package com.mycompany.covoitme;

import com.mycompany.covoitme.resources.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "Login", urlPatterns = {"/login"})
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

        if (email == null || email.trim().isEmpty() ||
            motDePasse == null || motDePasse.trim().isEmpty()) {

            errorMessage = "Tous les champs sont obligatoires";
        } else {
            Connection connection = null;
            try {
                connection = DatabaseConnection.getConnection();
                String query = "SELECT prenom FROM utilisateur WHERE email = ? AND password = ?";
                PreparedStatement stmt = connection.prepareStatement(query);
                stmt.setString(1, email);
                stmt.setString(2, motDePasse);

                ResultSet resultSet = stmt.executeQuery();

                if (resultSet.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("loggedIn", true);
                    session.setAttribute("email", email);
                    session.setAttribute("prenom", resultSet.getString("prenom"));

                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                } else {
                    errorMessage = "Email ou mot de passe incorrect";
                }
            } catch (SQLException | ClassNotFoundException e) {
                errorMessage = "Erreur de base de données: " + e.getMessage();
                e.printStackTrace();
            } finally {
                DatabaseConnection.closeConnection(connection);
            }
        }

        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet gérant la connexion des utilisateurs";
    }
}