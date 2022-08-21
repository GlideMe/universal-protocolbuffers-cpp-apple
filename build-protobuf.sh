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
BUILD_MACOSX_ARM64=YES

BUILD_I386_IOSSIM=NO
BUILD_X86_64_IOSSIM=YES
BUILD_ARM64_IOSSIM=YES

BUILD_IOS_ARMV7=NO
BUILD_IOS_ARMV7S=NO
BUILD_IOS_ARM64=YES

BUILD_WATCHOS_ARMV7K=YES
BUILD_WATCHOS_ARM64_32=YES
BUILD_WATCHOS_ARM64=YES

BUILD_I386_WATCHOSSIM=NO
BUILD_X86_64_WATCHOSSIM=YES
BUILD_ARM64_WATCHOSSIM=YES

PROTOBUF_SRC_DIR=./temp

DARWIN=darwin`uname -r`

XCODEDIR=`xcode-select --print-path`
IOS_SDK_VERSION=`xcrun --sdk iphoneos --show-sdk-version`
MIN_SDK_VERSION=14.0

MACOSX_PLATFORM=`xcrun --sdk macosx --show-sdk-platform-path`
MACOSX_SYSROOT=`xcrun --sdk macosx --show-sdk-path`
MIN_MACOS_VERSION=10.12

IPHONEOS_PLATFORM=`xcrun --sdk iphoneos --show-sdk-platform-path`
IPHONEOS_SYSROOT=`xcrun --sdk iphoneos --show-sdk-path`

IPHONESIMULATOR_PLATFORM=`xcrun --sdk iphonesimulator --show-sdk-platform-path`
IPHONESIMULATOR_SYSROOT=`xcrun --sdk iphonesimulator --show-sdk-path`

WATCHOS_PLATFORM=`xcrun --sdk watchos --show-sdk-platform-path`
WATCHOS_SYSROOT=`xcrun --sdk watchos --show-sdk-path`
MIN_WATCHOS_VERSION=7.0

WATCHSIMULATOR_PLATFORM=`xcrun --sdk watchsimulator --show-sdk-platform-path`
WATCHSIMULATOR_SYSROOT=`xcrun --sdk watchsimulator --show-sdk-path`


# Uncomment if you want to see more information about each invocation
# of clang as the builds proceed.
#CLANG_VERBOSE="--verbose"
CC=`xcrun -find cc`
CXX=`xcrun -find c++`
SILENCED_WARNINGS="-Wno-unused-local-typedef -Wno-unused-function"
#SILENCED_WARNINGS=""
# NOTE: Google Protobuf does not currently build if you specify 'libstdc++'
# instead of `libc++` here.
STDLIB=libc++

CFLAGS="${CLANG_VERBOSE} ${SILENCED_WARNINGS} -DNDEBUG -g -Os -pipe -fPIC -fcxx-exceptions" 
CFLAGS_OSX="${CLANG_VERBOSE} ${SILENCED_WARNINGS} -DNDEBUG -g -Os -pipe -fPIC -fcxx-exceptions"
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
echo "BUILD_MACOSX_ARM64 ......... ${BUILD_MACOSX_ARM64}"
echo "BUILD_I386_IOSSIM .......... ${BUILD_I386_IOSSIM}"
echo "BUILD_X86_64_IOSSIM ........ ${BUILD_X86_64_IOSSIM}"
echo "BUILD_ARM64_IOSSIM ......... ${BUILD_ARM64_IOSSIM}"
echo "BUILD_IOS_ARMV7 ............ ${BUILD_IOS_ARMV7}"
echo "BUILD_IOS_ARMV7S ........... ${BUILD_IOS_ARMV7S}"
echo "BUILD_IOS_ARM64 ............ ${BUILD_IOS_ARM64}"
echo "BUILD_WATCHOS_ARMV7K ....... ${BUILD_WATCHOS_ARMV7K}"
echo "BUILD_WATCHOS_ARM64_32 ..... ${BUILD_WATCHOS_ARM64_32}"
echo "BUILD_WATCHOS_ARM64 ........ ${BUILD_WATCHOS_ARM64}"
echo "BUILD_I386_WATCHOSSIM ...... ${BUILD_I386_WATCHOSSIM}"
echo "BUILD_X86_64_WATCHOSSIM .... ${BUILD_X86_64_WATCHOSSIM}"
echo "BUILD_ARM64_WATCHOSSIM ..... ${BUILD_ARM64_WATCHOSSIM}"
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
        mkdir "${PREFIX}/platform/x86_64-mac/"        
        ./configure --build=x86_64-apple-${DARWIN} --host=x86_64 --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/x86_64-mac "CC=${CC}" "CFLAGS=${CFLAGS_OSX} -arch x86_64 -isysroot ${MACOSX_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS_OSX} -arch x86_64 -isysroot ${MACOSX_SYSROOT}" LDFLAGS="-arch x86_64 ${LDFLAGS} -L${MACOSX_SYSROOT}/usr/lib/" "LIBS=${LIBS}"
        cp "config.log" "${PREFIX}/platform/x86_64-mac/"
        make -j 16 1> "${PREFIX}/platform/x86_64-mac/make.log" 2> "${PREFIX}/platform/x86_64-mac/make.err"
        #make check
        make install
        unset MACOSX_DEPLOYMENT_TARGET        
    )
