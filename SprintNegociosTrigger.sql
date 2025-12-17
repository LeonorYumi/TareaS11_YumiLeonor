-- crear base de datos
create database negocios_extranjeros;
use negocios_extranjeros;

-- crear tablas 
create table cliente (
    cliente_id int auto_increment primary key,
    nombre varchar(100),
    pais varchar(50),
    email varchar(100)
);
select * from cliente; 

create table inversionista (
    inversionista_id int auto_increment primary key,
    nombre varchar(100),
    capital decimal(12,2)
);
select * from inversionista;
 
create table venta (
    venta_id int auto_increment primary key,
    cliente_id int,
    inversionista_id int,
    monto decimal(12,2),
    fecha date,
    foreign key (cliente_id) references cliente(cliente_id),
    foreign key (inversionista_id) references inversionista(inversionista_id)
);
select * from venta;
 
-- tabla de auditoria
create table audit_log (
    audit_id int auto_increment primary key,
    usuario varchar(100),
    operacion varchar(10),
    tabla_afectada varchar(50),
    fecha timestamp default current_timestamp,
    id_afectado int,
    old_data json,
    new_data json
);
select * from audit_log; 

-- CREAR USUARIOS 
-- usuario analista 
-- el usuario analista no tiene permisos para crear usuarios, modificar privilegios, 
-- eliminar la tabla de auditoría ni alterar triggers.
create user 'analista'@'localhost' identified by 'analista123';

-- asignar permisos 
grant select, insert, update, delete on negocios_extranjeros.cliente to 'analista'@'localhost';
flush privileges;

grant select, insert, update, delete on negocios_extranjeros.inversionista to 'analista'@'localhost';
flush privileges;

grant select, insert, update, delete on negocios_extranjeros.venta to 'analista'@'localhost';
flush privileges;

-- usuario visor
create user 'visor'@'localhost' identified by 'visor123';

-- Otorgar permisos
grant select on negocios_extranjeros.cliente to 'visor'@'localhost';
flush privileges;

grant select on negocios_extranjeros.inversionista to 'visor'@'localhost';
flush privileges;

grant select on negocios_extranjeros.venta to 'visor'@'localhost';
flush privileges;

grant select on negocios_extranjeros.audit_log to 'visor'@'localhost';
flush privileges;
-- el usuario visor solo tiene permisos de lectura

-- TRIGGERS Y AUDITORIA
-- Triggers tabla cliente 
-- INSERT
delimiter $$
create trigger trg_cliente_insert
after insert on cliente
for each row
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, new_data)
    values (user(), 'insert', 'cliente', new.cliente_id,
        json_object('nombre', new.nombre, 'pais', new.pais,'email', new.email)
    );
end$$
delimiter ;

-- UPDATE
delimiter $$
create trigger trg_cliente_update
after update on cliente
for each row
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, old_data, new_data)
    values (user(), 'update', 'cliente', new.cliente_id,
        json_object('nombre', old.nombre,'pais', old.pais,'email', old.email),
        json_object('nombre', new.nombre,'pais', new.pais,'email', new.email)
    );
end$$
delimiter ;

-- DELETE
delimiter $$
create trigger trg_cliente_delete
after delete on cliente
for each row
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, old_data)
    values (user(),'delete','cliente',old.cliente_id,
        json_object('nombre', old.nombre,'pais', old.pais,'email', old.email)
    );
end$$
delimiter ;

-- Triggers tabla inversionista
-- INSERT
delimiter $$
create trigger trg_inversionista_insert
after insert on inversionista
for each row
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, new_data)
    values (user(),'insert','inversionista', new.inversionista_id,
        json_object('nombre', new.nombre,'capital', new.capital)
    );
end$$
delimiter ;

-- UPDATE
 delimiter $$
create trigger trg_inversionista_update
after update on inversionista
for each row
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, old_data, new_data)
    values (user(),'update','inversionista',new.inversionista_id,
        json_object('nombre', old.nombre,'capital', old.capital),
        json_object('nombre', new.nombre,'capital', new.capital)
    );
end$$
delimiter ;

-- DELETE
delimiter $$
create trigger trg_inversionista_delete
after delete on inversionista
for each row
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, old_data)
    values (user(),'delete','inversionista',old.inversionista_id,
        json_object('nombre', old.nombre,'capital', old.capital)
    );
end$$
delimiter ;

-- Triggers tabla venta
-- INSERT
delimiter $$
create trigger trg_venta_insert
after insert on venta
for each row
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, new_data)
    values (user(),'insert','venta',new.venta_id,
        json_object('cliente_id', new.cliente_id,'inversionista_id', new.inversionista_id,'monto', new.monto,'fecha', new.fecha)
    );
end$$
delimiter ;

-- UPDATE
delimiter $$
create trigger trg_venta_update
after update on venta
for each row
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, old_data, new_data)
    values (user(),'update','venta',new.venta_id,
        json_object('cliente_id', old.cliente_id,'inversionista_id', old.inversionista_id,'monto', old.monto,
            'fecha', old.fecha),
        json_object('cliente_id', new.cliente_id,'inversionista_id', new.inversionista_id,'monto', new.monto,
            'fecha', new.fecha)
    );
end$$
delimiter ;

-- DELETE
delimiter $$
create trigger trg_venta_delete
after delete on venta
for each row
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, old_data)
    values (user(),'delete','venta',old.venta_id,
        json_object('cliente_id', old.cliente_id,'inversionista_id', old.inversionista_id,'monto', old.monto,'fecha', old.fecha)
    );
end$$
delimiter ;

-- VERIFICAR PERMISOS
show grants for 'analista'@'localhost';
show grants for 'visor'@'localhost';
