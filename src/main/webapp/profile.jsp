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
        <form id="profileForm" action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data">
            <div class="flex items-center justify-center">
                <div class="relative flex items-center justify-center w-[165px] h-[165px] transition-all duration-300">
                    <input id="file" name="profileImage" type="file" class="hidden" onchange="loadFile(event)" accept="image/*" />
                    <img
                            src="${pageContext.request.contextPath}/profile?id=${sessionScope.userId}"
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
            <div class="mt-4 text-center">
                <button id="saveImageBtn" type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 hidden">
                    Enregistrer la photo
                </button>
            </div>
        </form>

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

<script>
const loadFile = function (event) {
    const image = document.getElementById("output");
    image.src = URL.createObjectURL(event.target.files[0]);

    document.getElementById("saveImageBtn").classList.remove("hidden");
    event.preventDefault();
};
</script>
</body>
</html>
