# CuNNy - Convolutional upscaling Neural Network, yeah!

Nice, small, and fast realtime CNN-based upscaler. Trained on visual novel
screenshots/CG.

Currently very new and immature 😭.

Supports exporting to an mpv ~~meme~~shader!

And now a Magpie effect!

# Usage

The order of quality is 8x32 > 4x32 > 4x24 > 4x16 > 4x12 > 3x12 > 2x12 > fast >
faster > veryfast. Conversely the order of speed would be the reverse.

The `CuNNy-fast` shader is the recommended shader if you're on a slow machine.

Variants:
- (No-suffix): Trained to be neutral and do no denoising or sharpening.
- `SOFT`: Trained to anti-alias & produce a soft output. Is probably the most
  'artifact-free' variant if you don't count blur.
- `DS`: Trained to denoise & sharpen.
- `NVL`: Trained to upscale visual novel games & high-quality illustrations.

### mpv

mpv shaders are found inside the `mpv/` directory.
Metric-focused variants are found inside the `results/` directory.
To activate, add `glsl-shader="path/to/shader.glsl"` to your
[mpv.conf](https://mpv.io/manual/stable/#configuration-files).

There are versions of the mpv shaders use 8-bit `dp4a` instructions. They can be
many times faster than the standard upscaling shader depending on if your
hardware supports accelerated `dp4a` instructions. Requires `vo=gpu-next` with
`gpu-api=vulkan`. They can be found inside the `dp4a/` subdirectories.

### Magpie

Magpie effects are found inside the `magpie/` directory.
To install, drag the files into the `effects` subfolder inside the root of your
Magpie installation. Once installed you will be able to add the effect in the
`Scaling modes` tab.

As CuNNy only upscales by a factor of 2x, if you are scaling a ratio between 1
and 2 (i.e. 720 -> 1080 \[1.5x\]) you will need to downscale after upscaling.

The choice of downscaler has a large effect on the resulting image quality and
sharpness. A high-quality downscale effect is provided in this repository
located inside the same `magpie/` directory. Apply the downscale effect after
the upscale effect.

# Training

Tested training with PyTorch nightly on Linux with Python 3.11. If any errors
arise try using nightly.

Create folders by running `sh scripts/mkfolders.sh`.
Prepare data by running `sh scripts/split.sh
<input-folder> <output-128-grids>`, then `py scripts/proc.py <128-grids> <out>`.

To train `py train.py <data> <N> <D>` where `N` is the number of internal
convolutions and `D` is the number of feature layers.

Convert the resulting model to an mpv shader by running
`py mpv.py <models/model.pickle>`.

Convert the resulting model to a Magpie effect by running
`py magpie.py <models/model.pickle>`.

Trains very fast on my machine.

# Quality

See `results/`.

# License

LGPL v3
