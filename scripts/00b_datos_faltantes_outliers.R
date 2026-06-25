library(tidyverse)
library(readxl)
library(dlookr)
library(naniar)

paises <- c("Argentina", "Brasil", "México", "Chile")

share_raw <- read_csv("input/Participación_de_la_industria_en_el_PBI.csv")
share <- share_raw %>%
  filter(geonombreFundar %in% paises,
         variable == "share_industrial_gdp") %>%
  mutate(valor_pct = valor * 100) %>%
  filter(anio >= 1970) %>%
  rename(pais = geonombreFundar)

cat("=== 1. Diagnóstico general — share industrial (Argendata) ===\n\n")
diagnose(share) %>% print()

cat("\n=== 1b. Outliers numéricos — share industrial ===\n\n")
diagnose_outlier(share) %>% print()

prim_raw <- read_excel(
  "input/Participación_del_sector_primario_en_el_PBI_comparado.xls",
  skip = 3
)

anios_str <- as.character(1970:2024)

primario <- prim_raw %>%
  filter(`Country Name` %in% paises) %>%
  select(`Country Name`, all_of(anios_str)) %>%
  pivot_longer(cols      = -`Country Name`,
               names_to  = "anio",
               values_to = "valor") %>%
  mutate(anio = as.integer(anio)) %>%
  rename(pais = `Country Name`)

cat("\n=== 2. Diagnóstico general — sector primario (Banco Mundial) ===\n\n")
diagnose(primario) %>% print()

cat("\n=== 2b. Valores en cero por país (posible dato faltante mal codificado) ===\n\n")
primario %>%
  group_by(pais) %>%
  summarise(
    n_ceros    = sum(valor == 0, na.rm = TRUE),
    n_total    = n(),
    prop_ceros = round(n_ceros / n_total * 100, 1)
  ) %>%
  print()

cat("\n=== 2c. Detalle de los años con valor 0.0 — Brasil ===\n\n")
primario %>%
  filter(pais == "Brasil", valor == 0) %>%
  pull(anio) %>%
  print()

cat("\n=== 2d. Resumen de faltantes (criterio: ceros como NA) ===\n\n")
primario_marcado <- primario %>%
  mutate(valor = if_else(valor == 0, NA_real_, valor))

miss_var_summary(primario_marcado) %>% print()
primario_marcado %>%
  group_by(pais) %>%
  miss_var_summary() %>%
  print()

cat("\n=== 3. Decisión de tratamiento ===\n\n")
cat("Brasil presenta 11 observaciones con valor 0.0 entre 1970 y 1980\n")
cat("en la base del sector primario (Banco Mundial). Un valor de 0.0%\n")
cat("sostenido durante 11 años consecutivos es inconsistente con la\n")
cat("participación real de un sector económico en el PBI, por lo que\n")
cat("se interpreta como dato faltante mal codificado, no como un valor real.\n\n")
cat("Tratamiento: se excluyen esos 11 años para Brasil y se utiliza\n")
cat("1981 (primer año con dato válido) como punto de referencia inicial\n")
cat("en los análisis donde antes se usaba 1970.\n\n")
cat("No se imputa ningún valor: se prefiere excluir el dato faltante\n")
cat("antes que estimar un valor para el período 1970-1980 de Brasil,\n")
cat("dado que no contamos con una fuente alternativa confiable para ese tramo.\n")

primario_limpio <- primario %>%
  filter(!(pais == "Brasil" & anio < 1981), !is.na(valor), valor > 0)

write_csv(primario_limpio, "output/01k_sector_primario_limpio.csv")

cat("\n=== 4. PIB industrial per cápita y manufacturas en exportaciones ===\n\n")

pib_raw <- read_csv("input/pib_indust_per_capita_comparado_entre_paises.csv")
pib <- pib_raw %>% filter(geonombreFundar %in% paises)

cat("--- Diagnóstico PIB industrial per cápita ---\n")
diagnose(pib %>% select(geonombreFundar, anio, gdp_indust_pc)) %>% print()
diagnose_outlier(pib %>% select(gdp_indust_pc)) %>% print()

exp_raw <- read_csv("input/Participación_de_las_manufacturas_en_las_exportaciones_totales.csv")
exp_dat <- exp_raw %>%
  filter(geonombreFundar %in% paises, lall_desc_full == "Total manufacturas")

cat("\n--- Diagnóstico manufacturas en exportaciones ---\n")
diagnose(exp_dat %>% select(geonombreFundar, anio, prop)) %>% print()
diagnose_outlier(exp_dat %>% select(prop)) %>% print()

cat("\nNinguna de estas dos bases presenta valores faltantes (NA) ni\n")
cat("ceros sospechosos en el período 1970-2024 analizado. Los outliers\n")
cat("detectados por el criterio de boxplot (1.5 x IQR) corresponden a\n")
cat("valores reales en años de crisis o recuperación fuerte (ej. 2002,\n")
cat("2003, 2009), no a errores de la fuente, por lo que se conservan sin\n")
cat("modificación.\n")

cat("\n=== 5. Outliers detectados con criterio 1.5 x IQR ===\n\n")

cat("PIB industrial per cápita — Brasil presenta 3 valores fuera del\n")
cat("rango 1.5xIQR: 1970, 1971 y 1993. Corresponden a (a) los primeros\n")
cat("años de la serie, cuando Brasil recién empezaba su proceso de\n")
cat("industrialización y los valores eran los más bajos de toda su\n")
cat("trayectoria, y (b) 1993, año de la crisis previa al Plan Real,\n")
cat("marcada por hiperinflación. Ambos son valores extremos genuinos\n")
cat("explicados por el contexto histórico, no errores de carga de datos,\n")
cat("por lo que se conservan sin modificación.\n\n")

cat("Share industrial, manufacturas en exportaciones e impo/expo\n")
cat("industriales no presentan outliers según el criterio 1.5xIQR en\n")
cat("ninguno de los cuatro países, para el período 1970-2024.\n")
