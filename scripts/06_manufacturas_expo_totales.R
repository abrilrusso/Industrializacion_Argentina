library(tidyverse)

datos <- read_csv("input/Participación_de_las_manufacturas_en_las_exportaciones_totales.csv")

datos_arg <- datos %>%
  # La fuente desagrega las exportaciones por nivel tecnológico; se usa
  # "Total manufacturas" porque es el agregado que responde la pregunta
  # del TP (peso de las manufacturas en general, no por categoría).
  filter(geonombreFundar == "Argentina",
         lall_desc_full == "Total manufacturas") %>%
  mutate(prop_pct = prop * 100) %>%
  select(anio, prop_pct)

g <- ggplot(datos_arg, aes(anio, prop_pct)) +

  geom_point(colour = "gray60", size = 1.8, alpha = 0.7) +

  geom_smooth(method = "loess", se = FALSE,
              colour = "#B13507", linewidth = 1.2) +

  scale_x_continuous(breaks = seq(1960, 2020, 10)) +
  scale_y_continuous(labels = function(x) paste0(x, "%")) +

  labs(
    title    = "Participación de las manufacturas en las exportaciones totales",
    subtitle = "Argentina | % de las exportaciones totales | puntos = valores anuales, línea = tendencia (loess)",
    x        = NULL,
    y        = "% de las exportaciones totales",
    caption  = "Fuente: Argendata (Fundar)."
  ) +

  theme_minimal(base_size = 12) +
  theme(
    plot.title       = element_text(face = "bold", size = 13),
    plot.subtitle    = element_text(colour = "gray40", size = 10, margin = margin(b = 12)),
    plot.caption     = element_text(hjust = 0, size = 8, colour = "gray50"),
    axis.ticks       = element_blank(),
    panel.grid.minor   = element_blank(),
    panel.grid.major.x = element_blank()
  )

print(g)

ggsave("output/06_manufacturas_expo_totales.png", g, width = 9, height = 5.5, dpi = 300, bg = "white")
