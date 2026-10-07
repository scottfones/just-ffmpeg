set unstable
set lists

export PKG_CONFIG_PATH := build_dir / 'lib/pkgconfig'
export CFLAGS := "-march=native"
export CXXFLAGS := "-march=native"

# Directories
base_dir := justfile_dir()
bin_dir := build_dir / 'bin'
build_dir := base_dir / 'ffmpeg_build'
source_dir := base_dir / 'ffmpeg_sources'

# Styles
h1 := ['green', 'bold']
h2 := ['green']
h3 := ['green', 'dim']
