package com.mycompany.covoitme.resources;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;

@WebFilter(urlPatterns = { "/*" })
public class ProfileImageFilter implements Filter {

  @Override
  public void init(FilterConfig filterConfig) throws ServletException {}

  @Override
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
    throws IOException, ServletException {
    HttpServletRequest httpRequest = (HttpServletRequest) request;
    HttpSession session = httpRequest.getSession(false);

    if (
      session != null &&
      session.getAttribute("loggedIn") != null &&
      (boolean) session.getAttribute("loggedIn") &&
      session.getAttribute("profileImage") == null
    ) {
      try (
        Connection conn = DatabaseConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement("SELECT profilePic FROM Utilisateur WHERE id = ?")
      ) {
        stmt.setInt(1, (int) session.getAttribute("userId"));

        try (ResultSet rs = stmt.executeQuery()) {
          if (rs.next() && rs.getBytes("profilePic") != null) {
            byte[] imageData = rs.getBytes("profilePic");
            String base64Image = Base64.getEncoder().encodeToString(imageData);
            session.setAttribute("profileImage", "data:image/jpeg;base64," + base64Image);
          }
        }
      } catch (SQLException | ClassNotFoundException e) {
        System.err.println("Erreur lors de la récupération de l'image de profil: " + e.getMessage());
      }
    }

    chain.doFilter(request, response);
  }
}
