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
      <h1 class="text-2xl font-bold mb-6 text-center text-blue-600">Publier une demande de trajet</h1>

        <% if (request.getParameter("error") != null && request.getParameter("error").equals("true")) { %>
          <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
            <strong class="font-bold">Erreur !</strong>
            <span class="block sm:inline"> Une erreur est survenue lors de la création du trajet. Veuillez réessayer.</span>
            <%= session.getAttribute("errorMessage") != null ? session.getAttribute("errorMessage") : "Une erreur est survenue lors de la création du trajet." %>
            <% session.removeAttribute("errorMessage"); %>
          </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/requestpath" method="POST" class="space-y-4">
        <div>
          <label for="villeDepart" class="block text-sm font-medium text-gray-700">Ville de départ</label>
          <input type="text" placeholder="Reims..." id="villeDepart" name="villeDepart" required class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
        </div>

        <div>
          <label for="villeDestination" class="block text-sm font-medium text-gray-700">Ville d'arrivée</label>
          <input type="text" id="villeDestination" placeholder="Paris..." name="villeDestination" required class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label for="adresseDepart" class="block text-sm font-medium text-gray-700">Adresse exacte du rendez-vous</label>
            <input placeholder="2 Av. Robert Schuman..." type="text" id="adresseDepart" name="adresseDepart" required class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
          </div>
          <div>
            <label for="adresseDestination" class="block text-sm font-medium text-gray-700">Adresse exacte de l'arrivée</label>
            <input placeholder="24 Rue du Commandant Guilbaud..." type="text" id="adresseDestination" name="adresseDestination" required class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
          </div>
        </div>

        <div>
          <label for="datePicker" class="block text-sm font-medium text-gray-700">Date du départ</label>
          <input type="date" id="datePicker" name="date" required class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label for="heure" class="block text-sm font-medium text-gray-700">Heure du départ</label>
            <input type="time" id="heure" name="heure" required class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
          </div>
          <div>
            <label for="comeback" class="block text-sm font-medium text-gray-700">Heure de l'arrivée</label>
            <input type="time" id="comeback" name="comeback" required class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
          </div>
        </div>

        <div>
          <label for="places" class="block text-sm font-medium text-gray-700">Nombre de places requises</label>
          <select id="places" name="places" class="col-span-1 md:col-span-1 border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
            <option>1 passager</option>
            <option>2 passagers</option>
            <option>3 passagers</option>
            <option>4 passagers</option>
          </select>
        </div>

        <div>
          <label for="commentaire" class="block text-sm font-medium text-gray-700">Commentaire (optionnel)</label>
          <textarea id="commentaire" name="commentaire" rows="3" class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Ex : bagages acceptés, animaux interdits..."></textarea>
        </div>

        <div class="text-center">
          <button type="submit" class="bg-green-600 text-white px-6 py-2 rounded hover:bg-green-700">Publier la demande de trajet</button>
          <button type="button" onclick="window.location.href='home'" class="bg-neutral-400 text-dark px-6 py-2 rounded hover:bg-neutral-500">Annuler la demande de trajet</button>
        </div>
      </form>

      <script>
        function toDateInputValue(dateObject){
          const local = new Date(dateObject);
          local.setMinutes(dateObject.getMinutes() - dateObject.getTimezoneOffset());
          return local.toJSON().slice(0,10);
        }

        document.getElementById('datePicker').value = toDateInputValue(new Date());
      </script>
    </div>
  </body>
</html>
