#!/bin/bash

echo "$(tput setaf 2)"
echo "###################################################################"
echo "# Preparing to build Google Protobuf"
echo "###################################################################"
echo "$(tput sgr0)"

# The results will be stored relative to the location
# where you stored this script, **not** relative to
# the location of the protobuf git repo.
PREFIX=`pwd`/protobuf
if [ -d ${PREFIX} ]
then
    rm -rf "${PREFIX}"
fi
mkdir -p "${PREFIX}/platform"

# A "YES" value will build the latest code from GitHub on the master branch.
# A "NO" value will use the 3.6.1 tarball downloaded from googlecode.com.
USE_GIT_MASTER=NO


PROTOBUF_GIT_URL=https://github.com/google/protobuf.git
PROTOBUF_GIT_DIRNAME=protobuf
PROTOBUF_VERSION=3.6.1

#PROTOBUF_RELEASE_TYPE=all
PROTOBUF_RELEASE_TYPE=cpp

PROTOBUF_RELEASE_URL=https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protobuf-${PROTOBUF_RELEASE_TYPE}-${PROTOBUF_VERSION}.tar.gz
PROTOBUF_RELEASE_DIRNAME=protobuf-${PROTOBUF_VERSION}

BUILD_MACOSX_X86_64=YES

BUILD_I386_IOSSIM=NO
BUILD_X86_64_IOSSIM=YES

BUILD_IOS_ARMV7=NO
BUILD_IOS_ARMV7S=NO
BUILD_IOS_ARM64=YES

BUILD_WATCHOS=YES
BUILD_WATCHSIMULATOR=YES

PROTOBUF_SRC_DIR=./temp

DARWIN=darwin`uname -r`

XCODEDIR=`xcode-select --print-path`
IOS_SDK_VERSION=`xcrun --sdk iphoneos --show-sdk-version`
MIN_SDK_VERSION=8.0

MACOSX_PLATFORM=${XCODEDIR}/Platforms/MacOSX.platform
MACOSX_SYSROOT=${MACOSX_PLATFORM}/Developer/SDKs/MacOSX.sdk
MIN_MACOS_VERSION=12.0

IPHONEOS_PLATFORM=`xcrun --sdk iphoneos --show-sdk-platform-path`
IPHONEOS_SYSROOT=`xcrun --sdk iphoneos --show-sdk-path`

IPHONESIMULATOR_PLATFORM=`xcrun --sdk iphonesimulator --show-sdk-platform-path`
IPHONESIMULATOR_SYSROOT=`xcrun --sdk iphonesimulator --show-sdk-path`

WATCHOS_PLATFORM=`xcrun --sdk watchos --show-sdk-platform-path`
WATCHOS_SYSROOT=`xcrun --sdk watchos --show-sdk-path`
MIN_WATCHOS_VERSION=4.0

WATCHSIMULATOR_PLATFORM=`xcrun --sdk watchsimulator --show-sdk-platform-path`
WATCHSIMULATOR_SYSROOT=`xcrun --sdk watchsimulator --show-sdk-path`


# Uncomment if you want to see more information about each invocation
# of clang as the builds proceed.
# CLANG_VERBOSE="--verbose"
CC=clang
CXX=clang
SILENCED_WARNINGS="-Wno-unused-local-typedef -Wno-unused-function"
# NOTE: Google Protobuf does not currently build if you specify 'libstdc++'
# instead of `libc++` here.
STDLIB=libc++
CFLAGS="${CLANG_VERBOSE} ${SILENCED_WARNINGS} -DNDEBUG -Os -pipe -fPIC -fcxx-exceptions -fembed-bitcode"
CFLAGS_OSX="${CLANG_VERBOSE} ${SILENCED_WARNINGS} -DNDEBUG -Os -pipe -fPIC -fcxx-exceptions"
CXXFLAGS="${CLANG_VERBOSE} ${CFLAGS} -std=c++11 -stdlib=${STDLIB}"
CXXFLAGS_OSX="${CLANG_VERBOSE} ${CFLAGS_OSX} -std=c++11 -stdlib=${STDLIB}"
LDFLAGS="-stdlib=${STDLIB}"
LIBS="-lc++ -lc++abi"

