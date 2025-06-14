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
import java.util.logging.Logger;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "Register", urlPatterns = { "/register" })
public class ServletRegister extends HttpServlet {

  private static final Logger logger = Logger.getLogger(ServletRegister.class.getName());

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    request.getRequestDispatcher("/login.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    String prenom = request.getParameter("prenom");
    String nom = request.getParameter("nom");
    String email = request.getParameter("email");
    String telephone = request.getParameter("telephone");
    int age = Integer.parseInt(request.getParameter("age"));
    String motDePasse = request.getParameter("motDePasse");
    String confirmMotDePasse = request.getParameter("confirmMotDePasse");

    String errorMessage = null;

    if (
      prenom == null ||
      prenom.trim().isEmpty() ||
      nom == null ||
      nom.trim().isEmpty() ||
      email == null ||
      email.trim().isEmpty() ||
      telephone == null ||
      telephone.trim().isEmpty() ||
      motDePasse == null ||
      motDePasse.trim().isEmpty() ||
      confirmMotDePasse == null ||
      confirmMotDePasse.trim().isEmpty()
    ) {
      errorMessage = "Tous les champs sont obligatoires";
    } else if (age < 18) {
      errorMessage = "Vous devez avoir au moins 18 ans pour vous inscrire";
    } else if (!motDePasse.equals(confirmMotDePasse)) {
      errorMessage = "Les mots de passe ne correspondent pas";
    } else if (!telephone.matches("0[1-9][0-9]{8}")) {
      errorMessage = "Le numéro de téléphone doit être au format français (10 chiffres commençant par 0)";
    } else {
      Connection connection = null;
      try {
        connection = DatabaseConnection.getConnection();
        String checkEmailQuery = "SELECT COUNT(*) FROM utilisateur WHERE email = ?";
        PreparedStatement checkEmailStmt = connection.prepareStatement(checkEmailQuery);
        checkEmailStmt.setString(1, email);
        ResultSet resultSet = checkEmailStmt.executeQuery();

        if (resultSet.next() && resultSet.getInt(1) > 0) {
          errorMessage = "Cette adresse email est déjà utilisée";
        } else {
          String insertQuery =
            "INSERT INTO utilisateur (nom, prenom, email, numTel, age, password) VALUES (?, ?, ?, ?, ?, ?)";
          PreparedStatement insertStmt = connection.prepareStatement(
            insertQuery,
            PreparedStatement.RETURN_GENERATED_KEYS
          );
          insertStmt.setString(1, nom);
          insertStmt.setString(2, prenom);
          insertStmt.setString(3, email);
          insertStmt.setString(4, telephone);
          insertStmt.setInt(5, age);
          insertStmt.setString(6, BCrypt.hashpw(motDePasse, BCrypt.gensalt()));

          int rowsInserted = insertStmt.executeUpdate();

          if (rowsInserted > 0) {
            ResultSet generatedKeys = insertStmt.getGeneratedKeys();
            int userId = -1;
            if (generatedKeys.next()) {
              userId = generatedKeys.getInt(1);
            }

            HttpSession session = request.getSession();
            session.setAttribute("loggedIn", true);
            session.setAttribute("userId", userId);
            session.setAttribute("prenom", prenom);
            session.setAttribute("nom", nom);
            session.setAttribute("email", email);
            session.setAttribute("numTel", telephone);
            session.setAttribute("age", age);

            response.sendRedirect(request.getContextPath() + "/home");
            return;
          } else {
            errorMessage = "Erreur lors de l'inscription. Veuillez réessayer.";
          }
        }
      } catch (SQLException | ClassNotFoundException e) {
        errorMessage = "Erreur de base de données: " + e.getMessage();
        logger.severe(errorMessage);
      } finally {
        DatabaseConnection.closeConnection(connection);
      }
    }

    if (errorMessage != null) {
      request.setAttribute("errorMessage", errorMessage);
      request.setAttribute("prenom", prenom);
      request.setAttribute("nom", nom);
      request.setAttribute("email", email);
      request.setAttribute("telephone", telephone);
      request.setAttribute("age", age);
      request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
  }

  @Override
  public String getServletInfo() {
    return "Servlet gérant l'inscription des utilisateurs";
  }
}
