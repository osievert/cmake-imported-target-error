.PHONY: all
all:
	cd import_in_root && make
	cd import_from_subdir && make

clean:
	cd import_in_root && make clean
	cd import_from_subdir && make clean