echo "PREFIX ..................... ${PREFIX}"
echo "USE_GIT_MASTER ............. ${USE_GIT_MASTER}"
echo "PROTOBUF_GIT_URL ........... ${PROTOBUF_GIT_URL}"
echo "PROTOBUF_GIT_DIRNAME ....... ${PROTOBUF_GIT_DIRNAME}"
echo "PROTOBUF_VERSION ........... ${PROTOBUF_VERSION}"
echo "PROTOBUF_RELEASE_URL ....... ${PROTOBUF_RELEASE_URL}"
echo "PROTOBUF_RELEASE_DIRNAME ... ${PROTOBUF_RELEASE_DIRNAME}"
echo "BUILD_MACOSX_X86_64 ........ ${BUILD_MACOSX_X86_64}"
echo "BUILD_I386_IOSSIM .......... ${BUILD_I386_IOSSIM}"
echo "BUILD_X86_64_IOSSIM ........ ${BUILD_X86_64_IOSSIM}"
echo "BUILD_IOS_ARMV7 ............ ${BUILD_IOS_ARMV7}"
echo "BUILD_IOS_ARMV7S ........... ${BUILD_IOS_ARMV7S}"
echo "BUILD_IOS_ARM64 ............ ${BUILD_IOS_ARM64}"
echo "BUILD_WATCHOS .............. ${BUILD_WATCHOS}"
echo "BUILD_WATCHSIMULATOR ....... ${BUILD_WATCHSIMULATOR}"
echo "PROTOBUF_SRC_DIR ........... ${PROTOBUF_SRC_DIR}"
echo "DARWIN ..................... ${DARWIN}"
echo "XCODEDIR ................... ${XCODEDIR}"
echo "IOS_SDK_VERSION ............ ${IOS_SDK_VERSION}"
echo "MIN_SDK_VERSION ............ ${MIN_SDK_VERSION}"
echo "MIN_WATCHOS_VERSION ........ ${MIN_WATCHOS_VERSION}"
echo "MACOSX_PLATFORM ............ ${MACOSX_PLATFORM}"
echo "MACOSX_SYSROOT ............. ${MACOSX_SYSROOT}"
echo "IPHONEOS_PLATFORM .......... ${IPHONEOS_PLATFORM}"
echo "IPHONEOS_SYSROOT ........... ${IPHONEOS_SYSROOT}"
echo "IPHONESIMULATOR_PLATFORM ... ${IPHONESIMULATOR_PLATFORM}"
echo "IPHONESIMULATOR_SYSROOT .... ${IPHONESIMULATOR_SYSROOT}"
echo "WATCHOS_PLATFORM ........... ${WATCHOS_PLATFORM}"
echo "WATCHOS_SYSROOT ............ ${WATCHOS_SYSROOT}"
echo "WATCHSIMULATOR_PLATFORM .... ${WATCHSIMULATOR_PLATFORM}"
echo "WATCHSIMULATOR_SYSROOT ..... ${WATCHSIMULATOR_SYSROOT}"
echo "CC ......................... ${CC}"
echo "CFLAGS ..................... ${CFLAGS}"
echo "CXX ........................ ${CXX}"
echo "CXXFLAGS ................... ${CXXFLAGS}"
echo "LDFLAGS .................... ${LDFLAGS}"
echo "LIBS ....................... ${LIBS}"

while true; do
    read -p "Proceed with build? (y/n) " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "$(tput setaf 2)"
echo "###################################################################"
echo "# Fetch Google Protobuf"
echo "###################################################################"
echo "$(tput sgr0)"

