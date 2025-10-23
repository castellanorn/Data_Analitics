# SPRINT 4

# Nivel 1.
# Descarga los archivos CSV, estudiales y diseña una base de datos con un esquema de estrella que contenga,
# al menos 4 tablas de las que puedas realizar las siguientes consultas:

# Se visualizaron los archivos csv y los campos que contenian, inferiendo que se trata de una plataforma de ventas digitales 
CREATE DATABASE marketplace;

CREATE TABLE transaction (						# el archivo transactions genera la tabla de hecho que conectara con otras tablas
	id VARCHAR(255) PRIMARY KEY,				# basados en los formatos utilizados en sprint anteriores
	card_id VARCHAR(20),						# se definieron estos formatos para los campos del archivo .csv
	business_id VARCHAR(20),
	timestamp TIMESTAMP,
	amount VARCHAR(50),
	declined BOOLEAN,
    product_ids VARCHAR(20),
	user_id INTEGER,
	lat FLOAT,
	longitude FLOAT);

SELECT * FROM transaction;

LOAD DATA									
INFILE "C:\Users\Usuario\Desktop\ESPECIALIZACION ANALISIS DE DATOS\SQL\transactions.csv"
INTO TABLE transaction 
FIELDS TERMINATED BY ';'								# cargar de datos en tabla transaction
IGNORE 1 ROWS;											# error code 1290 restriccion de seguridad para carga 

LOAD DATA
INFILE "C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\transactions.csv"   		# ruta indicada por security file priv
INTO TABLE transaction 
FIELDS TERMINATED BY ';'								# nuevamente carga de datos en tabla transaction, ruta del sistema
IGNORE 1 ROWS;											# error code 1290, 
-- "\" = caracter de escape en MySQL para sentencias,
-- para uso literal deben colocarse doble "\\" 

LOAD DATA
INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\transactions.csv"	# modificacion a \\
INTO TABLE transaction 
FIELDS TERMINATED BY ';'								# nuevamente carga de datos en tabla transaction, ruta del sistema
IGNORE 1 ROWS;	

SELECT * FROM transaction;		

CREATE TABLE credit_card (			-- Creamos la tabla credit_card 	
	id VARCHAR(15) PRIMARY KEY,									
    user_id VARCHAR(20),							# basados en los formatos utilizados en sprint anteriores
	iban VARCHAR(50),								# se definieron estos formatos para el archivo .csv
    pan VARCHAR(50),								# para campos nuevos se fijo como estandar VARCHAR(255)
	pin VARCHAR(4),
	cvv VARCHAR(3),
    track1 VARCHAR(255),
    track2 VARCHAR(255),
	expiring_date VARCHAR(15)
    );

LOAD DATA																			# cargar de datos en tabla credit_card
INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\credit_cards.csv'		# ruta indicada por security file priv
INTO TABLE credit_card 
FIELDS TERMINATED BY ','															# cambia el delimitador respecto al archivo anterior
IGNORE 1 ROWS;

SELECT * FROM credit_card;

ALTER TABLE transaction
ADD CONSTRAINT transaction_card_fkey FOREIGN KEY (card_id) REFERENCES credit_card (id);

SELECT * FROM credit_card;


CREATE TABLE company (							-- Creamos la tabla company 
        id VARCHAR(15) PRIMARY KEY,
        company_name VARCHAR(255),						# basados en los formatos utilizados en sprint anteriores
        phone VARCHAR(15),								# se definieron estos formatos para el archivo .csv
        email VARCHAR(100),
        country VARCHAR(100),
        website VARCHAR(255));

LOAD DATA																			# cargar de datos en tabla company
INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\companies.csv'			# ruta indicada por security file priv
INTO TABLE company 
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT * FROM company;

ALTER TABLE transaction
CHANGE COLUMN business_id company_id VARCHAR(15);						# cambio del nombre del campo para unificarlo luego

ALTER TABLE transaction
ADD CONSTRAINT transaction_company_fkey FOREIGN KEY (company_id) REFERENCES company (id);

SELECT * FROM company;

CREATE TABLE user (							-- Creamos la tabla user 
	id INTEGER PRIMARY KEY,
	name VARCHAR(100),									# basados en los formatos utilizados en sprint anteriores
	surname VARCHAR(100),								# se definieron estos formatos para el archivo .csv
	phone VARCHAR(150),
	email VARCHAR(150),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)
	);

