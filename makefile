GCC=gcc-7
GCCFLAGS= -Wall -pedantic 

all: clean compiler examples


compiler: 
		yacc -d sintaxis.y 
		flex lex.l
		$(GCC) -o compiler lex.yy.c y.tab.c node.c node.h -ly $(GCCFLAGS)

clean: 
	rm -rf *.o y.tab.c y.tab.h compiler lex.yy.c test* *.out

examples: example1 example2 example3 example4 example5

example1:
	./compiler <ejemplo1.ppp> test1.c
	gcc test1.c -o test1

example2:
	./compiler <ejemplo2.ppp> test2.c
	gcc test2.c -o test2

example3:
	./compiler <ejemplo3.ppp> test3.c
	gcc test3.c -o test3

example4:
	./compiler <ejemplo4.ppp> test4.c
	gcc test4.c -o test4

example5:
	./compiler <ejemplo5.ppp> test5.c
	gcc test5.c -o test5



.PHONY: all test1 test2 test3 clean compiler