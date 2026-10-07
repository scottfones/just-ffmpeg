import 'config.just'

x265_dir := source_dir / 'x265'
x265_build_dir := source_dir / 'x265_build'

# Clone libx265 source
clone:
  @echo ''
  @echo '{{style(h2, 'Cloning libx265')}}'
  gh repo clone Multicorewareinc/x265 '{{x265_dir}}'

# Pull libx265 source
pull:
  @echo ''
  @echo '{{style(h2, 'Pulling libx265')}}'
  git -C '{{x265_dir}}' pull

# Get libx265 source
get:
  @echo ''
  @echo '{{style(h2, 'Getting libx265')}}'
  @echo 'repo exists...{{ if path_exists(x265_dir / '.git') { 'true' } else { 'false' } }}'
  @just x265::{{ if path_exists(x265_dir / '.git') { 'pull' } else { 'clone' } }}
  @just x265::clean
  @mkdir -p '{{x265_build_dir}}'

# Configure libx265
[working-directory(x265_build_dir)]
configure:
  @echo ''
  @echo '{{style(h2, 'Configuring libx265')}}'
  cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="{{build_dir}}" -DCMAKE_BUILD_TYPE=Release -DENABLE_CLI=OFF -DENABLE_SHARED=OFF -DHIGH_BIT_DEPTH=ON "{{x265_dir}}/source"

# Make libx265
[working-directory(x265_build_dir)]
make:
  @echo ''
  @echo '{{style(h2, 'Making libx265')}}'
  make -j{{num_cpus()}}

# Install libx265
[working-directory(x265_build_dir)]
install:
  @echo ''
  @echo '{{style(h2, 'Installing libx265')}}'
  make install

# Build libx265
build: && get configure make install
  @echo '{{style(h1, 'Building libx265')}}'

# Clean libx265 build artifacts
clean:
  @echo ''
  @echo '{{style(h3, 'Cleaning up libx265')}}'
  rm -rf '{{x265_build_dir}}'
