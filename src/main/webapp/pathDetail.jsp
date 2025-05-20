<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
        <h1 class="text-3xl font-bold text-teal-800 mb-6">Mardi 20 mai</h1>

        <div class="bg-white rounded-lg shadow-md overflow-hidden mb-6">
            <div class="p-6 border-b border-gray-200">
                <div class="flex items-start">
                    <div class="relative flex flex-col items-center mr-6">
                        <div class="text-left w-16">
                            <div class="font-bold text-lg">15:00</div>
                            <div class="text-sm text-gray-500">1h40</div>
                        </div>
                        <div class="h-24 w-0.5 bg-teal-600 my-2 ml-2"></div>
                        <div class="text-left w-16">
                            <div class="font-bold text-lg">16:40</div>
                        </div>
                    </div>

                    <div class="flex-1">
                        <div class="mb-6">
                            <div class="flex items-center mb-1">
                                <span class="font-semibold text-lg">Le Bourget</span>
                            </div>
                            <div class="text-gray-600">7/9 Av. du 8 Mai 1945</div>
                        </div>
                        <div class="h-16"></div>
                        <div class="mb-6">
                            <div class="flex items-center mb-1">
                                <span class="font-semibold text-lg">Reims</span>
                            </div>
                            <div class="text-gray-600">4 Pl. Martyrs de la Résistance</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="p-6 border-b border-gray-200">
                <div class="flex justify-between items-center">
                    <div class="flex items-center">
                        <div class="h-16 w-16 rounded-full overflow-hidden border-2 border-white shadow-md mr-4">
                            <img src="https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg" alt="Mohamed" class="h-full w-full object-cover" />
                        </div>
                        <div>
                            <div class="font-semibold text-xl">Mohamed</div>
                            <div class="text-gray-600 text-sm">Conducteur</div>
                        </div>
                    </div>
                    <div>
                        <button class="text-gray-400 hover:text-gray-600">
                            <i class="fas fa-chevron-right text-lg"></i>
                        </button>
                    </div>
                </div>
            </div>

            <div class="p-6">
                <ul class="space-y-6">
                    <li class="flex items-start">
                        <div class="text-gray-500 mr-4 mt-1">
                            <i class="fas fa-users"></i>
                        </div>
                        <span class="text-gray-700">3 places disponibles</span>
                    </li>
                    <li class="flex items-start">
                        <div class="text-gray-500 mr-4 mt-1">
                            <i class="fas fa-car"></i>
                        </div>
                        <span class="text-gray-700">RENAULT GRAND SCENIC - Noir</span>
                    </li>
                    <li class="flex items-start">
                        <span class="text-gray-700">Je préfère ne pas voyager en compagnie d'animaux. J'ai 29 ans, j'aime les chevaux et papoter !</span>
                    </li>
                </ul>
            </div>
        </div>

        <div class="bg-white rounded-lg shadow-md overflow-hidden mb-6">
            <div class="p-6">
                <h2 class="text-xl font-bold mb-6">Passagers</h2>

                <div class="flex justify-between items-center">
                    <div class="flex items-center">
                        <div class="h-16 w-16 rounded-full overflow-hidden border-2 border-white shadow-md mr-4">
                            <img src="https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg" alt="Mamadou" class="h-full w-full object-cover" />
                        </div>
                        <div>
                            <div class="font-semibold text-lg">Mamadou</div>
                            <div class="text-gray-600 text-sm">Le Bourget → Cathédrale de Reims</div>
                        </div>
                    </div>
                    <div>
                        <button class="text-gray-400 hover:text-gray-600">
                            <i class="fas fa-chevron-right text-lg"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-lg shadow-md overflow-hidden mb-6">
            <div class="p-6">
                <div class="flex flex-col md:flex-row md:justify-between md:items-center">
                    <div class="flex items-center mb-4 md:mb-0">
                        <div class="h-12 w-12 flex items-center justify-center bg-gray-100 rounded-full mr-4">
                            <i class="fas fa-car text-gray-700"></i>
                        </div>
                        <div>
                            <div class="text-lg">Mardi 20 mai</div>
                            <div class="flex items-center">
                                <div class="flex flex-col items-center mr-3">
                                    <span class="text-sm font-medium">15:00</span>
                                    <div class="h-4 w-0.5 bg-gray-300 my-0.5"></div>
                                    <span class="text-sm font-medium">16:40</span>
                                </div>
                                <div>
                                    <div class="text-sm">Le Bourget</div>
                                    <div class="text-sm">Reims</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="flex flex-col items-end">
                        <div class="font-bold text-2xl">20<sup class="text-sm">,79</sup> €</div>
                        <div class="text-gray-600">1 passager</div>
                    </div>
                </div>

                <div class="mt-8">
                    <button class="w-full bg-blue-500 hover:bg-blue-600 text-white font-semibold py-3 px-4 rounded-full flex items-center justify-center transition">
                        <i class="far fa-calendar-plus mr-2"></i>
                        Demande de réservation
                    </button>
                </div>
            </div>
        </div>
    </div>

</body>
</html>