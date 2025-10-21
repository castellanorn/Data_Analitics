# SPRINT 3

# Nivel 1.
 
# Ejercicio 1
# Tu tarea es diseñar y crear una tabla llamada "credit_card" que almacene detalles cruciales sobre las tarjetas de crédito. 
# La nueva tabla debe ser capaz de identificar de forma única cada tarjeta y establecer una relación adecuada con 
# las otras dos tablas ("transaction" y "company"). Después de crear la tabla será necesario que ingreses la información 
# del documento denominado "datos_introducir_credit". Recuerda mostrar el diagrama y realizar una breve descripción del mismo.

CREATE TABLE credit_card (		-- Creamos la tabla credit_card 	
	id VARCHAR(15),
	iban VARCHAR(40),
    pan VARCHAR(40),
	pin VARCHAR(4),
	cvv VARCHAR(3),
	expiring_date VARCHAR(15));
    
# Luego se ejecuta el script con los datos de la tabla credit_card
-- Insertamos datos de credit_card
# INSERT INTO credit_card (id, iban, pan, pin, cvv, expiring_date) 
# VALUES ('CcU-2938', 'TR301950312213576817638661', '5424465566813633', '3257', '984', '10/30/22');
# ....    
SELECT * FROM credit_card;

# Se debe cambiar el formato de los datos de fecha, se cargaron como varchar para luego modificar
ALTER TABLE credit_card
RENAME COLUMN expiring_date TO expiring_date_varchar;       -- Se renombra para mantener nombre original

# Se crea la columna con formato DATE, trasnformando la columna inicial que viene en formato regional mm/dd/yy
ALTER TABLE credit_card										
ADD COLUMN expiring_date DATE AS (STR_TO_DATE(REPLACE(expiring_date_varchar,'/','.') ,GET_FORMAT(date,'USA')));

SELECT * FROM credit_card;

# Se define la clave primaria PK de la tabla credit_card
ALTER TABLE credit_card			
ADD PRIMARY KEY (id);

# Se crea la relacion de clave foranea entre la tabla transaction y credit_card
ALTER TABLE transaction
ADD CONSTRAINT company_id FOREIGN KEY (company_id) REFERENCES company (id);

SELECT * FROM credit_card;

## Ejercicio 2
# El departamento de Recursos Humanos ha identificado un error en el número de cuenta asociado 
# a su tarjeta de crédito  con ID CcU-2938. La información que debe mostrarse para este registro 
# es: TR323456312213576817699999. Recuerda mostrar que el cambio se realizó.
UPDATE credit_card
SET iban = "TR323456312213576817699999"
WHERE id = "CcU-2938";

SELECT id, iban
FROM credit_card
WHERE id = "CcU-2938";

# Ejercicio 3
# En la tabla "transaction" ingresa una nueva transacción con la siguiente información:
# Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD	# credit_card_id	CcU-9999	# company_id	b-9999 		# user_id	9999	
# lat	829.999 								# longitude	-117.999			# amount	111.11			# declined	0

INSERT INTO company (id) VALUES ('b-9999');			-- Introducir el registro en la tabla company (integridad referencial)
INSERT INTO credit_card (id) VALUES ('CcU-9999');	-- Introducir el registro en la tabla credit_card (integridad referencial)

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined) 
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', NOW(), '111.11', '0');

SELECT * FROM transaction WHERE company_id = 'b-9999'; 

DELETE FROM company WHERE id = 'b-9999';
DELETE FROM transaction WHERE company_id = 'b-9999';

# Ejercicio 4
# Desde recursos humanos te solicitan eliminar la columna "pan" de la tabla credit_card. 
# Recuerda mostrar el cambio realizado.

ALTER TABLE credit_card
DROP COLUMN pan;

SELECT * FROM credit_card;


# Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2 - Nivel 2

# Ejercicio 1
# Elimina de la tabla transacción el registro con ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de datos.

DELETE FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

SELECT id
FROM transaction
WHERE id ='000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

