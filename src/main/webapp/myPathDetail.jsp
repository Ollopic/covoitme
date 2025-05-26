<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    var trajet = (Map<String, Object>) request.getAttribute("trajet");
    var passagers = (List<Map<String, Object>>) request.getAttribute("passagers");

    if (passagers == null) passagers = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Infos sur mon trajet proposé</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 min-h-screen flex flex-col justify-between">
    <%@ include file="navbar.jsp" %>

    <div class="container mx-auto px-4 py-6">
        <h1 class="text-3xl font-bold text-teal-800 mb-6">Trajet proposé - <%= trajet.get("datedepart") %></h1>

        <div class="bg-white rounded-lg shadow-md overflow-hidden mb-6">
            <div class="p-6 border-b border-gray-200">
                <div class="flex items-start">
                    <div class="relative flex flex-col items-center mr-6">
                        <div class="text-left w-16">
                            <div class="font-bold text-lg"><%= trajet.get("heuredepart") %></div>
                            <div class="text-sm text-gray-500">Départ</div>
                        </div>
                        <div class="h-24 w-0.5 bg-teal-600 my-2 ml-2"></div>
                        <div class="text-left w-16">
                            <div class="font-bold text-lg"><%= trajet.get("heurearrivee") %></div>
                            <div class="text-sm text-gray-500">Arrivée</div>
                        </div>
                    </div>

                    <div class="flex-1">
                        <div class="mb-6">
                            <div class="flex items-center mb-1">
                                <span class="font-semibold text-lg"><%= trajet.get("villedepart") %></span>
                            </div>
                            <div class="text-gray-600"><%= trajet.get("adressedepart") %></div>
                        </div>
                        <div class="h-16"></div>
                        <div class="mb-6">
                            <div class="flex items-center mb-1">
                                <span class="font-semibold text-lg"><%= trajet.get("villedestination") %></span>
                            </div>
                            <div class="text-gray-600"><%= trajet.get("adressedestination") %></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="p-6 border-b border-gray-200">
                <ul class="space-y-6">
                    <li class="flex items-start">
                        <div class="text-gray-500 mr-4 mt-1">
                            <i class="fas fa-users"></i>
                        </div>
                        <span class="text-gray-700"><%= trajet.get("nbplaceslibres") %> places disponibles</span>
                    </li>
                    <li class="flex items-start">
                        <div class="text-gray-500 mr-4 mt-1">
                            <i class="fas fa-car"></i>
                        </div>
                        <span class="text-gray-700"><%= trajet.get("vehicule") %> - <%= trajet.get("immatriculation") %></span>
                    </li>
                    <li class="flex items-start">
                        <div class="text-gray-500 mr-4 mt-1">
                            <i class="fas fa-euro-sign"></i>
                        </div>
                        <span class="text-gray-700"><%= trajet.get("tarif") %> €</span>
                    </li>
                    <% if(trajet.get("commentaire") != null && !trajet.get("commentaire").toString().isEmpty()) { %>
                        <div class="text-gray-500 mr-4 mt-1">
                            <i class="fas fa-info-circle"></i>
                        </div>
                        <span class="text-gray-700"><%= trajet.get("commentaire") %></span>
                    <% } %>
                </ul>
            </div>
            
            <div class="p-6">
                <h2 class="font-bold text-xl mb-4 text-teal-800">
                    <i class="fas fa-users mr-2"></i>Passagers
                </h2>
                
                <% if(passagers.isEmpty()) { %>
                    <p class="text-gray-600 italic">Aucun passager n'a encore réservé ce trajet.</p>
                <% } else { %>
                    <div class="space-y-4">
                        <% for(Map<String, Object> passager : passagers) { %>
                            <div class="flex items-center p-4 border border-gray-200 rounded-lg hover:bg-gray-50">
                                <div class="h-12 w-12 rounded-full overflow-hidden border-2 border-white shadow-md mr-4">
                                    <img src="https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg" alt="Passager" class="h-full w-full object-cover" />
                                </div>
                                <div class="flex-1">
                                    <div class="font-medium text-teal-800"><%= passager.get("prenom") %> <%= passager.get("nom") %></div>
                                    <div class="flex flex-wrap gap-3 text-sm text-gray-500">
                                        <span><i class="fas fa-envelope mr-1"></i> <%= passager.get("email") %></span>
                                        <% if(passager.get("numtel") != null) { %>
                                            <span><i class="fas fa-phone mr-1"></i> <%= passager.get("numtel") %></span>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
            
            <div class="p-6 border-t border-gray-200">
                <form method="post" action="mypathdetail" onsubmit="return confirm('Êtes-vous sûr de vouloir annuler ce trajet ? Cette action est irréversible.');">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="trajet_id" value="<%= trajet.get("id") %>">
                    <button type="submit" class="text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center">
                        <i class="fas fa-times-circle mr-2"></i> Annuler ce trajet
                    </button>
                </form>
            </div>
        </div>
    </div>

</body>
</html>