fi

echo "$(tput setaf 2)"
echo "###################################################################"
echo "# arm64 for Mac OS X"
echo "###################################################################"
echo "$(tput sgr0)"

if [ "${BUILD_MACOSX_ARM64}" == "YES" ]
then
    (
	    export MACOSX_DEPLOYMENT_TARGET="${MIN_MACOS_VERSION}"
        cd ${PROTOBUF_SRC_DIR}
        make distclean    
        mkdir "${PREFIX}/platform/arm64-mac/"        
        ./configure --build=x86_64-apple-${DARWIN} --host=arm --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/arm64-mac "CC=${CC}" "CFLAGS=${CFLAGS_OSX} -arch arm64 -isysroot ${MACOSX_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS_OSX} -arch arm64 -isysroot ${MACOSX_SYSROOT}" LDFLAGS="-arch arm64 ${LDFLAGS} -L${MACOSX_SYSROOT}/usr/lib/" "LIBS=${LIBS}"
        cp "config.log" "${PREFIX}/platform/arm64-mac/"
        make -j 16 1> "${PREFIX}/platform/arm64-mac/make.log" 2> "${PREFIX}/platform/arm64-mac/make.err"
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
	    export MACOSX_DEPLOYMENT_TARGET="${MIN_MACOS_VERSION}"
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        mkdir "${PREFIX}/platform/sim-ios-i386/"
        ./configure --build=x86_64-apple-${DARWIN} --host=i386-apple-${DARWIN} --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/sim-ios-i386 "CC=${CC}" "CFLAGS=${CFLAGS_OSX} -mios-simulator-version-min=${MIN_SDK_VERSION} -arch i386 -isysroot ${IPHONESIMULATOR_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS_OSX} -mios-simulator-version-min=${MIN_SDK_VERSION} -arch i386 -isysroot ${IPHONESIMULATOR_SYSROOT}" LDFLAGS="-arch i386 -mios-simulator-version-min=${MIN_SDK_VERSION} ${LDFLAGS} -L${IPHONESIMULATOR_SYSROOT}/usr/lib/" "LIBS=${LIBS}"
        cp "config.log" "${PREFIX}/platform/sim-ios-i386/"
        make -j 16
        make install
        unset MACOSX_DEPLOYMENT_TARGET
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
	    export MACOSX_DEPLOYMENT_TARGET="${MIN_MACOS_VERSION}"
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        mkdir "${PREFIX}/platform/sim-ios-x86_64/"
        ./configure --build=x86_64-apple-${DARWIN} --host=x86_64 --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/sim-ios-x86_64 "CC=${CC}" "CFLAGS=${CFLAGS_OSX} -mios-simulator-version-min=${MIN_SDK_VERSION} -arch x86_64 -isysroot ${IPHONESIMULATOR_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS_OSX} -mios-simulator-version-min=${MIN_SDK_VERSION} -arch x86_64 -isysroot ${IPHONESIMULATOR_SYSROOT}" LDFLAGS="-arch x86_64 -mios-simulator-version-min=${MIN_SDK_VERSION} ${LDFLAGS} -L${IPHONESIMULATOR_SYSROOT}/usr/lib/" "LIBS=${LIBS}"
        cp "config.log" "${PREFIX}/platform/sim-ios-x86_64/"        
        make -j 16
        make install
        unset MACOSX_DEPLOYMENT_TARGET
        unset IPHONEOS_DEPLOYMENT_TARGET
    )
fi

echo "$(tput setaf 2)"
echo "#############################"
echo "# arm64 for iPhone Simulator"
echo "#############################"
echo "$(tput sgr0)"

