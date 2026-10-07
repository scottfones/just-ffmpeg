import 'config.just'

aom_dir := source_dir / 'aom'
aom_build_dir := source_dir / 'aom_build'

# Clone aom source
clone:
  @echo ''
  @echo '{{style(h2, 'Cloning aom')}}'
  git clone --depth 1 https://aomedia.googlesource.com/aom '{{aom_dir}}'

# Pull aom source
pull:
  @echo ''
  @echo '{{style(h2, 'Pulling aom')}}'
  git -C '{{aom_dir}}' pull

# Get aom source
get:
  @echo ''
  @echo '{{style(h2, 'Getting aom')}}'
  @echo 'repo exists...{{ if path_exists(aom_dir / '.git') { 'true' } else { 'false' } }}'
  @just aom::{{ if path_exists(aom_dir / '.git') { 'pull' } else { 'clone'} }}
  @just aom::clean
  @mkdir -p '{{aom_build_dir}}'

# Configure aom
[working-directory(aom_build_dir)]
configure:
  @echo ''
  @echo '{{style(h2, 'Configuring aom')}}'
  cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="{{build_dir}}" -DCMAKE_BUILD_TYPE=Release -DENABLE_DOCS=OFF -DENABLE_EXAMPLES=OFF -DENABLE_TESTS=OFF -DENABLE_TOOLS=OFF -DENABLE_NASM=on "{{aom_dir}}"

# Make aom
[working-directory(aom_build_dir)]
make:
  @echo ''
  @echo '{{style(h2, 'Making aom')}}'
  make -j{{num_cpus()}}

# Install aom
[working-directory(aom_build_dir)]
install:
  @echo ''
  @echo '{{style(h2, 'Installing aom')}}'
  make install

# Build aom
build: && get configure make install
  @echo '{{style(h1, 'Building aom')}}'

# Clean aom build artifacts
clean:
  @echo ''
  @echo '{{style(h3, 'Cleaning up aom')}}'
  rm -rf '{{aom_build_dir}}'
