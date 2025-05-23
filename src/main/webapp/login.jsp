<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Covoiturage - Connexion & Inscription</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">
  <div class="w-full max-w-md bg-white p-8 rounded-xl shadow-lg">
    <div class="flex justify-center mb-6 text-xl font-bold">
        Bienvenue sur Covoitme !
    </div>

    <div class="flex justify-center mb-6">
      <button id="showLogin" class="text-blue-600 font-semibold mr-4">Connexion</button>
      <button id="showRegister" class="text-gray-500 font-semibold">Inscription</button>
    </div>

    <form id="loginForm" class="space-y-4" action="${pageContext.request.contextPath}/login" method="post">
      <h2 class="text-xl font-bold text-center mb-4">Connexion</h2>
      <input type="email" name="email" placeholder="Email" required class="w-full p-2 border rounded" 
             value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" />
      <input type="password" name="motDePasse" placeholder="Mot de passe" required class="w-full p-2 border rounded" />
      <button type="submit" class="w-full bg-blue-600 text-white p-2 rounded hover:bg-blue-700">Se connecter</button>
    </form>

    <form id="registerForm" class="space-y-4 hidden" action="${pageContext.request.contextPath}/register" method="post">
      <h2 class="text-xl font-bold text-center mb-4">Inscription</h2>
      <input type="text" name="prenom" placeholder="Prénom" required class="w-full p-2 border rounded" 
             value="<%= request.getAttribute("prenom") != null ? request.getAttribute("prenom") : "" %>" />
      <input type="text" name="nom" placeholder="Nom" required class="w-full p-2 border rounded" 
             value="<%= request.getAttribute("nom") != null ? request.getAttribute("nom") : "" %>" />
      <input type="email" name="email" placeholder="Email" required class="w-full p-2 border rounded" 
             value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" />
      <input type="tel" name="telephone" placeholder="Numéro de téléphone" required 
           pattern="0[1-9][0-9]{8}" 
           title="Format attendu : 10 chiffres commençant par 0 (ex: 0123456789)"
           class="w-full p-2 border rounded" 
           value="<%= request.getAttribute("telephone") != null ? request.getAttribute("telephone") : "" %>" />
      <input type="number" name="age" placeholder="Votre âge" required min="18" max="100" 
             title="Vous devez avoir au minimum 18 ans pour pouvoir vous inscrire !" 
             class="w-full p-2 border rounded" 
             value="<%= request.getAttribute("age") != null ? request.getAttribute("age") : "" %>" />
      <input type="password" name="motDePasse" placeholder="Mot de passe" required class="w-full p-2 border rounded" />
      <input type="password" name="confirmMotDePasse" placeholder="Confirmer le mot de passe" required class="w-full p-2 border rounded" />
      <button type="submit" class="w-full bg-green-600 text-white p-2 rounded hover:bg-green-700">S'inscrire</button>
    </form>
  </div>

  <script>
    const loginForm = document.getElementById("loginForm");
    const registerForm = document.getElementById("registerForm");
    const showLogin = document.getElementById("showLogin");
    const showRegister = document.getElementById("showRegister");

    function displayLoginForm() {
      loginForm.classList.remove("hidden");
      registerForm.classList.add("hidden");
      showLogin.classList.add("text-blue-600");
      showLogin.classList.remove("text-gray-500");
      showRegister.classList.remove("text-blue-600");
      showRegister.classList.add("text-gray-500");
    }
    
    function displayRegisterForm() {
      loginForm.classList.add("hidden");
      registerForm.classList.remove("hidden");
      showLogin.classList.remove("text-blue-600");
      showLogin.classList.add("text-gray-500");
      showRegister.classList.add("text-blue-600");
      showRegister.classList.remove("text-gray-500");
    }

    showLogin.addEventListener("click", displayLoginForm);
    showRegister.addEventListener("click", displayRegisterForm);
    
    <% if (request.getAttribute("prenom") != null) { %>
      displayRegisterForm();
    <% } %>
  </script>
</body>
</html>