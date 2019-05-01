#!/bin/bash 

set -e 
set -x 

PG_ROOT=/tmp/pg11
PG_HOME=$PG_ROOT/postgresql-11.2

downloadSourceCode() {
	[ -e $PG_ROOT ] && echo "$PG_ROOT already exists - skipping download" && return 0;
	echo "downloading postgres source code..."
	mkdir -p $PG_ROOT
	pushd $PG_ROOT
	wget -O pg-11.2.tar.gz "https://ftp.postgresql.org/pub/source/v11.2/postgresql-11.2.tar.gz"
	gunzip pg-11.2.tar.gz
	tar xf pg-11.2.tar
	echo "source code extracted at $PG_ROOT"
	popd
}

build() {
	pushd $PG_ROOT
	mkdir -p build_dir
	cd build_dir
	$PG_HOME/configure
	echo "config log is available at $PG_ROOT/build_dir/config.log"
	echo "starting build"
	make
	popd
}

main() {
	downloadSourceCode
	build
}

main
