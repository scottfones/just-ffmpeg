import 'config.just'

nvcodec_dir := source_dir / 'nv-codec-headers'
# sdk/13.0 for old nvidia gpu
nvcodec_branch := 'sdk/13.0'

# Clone nv-codec-headers source
[working-directory(source_dir)]
clone:
  @echo ''
  @echo '{{style(h2, 'Cloning nv-codec-headers')}}'
  git clone --depth 1 --branch '{{nvcodec_branch}}' https://git.videolan.org/git/ffmpeg/nv-codec-headers.git

# Pull nv-codec-headers source
[working-directory(source_dir)]
pull:
  @echo ''
  @echo '{{style(h2, 'Pulling nv-codec-headers')}}'
  git -C nv-codec-headers pull

# Get nv-codec-headers source
[working-directory(source_dir)]
get:
  @echo ''
  @echo '{{style(h2, 'Getting nv-codec-headers')}}'
  @echo 'repo exists...{{ if path_exists(nvcodec_dir / '.git') { 'true' } else { 'false' } }}'
  @just nvcodec::{{ if path_exists(nvcodec_dir / '.git') { 'pull' } else { 'clone' } }}

# Install nv-codec-headers
[working-directory(nvcodec_dir)]
install:
  @echo ''
  @echo '{{style(h2, 'Installing nv-codec-headers')}}'
  make install PREFIX="{{build_dir}}"

# Build nv-codec-headers
build: && get install
  @echo '{{style(h1, 'Building nv-codec-headers')}}'
