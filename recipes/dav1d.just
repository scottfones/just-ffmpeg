import 'config.just'

dav1d_dir := source_dir / 'dav1d'
dav1d_build_dir := dav1d_dir / 'build'

# Clone dav1d source
clone:
  @echo ''
  @echo '{{style(h2, 'Cloning dav1d')}}'
  git clone --depth 1 https://code.videolan.org/videolan/dav1d.git '{{dav1d_dir}}'

# Pull dav1d source
pull:
  @echo ''
  @echo '{{style(h2, 'Pulling dav1d')}}'
  git -C '{{dav1d_dir}}' pull

# Get dav1d source
get:
  @echo ''
  @echo '{{style(h2, 'Getting dav1d')}}'
  @echo 'repo exists...{{ if path_exists(dav1d_dir / '.git') { 'true' } else { 'false' } }}'
  @just dav1d::{{ if path_exists(dav1d_dir / '.git') { 'pull' } else { 'clone' } }}
  @just dav1d::clean
  @mkdir -p '{{dav1d_build_dir}}'

# Configure dav1d
[working-directory(dav1d_build_dir)]
configure:
  @echo ''
  @echo '{{style(h2, 'Configuring dav1d')}}'
  meson setup -Denable_tools=false -Denable_tests=false --default-library=static --prefix "{{build_dir}}" --libdir="{{build_dir}}/lib" "{{dav1d_dir}}"

# Make dav1d
[working-directory(dav1d_build_dir)]
make:
  @echo ''
  @echo '{{style(h2, 'Making dav1d')}}'
  ninja

# Install dav1d
[working-directory(dav1d_build_dir)]
install:
  @echo ''
  @echo '{{style(h2, 'Installing dav1d')}}'
  ninja install

# Build dav1d
build: && get configure make install
  @echo ''
  @echo '{{style(h1, 'Building dav1d')}}'

# Clean dav1d build artifacts
clean:
  @echo ''
  @echo '{{style(h3, 'Cleaning up dav1d')}}'
  rm -rf '{{dav1d_build_dir}}'
