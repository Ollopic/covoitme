CREATE TABLE Utilisateur (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    email VARCHAR(150),
    numTel VARCHAR(20),
    age INT,
    password VARCHAR(100),
    profilePic BYTEA
);

CREATE TABLE Trajet (
    id SERIAL PRIMARY KEY,
    lieuDestination VARCHAR(200),
    dateDepart TIMESTAMP,
    dateArrivee TIMESTAMP,
    nbPlacesLibres INT,
    lieuDepart VARCHAR(200),
    conducteur_id INT,
    vehicule VARCHAR(100),
    immatriculation VARCHAR(20),
    FOREIGN KEY (conducteur_id) REFERENCES Utilisateur(id)
);

CREATE TABLE PassagerTrajet (
    utilisateur_id INT,
    trajet_id INT,
    PRIMARY KEY (utilisateur_id, trajet_id),
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id),
    FOREIGN KEY (trajet_id) REFERENCES Trajet(id)
);
