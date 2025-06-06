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

@WebServlet(name = "ServletPassengerRequests", urlPatterns = { "/passenger-requests" })
public class ServletPassengerRequests extends HttpServlet {

  private static final Logger logger = Logger.getLogger(ServletPassengerRequests.class.getName());

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
      String query = "SELECT rt.* FROM demandetrajet rt WHERE rt.utilisateur_id = ?";
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
        trajet.put("nbplaceslibres", resultSet.getInt("nbplaceslibres"));
        trajet.put("villedepart", resultSet.getString("villedepart"));
        trajet.put("villedestination", resultSet.getString("villedestination"));
        trajet.put("tarifs", resultSet.getString("tarif"));

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
      logger.log(Level.SEVERE, errorMessage, e);
    } finally {
      DatabaseConnection.closeConnection(connection);
    }

    if (errorMessage != null) {
      request.setAttribute("errorMessage", errorMessage);
    }

    request.getRequestDispatcher("/passengerRequests.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    String action = request.getParameter("action");

    if ("delete".equals(action)) {
      String requestIdStr = request.getParameter("trajet_id");

      try {
        int requestId = Integer.parseInt(requestIdStr);
        Connection connection = null;

        try {
          connection = DatabaseConnection.getConnection();

          String checkOwnerQuery = "SELECT COUNT(*) FROM demandetrajet WHERE id = ?";
          PreparedStatement checkOwnerStmt = connection.prepareStatement(checkOwnerQuery);
          checkOwnerStmt.setInt(1, requestId);
          ResultSet ownerResult = checkOwnerStmt.executeQuery();

          if (ownerResult.next() && ownerResult.getInt(1) == 0) {
            response.sendRedirect(request.getContextPath() + "/passenger-requests");
            return;
          }

          String deleteTrajetQuery = "DELETE FROM demandetrajet WHERE id = ?";
          PreparedStatement stmtDeleteTrajet = connection.prepareStatement(deleteTrajetQuery);
          stmtDeleteTrajet.setInt(1, requestId);
          stmtDeleteTrajet.executeUpdate();

          response.sendRedirect(request.getContextPath() + "/passenger-requests");
          return;
        } catch (SQLException | ClassNotFoundException e) {
          e.printStackTrace();
          response.sendRedirect(request.getContextPath() + "/passenger-requests");
        } finally {
          DatabaseConnection.closeConnection(connection);
        }
      } catch (NumberFormatException e) {
        response.sendRedirect(request.getContextPath() + "/passenger-requests");
      }
    }
  }

  @Override
  public String getServletInfo() {
    return "Get the list of requested paths";
  }
}
