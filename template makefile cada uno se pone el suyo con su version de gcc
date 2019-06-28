GCC=gcc
GCCFLAGS= -Wall -pedantic 

all: clean compiler 


compiler: 
		yacc -d sintaxis.y 
		flex lex.l
		$(GCC) -o compiler lex.yy.c y.tab.c node.c node.h -ly $(GCCFLAGS)

clean: 
	rm -rf *.o y.tab.c y.tab.h compiler lex.yy.c test1.c test1

test1: 
	./compiler < ejemplo1 > test1.c
	gcc test1.c -o test1


.PHONY: all test1 clean compiler