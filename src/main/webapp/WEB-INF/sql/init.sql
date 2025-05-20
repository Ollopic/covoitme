CREATE TABLE Vehicule (
    id SERIAL PRIMARY KEY,
    marque VARCHAR(100),
    modele VARCHAR(100),
    nImmatriculation VARCHAR(50)
);

CREATE TABLE Utilisateur (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    adresseMail VARCHAR(150),
    numTel VARCHAR(20),
    age INT,
    password VARCHAR(100),
    profilePic BYTEA,
    vehicule_id INT,
    FOREIGN KEY (vehicule_id) REFERENCES Vehicule(id)
);

CREATE TABLE Trajet (
    id SERIAL PRIMARY KEY,
    lieuDestination VARCHAR(200),
    dateDepart TIMESTAMP,
    dateArrivee TIMESTAMP,
    nbPlacesLibres INT,
    lieuDepart VARCHAR(200),
    conducteur_id INT,
    vehicule_id INT,
    FOREIGN KEY (conducteur_id) REFERENCES Utilisateur(id),
    FOREIGN KEY (vehicule_id) REFERENCES Vehicule(id)
);

CREATE TABLE PassagerTrajet (
    utilisateur_id INT,
    trajet_id INT,
    PRIMARY KEY (utilisateur_id, trajet_id),
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id),
    FOREIGN KEY (trajet_id) REFERENCES Trajet(id)
);
