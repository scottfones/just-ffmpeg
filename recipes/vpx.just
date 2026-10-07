import 'config.just'

vpx_dir := source_dir / 'libvpx'

# Clone libvpx source
[working-directory(source_dir)]
clone:
  @echo ''
  @echo '{{style(h2, 'Cloning libvpx')}}'
  git clone https://chromium.googlesource.com/webm/libvpx.git

# Pull libvpx source
[working-directory(source_dir)]
pull:
  @echo ''
  @echo '{{style(h2, 'Pulling libvpx')}}'
  git -C libvpx pull 

# Get libvpx source
[working-directory(source_dir)]
get:
  @echo ''
  @echo '{{style(h2, 'Getting libvpx')}}'
  @echo 'repo exists...{{ if path_exists(vpx_dir / '.git') { 'true' } else { 'false' } }}'
  @just vpx::{{ if path_exists(vpx_dir / '.git') { 'pull' } else { 'clone'} }}
  @just vpx::clean

# Configure libvpx
[working-directory(vpx_dir)]
configure:
  @echo ''
  @echo '{{style(h2, 'Configuring libvpx')}}'
  ./configure --prefix="{{build_dir}}" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=nasm --enable-pic

# Make libvpx
[working-directory(vpx_dir)]
make:
  @echo ''
  @echo '{{style(h2, 'Making libvpx')}}'
  make -j{{num_cpus()}}

# Install libvpx
[working-directory(vpx_dir)]
install:
  @echo ''
  @echo '{{style(h2, 'Installing libvpx')}}'
  make install

# Build libvpx
build: && get configure make install
  @echo '{{style(h1, 'Building libvpx')}}'

# Clean libvpx build artifacts
clean:
  @echo ''
  @echo '{{style(h3, 'Cleaning up libvpx')}}'
  git -C '{{vpx_dir}}' clean -fdxq