(
    if [ -d ${PROTOBUF_SRC_DIR} ]
    then
      rm -rf ${PROTOBUF_SRC_DIR}    
    fi

    cd `dirname ${PROTOBUF_SRC_DIR}`

    if [ "${USE_GIT_MASTER}" == "YES" ]
    then
        git clone ${PROTOBUF_GIT_URL}
    else
        if [ -d ${PROTOBUF_RELEASE_DIRNAME} ]
        then
            rm -rf "${PROTOBUF_RELEASE_DIRNAME}"
        fi
        
        if [ -f ${PROTOBUF_RELEASE_DIRNAME}.tar.gz ]
        then
        	echo "File ${PROTOBUF_RELEASE_DIRNAME}.tar.gz already exist, no need to re-download"
        else
        	echo "File ${PROTOBUF_RELEASE_DIRNAME}.tar.gz does not exist, will download"
         	curl --location ${PROTOBUF_RELEASE_URL} --output ${PROTOBUF_RELEASE_DIRNAME}.tar.gz        	
        fi
        
        tar xvf ${PROTOBUF_RELEASE_DIRNAME}.tar.gz
        mv "${PROTOBUF_RELEASE_DIRNAME}" "${PROTOBUF_SRC_DIR}"
        patch "${PROTOBUF_SRC_DIR}/src/google/protobuf/compiler/subprocess.cc" "./subprocess.patch"
        
        # Fix descriptor.h
		sed -i '' '/#define GOOGLE_PROTOBUF_DESCRIPTOR_H__/a\
		#undef TYPE_BOOL
		' ${PROTOBUF_SRC_DIR}/src/google/protobuf/descriptor.h

		# Remove the version of Google Test included with the release.
		if [ -d "${PROTOBUF_SRC_DIR}/gtest" ]
			then
				rm -r "${PROTOBUF_SRC_DIR}/gtest"
			fi
    fi
)

echo "$(tput setaf 2)"
echo "###################################################################"
echo "# Prepare the Configure Script"
echo "###################################################################"
echo "$(tput sgr0)"

(
    cd ${PROTOBUF_SRC_DIR}

    # Check that we're being run from the right directory.
    if test ! -f src/google/protobuf/stubs/common.h
    then
        cat >&2 << __EOF__
Could not find source code.  Make sure you are running this script from the
root of the distribution tree.
__EOF__
        exit 1
    fi

    autoreconf -f -i -Wall,no-obsolete
    rm -rf autom4te.cache config.h.in~
)

###################################################################
# This section contains the build commands to create the native
# protobuf library for Mac OS X.  This is done first so we have
# a copy of the protoc compiler.  It will be used in all of the
# susequent iOS builds.
###################################################################

echo "$(tput setaf 2)"
echo "###################################################################"
echo "# x86_64 for Mac OS X"
echo "###################################################################"
echo "$(tput sgr0)"

if [ "${BUILD_MACOSX_X86_64}" == "YES" ]
then
    (
	    export MACOSX_DEPLOYMENT_TARGET="${MIN_MACOS_VERSION}"
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        ./configure --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/x86_64-mac "CC=${CC}" "CFLAGS=${CFLAGS} -arch x86_64" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS} -arch x86_64" "LDFLAGS=${LDFLAGS}" "LIBS=${LIBS}"
        make
        #make check
        make install
        unset MACOSX_DEPLOYMENT_TARGET
    )
fi

PROTOC=${PREFIX}/platform/x86_64-mac/bin/protoc


###################################################################
# This section contains the build commands for each of the 
# architectures that will be included in the universal binaries.
###################################################################

echo "$(tput setaf 2)"
echo "###########################"
echo "# i386 for iPhone Simulator"
echo "###########################"
echo "$(tput sgr0)"

