library(tidyverse)
library(zoo)

share_raw <- read_csv("input/Participación_de_la_industria_en_el_PBI.csv")

datos <- share_raw %>%
  filter(geonombreFundar == "Argentina",
         variable == "share_industrial_gdp") %>%
  mutate(valor_pct = valor * 100) %>%
  filter(anio >= 1970) %>%
  arrange(anio)

datos <- datos %>%
  # stl() (visto en clase para descomposición de tendencia) exige una
  # frecuencia estacional (mensual/trimestral) y no se puede aplicar a
  # series anuales. Como adaptación, se usa rollmean() (zoo, clase 15)
  # para extraer la tendencia en su lugar. Aclarado con Nico.
  # k = 7 (ventana centrada) deja sin valor de tendencia los primeros y
  # los últimos 3 años de la serie (quedan como NA).
  mutate(
    tendencia = rollmean(valor_pct, k = 7, fill = NA, align = "center"),
    residuo   = valor_pct - tendencia
  )

g_desc <- ggplot(datos, aes(anio)) +
  geom_line(aes(y = valor_pct, colour = "Serie observada"), linewidth = 0.6) +
  geom_line(aes(y = tendencia, colour = "Tendencia (promedio móvil)"), linewidth = 1.2) +
  scale_colour_manual(
    values = c("Serie observada" = "gray60", "Tendencia (promedio móvil)" = "#B13507"),
    name = NULL
  ) +
  scale_y_continuous(labels = function(x) paste0(x, "%")) +
  labs(
    title    = "Participación industrial en el PBI: serie observada y tendencia",
    subtitle = "Argentina (1970-2024) | promedio móvil centrado de 7 años",
    x = NULL,
    y = "% del PBI",
    caption = "Fuente: Argendata (Fundar)."
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(colour = "gray40", size = 10, margin = margin(b = 12)),
    plot.caption  = element_text(hjust = 0, size = 8, colour = "gray50"),
    legend.position = "bottom"
  )

print(g_desc)

g_resid <- ggplot(datos, aes(anio, residuo)) +
  geom_col(fill = "#4A8A9C") +
  geom_hline(yintercept = 0, colour = "gray40", linewidth = 0.4) +
  scale_y_continuous(labels = function(x) paste0(x, " pp")) +
  labs(
    title    = "Residuo de la tendencia: shocks puntuales",
    subtitle = "Diferencia entre la serie observada y su tendencia (puntos porcentuales)",
    x = NULL,
    y = "Residuo (pp)",
    caption = "Fuente: Argendata (Fundar)."
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(colour = "gray40", size = 10, margin = margin(b = 12)),
    plot.caption  = element_text(hjust = 0, size = 8, colour = "gray50")
  )

print(g_resid)

ggsave("output/07a_tendencia.png", g_desc, width = 9, height = 5.5, dpi = 300, bg = "white")
ggsave("output/07b_residuo.png", g_resid, width = 9, height = 5.5, dpi = 300, bg = "white")

write_csv(datos, "output/07c_descomposicion.csv")
