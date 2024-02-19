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
    date_recolte char(50) NOT NULL,
    date_ajout date NOT NULL,
    caveId integer not null,
    primary key (id),
    FOREIGN KEY (caveId) REFERENCES caves(id)
);

INSERT INTO bouteilles (nom, cuvee, region, categorie, date_recolte, date_ajout ,caveId) VALUES
('Chardonnay', 'Cuvée Prestige', 'Bourgogne', 'blanc', '2019', '2023-12-16', 2),
('Merlot', 'Château Smith', 'Bordeaux', 'rouge', '2018', '2023-12-17', 3),
('Sauvignon Blanc', 'Domaine de la Vallée', 'Loire', 'blanc', '2021', '2023-12-18', 4),
('Cabernet Sauvignon', 'Grand Réserve', 'Languedoc', 'rouge', '2017', '2023-12-19', 5),
('Pinot Noir', 'Clos du Val', 'Bourgogne', 'rouge', '2019', '2023-12-20', 1),
('Riesling', 'Schloss Johannisberg', 'Alsace', 'blanc', '2020', '2023-12-21', 2),
('Malbec', 'Finca La Linda', 'Mendoza', 'rouge', '2018', '2023-12-22', 3),
('Gewürztraminer', 'Trimbach', 'Alsace', 'blanc', '2019', '2023-12-23', 4),
('Syrah', 'E. Guigal', 'Rhône', 'rouge', '2017', '2023-12-24', 5),
('Sancerre', 'Domaine Vacheron', 'Loire', 'blanc', '2020', '2023-12-25', 1),
('Zinfandel', 'Ridge Vineyards', 'Californie', 'rouge', '2018', '2023-12-26', 2),
('Chenin Blanc', 'Vouvray', 'Loire', 'blanc', '2020', '2023-12-27', 3),
('Tempranillo', 'Bodegas Muga', 'Rioja', 'rouge', '2016', '2023-12-28', 4),
('Viognier', 'Yalumba', 'Australie', 'blanc', '2021', '2023-12-29', 5),
('Côtes-du-Rhône', 'Domaine de la Janasse', 'Rhône', 'rouge', '2019', '2023-12-30', 1),
('Grenache Blanc', 'Château de Beaucastel', 'Rhône', 'blanc', '2020', '2023-12-31', 2),
('Barolo', 'Pio Cesare', 'Piémont', 'rouge', '2015', '2024-01-01', 3),
('Albariño', 'Marqués de Cáceres', 'Rias Baixas', 'blanc', '2021', '2024-01-02', 4),
('Petit Verdot', 'Château Palmer', 'Bordeaux', 'rouge', '2017', '2024-01-03', 5),
('Muscadet', 'Domaine de la Pépière', 'Loire', 'blanc', '2020', '2024-01-04', 1),
('Carménère', 'Concha y Toro', 'Chili', 'rouge', '2018', '2024-01-05', 2),
('Gruner Veltliner', 'Weingut Bründlmayer', 'Autriche', 'blanc', '2019', '2024-01-06', 3),
('Shiraz', 'Penfolds', 'Australie', 'rouge', '2016', '2024-01-07', 4),
('Verdejo', 'Bodegas Naia', 'Rueda', 'blanc', '2020', '2024-01-08', 5),
('Châteauneuf-du-Pape', 'Domaine du Vieux Télégraphe', 'Rhône', 'rouge', '2017', '2024-01-09', 1),
('Pinot Gris', 'Trimbach', 'Alsace', 'blanc', '2018', '2024-01-10', 2),
('Côtes de Provence', 'Château Miraval', 'Provence', 'rosé', '2021', '2024-01-11', 3),
('Amarone della Valpolicella', 'Allegrini', 'Vénétie', 'rouge', '2015', '2024-01-12', 4),
('Chablis', 'Domaine William Fèvre', 'Bourgogne', 'blanc', '2019', '2024-01-13', 5);