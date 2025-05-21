<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<header class="bg-white shadow">
  <div class="container mx-auto px-4 py-4 flex justify-between items-center">
    <a href="home.jsp" class="text-2xl font-bold text-blue-600">Covoitme</a>
    <nav class="space-x-6 hidden md:flex">
      <a href="home" class="text-gray-700 hover:text-blue-600">Accueil</a>
      <a href="newpath" class="text-gray-700 hover:text-blue-600">Publier un trajet</a>
      <a href="myPath.jsp" class="text-gray-700 hover:text-blue-600">Mes réservations</a>
      <a href="createdpath" class="text-gray-700 hover:text-blue-600">Mes trajets</a>
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
</header>