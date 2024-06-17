# mpv Upscaling Comparison - Now featuring CuNNy!! 😭😭😭😭😭

This is an attempt to match the very well made mpv upscaling comparison on
Artoriuz's blog (https://artoriuz.github.io/blog/mpv_upscaling.html) and add
comparisons with the CuNNy upscaler.

The file tested is `aoko.png`. It is converted to greyscale and downsampled in
gamma-light using the same method as described in the blogpost.

CuNNy models with the 'fp16' suffix can be found in this folder. The models
without 'fp16' suffix are all 8-bit quantized `dp4a` versions. They can be found
in the `dp4a` subdirectory of this folder. For reference, command used to
prepare the dataset is: `py proc.py data/eroge-128 data/mpv/mpv-nvl-box -yb`.

Updated models can be found in the `mpv/` subdirectory of this project.

# Results
Command: `mpv --no-config --vo=gpu-next --gpu-api=vulkan --no-hidpi-window-scale --window-scale=2.0 --pause=yes --screenshot-format=png --sigmoid-upscaling --deband=no --dither-depth=no --screenshot-high-bit-depth=no --osc=no aoko-lr.png`.

Comparing `aoko.png`

| Name | MAE (-) | PSNR (+) | SSIM (+) | MS-SSIM (+) | LPIPS-Alex (-) | LPIPS-VGG (-) | MAE (N) | PSNR (N) | SSIM (N) | MS-SSIM (N) | LPIPS-Alex (N) | LPIPS-VGG (N) | Mean |
| - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| CuNNy-8x32-fp16        | **0.00485** | **36.41974** | **0.99085** | 0.99945 | **0.00726** | **0.01733** | **1.000** | **1.000** | **1.000** | 0.999 | **1.000** | **1.000** | **1.000** |
| ArtCNN-C4F64-JAX       | 0.00516 | 35.99083 | 0.99032 | **0.99946** | 0.00806 | 0.01843 | 0.980 | 0.960 | 0.992 | **1.000** | 0.995 | 0.990 | 0.986 |
| CuNNy-4x32-fp16        | 0.00511 | 36.03550 | 0.99007 | 0.99942 | 0.00787 | 0.01904 | 0.983 | 0.964 | 0.988 | 0.995 | 0.996 | 0.985 | 0.985 |
| CuNNy-4x32     | 0.00536 | 35.91548 | 0.98939 | 0.99935 | 0.00800 | 0.02161 | 0.967 | 0.953 | 0.978 | 0.988 | 0.996 | 0.962 | 0.974 |
| ArtCNN-C4F32-JAX       | 0.00542 | 35.62700 | 0.98958 | 0.99943 | 0.00885 | 0.01965 | 0.962 | 0.926 | 0.981 | 0.997 | 0.991 | 0.979 | 0.973 |
| CuNNy-4x16     | 0.00611 | 34.89888 | 0.98702 | 0.99920 | 0.01044 | 0.02686 | 0.917 | 0.858 | 0.941 | 0.973 | 0.982 | 0.915 | 0.931 |
| ArtCNN-C4F16-JAX       | 0.00633 | 34.42294 | 0.98678 | 0.99928 | 0.01221 | 0.02686 | 0.902 | 0.813 | 0.938 | 0.981 | 0.972 | 0.915 | 0.920 |
| CuNNy-4x12     | 0.00665 | 34.41677 | 0.98579 | 0.99914 | 0.01147 | 0.02942 | 0.881 | 0.812 | 0.922 | 0.967 | 0.976 | 0.892 | 0.908 |
| CuNNy-3x8      | 0.00790 | 33.16919 | 0.98155 | 0.99890 | 0.01538 | 0.04199 | 0.799 | 0.695 | 0.857 | 0.943 | 0.953 | 0.779 | 0.838 |
| ArtCNN-C4F8-JAX        | 0.00818 | 32.71098 | 0.98160 | 0.99902 | 0.01807 | 0.04053 | 0.780 | 0.653 | 0.858 | 0.954 | 0.938 | 0.792 | 0.829 |
| CuNNy-2x8      | 0.00849 | 32.62496 | 0.97957 | 0.99879 | 0.01721 | 0.04907 | 0.760 | 0.644 | 0.827 | 0.931 | 0.943 | 0.716 | 0.804 |
| Anime4K_Upscale_UL     | 0.00906 | 32.52657 | 0.97925 | 0.99786 | 0.02026 | 0.04639 | 0.722 | 0.635 | 0.822 | 0.834 | 0.925 | 0.740 | 0.780 |
| Anime4K_Upscale_VL     | 0.00936 | 32.37935 | 0.97813 | 0.99788 | 0.02063 | 0.05127 | 0.702 | 0.621 | 0.805 | 0.837 | 0.923 | 0.696 | 0.764 |
| FSRCNNX_x2_16-0-4-1    | 0.00968 | 31.72720 | 0.97804 | 0.99807 | 0.02197 | 0.05249 | 0.681 | 0.560 | 0.804 | 0.857 | 0.916 | 0.685 | 0.750 |
| FSRCNNX_x2_8-0-4-1_LineArt     | 0.00961 | 31.95294 | 0.97637 | 0.99832 | 0.02161 | 0.05713 | 0.686 | 0.582 | 0.778 | 0.882 | 0.918 | 0.643 | 0.748 |
| CuNNy-1x8      | 0.01020 | 31.28666 | 0.97352 | 0.99847 | 0.02661 | 0.07715 | 0.647 | 0.519 | 0.734 | 0.898 | 0.889 | 0.464 | 0.692 |
| FSRCNNX_x2_8-0-4-1     | 0.01071 | 31.05344 | 0.97298 | 0.99804 | 0.02576 | 0.07031 | 0.613 | 0.497 | 0.726 | 0.853 | 0.894 | 0.525 | 0.685 |
| ravu-lite-ar-r4        | 0.01070 | 30.53948 | 0.97091 | 0.99805 | 0.03662 | 0.07227 | 0.613 | 0.449 | 0.694 | 0.855 | 0.832 | 0.508 | 0.659 |
| ravu-lite-ar-r3        | 0.01102 | 30.31550 | 0.96920 | 0.99800 | 0.04028 | 0.07227 | 0.593 | 0.428 | 0.668 | 0.849 | 0.811 | 0.508 | 0.643 |
| FSR    | 0.01431 | 28.46247 | 0.95641 | 0.99648 | 0.06250 | 0.09766 | 0.375 | 0.255 | 0.472 | 0.692 | 0.683 | 0.280 | 0.459 |
| ewa_lanczos4sharpest   | 0.01408 | 28.42126 | 0.95648 | 0.99630 | 0.09814 | 0.08984 | 0.390 | 0.251 | 0.473 | 0.673 | 0.479 | 0.350 | 0.436 |
| lanczos        | 0.01521 | 28.30954 | 0.95275 | 0.99666 | 0.12109 | 0.11133 | 0.315 | 0.240 | 0.415 | 0.710 | 0.347 | 0.158 | 0.364 |
| ewa_lanczossharp       | 0.01607 | 27.87723 | 0.94756 | 0.99534 | 0.14062 | 0.11523 | 0.259 | 0.200 | 0.336 | 0.574 | 0.235 | 0.123 | 0.288 |
| bilinear       | 0.01999 | 25.74570 | 0.92566 | 0.98979 | 0.18164 | 0.12891 | 0.000 | 0.000 | 0.000 | 0.000 | 0.000 | 0.000 | 0.000 |

