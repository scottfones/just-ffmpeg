import 'config.just'

vmaf_dir := source_dir / 'vmaf'
vmaf_lib_dir := vmaf_dir / 'libvmaf'
vmaf_build_dir := vmaf_lib_dir / 'build'

# Clone libvmaf source
[working-directory(source_dir)]
clone:
  @echo ''
  @echo '{{style(h2, 'Cloning libvmaf')}}'
  git clone --depth 1 https://github.com/Netflix/vmaf.git

# Pull libvmaf source
[working-directory(source_dir)]
pull:
  @echo ''
  @echo '{{style(h2, 'Pulling libvmaf')}}'
  git -C vmaf pull

# Get libvmaf source
[working-directory(source_dir)]
get:
  @echo ''
  @echo '{{style(h2, 'Getting libvmaf')}}'
  @echo 'repo exists...{{ if path_exists(vmaf_dir / '.git') { 'true' } else { 'false' } }}'
  @just vmaf::{{ if path_exists(vmaf_dir / '.git') { 'pull' } else { 'clone' } }}
  @just vmaf::clean
  @mkdir -p '{{vmaf_build_dir}}'

# Configure libvmaf
[working-directory(vmaf_build_dir)]
configure:
  @echo ''
  @echo '{{style(h2, 'Configuring libvmaf')}}'
  meson setup -Denable_tests=false -Denable_docs=false --buildtype=release --default-library=static --prefix "{{build_dir}}" --bindir="{{bin_dir}}" --libdir="{{build_dir}}/lib" "{{vmaf_lib_dir}}"

# Make libvmaf
[working-directory(vmaf_build_dir)]
make:
  @echo ''
  @echo '{{style(h2, 'Making libvmaf')}}'
  ninja

# Install libvmaf
[working-directory(vmaf_build_dir)]
install:
  @echo ''
  @echo '{{style(h2, 'Installing libvmaf')}}'
  ninja install

# Build libvmaf
build: && get configure make install
  @echo '{{style(h1, 'Building libvmaf')}}'

# Clean libvmaf build artifacts
clean:
  @echo ''
  @echo '{{style(h3, 'Cleaning up libvmaf')}}'
  rm -rf '{{vmaf_build_dir}}'
