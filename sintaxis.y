%{
#include <stdio.h>
#include <string.h>
#include <node.h>

extern void yyerror();
extern int yylex();
extern char* yytext;
extern int yylineno;
%}

// %define parse.lac full
// %define parse.error verbose

%union{
	Node *node;
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
%type<node> statement expression comparator operand operator 
%type<node> arguments definition assignment print

%right EQUALS GT GET LT LET 
%left  EQUALSCMP NTEQUAL
%left PLUS MINUS MUL DIV MOD
%left OR AND NOT 
 

%start PROGRAM

%%
program 		: statement
			{
				root = $1;
				print_program(root);
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
				add_terminal_node($$, endline_);
			}

			| IF expression statement
				{
					$$ = new_tree();
					add_terminal_node($$, if_);
					add_node($$, $2);
					add_node($$, $3);
				}
			|IF expression statement ELSE statement
				{
					$$ = new_tree();
					add_terminal_node($$, if_);
					add_node($$, $2);
					add_node($$, $3);
					add_terminal_node($$, else_);
					add_node($$, $5);


				}
			| WHILE expression statement
				{
					$$ = new_tree();
					add_terminal_node($$, while_);
					add_node($$, $2);
					add_node($$, $3);
				}
			|DO statement WHILE expression
				{
					$$ = new_tree();
					add_terminal_node($$, do_);
					add_node($$, $2);
					add_terminal_node($$, while_);
					add_node($$, $4);
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
expression		:operand comparator operand			
				{
					$$ = new_tree();
					$$->token = $2->token;
					add_node($$, $1);
					add_node($$, $2);
					add_node($$, $3);
				}
			|NOT expression
				{
					$$ = new_tree();
					add_terminal_node($$, not_);
					add_node($$, $2);
				}
			|expression AND expression
				{
					$$ = new_tree();
					add_node($$, $1);
					add_terminal_node($$, and_);
					add_node($$, $3);
				}
			|expression OR expression
				{
					$$ = new_tree();
					add_node($$, $1);
					add_terminal_node($$, or_);
					add_node($$, $3);
				}
			|TRUE
				{
					$$ = new_tree();
					add_terminal_node($$, true_);
				}
			|FALSE
				{
					$$ = new_tree();
					add_terminal_node($$, false_);
				}
			;
comparator	:EQUALSCMP
				{
					$$ = new_tree();
					add_terminal_node($$, equalscmp_);
					$$->token = equalscmp_;
				}
			|NTEQUAL
				{
					$$ = new_tree();
					add_terminal_node($$, ntequal_);
					$$->token =  ntequal_;
				}
			|GT
				{
					$$ = new_tree();
					add_terminal_node($$, gt_);
				}
			|LT
				{
					$$ = new_tree();
					add_terminal_node($$, lt_);
				}
			|GET
				{
					$$ = new_tree();
					add_terminal_node($$, get_);
				}
			|LET
				{
					$$ = new_tree();
					add_terminal_node($$, let_);
				}

	

operand		:INT
				{
					$$ = new_tree();
					// char * aux = malloc(33);
					// sprintf(aux, "%d", $1);
					add_terminal_node_with_value($$, int_, aux);
				}	
			|STRING
				{
					$$ = new_tree();
					add_terminal_node_with_value($$, string_, $1);
				}	
			|operand operator operand
				{
					$$ = new_tree();
					add_node($$, $1);
					add_node($$, $2);
					add_node($$, $3);
					$$->token = $2->token;
				}
			;
operator		:AND
				{
					$$ = new_tree();
					add_terminal_node($$, and_);
				}
			|OR	
				{
					$$ = new_tree();
					add_terminal_node($$, or_);
				}
			|PLUS
				{
					$$ = new_tree();
					add_terminal_node($$, plus_);
				}
			|MINUS
				{
					$$ = new_tree();
					add_terminal_node($$, minus_);
				}
			|MULT
				{
					$$ = new_tree();
					add_terminal_node($$, mult_);
				}
			|DIV
				{
					$$ = new_tree();
					add_terminal_node($$, div_);
				}		
			|MOD
				{
					$$ = new_tree();
					add_terminal_node($$, mod_);
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
					add_terminal_node($$, int_t_);
					add_node($$, $2);
				}
			| STRING_T assignment
				{
					$$ = new_tree();
					add_terminal_node($$, string_t_);
					add_node($$, $2);
				}
			;			
assignment		:ID EQUALS operator
				{
					$$ = new_tree();
					add_terminal_node_with_value($$, id_, $1);
					add_terminal_node($$, equals_);
					add_node($$, $3);
				}

print 		: PRINT arguments
				{
					$$ = new_tree();
					add_terminal_node($$, print_);
					add_node($$, $2);
					$$->token = print_;
				}
			;			
%%

int main(){

  yyparse();
  printf("No Errors!!\n");
  return 0;
}			