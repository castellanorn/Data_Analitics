# SPRINT 2

# Nivel 1.
 
# Ejercicio 2
# Utilizando JOIN realizarás las siguientes consultas:

# Listado de los países que están generando ventas.
	# RESPUESTA
SELECT DISTINCT country AS Paises_con_Ventas
FROM transaction AS t
LEFT JOIN company AS c
ON t.company_id = c.id
WHERE declined = 0;

# Desde cuántos países se generan las ventas.
	# RESPUESTA
SELECT COUNT(DISTINCT country) AS Cantidad_Paises_con_Ventas
FROM transaction AS t
LEFT JOIN company AS c
ON t.company_id = c.id
WHERE declined = 0;

# Identifica a la compañía con la mayor media de ventas.
	# RESPUESTA
SELECT company_name, ROUND(AVG(amount), 2) AS avg_ventas
FROM transaction AS t
LEFT JOIN company AS c
ON t.company_id = c.id
WHERE declined = 0
GROUP BY company_name
ORDER BY avg_ventas DESC
LIMIT 1;

# Ejercicio 3
# Utilizando sólo subconsultas (sin utilizar JOIN):

# Muestra todas las transacciones realizadas por empresas de Alemania.

	# Ejercicio con JOIN
SELECT DISTINCT company_name, country, t.id
FROM transaction AS t
LEFT JOIN company AS c
ON t.company_id = c.id
WHERE declined = 0 AND country = "Germany";

	# Subconsulta interna 
SELECT id, company_name, country
FROM company
WHERE country = "Germany"; # 8 empresas Alemanas

	# RESPUESTA
SELECT t.id, g.company_name, country
FROM transaction AS t,
	(SELECT company_name, id, country
	FROM company AS c
	WHERE country = "Germany") g
WHERE declined = 0 AND g.id = t.company_id ;
	
# Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.

	# Subconsuta interna AVG amount para comparar com resto de amount
SELECT ROUND(AVG(amount), 2)
FROM transaction AS t; 						# calculo AVG amount = 259

# Ejercicio con JOIN y subconsulta
SELECT DISTINCT company_name
FROM transaction AS t
INNER JOIN company AS c
ON t.company_id = c.id						# JOIN para traer nombre de empresas
WHERE declined = 0
AND amount > (SELECT ROUND(AVG(amount), 2)
				FROM transaction AS t); 	# subconsulta para calcular amount superior al AVG

# Ejercicio sin JOIN, solo subconsultas
	
    # Subconsulta obtener company_id 
SELECT DISTINCT company_id
FROM transaction AS t
WHERE declined = 0
AND amount > (SELECT ROUND(AVG(amount), 2) AS avg_amount
			FROM transaction AS t); 

	# RESPUESTA FINAL
SELECT DISTINCT company_name AS empresas_ventas_mayor_al_promedio
FROM company AS c
WHERE id IN (SELECT DISTINCT company_id					# filtro de codigo empresas
			FROM transaction AS t
			WHERE declined = 0
			AND amount > (SELECT ROUND(AVG(amount), 2)	# filtro de ventas al AVG
						FROM transaction AS t)); 

# Eliminarán del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas.

# Ejercicio con JOIN
SELECT DISTINCT company_name
FROM company AS c
INNER JOIN transaction AS t 
ON c.id = t.company_id
WHERE declined NOT IN (declined = 1);

# Ejercicio sin JOIN, solo subconsultas

	# total de empresas
SELECT COUNT(*)
FROM company;					# 100 empresas

	# verificacion de empresas con transacciones declinadas (declined = 1)
SELECT DISTINCT company_id
FROM transaction AS t
WHERE declined = 1; 			 # 86 empresas

	# verificacion de empresas con transacciones sin declinar (declined = 0)
SELECT DISTINCT company_id
FROM transaction AS t
WHERE declined = 0; 			 # 100 empresas

	# RESPUESTA FINAL 
