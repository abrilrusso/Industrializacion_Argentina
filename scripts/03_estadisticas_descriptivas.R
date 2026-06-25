library(tidyverse)
library(readxl)

paises <- c("Argentina", "Brasil", "México", "Chile")

pib <- read_csv("input/pib_indust_per_capita_comparado_entre_paises.csv") %>%
  filter(geonombreFundar %in% paises) %>%
  rename(pais = geonombreFundar)

tabla_pib <- pib %>%
  group_by(pais) %>%
  summarise(
    n       = n(),
    media   = round(mean(gdp_indust_pc), 1),
    mediana = round(median(gdp_indust_pc), 1),
    desvio  = round(sd(gdp_indust_pc), 1),
    cv_pct  = round(sd(gdp_indust_pc) / mean(gdp_indust_pc) * 100, 1),
    minimo  = round(min(gdp_indust_pc), 1),
    maximo  = round(max(gdp_indust_pc), 1)
  )

cat("=== 1. PIB industrial per cápita (USD constantes de 2015) ===\n\n")
print(tabla_pib)

arg <- pib %>% filter(pais == "Argentina")

subperiodos <- list(c(1970, 1990), c(1990, 2003), c(2003, 2011), c(2011, 2024))

# Se busca el año disponible más cercano a cada límite de subperíodo, por si
# el año exacto no tiene dato cargado en la fuente.
tasas_subperiodo <- map_dfr(subperiodos, function(sp) {
  yr_ini      <- sp[1]; yr_fin <- sp[2]
  yr_ini_real <- arg$anio[which.min(abs(arg$anio - yr_ini))]
  yr_fin_real <- arg$anio[which.min(abs(arg$anio - yr_fin))]
  val_ini     <- arg$gdp_indust_pc[arg$anio == yr_ini_real]
  val_fin     <- arg$gdp_indust_pc[arg$anio == yr_fin_real]
  tasa        <- round((val_fin / val_ini - 1) * 100, 1)
  tibble(subperiodo = paste0(yr_ini, "-", yr_fin), tasa_pct = tasa)
})

cat("\n--- Variación acumulada por subperíodo — Argentina ---\n")
print(tasas_subperiodo)

share <- read_csv("input/Participación_de_la_industria_en_el_PBI.csv") %>%
  filter(geonombreFundar %in% paises,
         variable == "share_industrial_gdp") %>%
  rename(pais = geonombreFundar) %>%
  mutate(valor_pct = valor * 100)

tabla_share <- share %>%
  group_by(pais) %>%
  summarise(
    media    = round(mean(valor_pct), 2),
    mediana  = round(median(valor_pct), 2),
    desvio   = round(sd(valor_pct), 2),
    cv_pct   = round(sd(valor_pct) / mean(valor_pct) * 100, 2),
    val_1970 = round(valor_pct[anio == 1970], 2),
    val_fin  = round(valor_pct[anio == max(anio)], 2),
    anio_fin = max(anio)
  )

cat("\n\n=== 2. Participación industria en el PBI (%) ===\n\n")
print(tabla_share)

# skip = 3 porque el archivo del Banco Mundial trae 3 filas de encabezado
# antes de la tabla con los datos por país y año.
prim_raw <- read_excel(
  "input/Participación_del_sector_primario_en_el_PBI_ARG.xls",
  skip = 3
)

anios_str <- as.character(1970:2024)

prim_arg <- prim_raw %>%
  filter(`Country Name` == "Argentina") %>%
  select(all_of(anios_str)) %>%
  pivot_longer(cols      = everything(),
               names_to  = "anio",
               values_to = "valor") %>%
  mutate(anio = as.integer(anio)) %>%
  filter(!is.na(valor))

tabla_primario <- prim_arg %>%
  summarise(
    n        = n(),
    media    = round(mean(valor), 2),
    mediana  = round(median(valor), 2),
    desvio   = round(sd(valor), 2),
    minimo   = round(min(valor), 2),
    maximo   = round(max(valor), 2),
    val_1970 = round(valor[anio == 1970], 2),
    val_fin  = round(valor[anio == max(anio)], 2),
    anio_fin = max(anio)
  )

cat("\n\n=== 3. Sector primario en el PBI — Argentina (%) ===\n\n")
print(tabla_primario)

exp_dat <- read_csv("input/Participación_de_las_manufacturas_en_las_exportaciones_totales.csv") %>%
  filter(geonombreFundar %in% paises,
         lall_desc_full == "Total manufacturas") %>%
  rename(pais = geonombreFundar) %>%
  mutate(prop_pct = prop * 100)

tabla_exportaciones <- exp_dat %>%
  group_by(pais) %>%
  summarise(
    media    = round(mean(prop_pct), 2),
    mediana  = round(median(prop_pct), 2),
    desvio   = round(sd(prop_pct), 2),
    cv_pct   = round(sd(prop_pct) / mean(prop_pct) * 100, 2),
    val_ini  = round(prop_pct[anio == min(anio)], 2),
    val_fin  = round(prop_pct[anio == max(anio)], 2),
    anio_ini = min(anio),
    anio_fin = max(anio)
  )

cat("\n\n=== 4. Manufacturas en exportaciones totales (%) ===\n\n")
print(tabla_exportaciones)

write_csv(tabla_pib, "output/03a_tabla_pib_industrial.csv")
write_csv(tasas_subperiodo, "output/03b_tasas_subperiodo_argentina.csv")
write_csv(tabla_share, "output/03c_tabla_share_industrial.csv")
write_csv(tabla_primario, "output/03d_tabla_sector_primario.csv")
write_csv(tabla_exportaciones, "output/03e_tabla_exportaciones.csv")
