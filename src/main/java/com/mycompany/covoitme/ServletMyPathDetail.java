package com.mycompany.covoitme;

import com.mycompany.covoitme.resources.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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

@WebServlet(name = "MyPathDetail", urlPatterns = { "/mypathdetail" })
public class ServletMyPathDetail extends HttpServlet {

  protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    String trajetIdStr = request.getParameter("id");
    if (trajetIdStr == null || trajetIdStr.isEmpty()) {
      response.sendRedirect(request.getContextPath() + "/createdpath");
      return;
    }

    int trajetId;
    try {
      trajetId = Integer.parseInt(trajetIdStr);
    } catch (NumberFormatException e) {
      response.sendRedirect(request.getContextPath() + "/createdpath");
      return;
    }

    Connection connection = null;
    Map<String, Object> trajet = new HashMap<>();
    List<Map<String, Object>> passagers = new ArrayList<>();

    try {
      connection = DatabaseConnection.getConnection();

      Integer utilisateurId = (Integer) request.getSession().getAttribute("userId");
      String checkOwnerQuery = "SELECT COUNT(*) FROM trajet WHERE id = ? AND conducteur_id = ?";
      PreparedStatement checkOwnerStmt = connection.prepareStatement(checkOwnerQuery);
      checkOwnerStmt.setInt(1, trajetId);
      checkOwnerStmt.setInt(2, utilisateurId);
      ResultSet ownerResult = checkOwnerStmt.executeQuery();

      if (ownerResult.next() && ownerResult.getInt(1) == 0) {
        response.sendRedirect(request.getContextPath() + "/createdpath");
        return;
      }

      connection = DatabaseConnection.getConnection();
      String query = "SELECT * FROM trajet WHERE id = ?";
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
      }

      String queryPassagers =
        "SELECT u.id, u.nom, u.prenom, u.email, u.numtel " +
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
        passager.put("email", resultSetPassagers.getString("email"));
        passager.put("numtel", resultSetPassagers.getString("numtel"));
        passagers.add(passager);
      }

      request.setAttribute("trajet", trajet);
      request.setAttribute("passagers", passagers);
      request.getRequestDispatcher("/myPathDetail.jsp").forward(request, response);
    } catch (SQLException | ClassNotFoundException e) {
      e.printStackTrace();
      response.sendRedirect(request.getContextPath() + "/createdpath");
    } finally {
      DatabaseConnection.closeConnection(connection);
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    String action = request.getParameter("action");

    if ("delete".equals(action)) {
      String trajetIdStr = request.getParameter("trajet_id");

      try {
        int trajetId = Integer.parseInt(trajetIdStr);
        Connection connection = null;

        try {
          connection = DatabaseConnection.getConnection();

          Integer utilisateurId = (Integer) request.getSession().getAttribute("userId");
          String checkOwnerQuery = "SELECT COUNT(*) FROM trajet WHERE id = ? AND conducteur_id = ?";
          PreparedStatement checkOwnerStmt = connection.prepareStatement(checkOwnerQuery);
          checkOwnerStmt.setInt(1, trajetId);
          checkOwnerStmt.setInt(2, utilisateurId);
          ResultSet ownerResult = checkOwnerStmt.executeQuery();

          if (ownerResult.next() && ownerResult.getInt(1) == 0) {
            response.sendRedirect(request.getContextPath() + "/createdpath");
            return;
          }

          String deletePassagerQuery = "DELETE FROM passagertrajet WHERE trajet_id = ?";
          PreparedStatement stmtDeletePassager = connection.prepareStatement(deletePassagerQuery);
          stmtDeletePassager.setInt(1, trajetId);
          stmtDeletePassager.executeUpdate();

          String deleteTrajetQuery = "DELETE FROM trajet WHERE id = ?";
          PreparedStatement stmtDeleteTrajet = connection.prepareStatement(deleteTrajetQuery);
          stmtDeleteTrajet.setInt(1, trajetId);
          stmtDeleteTrajet.executeUpdate();

          response.sendRedirect(request.getContextPath() + "/createdpath");
          return;
        } catch (SQLException | ClassNotFoundException e) {
          e.printStackTrace();
          response.sendRedirect(request.getContextPath() + "/mypathdetail?id=" + trajetId);
        } finally {
          DatabaseConnection.closeConnection(connection);
        }
      } catch (NumberFormatException e) {
        response.sendRedirect(request.getContextPath() + "/createdpath");
      }
    }
  }
}
