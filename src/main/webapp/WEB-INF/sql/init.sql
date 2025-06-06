CREATE TABLE Utilisateur (
    id SERIAL PRIMARY KEY,
    age INT,
    email VARCHAR(150),
    nom VARCHAR(100),
    numTel VARCHAR(20),
    password VARCHAR(100),
    prenom VARCHAR(100),
    profilePic BYTEA
);

CREATE TABLE Trajet (
    id SERIAL PRIMARY KEY,
    adresseDepart VARCHAR(200),
    adresseDestination VARCHAR(200),
    commentaire VARCHAR(500),
    conducteur_id INT,
    dateArrivee TIMESTAMP,
    dateDepart TIMESTAMP,
    immatriculation VARCHAR(20),
    nbPlacesLibres INT,
    tarif DECIMAL(6, 2),
    vehicule VARCHAR(100),
    villeDepart VARCHAR(100),
    villeDestination VARCHAR(100),
    FOREIGN KEY (conducteur_id) REFERENCES Utilisateur(id)
);

CREATE TABLE PassagerTrajet (
    trajet_id INT,
    utilisateur_id INT,
    nbPlacesReservees INT,
    PRIMARY KEY (utilisateur_id, trajet_id),
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id),
    FOREIGN KEY (trajet_id) REFERENCES Trajet(id)
);

CREATE TABLE DemandeTrajet (
    id SERIAL PRIMARY KEY,
    trajet_id INT,
    utilisateur_id INT,
    adresseDepart VARCHAR(200),
    adresseDestination VARCHAR(200),
    commentaire VARCHAR(500),
    dateArrivee TIMESTAMP,
    dateDepart TIMESTAMP,
    nbPlacesLibres INT,
    villeDepart VARCHAR(100),
    villeDestination VARCHAR(100),
    tarif DECIMAL(6, 2),
    FOREIGN KEY (trajet_id) REFERENCES Trajet(id),
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id)
);
