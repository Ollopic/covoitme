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
    conducteur_id INT,
    dateArrivee TIMESTAMP,
    dateDepart TIMESTAMP,
    immatriculation VARCHAR(20),
    nbPlacesLibres INT,
    vehicule VARCHAR(100),
    villeDepart VARCHAR(100),
    villeDestination VARCHAR(100),
    FOREIGN KEY (conducteur_id) REFERENCES Utilisateur(id)
);

CREATE TABLE PassagerTrajet (
    trajet_id INT,
    utilisateur_id INT,
    PRIMARY KEY (utilisateur_id, trajet_id),
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id),
    FOREIGN KEY (trajet_id) REFERENCES Trajet(id)
);
