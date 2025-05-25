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
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

@WebServlet(name = "PathDetail", urlPatterns = { "/pathdetail" })
public class ServletPathDetail extends HttpServlet {

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

      request.setAttribute("trajet", trajet);
      request.setAttribute("conducteur", conducteur);
      request.getRequestDispatcher("/pathDetail.jsp").forward(request, response);
    } catch (SQLException | ClassNotFoundException e) {
      e.printStackTrace();
      response.sendRedirect(request.getContextPath() + "/createdpath");
    } finally {
      DatabaseConnection.closeConnection(connection);
    }
  }
}
