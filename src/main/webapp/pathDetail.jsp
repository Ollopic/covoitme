<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%
    Map<String, Object> trajet = (Map<String, Object>) request.getAttribute("trajet");
    Map<String, Object> conducteur = (Map<String, Object>) request.getAttribute("conducteur");
    List<Map<String, Object>> passagers = (List<Map<String, Object>>) request.getAttribute("passagers");
    if (trajet == null) {
        response.sendRedirect("createdpath");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détail du trajet - CovoiturageApp</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 min-h-screen flex flex-col justify-between">
    <%@ include file="navbar.jsp" %>

    <div class="container mx-auto px-4 py-6">
        <h1 class="text-3xl font-bold text-teal-800 mb-6"><%= trajet.get("datedepart") %></h1>

        <div class="bg-white rounded-lg shadow-md overflow-hidden mb-6">
            <div class="p-6 border-b border-gray-200">
                <div class="flex items-start">
                    <div class="relative flex flex-col items-center mr-6">
                        <div class="text-left w-16">
                            <div class="font-bold text-lg"><%= trajet.get("heuredepart") %></div>
                            <div class="text-sm text-gray-500">Durée estimée</div>
                        </div>
                        <div class="h-24 w-0.5 bg-teal-600 my-2 ml-2"></div>
                        <div class="text-left w-16">
                            <div class="font-bold text-lg"><%= trajet.get("heurearrivee") %></div>
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
                <div class="flex justify-between items-center">
                    <div class="flex items-center">
                        <div class="h-16 w-16 rounded-full overflow-hidden border-2 border-white shadow-md mr-4">
                            <img src="https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg" alt="Conducteur" class="h-full w-full object-cover" />
                        </div>
                        <div>
                            <div class="font-semibold text-xl">Conducteur</div>
                            <div class="text-gray-600 text-sm">
                                <% if (conducteur != null && conducteur.get("prenom") != null && conducteur.get("nom") != null) { %>
                                    <%= conducteur.get("prenom") %> <%= conducteur.get("nom") %>
                                <% } else { %>
                                    Nom non spécifié
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="p-6">
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
                        <span class="text-gray-700"><%= trajet.get("commentaire") %></span>
                    </li>
                </ul>
            </div>
        </div>

        <% if (passagers != null && !passagers.isEmpty()) { %>
            <div class="bg-white rounded-lg shadow-md overflow-hidden mb-6">
                <div class="p-6">
                    <h2 class="text-xl font-bold mb-6">Passagers</h2>

                    <div class="space-y-4">
                        <% for (Map<String, Object> passager : passagers) { %>
                            <div class="flex justify-between items-center pb-4 border-b border-gray-100 last:border-0">
                                <div class="flex items-center">
                                    <div class="h-16 w-16 rounded-full overflow-hidden border-2 border-white shadow-md mr-4">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg" alt="Passager" class="h-full w-full object-cover" />
                                    </div>
                                    <div>
                                        <div class="font-semibold text-lg"><%= passager.get("prenom") %> <%= passager.get("nom") %></div>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        <% } %>

        <div class="bg-white rounded-lg shadow-md overflow-hidden mb-6">
            <div class="p-6">
                <div class="flex flex-col md:flex-row md:justify-between md:items-center">
                    <div class="flex items-center mb-4 md:mb-0">
                        <div class="h-12 w-12 flex items-center justify-center bg-gray-100 rounded-full mr-4">
                            <i class="fas fa-car text-gray-700"></i>
                        </div>
                        <div>
                            <div class="text-lg"><%= trajet.get("datedepart") %></div>
                            <div class="flex items-center">
                                <div class="flex flex-col items-center mr-3">
                                    <span class="text-sm font-medium"><%= trajet.get("heuredepart") %></span>
                                    <div class="h-4 w-0.5 bg-gray-300 my-0.5"></div>
                                    <span class="text-sm font-medium"><%= trajet.get("heurearrivee") %></span>
                                </div>
                                <div>
                                    <div class="text-sm"><%= trajet.get("villedepart") %></div>
                                    <div class="text-sm"><%= trajet.get("villedestination") %></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="flex flex-col items-end">
                        <div class="font-bold text-2xl"><%= trajet.get("tarif") %> €</div>
                        <div class="text-gray-600"><%= trajet.get("nbplaceslibres") %> passager(s)</div>
                    </div>
                </div>

                <div class="mt-8">
                    <form method="post" action="pathdetail">
                        <input type="hidden" name="action" value="reserve">
                        <input type="hidden" name="trajet_id" value="<%= trajet.get("id") %>">
                        <button type="submit" class="bg-blue-500 hover:bg-blue-600 text-white font-medium text-sm py-2.5 px-4 rounded-lg flex items-center justify-center transition mx-auto">
                            <i class="far fa-calendar-plus mr-2"></i>
                            Demande de réservation
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
