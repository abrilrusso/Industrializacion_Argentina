# Industria Argentina: ¿crisis o transformacion?
## Presentacion 
-Integrantes: Abril Russo Bergara y Franco Nicolas Croce

-Materia: Ciencia de Datos para Economía y Negocios

-Profesor: Nicolas Sidicario

-Facultad de Ciencias Económicas - UBA

## Descripcion del proyecto💡

Este proyecto surge del trabajo de dos estudiantes de la Facultad de Ciencias Económicas, guiados por nuestro profesor de Ciencia de Datos, con el objetivo de analizar la evolución de la industria argentina a lo largo de las últimas décadas.

A través del análisis de datos, visualizaciones y herramientas estadísticas, buscamos estudiar el comportamiento del sector industrial para identificar patrones, transformaciones y posibles períodos de crecimiento o retroceso. Asimismo, realizamos una comparación con otros países de América Latina con el fin de contextualizar el caso argentino dentro de una dinámica regional más amplia.

Nuestro objetivo es aportar evidencia basada en datos para comprender mejor las transformaciones productivas del país y su posicionamiento en la región.

## Hipótesis de trabajo 🕵️‍♀️
### Hipotesis principal 
En los últimos cincuenta años, Argentina experimentó un proceso de desindustrialización que deterioró su capacidad productiva industrial real, alejándola de la trayectoria de crecimiento sostenido que lograron mantener países de la región como Brasil y México.

### Hipotesis complementaria
La reducción del peso de la industria en la economía argentina responde principalmente a un proceso de reprimarización. El crecimiento de sectores primarios (favorecidos por cambios en los precios internacionales y la expansión de actividades como el agro y la energía) habría disminuido la participación relativa de la industria en el PBI, sin implicar necesariamente una caída absoluta de la producción industrial.

## Bases de datos utilizadas 📊
### Fuente principal
- [Argendata] (https://argendata.fund.ar/topico/industria/) 

### Fuentes auxiliares
- [Banco Mundial] (https://datos.bancomundial.org/indicador/NV.AGR.TOTL.ZS) 
- [Comision Europea] (https://composite-indicators.jrc.ec.europa.eu/explorer/indices/cipi/competitive-industrial-performance-index)
### Período trabajado ⏳

1970–2024

### Variables principales
-PBI industrial per cápita

-Participación de la industria en el PBI 

-Participación del sector primario en el PBI 

-Participación de manufacturas en exportaciones totales 

-Importaciones y exportaciones industriales 

-Índice de desempeño industrial competitivo

### Paises analizados 🌎
- Argentina
- Brasil
- Chile
- Mexico

## Estrategia de análisis 📚
En una primera etapa, estudiamos la evolución del sector industrial argentino a partir de indicadores como la participación de la industria en el PBI y el PBI industrial per cápita.

Luego, comparamos la trayectoria argentina con la de otros países de América Latina para evaluar si su desempeño responde a una tendencia regional o  a  una dinámica particular.

Por último, aplicamos herramientas de análisis temporal e inferencia estadística para distinguir entre cambios estructurales de largo plazo y fluctuaciones temporales asociadas a shocks económicos.

### Librerias requeridas 💻
- tidyverse
- readxl
- scales
- zoo

### Herramientas metodológicas 🛠️
- Indexación de series (base 1970 = 100): permite comparar variables con distinta escala.
- Tasas de variación acumuladas: mide cambios por subperíodos.
- Descomposición STL: separa tendencia, estacionalidad y ruido.
- Prueba T de Welch: evalúa diferencias entre países


## Estructura del repositorio 📁
```bash
Industria argentina/
├── raw/        # Bases originales descargadas
├── auxiliar/   # Bases complementarias
├── output/     # Gráficos, tablas y resultados
├── scripts/    # Scripts del proyecto
└── README.md   # Documentación del proyecto
```

## Instrucciones de reproducción



## Conclusiones 📝
La evidencia respalda la hipótesis principal: Argentina atravesó un proceso de desindustrialización estructural, y no una simple transformación hacia otros sectores. Tres resultados lo confirman:

1. Argentina es el único de los cuatro países que en 2024 produce menos industria por habitante que en 1970 (-17,6%), mientras Brasil, México  y Chile crecieron entre 44% y 86% en el mismo período.

2. El promedio móvil muestra que la caída no fue un evento puntual: la tendencia bajó de forma sostenida desde 30,4% en 1973 hasta 17,95% en 2021, sin recuperación duradera en ningún tramo de más de cinco décadas. Las crisis de 1989 y 2001 generaron desvíos fuertes pero acotados en el tiempo, lo que confirma que son shocks puntuales sobre una tendencia que ya venía cayendo, y no la causa de fondo.

3. La hipótesis complementaria de reprimarización se descarta: el sector primario también perdió participación en el PBI (de 9,6% en 1970 a 5,8% en 2024), por lo que el agro no explica el retroceso industrial.

En síntesis, no se trató de una transformación productiva saludable donde la industria cede lugar a otros sectores en crecimiento, sino de una pérdida de capacidad productiva real y sostenida en el tiempo, agravada (pero no causada) por las crisis macroeconómicas del período.

