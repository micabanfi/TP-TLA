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

%%
program 	: statement
			{
				root = $1;
				print_program(root);
			}
		;

statement 	: statement statement
				{
					$$ = new_tree();
					add_node($$, $1);
					add_node($$, $2);
				}
			;

statement	:END_LINE
			{
				$$ = new_tree();
				add_terminal_node($$, endline_);
			}

			| IF expression statement
				{
					$$ = new_tree();
					add_terminal_node($$, if_);
					add_node($$, $3);
					add_node($$, $4);
				}
			|IF expression statement ELSE statement
				{
					$$ = new_tree();
					add_terminal_node($$, if_);
					add_node($$, $3);
					add_node($$, $4);
					add_terminal_node($$, else_);
					add_node($$, $6);


				}
			| WHILE expression statement
				{
					$$ = new_tree();
					add_terminal_node($$, while_);
					add_node($$, $3);
					add_node($$, $4);
				}
			|DO statement WHILE expression
				{
					$$ = new_tree();
					add_terminal_node($$, do_);
					add_node($$, $3);
					add_terminal_node($$, while_);
					add_node($$, $5);
				}
			|definition END_LINE
				{
					$$ = new_tree();
					add_node($$, $1);
					add_terminal_node($$, endline_);
				}
			|assignment END_LINE
				{
					$$ = new_tree();
					add_node($$, $1);
					add_terminal_node($$, endline_);
				}
			| print END_LINE
				{
					$$ = new_tree();
					add_node($$, $1);
					add_terminal_node($$, endline_);
				}
			;
			
