<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mon Covoiturage</title>
    <script src="https://cdn.tailwindcss.com"></script>
  </head>
  <body class="font-sans text-gray-800">
    <%@ include file="navbar.jsp" %>

    <% if (request.getParameter("success") != null && request.getParameter("success").equals("true")) { %>
      <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4" role="alert">
        <strong class="font-bold">Succès !</strong>
        <% if (request.getParameter("request") != null && request.getParameter("request").equals("true")) { %>
          <span class="block sm:inline"> Votre demande de trajet a été créée avec succès.</span>
        <% } else { %>
          <span class="block sm:inline"> Votre trajet a été créé avec succès.</span>
        <% } %>
      </div>
    <% } %>

    <section class="bg-blue-50 py-16">
      <div class="container mx-auto px-4 text-center">
        <h1 class="text-4xl md:text-5xl font-bold mb-6">Partez ensemble, voyagez mieux.</h1>
        <form class="bg-white p-6 rounded shadow-md max-w-6xl mx-auto grid grid-cols-1 md:grid-cols-5 gap-4" action="listpath">
          <input type="text" name="start" placeholder="Départ" class="col-span-1 md:col-span-1 border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
          <input type="text" name="destination" placeholder="Destination" class="col-span-1 md:col-span-1 border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
          <input id="datePicker" name="date" type="date" class="col-span-1 md:col-span-1 border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
          <select class="col-span-1 md:col-span-1 border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" name="nbPassengers">
            <option disabled selected>Nombre de passagers</option>
            <option>1</option>
            <option>2</option>
            <option>3</option>
            <option>4</option>
          </select>
          <button type="submit" class="col-span-1 md:col-span-1 bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">Rechercher</button>
        </form>
      </div>
    </section>

    <section class="py-16 bg-white">
      <div class="container mx-auto px-4 grid grid-cols-1 md:grid-cols-3 gap-8 text-center">
        <div>
          <div class="text-blue-600 text-4xl mb-2">🔒</div>
          <h3 class="font-semibold text-lg mb-2">Profils vérifiés</h3>
          <p class="text-gray-600">Voyagez avec des membres de confiance.</p>
        </div>
        <div>
          <div class="text-blue-600 text-4xl mb-2">💳</div>
          <h3 class="font-semibold text-lg mb-2">Paiement sur place</h3>
          <p class="text-gray-600">Payez en liquide directement auprès de votre conducteur.</p>
        </div>
        <div>
          <div class="text-blue-600 text-4xl mb-2">📞</div>
          <h3 class="font-semibold text-lg mb-2">Assistance 24/7</h3>
          <p class="text-gray-600">Nous sommes là pour vous aider à tout moment.</p>
        </div>
      </div>
    </section>

    <section class="py-16 bg-blue-50">
      <div class="container mx-auto px-4 text-center">
        <h2 class="text-3xl font-bold mb-10">Comment ça marche</h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div>
            <div class="text-blue-600 text-4xl mb-2">🔍</div>
            <h3 class="font-semibold text-lg mb-2">Recherchez un trajet</h3>
            <p class="text-gray-600">Entrez votre lieu de départ et votre destination.</p>
          </div>
          <div>
            <div class="text-blue-600 text-4xl mb-2">📝</div>
            <h3 class="font-semibold text-lg mb-2">Réservez en ligne</h3>
            <p class="text-gray-600">Choisissez le trajet qui vous convient et réservez.</p>
          </div>
          <div>
            <div class="text-blue-600 text-4xl mb-2">🚗</div>
            <h3 class="font-semibold text-lg mb-2">Voyagez en toute confiance</h3>
            <p class="text-gray-600">Rencontrez le conducteur et profitez du trajet.</p>
          </div>
        </div>
      </div>
    </section>

    <section class="py-16 bg-white">
      <div class="container mx-auto px-4 text-center">
        <h2 class="text-3xl font-bold mb-6">Destinations populaires</h2>
        <ul class="flex flex-wrap justify-center gap-4 text-blue-600 font-medium">
          <li><a href="listpath?start=Paris&destination=Lyon" class="hover:underline">Paris → Lyon</a></li>
          <li><a href="listpath?start=Marseille&destination=Nice" class="hover:underline">Marseille → Nice</a></li>
          <li><a href="listpath?start=Lille&destination=Bruxelles" class="hover:underline">Lille → Bruxelles</a></li>
          <li><a href="listpath?start=Bordeaux&destination=Toulouse" class="hover:underline">Bordeaux → Toulouse</a></li>
        </ul>
      </div>
    </section>
      
      <script>
        function toDateInputValue(dateObject){
            const local = new Date(dateObject);
            local.setMinutes(dateObject.getMinutes() - dateObject.getTimezoneOffset());
            return local.toJSON().slice(0,10);
        }

        document.getElementById('datePicker').value = toDateInputValue(new Date());
      </script>
  </body>
</html>
