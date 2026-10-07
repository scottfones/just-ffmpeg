import 'recipes/config.just'

mod aac 'recipes/aac.just'
mod aom 'recipes/aom.just'
mod chromaprint 'recipes/chromaprint.just'
mod dav1d 'recipes/dav1d.just'
mod ffmpeg 'recipes/ffmpeg.just'
mod mp3 'recipes/mp3.just'
mod nvcodec 'recipes/nvcodec.just'
mod opus 'recipes/opus.just'
mod reqs 'recipes/reqs.just'
mod svtav1 'recipes/svtav1.just'
mod vmaf 'recipes/vmaf.just'
mod vpx 'recipes/vpx.just'
mod x264 'recipes/x264.just'
mod x265 'recipes/x265.just'

# Build everything
build-all: && aac::build aom::build chromaprint::build dav1d::build mp3::build nvcodec::build opus::build svtav1::build vmaf::build vpx::build x264::build x265::build ffmpeg::build
  @echo '{{ style(h1, "Building everything") }}'
