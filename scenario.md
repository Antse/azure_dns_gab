# Detailled scenario
## Faire une resolution local avec l'adresse IP 
```
C:\ ping 10.0.20.4
C:\ iexplore http://10.0.20.4
```
## Faire une résolution avec le nom de domaine fournis pas azure
```
$ dig vm-lin-dns1.rr3t5a3kkxtu1g12n5skakoyxa.ax.internal.cloudapp.net +short
```
## Faire une résolution avec le nom de la machine et la zone custom
```
C:\ nslookup vm-lin-web01.app.gab2019.local
```
## Ajouter une record A dans la zone custom
 - Aller sur le portail azure, dans la zone DNS app.gab2019.local
 - Créér le record set www
 - Modifier le TTL à 1 seconde
 - Ajouter l'adresse IP
## Faire une résolition de nom avec le record créée 
```
C:\ nslookup www.app.gab2019.local
```
## Modifier le record A dans la zone custom
 - Aller sur le portail azure, dans la zone DNS app.gab2019.local
 - Modifier l'enregistreùent www
## Faire une nouvelle resolution
```
C:\ nslookup www.app.gab2019.local
C:\ iexplore http://www.app.gab2019.local
```

