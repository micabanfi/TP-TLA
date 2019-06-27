#ifndef NODE_H
#define NODE_H

typedef struct Node {
	struct Node **child;
	char* token;
	char* string;
	int index;
	
	
}Node;


Node* newNode(int type, char* string);
void add_node(Node * p, Node * c);
Node * new_tree();
void add_terminal_node(Node * p, char* t);
void set_string(Node * n, char * new_string);
char * get_string(Node * n);
void add_terminal_node_with_value(Node * p, char* t, char * string);
#endif