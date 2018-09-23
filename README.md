# CPP Protocol Buffers for iOS, macOS and WatchOS

Adapted from [https://github.com/sheldonth/arm64-protocolbuffers-cpp]() which was adapted from [https://gist.github.com/BennettSmith/9487468ae3375d0db0cc
]()

Build the runtime Google Protobuf Buffers v3.6.1 C++ libraries (libprotoc.a, libprotobuf.a, libprotobuf-lite.a) for:

* macOS (x86_64)
* iOS Device (arm64) 
* iOS Simulator (x86_64)
* WatchOS device (armv7k)
* WatchOS device (arm64_32)
* WatchOS simulator (i386)
* Universal (Fat mach-o for all of the above)

Just clone this repo and run `./build-protofbuf.sh`

<!--`universal$ otool -vf ./libprotobuf.a

Fat headers
fat_magic FAT_MAGIC
nfat_arch 5

architecture i386
    cputype CPU_TYPE_I386
    cpusubtype CPU_SUBTYPE_I386_ALL
    capabilities 0x0
    offset 108
    size 3649264
    align 2^2 (4)
    
architecture arm64_32
    cputype CPU_TYPE_ARM64_32
    cpusubtype CPU_SUBTYPE_ARM64_V8
    capabilities 0x0
    offset 3649372
    size 10286304
    align 2^2 (4)
    
architecture armv7k
    cputype CPU_TYPE_ARM
    cpusubtype CPU_SUBTYPE_ARM_V7K
    capabilities 0x0
    offset 13935676
    size 9941128
    align 2^2 (4)
    
architecture x86_64
    cputype CPU_TYPE_X86_64
    cpusubtype CPU_SUBTYPE_X86_64_ALL
    capabilities 0x0
    offset 23876808
    size 4018064
    align 2^3 (8)
    
architecture arm64
    cputype CPU_TYPE_ARM64
    cpusubtype CPU_SUBTYPE_ARM64_ALL
    capabilities 0x0
    offset 27894872
    size 10477928
    align 2^3 (8)
    
Archive : ./libprotobuf.a`-->


