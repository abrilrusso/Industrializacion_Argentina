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

### Herramientas metodológicas 🛠️
- Indexación de series con base 1970 = 100
- Cálculo de tasas de variación acumulada por subperíodos
- Descomposición STL
- Welch T-test para comparación entre países

## Estructura del repositorio 📁
```bash
Industria argentina/
├── raw/        # Bases originales descargadas
├── auxiliar/   # Bases complementarias
├── input/      # Bases limpias y procesadas
├── output/     # Gráficos, tablas y resultados
├── scripts/    # Scripts del proyecto
├── utils/      # Funciones auxiliares
└── README.md   # Documentación del proyecto
```

## Instrucciones de reproducción
### Paquetes necesarios


## Conclusiones
