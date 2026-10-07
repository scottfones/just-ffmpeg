import 'config.just'

x264_dir := source_dir / 'x264'

# Clone libx264 source
[working-directory(source_dir)]
clone:
  @echo ''
  @echo '{{style(h2, 'Cloning libx264')}}'
  git clone --depth 1 https://code.videolan.org/videolan/x264.git

# Pull libx264 source
[working-directory(source_dir)]
pull:
  @echo ''
  @echo '{{style(h2, 'Pulling libx264')}}'
  git -C x264 pull 

# Get libx264 source
[working-directory(source_dir)]
get:
  @echo ''
  @echo '{{style(h2, 'Getting libx264')}}'
  @echo 'repo exists...{{ if path_exists(x264_dir / '.git') { 'true' } else { 'false' } }}'
  @just x264::{{ if path_exists(x264_dir / '.git') { 'pull' } else { 'clone'} }}
  @just x264::clean

# Configure libx264
[working-directory(x264_dir)]
configure:
  @echo ''
  @echo '{{style(h2, 'Configuring libx264')}}'
  ./configure --prefix="{{build_dir}}" --bindir="{{bin_dir}}" --disable-cli --enable-static --enable-pic


# Make libx264
[working-directory(x264_dir)]
make:
  @echo ''
  @echo '{{style(h2, 'Making libx264')}}'
  make -j{{num_cpus()}}

# Install libx264
[working-directory(x264_dir)]
install:
  @echo ''
  @echo '{{style(h2, 'Installing libx264')}}'
  make install

# Build libx264
build: && get configure make install
  @echo '{{style(h1, 'Building libx264')}}'

# Clean libx264 build artifacts
clean:
  @echo ''
  @echo '{{style(h3, 'Cleaning up libx264')}}'
  git -C '{{x264_dir}}' clean -fdxq
