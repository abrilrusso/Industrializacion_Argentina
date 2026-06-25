library(tidyverse)
library(readxl)

# skip = 3 porque el archivo del Banco Mundial trae 3 filas de encabezado
# antes de la tabla con los datos por país y año.
prim_raw <- read_excel(
  "input/Participación_del_sector_primario_en_el_PBI_comparado.xls",
  skip = 3
)

anios_str <- as.character(1970:2024)

# Brasil figura con 0.0% en sector primario entre 1968 y 1980 en la fuente
# del Banco Mundial. Se trata como dato faltante mal codificado, no como un
# cero real, así que se descarta con valor > 0 (a diferencia de los otros
# países, donde no hace falta este filtro). Por eso el primer subperíodo
# de este script arranca en 1981 y no en 1970. Punto a aclarar con Nico.
prim_brasil <- prim_raw %>%
  filter(`Country Name` == "Brasil") %>%
  select(all_of(anios_str)) %>%
  pivot_longer(cols      = everything(),
               names_to  = "anio",
               values_to = "valor") %>%
  mutate(anio = as.integer(anio)) %>%
  filter(!is.na(valor), valor > 0)

share_raw <- read_csv("input/Participación_de_la_industria_en_el_PBI.csv")

share_brasil <- share_raw %>%
  filter(geonombreFundar == "Brasil",
         variable == "share_industrial_gdp") %>%
  mutate(valor = valor * 100) %>%
  select(anio, valor) %>%
  mutate(sector = "Industria")

primario_brasil <- prim_brasil %>%
  select(anio, valor) %>%
  mutate(sector = "Sector primario")

subperiodos <- c(1981, 1990, 2003, 2011, 2023)

datos <- bind_rows(share_brasil, primario_brasil) %>%
  filter(anio %in% subperiodos) %>%
  mutate(anio = factor(anio))

g <- ggplot(datos, aes(anio, valor, fill = sector)) +

  geom_col(position = "dodge") +

  scale_fill_manual(
    values = c("Industria" = "#7D5BA6", "Sector primario" = "#E8C547"),
    name   = NULL
  ) +

  scale_y_continuous(labels = function(x) paste0(x, "%")) +

  labs(
    title    = "Industria y sector primario en el PBI de Brasil por subperíodo",
    subtitle = "Participación en el PBI (%) | violeta = industria | amarillo = sector primario",
    x        = NULL,
    y        = "% del PBI",
    caption  = paste0(
      "Fuentes: Argendata (Fundar) — industria. Banco Mundial — sector primario.\n",
      "El primer subperíodo corresponde a 1981, primer año con dato válido de sector primario (1970-1980 figuran como 0 en la fuente)."
    )
  ) +

  theme_minimal(base_size = 12) +
  theme(
    plot.title       = element_text(face = "bold", size = 13),
    plot.subtitle    = element_text(colour = "gray40", size = 10, margin = margin(b = 12)),
    plot.caption     = element_text(hjust = 0, size = 8, colour = "gray50"),
    axis.ticks       = element_blank(),
    panel.grid.minor   = element_blank(),
    panel.grid.major.x = element_blank(),
    legend.position    = "bottom"
  )

print(g)

ggsave("output/01g_exploratorio_brasil.png", g, width = 9, height = 5.5, dpi = 300, bg = "white")
