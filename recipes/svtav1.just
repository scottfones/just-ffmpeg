import 'config.just'

svtav1_dir := source_dir / 'SVT-AV1'
svtav1_build_dir := svtav1_dir / 'build'

# Clone SVT-AV1 source
clone:
  @echo ''
  @echo '{{style(h2, 'Cloning SVT-AV1')}}'
  git clone https://gitlab.com/AOMediaCodec/SVT-AV1.git '{{svtav1_dir}}'

# Pull SVT-AV1 source
pull:
  @echo ''
  @echo '{{style(h2, 'Pulling SVT-AV1')}}'
  git -C '{{svtav1_dir}}' pull

# Get SVT-AV1 source
get:
  @echo ''
  @echo '{{style(h2, 'Getting SVT-AV1')}}'
  @echo 'repo exists...{{ if path_exists(svtav1_dir / '.git') { 'true' } else { 'false' } }}'
  @just svtav1::{{ if path_exists(svtav1_dir / '.git') { 'pull' } else { 'clone' } }}
  @just svtav1::clean
  @mkdir -p '{{svtav1_build_dir}}'

# Configure SVT-AV1
[working-directory(svtav1_build_dir)]
configure:
  @echo ''
  @echo '{{style(h2, 'Configuring SVT-AV1')}}'
  cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="{{build_dir}}" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DBUILD_APPS=OFF "{{svtav1_dir}}"

# Make SVT-AV1
[working-directory(svtav1_build_dir)]
make:
  @echo ''
  @echo '{{style(h2, 'Making SVT-AV1')}}'
  make -j{{num_cpus()}}

# Install SVT-AV1
[working-directory(svtav1_build_dir)]
install:
  @echo ''
  @echo '{{style(h2, 'Installing SVT-AV1')}}'
  make install

# Build SVT-AV1
build: && get configure make install
  @echo '{{style(h1, 'Building SVT-AV1')}}'

# Clean SVT-AV1 build artifacts
clean:
  @echo ''
  @echo '{{style(h3, 'Cleaning up SVT-AV1')}}'
  rm -rf '{{svtav1_build_dir}}'
