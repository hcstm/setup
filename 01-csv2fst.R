# Vérification des packages installés -------------------------------------

if(!require(data.table)) install.packages("data.table")
if(!require(fst)) install.packages("fst")

# Importation des données ----------------------------------------------------------
# Modifier le chemin ci-dessous pour indiquer le chemin du répertoire où sont stockés les csv :
data_dir <- "../Hackathon/data"

rp <- data.table::fread(
  file.path(data_dir, "rp_ileDeFrance.csv"), 
  colClasses = rep("character", 46),
  encoding = 'Latin-1')

sirus <- data.table::fread(
  file.path(data_dir, "sirus.csv"), 
  colClasses = rep('character', 41), 
  encoding = 'Latin-1')

# Sauvegarde en fst -------------------------------------------------------
fst::write.fst(rp, file.path(data_dir, "rp_ileDeFrance.fst"), compress = 0)
fst::write.fst(sirus, file.path(data_dir, "sirus.fst"), compress = 0)



