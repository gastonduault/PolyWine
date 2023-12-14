# PolyWine

----

## TODO
> #### Vladou
> - **[FINI]** mise en place projet flutter
> - **[EN COURS]** frontend app flutter
> - **[EN COURS]** apprendre flutter
> - **[A COMMENCER]** connection bluethoot flutter <> casier vin

> #### Gaston
> - **[FINI]** Dockerisation mysql & python Flask
> - **[EN COURS]** base de donnée sql
> - **[EN COURS]** requête SQL Flask(SQLAlchemy) <> mysql-service
> - **[A COMMENCER]** requête HTTP Flutter <> Flask
> - **[A COMMENCER]** frontend app flutter



## BACK

>#### endpoints :
>>-  **[POST]** `api/login`
>>      - *send* **json**: `{username, password}`
>>      - *receive* **json**: `{[id_cave, nom_cave]}`
>
>>- **[POST]** `api/signin`
>>     - *send* **json**: `{username, password}`
>
>>- **[POST]** `api/login/cave`
>>     - *send* **json**: `{id_cave}`
>
>>- **[GET]** `api/cave/id`
>>     - Listes des bouteilles
>>     - Nom de la cave (Propriétaire)
>
>>- **[GET]** `api/cave/bouteille/id` 
>>     - Plus d'information sur la bouteille
>>     - *send* **json**: `{id_bouteille}`
>
>>- **[POST]** `api/cave/bouteille`
>>     - ajout / modification d'une bouteille
>>     - *send* **json**: `{nom, region, cuvee, type, annee, url_image}`
>
>>- **[DELETE]** `api/cave/bouteille/id`
>>     - supression d'une bouteille
>>     - *send* **json**: `{id_bouteille}` 
>
>>- **[GET]** `api/cave/historique`
>>     - *send* **json**: `{id_cave}` 
