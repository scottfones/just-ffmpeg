import 'config.just'

# Build dependencies
reqs_build := [
  'base-devel',
  'clang',
  'cmake',
  'git',
  'github-cli',
  'meson',
  'nasm',
  'ninja',
  'xxd',
]

# FFMPEG dependencies
reqs_libraries := [
  'avisynthplus',
  'bzip2',
  'fontconfig',
  'freetype2',
  'fribidi',
  'harfbuzz',
  'libass',
  'libbluray',
  'libbs2b',
  'libcaca',
  'libcdio',
  'libcdio-paranoia',
  'libdrm',
  'libglvnd',
  'libmysofa',
  'libopenmpt',
  'libplacebo',
  'libpulse',
  'librsvg',
  'libsoxr',
  'libssh',
  'libtheora',
  'libva',
  'libvdpau',
  'libvorbis',
  'libwebp',
  'libxcb',
  'libxml2',
  'lilv',
  'lv2',
  'ocl-icd',
  'opencl-headers',
  'openssl',
  'rubberband',
  'sdl2-compat',
  'spirv-headers',
  'tesseract',
  'vapoursynth',
  'vulkan-headers',
  'vulkan-icd-loader',
  'zimg',
  'zlib',
  'zvbi',
]

# Check for missing packages
check:
  @echo ''
  @echo '{{style(h2, 'Checking requirements')}}'
  @pacman -T {{reqs_build}} {{reqs_libraries}} && echo 'All requirements are installed.' || { echo 'Run `just reqs::get` to install them.'; exit 1; }

# Install missing packages
get:
  @echo ''
  @echo '{{style(h2, 'Getting requirements')}}'
  sudo pacman -S --needed {{reqs_build}} {{reqs_libraries}}
