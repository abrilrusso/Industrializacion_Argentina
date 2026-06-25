library(tidyverse)
library(scales)

datos <- read_csv("input/Participación_de_la_industria_en_el_PBI.csv")

datos_4paises <- datos %>%
  filter(geonombreFundar %in% c("Argentina", "Brasil", "Chile", "México")) %>%
  filter(variable == "share_industrial_gdp") %>%
  filter(anio >= 1970) %>%
  select(anio, geonombreFundar, valor)

datos_extremos <- datos_4paises %>%
  group_by(geonombreFundar) %>%
  filter(anio == 1970 | anio == max(anio)) %>%
  mutate(periodo = if_else(anio == 1970, "1970", "Último dato")) %>%
  ungroup()

orden_paises <- datos_extremos %>%
  filter(periodo == "Último dato") %>%
  arrange(valor) %>%
  pull(geonombreFundar)

datos_extremos <- datos_extremos %>%
  mutate(geonombreFundar = factor(geonombreFundar, levels = orden_paises))

g <- ggplot(datos_extremos, aes(x = valor, y = geonombreFundar)) +

  geom_line(aes(group = geonombreFundar), colour = "gray70", linewidth = 1) +

  geom_point(aes(colour = periodo), size = 4) +

  scale_colour_manual(
    values = c(
      "1970"         = "#4A8A9C",
      "Último dato"  = "#B13507"
    ),
    name = NULL
  ) +

  scale_x_continuous(labels = label_percent(accuracy = 1, decimal.mark = ",")) +

  labs(
    title    = "Caída de la participación de la industria en el PBI",
    subtitle = "1970 vs. último dato disponible, por país",
    x        = "Participación de la industria en el PBI",
    y        = NULL,
    caption  = "Fuente: Argendata (Fundar), a partir de Banco Mundial."
  ) +

  theme_minimal(base_size = 12) +
  theme(
    plot.title       = element_text(face = "bold", size = 13),
    plot.subtitle    = element_text(colour = "gray40", size = 10, margin = margin(b = 12)),
    plot.caption     = element_text(hjust = 0, size = 8, colour = "gray50"),
    axis.ticks       = element_blank(),
    panel.grid.minor   = element_blank(),
    panel.grid.major.y = element_blank(),
    legend.position    = "bottom"
  )

print(g)

ggsave("output/04_pbi_industrial_comparado.png", g, width = 9, height = 5.5, dpi = 300, bg = "white")
