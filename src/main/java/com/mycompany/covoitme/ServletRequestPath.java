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
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.logging.Logger;

@WebServlet(name = "RequestPath", urlPatterns = { "/requestpath" })
public class ServletRequestPath extends HttpServlet {

  private static final Logger logger = Logger.getLogger(ServletRequestPath.class.getName());

  protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    request.getRequestDispatcher("/requestPath.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
    try {
      String villeDepart = request.getParameter("villeDepart");
      String villeDestination = request.getParameter("villeDestination");
      String adresseDepart = request.getParameter("adresseDepart");
      String adresseDestination = request.getParameter("adresseDestination");
      String dateStr = request.getParameter("date");
      String heureDepart = request.getParameter("heure");
      String heureArrivee = request.getParameter("comeback");
      String nbPlacesStr = request.getParameter("places");
      String commentaire = request.getParameter("commentaire");
      Float tarif = Float.parseFloat(request.getParameter("tarif"));

      int nbPlaces = 1;
      if (nbPlacesStr != null) {
        // Extraction du nombre depuis la chaîne "X passagers"
        nbPlaces = Integer.parseInt(nbPlacesStr.split(" ")[0]);
      }

      LocalDate date = LocalDate.parse(dateStr);
      LocalTime timeDepart = LocalTime.parse(heureDepart);
      LocalTime timeArrivee = LocalTime.parse(heureArrivee);

      LocalDateTime dateTimeDepart = LocalDateTime.of(date, timeDepart);
      LocalDateTime dateTimeArrivee = LocalDateTime.of(date, timeArrivee);

      if (timeArrivee.isBefore(timeDepart)) {
        dateTimeArrivee = LocalDateTime.of(date.plusDays(1), timeArrivee);
      }

      Timestamp timestampDepart = Timestamp.valueOf(dateTimeDepart);
      Timestamp timestampArrivee = Timestamp.valueOf(dateTimeArrivee);

      Connection conn = null;
      PreparedStatement pstmt = null;

      HttpSession session = request.getSession();
      Integer requesterId = (Integer) session.getAttribute("userId");

      if (requesterId == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
      }

      try {
        conn = DatabaseConnection.getConnection();
        String sql =
          "INSERT INTO RequeteTrajet (villeDepart, villeDestination, adresseDepart, adresseDestination, dateDepart, dateArrivee, nbPlacesLibres, commentaire, utilisateur_id, tarif) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, villeDepart);
        pstmt.setString(2, villeDestination);
        pstmt.setString(3, adresseDepart);
        pstmt.setString(4, adresseDestination);
        pstmt.setTimestamp(5, timestampDepart);
        pstmt.setTimestamp(6, timestampArrivee);
        pstmt.setInt(7, nbPlaces);
        pstmt.setString(8, commentaire);
        pstmt.setInt(9, requesterId);
        pstmt.setFloat(10, tarif);

        pstmt.executeUpdate();

        response.sendRedirect(request.getContextPath() + "/home?success=true&request=true");
      } catch (SQLException e) {
        logger.severe("Erreur lors de l'insertion de la demande de trajet: " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/requestpath?error=true");
      } finally {
        if (pstmt != null) {
          try {
            pstmt.close();
          } catch (SQLException e) {
            logger.severe("Erreur lors de la fermeture du PreparedStatement: " + e.getMessage());
          }
        }
        if (conn != null) {
          try {
            conn.close();
          } catch (SQLException e) {
            logger.severe("Erreur lors de la fermeture de la connexion: " + e.getMessage());
          }
        }
      }
    } catch (Exception e) {
      logger.severe(e.getMessage());
      response.sendRedirect(request.getContextPath() + "/requestpath?error=true");
    }
  }
}
