//ver link de donde lo sacamos
#include <stdio.h>
#include <stdlib.h>
#include "node.h"

Node* newNode(string t, char* string)
{
	Node* node = malloc(sizeof(Node));
	node->token = t;
	node->string = string;
	node->index=0;
	node->child = malloc(10*sizeof(*node->child));
	return node;
}

void
add_node(Node * p, Node * c){
	p->children[p->index++] = c;
}

Node *
new_tree(){
	return new_node(root_, NULL);
}

void
add_terminal_node(Node * p, string t){
	if(p == NULL)
		return;

	p->child[p->index++] = new_node(t, NULL);
}

void
set_string(Node * n, char * new_string){
	n->sting = new_string;
}

char *
get_string(Node * n){
	return n->string;
}

void
add_terminal_node_with_value(Node * p, string t, char * string) {

	if(p == NULL)
		return;

	p->child[p->index++] = new_node(t, string);

}
