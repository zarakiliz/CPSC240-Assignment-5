#include <cstdio>

extern "C" double triangle();

int main()
{
    printf("Welcome to Amazing triangles programmed by Elizabeth Orellana on April 5, 2022\n\n");
    double ret = triangle();
    printf("\n\nThe driver recieved this number: %lf and will simply keep it.\n", ret);
    printf("\nAn integer zero will now be sent to the OS. Have a nice day!\n");
    return 0;
}