#!/bin/bash 

set -e 
set -x 

PG_ROOT=/tmp/pg11
PG_HOME=$PG_ROOT/postgresql-11.2
INSTALL_DIR=$PG_ROOT/install
DIST_DIR=$PG_ROOT/dist
PACKAGE_NAME=postgresql-Linux-x86_64.txz

darwin=false
case "`uname`" in
  Darwin* )
    darwin=true
    PACKAGE_NAME=postgresql-Darwin-x86_64.txz
    ;;
esac


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
	$PG_HOME/configure --prefix $INSTALL_DIR
	echo "config log is available at $PG_ROOT/build_dir/config.log"
	echo "starting build"
	make
	## this installs to the $INSTALL_DIR specified above
	make install
	popd
}

run() {
	pushd $PG_ROOT
	rm -rf data && mkdir -p data
	install/bin/initdb -D ./data
	install/bin/pg_ctl -D ./data -l logfile -o "-p 5432 -F -c timezone=UTC -c synchronous_commit=off -c max_connections=300" start
	install/bin/pg_ctl -D ./data status
	echo "stopping server"
	install/bin/pg_ctl -D ./data stop
	popd
}

package() {
	pushd $INSTALL_DIR
	mkdir -p $DIST_DIR
	tar -cJf $DIST_DIR/$PACKAGE_NAME bin include lib share
	echo "created postgres 11 binary at $DIST_DIR"
	popd
}

main() {
	downloadSourceCode
	build
	run
	package
}

main

