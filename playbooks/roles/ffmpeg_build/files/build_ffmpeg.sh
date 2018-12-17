#!/bin/sh

#sudo yum -y install autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make mercurial pkgconfig zlib-devel

mkdir ~/ffmpeg_sources

#nasm
cd ~/ffmpeg_sources
#wget https://www.nasm.us/pub/nasm/releasebuilds/2.14rc15/nasm-2.14rc15.tar.xz
#tar xvfJ nasm-2.14rc15.tar.xz
#cd nasm-2.14rc15
wget https://www.nasm.us/pub/nasm/releasebuilds/2.14rc16/nasm-2.14rc16.tar.xz
tar xvfJ nasm-2.14rc16.tar.xz
cd nasm-2.14rc16
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install

#libx264
cd ~/ffmpeg_sources
git clone --depth 1 git://git.videolan.org/x264
cd x264
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
make
make install


#libx265
cd ~/ffmpeg_sources
hg clone https://bitbucket.org/multicoreware/x265
cd ~/ffmpeg_sources/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off ../../source
make
make install


#libfdk_aac
cd ~/ffmpeg_sources
git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install


#libmp3lame
cd ~/ffmpeg_sources
curl -O -L http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar xzvf lame-3.100.tar.gz
cd lame-3.100
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm
make
make install


#libopus
cd ~/ffmpeg_sources
git clone http://git.opus-codec.org/opus.git
cd opus
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install


#libogg
cd ~/ffmpeg_sources
curl -O https://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.3.tar.gz
tar xzvf libogg-1.3.3.tar.gz
cd libogg-1.3.3
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install

#libvorbis
cd ~/ffmpeg_sources
curl -O https://ftp.osuosl.org/pub/xiph/releases/vorbis/libvorbis-1.3.6.tar.gz
tar xzvf libvorbis-1.3.6.tar.gz
cd libvorbis-1.3.6
LDFLAGS="-L$HOME/ffmeg_build/lib" CPPFLAGS="-I$HOME/ffmpeg_build/include" ./configure --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --disable-shared
make
make install

#libvpx
cd ~/ffmpeg_sources
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="$HOME/ffmpeg_build" --disable-examples
make
make install

#AV1
cd ~/ffmpeg_sources
git clone --depth 1 https://aomedia.googlesource.com/aom
mkdir aom_build
cd aom_build
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off -DENABLE_NASM=on ../aom
make
make install

##############################################################################################################
# Added by naoki
# Freetype2
cd ~/ffmpeg_sources
wget http://jaist.dl.sourceforge.net/sourceforge/freetype/freetype-2.9.1.tar.gz
tar xzvf freetype-2.9.1.tar.gz
cd freetype-2.9.1
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
##############################################################################################################

#FFmpeg
cd ~/ffmpeg_sources
wget https://ffmpeg.org/releases/ffmpeg-4.1.tar.xz
tar Jxfv ffmpeg-4.1.tar.xz
cd ffmpeg*
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig:$HOME/ffmpeg_build/lib64/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib" --extra-libs="-lpthread -lm" --bindir="$HOME/bin" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-libaom
make
make install
hash -r


