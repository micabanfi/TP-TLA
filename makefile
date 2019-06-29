GCC=gcc-7
GCCFLAGS= -Wall -pedantic -g

all: clean compiler 


compiler: 
		yacc -d sintaxis.y -t -v
		flex lex.l
		$(GCC) -o compiler lex.yy.c y.tab.c node.c node.h -ly $(GCCFLAGS)

clean: 
	rm -rf *.o y.tab.c y.tab.h compiler lex.yy.c ejemplo1.c

test1: 
	./compiler < ejemplo1.m > ejemplo1.c
	gcc ejemplo1.c -o ejemplo1


.PHONY: all test1 clean compiler