%{
#include <stdio.h>
#include <string.h>
#include "node.h"

extern void yyerror();
extern int yylex();
extern char* yytext;
extern int yylineno;
static Node * root;


%}

// %define parse.lac full
// %define parse.error verbose

%union{
	struct Node * node;

}



%token EQUALS
%token NOT
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
%token<node> END_LINE FALSE TRUE 
%token<node> INT_T
%token<node> STRING_T
%token<string> STRING
%token<integer> INT
%token<node> ID
%type<node> statement expression comparator operand operator 
%type<node> arguments definition assignment print
%type<node> program

%right EQUALS GT GET LT LET 
%left  EQUALSCMP NTEQUAL
%left PLUS MINUS MUL DIV MOD
%left OR AND NOT 
 

%start program

%%
program 		: statement
			{
				root = $1;
			}
			;

statement 		: statement statement
				{
					$$ = new_tree();
					add_node($$, $1);
					add_node($$, $2);
				}
			;

statement		:END_LINE
			{
				$$ = new_tree();
				add_terminal_node($$, "\n");
			}

			| IF expression statement
				{
					$$ = new_tree();
					add_terminal_node($$, "if");
					add_node($$, $2);
					add_node($$, $3);
				}
			|IF expression statement ELSE statement
				{
					$$ = new_tree();
					add_terminal_node($$, "if");
					add_node($$, $2);
					add_node($$, $3);
					add_terminal_node($$, "else");
					add_node($$, $5);


				}
			| WHILE expression statement
				{
					$$ = new_tree();
					add_terminal_node($$, "while");
					add_node($$, $2);
					add_node($$, $3);
				}
			|DO statement WHILE expression
				{
					$$ = new_tree();
					add_terminal_node($$, "do");
					add_node($$, $2);
					add_terminal_node($$, "while");
					add_node($$, $4);
				}
			|definition END_LINE
				{
					$$ = new_tree();
					add_node($$, $1);
					add_terminal_node($$, "\n");
				}
			|assignment END_LINE
				{
					$$ = new_tree();
					add_node($$, $1);
					add_terminal_node($$, "\n");
				}
			| print END_LINE
				{
					$$ = new_tree();
					add_node($$, $1);
					add_terminal_node($$, "\n");
				}
			;
expression		:operand comparator operand			
				{
					$$ = new_tree();
					//$$->token = $2.token;
					add_node($$, $1);
					add_node($$, $2);
					add_node($$, $3);
				}
			|NOT expression
				{
					$$ = new_tree();
					add_terminal_node($$, "!");
					add_node($$, $2);
				}
			|expression AND expression
				{
					$$ = new_tree();
					add_node($$, $1);
					add_terminal_node($$, "&&");
					add_node($$, $3);
				}
			|expression OR expression
				{
					$$ = new_tree();
					add_node($$, $1);
					add_terminal_node($$, "||");
					add_node($$, $3);
				}
			|TRUE
				{
					$$ = new_tree();
					add_terminal_node($$, "TRUE");
				}
			|FALSE
				{
					$$ = new_tree();
					add_terminal_node($$, "FALSE");
				}
			;
comparator	:EQUALSCMP
				{
					$$ = new_tree();
					add_terminal_node($$, "==");
					$$->token = "=";
				}
			|NTEQUAL
				{
					$$ = new_tree();
					add_terminal_node($$, "!=");
					$$->token =  "!=";
				}
			|GT
				{
					$$ = new_tree();
					add_terminal_node($$, ">");
				}
			|LT
				{
					$$ = new_tree();
					add_terminal_node($$, "<");
				}
			|GET
				{
					$$ = new_tree();
					add_terminal_node($$, ">=");
				}
			|LET
				{
					$$ = new_tree();
					add_terminal_node($$, "<=");
				}

	

operand				
			:operand operator operand
				{
					$$ = new_tree();
					add_node($$, $1);
					add_node($$, $2);
					add_node($$, $3);
					$$->token = $2->token;
				}
			|ID
				{
				$$ = new_tree();
					add_terminal_node_with_value($$, "ID", $1);
				}
			;
operator		:AND
				{
					$$ = new_tree();
					add_terminal_node($$, "&&");
				}
			|OR	
				{
					$$ = new_tree();
					add_terminal_node($$, "||");
				}
			|PLUS
				{
					$$ = new_tree();
					add_terminal_node($$, "+");
				}
			|MINUS
				{
					$$ = new_tree();
					add_terminal_node($$, "-");
				}
			|MULT
				{
					$$ = new_tree();
					add_terminal_node($$, "*");
				}
			|DIV
				{
					$$ = new_tree();
					add_terminal_node($$, "/");
				}		
			|MOD
				{
					$$ = new_tree();
					add_terminal_node($$, "%");
				}

arguments		:expression
				{
					$$ = new_tree();
					add_node($$, $1);
				}
			|operand
				{
					$$ = new_tree();
					add_node($$, $1);
				}
			;
definition 		: INT_T assignment
				{
					$$ = new_tree();
					add_terminal_node($$, "Integer");
					add_node($$, $2);
				}
			| STRING_T assignment
				{
					$$ = new_tree();
					add_terminal_node($$, "String");
					add_node($$, $2);
				}
			;			
assignment		:ID EQUALS operator
				{
					$$ = new_tree();
					add_terminal_node_with_value($$, "ID", $1);
					add_terminal_node($$, "=");
					add_node($$, $3);
				}

print 		: PRINT arguments
				{
					$$ = new_tree();
					add_terminal_node($$, "printf");
					add_node($$, $2);
					$$->token = "printf";
				}
			;			
%%

int main(){

  yyparse();
  printf("No Errors!!\n");
  return 0;
}			