LOAD DATA																			# cargar de datos en tabla user
INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\european_users.csv'		# archivo usuarios europeos
INTO TABLE user 																	# ruta indicada por security file priv
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;										
# error 1262 diferencia de campos entre archivo y tabla
-- algunos registros tiene campos entre comillas ("") por uso de coma (,) dentro de los datos

LOAD DATA																			# nueva carga de datos en tabla user
INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\european_users.csv'		# archivo usuarios europeos
INTO TABLE user 																	# ruta indicada por security file priv
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'					# comando para considerar algunos campos entre comillas "" no todos
IGNORE 1 ROWS;

LOAD DATA																			# cargar de datos en tabla user
INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\american_users.csv'		# archivo usuarios americanos
INTO TABLE user 																	# ruta indicada por security file priv
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;

SELECT * FROM user;

ALTER TABLE transaction
ADD CONSTRAINT transaction_user_fkey FOREIGN KEY (user_id) REFERENCES user (id);

SELECT * FROM user;

# Ejercicio 1
# Realiza una subconsulta que muestre a todos los usuarios con más de 80 transacciones utilizando al menos 2 tablas.

SELECT id, t.num_transacciones, name, surname
FROM user, (SELECT user_id, COUNT(id) AS num_transacciones FROM transaction				# subconsulta sobre tabla transaction 					 
			GROUP BY user_id HAVING COUNT(id) > 80) AS t								# agrupa por user limita a mas de 80 transacciones 
WHERE t.user_id = id;

SELECT user_id, COUNT(id) AS num_transacciones, (SELECT name FROM user 
												WHERE id = t.user_id) AS user_name		# subconsulta sobre tabla user
FROM transaction AS t      									
GROUP BY user_id 										 
HAVING COUNT(id) > 80 ;

# Ejercicio 2
# Muestra la media de amount por IBAN de las tarjetas de crédito en la compañía Donec Ltd., utiliza por lo menos 2 tablas.

SELECT ROUND(AVG(t.amount), 2) AS avg_ventas, ca.iban AS iban_card_DonecLtd
FROM transaction AS t
JOIN company AS co										# se unen las 3 tablas implicadas en la sentencia
ON co.id = t.company_id									# transaction, credit_card y company
JOIN credit_card AS ca
ON ca.id = t.card_id
WHERE co.company_name = "Donec Ltd"						# filtro por transacciones de la empresa Donec Ltd.
GROUP BY ca.iban										# agrupar por iban de tarjeta
;

# Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2

# Crea una nueva tabla que refleje el estado de las tarjetas de crédito basado en: 
# si las tres últimas transacciones han sido declinadas entonces es inactivo, si al menos una no es rechazada entonces es activo. 
# Partiendo de esta tabla responde:

# Se requieren 2 cosas para crear la nueva tabla:
-- Clasificar las tarjetas en activas e inactivas con un condicional, se usa CASE WHEN THEN
-- Definir la condición que permite separar las tarjetas, se usa la funcion ventana OVER, RANK, ROW_NUMBER

SELECT id, timestamp, card_id, declined, COUNT(declined)
OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS orden		# aqui se agrupa con PARTITION BY, y ordena ORDER BY
FROM transaction;

# funcion ventana en select (para confirmar el orden de uso de tarjeta) y en condicion del CASE para definir que separar
SELECT  card_id, declined, COUNT(declined)   							
OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS orden,				
CASE	WHEN declined = 1 AND COUNT(declined)
		OVER (partition by card_id order by timestamp DESC) IN (1, 2, 3) THEN  "inactiva"		# condiciones para inactivo
		ELSE "activa"																			# condiciones para activo
END AS status 
FROM transaction
GROUP BY card_id; 	

# al usar GROUP BY genera error 1055, indica no compatible con slq_mode = only_full_group_by
# se soliciona limitando el select o desactivando este modo
# incluso abajo limitando el select a solo el campo que agrupa y la funcion agregada		

SELECT  card_id, COUNT(declined)   							
OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS orden,				
CASE	WHEN declined = 1 AND COUNT(declined)
		OVER (partition by card_id order by timestamp DESC) IN (1, 2, 3) THEN  "inactiva"		# condiciones para inactivo
		ELSE "activa"																			# condiciones para activo
END AS status 
FROM transaction
GROUP BY card_id; 			

# Se procede a desactivar el modo ONLY_FULL_GROUP_BY para aplicar la consulta que genera la tabla
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));		# DESACTIVAR

