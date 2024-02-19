CREATE TABLE caves (
    id integer not null AUTO_INCREMENT,
    nom char(50) NOT NULL,
    primary key (id)
);

INSERT INTO caves (nom) VALUES
('Vladou'),
('Gastoun'),
('Melchior'),
('Souhail'),
('Léo'),
('Nathan');


CREATE TABLE bouteilles (
    id integer not null AUTO_INCREMENT,
    nom char(50) NOT NULL,
    cuvee char(50) NOT NULL,
    region char(50) NOT NULL,
    categorie char(50) NOT NULL,
    date_recolte char(50) NOT NULL,
    date_ajout date NOT NULL,
    caveId integer not null,
    primary key (id),
    FOREIGN KEY (caveId) REFERENCES caves(id)
);

INSERT INTO bouteilles (nom, cuvee, region, categorie, date_recolte, date_ajout ,caveId) VALUES
('Vouvray', "domaine d'orsay", "Bordeaux", "rouge", "2020", "2023-12-15",  1);
