#include <stdio.h>

#include "hello.h"

int main(int argc, char *argv[])
{
    printf("%s\n", hello().c_str());
    return 0;
}

