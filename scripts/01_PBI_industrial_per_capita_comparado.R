library(tidyverse)
library(scales)

owid_rojo <- "#B13507"
owid_azul <- "#4A8A9C"
owid_gris <- "#BDBDBD"

theme_owid <- function(base_size = 13, base_family = "") {
  theme_minimal(base_size = base_size, base_family = base_family) +
    theme(
      plot.title.position   = "plot",
      plot.caption.position = "plot",
      plot.title    = element_text(face = "bold", size = rel(1.35),
                                   colour = "#1d1d1d", lineheight = 1.2,
                                   margin = margin(b = 4)),
      plot.subtitle = element_text(size = rel(1.0), colour = "#5b5b5b",
                                   margin = margin(b = 16)),
      plot.caption  = element_text(hjust = 0, size = rel(0.72),
                                   colour = "#8a8a8a", margin = margin(t = 14)),
      axis.title    = element_blank(),
      axis.text     = element_text(colour = "#5b5b5b"),
      axis.ticks    = element_blank(),
      panel.grid.major.y = element_line(colour = "#e6e6e6", linewidth = 0.4),
      panel.grid.major.x = element_blank(),
      panel.grid.minor   = element_blank(),
      legend.position    = "none",
      plot.margin = margin(t = 14, r = 130, b = 10, l = 16)
    )
}

df_raw <- read_csv("input/pib_indust_per_capita_comparado_entre_paises.csv")

protagonistas <- "Argentina"
contexto      <- c("Brasil", "México", "Chile")

# Se indexa a 1970 = 100 porque es el año base de todo el TP (primer año
# con dato disponible para los 4 países), no un punto elegido al azar.
datos <- df_raw %>%
  filter(geonombreFundar %in% c(protagonistas, contexto)) %>%
  group_by(geonombreFundar) %>%
  arrange(anio) %>%
  mutate(indice = gdp_indust_pc / gdp_indust_pc[anio == 1970] * 100) %>%
  ungroup() %>%
  mutate(grupo = if_else(geonombreFundar %in% protagonistas,
                         geonombreFundar, "Otros"))

fin_arg <- datos %>%
  filter(geonombreFundar == "Argentina", anio == max(anio))

fin_otros <- datos %>%
  filter(grupo == "Otros") %>%
  group_by(geonombreFundar) %>%
  filter(anio == max(anio)) %>%
  ungroup()

g <- ggplot(datos, aes(anio, indice)) +

  # Los períodos resaltados (1976-1990 y 2003-2011) se definen por contexto
  # histórico (dictadura/crisis de deuda y salida de la convertibilidad),
  # no surgen de un test estadístico de quiebre.
  annotate("rect",
           xmin = 1976, xmax = 1990, ymin = -Inf, ymax = Inf,
           fill = owid_rojo, alpha = 0.07) +

  annotate("text",
           x = 1983, y = 198,
           label = "Desindustrialización\n1976-1990",
           colour = owid_rojo, size = 3, lineheight = 0.9, fontface = "bold") +

  geom_hline(yintercept = 100, linetype = "dashed",
             colour = "gray50", linewidth = 0.4) +
  annotate("text",
           x = 2024, y = 104, label = "Nivel de 1970",
           colour = "gray50", hjust = 0, size = 3) +

  geom_line(data = filter(datos, grupo == "Otros"),
            aes(group = geonombreFundar),
            colour = owid_gris, linewidth = 0.7) +

  geom_line(data = filter(datos, grupo != "Otros"),
            colour = owid_rojo, linewidth = 1.3) +

  geom_point(data = fin_arg, colour = owid_rojo, size = 2.5) +

  geom_text(data = fin_arg,
            aes(label = geonombreFundar),
            colour = owid_rojo, hjust = 0, nudge_x = 0.8,
            fontface = "bold", size = 4) +

  geom_text(data = fin_otros,
            aes(label = geonombreFundar),
            colour = "gray50", hjust = 0, nudge_x = 0.8,
            size = 3.5) +

  annotate("text",
           x = 2000, y = 123,
           label = "Recuperación\n2003-2011",
           hjust = 0, colour = owid_azul, size = 3, lineheight = 0.95) +
  annotate("segment",
           x = 2003, y = 117, xend = 2006, yend = 100,
           linewidth = 0.3, colour = owid_azul,
           arrow = arrow(length = unit(1.7, "mm"), type = "closed")) +

  scale_x_continuous(breaks = seq(1970, 2024, 10),
                     expand = expansion(mult = c(0.01, 0.07))) +
  scale_y_continuous(breaks = seq(50, 200, 25)) +
  coord_cartesian(clip = "off") +

  labs(
    title    = "Argentina: menos industria por habitante que en 1970",
    subtitle = "PIB industrial per cápita | índice base 1970 = 100 | USD constantes de 2015",
    caption  = "Fuente: Argendata (Fundar)",
    x = NULL, y = NULL
  ) +
  theme_owid()

print(g)

ggsave("output/01a_grafico_comunicacional.png", g,
       width = 9, height = 5.5, dpi = 300, bg = "white")
