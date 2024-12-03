# Algoritmo genético para replicación de imágenes estilizadas

Código de proyecto: GAFSIR (Genetic Algorithm for Stylized Image replication)

_Franco Yudica (13922)_

## Indice

- [Introducción](#introducción)
- [Marco teórico](#marco-teórico)

  - [Algoritmo genético](#algoritmo-genético)
  - [Justificación](#justificación)

- [Bibliografía](#bibliografía)

# Introducción

En este proyecto se ha desarrollado un método para generar imágenes _transformadas estéticamente_ utilizando técnicas de computación evolutivas. Al aplicar un algoritmo genético para replicar una imagen a través de modificaciones iterativas, se busca no solo aproximar la imagen original, sino también explorar una estética única, diferente a otras tales como las foto mosaicos, pointillism, pixelart, entre otros.

Se considera que el abordar el problema mediante el uso de IA es una excelente decisión, debido a que esta se centra en el desarrollo de sistemas capaces de adaptarse y tomar decisiones en función de su entorno, siendo esta una característica últil en los procesos de generación de imágenes.

A continuación se explicarán los fundamentos del algoritmo genético, los motivos por los que se decide usarlo, la implementación del mismo, las métricas utilizadas con el fin de establecer el alcance y rendimiento del algoritmo sobre el problema dado, herramientas de implementación, una descripción de los experimentos y resultados obtenidos, en conjunto con un análisis de los mismos y finalmente conlcusiones sobre el proyecto.

# Marco teórico

## Algoritmo genético

Existe una gran variedad de algoritmos genéticos, pero todos tienen en común la siguiente idea:

Si se cuenta con una población de individuos en un entorno que cuenta con recursos limitados, la competencia entre los individuos por tales recursos produce la supervivencia de los más aptos, también denominada selección natural. Esto causa un aumento en la aptitud de la población remanente.

Dada una función de calidad a maximizar, podemos crear aleatoriamente un conjunto de soluciones candidatas, es decir, elementos del dominio de la función. Luego aplicamos la función de calidad a estas como una medida abstracta de aptitud: cuanto mayor sea, mejor. Con base en estos valores de aptitud, se eligen algunas de las mejores candidatas para sembrar la próxima generación. Esto se realiza aplicando recombinación y/o mutación sobre ellas.

La recombinación es un operador que se aplica a dos o más candidatas seleccionadas (los llamados padres), produciendo una o más nuevas candidatas (los hijos). La mutación se aplica a una candidata y da como resultado una nueva candidata. Por lo tanto, al ejecutar las operaciones de recombinación y mutación sobre los padres, se crea un conjunto de nuevas candidatas (la descendencia). Estas nuevas candidatas tienen su aptitud evaluada y luego compiten, basándose en su aptitud (y posiblemente su edad), con las antiguas por un lugar en la próxima generación. Este proceso puede iterarse hasta que se encuentre una candidata con calidad suficiente (una solución) o se alcance un límite computacional previamente establecido.

Existen dos fuerzas principales que forman la base de los sistemas evolutivos:

- Operadores de variación (recombinación y mutación): crean la diversidad necesaria dentro de la población y, de este modo, facilitan la aparición de novedades.
- Selección: actúa como una fuerza que incrementa la calidad media de las soluciones en la población.

La aplicación combinada de la variación y la selección generalmente conduce a la mejora de los valores de aptitud en poblaciones consecutivas. Es fácil visualizar este proceso como si la evolución estuviera optimizando (o al menos "aproximando") la función de aptitud, acercándose cada vez más a los valores óptimos con el tiempo.

Es importante destacar que muchos componentes de los procesos evolutivos son estocásticos. Por ejemplo, la selección de los mejores individuos no es completamente determinista; incluso los individuos menos aptos suelen tener alguna probabilidad de convertirse en padres o de pasar a la siguiente generación. Durante el proceso de recombinación, la elección de qué atributos de cada padre serán combinados es aleatoria. De manera similar, en el caso de la mutación, la selección de los atributos a modificar en una solución candidata también sigue un comportamiento aleatorio.

[_Introduction to evolutionary computing second edition_](#bibliografía)

## Justificación

En este proyecto se ha optado por utilizar algoritmos genéticos, ya que el proceso de generación de imágenes puede simplificarse como una serie de búsquedas locales.

El problema a resolver se clasifica como una búsqueda local, dado que no se busca la mejor solución absoluta (que en este caso sería la imagen objetivo, la cual se proporciona como parámetro al algoritmo), sino aproximaciones de calidad.

Un algoritmo genético es especialmente adecuado para este problema debido a su capacidad para mantener la diversidad en la población, lo que ayuda a evitar caer en óptimos locales. Además, gracias a los operadores de variación y selección, es posible ampliar el espacio de búsqueda y descubrir soluciones de alta calidad.

**Aspectos adicionales:**

- No es de interés analizar los pasos intermedios que realiza el algoritmo genético para alcanzar la solución.
- El entorno es observable, determinista y estático, lo que lo hace ideal para la aplicación de algoritmos genéticos.
- Los algoritmos genéticos son altamente configurables, lo que permite adaptarlos a diferentes entornos y necesidades. Esta flexibilidad ofrece un amplio margen para explorar diversas estrategias en la generación de imágenes.

# Bibliografía

- [Introduction to evolutionary computing](https://link.springer.com/book/10.1007/978-3-662-44874-8)
- Artificial Intelligence A Modern Approach, Third Edition
- [What is Delta E? And Why Is It Important for Color Accuracy? ](https://www.viewsonic.com/library/creative-work/what-is-delta-e-and-why-is-it-important-for-color-accuracy/)
- [Formulación matemática de _delta e_](http://zschuessler.github.io/DeltaE/learn/)

Papers y proyectos:

- [Inspiración del proyecto](https://www.youtube.com/watch?v=6aXx6RA1IK4)
- [Genetic algorithm for image recreation](https://medium.com/@sebastian.charmot/genetic-algorithm-for-image-recreation-4ca546454aaa). Utilización de _delta e_.

- [Grow Your Own Picture Genetic Algorithms & Generative Art](https://chriscummins.cc/s/genetics/#). Aplicación web para generar imagen con algoritmos genéticos.

- [Procedural paintings with genetic evolution algorithm](https://shahriyarshahrabi.medium.com/procedural-paintings-with-genetic-evolution-algorithm-6838a6e64703). Cálculo de métrica con _delta e_ sobre el espacio [_CIELab_](https://en.wikipedia.org/wiki/CIELAB_color_space), mismos atributos genéticos propuestos en este proyecto y paralelización con [_compute shaders_](https://www.khronos.org/opengl/wiki/Compute_Shader).

- [Genetic drawing](https://github.com/anopara/genetic-drawing). Código fuente para replicar imágenes como pinturas.

- [EllipScape: A Genetic Algorithm Based Approach to Non-Photorealistic Colored Image Reconstruction for Evolutionary Art](https://aisel.aisnet.org/cgi/viewcontent.cgi?article=1613&context=hicss-57). Algoritmo genético completamente distito, pero utiliza como función de fitness y métrica _Peak Signal-to-Noise_
  Ratio (PSNR). Se muestran resultados en cuanto a los tiempos de ejecución y como cambia la función de fitness a lo largo de las generaciones.
