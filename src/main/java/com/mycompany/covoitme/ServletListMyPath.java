package com.mycompany.covoitme;

import com.mycompany.covoitme.resources.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ServletMyPath", urlPatterns = { "/mypath" })
public class ServletListMyPath extends HttpServlet {

  private static final Logger logger = Logger.getLogger(ServletListMyPath.class.getName());

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    String errorMessage = null;
    HttpSession session = request.getSession(false);

    List<Map<String, Object>> trajets = new ArrayList<>();
    List<Map<String, Object>> trajetsExpired = new ArrayList<>();

    Connection connection = null;
    try {
      connection = DatabaseConnection.getConnection();
      String query =
        "SELECT distinct t.*, u.* " +
        "FROM utilisateur u " +
        "JOIN passagertrajet pt on pt.utilisateur_id = u.id " +
        "JOIN trajet t on t.id = pt.trajet_id " +
        "WHERE u.id = ?";
      PreparedStatement stmt = connection.prepareStatement(query);
      stmt.setInt(1, (int) session.getAttribute("userId"));

      ResultSet resultSet = stmt.executeQuery();

      SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE d MMMM yyyy", Locale.FRENCH);
      SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");

      while (resultSet.next()) {
        Map<String, Object> trajet = new HashMap<>();

        Timestamp dateDepart = Timestamp.valueOf(resultSet.getString("datedepart"));
        Timestamp dateArrivee = Timestamp.valueOf(resultSet.getString("datearrivee"));

        trajet.put("id", resultSet.getInt("id"));
        trajet.put("adressedepart", resultSet.getString("adressedepart"));
        trajet.put("adressedestination", resultSet.getString("adressedestination"));
        trajet.put("commentaire", resultSet.getString("commentaire"));
        trajet.put("datearrivee", dateFormat.format(dateArrivee));
        trajet.put("datedepart", dateFormat.format(dateDepart));
        trajet.put("heurearrivee", timeFormat.format(dateArrivee));
        trajet.put("heuredepart", timeFormat.format(dateDepart));
        trajet.put("immatriculation", resultSet.getString("immatriculation"));
        trajet.put("nbplaceslibres", resultSet.getInt("nbplaceslibres"));
        trajet.put("tarif", resultSet.getBigDecimal("tarif"));
        trajet.put("vehicule", resultSet.getString("vehicule"));
        trajet.put("villedepart", resultSet.getString("villedepart"));
        trajet.put("villedestination", resultSet.getString("villedestination"));
        trajet.put("conducteur", resultSet.getString("nom") + " " + resultSet.getString("prenom"));

        if (dateArrivee.before(new Date())) {
          trajetsExpired.add(trajet);
        } else {
          trajets.add(trajet);
        }
      }

      request.setAttribute("trajets", trajets);
      request.setAttribute("trajetsExpired", trajetsExpired);
    } catch (SQLException | ClassNotFoundException e) {
      errorMessage = "Erreur de base de données: " + e.getMessage();
      logger.info(errorMessage);
    } finally {
      DatabaseConnection.closeConnection(connection);
    }

    if (errorMessage != null) {
      request.setAttribute("errorMessage", errorMessage);
    }

    request.getRequestDispatcher("/myPath.jsp").forward(request, response);
  }

  @Override
  public String getServletInfo() {
    return "Servlet qui charge les trajets réservés par l'utilisateur";
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
    String action = request.getParameter("action");

    if ("delete".equals(action)) {
      String trajetIdStr = request.getParameter("trajet_id");
      if (trajetIdStr != null && !trajetIdStr.isEmpty()) {
        int trajetId = Integer.parseInt(trajetIdStr);
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId != null) {
          Connection connection = null;
          try {
            connection = DatabaseConnection.getConnection();

            String getReservationQuery =
              "SELECT nbPlacesReservees FROM passagertrajet WHERE trajet_id = ? AND utilisateur_id = ?";
            PreparedStatement getStmt = connection.prepareStatement(getReservationQuery);
            getStmt.setInt(1, trajetId);
            getStmt.setInt(2, userId);
            ResultSet rs = getStmt.executeQuery();

            int nbPlaces = 1;
            if (rs.next()) {
              nbPlaces = rs.getInt("nbPlacesReservees");
            }

            String deleteQuery = "DELETE FROM passagertrajet WHERE trajet_id = ? AND utilisateur_id = ?";
            PreparedStatement deleteStmt = connection.prepareStatement(deleteQuery);
            deleteStmt.setInt(1, trajetId);
            deleteStmt.setInt(2, userId);
            int rowsAffected = deleteStmt.executeUpdate();

            if (rowsAffected > 0) {
              String updateQuery = "UPDATE trajet SET nbplaceslibres = nbplaceslibres + ? WHERE id = ?";
              PreparedStatement updateStmt = connection.prepareStatement(updateQuery);
              updateStmt.setInt(1, nbPlaces);
              updateStmt.setInt(2, trajetId);
              updateStmt.executeUpdate();
            }
          } catch (SQLException | ClassNotFoundException e) {
            logger.log(Level.SEVERE, e.getMessage(), e);
          } finally {
            DatabaseConnection.closeConnection(connection);
          }
        }
      }
    }

    response.sendRedirect(request.getContextPath() + "/mypath");
  }
}