if [ "${BUILD_I386_IOSSIM}" == "YES" ]
then
    (
	    export IPHONEOS_DEPLOYMENT_TARGET="${MIN_SDK_VERSION}"
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        ./configure --build=x86_64-apple-${DARWIN} --host=i386-apple-${DARWIN} --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/i386-sim "CC=${CC}" "CFLAGS=${CFLAGS} -mios-simulator-version-min=${MIN_SDK_VERSION} -arch i386 -isysroot ${IPHONESIMULATOR_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS} -arch i386 -isysroot ${IPHONESIMULATOR_SYSROOT}" LDFLAGS="-arch i386 -mios-simulator-version-min=${MIN_SDK_VERSION} ${LDFLAGS}" "LIBS=${LIBS}"
        make
        make install
        unset IPHONEOS_DEPLOYMENT_TARGET
    )
fi

echo "$(tput setaf 2)"
echo "#############################"
echo "# x86_64 for iPhone Simulator"
echo "#############################"
echo "$(tput sgr0)"

if [ "${BUILD_X86_64_IOSSIM}" == "YES" ]
then
    (
	    export IPHONEOS_DEPLOYMENT_TARGET="${MIN_SDK_VERSION}"
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        ./configure --build=x86_64-apple-${DARWIN} --host=x86_64-apple-${DARWIN} --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/x86_64-sim "CC=${CC}" "CFLAGS=${CFLAGS} -mios-simulator-version-min=${MIN_SDK_VERSION} -arch x86_64 -isysroot ${IPHONESIMULATOR_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS} -arch x86_64 -isysroot ${IPHONESIMULATOR_SYSROOT}" LDFLAGS="-arch x86_64 -mios-simulator-version-min=${MIN_SDK_VERSION} ${LDFLAGS}" "LIBS=${LIBS}"
        make
        make install
        unset IPHONEOS_DEPLOYMENT_TARGET
    )
fi

echo "$(tput setaf 2)"
echo "##################"
echo "# armv7 for iPhone"
echo "##################"
echo "$(tput sgr0)"

if [ "${BUILD_IOS_ARMV7}" == "YES" ]
then
    (
	    export IPHONEOS_DEPLOYMENT_TARGET="${MIN_SDK_VERSION}"    
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        ./configure --build=x86_64-apple-${DARWIN} --host=armv7-apple-${DARWIN} --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/armv7-ios "CC=${CC}" "CFLAGS=${CFLAGS} -miphoneos-version-min=${MIN_SDK_VERSION} -arch armv7 -isysroot ${IPHONEOS_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS} -arch armv7 -isysroot ${IPHONEOS_SYSROOT}" LDFLAGS="-arch armv7 -miphoneos-version-min=${MIN_SDK_VERSION} ${LDFLAGS}" "LIBS=${LIBS}"
        make
        make install
        unset IPHONEOS_DEPLOYMENT_TARGET
    )
fi

echo "$(tput setaf 2)"
echo "###################"
echo "# armv7s for iPhone"
echo "###################"
echo "$(tput sgr0)"

if [ "${BUILD_IOS_ARMV7S}" == "YES" ]
then
    (
	    export IPHONEOS_DEPLOYMENT_TARGET="${MIN_SDK_VERSION}"    
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        ./configure --build=x86_64-apple-${DARWIN} --host=armv7s-apple-${DARWIN} --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/armv7s-ios "CC=${CC}" "CFLAGS=${CFLAGS} -miphoneos-version-min=${MIN_SDK_VERSION} -arch armv7s -isysroot ${IPHONEOS_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS} -arch armv7s -isysroot ${IPHONEOS_SYSROOT}" LDFLAGS="-arch armv7s -miphoneos-version-min=${MIN_SDK_VERSION} ${LDFLAGS}" "LIBS=${LIBS}"
        make
        make install
        unset IPHONEOS_DEPLOYMENT_TARGET
    )
fi

echo "$(tput setaf 2)"
echo "##################"
echo "# arm64 for iPhone"
echo "##################"
echo "$(tput sgr0)"

