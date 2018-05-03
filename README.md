# 環境設定

## 開発環境

* OS - OS X HighSierra
* エミュレータ - QEMU emulator version 2.11.0
Copyright (c) 2003-2017 Fabrice Bellard and the QEMU Project developers
* アセンブラ - nasm
* gcc - i386-elf-gcc (base gcc ver6)
* ld - gnu ld 

書籍のアセンブラやビルドはWindows環境及び、著者の独自アセンブラで書かれています。
また、macにプリインストールされているgcc, ldではi386のイメージがオプションの都合でビルドできないため最初にクロスコンパイル環境は構築します。

## クロスコンパイル環境構築

day3以降はC言語とアセンブラのオブジェクトファイルをリンクしてビルドします。
この際にOS X既存のGCCでは上手くビルドできないため以下の手順を行ってください。

### i386-elf-gcc, gnu ldの導入

以下のコマンドを実行して導入します。
これで各日付ディレクトリ内の `make run` でqemuが立ち上がるはずです。

```
brew install gcc6

export CC=/usr/local/Cellar/gcc@6/6.4.0_2/bin/gcc-6 # ↑の手順でinstallしたGCCのパス
export LD=/usr/local/bin/gcc@6/6.4.0_2/bin/gcc-6

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
cd /tmp/src
curl -O https://ftp.gnu.org/gnu/gcc/gcc-6.4.0/gcc-6.4.0.tar.gz
tar xf gcc-6.4.0.tar.gz
mkdir gcc-build
cd gcc-build
../gcc-6.4.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --disable-libssp --enable-languages=c --without-headers --with-gmp=/usr/local --with-mpfr=/usr/local --with-mpfr=/usr/local --with-libiconv-prefix=/usr/local
make all-gcc 
make all-target-libgcc 
sudo make install-gcc 
sudo make install-target-libgcc
```


