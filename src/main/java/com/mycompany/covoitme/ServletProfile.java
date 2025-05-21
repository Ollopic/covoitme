package com.mycompany.covoitme;

import com.mycompany.covoitme.resources.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "Profile", urlPatterns = { "/profile" })
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class ServletProfile extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    HttpSession session = request.getSession(false);

    String prenom = (String) session.getAttribute("prenom");
    String nom = (String) session.getAttribute("nom");
    String email = (String) session.getAttribute("email");
    String numTel = (String) session.getAttribute("numTel");
    int age = (int) session.getAttribute("age");

    request.setAttribute("prenom", prenom);
    request.setAttribute("nom", nom);
    request.setAttribute("email", email);
    request.setAttribute("numTel", numTel);
    request.setAttribute("age", age);

    request.getRequestDispatcher("/profile.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    HttpSession session = request.getSession(false);

    int userId = (int) session.getAttribute("userId");

    String prenom = request.getParameter("prenom");
    String nom = request.getParameter("nom");
    String email = request.getParameter("email");
    String numTel = request.getParameter("numTel");
    int age = Integer.parseInt(request.getParameter("age"));

    Part filePart = request.getPart("profileImage");
    InputStream imageInputStream = null;
    boolean imageProvided = false;

    if (filePart != null && filePart.getSize() > 0) {
      imageInputStream = filePart.getInputStream();
      imageProvided = true;
    }

    String sql = imageProvided
      ? "UPDATE Utilisateur SET prenom = ?, nom = ?, email = ?, numTel = ?, age = ?, profilePic = ? WHERE id = ?"
      : "UPDATE Utilisateur SET prenom = ?, nom = ?, email = ?, numTel = ?, age = ? WHERE id = ?";

    try (
      Connection conn = DatabaseConnection.getConnection();
      PreparedStatement stmt = conn.prepareStatement(sql)
    ) {
      stmt.setString(1, prenom);
      stmt.setString(2, nom);
      stmt.setString(3, email);
      stmt.setString(4, numTel);
      stmt.setInt(5, age);

      if (imageProvided) {
        stmt.setBinaryStream(6, imageInputStream);
        stmt.setInt(7, userId);
      } else {
        stmt.setInt(6, userId);
      }

      stmt.executeUpdate();

      session.setAttribute("prenom", prenom);
      session.setAttribute("nom", nom);
      session.setAttribute("email", email);
      session.setAttribute("numTel", numTel);
      session.setAttribute("age", age);
      session.setAttribute("profileImage", null);

      response.sendRedirect(request.getContextPath() + "/profile");
    } catch (SQLException | ClassNotFoundException e) {
      throw new ServletException("Erreur lors de la mise à jour du profil", e);
    }
  }
}
