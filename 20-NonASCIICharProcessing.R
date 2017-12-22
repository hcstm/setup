# Importation des fst -----------------------------------------------------
# Modifier le chemin ci-dessous pour indiquer le chemin du répertoire où sont stockés les fst :
data_dir <- "../data"

rp <- data.table::fread(
  file.path(data_dir, "rp_ileDeFrance.csv"), 
  colClasses = rep("character", 46),
  encoding = 'Latin-1')

sirus <- data.table::fread(
  file.path(data_dir, "sirus.csv"), 
  colClasses = rep('character', 41), 
  encoding = 'Latin-1')

# Fonctions utilitaires ---------------------------------------------------
u_codepoint_hex <- function(char) {
  if(length(char) == 0) return(character(0))
  if(length(char) == 1) {
    if(is.na(char)) {
      return(NA_character_)
    } else {
      assertthat::assert_that(nchar(char) == 1)
      paste0("0x", 
             paste0(
               as.character(unlist(iconv(char, localeToCharset()[1], "UNICODEBIG", toRaw = TRUE))),
               collapse=""
             )
      )
    }
  } else {
    vapply(char, u_codepoint_hex, FUN.VALUE = character(1))
  }
}

u_codepoint_int <- function(char) {
  if(length(char) == 0) return(integer(0))
  if(length(char) == 1) {
    if(is.na(char)) {
      return(NA_integer_)
    } else {
      as.integer(as.hexmode(u_codepoint_hex(char)))
    }
  } else {
    vapply(char, u_codepoint_int, FUN.VALUE = integer(1))
  }
}

nb_char <- function(DT, var) {
  get(DT)[
    , .(.I, char_list = strsplit(get(var), ""))
    ][
      , .(char = unlist(char_list))
      ][
        , .N, by = char
        ][
          , .(hex_char = u_codepoint_hex(char), int_char = u_codepoint_int(char), N), 
          by = char
          ][
            order(int_char)
            ]
}


# Analyse de SIRUS --------------------------------------------------------

var_sirus <- colnames(sirus)
tables_char_sirus <- purrr::map2("sirus", var_sirus, nb_char)
names(tables_char_sirus) <- var_sirus
ens_char_sirus <- data.table::rbindlist(tables_char_sirus)[
  , .(N = sum(N)), by = .(char, hex_char, int_char)
  ][
    order(int_char)
    ]
ens_char_sirus



# transfo ASCII -----------------------------------------------------------

to_ascii <- function(x) stringi::stri_trans_general(x, "Latin-ASCII")

nom_col <- colnames(sirus)

for(j in nom_col) data.table::set(sirus, j = j, value = to_ascii(sirus[[j]]))


# Point d'interrogation espagnol ------------------------------------------

champ_char_espagnol <- data.table::rbindlist(tables_char_sirus, idcol = TRUE)[
  int_char == 191, .(champ = .id, char, N)
  ][
    order(champ)
    ]
champ_char_espagnol

champ_like_pattern <- function(champ, pattern) {
  `%like%` <- data.table::`%like%`
  sirus[get(champ) %like% pattern, .(sirus_id, nic, champ = champ, valeur = get(champ))]
}

details_char_espagnol <- 
  purrr::map2(champ_char_espagnol$champ, champ_char_espagnol$char, champ_like_pattern)

espagnol <- data.table::rbindlist(details_char_espagnol)[order(sirus_id, nic)]


# On remplace les N? suivi ou non d'un espace par un N espace
for(j in nom_col) data.table::set(sirus, j = j, value = stringi::stri_replace_all(sirus[[j]], " ", regex = "(?<=N{1}+)\u00bf[ ]*(?=[0123456789])") )
