#include <stdio.h>
#include <stdlib.h>
#include "node.h"

Node* newNode(char* t, char* string)
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
	p->child[p->index++] = c;
}

Node *
new_tree(){
	return newNode("", NULL);
}

void
add_terminal_node(Node * p, char* t){
	if(p == NULL)
		return;

	p->child[p->index++] = newNode(t, NULL);
}

void
set_string(Node * n, char * new_string){
	n->string = new_string;
}

char *
get_string(Node * n){
	return n->string;
}

void
add_terminal_node_with_value(Node * p, char* t, char * string) {

	if(p == NULL)
		return;

	p->child[p->index++] = newNode(t, string);

}
