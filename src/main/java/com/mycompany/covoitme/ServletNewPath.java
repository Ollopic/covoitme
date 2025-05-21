package com.mycompany.covoitme;
import com.mycompany.covoitme.resources.DatabaseConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.ServletException;


@WebServlet(name = "NewHome", urlPatterns = {"/newpath"})
public class ServletNewPath extends HttpServlet {

  protected void doGet(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
      request.getRequestDispatcher("/newPath.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
      try {
          String villeDepart = request.getParameter("villeDepart");
          String villeDestination = request.getParameter("villeDestination");
          String adresseDepart = request.getParameter("adresseDepart");
          String adresseDestination = request.getParameter("adresseDestination");
          String dateStr = request.getParameter("date");
          String heureDepart = request.getParameter("heure");
          String heureArrivee = request.getParameter("comeback");
          String vehicule = request.getParameter("car");
          String immatriculation = request.getParameter("matriculation");
          String nbPlacesStr = request.getParameter("places");
          Float tarif = Float.parseFloat(request.getParameter("tarif"));
          String commentaire = request.getParameter("commentaire");

          int nbPlaces = 1; // Valeur par défaut
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

          HttpSession session = request.getSession();
          Integer conducteurId = (Integer) session.getAttribute("userId");

          if (conducteurId == null) {
              response.sendRedirect(request.getContextPath() + "/login");
              return;
          }

          Connection conn = null;
          PreparedStatement pstmt = null;

          try {
              conn = DatabaseConnection.getConnection();
              String sql = "INSERT INTO Trajet (villeDepart, villeDestination, adresseDepart, adresseDestination, dateDepart, dateArrivee, vehicule, immatriculation, nbPlacesLibres, conducteur_id, tarif, commentaire) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

              pstmt = conn.prepareStatement(sql);
              pstmt.setString(1, villeDepart);
              pstmt.setString(2, villeDestination);
              pstmt.setString(3, adresseDepart);
              pstmt.setString(4, adresseDestination);
              pstmt.setTimestamp(5, timestampDepart);
              pstmt.setTimestamp(6, timestampArrivee);
              pstmt.setString(7, vehicule);
              pstmt.setString(8, immatriculation);
              pstmt.setInt(9, nbPlaces);
              pstmt.setInt(10, conducteurId);
              pstmt.setFloat(11, tarif);
              pstmt.setString(12, commentaire);

              pstmt.executeUpdate();

              response.sendRedirect(request.getContextPath() + "/home?success=true");

          } catch (SQLException e) {
              e.printStackTrace();
              response.sendRedirect(request.getContextPath() + "/newpath?error=true");
          } finally {
              if (pstmt != null) {
                  try {
                      pstmt.close();
                  } catch (SQLException e) {
                      e.printStackTrace();
                  }
              }
              if (conn != null) {
                  try {
                      conn.close();
                  } catch (SQLException e) {
                      e.printStackTrace();
                  }
              }
          }

      } catch (Exception e) {
          e.printStackTrace();
          response.sendRedirect(request.getContextPath() + "/newpath?error=true");
      }
    }
}
