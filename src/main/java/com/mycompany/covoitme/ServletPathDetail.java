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
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet(name = "PathDetail", urlPatterns = { "/pathdetail" })
public class ServletPathDetail extends HttpServlet {

  private static final Logger logger = Logger.getLogger(ServletPathDetail.class.getName());

  protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    String trajetIdStr = request.getParameter("id");
    if (trajetIdStr == null || trajetIdStr.isEmpty()) {
      response.sendRedirect(request.getContextPath() + "/listpath");
      return;
    }

    int trajetId;
    try {
      trajetId = Integer.parseInt(trajetIdStr);
    } catch (NumberFormatException e) {
      response.sendRedirect(request.getContextPath() + "/listpath");
      return;
    }

    Connection connection = null;
    Map<String, Object> trajet = new HashMap<>();
    Map<String, Object> conducteur = new HashMap<>();

    try {
      connection = DatabaseConnection.getConnection();
      String query =
        "SELECT t.*, u.id as conducteur_id, u.nom, u.prenom, u.email, u.numtel " +
        "FROM trajet t " +
        "JOIN utilisateur u ON t.conducteur_id = u.id " +
        "WHERE t.id = ?";
      PreparedStatement stmt = connection.prepareStatement(query);
      stmt.setInt(1, trajetId);

      ResultSet resultSet = stmt.executeQuery();

      SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE d MMMM", Locale.FRENCH);
      SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");

      if (resultSet.next()) {
        Timestamp dateDepart = resultSet.getTimestamp("datedepart");
        Timestamp dateArrivee = resultSet.getTimestamp("datearrivee");

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

        conducteur.put("id", resultSet.getInt("conducteur_id"));
        conducteur.put("nom", resultSet.getString("nom"));
        conducteur.put("prenom", resultSet.getString("prenom"));
        conducteur.put("email", resultSet.getString("email"));
        conducteur.put("numtel", resultSet.getString("numtel"));
      }

      List<Map<String, Object>> passagers = new ArrayList<>();
      String queryPassagers =
        "SELECT u.id, u.nom, u.prenom " +
        "FROM passagertrajet pt " +
        "JOIN utilisateur u ON pt.utilisateur_id = u.id " +
        "WHERE pt.trajet_id = ?";

      PreparedStatement stmtPassagers = connection.prepareStatement(queryPassagers);
      stmtPassagers.setInt(1, trajetId);
      ResultSet resultSetPassagers = stmtPassagers.executeQuery();

      while (resultSetPassagers.next()) {
        Map<String, Object> passager = new HashMap<>();
        passager.put("id", resultSetPassagers.getInt("id"));
        passager.put("nom", resultSetPassagers.getString("nom"));
        passager.put("prenom", resultSetPassagers.getString("prenom"));
        passagers.add(passager);
      }

      HttpSession session = request.getSession();
      Integer userId = (Integer) session.getAttribute("userId");
      boolean dejaReserve = false;

      if (userId != null) {
        String queryDejaReserve =
          "SELECT COUNT(*) FROM passagertrajet WHERE utilisateur_id = ? AND trajet_id = ?";
        PreparedStatement stmtDejaReserve = connection.prepareStatement(queryDejaReserve);
        stmtDejaReserve.setInt(1, userId);
        stmtDejaReserve.setInt(2, trajetId);
        ResultSet resultDejaReserve = stmtDejaReserve.executeQuery();

        if (resultDejaReserve.next() && resultDejaReserve.getInt(1) > 0) {
          dejaReserve = true;
        }
      }

      request.setAttribute("dejaReserve", dejaReserve);
      request.setAttribute("passagers", passagers);
      request.setAttribute("trajet", trajet);
      request.setAttribute("conducteur", conducteur);
      request.getRequestDispatcher("/pathDetail.jsp").forward(request, response);
    } catch (SQLException | ClassNotFoundException e) {
      logger.severe("Erreur de la base de données: " + e.getMessage());
      response.sendRedirect(request.getContextPath() + "/createdpath");
    } finally {
      DatabaseConnection.closeConnection(connection);
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    String action = request.getParameter("action");

    if ("reserve".equals(action)) {
      String trajetIdStr = request.getParameter("trajet_id");
      String nbPassagersStr = request.getParameter("nbPassagers");

      if (trajetIdStr == null || trajetIdStr.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/listpath");
        return;
      }

      int trajetId;
      trajetId = Integer.parseInt(trajetIdStr);

      int nbPassagers = 1;
      if (nbPassagersStr != null && !nbPassagersStr.isEmpty()) {
        nbPassagers = Integer.parseInt(nbPassagersStr);
      }

      HttpSession session = request.getSession();
      Integer userId = (Integer) session.getAttribute("userId");

      Connection connection = null;
      try {
        connection = DatabaseConnection.getConnection();

        String checkQuery = "SELECT COUNT(*) FROM passagertrajet WHERE utilisateur_id = ? AND trajet_id = ?";
        PreparedStatement checkStmt = connection.prepareStatement(checkQuery);
        checkStmt.setInt(1, userId);
        checkStmt.setInt(2, trajetId);
        ResultSet checkResult = checkStmt.executeQuery();

        if (checkResult.next() && checkResult.getInt(1) > 0) {
          response.sendRedirect(request.getContextPath() + "/pathdetail?id=" + trajetId);
          return;
        }

        String placeQuery = "SELECT nbplaceslibres FROM trajet WHERE id = ?";
        PreparedStatement placeStmt = connection.prepareStatement(placeQuery);
        placeStmt.setInt(1, trajetId);
        ResultSet placeResult = placeStmt.executeQuery();

        if (placeResult.next() && placeResult.getInt("nbplaceslibres") >= nbPassagers) {
          String insertQuery =
            "INSERT INTO passagertrajet (utilisateur_id, trajet_id, nbPlacesReservees) VALUES (?, ?, ?)";
          PreparedStatement insertStmt = connection.prepareStatement(insertQuery);
          insertStmt.setInt(1, userId);
          insertStmt.setInt(2, trajetId);
          insertStmt.setInt(3, nbPassagers);
          insertStmt.executeUpdate();

          String updateQuery = "UPDATE trajet SET nbplaceslibres = nbplaceslibres - ? WHERE id = ?";
          PreparedStatement updateStmt = connection.prepareStatement(updateQuery);
          updateStmt.setInt(1, nbPassagers);
          updateStmt.setInt(2, trajetId);
          updateStmt.executeUpdate();

          response.sendRedirect(request.getContextPath() + "/pathdetail?id=" + trajetId);
        } else {
          response.sendRedirect(request.getContextPath() + "/pathdetail?id=" + trajetId);
        }
      } catch (SQLException | ClassNotFoundException e) {
        logger.severe("Erreur de la base de données: " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/pathdetail?id=" + trajetId);
      } finally {
        DatabaseConnection.closeConnection(connection);
      }
    } else {
      response.sendRedirect(request.getContextPath() + "/listpath");
    }
  }
}