CREATE TABLE card_status AS							# se crea una tabla que permita revisar a futuro la consulta
SELECT  card_id, #COUNT(declined) OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS orden,				
CASE	WHEN declined = 1 AND COUNT(declined)
		OVER (partition by card_id order by timestamp DESC) IN (1, 2, 3) THEN  "inactiva"		# condiciones para inactivo
		ELSE "activa"																			# condiciones para activo
END AS status 
FROM transaction
GROUP BY card_id; 	

SELECT * FROM card_status;		

# Se activa nuevamente el modo 
SET SESSION sql_mode = CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');		# ACTIVAR

SELECT * FROM card_status;	 # se confirma que se puede consultar la tabla creada

# Ejercicio 1
# ¿Cuántas tarjetas están activas?

SELECT COUNT(status) 					# se consulta la tabla card_status filtrando status activo
FROM status_card
WHERE status = "activa";

# Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3 

# Crea una tabla con la que podamos unir los datos del nuevo archivo products.csv con la base de datos creada, 
# teniendo en cuenta que desde transaction tienes product_ids. Genera la siguiente consulta:

# primero se crea la tabla product definiendo los campos a partir del archivo products.csv

CREATE TABLE product (							-- Creamos la tabla product
	id INTEGER PRIMARY KEY,
	product_name VARCHAR(255),					# se definieron estos formatos
	price VARCHAR(20),								# en funcion de los registros del archivo .csv
	colour VARCHAR(15),
	weight FLOAT,
	warehouse_id VARCHAR(15));

LOAD DATA																			# cargar de datos en tabla product
INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\products.csv'			# ruta indicada por security file priv
INTO TABLE product 
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT * FROM product;

UPDATE product 								# eliminar el simbolo $ para dejar solo el valor numerico
SET price = REPLACE(price,'$','');

UPDATE product SET price = TRIM(LEADING '$' FROM price);

UPDATE product SET price = SUBSTRING(price, 1);

UPDATE product SET price = REPLACE(price,'$','') WHERE id IS NOT NULL;

UPDATE product SET price = REPLACE(price,'$','') WHERE price LIKE '$%';

# Actualizacion del campo price no se consigue por esta activado "safe update mode" actualizacion segura
# Se procede a desactivar temporalmente este modo para aplica el cambio
SET SQL_SAFE_UPDATES = 0;					# Desactivar el modo de actualizacion segura

UPDATE product 								# ejecutar sentencia para eliminar 
SET price = REPLACE(price,'$','');			# simbolo $ y dejar solo el valor numerico en price

SET SQL_SAFE_UPDATES = 1;					# Activar el modo de actualizacion segura 

SELECT * FROM product;						# comprobar que campo price solo queda con valor numerico

# se procede ahora a establecer la relacion entre la tabla transaction y product, con una tabla de asociación
# Para crear esta tabla intermedia se debe separa la lista de productos en cada transaccion
# con el comando JSON_TABLE se puede obtener la columna de product_id 
# pero antes se debe modificar el formato, se decide crea la columna product_ids_json

# columna de productos en formato JSON
ALTER TABLE transaction											
ADD COLUMN product_ids_json JSON AS (CONCAT("[", REPLACE(product_ids, " ",""),"]"));

# Se crea la tabla intermedia transaction_product
CREATE TABLE transaction_product        						
SELECT t.id AS transaction_id, tp.product_id AS product_id
FROM transaction AS t,
JSON_TABLE(														# con comando JSON_TABLE se crea
	t.product_ids_json,											# columna product_id a partir de product_ids_json
	'$[*]' COLUMNS(
		product_id INT PATH '$')
) AS tp;	

SELECT * FROM transaction_product;  
  
# Relacion entre la tabla transation_product a traves de restriccion y Foreign key con tabla producto y transaction

ALTER TABLE transaction_product
ADD CONSTRAINT product_fkey FOREIGN KEY (product_id) REFERENCES product (id);   			-- referencia a traves de product.id

ALTER TABLE transaction_product
ADD CONSTRAINT transaction_fkey FOREIGN KEY (transaction_id) REFERENCES transaction (id); 	-- referencia a traves de product.id

SELECT * FROM transaction_product; 

# Ejercicio 1
# Necesitamos conocer el número de veces que se ha vendido cada producto.

# Ahora con una columna de product_id separada y relacionada con transaction_id se puede calcular la cantidad de ventas

SELECT tp.product_id, p.product_name, COUNT(tp.product_id) AS cantidades_vendidas
FROM transaction_product AS tp
JOIN product AS p
ON p.id = tp.product_id
GROUP BY tp.product_id;



