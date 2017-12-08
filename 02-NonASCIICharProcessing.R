# Importation des fst -----------------------------------------------------
data_dir <- "../Hackathon/data"

rp <- fst::read.fst(
  file.path(data_dir, "rp_ileDeFrance.fst"),
  as.data.table = TRUE)

sirus <- fst::read.fst(
  file.path(data_dir, "sirus.fst"),
  as.data.table = TRUE)
