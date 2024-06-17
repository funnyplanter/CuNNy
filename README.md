# CuNNy - Convolutional upscaling Neural Network, yeah!

Nice, small, and fast realtime CNN-based upscaler. Trained on visual novel
screenshots/CG.

Currently very new and immature 😭.

Supports exporting to an mpv ~~meme~~shader!

And now a Magpie effect!

# Usage

mpv shaders are found inside the `mpv/` directory.
Metric-focused variants are found inside the `results/` directory.

Magpie effects are found inside the `magpie/` directory.

The order of quality is 8x32 > 4x32 > 4x24 > 4x16 > 4x12 > 3x12 > 2x12 > fast >
faster > veryfast. Conversely the order of speed would be the reverse.

The `CuNNy-fast` shader is the recommended shader if you're on a slow machine.

Variants:
- (No-suffix): Trained to be neutral and do no denoising or sharpening.
- `DS`: Trained to denoise & sharpen images.
- `NVL`: Trained on VN screenshots/CG.

There are versions of the mpv shaders use 8-bit `dp4a` instructions. They can be
many times faster than the standard upscaling shader depending on if your
hardware supports accelerated `dp4a` instructions. Requires `vo=gpu-next` with
`gpu-api=vulkan`. They can be found inside the `dp4a/` subdirectories.

# Training

Tested training with PyTorch nightly. If any errors arise try using nightly.

Prepare data by running `sh scripts/build.sh`, then `sh scripts/split.sh
<input-folder> <output-128-grids>`, then `py scripts/proc.py <128-grids> <out>`.

To train `py train.py <data> <N> <D>` where `N` is the number of internal
convolutions and `D` is the number of feature layers.

Convert the resulting model to an mpv shader by running
`py mpv.py <models/model.pt>`.

Convert the resulting model to a Magpie effect by running
`py magpie.py <models/model.pt>`.

Trains very fast on my machine.

# Quality

See `results/`.

# License

LGPL v3