if [ "${BUILD_IOS_ARM64}" == "YES" ]
then
    (
	    export IPHONEOS_DEPLOYMENT_TARGET="${MIN_SDK_VERSION}"    
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        ./configure --build=x86_64-apple-${DARWIN} --host=arm --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/arm64-ios "CC=${CC}" "CFLAGS=${CFLAGS} -miphoneos-version-min=${MIN_SDK_VERSION} -arch arm64 -isysroot ${IPHONEOS_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS} -arch arm64 -isysroot ${IPHONEOS_SYSROOT}" LDFLAGS="-arch arm64 -miphoneos-version-min=${MIN_SDK_VERSION} ${LDFLAGS}" "LIBS=${LIBS}"
        make
        make install
        unset IPHONEOS_DEPLOYMENT_TARGET
    )
fi

echo "$(tput setaf 2)"
echo "###################"
echo "# arm7k for WatchOS"
echo "###################"
echo "$(tput sgr0)"

if [ "${BUILD_WATCHOS}" == "YES" ]
then
    (
	    export WATCHOS_DEPLOYMENT_TARGET="${MIN_WATCHOS_VERSION}"
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        ./configure --build=x86_64-apple-${DARWIN} --host=armv7k-apple-${DARWIN} --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/armv7k-watchos "CC=${CC}" "CFLAGS=${CFLAGS} -mwatchos-version-min=${MIN_WATCHOS_VERSION} -arch armv7k -isysroot ${WATCHOS_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS} -arch armv7k -isysroot ${WATCHOS_SYSROOT}" LDFLAGS="-arch armv7k -mwatchos-version-min=${MIN_WATCHOS_VERSION} ${LDFLAGS}" "LIBS=${LIBS}"
        make
        make install
        unset WATCHOS_DEPLOYMENT_TARGET
    )
fi

echo "$(tput setaf 2)"
echo "###########################"
echo "# i386 for Watch Simulator"
echo "###########################"
echo "$(tput sgr0)"

if [ "${BUILD_WATCHSIMULATOR}" == "YES" ]
then
    (
	    export WATCHOS_DEPLOYMENT_TARGET="${MIN_WATCHOS_VERSION}"
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        ./configure --build=x86_64-apple-${DARWIN} --host=i386-apple-${DARWIN} --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/watchos-sim "CC=${CC}" "CFLAGS=${CFLAGS} -mwatchos-simulator-version-min=${MIN_WATCHOS_VERSION} -arch i386 -isysroot ${WATCHSIMULATOR_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS} -arch i386 -isysroot ${WATCHSIMULATOR_SYSROOT}" LDFLAGS="-arch i386 -mwatchos-simulator-version-min=${MIN_WATCHOS_VERSION} ${LDFLAGS}" "LIBS=${LIBS}"
        make
        make install
        unset WATCHOS_DEPLOYMENT_TARGET
    )
fi

echo "$(tput setaf 2)"
echo "###################################################################"
echo "# Create Universal Libraries and Finalize the packaging"
echo "###################################################################"
echo "$(tput sgr0)"
(
cd ${PREFIX}/platform
mkdir universal
for i in `ls x86_64-mac/lib/*.a`
do
i=`basename $i`
lipo -create *sim/lib/$i *watchos/lib/$i *ios/lib/$i -output universal/$i
done
)
(
cd ${PREFIX}
mkdir bin
mkdir lib
cp -r platform/x86_64-mac/bin/protoc bin
cp -r platform/x86_64-mac/lib/* lib
cp -r platform/universal/* lib
#rm -rf platform
lipo -info lib/libprotobuf.a
lipo -info lib/libprotobuf-lite.a
)
if [ "${USE_GIT_MASTER}" == "YES" ]
then
if [ -d "${PREFIX}-master" ]
then
rm -rf "${PREFIX}-master"
fi
mv "${PREFIX}" "${PREFIX}-master"
else
if [ -d "${PREFIX}-${PROTOBUF_VERSION}" ]
then
rm -rf "${PREFIX}-${PROTOBUF_VERSION}"
fi
mv "${PREFIX}" "${PREFIX}-${PROTOBUF_VERSION}"
fi

echo Done!