if [ "${BUILD_ARM64_IOSSIM}" == "YES" ]
then
    (
	    export IPHONEOS_DEPLOYMENT_TARGET="${MIN_SDK_VERSION}"
	    export MACOSX_DEPLOYMENT_TARGET="${MIN_MACOS_VERSION}"
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        mkdir "${PREFIX}/platform/sim-ios-arm64/"
        ./configure --build=x86_64-apple-${DARWIN} --host=arm --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/sim-ios-arm64 "CC=${CC}" "CFLAGS=${CFLAGS_OSX} -mios-simulator-version-min=${MIN_SDK_VERSION} -arch arm64 -isysroot ${IPHONESIMULATOR_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS_OSX} -mios-simulator-version-min=${MIN_SDK_VERSION} -arch arm64 -isysroot ${IPHONESIMULATOR_SYSROOT}" LDFLAGS="-arch arm64 -mios-simulator-version-min=${MIN_SDK_VERSION} ${LDFLAGS} -L${IPHONESIMULATOR_SYSROOT}/usr/lib/" "LIBS=${LIBS}"
        cp "config.log" "${PREFIX}/platform/sim-ios-arm64/"        
        make -j 16
        make install
        unset MACOSX_DEPLOYMENT_TARGET
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
        mkdir "${PREFIX}/platform/device-ios-armv7/"
        ./configure --build=x86_64-apple-${DARWIN} --host=armv7-apple-${DARWIN} --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/device-ios-armv7 "CC=${CC}" "CFLAGS=${CFLAGS} -miphoneos-version-min=${MIN_SDK_VERSION} -arch armv7 -isysroot ${IPHONEOS_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS} -arch armv7 -isysroot ${IPHONEOS_SYSROOT}" LDFLAGS="-arch armv7 -miphoneos-version-min=${MIN_SDK_VERSION} ${LDFLAGS}" "LIBS=${LIBS}"
        make -j 16
        make install
        unset IPHONEOS_DEPLOYMENT_TARGET
        cp "config.log" "${PREFIX}/platform/device-ios-armv7/"
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
        mkdir "${PREFIX}/platform/device-ios-armv7s/"
        ./configure --build=x86_64-apple-${DARWIN} --host=armv7s-apple-${DARWIN} --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/device-ios-armv7s "CC=${CC}" "CFLAGS=${CFLAGS} -miphoneos-version-min=${MIN_SDK_VERSION} -arch armv7s -isysroot ${IPHONEOS_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS} -arch armv7s -isysroot ${IPHONEOS_SYSROOT}" LDFLAGS="-arch armv7s -miphoneos-version-min=${MIN_SDK_VERSION} ${LDFLAGS}" "LIBS=${LIBS}"
        make -j 16
        make install
        unset IPHONEOS_DEPLOYMENT_TARGET
        cp "config.log" "${PREFIX}/platform/device-ios-armv7s/"
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
        mkdir "${PREFIX}/platform/device-ios-arm64/"
        ./configure --build=x86_64-apple-${DARWIN} --host=arm --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/device-ios-arm64 "CC=${CC}" "CFLAGS=${CFLAGS} -miphoneos-version-min=${MIN_SDK_VERSION} -arch arm64 -isysroot ${IPHONEOS_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS} -arch arm64 -isysroot ${IPHONEOS_SYSROOT}" LDFLAGS="-arch arm64 -miphoneos-version-min=${MIN_SDK_VERSION} ${LDFLAGS}" "LIBS=${LIBS}"
        cp "config.log" "${PREFIX}/platform/device-ios-arm64/"
        make -j 16
        make install
        unset IPHONEOS_DEPLOYMENT_TARGET        
    )
fi

echo "$(tput setaf 2)"
echo "###################"
echo "# arm7k for WatchOS"
echo "###################"
echo "$(tput sgr0)"

if [ "${BUILD_WATCHOS_ARMV7K}" == "YES" ]
then
    (
	    export WATCHOS_DEPLOYMENT_TARGET="${MIN_WATCHOS_VERSION}"
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        mkdir "${PREFIX}/platform/device-watchos-armv7k/"
        ./configure --build=x86_64-apple-${DARWIN} --host=arm --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/device-watchos-armv7k "CC=${CC}" "CFLAGS=${CFLAGS} -mwatchos-version-min=${MIN_WATCHOS_VERSION} -arch armv7k -isysroot ${WATCHOS_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS} -arch armv7k -isysroot ${WATCHOS_SYSROOT}" LDFLAGS="-arch armv7k -mwatchos-version-min=${MIN_WATCHOS_VERSION} ${LDFLAGS}" "LIBS=${LIBS}"
        cp "config.log" "${PREFIX}/platform/device-watchos-armv7k/"
        make -j 16
        make install
        unset WATCHOS_DEPLOYMENT_TARGET        
    )
