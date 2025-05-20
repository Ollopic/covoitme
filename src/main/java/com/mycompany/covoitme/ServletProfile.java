package com.mycompany.covoitme;

import java.io.IOException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.ServletException;

@WebServlet(name = "Profile", urlPatterns = {"/profile"})
public class ServletProfile extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("loggedIn") != null && (boolean) session.getAttribute("loggedIn")) {
            String prenom = (String) session.getAttribute("prenom");
            String nom = (String) session.getAttribute("nom");
            String email = (String) session.getAttribute("email");
            String numTel = (String) session.getAttribute("numTel");
            int age = (int) session.getAttribute("age");

            request.setAttribute("prenom", prenom);
            request.setAttribute("nom", nom);
            request.setAttribute("email", email);
            request.setAttribute("numTel", numTel);
            request.setAttribute("age", age);

            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}