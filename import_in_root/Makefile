all: app

.PHONY: lib
lib: libhello.a

libhello.a: lib/hello.cpp
	g++ -Iinclude -o hello.o -c lib/hello.cpp
	ar rvs libhello.a hello.o

app: libhello.a main.cpp
	mkdir -p build && cd build && cmake .. && make VERBOSE=1

clean:
	rm -rf hello.o libhello.a build
