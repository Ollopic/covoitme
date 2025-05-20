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
    <header class="bg-white shadow">
      <div class="container mx-auto px-4 py-4 flex justify-between items-center">
        <a href="home.html" class="text-2xl font-bold text-blue-600">Covoitme</a>
        <nav class="space-x-6 hidden md:flex">
          <a href="home.html" class="text-gray-700 hover:text-blue-600">Accueil</a>
          <a href="newPath.html" class="text-gray-700 hover:text-blue-600">Publier un trajet</a>
          <a href="myPath.html" class="text-gray-700 hover:text-blue-600">Mes réservations</a>
          <a href="createdPath.html" class="text-gray-700 hover:text-blue-600">Mes trajets</a>
        </nav>
        <div class="flex items-center gap-4">
            <a href="profile" class="flex bg-white rounded-full focus:ring-2 focus:ring-gray-300" id="user-menu-button" aria-expanded="false" data-dropdown-placement="bottom">
                <img class="w-12 h-12 rounded-full" src="https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg" alt="user photo">
            </a>
            <a href="#"
                class="text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center mr-3 md:mr-0">
                Se déconnecter
            </a>
        </div>
      </div>
    </header>

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
