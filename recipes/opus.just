import 'config.just'

opus_dir := source_dir / 'opus'

# Clone libopus source
clone:
  @echo ''
  @echo '{{style(h2, 'Cloning libopus')}}'
  gh repo clone xiph/opus '{{opus_dir}}'

# Pull libopus source
pull:
  @echo ''
  @echo '{{style(h2, 'Pulling libopus')}}'
  git -C '{{opus_dir}}' pull

# Get libopus source
get:
  @echo ''
  @echo '{{style(h2, 'Getting libopus')}}'
  @echo 'repo exists...{{ if path_exists(opus_dir / '.git') { 'true' } else { 'false' } }}'
  @just opus::{{ if path_exists(opus_dir / '.git') { 'pull' } else { 'clone'} }}
  @just opus::clean

# Configure libopus
[working-directory(opus_dir)]
configure:
  @echo ''
  @echo '{{style(h2, 'Configuring libopus')}}'
  ./autogen.sh
  ./configure --prefix="{{build_dir}}" --bindir="{{bin_dir}}" --disable-shared --enable-pic CFLAGS="-O2 $CFLAGS"


# Make libopus
[working-directory(opus_dir)]
make:
  @echo ''
  @echo '{{style(h2, 'Making libopus')}}'
  make -j{{num_cpus()}}

# Install libopus
[working-directory(opus_dir)]
install:
  @echo ''
  @echo '{{style(h2, 'Installing libopus')}}'
  make install

# Build libopus
build: && get configure make install
  @echo '{{style(h1, 'Building libopus')}}'

# Clean libopus build artifacts
clean:
  @echo ''
  @echo '{{style(h3, 'Cleaning up libopus')}}'
  git -C '{{opus_dir}}' clean -fdxq -e 'opus_data-*.tar.gz'
