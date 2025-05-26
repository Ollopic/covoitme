<%@ page import="java.util.*, java.text.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Résultats de recherche - CovoiturageApp</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 min-h-screen flex flex-col">
<%@ include file="navbar.jsp" %>

<%
    List<Map<String, Object>> trajets = (List<Map<String, Object>>) request.getAttribute("trajets");
%>
<section class="bg-blue-50 py-16">
    <div class="container mx-auto px-4 text-center">
        <h1 class="text-4xl md:text-5xl font-bold mb-6">Partez ensemble, voyagez mieux.</h1>
        <form class="bg-white p-6 rounded shadow-md max-w-6xl mx-auto grid grid-cols-1 md:grid-cols-5 gap-4" action="listpath">
            <input type="text" value="<%= request.getParameter("start") %>" name="start" placeholder="Départ" class="col-span-1 md:col-span-1 border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
            <input type="text" value="<%= request.getParameter("destination") %>" name="destination" placeholder="Destination" class="col-span-1 md:col-span-1 border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
            <input id="datePicker" name="date" type="date" value="<%= request.getParameter("date") %>" class="col-span-1 md:col-span-1 border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
            <%
                String selectedNbPassengers = request.getParameter("nbPassengers");
            %>
            <select class="col-span-1 md:col-span-1 border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" name="nbPassengers">
                <option disabled <%= (selectedNbPassengers == null) ? "selected" : "" %>>Nombre de passagers</option>
                <option value="1" <%= "1".equals(selectedNbPassengers) ? "selected" : "" %>>1</option>
                <option value="2" <%= "2".equals(selectedNbPassengers) ? "selected" : "" %>>2</option>
                <option value="3" <%= "3".equals(selectedNbPassengers) ? "selected" : "" %>>3</option>
                <option value="4" <%= "4".equals(selectedNbPassengers) ? "selected" : "" %>>4</option>
            </select>
            <button type="submit" class="col-span-1 md:col-span-1 bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">Rechercher</button>
        </form>
    </div>
</section>

<section class="container mx-auto px-4 py-6">
    <h2 class="text-xl font-semibold mb-4"><%= trajets.size() %> trajet(s) trouvés de <%= request.getParameter("start") %> à <%= request.getParameter("destination") %></h2>

    <div class="space-y-4">
        <%
            for (Map<String, Object> trajet : trajets) {
        %>
        <div class="bg-white rounded-lg shadow-md overflow-hidden">
            <div class="p-4">
                <div class="flex flex-col md:flex-row md:justify-between">
                    <div class="flex items-start gap-4">
                        <div class="flex flex-col items-center">
                            <span class="font-semibold text-lg"><%= trajet.get("heuredepart") %></span>
                            <div class="w-0.5 h-16 bg-gray-300 my-1"></div>
                            <span class="font-semibold text-lg"><%= trajet.get("heurearrivee") %></span>
                        </div>
                        <div class="flex-1">
                            <div class="mb-4">
                                <div class="font-medium"><%= trajet.get("adressedepart") %></div>
                                <div class="text-md text-blue-500 mt-1">
                                    <%= trajet.get("datedepart") != null ? trajet.get("datedepart") : "" %>
                                </div>
                            </div>
                            <div class="mb-2">
                                <div class="font-medium"><%= trajet.get("adressedestination") %></div>
                                <div class="text-md text-blue-500 mt-1">
                                    <%= trajet.get("datearrivee") != null ? trajet.get("datearrivee") : "" %>
                                </div>
                            </div>
                            <div class="text-sm text-gray-500 mt-2">
                                <i class="fas fa-clock mr-1"></i> <%= trajet.get("duree") %> · Direct
                            </div>
                        </div>
                    </div>

                    <div class="mt-4 md:mt-0 flex flex-col items-end justify-between">
                        <div class="flex items-center mb-4">
                            <div class="h-8 w-8 rounded-full overflow-hidden mr-2">
                                <img class="w-12 h-12 rounded-full border-2" src="<%= trajet.get("conducteurprofilepic") %>" onerror="this.src='https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg'" alt="user photo">
                            </div>
                            <span class="font-medium"><%= trajet.get("conducteur") %></span>
                        </div>
                        <div class="flex items-center">
                            <div class="mr-4">
                                <span class="text-2xl font-bold"><%= trajet.get("tarif") %> € / passagers</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/pathdetail?id=<%= trajet.get("id") %>" class="bg-blue-600 text-white px-6 py-2 rounded-full hover:bg-blue-700 transition">Détail</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="bg-gray-50 p-3 flex flex-wrap gap-3 text-sm">
                <div class="flex items-center text-gray-600">
                    <i class="fas fa-car-side mr-1"></i>
                    <span><%= trajet.get("vehicule") %></span>
                </div>
                <div class="flex items-center text-gray-600">
                    <i class="fas fa-chair mr-1"></i>
                    <span><%= trajet.get("nbplaceslibres") %> place(s) disponible(s)</span>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>
</section>
</body>