# Frametimes

Command: `mpv --no-config --profile=fast --vo=gpu-next --sid=no --gpu-api=vulkan --audio=no --untimed=yes --video-sync=display-desync --fullscreen=yes`.

Using an RTX 4090 with GPU clocks locked to maximum upscaling a 1080p anime
video -> 4K.

Unfortunately I had to make use a different method to the one described in
the blogpost as it did not work well on my machine and resulted in `fast` and
`FSR` to only have a couple seconds difference.

This method is a very unscientific way of eyeballing the average frametime after
a couple seconds so I suggest taking the results with a handful of salt.

Also due to hardware/drivers likely being different these numbers will not fully
match what you will get anyway so I recommend testing everything out yourself on
your own machine.

| Preset | Frametime (us) | Score |
| - | - | - |
| fast | 50 | - |
| lanczos | 95 | 0.364 |
| ravu-lite-ar-r3 | 140 | 0.643 |
| ewa_lanczossharp | 150 | 0.288 |
| FSR | 175 | 0.459 |
| ravu-lite-ar-r4 | 180 | 0.659 |
| CuNNy-1x8 | 230 | 0.692 |
| CuNNy-2x8 | 280 | 0.804 |
| CuNNy-3x8 | 320 | 0.838 |
| CuNNy-4x12 | 560 | 0.908 |
| FSRCNNX_x2_8-0-4-1/LineArt | 600 | 0.685, 0.748 |
| ArtCNN-C4F8-JAX | 710 | 0.829 |
| CuNNy-4x16 | 770 | 0.931 |
| Anime4K_Upscale_VL | 1700 | 0.764 |
| ArtCNN-C4F16-JAX | 1970 | 0.920 |
| CuNNy-4x32 | 2350 | 0.974 |
| FSRCNNX_x2_16-0-4-1 | 2360 | 0.750 |
| Anime4K_Upscale_UL | 2650 | 0.780 |
| CuNNy-4x32-fp16 | 3050 | 0.985 |
| CuNNy-8x32-fp16 | 5600 | 1.000 |
| ArtCNN-C4F32-JAX | 7200 | 0.973 |
| ArtCNN-C4F64-JAX | 15300 | 0.986 |
