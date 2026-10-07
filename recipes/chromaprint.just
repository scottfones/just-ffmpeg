import 'config.just'

chromaprint_dir := source_dir / 'chromaprint'
chromaprint_build_dir := chromaprint_dir / 'build'

# Clone chromaprint source
clone:
  @echo ''
  @echo '{{style(h2, 'Cloning chromaprint')}}'
  git clone --depth 1 https://github.com/acoustid/chromaprint.git '{{chromaprint_dir}}'

# Pull chromaprint source
pull:
  @echo ''
  @echo '{{style(h2, 'Pulling chromaprint')}}'
  git -C '{{chromaprint_dir}}' pull

# Get chromaprint source
get:
  @echo ''
  @echo '{{style(h2, 'Getting chromaprint')}}'
  @echo 'repo exists...{{ if path_exists(chromaprint_dir / '.git') { 'true' } else { 'false' } }}'
  @just chromaprint::{{ if path_exists(chromaprint_dir / '.git') { 'pull' } else { 'clone' } }}
  @just chromaprint::clean
  @mkdir -p '{{chromaprint_build_dir}}'

# Configure chromaprint
[working-directory(chromaprint_build_dir)]
configure:
  @echo ''
  @echo '{{style(h2, 'Configuring chromaprint')}}'
  cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="{{build_dir}}" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTS=OFF -DFFT_LIB=kissfft "{{chromaprint_dir}}"

# Make chromaprint
[working-directory(chromaprint_build_dir)]
make:
  @echo ''
  @echo '{{style(h2, 'Making chromaprint')}}'
  make -j{{num_cpus()}}

# Install chromaprint
[working-directory(chromaprint_build_dir)]
install:
  @echo ''
  @echo '{{style(h2, 'Installing chromaprint')}}'
  make install

# Build chromaprint
build: && get configure make install
  @echo ''
  @echo '{{style(h1, 'Building chromaprint')}}'

# Clean chromaprint build artifacts
clean:
  @echo ''
  @echo '{{style(h3, 'Cleaning up chromaprint')}}'
  rm -rf '{{chromaprint_build_dir}}'
