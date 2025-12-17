-- Crear base de datos 
CREATE DATABASE campamento;
USE campamento;
-- crear tabla
CREATE TABLE clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellidos VARCHAR(50),
    fecha_nacimiento DATE,
    direccion VARCHAR(100),
    telefono VARCHAR(15)
);
CREATE TABLE pago_campamento (
    pago_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    fecha_pago DATE,
    monto DECIMAL(10, 2),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);
-- PRACTICA 1 - Crear Usuarios 
create user 'PP_GRILLO'@'localhost' identified by 'pp123';

-- Crear dos usuarios
create user 'user_Dolores_de _Barriga'@'localhost' identified by 'dolores12';
create user 'user_Paco_ Mer'@'localhost' identified by 'paco12';

-- OTORGAR PRIVILEGIOS
--  user_Dolores_de _Barriga
-- permisos de crud en la tabla clientes
grant select, insert, update on campamento.clientes to 'user_Dolores_de _Barriga'@'localhost';
flush privileges;

-- permisos de consulta en la tabla de pago_campeonato
grant select on campamento.pago_campamento to 'user_Dolores_de _Barriga'@'localhost';
flush privileges;

-- user_Paco_ Mer
-- permisos de crud en la tabla pago_campeonato
grant select, insert, delete on campamento.pago_campamento to 'user_Paco_ Mer'@'localhost';
flush privileges;

-- permisos de consulta en la tabla clientes
grant select on campamento.clientes to 'user_Paco_ Mer'@'localhost';
flush privileges;

-- PRACTICA 2 
-- Otorgar permisos de select y insert en la base de datos al usuario PP_GRILLO
grant select, insert on campamento.* to 'PP_GRILLO'@'localhost';
flush privileges;

-- PRACTICA 3
-- Verificar dos usuarios y privilegios 
select user, host from mysql.user;

-- verificar privilegios 
show grants for 'PP_GRILLO'@'localhost';
show grants for 'user_Dolores_de _Barriga'@'localhost';

-- PRACTICA 4 - Eliminar privilegios
-- revoca el permiso de insersion al usuario PP_GRILLO
revoke insert on campamento.* from 'PP_GRILLO'@'localhost';

-- PRACTICA 5 -- Modificar usuario
-- Cambiar la contraseña del usuario PP_GRILLO
alter user 'PP_GRILLO'@'localhost' identified by '5012';

-- PRACTICA 6 - Modificar Roles
-- Asigna al usuario PP_GRILLO permisos de actualización en la base de datos campamento.
grant update on campamento.* to 'PP_GRILLO'@'localhost';

-- PRACTICA 7 - Privilegios de Super Administrador
-- Crea un usuario super_admin con todos los privilegios en todas las bases de datos.
create user 'super_admin'@'localhost' identified by 'admin12';

-- privelgios
grant all privileges on *.* to 'super_admin'@'localhost' with grant option;
flush privileges;

-- PRACTICA 8 - CRUD en una Tabla
-- Otorga permisos de CRUD (Create, Read, Update, Delete) en la tabla clientes al usuario PP_grillo.
grant select, insert, update, delete on campamento.clientes to 'PP_GRILLO'@'localhost';

-- PRACTICA 9 - Permisos de Solo Selección
-- Otorga permisos de solo selección en la tabla pago_campamento al usuario PP_grillo.
grant select on campamento.pago_campamento to 'PP_GRILLO'@'localhost';

-- PRACTICA 10 - Ejecución de Consultas
-- Verifica los permisos asignados al usuario PP_GRILLO y muestra los permisos.
show grants for 'PP_GRILLO'@'localhost';