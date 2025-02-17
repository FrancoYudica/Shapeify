<div align="center">

<img src="imgs/GenartIconAndName.png" width=500></img>

<a href="https://github.com/FrancoYudica/Genart/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/badge/License-MIT-blue.svg?" /></a>
<a href="https://godotengine.org/download/"><img alt="Godot v4.3+" src="https://img.shields.io/badge/Godot-v4.3+-blue.svg?" /></a>
<a href="https://github.com/FrancoYudica/Genart/releases"><img alt="Latest Genart Release" src="https://img.shields.io/github/v/release/FrancoYudica/Genart?include_prereleases&"></a>
</div>

Genart is an application that transforms your target image into uniquely stylized artwork.
Smaller images are used as building blocks to reconstruct the target picture.

This tool is perfect for artists, designers, or anyone looking to experiment with creative and abstract image representations.

<div align="center">

<img src="https://github.com/user-attachments/assets/22578a87-1d6a-4a08-9506-2c7e2c722967" width=800></img>

</div>

## Features

- Reconstruct any image using a chosen set of smaller images as building blocks.
- Save generated artwork in formats such as PNG, JPG, WEBP, and JSON for use in custom projects.
- Load PNG, JPG, SVG, JPEG, BMP and WEBP images.
- Create animations with GenArt's integrated animator.
- Optimize results easily with predefined SUPER_FAST, FAST, PERFORMANCE, and QUALITY modes.
- Utilize tested default image collections for effortless creation.
- Customize algorithms with an extensive range of settings.
- Prioritize specific areas of the image using an automatically generated weight texture, guiding the algorithm to focus on the most important regions. Weight texture can also be provided by user to develop specific image regions.

## Installation

Genart is available through the following options:

- [Itch.io](https://franco-yudica.itch.io/genart)
- The latest [GitHub release](https://github.com/FrancoYudica/Genart/releases)
- Building the project locally using [Godot 4.3](https://godotengine.org/download).

## Animator

After the image is generated, you can apply animations, which are built into Genart by default. These function similarly to vertex shaders, allowing you to create animations like the following:

<div align="center">

<img src="imgs/samples/animations/icecream/timeline.gif" width="200"> 
<img src="imgs/samples/animations/icecream/scale_all.gif" width="200"> 
<img src="imgs/samples/animations/icecream/translate_top.gif" width="200">
<img src="imgs/samples/animations/icecream/wave_from_left.gif" width="200">

</div>

Note that animations are exported as a sequence of images, therefore using a tool such as [ffmpeg](https://www.ffmpeg.org/) is required in order to generate a video or gif.


## Post processing

Genart includes a set of post-processing effects that are applied after the shapes are generated, meaning they do not interfere with the core algorithm.

Currently, the available post-processing effects include:

- Hue Shift
- Value Shift
- Saturation Shift
- RGB Shift
- CIELAB Shift

Below are some examples showcasing the possibilities of the post-processing pipeline, achieved by combining multiple effects:

<div align="center">

<img src="https://github.com/user-attachments/assets/fb387ad2-3055-4ac5-b589-bc4ba7683eeb" title="Image without post processing" style="vertical-align: top;" width=125>
<img src="https://github.com/user-attachments/assets/0414a146-a037-4041-8ec8-bace543dee71" style="vertical-align: top;" width=125>
<img src="https://github.com/user-attachments/assets/8b27c4d4-b1cd-488d-aee7-3ace8eab9647" style="vertical-align: top;" width=125>
<img src="https://github.com/user-attachments/assets/5b9338c8-e4fc-4512-b991-3c33dbb61ffc" style="vertical-align: top;" width=125>
<img src="https://github.com/user-attachments/assets/3d739dd2-929e-4249-911f-cf8cfa7eaf48" style="vertical-align: top;" width=125>
<img src="https://github.com/user-attachments/assets/f66d86a8-8439-4589-8d77-e418ed6c15ea" style="vertical-align: top;" width=125>

</div>

## Settings

Genart provides an extensive range of configurable settings, allowing users to adjust the attributes of its algorithms through a dedicated interface. Additionally, pre-tested presets are available to produce high-quality results, offering a practical option for users who may not have prior knowledge of the underlying algorithms.


![all_toggle_panels](https://github.com/user-attachments/assets/72f9e4a2-1f81-4cd2-9c03-c2ad71e90678)

## Contributing

Contributions of all kinds are welcome! If you’re interested in contributing to this project, please take a moment to review [`CONTRIBUTING.md`](https://github.com/FrancoYudica/Genart/blob/main/CONTRIBUTING.md) file.

## Gallery

Here are some examples showcasing Genart’s versatility:

<div align="center">

<img src="https://github.com/user-attachments/assets/1e0c5fa0-c56a-4779-976a-b878cb011da0" title="Billie Eilish 500 shapes" style="vertical-align: top;" width=400>
<img src="https://github.com/user-attachments/assets/6969049d-084d-4483-b045-9413acb509dc" title="Flowers 500 shapes" style="vertical-align: top;" width=400>
<img src="https://github.com/user-attachments/assets/2b24f0b4-e0cb-43d6-8619-0ec5454be19b" title="Mona Lisa 300 rotated capsule shapes" style="vertical-align: top;" width=400>
<img src="https://github.com/user-attachments/assets/997b0a8f-9f2b-43c8-92ce-ac4b141511b7" title="Bunny 200 shapes" style="vertical-align: top;" width=400>
<img src="https://github.com/user-attachments/assets/59c6cfed-ef1c-4be3-8ac0-e64f03511365" title="Beach 350 shapes" style="vertical-align: top;" width=800>
<img src="https://github.com/user-attachments/assets/e8680bb0-3a4f-45f6-acb3-75cbc1f26e0b" title="People dancing 200 shapes" style="vertical-align: top;" width=400> 
<img src="https://github.com/user-attachments/assets/6fd4d317-b1c4-4eff-9258-c8698db704b9" title="Eye 400 shapes" style="vertical-align: top;" width=400>
<img src="https://github.com/user-attachments/assets/6d54294a-e804-4ef1-a9c0-bfae469827b6" title="Dwayne Johnson 400 shapes" style="vertical-align: top;" width=400>
<img src="https://github.com/user-attachments/assets/a5d00591-a1ca-4611-8aa1-480d6debd6b6" title="Sabana tree 300 shapes" style="vertical-align: top;" width=400>
<img src="https://github.com/user-attachments/assets/9f3c5b9e-9f70-47e4-ab93-aebf85ef2b9b" title="Train station 600 shapes" style="vertical-align: top;" width=800>
<img src="https://github.com/user-attachments/assets/8ffe17c1-1f48-4135-8410-453f323c3e0f" title="Breakdance 200 shapes" style="vertical-align: top;" width=400>
<img src="https://github.com/user-attachments/assets/d430de88-51de-4205-b1e0-56ff1cab9419" title="Flowers 200 shapes" style="vertical-align: top;" width=400>
<img src="https://github.com/user-attachments/assets/5500f41b-de4e-49ee-95ce-0addcbf3bf1f" title="Dog 300 shapes" style="vertical-align: top;" width=400>
<img src="https://github.com/user-attachments/assets/0df989fd-d0aa-41f0-b515-4e6e6d7497b8" title="Smoking 300 shapes" style="vertical-align: top;" width=400>

</div>

