<img src="imgs/GenartIconAndName.png" width=500></img>
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](https://github.com/FrancoYudica/Genart/blob/main/LICENSE)

Genart is an application that transforms your target image into uniquely stylized artwork.
Smaller images are used as building blocks to reconstruct the target picture.

This tool is perfect for artists, designers, or anyone looking to experiment with creative and abstract image representations.

<div align="center">

<img src="https://github.com/user-attachments/assets/93a80909-5bb0-4a7d-bca0-6a515866f7e3" width=800></img>

</div>

## Features

- Reconstruct any image using a chosen set of smaller images as building blocks.
- Save generated artwork in formats such as PNG, JPG, WEBP and JSON for use in custom projects.
- Create animations with GenArt's integrated animator.
- Optimize results easily with predefined FAST, PERFORMANCE, and QUALITY modes.
- Utilize default image collections for effortless creation.
- Customizable algorithm with a wide range of settings.

## Animator

<div align="center">
<img src="https://github.com/user-attachments/assets/bc3f2675-75ab-4b8f-9d19-9b900da3f427" width=800></img>
</div>

Animations are exported as a sequence of images, therefore using a tool such as [ffmpeg](https://www.ffmpeg.org/) is required in order to generate a video or gif.

<div align="center">

|                               Timeline                                |                               Scale all                                |                             Translate from top                             |                               Wave from left                                |
| :-------------------------------------------------------------------: | :--------------------------------------------------------------------: | :------------------------------------------------------------------------: | :-------------------------------------------------------------------------: |
| <img src="imgs/samples/animations/icecream/timeline.gif" width="200"> | <img src="imgs/samples/animations/icecream/scale_all.gif" width="200"> | <img src="imgs/samples/animations/icecream/translate_top.gif" width="200"> | <img src="imgs/samples/animations/icecream/wave_from_left.gif" width="200"> |

</div>

## Settings
Genart provides an extensive range of configurable settings, allowing users to adjust the attributes of its algorithms through a dedicated interface. Additionally, pre-tested presets are available to produce high-quality results, offering a practical option for users who may not have prior knowledge of the underlying algorithms.
<div align="center">
<img src="https://github.com/user-attachments/assets/6d462f63-1d08-4e41-b413-e8cdcd1c96fe" width=500></img>
<img src="https://github.com/user-attachments/assets/25160229-3b51-4571-ae51-573f59288e33" width=500></img>
</div>

## Installation

Genart is available through the following options:  
- [Itch.io](https://franco-yudica.itch.io/genart)  
- The latest [GitHub release](https://github.com/FrancoYudica/Genart/releases)  
- Building the project locally using [Godot 4.3](https://godotengine.org/download).


## Remaining tasks

### Multithreaded individual generator

Genart prioritizes offering a wide range of creative control over raw performance. While this focus enables extensive customization, it may come at the cost of speed. Implementing multithreading within the individual generator algorithms will address this by enhancing responsiveness and overall user experience.

## Gallery

Some examples with different images as building blocks.

<div align="center">


| <img src="https://github.com/user-attachments/assets/2b24f0b4-e0cb-43d6-8619-0ec5454be19b" alt="Mona Lisa" style="object-fit: cover;"> | <img src="https://github.com/user-attachments/assets/8bac080b-9d6a-4193-a19e-3a335b2f673c" alt="Billie Eilish" style="object-fit: cover;">| 
| :------------------------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------------------------: |
|                        _Mona Lisa. 300 fixed rotation capsules_                                                                        | _Billie Eilish. 500 brush strokes_                                                                                                        |

| <img src="https://github.com/user-attachments/assets/22099d50-b632-4ea3-a019-428ac209c54b"> | <img src="https://github.com/user-attachments/assets/8b3cb5a1-ec83-4138-9438-bc45177a0d86" alt="Milky Way" style="object-fit: cover;"> |
| :-----------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------------------------: |
|              _Lamborghini Aventador. 200 geometric rounded objects_                         |                                _Milky Way. 200 glow objects_                                                                           |

</div>
