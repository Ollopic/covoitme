/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.covoitme;

import com.mycompany.covoitme.resources.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

/**
 *
 * @author liritt
 */
@WebServlet(name = "ServletMyPath", urlPatterns = { "/mypath" })
public class ServletListMyPath extends HttpServlet {

  /**
   * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
   * methods.
   *
   * @param request servlet request
   * @param response servlet response
   * @throws ServletException if a servlet-specific error occurs
   * @throws IOException if an I/O error occurs
   */
  protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    response.setContentType("text/html;charset=UTF-8");
    try (PrintWriter out = response.getWriter()) {
      /* TODO output your page here. You may use following sample code. */
      out.println("<!DOCTYPE html>");
      out.println("<html>");
      out.println("<head>");
      out.println("<title>Servlet ServletMyPath</title>");
      out.println("</head>");
      out.println("<body>");
      out.println("<h1>Servlet ServletMyPath at " + request.getContextPath() + "</h1>");
      out.println("</body>");
      out.println("</html>");
    }
  }

  /**
   * Handles the HTTP <code>GET</code> method.
   *
   * @param request servlet request
   * @param response servlet response
   * @throws ServletException if a servlet-specific error occurs
   * @throws IOException if an I/O error occurs
   */
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
      e.printStackTrace();
    } finally {
      DatabaseConnection.closeConnection(connection);
    }

    if (errorMessage != null) {
      request.setAttribute("errorMessage", errorMessage);
    }

    request.getRequestDispatcher("/myPath.jsp").forward(request, response);
  }

  /**
   * Handles the HTTP <code>POST</code> method.
   *
   * @param request servlet request
   * @param response servlet response
   * @throws ServletException if a servlet-specific error occurs
   * @throws IOException if an I/O error occurs
   */
  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    processRequest(request, response);
  }

  /**
   * Returns a short description of the servlet.
   *
   * @return a String containing servlet description
   */
  @Override
  public String getServletInfo() {
    return "Servlet qui charge les trajets réservés par l'utilisateur";
  }
}
