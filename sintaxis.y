%{
#include <stdio.h>
#include <string.h>
#include <node.h>

extern void yyerror();
extern int yylex();
extern char* yytext;
extern int yylineno;
%}

%define parse.lac full
%define parse.error verbose

%union{
	Node *node;
}

%token<node> INT_T
%token<node> STRING_T

%token EQUALS
%token EQUALSCMP
%token DIFFCMP
%token GT
%token LT
%token GET
%token LET
%token AND
%token OR
%token PLUS
%token MINUS
%token MULT
%token DIV
%token MOD
%token PRINT
%token L_PAR R_PAR
%token<node> IF
%token<node> ELSE
%token<node> DO
%token<node> WHILE
%token<node> END_LINE

%right EQUALS
%left EQUALS NTEQUAL
%left PLUS MINUS MUL DIV MOD
%left OR AND NOT 
%left GT GET LT LET 

%start PROGRAM