fi

echo "$(tput setaf 2)"
echo "######################"
echo "# ARM64_32 for WatchOS"
echo "######################"
echo "$(tput sgr0)"

if [ "${BUILD_WATCHOS_ARM64_32}" == "YES" ]
then
    (
	    export WATCHOS_DEPLOYMENT_TARGET="${MIN_WATCHOS_VERSION}"
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        mkdir "${PREFIX}/platform/device-watchos-armv64_32/"
        ./configure --build=x86_64-apple-${DARWIN} --host=arm --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/device-watchos-armv64_32 "CC=${CC}" "CFLAGS=${CFLAGS} -mwatchos-version-min=${MIN_WATCHOS_VERSION} -arch arm64_32 -isysroot ${WATCHOS_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS} -arch arm64_32 -isysroot ${WATCHOS_SYSROOT}" LDFLAGS="-arch arm64_32 -mwatchos-version-min=${MIN_WATCHOS_VERSION} ${LDFLAGS}" "LIBS=${LIBS}"
        cp "config.log" "${PREFIX}/platform/device-watchos-armv64_32/"
        make -j 16
        make install
        unset WATCHOS_DEPLOYMENT_TARGET        
    )
fi

echo "$(tput setaf 2)"
echo "######################"
echo "# ARM64 for WatchOS"
echo "######################"
echo "$(tput sgr0)"

if [ "${BUILD_WATCHOS_ARM64}" == "YES" ]
then
    (
	    export WATCHOS_DEPLOYMENT_TARGET="${MIN_WATCHOS_VERSION}"
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        mkdir "${PREFIX}/platform/device-watchos-armv64/"
        ./configure --build=x86_64-apple-${DARWIN} --host=arm --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/device-watchos-armv64 "CC=${CC}" "CFLAGS=${CFLAGS} -mwatchos-version-min=${MIN_WATCHOS_VERSION} -arch arm64 -isysroot ${WATCHOS_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS} -arch arm64 -isysroot ${WATCHOS_SYSROOT}" LDFLAGS="-arch arm64 -mwatchos-version-min=${MIN_WATCHOS_VERSION} ${LDFLAGS}" "LIBS=${LIBS}"
        cp "config.log" "${PREFIX}/platform/device-watchos-armv64/"
        make -j 16
        make install
        unset WATCHOS_DEPLOYMENT_TARGET        
    )
fi


echo "$(tput setaf 2)"
echo "##################################"
echo "# x86_64 for Watch Simulator"
echo "##################################"
echo "$(tput sgr0)"

if [ "${BUILD_X86_64_WATCHOSSIM}" == "YES" ]
then
    (
    	export WATCHOS_DEPLOYMENT_TARGET="${MIN_WATCHOS_VERSION}"
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        mkdir "${PREFIX}/platform/sim-watchos-x86_64/"
        ./configure --build=x86_64-apple-${DARWIN} --host=x86_64 --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/sim-watchos-x86_64 "CC=${CC}" "CFLAGS=${CFLAGS} -mwatchos-simulator-version-min=${MIN_WATCHOS_VERSION} -arch x86_64 -isysroot ${WATCHSIMULATOR_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS_OSX} -arch x86_64 -isysroot ${WATCHSIMULATOR_SYSROOT}" LDFLAGS="-arch x86_64 -mwatchos-simulator-version-min=${MIN_WATCHOS_VERSION} ${LDFLAGS} -L${WATCHSIMULATOR_SYSROOT}/usr/lib/" "LIBS=${LIBS}"
        cp "config.log" "${PREFIX}/platform/sim-watchos-x86_64/"
        make -j 16
        make install
        unset WATCHOS_DEPLOYMENT_TARGET
    )
fi

echo "$(tput setaf 2)"
echo "##################################"
echo "# i386 for Watch Simulator"
echo "##################################"
echo "$(tput sgr0)"

