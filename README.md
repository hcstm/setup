# setup
Des programmes à faire tourner avant le Hackathon

`01-csv2fst.R` : pour sauvegarder les fichiers `csv` au format `fst`. Très utile si vous avez un `SSD` sur lequel stocker les `fst`. N'oubliez pas de régler le paramètre de compression (arbitrage taille des fichiers/rapidité de chargement). Avec un paramètre de compression à 0, la taille des `fst` double presque par rapport au `csv`, mais le temps de chargement des données est ensuite le plus rapide.
