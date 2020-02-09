all: app

.PHONY: lib
lib: lib/libhello.a

lib/libhello.a: lib/hello.cpp
	g++ -Ilib/include -o hello.o -c lib/hello.cpp
	ar rvs lib/libhello.a hello.o

app: lib/libhello.a main.cpp
	mkdir -p build && cd build && cmake .. && make VERBOSE=1

clean:
	rm -rf hello.o lib/libhello.a build
