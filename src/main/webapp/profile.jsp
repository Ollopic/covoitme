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

  <div id="errorMessage" class="hidden bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
    <span id="errorText"></span>
  </div>

  <div class="space-y-4">
    <form id="profileForm" action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data">

      <div class="flex items-center justify-center">
        <div class="relative flex items-center justify-center w-[165px] h-[165px] transition-all duration-300">
          <input id="file" name="profileImage" type="file" class="hidden" onchange="loadFile(event)" accept="image/*" />
          <img
            src="<%= session.getAttribute("profileImage") %>"
            onerror="this.src='https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg'"
            id="output"
            alt="Nouvelle photo de profil"
            class="absolute w-[165px] h-[165px] object-cover border-2 border-blue-500 rounded-full shadow-[0_0_10px_0_rgba(255,255,255,0.35)]">
          <label
            for="file"
            class="absolute flex items-center justify-center w-[165px] h-[165px] cursor-pointer transition-all duration-200 bg-transparent text-transparent rounded-full hover:bg-black hover:bg-opacity-80 hover:text-white z-10">
            <span class="inline-flex items-center justify-center h-8 px-2">Changer l'image</span>
          </label>
        </div>
      </div>

      <div class="mt-2 text-center text-sm text-gray-500">
        Taille maximum : 5 MB
      </div>

      <div class="mt-4 text-center">
        <button id="saveImageBtn" type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 hidden">
          Enregistrer la photo
        </button>
      </div>

      <div id="readonlySection" class="mt-6 space-y-2">
        <p><strong>Prénom :</strong> <%= request.getAttribute("prenom") %></p>
        <p><strong>Nom :</strong> <%= request.getAttribute("nom") %></p>
        <p><strong>Email :</strong> <%= request.getAttribute("email") %></p>
        <p><strong>Numéro de téléphone :</strong> <%= request.getAttribute("numTel") %></p>
        <p><strong>Âge :</strong> <%= request.getAttribute("age") %></p>
      </div>

      <div id="editSection" class="mt-6 space-y-4 hidden">
        <div>
          <label class="block text-gray-600 text-lg font-semibold">Prénom :</label>
          <input type="text" name="prenom" value="<%= request.getAttribute("prenom") %>" class="w-full border rounded px-3 py-2 text-gray-800 text-lg"/>
        </div>

        <div>
          <label class="block text-gray-600 text-lg font-semibold">Nom :</label>
          <input type="text" name="nom" value="<%= request.getAttribute("nom") %>" class="w-full border rounded px-3 py-2 text-gray-800 text-lg"/>
        </div>

        <div>
          <label class="block text-gray-600 text-lg font-semibold">Email :</label>
          <input type="email" name="email" value="<%= request.getAttribute("email") %>" class="w-full border rounded px-3 py-2 text-gray-800 text-lg"/>
        </div>

        <div>
          <label class="block text-gray-600 text-lg font-semibold">Numéro de téléphone :</label>
          <input type="tel" name="numTel" value="<%= request.getAttribute("numTel") %>" class="w-full border rounded px-3 py-2 text-gray-800 text-lg"/>
        </div>

        <div>
          <label class="block text-gray-600 text-lg font-semibold">Âge :</label>
          <input type="number" name="age" value="<%= request.getAttribute("age") %>" class="w-full border rounded px-3 py-2 text-gray-800 text-lg"/>
        </div>

        <div class="text-center mt-4">
          <button type="submit" class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">
            Enregistrer les modifications
          </button>
        </div>
      </div>

    </form>

    <div class="text-center">
      <button id="editBtn" type="button" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 mt-4">
        Modifier
      </button>
    </div>
  </div>
</div>

<script>
  const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5 MB max est ce que supporte le servlet

  function showError(message) {
    const errorDiv = document.getElementById("errorMessage");
    const errorText = document.getElementById("errorText");
    errorText.textContent = message;
    errorDiv.classList.remove("hidden");

    setTimeout(function() {
      errorDiv.classList.add("hidden");
    }, 5000);
  }

  function hideError() {
    document.getElementById("errorMessage").classList.add("hidden");
  }

  function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  }

  function loadFile(event) {
    const file = event.target.files[0];

    if (!file) return;

    if (file.size > MAX_FILE_SIZE) {
      showError('L\'image est trop volumineuse (' + formatFileSize(file.size) + '). La taille maximum autorisée est de 5 MB.');

      event.target.value = '';
      document.getElementById("saveImageBtn").classList.add("hidden");
      return;
    }

    if (!file.type.startsWith('image/')) {
      showError('Veuillez sélectionner un fichier image valide.');
      event.target.value = '';
      document.getElementById("saveImageBtn").classList.add("hidden");
      return;
    }

    hideError();

    const image = document.getElementById("output");
    image.src = URL.createObjectURL(file);
    document.getElementById("saveImageBtn").classList.remove("hidden");

    event.preventDefault();
  }

  document.getElementById("profileForm").addEventListener("submit", function(event) {
    const fileInput = document.getElementById("file");

    if (fileInput.files.length > 0) {
      const file = fileInput.files[0];

      if (file.size > MAX_FILE_SIZE) {
        event.preventDefault();
        showError('L\'image est trop volumineuse (' + formatFileSize(file.size) + '). La taille maximum autorisée est de 5 MB.');
        return false;
      }
    }
  });

  document.getElementById("editBtn").addEventListener("click", function() {
    document.getElementById("readonlySection").classList.add("hidden");
    document.getElementById("editSection").classList.remove("hidden");
    document.getElementById("editBtn").classList.add("hidden");
  });
</script>

</body>
</html>