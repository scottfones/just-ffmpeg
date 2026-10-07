import 'config.just'

aac_dir := source_dir / 'fdk-aac'

# Clone libfdk_aac source
clone:
  @echo ''
  @echo '{{style(h2, 'Cloning libfdk_aac')}}'
  gh repo clone mstorsjo/fdk-aac '{{aac_dir}}'


# Pull libfdk_aac source
pull:
  @echo ''
  @echo '{{style(h2, 'Pulling libfdk_aac')}}'
  git -C '{{aac_dir}}' pull

# Get libfdk_aac source
get:
  @echo ''
  @echo '{{style(h2, 'Getting libfdk_aac')}}'
  @echo '{{aac_dir}}'
  @echo 'repo exists...{{ if path_exists(aac_dir / '.git') { 'true' } else { 'false' } }}'
  @just aac::{{ if path_exists(aac_dir / '.git') { 'pull' } else { 'clone'} }}
  @just aac::clean

# Configure libfdk_aac
[working-directory(aac_dir)]
configure:
  @echo ''
  @echo '{{style(h2, 'Configuring libfdk_aac')}}'
  autoreconf -fiv
  ./configure --prefix="{{build_dir}}" --bindir="{{bin_dir}}" --disable-shared CFLAGS="-O2 $CFLAGS" CXXFLAGS="-O2 $CXXFLAGS"

# Make libfdk_aac
[working-directory(aac_dir)]
make:
  @echo ''
  @echo '{{style(h2, 'Making libfdk_aac')}}'
  make -j{{num_cpus()}}

# Install libfdk_aac
[working-directory(aac_dir)]
install:
  @echo ''
  @echo '{{style(h2, 'Installing libfdk_aac')}}'
  make install

# Build libfdk_aac
build: && get configure make install
  @echo ''
  @echo '{{style(h1, 'Building libfdk_aac')}}'

# Clean libfdk_aac build artifacts
clean:
  @echo ''
  @echo '{{style(h3, 'Cleaning up libfdk_aac')}}'
  git -C '{{aac_dir}}' clean -fdxq
