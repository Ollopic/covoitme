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
    <div class="max-w-3xl mx-auto mt-10 bg-white p-8 rounded shadow">
      <h1 class="text-2xl font-bold mb-6 text-center text-blue-600">Publier un trajet</h1>
      <form action="/trajets" method="POST" class="space-y-4">
        <div>
          <label for="depart" class="block text-sm font-medium text-gray-700">Ville de départ</label>
          <input type="text" placeholder="Reims..." id="depart" name="depart" required class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
        </div>

        <div>
          <label for="destination" class="block text-sm font-medium text-gray-700">Ville d'arrivée</label>
          <input type="text" id="destination" placeholder="Paris..." name="destination" required class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label for="rdv-address" class="block text-sm font-medium text-gray-700">Adresse exacte du rendez-vous</label>
            <input placeholder="2 Av. Robert Schuman..." type="text" id="rdv-address" name="depart" required class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
          </div>
          <div>
            <label for="finish-address" class="block text-sm font-medium text-gray-700">Adresse exacte de l'arrivée</label>
            <input placeholder="24 Rue du Commandant Guilbaud..." type="text" id="finish-address" name="depart" required class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
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

        <div>
          <label for="places" class="block text-sm font-medium text-gray-700">Nombre de places disponibles</label>
          <select id="places" class="col-span-1 md:col-span-1 border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
            <option>1 passager</option>
            <option>2 passagers</option>
            <option>3 passagers</option>
            <option>4 passagers</option>
          </select>
        </div>

        <div>
          <label for="prix" class="block text-sm font-medium text-gray-700">Prix par passager (€)</label>
          <input type="number" id="prix" name="prix" min="0" step="0.5" required class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
        </div>

        <div>
          <label for="commentaire" class="block text-sm font-medium text-gray-700">Commentaire (optionnel)</label>
          <textarea id="commentaire" name="commentaire" rows="3" class="mt-1 block w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Ex : bagages acceptés, animaux interdits..."></textarea>
        </div>

        <div class="text-center">
          <button type="submit" class="bg-green-600 text-white px-6 py-2 rounded hover:bg-green-700">Publier le trajet</button>
          <button type="button" onclick="window.location.href='home.jsp'" class="bg-neutral-400 text-dark px-6 py-2 rounded hover:bg-neutral-500">Annuler la publication du trajet</button>
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
