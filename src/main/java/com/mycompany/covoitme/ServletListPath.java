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
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ServletListPath", urlPatterns = { "/listpath" })
public class ServletListPath extends HttpServlet {

  private static final Logger logger = Logger.getLogger(ServletListPath.class.getName());

  private String calculerDuree(Timestamp dateDepart, Timestamp dateArrivee) {
    long diffEnMillis = dateArrivee.getTime() - dateDepart.getTime();

    long diffEnMinutes = diffEnMillis / (1000 * 60);

    long jours = diffEnMinutes / (24 * 60);
    long heures = (diffEnMinutes % (24 * 60)) / 60;
    long minutes = diffEnMinutes % 60;

    StringBuilder duree = new StringBuilder();

    if (jours > 0) {
      duree.append(jours).append("j ");
    }

    if (heures > 0) {
      duree.append(heures).append("h ");
    }

    if (minutes > 0) {
      duree.append(minutes).append("min");
    }

    if (duree.length() == 0) {
      duree.append("0min");
    }

    return duree.toString().trim();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    String errorMessage = null;
    HttpSession session = request.getSession(false);

    List<Map<String, Object>> trajets = new ArrayList<>();

    String villedepart = request.getParameter("start");
    String villedestination = request.getParameter("destination");
    String dateParam = request.getParameter("date");
    String nbPassengersParam = request.getParameter("nbPassengers");

    Timestamp datedepart = null;
    if (dateParam != null && !dateParam.isEmpty()) {
      datedepart = Timestamp.valueOf(dateParam + " 00:00:00");
    }

    Integer nbPassengers = null;
    if (nbPassengersParam != null && !nbPassengersParam.isEmpty()) {
      nbPassengers = Integer.valueOf(nbPassengersParam);
    }

    Connection connection = null;
    try {
      connection = DatabaseConnection.getConnection();

      StringBuilder queryBuilder = new StringBuilder(
        "SELECT t.*, u.* FROM utilisateur u " +
        "JOIN trajet t on t.conducteur_id = u.id " +
        "WHERE t.conducteur_id != ?"
      );

      List<Object> parameters = new ArrayList<>();
      parameters.add(session.getAttribute("userId"));

      if (villedepart != null && !villedepart.isEmpty()) {
        queryBuilder.append(" AND t.villedepart = ?");
        parameters.add(villedepart);
      }
      if (villedestination != null && !villedestination.isEmpty()) {
        queryBuilder.append(" AND t.villedestination = ?");
        parameters.add(villedestination);
      }
      if (datedepart != null) {
        queryBuilder.append(" AND DATE(t.datedepart) = DATE(?)");
        parameters.add(datedepart);
      }
      if (nbPassengers != null) {
        queryBuilder.append(" AND t.nbplaceslibres >= ?");
        parameters.add(nbPassengers);
      }
      queryBuilder.append(" ORDER BY t.datedepart");

      PreparedStatement stmt = connection.prepareStatement(queryBuilder.toString());

      for (int i = 0; i < parameters.size(); i++) {
        stmt.setObject(i + 1, parameters.get(i));
      }

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
        if (resultSet.getBytes("profilePic") != null) {
          byte[] imageData = resultSet.getBytes("profilePic");
          String base64Image = Base64.getEncoder().encodeToString(imageData);
          trajet.put("conducteurprofilepic", "data:image/jpeg;base64," + base64Image);
        }

        trajet.put("duree", calculerDuree(dateDepart, dateArrivee));

        trajets.add(trajet);
      }

      request.setAttribute("trajets", trajets);
    } catch (SQLException | ClassNotFoundException e) {
      errorMessage = "Erreur de base de données: " + e.getMessage();
      logger.log(Level.SEVERE, errorMessage, e);
    } finally {
      DatabaseConnection.closeConnection(connection);
    }

    if (errorMessage != null) {
      request.setAttribute("errorMessage", errorMessage);
    }

    request.getRequestDispatcher("/listPath.jsp").forward(request, response);
  }

  @Override
  public String getServletInfo() {
    return "Returns the list of paths, with filters applied";
  }
}
