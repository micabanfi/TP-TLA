#ifndef NODE_H
#define NODE_H


typedef struct Node {
	struct Node **child;
	token t;
	char* string;
	int index;
	
	
}Node;


Node* newNode(int type, char* string);

#endif