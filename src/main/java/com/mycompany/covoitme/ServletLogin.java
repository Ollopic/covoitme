package com.mycompany.covoitme;

import com.mycompany.covoitme.resources.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "Login", urlPatterns = { "/login" })
public class ServletLogin extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    request.getRequestDispatcher("/login.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    String email = request.getParameter("email");
    String motDePasse = request.getParameter("motDePasse");

    String errorMessage = null;

    if (email == null || email.trim().isEmpty() || motDePasse == null || motDePasse.trim().isEmpty()) {
      errorMessage = "Tous les champs sont obligatoires";
    } else {
      Connection connection = null;
      try {
        connection = DatabaseConnection.getConnection();
        String query = "SELECT id, prenom, nom, password, numTel, age FROM utilisateur WHERE email = ?";
        PreparedStatement stmt = connection.prepareStatement(query);
        stmt.setString(1, email);

        ResultSet resultSet = stmt.executeQuery();

        if (resultSet.next()) {
          String hashStocke = resultSet.getString("password");
          if (BCrypt.checkpw(motDePasse, hashStocke)) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedIn", true);
            session.setAttribute("userId", resultSet.getInt("id"));
            session.setAttribute("prenom", resultSet.getString("prenom"));
            session.setAttribute("nom", resultSet.getString("nom"));
            session.setAttribute("email", email);
            session.setAttribute("numTel", resultSet.getString("numTel"));
            session.setAttribute("age", resultSet.getInt("age"));

            String redirectURL = (String) session.getAttribute("redirectAfterLogin");
            if (redirectURL != null) {
              session.removeAttribute("redirectAfterLogin");
              response.sendRedirect(redirectURL);
            } else {
              response.sendRedirect(request.getContextPath() + "/home");
            }
          } else {
            errorMessage = "Email ou mot de passe incorrect";
          }
        } else {
          errorMessage = "Email ou mot de passe incorrect";
        }
      } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
      } finally {
        DatabaseConnection.closeConnection(connection);
      }
    }

    if (errorMessage != null) {
      request.setAttribute("email", email);
      request.setAttribute("errorMessage", errorMessage);
      request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
  }

  @Override
  public String getServletInfo() {
    return "Servlet gérant la connexion des utilisateurs";
  }
}
