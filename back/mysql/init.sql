CREATE TABLE caves (
    id integer not null AUTO_INCREMENT,
    nom char(50) NOT NULL unique,
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
    date_recolte integer NOT NULL,
    caveId integer not null,
    emplacement integer,
    primary key (id),
    FOREIGN KEY (caveId) REFERENCES caves(id)
);

CREATE TABLE historique (
    id integer not null AUTO_INCREMENT,
    nom char(50) NOT NULL,
    cuvee char(50) NOT NULL,
    region char(50) NOT NULL,
    categorie char(50) NOT NULL,
    date_recolte integer NOT NULL,
    caveId integer not null,
    emplacement integer,
    primary key (id),
    FOREIGN KEY (caveId) REFERENCES caves(id)
);

-- INSERT INTO historique (nom, cuvee, region, categorie, date_recolte, caveId, emplacement) VALUES
-- ('Chardonnay', 'Cuvée Prestige', 'Bourgogne', 'blanc', 1990, 2, 0),
-- ('Merlot', 'Château Smith', 'Bordeaux', 'rouge', 2018, 3, 0),
-- ('Sauvignon Blanc', 'Domaine de la Vallée', 'Loire', 'blanc', 2020, 4, 0),
-- ('Cabernet Sauvignon', 'Grand Réserve', 'Languedoc', 'rouge', 2017, 5, 0);
-- ('Pinot Noir', 'Clos du Val', 'Bourgogne', 'rouge', 1990, 1, 0),
-- ('Riesling', 'Schloss Johannisberg', 'Alsace', 'blanc', 2020, 2, 1),
-- ('Malbec', 'Finca La Linda', 'Mendoza', 'rouge', 2018, 3, 1),
-- ('Gewürztraminer', 'Trimbach', 'Alsace', 'blanc', 1990, 4, 1),
-- ('Syrah', 'E. Guigal', 'Rhône', 'rouge', 2017, 5, 1),
-- ('Sancerre', 'Domaine Vacheron', 'Loire', 'blanc', 2020, 1, 1),
-- ('Zinfandel', 'Ridge Vineyards', 'Californie', 'rouge', 2018, 2, 2),
-- ('Chenin Blanc', 'Vouvray', 'Loire', 'blanc', 2020, 3, 2),
-- ('Tempranillo', 'Bodegas Muga', 'Rioja', 'rouge', 2016, 4, 2),
-- ('Viognier', 'Yalumba', 'Australie', 'blanc', 2021, 5, 2),
-- ('Côtes-du-Rhône', 'Domaine de la Janasse', 'Rhône', 'rouge', 2019, 1, 2),
-- ('Grenache Blanc', 'Château de Beaucastel', 'Rhône', 'blanc', 2020, 2, 3),
-- ('Barolo', 'Pio Cesare', 'Piémont', 'rouge', 2015, 3, 3),
-- ('Albariño', 'Marqués de Cáceres', 'Rias Baixas', 'blanc', 2021, 4, 3),
-- ('Petit Verdot', 'Château Palmer', 'Bordeaux', 'rouge', 2017, 5, 3),
-- ('Muscadet', 'Domaine de la Pépière', 'Loire', 'blanc', 2020, 1, 3),
-- ('Carménère', 'Concha y Toro', 'Chili', 'rouge', 2018, 2, 4),
-- ('Gruner Veltliner', 'Weingut Bründlmayer', 'Autriche', 'blanc', 2019, 3, 4),
-- ('Shiraz', 'Penfolds', 'Australie', 'rouge', 2016, 4, 4),
-- ('Verdejo', 'Bodegas Naia', 'Rueda', 'blanc', 2020, 5, 4),
-- ('Châteauneuf-du-Pape', 'Domaine du Vieux Télégraphe', 'Rhône', 'rouge', 2017, 1, 4),
-- ('Pinot Gris', 'Trimbach', 'Alsace', 'blanc', 2018, 2, 5),
-- ('Côtes de Provence', 'Château Miraval', 'Provence', 'rosé', 2021, 3, 5),
-- ('Amarone della Valpolicella', 'Allegrini', 'Vénétie', 'rouge', 2015, 4, 5),
-- ('Chablis', 'Domaine William Fèvre', 'Bourgogne', 'blanc', 2019, 5, 5);

