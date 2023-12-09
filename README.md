# PolyWine
<hr />

### notes 
>```docker-compose : ```
> ```yml
> services:
>   php:
>       depends_on:
>           - mysql
>       networks:
>           - mysql_network
> 
>   nginx:
>       networks:
>           - mysql_network 
> ```
