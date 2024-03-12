## Maquettes

<a href="https://www.figma.com/proto/3vyjWRazGmI9xCGPG7ij4v?node-id=0-1&t=0FpNm5Ffpij5tY2E-6"> 
Lien des maquettes 
</a>

## commandes FLUTTER
> *Voir l'état du SDK* 
> - `flutter doctor`

> *Lancer l'application* 
> - `flutter run ./front/lib/main.dart`

> *Si erreur de dépendance : que flutter ne trouve pas les paquets (exemple: provider)* 
> - `cd front`
> - `flutter clean`
> - `flutter pub get`


## flutter http <> api flask
> *changer l'url dans le fichier `front/lib/pages/fetch/url.dart`* 
> - `final String url = 'http://mon_ipv4:5001/';`
> <br /> il faut être sur le même réseau que le smartphone (comme par exemple être sur un partage de connexion du smartphone)
> *Pour connaitre son adresse ipV4*
> - MAC :
>   - `ifconfig | grep "inet "`
>   - ou
>   - `ipconfig getifaddr en0`
> - Linux : (avec net-tools)
>   - `ìfconfig`
>   - ou
>   - `ip -a`
> - Windows
>   - `ipconfig`    
   


## commandes GIT
> *Cloner le repository* 
> - `git clone git@github.com:gastonduault/PolyWine.git`

> *Voir l'état du dépôt local (voir si on a fait des modifications) :* 
> - `git status`

> *pour push ses modifications :* 
> - `git add --all`
> - `git commit -m "nom du commit"`
> - `git push origin nom_de_la_branch`

> *pour mettre à jour*
>- `git pull origin nom_de_la_branch`

> *Voir sur quel branch on est*
>- `git branch`

> *Changer de branch*
>- `git checkout nom_de_la_branch`

> *Créer une branche (qui sera une copie de la branche sur laquelle on est*
>- `git checkout -b nom_nouvelle_branch`
