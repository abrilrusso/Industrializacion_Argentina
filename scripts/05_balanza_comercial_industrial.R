library(tidyverse)
library(scales)

datos <- read_csv("input/Evolución_de_las_importaciones_y_las_exportaciones_industriales.csv")

datos_arg <- datos %>%
  filter(geonombreFundar == "Argentina") %>%
  select(anio, flujo, valores_constantes)

g <- ggplot(datos_arg, aes(anio, valores_constantes, colour = flujo)) +

  geom_line(linewidth = 1.1) +

  scale_colour_manual(
    values = c(
      "Exportaciones industriales" = "#B13507",
      "Importaciones industriales" = "#4A8A9C"
    ),
    name = NULL
  ) +

  scale_x_continuous(breaks = seq(1960, 2020, 10)) +
  scale_y_continuous(labels = label_number(big.mark = ".", decimal.mark = ",")) +

  labs(
    title    = "Importaciones y exportaciones industriales de Argentina",
    subtitle = "Valores constantes (millones de USD) | 1962-2023",
    x        = NULL,
    y        = "Millones de USD constantes",
    caption  = "Fuente: Argendata (Fundar)."
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

ggsave("output/05_balanza_comercial_industrial.png", g, width = 9, height = 5.5, dpi = 300, bg = "white")
