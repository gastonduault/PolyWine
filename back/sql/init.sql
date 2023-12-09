CREATE TABLE caves (
    id integer not null AUTO_INCREMENT,
    name char(50) NOT NULL,
    primary key (id)
);

INSERT INTO caves (name) VALUES
('Vladou'),
('Gastoun'),
('Nathan');


CREATE TABLE bouteilles (
    id integer not null AUTO_INCREMENT,
    name char(50) NOT NULL,
    region char(50) NOT NULL,
    categorie char(50) NOT NULL,
    caveId integer not null,
    primary key (userId),
    FOREIGN KEY (caveId) REFERENCES caves(id)
);

INSERT INTO caves (name) VALUES
('Vouvray', "domaine d'orsay", "rouge",1);
