class_name Constants extends Node

## Defines the maximum amount of pixels of the target texture. The main propuse 
## of this restriction is to reduce the complexity of the image generation algo.
static var MAX_PIXEL_COUNT: int = 1920 * 1080

## Sizes in bytes of the maximum memory allocated by compute shaders
static var MAX_COMPUTE_BUFFER_SIZE: int = 524288
