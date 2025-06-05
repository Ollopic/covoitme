<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Créer un trajet</title>
    <script src="https://cdn.tailwindcss.com"></script>
  </head>
  <body class="bg-gray-100 font-sans">
  <%@ include file="navbar.jsp" %>

  <div class="max-w-3xl mx-auto mt-10 bg-white p-8 rounded shadow">
      <h1 class="text-2xl font-bold mb-6 text-center text-blue-600">Prendre en charge un trajet</h1>

        <% if (request.getParameter("error") != null && request.getParameter("error").equals("true")) { %>
          <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
            <strong class="font-bold">Erreur !</strong>
            <span class="block sm:inline"> Une erreur est survenue lors de la prise en charge du trajet. Veuillez réessayer.</span>
            <%= session.getAttribute("errorMessage") != null ? session.getAttribute("errorMessage") : "Une erreur est survenue lors de la prise en charge du trajet." %>
            <% session.removeAttribute("errorMessage"); %>
          </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/takerequest" method="POST" class="space-y-4">
          <input type="hidden" name="request_id" value="<%= request.getParameter("id") %>">

          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label for="car" class="block text-sm font-medium text-gray-700">Votre voiture</label>
              <input placeholder="Peugeot 3008 noir" type="text" id="car" name="car" required class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
            </div>
            <div>
              <label for="matriculation" class="block text-sm font-medium text-gray-700">Plaque d'immatriculation</label>
              <input type="text" id="matriculation" name="matriculation" required class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
            </div>
          </div>

          <div class="text-center">
            <button type="submit" class="bg-green-600 text-white px-6 py-2 rounded hover:bg-green-700">Prendre en charge la demande</button>
            <button type="button" onclick="window.location.href='listrequest'" class="bg-neutral-400 text-dark px-6 py-2 rounded hover:bg-neutral-500">Annuler la prise en charge</button>
          </div>
      </form>
    </div>
  </body>
</html>
