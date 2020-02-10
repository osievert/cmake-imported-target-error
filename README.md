# CMake imported target problems

CMake has the concept of an "imported" target that is useful for adding
a prebuilt library into a CMake dependency graph in the same way that
a typical "source" target defined with `add_library()` works. The goal
is to be able to define an imported target such that an application that
integrates a prebuilt library need only add that target as a dependency
and then include paths, library paths, and link libraries will be automatically
handled.

Reference: https://cmake.org/cmake/help/v3.16/manual/cmake-buildsystem.7.html#include-directories-and-usage-requirements

Sounds great. It doesn't work, though. This is the simplest possible example
that shows one of the problems (and a strange problem it is): include
directories are automatically included in app compilation only if the imported
target is defined in the top-level CMakeLists.txt file.

**UPDATE: latest commit works. Issue was not with the `INTERFACE_INCLUDE_DIRECTORIES`
but with the scope of imported targets. Imported targets are scoped to the
list/directory by default. Adding `GLOBAL` to the add_library() call for the
imported library allowed the second example to work. Remaining question,
however, is "why are imported targets so different from standard targets
in this way?"**

## What this example does

There are two CMake project trees included in this repo:
- `import_in_root` is an example of an imported target that is defined
  in the root-level CMakeLists.txt file.
- `import_from_subdir` is an example of an imported target that is defined
  in it's own CMakeLists.txt file that is then included in the root-level
  CMakeLists.txt file using CMake's `add_subdirectory()` function. This represents
  a common way of working with external prebuilt libraries - they are
  managed independendly and included into top-level projects as needed.

The first example works. The second example does not work. The include path
of the imported target, defined identically in both examples, is added to the
application compilation commands in the first example but is NOT added to
the application compilation commands in the second example. This means that
imported targets only work if they are defined in the root-level CMakeLists.txt
file. That severly limits the usefulness of imported targets.

## How this example works

Each of the two subdirectories are independent CMake project trees. In each
subdirectory, a `Makefile` helps to illustrate the workflow required to
see the success of defining an imported target in a root-level CMakeLists.txt
file versus the failure of defining an imported target in its own CMakeLists.txt
file.

Workflow:
1. Clone this repo on MacOS or Linux. This example is not set-up to work on
   Windows (because it uses make to build the "prebuilt" library).
2. Type `make`. This will build a command line application in each of the
   two subdirectories. One of thse builds will succeed, one will fail.

A more fine-grained way to work with these projects:
1. Change directory to one of the subdirectories.
2. Type `make lib` to build the "prebuilt" library we want to import (sources
   for this library are included in this repo; to simulate a "prebuilt" library
   we build this library using make directly, then reference this prebuilt
   library in CMake in step 3).
3. Once the prebuilt library exists, you can run CMake to build a simple
   command line application that references this prebuilt library as an
   imported target by typing `make app`. This will succeed in the first
   subdirectory but will fail in the second.

Whether in the root directory of this repo or in one
of the independent project subdirectories, you can type
`make clean` to clean the project(s).

## Details

System configuration on which the failure happens:
- MacOS 10.14.6
- Xcode 11.3
- CMake 3.14.5 (installed via HomeBrew)

The failure in the second subdirectory:
```bash
[ 50%] Building CXX object CMakeFiles/foo.dir/main.cpp.o
/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++    -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk -mmacosx-version-min=10.14   -o CMakeFiles/foo.dir/main.cpp.o -c $HOME/projects/cmake/imported/import_from_subdir/main.cpp
$HOME/projects/cmake/imported/import_from_subdir/main.cpp:3:10: fatal error: 'hello.h' file not found
#include "hello.h"
         ^~~~~~~~~
1 error generated.
make[3]: *** [CMakeFiles/foo.dir/main.cpp.o] Error 1
make[2]: *** [CMakeFiles/foo.dir/all] Error 2
make[1]: *** [all] Error 2
make: *** [app] Error 2
```

In the first subdirectory, the imported target include path is included in the compile command (`-isystem` argument):
```bash
[ 50%] Building CXX object CMakeFiles/foo.dir/main.cpp.o
/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++   -isystem $HOME/projects/cmake/imported/import_in_root/include  -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk -mmacosx-version-min=10.14   -o CMakeFiles/foo.dir/main.cpp.o -c $HOME/projects/cmake/imported/import_in_root/main.cpp
```

In both cases, the imported CMake target is defined like this:
```cmake
add_library(hello STATIC IMPORTED)
set_target_properties(hello PROPERTIES IMPORTED_LOCATION "${CMAKE_CURRENT_SOURCE_DIR}/libhello.a")
set_target_properties(hello PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}/include")
```


