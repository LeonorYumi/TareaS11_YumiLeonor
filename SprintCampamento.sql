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
