library(tidyverse)

share_raw <- read_csv("input/Participación_de_la_industria_en_el_PBI.csv")

datos <- share_raw %>%
  filter(geonombreFundar %in% c("Argentina", "Brasil"),
         variable == "share_industrial_gdp") %>%
  mutate(valor_pct = valor * 100) %>%
  filter(anio >= 1970) %>%
  rename(pais = geonombreFundar) %>%
  arrange(pais, anio)

datos <- datos %>%
  group_by(pais) %>%
  mutate(tasa_variacion = valor_pct - lag(valor_pct)) %>%
  ungroup() %>%
  filter(!is.na(tasa_variacion))

cat("=== Descriptivos por país ===\n\n")

datos %>%
  group_by(pais) %>%
  summarise(
    n       = n(),
    media   = round(mean(tasa_variacion), 3),
    sd      = round(sd(tasa_variacion), 3),
    mediana = round(median(tasa_variacion), 3)
  ) %>%
  print()

cat("\n=== T-test de Welch: tasa de variación anual ARG vs BRA ===\n\n")

# t.test() en R usa Welch por defecto (var.equal = FALSE), por eso no hace
# falta pasar ningún argumento extra para que sea Welch y no Student.
test_t <- t.test(tasa_variacion ~ pais, data = datos)
print(test_t)

cat("\n=== Conclusión ===\n\n")
if (test_t$p.value < 0.05) {
  cat("p-valor menor a 0.05: se rechaza H0.\n")
  cat("Las tasas de variación anual difieren significativamente entre Argentina y Brasil.\n")
} else {
  cat("p-valor mayor a 0.05: no se rechaza H0.\n")
  cat("No hay evidencia suficiente de que las tasas difieran entre Argentina y Brasil.\n")
}

write_csv(datos, "output/03_metodo3_tasas_variacion.csv")
