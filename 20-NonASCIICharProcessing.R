# Importation des fst -----------------------------------------------------
# Modifier le chemin ci-dessous pour indiquer le chemin du répertoire où sont stockés les fst :
data_dir <- "../data"

rp <- fst::read.fst(
  file.path(data_dir, "rp_ileDeFrance.fst"),
  as.data.table = TRUE)

sirus <- fst::read.fst(
  file.path(data_dir, "sirus.fst"),
  as.data.table = TRUE)