SELECT company_name AS empresas_sin_ventas
FROM company AS c
WHERE id NOT IN  (SELECT company_id			# subconsulta donde descarto (NOT IN)
				FROM transaction AS t		# empresas con transacciones realizadas
				WHERE declined = 0);		# declined = 0
                
# Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2
# Ejercicio 1

# Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. 
# Muestra la fecha de cada transacción junto con el total de las ventas.
	# RESPUESTA
SELECT DATE(timestamp) AS fecha, SUM(amount) AS max_ventas_del_dia
FROM transaction AS t
LEFT JOIN company AS c
ON c.id = t.company_id
GROUP BY fecha
ORDER BY SUM(amount) DESC
LIMIT 5;	

# Ejercicio 2
# ¿Cuál es la media de ventas por país? Presenta los resultados ordenados de mayor a menor medio.
	# RESPUESTA
SELECT AVG(amount) AS avg_ventas, country
FROM transaction AS t
INNER JOIN company AS c
ON c.id = t.company_id
GROUP BY country
ORDER BY avg_ventas DESC;

# Ejercicio 3
# En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacer competencia a la 
# compañía “Non Institute”. Para ello, te piden la lista de todas las transacciones realizadas por empresas que están 
# ubicadas en el mismo país que esta compañía.

	# Subconsulta interna
# Donde esta la empresa “Non Institute” ???
SELECT country #, company_name
FROM company
WHERE company_name = 'Non Institute';  # Reino Unido

# Muestra el listado aplicando JOIN y subconsultas.

	# RESPUESTA
SELECT t.id, company_name, country
FROM company AS c
LEFT JOIN transaction AS t 
ON c.id = t.company_id
WHERE country = (SELECT country
				FROM company
				WHERE company_name = 'Non Institute');

# Muestra el listado aplicando solo subconsultas.

	# Subconsuta interna
SELECT id, company_id
FROM transaction;			# fitrando transacciones y id compañias

	# RESPUESTA
SELECT t.id, company_name, country
FROM company AS c,
	(SELECT id, company_id 
    FROM transaction) t
WHERE t.company_id = c.id
AND country = (SELECT country
				FROM company
				WHERE company_name = 'Non Institute');

# Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3   
# Ejercicio 1

# Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que realizaron 
# transacciones con un valor comprendido entre 350 y 400 euros y en alguna de estas fechas: 
# 29 de abril de 2015, 20 de julio de 2018 y 13 de marzo de 2024. 
# Ordena los resultados de mayor a menor cantidad.

	# empresa con transacciones entre 350 y 400
SELECT company_id, amount    
FROM transaction AS t
WHERE amount BETWEEN 350 AND 400
ORDER BY amount DESC;

	# empresas con transacciones la fechas citadas '2015-04-29', '2018-07-20', '2024-03-13'
SELECT company_id, DATE(timestamp) AS fecha
FROM transaction AS t
WHERE DATE(timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13');

	# RESPUESTA
SELECT company_name, phone, country, DATE(timestamp) AS fecha, amount
FROM transaction AS t
LEFT JOIN company AS c
ON t.company_id = c.id
WHERE DATE(timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
AND amount BETWEEN 350 AND 400
ORDER BY amount DESC;

# Ejercicio 2
# Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera, 
# por lo que te piden la información sobre la cantidad de transacciones que realizan las empresas, 
# pero el departamento de recursos humanos es exigente y quiere un listado de las empresas 
# en las que especifiques si tienen más de 400 transacciones o menos.

	# calculo de num_transacciones para cada empresa
SELECT company_id, COUNT(id) AS num_transacciones
FROM transaction AS t
GROUP BY company_id
ORDER BY num_transacciones;

	# RESPUESTA
SELECT company_name, COUNT(t.id) AS num_transacciones,
CASE WHEN COUNT(t.id) >= 400 THEN 'mayor a 400 transacciones' 	# CASE permite introducir la condicion
     WHEN COUNT(t.id) < 400 THEN 'menor a 400 transacciones'  	# de menor o mayor a 400 transacciones
END AS categoria
FROM transaction AS t
LEFT JOIN company AS c
ON t.company_id = c.id
GROUP BY company_id;