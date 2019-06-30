# Programación Para Pequeños
## Introducción
Cada día mas niños comienzan a estudiar programación desde mas jóvenes,y  a  esta  creciente  demanda  surgen  día  a  día  nuevas  herramientas  paraaprender a programar desde chicos, pero generalmente estas herramientasestán en inglés entonces quedan fuera del alcance de los niños que solamentehablan español. Decidimos colaborar con la causa y desarrollar un lenguaje,en español, lo mas simple y coloquial posible, que permita hacer las cosasbásicas de programación imperativa para dar los primeros pasos en la materia.

## Archivos destacados
- **makefile** : Archivo para generar los archivos ejecutables.
- **lex.l** : Definicion de la gramatica y palabras reservadas del lenguaje.
- **sintaxis.y** : Definicion de reglas y funciones auxiliares.

## Estructura
![alt text](https://github.com/micabanfi/TP-TLA/blob/master/diagram?raw=true)

## Instalación
1. Clonar repositorio
	>git clone https://github.com/micabanfi/TP-TLA.git
2. Situarse en la carpeta
	> cd TP-TLA
4. Ejecutar makefile
	> make compiler
## Ejecución caso personalizado
4. Escribir un codigo
	>nano code.ppp
5. Compilarlo
	>./compiler <code.ppp> code.c
	gcc code.c -o code.o
6. Ejecutarlo
	> ./code.o

## Ejecución caso de prueba
4. Compilar caso de prueba elegido
	>make example1
5. Ejecutarlo
	>./test1

**Se puede compilar todo junto con**
> make all

**Se puede compilar todos los ejemplos con**
> make examples

## Colaboradores
- Micaela Banfi - mbanfi@itba.edu.ar
- Juan Grethe - jgrethe@itba.edu.ar
- Martin Grabina mgrabina@itba.edu.ar