# Ejercicio 2
# La sección de marketing desea tener acceso a información específica para realizar análisis y estrategias efectivas. Se ha solicitado
# crear una vista que proporcione detalles clave sobre las compañías y sus transacciones. Será necesaria que crees una vista 
# llamada VistaMarketing que contenga la siguiente información: Nombre de la compañía. Teléfono de contacto. País de residencia. 
# Media de compra realizado por cada compañía. Presenta la vista creada, ordenando los datos de mayor a menor promedio de compra.
CREATE VIEW VistaMarketing AS
SELECT c.company_name, c.phone, c.country, ROUND(AVG(t.amount), 2) AS avg_amount
FROM company AS c
LEFT JOIN transaction AS t   ### verificar comportamiento de joins
ON c.id = t.company_id
GROUP BY c.company_name, c.phone, c.country
ORDER BY avg_amount DESC;
SELECT * FROM VistaMarketing
ORDER BY avg_amount DESC;

# Ejercicio 3
# Filtra la vista VistaMarketing para mostrar sólo las compañías que tienen su país de residencia en "Germany"

SELECT * 
FROM VistaMarketing 
WHERE country = 'Germany'
ORDER BY avg_amount DESC;


# Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3 - Nivel 3   

# Ejercicio 1
# La próxima semana tendrás una nueva reunión con los gerentes de marketing. Un compañero de tu equipo realizó 
# modificaciones en la base de datos, pero no recuerda cómo las realizó. Te pide que le ayudes a dejar 
# los comandos ejecutados para obtener el siguiente diagrama anexo en el informe

-- Se ejecutan los script entregados de tabla user ("estructura datos user.sql", "datos introducir sprint3 user.sql")
SELECT * FROM user;

# Se establecen las relaciones y definen claves foraneas con tabla transaction
ALTER TABLE user					
CHANGE COLUMN id id INTEGER; 				# cambio del tipo de dato para coincidir con tabla transaction y diagrama

ALTER TABLE transaction
ADD CONSTRAINT transaction_user_fkey FOREIGN KEY (user_id) REFERENCES user (id);   
# genera error 1452 por integridad referencial por se pueden vincular, revisar que registro falta

SELECT DISTINCT user_id
FROM transaction
WHERE user_id NOT IN (SELECT id FROM user);		# falta el registro insertado en el sprint 2 user_id = 9999

INSERT INTO user (id) VALUES (9999);
# se vuelve a ejecutar la sentencia de la linea 142   

# Ahora se ajustan el tipo de dato, extension y nombres para la tabla credit_card este como en el diagrama
ALTER TABLE credit_card					
CHANGE COLUMN id id VARCHAR(20);
ALTER TABLE credit_card					
MODIFY COLUMN iban VARCHAR(50);
ALTER TABLE credit_card					
MODIFY COLUMN cvv INTEGER;
ALTER TABLE credit_card					
MODIFY COLUMN expiring_date_varchar VARCHAR(20);
ALTER TABLE credit_card					
DROP COLUMN expiring_date;
ALTER TABLE credit_card					
RENAME COLUMN expiring_date_varchar TO expiring_date;

# Ahora se ejecutan el resto de los cambios a las tablas para imitar la imagen del diagrama presentado

# creacion del campo fecha actual con formato DATE
ALTER TABLE credit_card
ADD COLUMN fecha_actual DATE DEFAULT (CURRENT_DATE);	

# se elimina el campo website
ALTER TABLE company					
DROP COLUMN website;									

# se renombra la Tabla user	
RENAME TABLE user TO data_user;							

# se modifica la longitud del formato VARCHAR
ALTER TABLE transaction					
MODIFY COLUMN credit_card_id VARCHAR(20);				

# Ejercicio 2
# La empresa también le pide crear una vista llamada "InformeTecnico" que contenga la siguiente información:
# ID de la transacción, Nombre del usuario/a, Apellido del usuario/a,
# IBAN de la tarjeta de crédito usada. Nombre de la compañía de la transacción realizada.
# Asegúrese de incluir información relevante de las tablas que conocerá y utilice alias para cambiar de nombre columnas según sea necesario.
# Muestra los resultados de la vista, ordena los resultados de forma descendente en función de la variable ID de transacción.

CREATE VIEW InformeTecnico AS
SELECT t.id AS Num_transaction, u.name AS Name_user, u.surname AS Lastname_user, cc.iban AS Num_iban_Credit_card, c.company_name AS name_company_selling
FROM transaction AS t
JOIN data_user AS u
ON t.user_id = u.id
JOIN credit_card AS cc
ON t.credit_card_id = cc.id
JOIN company AS c
ON t.company_id = c.id
ORDER BY t.id DESC;
SELECT * FROM InformeTecnico ORDER BY Num_transaction DESC;
