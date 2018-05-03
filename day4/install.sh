export CC=/usr/local/Cellar/gcc@6/6.4.0_2/bin/gcc-6 # ↑の手順でinstallしたGCCのパス
export LD=/usr/local/Cellar/gcc@6/6.4.0_2/bin/gcc-6

export PREFIX="/usr/local/i386elfgcc"
export TARGET=i386-elf
export PATH="$PREFIX/bin:$PATH"

# binutilsのインストール
mkdir /tmp/src
cd /tmp/src
curl -O http://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.gz
tar xf binutils-2.28.tar.gz
mkdir binutils-build
cd binutils-build
../binutils-2.28/configure --target=$TARGET --enable-interwork --enable-multilib --disable-nls --disable-werror --prefix=$PREFIX 2>&1 | tee configure.log
sudo make all install 2>&1 | tee make.log

# OSXデフォルトのlibiconvは古すぎてGCCのビルドでこけたので、最新版をインストールする
cd /tmp/src
curl -O https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz
tar xf libiconv-1.15.tar.gz
cd libiconv-1.15
./configure -prefix=/usr/local
make
make install

# クロスコンパイラなGCCをビルド
# バージョンは特にこだわりがなかったので、homebrewで入れたGCCのバージョンに合わせた
cd /tmp/src
curl -O https://ftp.gnu.org/gnu/gcc/gcc-5.3.0/gcc-5.3.0.tar.bz2
tar xf gcc-5.3.0.tar.bz2
mkdir gcc-build
cd gcc-build
../gcc-5.3.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --disable-libssp --enable-languages=c --without-headers --with-gmp=/usr/local --with-mpfr=/usr/local --with-mpfr=/usr/local --with-libiconv-prefix=/usr/local
make all-gcc 
make all-target-libgcc 
sudo make install-gcc 
sudo make install-target-libgcc

# /usr/local/i386elfgcc/bin配下にGCCがインストールされている
# 念のためバージョン確認
/usr/local/i386elfgcc/bin/i386-elf-gcc -v
