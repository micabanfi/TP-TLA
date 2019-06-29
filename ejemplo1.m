inicio
	numero acum es 0
	numero iteracion es 1
	si 1 es distinto a 1
		imprimir "no se va a cumplir"
	o si ((1 es mayor a 2 o 2 es mayor a 3) y 5 es igual a 6)
		imprimir "no se va a cumplir"
	y si no
		repetir desde 100 hasta 200 de a 10
			imprimir "----------------"
			imprimir "iteracion numero"
			imprimir iteracion
			iteracion es iteracion + 1
			imprimir "----------------"
			hacer
				imprimir acum
				acum es acum + 1
			mientras acum es menor a 3
			acum es 0
		fin repetir
	fin si
	si iteracion es mayor a 1
		imprimir "Lo logramos!"
	y si no
		imprimir "Lo lamento mucho."
	fin si
fin