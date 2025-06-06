<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<header class="bg-white shadow">
  <div class="container mx-auto px-4 py-4 flex justify-between items-center">
    <a href="home" class="text-2xl font-bold text-blue-600">Covoitme</a>
    <nav class="space-x-6 hidden md:flex">
        <a href="home" class="text-gray-700 hover:text-blue-600">Accueil</a>

        <div class="relative inline-block text-left">
            <button
                id="dropdownButton"
                class="dropdown-btn inline-flex justify-between text-gray-700 hover:text-blue-600"
            >
                Gérer les trajets
                <svg class="ml-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                </svg>
            </button>

            <div
                id="dropdownMenu"
                class="hidden absolute left-0 mt-2 w-full rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 z-10"
            >
                <div class="py-1">
                    <a href="newpath" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Publier un trajet</a>
                    <a href="requestpath" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Demander un trajet</a>
                </div>
            </div>
        </div>

        <a href="mypath" class="text-gray-700 hover:text-blue-600">Mes réservations</a>
        <a href="createdpath" class="text-gray-700 hover:text-blue-600">Mes trajets publiés</a>
        <a href="passenger-requests" class="text-gray-700 hover:text-blue-600">Mes demandes de trajet</a>
    </nav>
    <div class="flex items-center gap-4">
        <a href="profile" class="flex bg-white rounded-full focus:ring-2 focus:ring-gray-300" id="user-menu-button" aria-expanded="false" data-dropdown-placement="bottom">
            <img class="w-12 h-12 rounded-full border-2 border-blue-600" src="<%= session.getAttribute("profileImage") %>" onerror="this.src='https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg'" alt="user photo">
        </a>
        <a href="${pageContext.request.contextPath}/logout"
            class="text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center mr-3 md:mr-0">
            Se déconnecter
        </a>
    </div>
  </div>

    <script>
        const button = document.getElementById('dropdownButton');
        const menu = document.getElementById('dropdownMenu');

        button.addEventListener('click', () => {
            menu.classList.toggle('hidden');
        });

        document.addEventListener('click', (e) => {
            if (!button.contains(e.target) && !menu.contains(e.target)) {
                menu.classList.add('hidden');
            }
        });
    </script>
</header>