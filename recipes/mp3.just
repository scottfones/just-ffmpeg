import 'config.just'

mp3_dir := source_dir / f"lame-{{mp3_ver}}"
mp3_link := f"https://sourceforge.net/projects/lame/files/lame/{{mp3_ver}}/lame-{{mp3_ver}}.tar.gz/download"
mp3_ver := "4.0"

# Get LAME source
[working-directory(source_dir)]
get:
  @echo ''
  @echo '{{style(h2, 'Getting LAME')}}'
  @echo 'source exists... {{ if path_exists(mp3_dir) { 'true' } else { 'false' } }}'
  @[ -d "{{mp3_dir}}" ] || curl -fsSL "{{mp3_link}}" | tar -xvz
  @just mp3::clean

# Configure LAME
[working-directory(mp3_dir)]
configure:
  @echo ''
  @echo '{{style(h2, 'Configuring LAME')}}'
  ./configure --prefix="{{build_dir}}" --bindir="{{bin_dir}}" --disable-frontend --disable-decoder --disable-shared --enable-pic CFLAGS="-O3 -ffast-math $CFLAGS"


# Make LAME
[working-directory(mp3_dir)]
make:
  @echo ''
  @echo '{{style(h2, 'Making LAME')}}'
  make -j{{num_cpus()}}

# Install LAME
[working-directory(mp3_dir)]
install:
  @echo ''
  @echo '{{style(h2, 'Installing LAME')}}'
  make install

# Build LAME
build: && get configure make install
  @echo '{{style(h1, 'Building LAME')}}'

# Clean LAME build artifacts
clean:
  @echo ''
  @echo '{{style(h3, 'Cleaning up LAME')}}'
  [ ! -f '{{mp3_dir}}/Makefile' ] || make -C '{{mp3_dir}}' distclean >/dev/null
