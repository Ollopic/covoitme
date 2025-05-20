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
<body class="bg-gray-100 min-h-screen flex flex-col justify-between">
    <%@ include file="navbar.jsp" %>

    <section class="bg-blue-50 py-4">
        <form class="bg-white p-6 rounded shadow-md max-w-4xl mx-auto grid grid-cols-1 md:grid-cols-5 gap-4">
          <input type="text" placeholder="Départ" class="col-span-1 md:col-span-1 border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
          <input type="text" placeholder="Destination" class="col-span-1 md:col-span-1 border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
          <input id="datePicker" type="date" class="col-span-1 md:col-span-1 border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
          <select class="col-span-1 md:col-span-1 border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
            <option>1 passager</option>
            <option>2 passagers</option>
            <option>3 passagers</option>
            <option>4 passagers</option>
          </select>
          <button type="submit" class="col-span-1 md:col-span-1 bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">Rechercher</button>
        </form>
    </section>

    <section class="bg-white shadow-md mt-4">
        <div class="container mx-auto px-4 py-4">
            <div class="flex flex-wrap justify-between items-center gap-4">
                <div class="flex flex-wrap items-center gap-3">
                    <div class="flex items-center border border-gray-300 rounded-full px-3 py-1 text-sm">
                        <span>Heure de départ</span>
                        <i class="fas fa-chevron-down ml-2 text-gray-500"></i>
                    </div>
                    <div class="flex items-center border border-gray-300 rounded-full px-3 py-1 text-sm">
                        <span>Prix</span>
                        <i class="fas fa-chevron-down ml-2 text-gray-500"></i>
                    </div>
                    <div class="flex items-center border border-gray-300 rounded-full px-3 py-1 text-sm">
                        <span>Options</span>
                        <i class="fas fa-chevron-down ml-2 text-gray-500"></i>
                    </div>
                </div>
                <div class="flex items-center text-sm text-gray-600">
                    <span>Trier par :</span>
                    <select class="ml-2 border-none bg-transparent font-medium text-blue-600 focus:outline-none">
                        <option>Prix croissant</option>
                        <option>Prix décroissant</option>
                        <option>Heure de départ</option>
                    </select>
                </div>
            </div>
        </div>
    </section>

    <section class="container mx-auto px-4 py-6">
        <h2 class="text-xl font-semibold mb-4">2 trajets trouvés de Paris à Reims</h2>
        
        <div class="space-y-4">
            <div class="bg-white rounded-lg shadow-md overflow-hidden">
                <div class="p-4">
                    <div class="flex flex-col md:flex-row md:justify-between">
                        <div class="flex items-start gap-4">
                            <div class="flex flex-col items-center">
                                <span class="font-semibold text-lg">08:15</span>
                                <div class="w-0.5 h-12 bg-gray-300 my-1"></div>
                                <span class="font-semibold text-lg">10:00</span>
                            </div>
                            <div>
                                <div class="mb-2">
                                    <span class="font-medium">Gare de Paris Est</span>
                                </div>
                                <div>
                                    <span class="font-medium">Reims Centre</span>
                                </div>
                                <div class="text-sm text-gray-500 mt-2">
                                    <i class="fas fa-clock mr-1"></i> 1h45 · Direct
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 md:mt-0 flex flex-col items-end justify-between">
                            <div class="flex items-center mb-4">
                                <div class="h-8 w-8 rounded-full overflow-hidden mr-2">
                                    <img src="https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg" alt="Conducteur" class="h-full w-full object-cover" />
                                </div>
                                <span class="font-medium">Thomas</span>
                            </div>
                            <div class="flex items-center">
                                <div class="mr-4">
                                    <span class="text-2xl font-bold">19 €</span>
                                </div>
                                <a href="pathDetail.jsp" class="bg-blue-600 text-white px-6 py-2 rounded-full hover:bg-blue-700 transition">Réserver</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="bg-gray-50 p-3 flex flex-wrap gap-3 text-sm">
                    <div class="flex items-center text-gray-600">
                        <i class="fas fa-car-side mr-1"></i>
                        <span>Citroën C4</span>
                    </div>
                    <div class="flex items-center text-gray-600">
                        <i class="fas fa-chair mr-1"></i>
                        <span>2 places arrière disponibles</span>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow-md overflow-hidden">
                <div class="p-4">
                    <div class="flex flex-col md:flex-row md:justify-between">
                        <div class="flex items-start gap-4">
                            <div class="flex flex-col items-center">
                                <span class="font-semibold text-lg">10:30</span>
                                <div class="w-0.5 h-12 bg-gray-300 my-1"></div>
                                <span class="font-semibold text-lg">12:15</span>
                            </div>
                            <div>
                                <div class="mb-2">
                                    <span class="font-medium">Paris La Défense</span>
                                </div>
                                <div>
                                    <span class="font-medium">Gare de Reims</span>
                                </div>
                                <div class="text-sm text-gray-500 mt-2">
                                    <i class="fas fa-clock mr-1"></i> 1h45 · Direct
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 md:mt-0 flex flex-col items-end justify-between">
                            <div class="flex items-center mb-4">
                                <div class="h-8 w-8 rounded-full overflow-hidden mr-2">
                                    <img src="https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg" alt="Conductrice" class="h-full w-full object-cover" />
                                </div>
                                <span class="font-medium">Sophie</span>
                            </div>
                            <div class="flex items-center">
                                <div class="mr-4">
                                    <span class="text-2xl font-bold">17 €</span>
                                </div>
                                <a href="pathDetail.jsp" class="bg-blue-600 text-white px-6 py-2 rounded-full hover:bg-blue-700 transition">Réserver</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="bg-gray-50 p-3 flex flex-wrap gap-3 text-sm">
                    <div class="flex items-center text-gray-600">
                        <i class="fas fa-car-side mr-1"></i>
                        <span>Tesla Model 3</span>
                    </div>
                    <div class="flex items-center text-green-600">
                        <i class="fas fa-leaf mr-1"></i>
                        <span>Véhicule électrique</span>
                    </div>
                    <div class="flex items-center text-gray-600">
                        <i class="fas fa-chair mr-1"></i>
                        <span>3 places arrière disponibles</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-8 flex justify-center">
            <nav class="flex items-center">
                <button class="px-3 py-1 rounded border border-gray-300 mr-2 bg-white text-gray-600">
                    <i class="fas fa-chevron-left"></i>
                </button>
                <button class="px-3 py-1 rounded border border-blue-600 mr-2 bg-blue-600 text-white">1</button>
                <button class="px-3 py-1 rounded border border-gray-300 mr-2 bg-white text-gray-600">2</button>
                <button class="px-3 py-1 rounded border border-gray-300 bg-white text-gray-600">
                    <i class="fas fa-chevron-right"></i>
                </button>
            </nav>
        </div>
    </section>

    <footer class="bg-gray-800 text-white py-10 items-end">
      <div class="container mx-auto px-2 flex flex-col md:flex-row justify-between items-center">
        <div class="mb-4 md:mb-0">
          <a href="#" class="hover:underline">À propos</a> |
          <a href="#" class="hover:underline">Conditions générales</a> |
          <a href="#" class="hover:underline">Politique de confidentialité</a> |
          <a href="#" class="hover:underline">Contact</a>
        </div>
      </div>
    </footer>
</body>