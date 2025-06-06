package com.mycompany.covoitme;

import com.mycompany.covoitme.resources.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet(name = "TakeRequest", urlPatterns = { "/takerequest" })
public class ServletTakeRequest extends HttpServlet {

  protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    request.getRequestDispatcher("/takeRequest.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    String requestIdStr = request.getParameter("request_id");
    String car = request.getParameter("car");
    String immatriculation = request.getParameter("matriculation");

    try {
      int requestId = Integer.parseInt(requestIdStr);
      Connection connection = null;

      try {
        connection = DatabaseConnection.getConnection();

        Integer utilisateurId = (Integer) request.getSession().getAttribute("userId");

        String insertQuery =
          "INSERT INTO trajet (tarif, adressedepart, adressedestination, datedepart, datearrivee, nbplaceslibres, villedepart, villedestination, conducteur_id, vehicule, immatriculation) " +
          "SELECT tarif, adressedepart, adressedestination, datedepart, datearrivee, nbplaceslibres, villedepart, villedestination, ?, ?, ? FROM demandetrajet WHERE id = ? RETURNING id";

        PreparedStatement insertStmt = connection.prepareStatement(insertQuery);
        insertStmt.setInt(1, utilisateurId);
        insertStmt.setString(2, car);
        insertStmt.setString(3, immatriculation);
        insertStmt.setInt(4, requestId);
        ResultSet newTrajetId = insertStmt.executeQuery();

        if (newTrajetId.next()) {
          String updateQuery = "UPDATE demandetrajet SET trajet_id = ? WHERE id = ?";
          PreparedStatement updateStmt = connection.prepareStatement(updateQuery);
          updateStmt.setInt(1, newTrajetId.getInt("id"));
          updateStmt.setInt(2, requestId);
          updateStmt.executeUpdate();

          String addPassengersQuery =
            "INSERT INTO passagertrajet (utilisateur_id, trajet_id, nbplacesreservees) SELECT utilisateur_id, ?, nbplaceslibres FROM demandetrajet WHERE id = ?";
          PreparedStatement addPassengersStmt = connection.prepareStatement(addPassengersQuery);
          addPassengersStmt.setInt(1, newTrajetId.getInt("id"));
          addPassengersStmt.setInt(2, requestId);
          addPassengersStmt.executeUpdate();
        }

        response.sendRedirect(request.getContextPath() + "/createdpath");
        return;
      } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        response.sendRedirect(request.getContextPath() + "/listrequest");
      } finally {
        DatabaseConnection.closeConnection(connection);
      }
    } catch (NumberFormatException e) {
      response.sendRedirect(request.getContextPath() + "/listrequest");
    }
  }
}
