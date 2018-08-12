using BinaryBuilder

sources = ["./src"]

# These are the platforms built inside the wizard
platforms = [
    BinaryProvider.Linux(:i686, :glibc),
    BinaryProvider.Linux(:x86_64, :glibc),
    #BinaryProvider.Linux(:aarch64, :glibc),
    #BinaryProvider.Linux(:armv7l, :glibc),
    #BinaryProvider.Linux(:powerpc64le, :glibc),
    BinaryProvider.MacOS(),
    BinaryProvider.Windows(:i686),
    BinaryProvider.Windows(:x86_64)
]


script = raw"""
cd $WORKSPACE/srcdir/ddierckx

flags="-O3 -shared -fPIC"
libdir="lib"

# set suffix
if [[ ${target} == *-mingw32 ]]; then
    suffix="dll"
    flags="${flags} -static-libgfortran -static-libgcc"
    libdir="bin"
elif [[ ${target} == *apple* ]]; then
    suffix="dylib"
else
    suffix="so"
fi

mkdir -p $WORKSPACE/destdir/${libdir}
gfortran -o $WORKSPACE/destdir/${libdir}/libddierckx.${suffix} ${flags} *.f
"""

dependencies = []
products(prefix) = [LibraryProduct(prefix, "libddierckx", :libddierckx)]

build_tarballs(ARGS, "libddierckx", v"1.0.0", sources, script, platforms,
               products, dependencies)