if [ "${BUILD_I386_WATCHOSSIM}" == "YES" ]
then
    ( 
	    export WATCHOS_DEPLOYMENT_TARGET="${MIN_WATCHOS_VERSION}"
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        mkdir "${PREFIX}/platform/sim-watchos-i386/"
        ./configure --build=x86_64-apple-${DARWIN} --host=i386-apple-${DARWIN} --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/sim-watchos-i386 "CC=${CC}" "CFLAGS=${CFLAGS} -mwatchos-simulator-version-min=${MIN_WATCHOS_VERSION} -arch i386 -isysroot ${WATCHSIMULATOR_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS_OSX} -arch i386 -isysroot ${WATCHSIMULATOR_SYSROOT}" LDFLAGS="-arch i386 -mwatchos-simulator-version-min=${MIN_WATCHOS_VERSION} ${LDFLAGS} -L${WATCHSIMULATOR_SYSROOT}/usr/lib/" "LIBS=${LIBS}"
        cp "config.log" "${PREFIX}/platform/sim-watchos-i386/"
        make -j 16
        make install
        unset WATCHOS_DEPLOYMENT_TARGET
    )
fi

echo "$(tput setaf 2)"
echo "##################################"
echo "# arm64 for Watch Simulator"
echo "##################################"
echo "$(tput sgr0)"

if [ "${BUILD_ARM64_WATCHOSSIM}" == "YES" ]
then
    ( 
        export WATCHOS_DEPLOYMENT_TARGET="${MIN_WATCHOS_VERSION}"
        cd ${PROTOBUF_SRC_DIR}
        make distclean
        mkdir "${PREFIX}/platform/sim-watchos-arm64/"
        ./configure --build=x86_64-apple-${DARWIN} --host=arm --with-protoc=${PROTOC} --disable-shared --prefix=${PREFIX} --exec-prefix=${PREFIX}/platform/sim-watchos-arm64 "CC=${CC}" "CFLAGS=${CFLAGS} -mwatchos-simulator-version-min=${MIN_WATCHOS_VERSION} -arch arm64 -isysroot ${WATCHSIMULATOR_SYSROOT}" "CXX=${CXX}" "CXXFLAGS=${CXXFLAGS_OSX} -arch arm64 -isysroot ${WATCHSIMULATOR_SYSROOT}" LDFLAGS="-arch arm64 -mwatchos-simulator-version-min=${MIN_WATCHOS_VERSION} ${LDFLAGS} -L${WATCHSIMULATOR_SYSROOT}/usr/lib/" "LIBS=${LIBS}"
        cp "config.log" "${PREFIX}/platform/sim-watchos-arm64/"
        make -j 16
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
mkdir device-watchos
mkdir device-ios
mkdir sim-watchos
mkdir sim-ios
mkdir macos
for i in `ls x86_64-mac/lib/*.a`
do
i=`basename $i`
lipo -create device-watchos*/lib/$i -output device-watchos/$i
lipo -create device-ios*/lib/$i -output device-ios/$i
lipo -create sim-ios*/lib/$i -output sim-ios/$i
lipo -create sim-watchos*/lib/$i -output sim-watchos/$i
lipo -create *mac/lib/$i -output macos/$i
done
)
(
cd ${PREFIX}
mkdir bin
mkdir lib
mkdir -p lib/macos
mkdir lib/device-watchos
mkdir lib/device-ios
mkdir lib/sim-watchos
mkdir lib/sim-ios

cp -r platform/x86_64-mac/bin/protoc bin/protoc_x86-64
cp -r platform/arm64-mac/bin/protoc bin/protoc_arm64
cp -r platform/macos/* lib/macos
cp -r platform/device-watchos/* lib/device-watchos
cp -r platform/sim-watchos/* lib/sim-watchos
cp -r platform/sim-ios/* lib/sim-ios
cp -r platform/device-ios/* lib/device-ios

#rm -rf platform
lipo -info  lib/device-watchos/libprotobuf.a
lipo -info  lib/device-watchos/libprotobuf-lite.a

lipo -info  lib/sim-watchos/libprotobuf.a
lipo -info  lib/sim-watchos/libprotobuf-lite.a

lipo -info  lib/sim-ios/libprotobuf.a
lipo -info  lib/sim-ios/libprotobuf-lite.a

lipo -info  lib/device-ios/libprotobuf.a
lipo -info  lib/device-ios/libprotobuf-lite.a

lipo -info  lib/macos/libprotobuf.a
lipo -info  lib/macos/libprotobuf-lite.a

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

