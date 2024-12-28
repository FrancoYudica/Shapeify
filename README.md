<img src="imgs/GenartIconAndName.png" width=500></img>
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](https://github.com/FrancoYudica/Genart/blob/main/LICENSE)

Genart is an application that transforms your target image into uniquely stylized artwork.
Smaller images are used as building blocks to reconstruct the target picture.

This tool is perfect for artists, designers, or anyone looking to experiment with creative and abstract image representations.

<div align="center">

<img src="imgs/GenartAppSample0.png" width=900></img>

</div>

## Features

- Reconstruct any image using a chosen set of smaller images as building blocks.
- Save generated artwork in formats such as PNG, JPG, and JPEG.
- Create dynamic animations with GenArt's integrated animator.
- Optimize results easily with predefined FAST, PERFORMANCE, and QUALITY modes.
- Utilize default image collections for effortless creation.
- Fully customizable algorithm with a wide range of settings.

## Animator

<div align="center">

<img src="imgs/GenartAppSampleAnimator.png" width=900></img>

</div>

Animations are exported as a sequence of images, therefore using a tool such as [ffmpeg](https://www.ffmpeg.org/) is required in order to generate a video or gif.

<div align="center">

|                               Timeline                                |                               Scale all                                |                             Translate from top                             |                               Wave from left                                |
| :-------------------------------------------------------------------: | :--------------------------------------------------------------------: | :------------------------------------------------------------------------: | :-------------------------------------------------------------------------: |
| <img src="imgs/samples/animations/icecream/timeline.gif" width="200"> | <img src="imgs/samples/animations/icecream/scale_all.gif" width="200"> | <img src="imgs/samples/animations/icecream/translate_top.gif" width="200"> | <img src="imgs/samples/animations/icecream/wave_from_left.gif" width="200"> |

</div>

## Installing

You can download the last github release or build the project yourself by cloning the source code and using Godot 4.3.

## Gallery

Some examples with different images as building blocks.

<div align="center">

| <img src="imgs/samples/MonaLisa300ind.png" alt="Mona Lisa" style="object-fit: cover;"> |
| :------------------------------------------------------------------------------------: |
|                        _Mona Lisa. 300 fixed rotation capsules_                        |

| <img src="imgs/samples/lambo-200ind.png" alt="Lambo" style="object-fit: cover;"> |
| :------------------------------------------------------------------------------: |
|              _Lamborghini Aventador. 200 geometric rounded objects_              |

| <img src="imgs/samples/BillieEilish500.png" alt="Billie Eilish" style="object-fit: cover;"> |
| :-----------------------------------------------------------------------------------------: |
|                             _Billie Eilish. 500 brush strokes_                              |

| <img src="imgs/samples/MilkyWay200indglow.png" alt="Milky Way" style="object-fit: cover;"> |
| :----------------------------------------------------------------------------------------: |
|                               _Milky Way. 200 glow objects_                                |

</div>
