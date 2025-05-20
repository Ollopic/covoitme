<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Profil | Covoitme</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">

  <%@ include file="navbar.jsp" %>

  <div class="max-w-md mx-auto mt-10 bg-white rounded-2xl shadow-lg p-6">
    <h1 class="text-2xl font-bold text-center text-blue-600 mb-6">Profil utilisateur</h1>

    <div class="space-y-4">
      <div>
        <label class="block text-gray-600 text-lg font-semibold">Prénom :</label>
        <p class="text-gray-800 text-lg"><%= request.getAttribute("prenom") %></p>
      </div>

      <div>
        <label class="block text-gray-600 text-lg font-semibold">Nom :</label>
        <p class="text-gray-800 text-lg"><%= request.getAttribute("nom") %></p>
      </div>

      <div>
        <label class="block text-gray-600 text-lg font-semibold">Email :</label>
        <p class="text-gray-800 text-lg"><%= request.getAttribute("email") %></p>
      </div>

      <div>
        <label class="block text-gray-600 text-lg font-semibold">Numéro de téléphone :</label>
        <p class="text-gray-800 text-lg"><%= request.getAttribute("numTel") %></p>
      </div>

      <div>
        <label class="block text-gray-600 text-lg font-semibold">Âge :</label>
        <p class="text-gray-800 text-lg"><%= request.getAttribute("age") %></p>
      </div>
    </div>
  </div>

</body>
</html>
