paquetes <- c("tidyverse", "scales", "readxl", "dlookr", "naniar", "zoo")

paquetes_faltantes <- paquetes[!paquetes %in% installed.packages()[, "Package"]]

if (length(paquetes_faltantes) > 0) {
  install.packages(paquetes_faltantes)
}
