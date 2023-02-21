<!-- vim: set spelllang=fr: -->
# Pionnières de l’informatique

Cette série d’affiches illustre le portrait et une courte biographie de quatre femmes pionnières de l’informatique:
[Margaret Hamilton](https://en.wikipedia.org/wiki/Margaret_Hamilton_(software_engineer)),
[Grace Hopper](https://en.wikipedia.org/wiki/Grace_Hopper),
[Katherine Johnson](https://en.wikipedia.org/wiki/Katherine_Johnson)
et [Ada Lovelace](https://en.wikipedia.org/wiki/Ada_Lovelace).
Elle a été produite en février 2023 et est présentement affichée dans le [local des clubs parascolaires](https://wiki.aediroum.ca/wiki/Local_des_clubs_parascolaires) au pavillon André-Aisenstadt.

<a href="https://wiki.aediroum.ca/images/4/47/Affiche-Pionni%C3%A8res-Hamilton.jpg" target="_blank"><img alt="Affiche de Margaret Hamilton" src="https://wiki.aediroum.ca/images/4/47/Affiche-Pionni%C3%A8res-Hamilton.jpg" width="180"></a>
<a href="https://wiki.aediroum.ca/images/5/52/Affiche-Pionni%C3%A8res-Hopper.jpg" target="_blank"><img alt="Affiche de Grace Hopper" src="https://wiki.aediroum.ca/images/5/52/Affiche-Pionni%C3%A8res-Hopper.jpg" width="180"></a>
<a href="https://wiki.aediroum.ca/images/1/1f/Affiche-Pionni%C3%A8res-Johnson.jpg" target="_blank"><img alt="Affiche de Katherine Johnson" src="https://wiki.aediroum.ca/images/1/1f/Affiche-Pionni%C3%A8res-Johnson.jpg" width="180"></a>
<a href="https://wiki.aediroum.ca/images/7/70/Affiche-Pionni%C3%A8res-Lovelace.jpg" target="_blank"><img alt="Affiche de Ada Lovelace" src="https://wiki.aediroum.ca/images/7/70/Affiche-Pionni%C3%A8res-Lovelace.jpg" width="180"></a>

## Compilation

Les affiches ont été préparées avec LuaLaTeX.
Pour compiler les affiches, la commande suivante peut être utilisée:

```console
latexmk -lualatex -output-directory=build poster
```

La police [Concourse](https://mbtype.com/fonts/concourse/) (non-libre) doit être installée pour pouvoir compiler.
Sinon, vous pouvez la remplacer par une autre police de votre choix en modifiant [le fichier `poster.cls`](poster.cls).

## Sources

* Extraits biographiques adaptés de Wikipédia en date du 11 février 2023.
* Portraits:
    - [Margaret Hamilton: MIT Museum, restauration par Adam Cuerden](https://commons.wikimedia.org/wiki/File:Margaret_Hamilton_-_restoration.jpg)
    - [Grace Hopper: National Museum of American History, Archives Center](https://edan.si.edu/slideshow/viewer/?eadrefid=NMAH.AC.0324_ref162)
    - [Katherine Johnson: NASA](https://www.nasa.gov/langley/100/launching-the-space-race-katherine-johnson)
    - [Ada Lovelace: Computer History Museum](https://www.computerhistory.org/collections/catalog/102622933)

## Licence

Cette œuvre réalisée par Mattéo Delabre a été publiée au Québec et est diffusée sous licence CC0.
