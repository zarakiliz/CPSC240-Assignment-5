#!/bin/bash

#Program: Length Side 
#Author: Elizabeth Orellana

#Purpose: script file to run the program files together.
#Clear any previously compiled outputs
rm *.o
rm *.o
rm *.lis

echo "Assemble triangle.asm"
nasm -f elf64 -l triangle.lis -o triangle.o triangle.asm -g -gdwarf

echo "compile geometry.cpp using the g++ compiler standard 2017"
g++ -c -Wall -no-pie -m64 -std=c++17 -o geometry.o geometry.cpp -g

echo "Link object files using the gcc Linker standard 2017"
g++ -m64 -no-pie -o final.out triangle.o geometry.o -std=c++17 -g

echo "Run the Triangle Program:"
gdb ./final.out 



echo "Script file has terminated."

#Clean up after program is run
rm *.o
rm *.out
rm *.lis