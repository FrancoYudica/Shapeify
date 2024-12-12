# Algoritmo genético para replicación de imágenes estilizadas

Código de proyecto: GAFSIR (Genetic Algorithm for Stylized Image replication)

_Franco Yudica (13922)_

## Indice

- [Introducción](#introducción)
- [Marco teórico](#marco-teórico)

  - [Introducción de algoritmo genético](#introducción-de-algoritmo-genético)
  - [Justificación](#justificación)

- [Diseño experimental](#diseño-experimental)

  - [Implementación](#implementación)
    - [Generación de imagen](#generación-de-imagen)
      - [Algoritmo de generación de individuo](#algoritmo-de-generación-de-individuo)
      - [Construcción de la imagen](#construcción-de-la-imagen)
      - [Condiciones de parada](#condiciones-de-parada)
    - [Algoritmo genético](#algoritmo-genético)
      - [Individuo](#individuo)
        - [Tinte](#tinte)
      - [Función de fitness](#función-de-fitness)
        - [MSE](#mse-mean-squared-error)
        - [MPA](#mpa-mean-power-accuracy)
      - [Inicialización del algoritmo](#inicialización-del-algoritmo)
      - [Operadores](#operadores)
        - [Selección](#selección)
        - [Cruce](#cruce)
        - [Mutación](#mutación)
        - [Selección de sobrevivientes](#selección-de-sobrevivientes)
        - [Criterio de finalización](#criterio-de-finalización)
    - [Algoritmo aleatorio](#algoritmo-aleatorio)
    - [Algoritmo mejor de aleatorios](#algoritmo-mejor-de-aleatorios)
  - [Métrica](#métrica)

    - [Delta E medio](#delta-e-medio)
      - [Cálculo de delta E 1994](#cálculo-de-delta-e-1994)

  - [Herramientas](#herramientas)
  - [Experimentos y resultados obtenidos](#experimentos-y-resultados-obtenidos)
    - [Algoritmo de generación de individuos genético](#algoritmo-de-generación-de-individuos-genético)
      - [Parámetros](#parámetros)
      - [Caso de prueba básico](#caso-de-prueba-básico)
      - [Caso real con Mona Lisa](#caso-real-con-mona-lisa)
      - [Estudio comparativo basado en ejecuciones múltiples del algoritmo](#estudio-comparativo-basado-en-ejecuciones-múltiples-del-algoritmo)
    - [Algoritmo de generación de imagen](#algoritmo-de-generación-de-imagen)
      - [Límite en cantidad de individuos generados](#límite-en-cantidad-de-individuos-generados)
      - [Límite en tiempo de ejecución y cantidad máxima de individuos generados](#límite-en-tiempo-de-ejecución-y-cantidad-máxima-de-individuos-generados)

- [Conclusiones](#conclusiones)

- [Bibliografía](#bibliografía)

# Introducción

En este proyecto se ha desarrollado un método para generar imágenes _transformadas estéticamente_ utilizando técnicas de computación evolutivas. Al aplicar un algoritmo genético para replicar una imagen a través de modificaciones iterativas, se busca no solo aproximar la imagen original, sino también explorar una estética única, diferente a otras tales como las foto mosaicos, pointillism, pixelart, entre otros.

Se considera que el abordar el problema mediante el uso de IA es una excelente decisión, debido a que esta se centra en el desarrollo de sistemas capaces de adaptarse y tomar decisiones en función de su entorno, siendo esta una característica últil en los procesos de generación de imágenes.

A continuación se explicarán los fundamentos del algoritmo genético, los motivos por los que se decide usarlo, la implementación del mismo, las métricas utilizadas con el fin de establecer el alcance y rendimiento del algoritmo sobre el problema dado, herramientas de implementación, una descripción de los experimentos y resultados obtenidos, en conjunto con un análisis de los mismos y finalmente conlcusiones sobre el proyecto.

# Marco teórico

## Introducción de algoritmo genético

Existe una gran variedad de algoritmos genéticos, pero todos tienen en común la siguiente idea:

Si se cuenta con una población de individuos en un entorno que cuenta con recursos limitados, la competencia entre los individuos por tales recursos produce la supervivencia de los más aptos, también denominada selección natural. Esto causa un aumento en la aptitud de la población remanente.

Dada una función de calidad a maximizar, podemos crear aleatoriamente un conjunto de soluciones candidatas, es decir, elementos del dominio de la función. Luego aplicamos la función de calidad a estas como una medida abstracta de aptitud: cuanto mayor sea, mejor. Con base en estos valores de aptitud, se eligen algunas de las mejores candidatas para sembrar la próxima generación. Esto se realiza aplicando recombinación y/o mutación sobre ellas.

La recombinación es un operador que se aplica a dos o más candidatas seleccionadas (los llamados padres), produciendo una o más nuevas candidatas (los hijos). La mutación se aplica a una candidata y da como resultado una nueva candidata. Por lo tanto, al ejecutar las operaciones de recombinación y mutación sobre los padres, se crea un conjunto de nuevas candidatas (la descendencia). Estas nuevas candidatas tienen su aptitud evaluada y luego compiten, basándose en su aptitud (y posiblemente su edad), con las antiguas por un lugar en la próxima generación. Este proceso puede iterarse hasta que se encuentre una candidata con calidad suficiente (una solución) o se alcance un límite computacional previamente establecido.

Existen dos fuerzas principales que forman la base de los sistemas evolutivos:

- Operadores de variación (recombinación y mutación): crean la diversidad necesaria dentro de la población y, de este modo, facilitan la aparición de novedades.
- Selección: actúa como una fuerza que incrementa la calidad media de las soluciones en la población.

La aplicación combinada de la variación y la selección generalmente conduce a la mejora de los valores de aptitud en poblaciones consecutivas. Es fácil visualizar este proceso como si la evolución estuviera optimizando (o al menos "aproximando") la función de aptitud, acercándose cada vez más a los valores óptimos con el tiempo.

Es importante destacar que muchos componentes de los procesos evolutivos son estocásticos. Por ejemplo, la selección de los mejores individuos no es completamente determinista; incluso los individuos menos aptos suelen tener alguna probabilidad de convertirse en padres o de pasar a la siguiente generación. Durante el proceso de recombinación, la elección de qué atributos de cada padre serán combinados es aleatoria. De manera similar, en el caso de la mutación, la selección de los atributos a modificar en una solución candidata también sigue un comportamiento aleatorio. [\[1\] _Introduction to evolutionary computing second edition_](#evolutionary-computing).

## Justificación

En este proyecto se ha optado por utilizar algoritmos genéticos, ya que el proceso de generación de imágenes puede simplificarse como una serie de búsquedas locales.

El problema a resolver se clasifica como una búsqueda local, dado que no se busca la mejor solución absoluta (que en este caso sería la imagen objetivo, la cual se proporciona como parámetro al algoritmo), sino aproximaciones de calidad.

Un algoritmo genético es especialmente adecuado para este problema debido a su capacidad para mantener la diversidad en la población, lo que ayuda a evitar caer en óptimos locales. Además, gracias a los operadores de variación y selección, es posible ampliar el espacio de búsqueda y descubrir soluciones de alta calidad.

**Aspectos adicionales:**

- No es de interés analizar los pasos intermedios que realiza el algoritmo genético para alcanzar la solución.
- Los algoritmos genéticos son altamente configurables, lo que permite adaptarlos a diferentes entornos y necesidades. Esta flexibilidad ofrece un amplio margen para explorar diversas estrategias en la generación de imágenes.

# Diseño experimental

## Implementación

### Generación de imagen

La _imagen final_ se generará mediante iteraciones sucesivas y acumulativas de un algoritmo de **generación de individuo**.

#### Algoritmo de generación de individuo

Dadas dos imágenes, una denominada _imagen fuente_ la cuál representa el progreso logrado en la generación de la imagen y otra denominada _imagen objetivo_, se busca encontrar al individuo que, al ser renderizado sobre la _imagen fuente_, produzca una nueva imagen que sea lo más similar posible a la _imagen objetivo_.

Es importante tener en mente la diferencia entre _imagen fuente_ e _imagen objetivo_ debido a que seran ampliamente referidas a partir de este punto.

#### Construcción de la imagen

1. Se inicializa la _imagen fuente_ pintada con el color promedio de la _imagen objetivo_, **Imagen<sub>0</sub>**, **Imagen<sub>i</sub>** = **Imagen<sub>0</sub>**.
2. Se ejecuta el algoritmo de generación de individuo sobre **Imagen<sub>i</sub>**.
3. Se obtiene el mejor individuo y lo renderiza sobre **Imagen<sub>i</sub>**, obteniendo una nueva _imagen fuente_, **Imagen<sub>(i+1)</sub>**.
4. Si se cumple la **_condición de parada_**, la generación de la imagen termina.
5. Vuelve al paso 2, pero con **Imagen<sub>(i+1)</sub>**.

#### Condiciones de parada

- **Cantidad de individuos generados**: La generación de imagen finaliza al alcanzar una cantidad de individuos previamente establecida.
- **Tiempo de ejecución**: La generación de imagen finaliza tras pasar una cantidad de tiempo específica.

### Algoritmo genético

El algoritmo genético es un algoritmo de generación de individuo.

#### Individuo

Los individuos cuentan con una serie de atributos genéticos que brinan suficiente flexibilidad para representar distintas formas y colores:

- **Textura**: El algoritmo genético toma como entrada un conjunto de texturas que serán utilizadas por los individuos. Cada individuo posee un atributo llamado textura, el cual corresponde a una de las texturas proporcionadas al algoritmo. Las texturas pueden asignarse a múltiples individuos, permitiendo su repetición dentro de la población.
- **Posición**: Vector bidimensional dominio [0, N]x[0, M], donde N es el ancho y M el alto de la imagen objetivo. Determina la posición donde se renderizará la textura.
- **Tinte**: Es un color utilizado para pintar la textura. Es vital para que los individuos tomen colores en función de su posición.
- **Tamaño**: Vector bidimensional de enteros que representa la resolución en unidad de pixeles con la que se renderizará la textura. Nótese que el tamaño no necesariamente coincide con la resolución original de la textura seleccionada, brindando mayor versatilidad para poder cubrir regiones de distintos tamaños.
- **Rotación**: La textura puede ser rotada [0, 2PI], teniendo como pivote el centro de la textura.

En definitiva, un individuo puede interpretarse como una sub-imagen que se renderizará sobre la _imagen fuente_ con el objetivo de lograr la mayor semejanza posible con _imagen objetivo_.

##### Tinte

El tinte de un individuo será el color promedio de la sub-imagen de la _imagen objetivo_ que ocupe el individuo.

###### Muestreo de color promedio de subrectángulo

Una vez determinada la posición, tamaño y rotación del individuo, se calcula su AABB (Axis Aligned Bounding Box) o subrectángulo, el cuál describe cuál es la porción de la pantalla que ocupa el individuo.
Posteriormente, se ejecuta un algoritmo que calcula el color promedio ocupado por AABB, el cuál es asignado al individuo.

###### Muestreo de color promedio de subrectángulo enmascarado

El método anterior encuentra un problema importante cuando se trabaja con texturas que incluyen transparencia. Al muestrear todo el subrectángulo se incorporan píxeles en el cálculo del color promedio que pueden no ser visibles debido a la transparencia de la textura del individuo.

Para solucionar este problema, se utiliza el muestreo de color enmascarado. Esta técnica calcula el color promedio dentro de AABB pero solo a partir de aquellos píxeles donde la transparencia de la máscara no es cero.

#### Función de fitness

La función de fitness, recibe como parámetro un indiduo y retorna un valor del intervalo [0.0, 1.0]. Donde el peor fitness posible es 0, y el mejor 1.

```c++
float fitness(individual) {...}
```

Esta función realiza las siguientes tareas:

1. Renderiza al individuo sobre la _imagen fuente_, obteniendo la _imagen fuente del individuo_.
2. Envía la _imagen fuente del individuo_ a una función que se encargará de determinar la diferencia entre esta y la _imagen objetivo_, retornando un valor normalizado que representa el fitness del individuo.

A continuación se detallarán los dos métodos que se han utilizado para determinar el fitness de los individuos. Teniendo en cuenta que los individuos obtienen los colores diréctamente de la _imagen objetivo_, los métodos de cálculo de fitness pueden trabajar con los colores en el espacio RGB. Si los colores fueran aleatorizados, entonces se debería mejorar la función de fitness, cambiando el espacio RGB a uno que sea perceptualmente uniforme, tal como CEILab.

Existen estudios similares que debido a la aleatorización de colores se han encontrado con este mismo problema, y utilizan representaciones de colores en espacios alternativos para su función de fitness, tales como el espacio CEILab o PSNR. [\[12\]](#genetic-algorithm-for-image-recreation), [\[14\]](#procedural-paintings), [\[15\]](#genetic-drawing), [\[16\]](#ellipspace).

##### MPA (Mean Power Accuracy)

La función de fitness utilizada en este trabajo es la siguiente:

![](imgs/formulas/MPANPower.png)
_[Figura 3]_ Fórmula de fitness utilizando MPA.

Donde:

- **N**: Es la cantidad de pixeles de la imagen.
- **{R, G, B}**: Es el conjunto de canales sobre los cuales se calculará la diferencia. Cada canal toma un valor normalizado del intervalo: [0.0, 1.0].
- La diferencia de realiza entre la _imagen objetivo_ y la _imagen fuente del individuo_.

Se realiza la sumatoria de la exactitud potenciada a cierto valor. Nótese que los valores de los canales de la imagen están normalizados, y es este el motivo por el cuál se calcula el complemento a uno. Además, el resultado está normalizado, en el intervalo [0.0, 1.0] al dividir la sumatoria por la cantidad de canales totales, _3N_.

De esta forma la penalización aumenta sobre aquellos canales cuyo error sea mayor. Además, se puede modificar el valor de exponente, o también llamado factor de penalización para modificar la distribución de los valores.

La siguiente función de fitness es la planteada en [\[14\]](#procedural-paintings), la cuál utiliza el factor de penalización `n = 4`:

![](imgs/formulas/MPA4Power.png)
_[Figura 4] Fórmula MPA con potencia 4._

#### Inicialización del algoritmo

Se mantiene una población de tamaño fijo a lo largo de toda la ejecución del algoritmo. La población inicial está formada por individuos con los siguientes atributos aleatorizados:

- Textura
- Posición
- Tamaño
- Rotación

Reiterando, el tinte es obtenido mediante un muestreo de la sub-imagen objetivo que ocupa el individuo.

#### Operadores

Los operadores de un algoritmo genético son las funciones principales que manipulan una población de posibles soluciones para buscar la solución óptima a un problema. [\[1\] _Introduction to evolutionary computing second edition_](#evolutionary-computing).

##### Selección

Este operador determina cuáles son los individuos que serán seleccionados para la reproducción.

No se opta por la selección basada en fitness porque el fitness de los individuos suele ser muy parecido, lo cuál significaría que la selección basada en fitness convergería en la mayoría de los casos a una selección aleatoria.

Por este motivo se utiliza el operador de **selección basado en ranking**, donde la probabilidad de cada individuo de ser seleccionado depende de su ranking y no de su fitness. Este método asegura una distribución probabilística constante, evitando caer en una distribución aleatoria uniforme.

##### Cruce

Este operador recibe a dos padres y crea un hijo.
Los atributos genéticos son utilizados por este método son los siguientes:

- Textura
- Posición
- Tamaño
- Rotación

Debido a que la posición el tamaño y la rotación están formados por números reales, es posible realizar interpolaciones lineales entre los mismos atributos de los padres.

Los factores de interpolación son aleatorizados para cada uno de los atributos con el fin de maximizar la diversidad de los hijos obtenidos y de dar la posibilidad de que el mejor cromosoma de cada padre sea seleccionado.

En el caso de la textura, se debe seleccionar una de las texturas de los dos padres. Para este atributo también se genera un valor aleatorizado a través del cuál se selecciona una de las dos.

```GDScript
var child = Individual.new()

# For each attribute there is a blending t
var texture_t: float = randf()
var position_t: float = randf()
var size_t: float = randf()
var rotation_t: float = randf()

child.texture = parent_a.texture if randf() < texture_t else parent_b.texture

# Lerps
child.position = parent_a.position * position_t + parent_b.position * (1.0 - position_t)
child.size = parent_a.size * size_t + parent_b.size * (1.0 - size_t)
child.rotation = parent_a.rotation * rotation_t + parent_b.rotation * (1.0 - rotation_t)
```

##### Mutación

Tras el nacimiento de un hijo, se aplica el operador de mutación sobre los siguientes atributos:

- **Tamaño**: Se realiza un re-escalado aleatorio a lo ancho y a lo largo. La modificación de la escala toma valores del siguiente intervalo: [-50%, 50%].

- **Posición**: Se aplica una traslación aleatoria la cuál es relativa al tamaño del individuo, tomando esta un valor del intervalo vectorial [-tamaño, tamaño]. De esta forma la traslación es como máximo una unidad de su tamaño actual, brindando un método adaptativo que previene el movimiento excesivo de individuos pequeños.

- **Rotación**: La rotación es modificada por un valor aleatorio del intervalo [-PI/2, PI/2].

Nótese que los atributos de tamaño y posición tienen mutaciones relativas, lo cuál significa que los factores de mutación de estos atributos se calculan proporcionalmente, en función del valor de cada atributo. Esto es de caracter fundamental para explorar nuevas soluciones, pero al mismo tiempo no perder el progreso evolutivo logrado.

##### Selección de sobrevivientes

Este operador determina cuáles son los individuos que van a transicionar a la siguiente generación, tras haber creado todos los hijos de la generación actual.

Se utiliza **elitismo**. Elitismo asegura que cierto porcentaje de los mejores individuos de la generación previa sean preservados para la siguiente generación. Esta estrategia permite mantener diversidad y no perder los mejores individuos.

##### Criterio de finalización

**Límite de generaciones**: El algoritmo se detendrá tras un número predefinido de generaciones, lo que permite limitar el tiempo de ejecución.

### Algoritmo aleatorio

Al igual que el algoritmo genético, este también es un [algoritmo de generación de individuo](#algoritmo-de-generación-de-individuo).

Con el fin de evaluar el rendimiento del [algoritmo de generación de individuo genético](#algoritmo-genético), se implementó un algoritmo completamente aleatorio, el cuál sirve como punto de partida.

Este algoritmo generará un único individuo de forma aleatoria, bajo los mismos principios de [iniciación del algoritmo genético](#inicialización-del-algoritmo).

### Algoritmo mejor de aleatorios

Otro algoritmo de generación de individuos que se ha implementado en este trabajo, es el algoritmo mejor de aleatorios. Como su nombre lo describe, este algoritmo genera X cantidad de individuos aleatoriamente, de igual manera que el [algoritmo aleatorio](#algoritmo-aleatorio), pero selecciona al mejor de los generados.
La selección del mejor de los individuos se hace mediante la misma función de fitness que el algoritmo genético. A este algoritmo se lo podría considerar como un híbrido entre el aleatorio y el genético ya que cuenta con la misma generación aleatoria de individuos que el algoritmo aleatorio, pero también utiliza la función de fitness del algoritmo genético.

El motivo principal por el cuál se ha implementado este algoritmo se debe al bajo rendimiento del [algoritmo aleatorio](#algoritmo-aleatorio), el cual será analizado en la sección de [algoritmo de generación de imagen](#algoritmo-de-generación-de-imagen).

## Métrica

La métrica utilizada para evaluar la similitud entre las imágenes será el _Delta E (ΔE)_ [\[8\]](#what-is-delta-e). medio, aplicado en el espacio de color CIE L*a*b\* [\[10\]](#what-is-cielab). Este espacio, a diferencia del RGB, es perceptualmente uniforme, lo que significa que las diferencias calculadas en él se corresponden mejor con la percepción humana de las variaciones de color.

El delta E es una medida estándar utilizada para cuantificar la diferencia entre dos colores en este espacio, y en este proyecto será clave para comparar la imagen generada con la _imagen objetivo_.

De esta forma, se podrá obtener una evaluación más precisa de la calidad de las imágenes generadas, ya que la métrica estará alineada con la percepción visual humana.

Con el objetivo de comparar los resultados de ambos algoritmos utilizando esta métrica, se evaluarán los siguientes escenarios:

- La métrica final obtenida al fijar una cantidad máxima de objetos.
- La cantidad de objetos necesarios para alcanzar una métrica objetivo específica.

### Delta E medio

El cálculo de _Delta E (ΔE)_ se realiza sobre el espacio de colores uniforme _CEILab_, es por este motivo que la _imagen generada_ y la _imagen objetivo_ deben ser transformadas a este espacio.
Una vez realizada tal transformación, obteniendo las componentes de cada pixel _(L, a, b)_, se evalua la función de _Delta E (ΔE)_, y se calcula la media de la siguiente manera:

![](imgs/formulas/average_delta_e.png)
_[Figura 5] - ΔE medio sobre imágenes en espacio de color CEILab_

- **N** es la cantidad de pixeles de las imágenes, cantidad que debe coincidir.
- **(L, a, b)** son los canales del espacio de color _CEILab_.
- **ΔE(img1, img2)** es la función utilizada para calcular ΔE entre dos pixeles de la _imagen generada_ y la _imagen objetivo_.

A lo largo del tiempo, se han desarrollado diversas funciones para calcular ΔE, considerando las versiones de 1976, 1994 y 2000. Se ha optado por implementar la fórmula de ΔE de 1994, ya que ofrece una mayor precisión que la de 1976, pero sin la exigencia computacional de la versión de 2000. Además, es importante destacar que la métrica utilizada no será ΔE en sí misma, sino el ΔE medio, lo que hace que el uso de una función de extrema precisión sea innecesario, dado que se calcula el promedio, haciendo que el exeso de detalles percibidos por la función se pierdan.

#### Cálculo de delta E 1994

<div align="center">

| _[Figura 6] - Fórmula de delta E 1994_ |
| :------------------------------------: |
|  ![](imgs/formulas/formula-cie94.png)  |
|   Referencia [\[9\]](#delta-e-math).   |

</div>

- **(L, a, b)** son los canales del espacio de color _CEILab_.
- Las constantes _K1_, _K2_, _Kl_, _Kc_, _Kh_ son pesos que permiten ajustar la importancia de distintas componentes. Tras analizar implementaciones ya existentes utilizadas en proyectos similares se ha encontrado que es común tratar a todas las componentes por igual, motivo por el cuál se les asigna el valor de 1 a todas las constantes. [\[17\]](#python-colour)

## Herramientas

Para el desarrollo de este proyecto, se utilizó Godot 4.3 [\[3\]](#godot-43), con lógica programada en GDScript [\[4\]](#gdscript) y paralelización implementada en GLSL [\[5\]](#glsl). La visualización de resultados se realizó con Python [\[6\]](#python) y matplotlib [\[7\]](#matplotlib).

## Experimentos y resultados obtenidos

### Algoritmo de generación de individuos genético

Como se detalló previamente, se implementaron dos algoritmos para la generación de individuos: el genético y el aleatorio. La experimentación descrita en esta sección se enfocó exclusivamente en el algoritmo genético. Se consideró que incluir un análisis del algoritmo aleatorio en este contexto sería poco significativo, pero su estudio será de gran importancia al comparar los resultados de ambos algoritmos en el proceso de generación de imágenes.

#### Parámetros

Los experimentos presentados en las siguientes secciones mantienen constantes los parámetros establecidos, con el objetivo de minimizar la cantidad de variables y garantizar una experimentación coherente y consistente.

El algoritmo genético cuenta con los siguientes parámetros:

<div align="center">

| Parámetro                | Valor |
| ------------------------ | ----- |
| Generaciones             | 20    |
| Población                | 150   |
| Probabilidad de mutación | 20%   |
| Porcentaje elitista      | 25%   |

</div>

Es importante aclarar que en los siguientes experimentos, los únicos parámetros que varían son:

- Imagen fuente
- Imagen objetivo
- Dominio de imágenes de los individuos.

#### Caso de prueba básico

Para poner a prueba el algoritmo de generación de individuos, se decidió definir la imagen objetivo más simple posible, pero que ponga a prueba las capacidades del algoritmo genético.

<div align="center">

|                  _[Figura 6] - Imagen objetivo del caso de prueba básico_                  |
| :----------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/simple_rectangle_test/convergence_rectangle_target_test.png) |

</div>

En la fugura 6 se puede observar una simple imagen de resolución 128x128px, la cuál tiene como objetivo poner a prueba las capacidades del algoritmo genético tanto en la determinación de posición, tamaño, color y rotación. Nótese que se ha seleccionado un rectángulo con el objetivo de que el algoritmo también deba optimizar el atributo genético de la rotación.

Para simplificar las cosas aun más, los individuos solo podrán tomar una textura, ilustrada por la figura 7, la cuál coincide con el rectángulo blanco que se busca replicar de la figura 6.

<div align="center">

|                    _[Figura 7] - Textura utilizada por los individuos_                    |
| :---------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/simple_rectangle_test/convergence_rectangle_shape_test.png) |

</div>

(Nótese que se han añadido los cuadros típicos de imágenes con transparencia manualmente para que se pueda visualizar la imagen sobre un fondo blanco. En la práctica, los cuadros grises representan los pixeles transparentes).

Además, la _imagen fuente_, es decir, sobre la cuál se renderizarán los individuos es la siguiente:

<div align="center">

|                                _[Figura 8] - Imagen fuente_                                |
| :----------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/simple_rectangle_test/convergence_rectangle_source_test.png) |

</div>

Se plantea este escenario porque es posible agregar un individuo sobre la imagen fuente y obtener una imagen igual a la objetivo.

##### Resultados

Tras ejectutar el algoritmo genético durante 2,6 segundos, se obtuvo el siguiente individuo:

<div align="center">
<table>
  <tr>
    <!-- Table on the left -->
    <td>
      <table>
        <tr><th>Attribute</th><th>Value</th></tr>
        <tr><td>Fitness</td><td>0.95458984375</td></tr>
        <tr><td>Metric Score</td><td>4.541015625</td></tr>
        <tr><td>Position X</td><td>63</td></tr>
        <tr><td>Position Y</td><td>60</td></tr>
        <tr><td>Size X</td><td>96.3577575683594</td></tr>
        <tr><td>Size Y</td><td>108.490371704102</td></tr>
        <tr><td>Rotation</td><td>3.27535051368461</td></tr>
        <tr><td>Color</td><td>(1.0, 1.0, 1.0)</td></tr>
        <tr><td>Texture index</td><td>0 (Correspondiente al rectángulo)</td></tr>
      </table>
    </td>
    <!-- Image on the right -->
    <td align="center">
      <table>
        <tr><th><i>[Figura 9] - Imagen fuente del individuo generado</i></th></tr>
        <tr>
          <td>
            <figure>
              <img src="imgs/plots_and_statistics/simple_rectangle_test/precise_optimization_params/out.png" width="300">
            </figure>
          </td>
        </tr>
      </table>
    </td>

  </tr>
</table>
</div>
La figura 10 ilustra el fitness medio de por población en cada generación, el cuál utiliza la función MPA con potencia 4, motivo por el cuál está nomrmalizado y aumenta mientras disminuye el error medio de la población.

|                               _[Figura 10] - Fitness medio por generación_                                |
| :-------------------------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/simple_rectangle_test/precise_optimization_params/average_fitness_plot.png) |

La figura 11 ilustra los gráficos de caja del fitness por generación y se observa que la dispersión de los valores disminuye a medida que aumentan las generaciones. Esto representa un comportamiento adecuado, donde el algoritmo inicialmente realiza exploración, y a medida que avanzan las generaciones se hace explotación.

|                   _[Figura 11] - Gráficos de caja de fitness medio por generación_                   |
| :--------------------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/simple_rectangle_test/precise_optimization_params/fitness_boxplot.png) |

Los gráficos anteriores representan el comportamiento evolutivo en conjunto de la población, pero también es de interés analizar cuál es el valor del fitness de la mejor solución candidata en cada generación:

|                _[Figura 12] - Valor de fitness del mejor individuo de cada generación_                |
| :---------------------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/simple_rectangle_test/precise_optimization_params/max_fitness_plot.png) |

La figura 13 muesta de manera intuitiva la posición de los individuos en cada una de las generaciones donde claramente se puede ver como es que el atributo posición de los individuos evoluciona al centro, siendo esta la posición ideal.

<div align="center">

|                    _[Figura 13] - Posiciones de individuos por generación_                     |
| :--------------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/simple_rectangle_test/precise_optimization_params/positions.gif) |

</div>

#### Caso real con Mona Lisa

La Mona Lisa será utilizada como la imagen estándar a partir de este punto con el fin de mantener constante la mayor cantidad de parámetros. Además es comunmente utilizada en trabajos similares de generación de imágenes.

<div align="center">

|                 _[Figura 14] - Textura 1 del dominio de texturas de individuos_                  |
| :----------------------------------------------------------------------------------------------: |
| <img src="imgs/plots_and_statistics/mona_lisa_img_generation/shapes_used/shape_0.png" width=200> |

</div>
La figura 14 ilustra la única textura que será utilizada por los individuos.

##### Resultados desde cero

Se realiza una ejecución desde cero, lo cuál significa que la imagen fuente no tiene nada renderizado, únicamente el color promedio de la imagen objetivo.

<div align="center">

|                               _[Figura 37.1] - Imagen fuente_                               |          _[Figura 37.2] - Imagen objetivo: Mona Lisa original_          |
| :-----------------------------------------------------------------------------------------: | :---------------------------------------------------------------------: |
| <img src="imgs/plots_and_statistics/mona_lisa/mona_lisa_average_color_clear.png" width=400> | <img src="imgs/plots_and_statistics/mona_lisa/Mona_Lisa.jpg" width=400> |

</div>

Tras ejectutar el algoritmo genético durante 5,5 segundos, se obtuvo el siguiente individuo:

<div align="center">
<table>
  <tr>
    <!-- Table on the left -->
    <td>
      <table>
        <tr><th>Attribute</th><th>Value</th></tr>
        <tr><td>Fitness</td><td>0.644296525266873</td></tr>
        <tr><td>Metric Score</td><td>24.323813597624</td></tr>
        <tr><td>Position X</td><td>404</td></tr>
        <tr><td>Position Y</td><td>821</td></tr>
        <tr><td>Size X</td><td>688.973754882812</td></tr>
        <tr><td>Size Y</td><td>1072.1259765625</td></tr>
        <tr><td>Rotation</td><td>4.64755909331613</td></tr>
        <tr><td>Color</td><td>(0.1568, 0.0784, 0.0470)</td></tr>
        <tr><td>Texture index</td><td>0 (Correspondiente al círculo)</td></tr>
      </table>
    </td>
    <!-- Image on the right -->
    <td align="center">
      <table>
        <tr><th><i>[Figura 16] - Imagen fuente del individuo</i></th></tr>
        <tr>
          <td>
            <figure>
              <img src="imgs/plots_and_statistics/mona_lisa/precise_optimization_params/individual_0/source_image_result.png" width="300">
            </figure>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</div>

La figura 17 muestra como varía el fitness medio de cada población a lo largo de las generaciones.

|                                _[Figura 17] - Fitness medio por generación_                                |
| :--------------------------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/mona_lisa/precise_optimization_params/individual_0/average_fitness_plot.png) |

La figura 18 muesta los gráficos de caja del fitness por generación. Se puede observar un comportamiento similar al del caso básico, pero con una mayor definición entre la exploración y la explotación en las últimas generaciones.

|                   _[Figura 18] - Gráficos de caja de fitness medio por generación_                    |
| :---------------------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/mona_lisa/precise_optimization_params/individual_0/fitness_boxplot.png) |

|                _[Figura 19] - Valor del fitness del mejor individuo de cada generación_                |
| :----------------------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/mona_lisa/precise_optimization_params/individual_0/max_fitness_plot.png) |

En la figura 20, se ilustran las posiciones por generación de los individuos donde se puede observar que los puntos se trasladan hacia arriba, mientras que el individuo fue renderizado en la parte inferior de la imagen. Esto no es un error porque la orientación del eje Y en Godot y matplotlib están invertidos.

|                   _[Figura 20] - Posiciones de los individuos por generación_                   |                                _[Figura 21] - Imagen fuente del individuo_                                |
| :---------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/mona_lisa/precise_optimization_params/individual_0/positions.gif) | ![](imgs/plots_and_statistics/mona_lisa/precise_optimization_params/individual_0/source_image_result.png) |

En definitiva, se observa el correcto funcionamiento del algoritmo, cuyos resultados coinciden con el simple caso del rectángulo.

##### Resultados con progreso

En el experimento anterior se evaluaron estadísticas del algoritmo genético tomando una imagen fuente vacía. Debido a que se utilizarán iteraciones sucesivas del algoritmo genético, el estudio del caso anterior no basta para poder asegurar el correcto funcionamiento del algoritmo en el proceso de generación de imágenes. Es por este motivo que a continuación se hará un análisis similar pero con un punto de partida más avanzado, donde la imagen fuente no está vacía, simulando una etapa de generación de imagen.

|                   _[Figura 22] - Imagen fuente avanzada con 50 individuos (Etapa 50)_                   |  _[Figura 23] - Imagen objetivo: Mona Lisa original_   |
| :-----------------------------------------------------------------------------------------------------: | :----------------------------------------------------: |
| ![](imgs/plots_and_statistics/mona_lisa/precise_optimization_params/individual_51/mona_lisa_50_ind.png) | ![](imgs/plots_and_statistics/mona_lisa/Mona_Lisa.jpg) |

El algoritmo cuenta con los mismos parámetros que se utilizaron en la ejecución desde cero.

Tras ejectutar el algoritmo genético durante 4,5 segundos, se obtuvo el siguiente individuo:

<div align="center">

| Attribute     | Value                          |
| ------------- | ------------------------------ |
| Fitness       | 0.808261032735021              |
| Metric Score  | 10.6251412383781               |
| Position X    | 499                            |
| Position Y    | 445                            |
| Size X        | 49.4948654174805               |
| Size Y        | 291.158996582031               |
| Rotation      | 2.45406044618326               |
| Color         | (0.1294, 0.0627, 0.043)        |
| Texture index | 0 (Correspondiente al círculo) |

</div>

A continuación, en la figura 24 y 25 se pueden observar las imágenes fuentes de los individuos generados en la etapa 50 y 51 correspondientemente, siendo el de la etapa 51 el recientemente generado:

|                              _[Figura 24] - Imagen fuente de la etapa 50_                               |                            _[Figura 25] - Imagen fuente de la etapa 51_                             |  _[Figura 26] - Imagen objetivo: Mona Lisa original_   |
| :-----------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------: | :----------------------------------------------------: |
| ![](imgs/plots_and_statistics/mona_lisa/precise_optimization_params/individual_51/mona_lisa_50_ind.png) | ![](imgs/plots_and_statistics/mona_lisa/precise_optimization_params/individual_51/mona_lisa_51.png) | ![](imgs/plots_and_statistics/mona_lisa/Mona_Lisa.jpg) |

Se observa que se el algoritmo generó un individuo el cuál se encuentra a la altura del hombro.

La figura 26 ilustra como el fitness medio varía a lo largo de las generaciones.

|                                   _[Figura 26] - Fitness medio por generación_                                    |
| :---------------------------------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/mona_lisa/precise_optimization_params/individual_51/plots/average_fitness_plot.png) |

En la figura 27 se puede observar un comportamiento similar al del caso desde cero, pero se presenta una explotación mucho más rápida y menor exploración.

|                          _[Figura 27] - Gráficos de caja de fitness por generación_                          |
| :----------------------------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/mona_lisa/precise_optimization_params/individual_51/plots/fitness_boxplot.png) |

En la figura 28 se pueden observar los efectos de la rápida explotación debido a que el algoritmo quedó atascado en un mismo valor a partir de la tercera generación.

|                  _[Figura 28] - Valor de la métrica del mejor individuo de cada generación_                   |
| :-----------------------------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/mona_lisa/precise_optimization_params/individual_51/plots/max_fitness_plot.png) |

<div align="center">

|                      _[Figura 29] - Posiciones de los individuos por generación_                       |
| :----------------------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/mona_lisa/precise_optimization_params/individual_51/plots/positions.gif) |

</div>

En la figura 29, a diferencia de los gráficos ilustrados en la figura 27 y 28, se observa que la explotación sobre el atributo posición no resulta ser tan prematuro como los gráficos anteriores ilustraban. Es probable que dada la imagen fuente sobre la cuál se ejecutó el algoritmo, el algoritmo construyera una población con atributos diversos pero con fitness similares. De hecho, si se observa el gráfico en detalle, se puede observar que hay varios puntos, es decir individuos, cuya posición se mantiene constante a lo lagro de las generaciones, lo cuál significa que estos son buenas soluciones por encima del percentil 80 de la población.

#### Estudio comparativo basado en ejecuciones múltiples del algoritmo

Previamente, se analizó el comportamiento de una única ejecución del algoritmo genético con el objetivo de evaluar la evolución de la población a lo largo de las generaciones. Sin embargo, generalizar los resultados obtenidos en esa ejecución sería incorrecto. Por esta razón, y manteniendo los mismos parámetros, se llevaron a cabo 100 ejecuciones del algoritmo genético. A continuación, se presentan los resultados de estas pruebas, tanto para la imagen objetivo del caso básico como para la de Mona Lisa.
Es importante aclarar que la imagen fuente utilizada para evaluar las distintas ejecuciones siempre fue la misma. Para el caso básico, se utilizó el fondo negro, y para la Mona Lisa, se utilizó la imagen de la etapa 50.

|          _[Figura 30] - Distribución del tiempo de ejecución con imagen objetivo del caso básico_          |       _[Figura 31] - Distribución del tiempo de ejecución con imagen objetivo Mona Lisa_       |
| :--------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/simple_rectangle_test/multiple_individual_generators/time_taken_boxplot.png) | ![](imgs/plots_and_statistics/mona_lisa/multiple_individual_generators/time_taken_boxplot.png) |

La condición de corte del algoritmo está definida por la cantidad de generaciones, fijada en 20. Por este motivo, los tiempos de ejecución no muestran una gran dispersión en ninguno de los casos analizados.

- En la figura 30 se observa que el tiempo promedio de ejecución del algoritmo es aproximadamente 2,23 segundos. Dado que en cada ejecución se procesan 3000 individuos (resultado de multiplicar 20 generaciones por un tamaño de población de 150), el tiempo promedio por individuo es de 0,74 milisegundos.
- Por otro lado, en la figura 31 se muestra que el tiempo promedio por individuo es de 1,26 milisegundos.

Esta variación en los tiempos medios se debe a la diferencia en la resolución de las imágenes objetivo:

- El caso básico utiliza una imagen con resolución de 128x128, lo que implica el procesamiento de 6384 píxeles.
- En cambio, la imagen de Mona Lisa tiene una resolución de 640x968, lo que corresponde al procesamiento de 619,520 píxeles.

Esto significa que la imagen de Mona Lisa tiene 37,81 veces más píxeles que la del caso básico. No obstante, cabe destacar que, a pesar de esta gran diferencia en la cantidad de datos a procesar, el tiempo medio de ejecución en el caso básico fue 1,7 veces más rápido que en el caso de Mona Lisa.

|              _[Figura 32] - Distribución del fitness con imagen objetivo del caso básico_               |           _[Figura 33] - Distribución del fitness con imagen objetivo Mona Lisa_            |
| :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/simple_rectangle_test/multiple_individual_generators/fitness_boxplot.png) | ![](imgs/plots_and_statistics/mona_lisa/multiple_individual_generators/fitness_boxplot.png) |

En la figura 32 se observa que las ejecuciones del algoritmo genético para el caso básico presentan una mayor dispersión del fitness en comparación con las correspondientes a la Mona Lisa, mostradas en la figura 33.
Esta diferencia en la dispersión se explica porque, en el caso básico, la imagen fuente es completamente negra, lo que genera una mayor sensibilidad al error ante pequeñas imperfecciones en los individuos generados. Por otro lado, en el caso de la Mona Lisa, cuya imagen fuente corresponde a la etapa 50, existe un mayor nivel de similitud entre la imagen fuente y la imagen objetivo. Esto reduce el impacto de ligeras imperfecciones en los individuos generados, resultando en una menor variación en el fitness de los individuos generados.

|                _[Figura 34] - Posiciones de los individuos generados con imagen objetivo del caso básico_                |             _[Figura 35] - Posiciones de los individuos generados con imagen objetivo Mona Lisa_             |
| :----------------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/simple_rectangle_test/multiple_individual_generators/individual_positions_with_scores.png) | ![](imgs/plots_and_statistics/mona_lisa/multiple_individual_generators/individual_positions_with_scores.png) |

De manera similar a los análisis previos, considerar el atributo genético de la posición proporciona una aproximación al comportamiento del algoritmo genético:

- En el caso básico, las posiciones de los individuos generados se concentran en la región central de la imagen. Este resultado es acertado, ya que el centro representa la única posición viable para los individuos en este escenario.
- Para la Mona Lisa, se observa una mayor dispersión en las posiciones de los individuos, a pesar de que la métrica presenta menor variación. Sin embargo, la distribución de las posiciones no es uniforme ni aleatoria. Este comportamiento se explica porque, en la etapa 50 de la generación de Mona Lisa, existen múltiples posiciones donde es posible ubicar un individuo manteniendo un valor similar en la métrica. Esto es coherente con los cúmulos de individuos observados.

#### Algoritmo de generación de imagen

En esta sección, tras probar el algortmo genético del generación de individuos se evaluó el comportamiento del [algoritmo genético](#algoritmo-genético), [aleatorio](#algoritmo-aleatorio) y [mejor de aleatorios](#algoritmo-mejor-de-aleatorios), en el proceso de generación de imágenes. Se evaluarán los resultados obtenidos por los tres algortimos considerando los distintos puntos de corte:

- **Límite en cantidad de individuos generados**
- **Límite en tiempo de ejecución y cantidad máxima de individuos generados**: La condición a evaluar principalmente es el tiempo de ejecución, pero también se añade un límite alto en la cantidad de individuos.

##### Parámetros

El dominio de texturas de los individuos está formado por las siguientes ilustradas en las figuras 36.

<div align="center">

|                _[Figura 36.1] - Textura 1 del dominio de texturas de individuos_                 |                _[Figura 36.2] - Textura 2 del dominio de texturas de individuos_                 |
| :----------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------: |
| <img src="imgs/plots_and_statistics/mona_lisa_img_generation/shapes_used/shape_0.png" width=200> | <img src="imgs/plots_and_statistics/mona_lisa_img_generation/shapes_used/shape_1.png" width=200> |

</div>

<div align="center">

|                               _[Figura 37.1] - Imagen fuente_                               |          _[Figura 37.2] - Imagen objetivo: Mona Lisa original_          |
| :-----------------------------------------------------------------------------------------: | :---------------------------------------------------------------------: |
| <img src="imgs/plots_and_statistics/mona_lisa/mona_lisa_average_color_clear.png" width=400> | <img src="imgs/plots_and_statistics/mona_lisa/Mona_Lisa.jpg" width=400> |

</div>

- Los parámetros utilizados por el **algoritmo genético** son los mismos que se utilizaron al experimentar con el algoritmo genético en la sección anterior.
- El **algoritmo aleatorio** no cuenta con parámetros, por lo que no hay nada que especificar.
- El **algoritmo mejor de aleatorios** cuenta con un parámetro _N_, que establece la cantidad de individuos que se generan. En esta experimentación _N_ toma el valor de 150, el cuál equivale al tamaño de la población del algoritmo genético. Se ha establecido este valor con el objetivo de poder medir cuanto impacto tiene la explotación del algoritmo genético a lo largo de las 20 generaciones.

##### Límite en cantidad de individuos generados

Como primer condición de corte a evaluar, se ha utilizado un límite de 200 individuos.

|                            _[Figura 38.1] - Imagen generada con algoritmo genético_                            |                              _[Figura 38.2] - Imagen generada con algoritmo aleatorio_                               |                  _[Figura 38.3] - Imagen generada con algoritmo mejor de aleatorios_                  |
| :------------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/mona_lisa_img_generation/genetic/individual_count_limit/generated_mona_lisa.png) | ![](imgs/plots_and_statistics/mona_lisa_img_generation/random/individual_count_limit/generated_mona_lisa_random.png) | ![](imgs/plots_and_statistics/mona_lisa_img_generation/best_of_random/individual_count_limit/out.png) |
|                                            Generada en 743 segundos                                            |                                               Generada en 1,2 segundos                                               |                                       Generada en 34,5 segundos                                       |
|                                   Puntuación de la métrica: 7.56027569731405                                   |                                      Puntuación de la métrica: 25.0826882102273                                      |                              Puntuación de la métrica: 9.03677685950413                               |

En las fuguras 38 se puede observar las imágenes generadas con cada algoritmo. Es notable la diferencia de calidad, y se puede observar que el algoritmo aleatorio tiene un problema con el tamaño de los individuos generados.

Además, al comparar las figuras 38.1 y 38.3, se puede observar claramente que, aunque el tamaño de la población es el mismo en ambas, es decir, 150, el proceso evolutivo implementado por el algoritmo genético tiene un impacto significativo, logrando generar individuos con una mayor precisión al optimizar la cantidad de individuos para generar una imagen con mayor calidad.

<div align="center">

|           _[Figura 40.1] - Métrica calculada en el proceso de genración de imagen con algoritmo genético_            |          _[Figura 40.2] - Métrica calculada en el proceso de genración de imagen con algoritmo aleatorio_           |
| :------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------: |
| <img src="imgs/plots_and_statistics/mona_lisa_img_generation/genetic/individual_count_limit/metric.png" width="500"> | <img src="imgs/plots_and_statistics/mona_lisa_img_generation/random/individual_count_limit/metric.png" width="500"> |

</div>

<div align="center">

|         _[Figura 40.3] - Métrica calculada en el proceso de genración de imagen con algoritmo mejor de aleatorios_          |
| :-------------------------------------------------------------------------------------------------------------------------: |
| <img src="imgs/plots_and_statistics/mona_lisa_img_generation/best_of_random/individual_count_limit/metric.png" width="500"> |

</div>

- El gráfico ilustrado en la figura 40.1, describe el comportamiento de la métrica en el proceso de generación de imagen utilizando el algoritmo genético como generador de individuos. Se observa que la curva tiene una forma logarítmica, sin retrocesos, debido a que cada individuo generado, y añadido a la imagen, reduce el error medio entre la imagen objetivo y la imagen fuente de cada etapa. Se considera que estos resultados son sumamente importantes ya que muestran como el algoritmo genético es capaz de encontrar los mejores individuos posibles en cada etapa.
- El gráfico de la figura 40.2 tiene un comportamiento completamente distinto al del algoritmo genético. Se observa que debido a la aleatoriedad existe una gran cantidad de retrocesos en la métrica, este comportamiento está lejos de ser idoneo y el gran contraste entre los resultados obtenidos hace brillar al algoritmo genético.
- En cuanto al algoritmo mejor de aleatorios, representado en la figura 40.3, se observa un comportamiento logarítmico similar al del algoritmo genético. Sin embargo, a diferencia del algoritmo genético, no se ha alcanzado el mismo valor de métrica, lo que provoca que la asíntota de la métrica parezca estar en un valor superior al compararla con la asíntota del algoritmo genético.

¿Por qué la métrica presenta un comportamiento logarítmico? A primera vista, lo ideal sería lograr un comportamiento lineal. Hay un atributo que tiene mucha importancia el cuál impacta directamente en los resultados obtenidos. Este atributo es el del tamaño, el cuál provoca una gran cantidad de retrocesos en el algoritmo aleatorio.

<div align="center">

|   _[Figura 41.1] - Area de los individuos generados en el proceso de genración de imagen con algoritmo genético_   |  _[Figura 41.2] - Area de los individuos generados en el proceso de genración de imagen con algoritmo aleatorio_  |
| :----------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------: |
| <img src="imgs/plots_and_statistics/mona_lisa_img_generation/genetic/individual_count_limit/area.png" width="500"> | <img src="imgs/plots_and_statistics/mona_lisa_img_generation/random/individual_count_limit/area.png" width="500"> |

</div>

<div align="center">

| _[Figura 41.3] - Area de los individuos generados en el proceso de genración de imagen con algoritmo mejor de aleatorios_ |
| :-----------------------------------------------------------------------------------------------------------------------: |
| <img src="imgs/plots_and_statistics/mona_lisa_img_generation/best_of_random/individual_count_limit/area.png" width="500"> |

</div>

En las figuras 41 se puede observar la gran diferencia de los tamaños de los individuos generados. El algoritmo genético tiende a reducir el área de los individuos generados, lo cuál tiene sentido debido a que de este modo se evita perder secciones de la imagen previamente desarrolladas. El algoritmo mejor de aleatorios tiene un comportamiento similar, aunque no tan definido como el del genético.
En cuanto al algoritmo aleatorio, el tamaño es aleatorio y esto provoca grandes retrocesos cuando el área es grande.

La reducción del tamaño de los individuos a lo largo de las etapas explica el comportamiento logarítmico presentado en la figura 40. Inicialmente los individuos son de gran tamaño, esto implica que cubren mayor cantidad de pixeles, provocando un disminución significativa en la métrica. A medida que avanza el proceso de generación de imagen, el tamaño de los individuos disminuye de tal forma que no se provocan retrocesos, pero dado a que el tamaño es menor, la contribución de cada individuo en la imagen es menor, provocando el comportamiento logarítmico de la función de la métrica.

<div align="center">

|  _[Figura 42.1] - Tiempo de generación por cada individuo en el proceso de generación de imagen con algoritmo genético_  | _[Figura 42.2] - Tiempo de generación por cada individuo en el proceso de generación de imagen con algoritmo aleatorio_ |
| :----------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------: |
| <img src="imgs/plots_and_statistics/mona_lisa_img_generation/genetic/individual_count_limit/time_taken.png" width="500"> | <img src="imgs/plots_and_statistics/mona_lisa_img_generation/random/individual_count_limit/time_taken.png" width="500"> |

</div>

<div align="center">

| _[Figura 42.3] - Tiempo de generación por cada individuo en el proceso de generación de imagen con algoritmo mejor de aleatorios_ |
| :-------------------------------------------------------------------------------------------------------------------------------: |
|  <img src="imgs/plots_and_statistics/mona_lisa_img_generation/best_of_random/individual_count_limit/time_taken.png" width="500">  |

</div>

Las figuras 42 muestran los tiempos de ejecucion de cada etapa para cada algoritmo. Se añadieron estas figuras con el fin de ilustrar la relación del tamaño de los individuos generados y el tiempo de ejecución. Esta relación se puede observar con mayor claridad en el algoritmo genético, pero también sucede en el aleatorio y mejor de aleatorios. La relación del tamaño y los tiempos de ejecución se debe principalmente al muestreo del color promedio, ya que el muestreador debe considerar una mayor cantidad de pixeles, lo cuál implica mayor cantidad de operaciones matemáticas y mecanismos de sincronización.

Tras analizar resultados anteriores se considera que continuar con un análisis compartativo sobre las condiciones de corte restantes con los mismos parámetros carece de sentido debido a la amplia superioridad del algoritmo genético y el mejor de aleatorios sobre el algoritmo aleatorio. Con el fin de intentar mejorar el rendimiento del algoritmo aleatorio se decide establecer un tamaño fijo de los individuos, de tal modo que el algoritmo aleatorio no pueda generar individuos demasiado grandes que provoquen muchos retrocesos.

Se ha establecido que el ancho de los individuos sea igual al 30% del ancho de la imagen, y el alto es un valor que se calcula luego de establecer el ancho con el fin de mantener la relación de aspecto de la textura del individuo.

##### Límite en tiempo de ejecución y cantidad máxima de individuos generados

Se estableció un tiempo de ejecución límite de 400 segundos, y en cuanto a la cantidad de individuos, se estableció un límite alto de 1000 individuos.
| _[Figura 46] - Imagen generada con algoritmo genético_ | _[Figura 47] - Imagen generada con algoritmo aleatorio_ | _[Figura 47] - Imagen generada con algoritmo aleatorio_ |
| :-------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------: |
| ![](imgs/plots_and_statistics/mona_lisa_img_generation/genetic/execution_time_limit/genetated_genetic.png) | ![](imgs/plots_and_statistics/mona_lisa_img_generation/random/execution_time_limit/generated_random_1000.png) | ![](imgs/plots_and_statistics/mona_lisa_img_generation/best_of_random/execution_time_limit/out.png) |
| Formada por 112 individuos| Formada por 1000 individuos | Formada por 1000 individuos |
| Tiempo de ejecución 400 segundos | Tiempo de ejecución 5 segundos | Tiempo de ejecución 165 segundos |
| Puntuación de la métrica: 9.25097091296488| Puntuación de la métrica: 17.2200897469008 | Puntuación de la métrica: 8.76277440599173 |

Tras establecer un tamaño fijo para los individuos, se obtuvieron notables mejoras en el algoritmo aleatorio si se compara la figura 47 con la 38.2, sin embargo los resultados tras utilizar este algoritmo continuan siendo insatisfactorios. De hecho, este algoritmo presenta un comportamiento similar a la ejecución anterior, obteniendo muchos retrocesos debido a la superposición de individuos.

Dejando de lado el algoritmo aleatorio y comparando el genético y mejor de aleatorios, se puede observar que el algoritmo mejor de aleatorios obtuvo un mejor resultado que el genético. Esta diferencia de calidad es captada correctamente por la métrica. Sin embargo, el algoritmo genético obtuvo un resultado similar utilizando tan solo 112 individuos, a diferencia del mejor de aleatorios que llegó al límite de 1000.

Es claro que el algoritmo aleatorio genera retrocesos de la métrica a partir de cierta cantidad de individuos, tal como se ilustra en las figura 48.2.

<div align="center">

|                  _[Figura 48.2] - Métrica calculada en el proceso de genración de imagen con algoritmo aleatorio_                   | _[Figura 48.1] - Métrica calculada en el proceso de genración de imagen con algoritmo genético_                                      |
| :---------------------------------------------------------------------------------------------------------------------------------: | ------------------------------------------------------------------------------------------------------------------------------------ |
| <img src="imgs/plots_and_statistics/mona_lisa_img_generation/random/execution_time_limit/metric.png" alt="Description" width="500"> | <img src="imgs/plots_and_statistics/mona_lisa_img_generation/genetic/execution_time_limit/metric.png" alt="Description" width="500"> |

</div>

<div align="center">

|                 _[Figura 48.3] - Métrica calculada en el proceso de genración de imagen con algoritmo mejor de aleatorios_                  |
| :-----------------------------------------------------------------------------------------------------------------------------------------: |
| <img src="imgs/plots_and_statistics/mona_lisa_img_generation/best_of_random/execution_time_limit/metric.png" alt="Description" width="500"> |

</div>

La métrica tras utilizar el algoritmo genético mantiene la curva logarítmica durante los 400 segundos de ejecución, mientras que el algoritmo aleatorio presenta retrocesos a partir de la etapa 200. En cuanto al algorimo mejor de aleatorios, se observa que la asíntota está mucho mas definida que el algoritmo genético, lo cuál quiere decir que llegada cierta cantidad de individuos, el beneficio de agregar nuevos individuos es cada vez menor. Se considera que esta propiedad no es única del algoritmo mejor de aleatorios y que también se presentaría en el algoritmo genético si se generaran 1000 individuos.

En cuanto al uso del algoritmo aleatorio en el proceso de generación de imágenes, se han obtenido mejores resultados tras reducir y establecer un valor fijo para el ancho de los individuos. Si se buscan mejores resultados con el algoritmo aleatorio, sería necesario continuar reduciendo el tamaño cada vez mas, de tal modo que se reduzca la probabilidad de superposición.

# Conclusiones

En este trabajo se ha demostrado que la utilización de algoritmos genéticos para la replicación de imágenes estilizadas es una elección viable. Se obtuvieron muy buenos resultados y se han logrado los objetivos. Además, se pudo comprobar que el uso de algoritmos aleatorios no brinda buenos resultados, siendo estos poco adaptables a los entornos y consumiendo mucho tiempo. En el proceso del desarrollo del trabajo se decidió implementar el algoritmo mejor de aleatorios, que a pesar de no contar con las características de explotación del algoritmo genético, es capaz de generar individuos decentes en poco tiempo.

Si el objetivo es generar una imagen de alta calidad que capture muchos detalles utilizando la menor cantidad de individuos posible, minimizando la superposición de texturas entre ellos, la superioridad del algoritmo genético es indiscutible. Por otro lado, si la prioridad es una experimentación rápida y la creación de imágenes con menor nivel de detalle, entonces optar por el algoritmo mejor de aleatorios resulta ser la decisión más adecuada.

No obstante, la principal desventaja de los algoritmos genéticos persiste: el tiempo de ejecución. La combinación del procesamiento de imágenes con algoritmos genéticos ha requerido la paralelización de componentes clave utilizando la GPU, tales como el muestreo de colores, el cálculo del fitness, la evaluación de métricas y el renderizado de imágenes. Sin esta paralelización, los tiempos de ejecución habrían dificultado considerablemente la realización de los experimentos. Es importante destacar que solo se paralelizaron los componentes esenciales, dejando margen para futuras optimizaciones del algoritmo en su conjunto.

Existen múltiples oportunidades de mejora y posibilidades para añadir características que amplíen la variedad de imágenes generadas. Una tarea pendiente, que podría mejorar significativamente los resultados en imágenes con gran cantidad de detalles, es la incorporación de filtros de detección de bordes, como el [operador de Sobel](https://de.wikipedia.org/wiki/Sobel-Operator), combinados con un [filtro Gaussiano](https://en.wikipedia.org/wiki/Gaussian_filter), para ponderar el fitness de los individuos de forma más precisa, fomentando la exploración de porciones de imagen más detalladas.

Otra de las tareas pendientes de este trabajo es realizar una comparativa de la cantidad de individuos requeridos para poder generar una imagen con un valor de la métrica fijo. Aunque según la experimentación realizada en este trabajo, es claro que el algoritmo genético logaría la métrica objetivo con una menor cantidad de individuos que el algoritmo mejor de individuos.

# Bibliografía

### Libros

**[1]** <a id="evolutionary-computing"></a> A. E. Eiben and J. E. Smith, Introduction to Evolutionary Computing, 2nd Edition, Springer, 2015. Disponible en: https://link.springer.com/book/10.1007/978-3-662-44874-8.

**[2]**. S. Russell and P. Norvig, Artificial Intelligence: A Modern Approach, 3rd Edition, Pearson Education, 2010.

### Referencias de herramientas

**[3]** <a id="godot-43"></a> Godot Engine, Godot 4.3, Disponible en: https://godotengine.org/.

**[4]** <a id="gdscript"></a> GDScript Basics, Disponible en: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html.

**[5]** <a id="glsl"></a> Khronos Group, Core Language (GLSL), Disponible en: https://www.khronos.org/opengl/wiki/Core_Language_(GLSL).

**[6]** <a id="python"></a> Python Software Foundation, Python 3.10 Documentation, Disponible en: https://www.python.org/.

**[7]** <a id="matplotlib"></a> The Matplotlib Development Team, Matplotlib: Visualization with Python, Disponible en: https://matplotlib.org/.

### Artículos en línea

**[8]** <a id="what-is-delta-e"></a> ViewSonic, "What is Delta E? And Why Is It Important for Color Accuracy?", Disponible en: https://www.viewsonic.com/library/creative-work/what-is-delta-e-and-why-is-it-important-for-color-accuracy/.

**[9]** <a id="delta-e-math"></a> Z. Schuessler, "Formulación matemática de Delta E", Disponible en: http://zschuessler.github.io/DeltaE/learn/.

**[10]** <a id="what-is-cielab"></a> "¿Que es CELab\*?", Disponible en: https://en.wikipedia.org/wiki/CIELAB_color_space

### Papers y proyectos

**[11]** Inspiración del proyecto, YouTube, Disponible en: https://www.youtube.com/watch?v=6aXx6RA1IK4.

**[12]** <a id="genetic-algorithm-for-image-recreation"></a> S. Charmot, "Genetic Algorithm for Image Recreation", Medium, Disponible en: https://medium.com/@sebastian.charmot/genetic-algorithm-for-image-recreation-4ca546454aaa.

**[13]** C. Cummins, "Grow Your Own Picture: Genetic Algorithms & Generative Art", Disponible en: https://chriscummins.cc/s/genetics/#.

**[14]** <a id="procedural-paintings"></a> S. Shahrabi, "Procedural Paintings with Genetic Evolution Algorithm", Medium, Disponible en: https://shahriyarshahrabi.medium.com/procedural-paintings-with-genetic-evolution-algorithm-6838a6e64703.

- Incluye cálculo de métricas con Delta E en el espacio de color CIELab, atributos genéticos propuestos y paralelización mediante compute shaders.

**[15]** <a id="genetic-drawing"></a> N. Opara, Genetic Drawing, Repositorio en GitHub, Disponible en: https://
github.com/anopara/genetic-drawing.

**[16]** <a id="ellipspace"></a> S. Mukherjee et al., "EllipScape: A Genetic Algorithm Based Approach to Non-Photorealistic Colored Image Reconstruction for Evolutionary Art", Proceedings of the 57th Hawaii International Conference on System Sciences (HICSS), 2024. Disponible en: https://aisel.aisnet.org/cgi/viewcontent.cgi?article=1613&context=hicss-57.

- Algoritmo genético distinto, utiliza Peak Signal-to-Noise Ratio (PSNR) como métrica de fitness.

**[17]** <a id="python-colour"></a> Librería de Python que cuenta con implementaciones de cálculo de delta E. https://github.com/colour-science/colour
