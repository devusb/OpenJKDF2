include(cmake_modules/target_linux_all.cmake)

# Linux 64-bit with OpenGL ES 3 instead of desktop GL.
# Used on weak mobile-GPU targets where desktop GL only exists via Zink
# (which is heavy on translation) and where the native driver is GLES.
# Mirrors the Android codepath's renderer choice on a Linux host.

macro(plat_initialize)
    message( STATUS "Targeting Linux 64-bit (GLES)" )
    set(BIN_NAME "openjkdf2-gles")

    add_definitions(-DARCH_64BIT)
    add_definitions(-D_XOPEN_SOURCE=500)
    add_definitions(-D_DEFAULT_SOURCE)
    add_definitions(-DTARGET_LINUX_64_GLES)

    include(cmake_modules/plat_feat_full_sdl2.cmake)

    set(TARGET_LINUX TRUE)
    set(TARGET_LINUX_64_GLES TRUE)

    # Use distro/nix-managed libs instead of the lib/ submodules' ExternalProjects.
    # The ExternalProject path bakes architecture-specific install dirs (lib vs
    # lib64) that fight nixpkgs and any modern Linux distro.
    set(TARGET_USE_SYSTEM_LIBS TRUE)

    # Steam multiplayer drags protobuf + GNS ExternalProjects into the build;
    # turn it off here — irrelevant for the GLES handheld target.
    set(TARGET_USE_GAMENETWORKINGSOCKETS FALSE)

    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -std=c11 -fshort-wchar -Werror=implicit-function-declaration -Wno-unused-variable -Wno-parentheses -Wno-incompatible-pointer-types")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -fshort-wchar -Werror=implicit-function-declaration -Wno-unused-variable -Wno-parentheses ")
    add_link_options(-fshort-wchar)
endmacro()

macro(plat_specific_deps)
    plat_sdl2_deps()
endmacro()
