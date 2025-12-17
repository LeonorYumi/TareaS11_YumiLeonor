-- crear base de datos
create database negocios_extranjeros;
\c negocios_extranjeros;

-- crear tablas principales
-- tabla cliente
create table cliente (
    cliente_id serial primary key,
    nombre varchar(100),
    pais varchar(50),
    email varchar(100)
);

-- tabla inversionista
create table inversionista (
    inversionista_id serial primary key,
    nombre varchar(100),
    capital numeric(12,2)
);

-- tabla venta
create table venta (
    venta_id serial primary key,
    cliente_id int references cliente(cliente_id),
    inversionista_id int references inversionista(inversionista_id),
    monto numeric(12,2),
    fecha date
);

-- tabla de auditoria
create table audit_log (
    audit_id serial primary key,
    usuario varchar(100),
    operacion varchar(10),
    tabla_afectada varchar(50),
    fecha timestamp default current_timestamp,
    id_afectado int,
    old_data jsonb,
    new_data jsonb
);

-- crear usuarios (roles)
-- usuario analista
-- el analista puede realizar operaciones de negocio
-- no puede crear usuarios, modificar privilegios ni alterar auditoria
create role analista login password 'analista123';

-- asignar permisos al analista
grant select, insert, update, delete
on cliente, inversionista, venta
to analista;

-- usuario visor
-- el visor solo puede consultar informacion
create role visor login password 'visor123';

-- asignar permisos de solo lectura
grant select
on cliente, inversionista, venta, audit_log
to visor;

-- funciones y triggers de auditoria
-- triggers tabla cliente

-- insert cliente
create or replace function fn_cliente_insert()
returns trigger as $$
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, new_data)
    values (
        current_user,
        'insert',
        'cliente',
        new.cliente_id,
        jsonb_build_object(
            'nombre', new.nombre,
            'pais', new.pais,
            'email', new.email
        )
    );
    return new;
end;
$$ language plpgsql;

create trigger trg_cliente_insert
after insert on cliente
for each row
execute function fn_cliente_insert();

-- update cliente
create or replace function fn_cliente_update()
returns trigger as $$
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, old_data, new_data)
    values (
        current_user,
        'update',
        'cliente',
        new.cliente_id,
        jsonb_build_object(
            'nombre', old.nombre,
            'pais', old.pais,
            'email', old.email
        ),
        jsonb_build_object(
            'nombre', new.nombre,
            'pais', new.pais,
            'email', new.email
        )
    );
    return new;
end;
$$ language plpgsql;

create trigger trg_cliente_update
after update on cliente
for each row
execute function fn_cliente_update();

-- delete cliente
create or replace function fn_cliente_delete()
returns trigger as $$
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, old_data)
    values (
        current_user,
        'delete',
        'cliente',
        old.cliente_id,
        jsonb_build_object(
            'nombre', old.nombre,
            'pais', old.pais,
            'email', old.email
        )
    );
    return old;
end;
$$ language plpgsql;

create trigger trg_cliente_delete
after delete on cliente
for each row
execute function fn_cliente_delete();

-- triggers tabla inversionista
-- insert inversionista
create or replace function fn_inversionista_insert()
returns trigger as $$
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, new_data)
    values (
        current_user,
        'insert',
        'inversionista',
        new.inversionista_id,
        jsonb_build_object(
            'nombre', new.nombre,
            'capital', new.capital
        )
    );
    return new;
end;
$$ language plpgsql;

create trigger trg_inversionista_insert
after insert on inversionista
for each row
execute function fn_inversionista_insert();

-- update inversionista
create or replace function fn_inversionista_update()
returns trigger as $$
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, old_data, new_data)
    values (
        current_user,
        'update',
        'inversionista',
        new.inversionista_id,
        jsonb_build_object(
            'nombre', old.nombre,
            'capital', old.capital
        ),
        jsonb_build_object(
            'nombre', new.nombre,
            'capital', new.capital
        )
    );
    return new;
end;
$$ language plpgsql;

create trigger trg_inversionista_update
after update on inversionista
for each row
execute function fn_inversionista_update();

-- delete inversionista
create or replace function fn_inversionista_delete()
returns trigger as $$
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, old_data)
    values (
        current_user,
        'delete',
        'inversionista',
        old.inversionista_id,
        jsonb_build_object(
            'nombre', old.nombre,
            'capital', old.capital
        )
    );
    return old;
end;
$$ language plpgsql;

create trigger trg_inversionista_delete
after delete on inversionista
for each row
execute function fn_inversionista_delete();

-- triggers tabla venta
-- insert venta
create or replace function fn_venta_insert()
returns trigger as $$
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, new_data)
    values (
        current_user,
        'insert',
        'venta',
        new.venta_id,
        jsonb_build_object(
            'cliente_id', new.cliente_id,
            'inversionista_id', new.inversionista_id,
            'monto', new.monto,
            'fecha', new.fecha
        )
    );
    return new;
end;
$$ language plpgsql;

create trigger trg_venta_insert
after insert on venta
for each row
execute function fn_venta_insert();

-- update venta
create or replace function fn_venta_update()
returns trigger as $$
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, old_data, new_data)
    values (
        current_user,
        'update',
        'venta',
        new.venta_id,
        jsonb_build_object(
            'cliente_id', old.cliente_id,
            'inversionista_id', old.inversionista_id,
            'monto', old.monto,
            'fecha', old.fecha
        ),
        jsonb_build_object(
            'cliente_id', new.cliente_id,
            'inversionista_id', new.inversionista_id,
            'monto', new.monto,
            'fecha', new.fecha
        )
    );
    return new;
end;
$$ language plpgsql;

create trigger trg_venta_update
after update on venta
for each row
execute function fn_venta_update();

-- delete venta
create or replace function fn_venta_delete()
returns trigger as $$
begin
    insert into audit_log(usuario, operacion, tabla_afectada, id_afectado, old_data)
    values (
        current_user,
        'delete',
        'venta',
        old.venta_id,
        jsonb_build_object(
            'cliente_id', old.cliente_id,
            'inversionista_id', old.inversionista_id,
            'monto', old.monto,
            'fecha', old.fecha
        )
    );
    return old;
end;
$$ language plpgsql;

create trigger trg_venta_delete
after delete on venta
for each row
execute function fn_venta_delete();

-- verificacion de permisos
-- consultar permisos del analista
select * from information_schema.role_table_grants
where grantee = 'analista';

-- consultar permisos del visor
select * from information_schema.role_table_grants
where grantee = 'visor';

-- pruebas
-- pruebas como analista
insert into cliente(nombre, pais, email)
values ('maria lopez', 'ecuador', 'maria@mail.com');

update cliente set pais = 'peru'
where cliente_id = 1;

delete from cliente where cliente_id = 1;

-- pruebas como visor
select * from audit_log;
