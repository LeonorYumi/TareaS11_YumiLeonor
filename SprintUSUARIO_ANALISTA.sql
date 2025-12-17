use negocios_extranjeros;
-- PORBAR PERMISOS COMO ANALISTA
insert into cliente(nombre, pais, email)
values ('maria lopez', 'ecuador', 'maria@mail.com');
select * from cliente;

update cliente set pais = 'peru'
where cliente_id = 1;

delete from cliente where cliente_id = 1;