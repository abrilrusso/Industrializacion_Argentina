library(tidyverse)
library(readxl)

# skip = 3 porque el archivo del Banco Mundial trae 3 filas de encabezado
# antes de la tabla con los datos por país y año.
prim_raw <- read_excel(
  "input/Participación_del_sector_primario_en_el_PBI_comparado.xls",
  skip = 3
)

anios_str <- as.character(1970:2024)

prim_chile <- prim_raw %>%
  filter(`Country Name` == "Chile") %>%
  select(all_of(anios_str)) %>%
  pivot_longer(cols      = everything(),
               names_to  = "anio",
               values_to = "valor") %>%
  mutate(anio = as.integer(anio)) %>%
  filter(!is.na(valor))

share_raw <- read_csv("input/Participación_de_la_industria_en_el_PBI.csv")

share_chile <- share_raw %>%
  filter(geonombreFundar == "Chile",
         variable == "share_industrial_gdp") %>%
  mutate(valor = valor * 100) %>%
  select(anio, valor) %>%
  mutate(sector = "Industria")

primario_chile <- prim_chile %>%
  select(anio, valor) %>%
  mutate(sector = "Sector primario")

subperiodos <- c(1970, 1990, 2003, 2011, 2023)

datos <- bind_rows(share_chile, primario_chile) %>%
  filter(anio %in% subperiodos) %>%
  mutate(anio = factor(anio))

g <- ggplot(datos, aes(anio, valor, fill = sector)) +

  geom_col(position = "dodge") +

  scale_fill_manual(
    values = c("Industria" = "#2E5FA3", "Sector primario" = "#C0392B"),
    name   = NULL
  ) +

  scale_y_continuous(labels = function(x) paste0(x, "%")) +

  labs(
    title    = "Industria y sector primario en el PBI de Chile por subperíodo",
    subtitle = "Participación en el PBI (%) | azul = industria | rojo = sector primario",
    x        = NULL,
    y        = "% del PBI",
    caption  = "Fuentes: Argendata (Fundar) — industria. Banco Mundial — sector primario."
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

ggsave("output/01i_exploratorio_chile.png", g, width = 9, height = 5.5, dpi = 300, bg = "white")
