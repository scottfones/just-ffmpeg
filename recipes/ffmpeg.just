import 'config.just'

ffmpeg_dir := source_dir / 'ffmpeg'

ffmpeg_licenses := [
  '--enable-gpl',
  '--enable-version3',
  '--enable-nonfree',
]

ffmpeg_libraries := [
  '--enable-avisynth',
  '--enable-chromaprint',
  '--enable-libaom',
  '--enable-libass',
  '--enable-libbluray',
  '--enable-libbs2b',
  '--enable-libcaca',
  '--enable-libcdio',
  '--enable-libdav1d',
  '--enable-libfdk-aac',
  '--enable-libfontconfig',
  '--enable-libfreetype',
  '--enable-libfribidi',
  '--enable-libharfbuzz',
  '--enable-libmp3lame',
  '--enable-libmysofa',
  '--enable-libopenmpt',
  '--enable-libopus',
  '--enable-libplacebo',
  '--enable-libpulse',
  '--enable-librsvg',
  '--enable-librubberband',
  '--enable-libsoxr',
  '--enable-libssh',
  '--enable-libsvtav1',
  '--enable-libtesseract',
  '--enable-libtheora',
  '--enable-libvmaf',
  '--enable-libvorbis',
  '--enable-libvpx',
  '--enable-libwebp',
  '--enable-libx264',
  '--enable-libx265',
  '--enable-libxml2',
  '--enable-libzimg',
  '--enable-libzvbi',
  '--enable-lv2',
  '--enable-openssl',
  '--enable-vapoursynth',
]

# cuda-llvm for older nvidia card
ffmpeg_hardware := [
  '--enable-cuda-llvm',
  '--enable-cuvid',
  '--enable-ffnvcodec',
  '--enable-libdrm',
  '--enable-nvdec',
  '--enable-nvenc',
  '--enable-opencl',
  '--enable-opengl',
  '--enable-vulkan',
]

# Clone FFmpeg source
clone:
  @echo ''
  @echo '{{style(h2, 'Cloning FFmpeg')}}'
  git clone --depth 1 https://git.ffmpeg.org/ffmpeg.git '{{ffmpeg_dir}}'

# Pull FFmpeg source
pull:
  @echo ''
  @echo '{{style(h2, 'Pulling FFmpeg')}}'
  git -C '{{ffmpeg_dir}}' pull

# Get FFmpeg source
get:
  @echo ''
  @echo '{{style(h2, 'Getting FFmpeg')}}'
  @echo 'repo exists...{{ if path_exists(ffmpeg_dir / '.git') { 'true' } else { 'false' } }}'
  @just ffmpeg::{{ if path_exists(ffmpeg_dir / '.git') { 'pull' } else { 'clone' } }}
  @just ffmpeg::clean

# Configure FFmpeg
[working-directory(ffmpeg_dir)]
configure:
  @echo ''
  @echo '{{style(h2, 'Configuring FFmpeg')}}'
  ./configure \
    --prefix="{{build_dir}}" \
    --bindir="{{bin_dir}}" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I{{build_dir}}/include" \
    --extra-ldflags="-L{{build_dir}}/lib" \
    --extra-libs="-lpthread -lm" \
    --ld="g++" \
    --cpu=host \
    {{ffmpeg_licenses}} \
    {{ffmpeg_libraries}} \
    {{ffmpeg_hardware}}

# Make FFmpeg
[working-directory(ffmpeg_dir)]
make:
  @echo ''
  @echo '{{style(h2, 'Making FFmpeg')}}'
  make -j{{num_cpus()}}

# Install FFmpeg
[working-directory(ffmpeg_dir)]
install:
  @echo ''
  @echo '{{style(h2, 'Installing FFmpeg')}}'
  make install

# Build FFmpeg
build: && get configure make install
  @echo ''
  @echo '{{style(h1, 'Building FFmpeg')}}'

# Clean FFmpeg build artifacts
clean:
  @echo ''
  @echo '{{style(h3, 'Cleaning up FFmpeg')}}'
  git -C '{{ffmpeg_dir}}' clean -fdxq
