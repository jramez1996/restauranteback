PGDMP         ,                w            dbventas    10.7    10.7 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    16759    dbventas    DATABASE     �   CREATE DATABASE dbventas WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Spanish_Spain.1252' LC_CTYPE = 'Spanish_Spain.1252';
    DROP DATABASE dbventas;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    3                        3079    12924    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            �           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            �            1259    73755    empleado    TABLE     �  CREATE TABLE public.empleado (
    nombrescompletos character varying(150) NOT NULL,
    apellidopaterno character varying(150) NOT NULL,
    apellidomaterno character varying(150) NOT NULL,
    direccion character varying(100) NOT NULL,
    correo character varying(150),
    id integer NOT NULL,
    distrito integer,
    fechanacimiento date,
    documento character varying(16) NOT NULL
);
    DROP TABLE public.empleado;
       public         postgres    false    3                       1255    98314 '   actualizar_empleados(public.empleado[])    FUNCTION     j  CREATE FUNCTION public.actualizar_empleados(public.empleado[]) RETURNS TABLE(estado boolean, mensaje text)
    LANGUAGE plpgsql
    AS $_$
 declare arempleado empleado;
BEGIN
  foreach arempleado in array $1
  loop 
  update empleado 
	set 
	nombrescompletos=arempleado.nombrescompletos,
	apellidopaterno= arempleado.apellidopaterno,
	direccion= arempleado.direccion,
	correo= arempleado.correo,
	apellidomaterno= arempleado.apellidomaterno,
	distrito= arempleado.distrito,
	fechanacimiento= arempleado.fechanacimiento where id= arempleado.id;
 end loop;
 RETURN QUERY select true,'actualizo correctamente';
END; $_$;
 >   DROP FUNCTION public.actualizar_empleados(public.empleado[]);
       public       postgres    false    215    3    1                        1255    57355 @   actualizarproducto(integer, numeric, integer, character varying)    FUNCTION     |  CREATE FUNCTION public.actualizarproducto(pidproducto integer, ppreciounitario numeric, pidcategoria integer, pdescripcion character varying) RETURNS TABLE(msg text, estado boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN

--cantidad:=(select count(*) from producto where idproducto=pidproducto);
if (select count(*) from producto where idproducto=pidproducto)>0 then 
	update producto set preciounitario=ppreciounitario,idcategoria=pidcategoria,descripcion=pdescripcion 
	where idproducto=pidproducto;
	RETURN QUERY select 'se actualizo correctamente',true ;
else 
	RETURN QUERY select 'no se encontro producto',false ;
end if;

END; $$;
 �   DROP FUNCTION public.actualizarproducto(pidproducto integer, ppreciounitario numeric, pidcategoria integer, pdescripcion character varying);
       public       postgres    false    3    1            �            1255    16993 1   get_cliente(character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.get_cliente(p_documento character varying, p_tipo character varying) RETURNS TABLE(p_idcliente integer, p_nombrecompletos character varying, p_tipocliente character varying, documento character varying, direccion character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY select *from cliente as cl 
	where cl.documento=p_documento and cl.tipocliente=p_tipo;

END; $$;
 [   DROP FUNCTION public.get_cliente(p_documento character varying, p_tipo character varying);
       public       postgres    false    3    1            �            1255    16999    get_clientes()    FUNCTION     #  CREATE FUNCTION public.get_clientes() RETURNS TABLE(p_id integer, p_nombres character varying, p_tipocliente character varying, p_documento character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY SELECT
 idcliente,nombrecompletos,tipocliente,documento
 FROM
 cliente;
END; $$;
 %   DROP FUNCTION public.get_clientes();
       public       postgres    false    3    1            �            1255    17005    get_correlativo(text)    FUNCTION     �   CREATE FUNCTION public.get_correlativo(tipo text) RETURNS integer
    LANGUAGE plpgsql
    AS $$

 DECLARE cantidad Integer;
BEGIN
cantidad:=(select count(*) as cantidad from venta where tipodocumento=tipo )+1; 
 return cantidad;
END; $$;
 1   DROP FUNCTION public.get_correlativo(tipo text);
       public       postgres    false    3    1            �            1255    73875    get_departamento(integer)    FUNCTION     J  CREATE FUNCTION public.get_departamento(piddepartamento integer) RETURNS TABLE(descripciondepartamento character varying, iddepartamento integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY select det.descripcion,det.id from departamento det 
 where  det.id=COALESCE (piddepartamento, det.id) order by det.id asc;
END; $$;
 @   DROP FUNCTION public.get_departamento(piddepartamento integer);
       public       postgres    false    3    1                       1255    73874    get_distrito(integer, integer)    FUNCTION     �  CREATE FUNCTION public.get_distrito(pid integer, pidprovincia integer) RETURNS TABLE(descripciondistrito character varying, iddistrito integer, idprovincia integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY select pr.descripcion,pr.id,pr.idprovincia from distrito pr 
 where  pr.id=COALESCE (pid, pr.id) and pr.idprovincia=COALESCE (pidprovincia, pr.idprovincia)
 order by pr.id asc;
END; $$;
 F   DROP FUNCTION public.get_distrito(pid integer, pidprovincia integer);
       public       postgres    false    3    1                       1255    90124    get_empleados(integer)    FUNCTION     u  CREATE FUNCTION public.get_empleados(pidempleado integer) RETURNS TABLE(documento character varying, idempleado integer, nombrescompletos character varying, apellidopaterno character varying, apellidomaterno character varying, direccion character varying, correo character varying, distrito integer, discripciondistrito character varying, fechanacimiento date, idprovincia integer, iddepartamento integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY 

select e.documento,e.id idempelado ,e.nombrescompletos,e.apellidopaterno,
 e.apellidomaterno,e.direccion
,e.correo,e.distrito ,

d.descripcion discripciondistrito,e.fechanacimiento, 
p.id idprovincia,d.id iddepartamento
from empleado e
inner join distrito d on e.distrito=d.id
inner join provincia p on d.idprovincia=p.id
inner join departamento de on de.id=p.iddepartamento
where e.id=COALESCE (pidempleado,  e.id);
END; $$;
 9   DROP FUNCTION public.get_empleados(pidempleado integer);
       public       postgres    false    1    3            �            1255    16915    get_empresa()    FUNCTION     �   CREATE FUNCTION public.get_empresa() RETURNS TABLE(p_ruc character, p_razonsocial character varying, p_direccion character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY SELECT
 ruc,razonsocial,direccion
 FROM
 empresa;
END; $$;
 $   DROP FUNCTION public.get_empresa();
       public       postgres    false    1    3                       1255    65546    get_generarnumeroventa()    FUNCTION     �   CREATE FUNCTION public.get_generarnumeroventa() RETURNS TABLE(numero bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY select count(*) as numeroventa from venta;
END; $$;
 /   DROP FUNCTION public.get_generarnumeroventa();
       public       postgres    false    3    1            �            1255    17007    get_producto(integer)    FUNCTION     D  CREATE FUNCTION public.get_producto(pa_idproducto integer) RETURNS TABLE(p_idproducto integer, p_nombre character varying, p_stock integer, p_preciounitario numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY select idproducto,nombre,stock,preciounitario from producto pr where pr.idproducto=pa_idproducto;
END; $$;
 :   DROP FUNCTION public.get_producto(pa_idproducto integer);
       public       postgres    false    1    3                       1255    57356    get_productos()    FUNCTION     �  CREATE FUNCTION public.get_productos() RETURNS TABLE(r_idproducto integer, r_nombre character varying, r_stock integer, r_preciounitario numeric, ridcategoria integer, rcategoria character varying, rdescripcion character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN

 RETURN QUERY select p.idproducto,p.nombre,p.stock,p.preciounitario,c.id as idcategoria,c.nombre as categoria,p.descripcion from producto p
 inner join categoria c on p.idcategoria=c.id
 where p.stock>0;
END; $$;
 &   DROP FUNCTION public.get_productos();
       public       postgres    false    1    3            �            1255    49167    get_productos(integer)    FUNCTION       CREATE FUNCTION public.get_productos(p_idproducto integer) RETURNS TABLE(idproducto integer, nombre character varying, stock integer, preciounitario numeric, idcategoria integer, categoria character varying, imgproducto text, descripcion character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY select p.idproducto,p.nombre,p.stock,p.preciounitario,c.id as idcategoria,c.nombre as categoria,p.imgproducto,p.descripcion from producto p
 inner join categoria c on p.idcategoria=c.id
 where p.idproducto=p_idproducto;
END; $$;
 :   DROP FUNCTION public.get_productos(p_idproducto integer);
       public       postgres    false    1    3                       1255    57357    get_productos02()    FUNCTION     �  CREATE FUNCTION public.get_productos02() RETURNS TABLE(r_idproducto integer, r_nombre character varying, r_stock integer, r_preciounitario numeric, ridcategoria integer, rcategoria character varying, rdescripcion character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY select p.idproducto,p.nombre,p.stock,p.preciounitario,c.id as idcategoria,c.nombre as categoria,p.descripcion from producto p
 inner join categoria c on p.idcategoria=c.id;
END; $$;
 (   DROP FUNCTION public.get_productos02();
       public       postgres    false    3    1            �            1255    24615    get_productoscategoria(integer)    FUNCTION     ^  CREATE FUNCTION public.get_productoscategoria(par_idcategoria integer) RETURNS TABLE(p_idproducto integer, p_producto character varying, p_stock integer, p_preciounitario numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY SELECT
 idproducto,nombre,stock,preciounitario
 FROM
 producto WHERE stock>0 and par_idcategoria=idcategoria;
END; $$;
 F   DROP FUNCTION public.get_productoscategoria(par_idcategoria integer);
       public       postgres    false    3    1            �            1255    41000    get_productosnombre()    FUNCTION     �   CREATE FUNCTION public.get_productosnombre() RETURNS TABLE(r_idproducto integer, r_producto character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY SELECT
  p.idproducto, p.nombre
 FROM
 producto p;
END; $$;
 ,   DROP FUNCTION public.get_productosnombre();
       public       postgres    false    1    3                       1255    73870    get_provincia(integer)    FUNCTION       CREATE FUNCTION public.get_provincia(pid integer) RETURNS TABLE(descripcion character varying, id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY select pr.descripcion,pr.id from provincia pr 
 where  pr.id=COALESCE (pid, det.id) order by det.id asc;
END; $$;
 1   DROP FUNCTION public.get_provincia(pid integer);
       public       postgres    false    3    1                       1255    73873    get_provincia(integer, integer)    FUNCTION     �  CREATE FUNCTION public.get_provincia(pid integer, pidepartamento integer) RETURNS TABLE(descripcionprovincia character varying, idprovincia integer, idepartamento integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY select pr.descripcion,pr.id,pr.iddepartamento from provincia pr 
 where  pr.id=COALESCE (pid, pr.id) and pr.iddepartamento=COALESCE (pidepartamento, pr.iddepartamento)
 order by pr.id asc;
END; $$;
 I   DROP FUNCTION public.get_provincia(pid integer, pidepartamento integer);
       public       postgres    false    1    3                       1255    17000    get_tipocambio()    FUNCTION     V  CREATE FUNCTION public.get_tipocambio() RETURNS TABLE(p_idtipocambio integer, p_nombre character varying, p_principal boolean, p_simbolo character, p_valor numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN

 RETURN QUERY select tc.idtipocambio,tc.nombre,tc.principal,tc.simbolo,tc.valor
 from tipocambio tc order by tc.idtipocambio asc;
END; $$;
 '   DROP FUNCTION public.get_tipocambio();
       public       postgres    false    3    1            �            1255    17001    get_tipocambio(integer)    FUNCTION     u  CREATE FUNCTION public.get_tipocambio(pa_idtipocambio integer) RETURNS TABLE(p_idtipocambio integer, p_nombre character varying, p_principal boolean, p_simbolo character, p_valor numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY select tc.idtipocambio,tc.nombre,tc.principal,tc.simbolo,tc.valor
 from tipocambio tc where pa_idtipocambio=tc.idtipocambio;
END; $$;
 >   DROP FUNCTION public.get_tipocambio(pa_idtipocambio integer);
       public       postgres    false    1    3            �            1255    24642 1   get_usuario(character varying, character varying)    FUNCTION     y  CREATE FUNCTION public.get_usuario(par_usuario character varying, par_pass character varying) RETURNS TABLE(p_idusuario integer, p_nombre character varying, p_usuario character varying, p_tipousuario smallint)
    LANGUAGE plpgsql
    AS $$BEGIN
 RETURN QUERY select id,nombre,usuario,tipousuario from usuario
 where usuario=par_usuario and md5(par_pass)=contrasenia;
END; $$;
 ]   DROP FUNCTION public.get_usuario(par_usuario character varying, par_pass character varying);
       public       postgres    false    1    3            �            1255    24588    get_ventas02()    FUNCTION     �  CREATE FUNCTION public.get_ventas02() RETURNS TABLE(p_idcliente integer, p_nombrecompletos character varying, p_documento character varying, p_tipocliente character varying, p_serie character varying, p_fechaemision timestamp without time zone, p_impuesto numeric, p_total numeric, p_nombretipocambio character varying, p_simbolo character, p_valor numeric, pdetalle json)
    LANGUAGE plpgsql
    AS $$BEGIN
 	RETURN QUERY select  vt.idcliente,cl.nombrecompletos,cl.documento,
	cl.tipocliente,
	vt.serie,vt.fechaemision,vt.impuesto,vt.total,
	tp.nombre,tp.simbolo,tp.valor,
	(select array_to_json(array_agg(colum.*))  AS json from (select * 
	from detalleventa  as dv inner join producto pr
	on pr.idproducto=dv.idproducto 
	) as colum where colum.idventa=vt.idventa)
	from venta  as vt
	inner join cliente cl on cl.idcliente=vt.idcliente
	inner join tipocambio tp on tp.idtipocambio=vt.idtipocambio order by  vt.fechaemision desc;
END; $$;
 %   DROP FUNCTION public.get_ventas02();
       public       postgres    false    3    1            �            1255    40987    getcategorias()    FUNCTION     �   CREATE FUNCTION public.getcategorias() RETURNS TABLE(r_idcategoria integer, r_nombre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY SELECT
 id,nombre
 FROM
 categoria;
END; $$;
 &   DROP FUNCTION public.getcategorias();
       public       postgres    false    1    3            
           1255    73881    getempleados()    FUNCTION     *  CREATE FUNCTION public.getempleados() RETURNS TABLE(nombrescompletos character varying, apellidopaterno character varying, apellidomaterno character varying, direccion character varying, correo character varying, distrito integer, discripciondistrito character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY 
select e.nombrescompletos,e.apellidopaterno,
 e.apellidomaterno,e.direccion
,e.correo,e.distrito,d.descripcion discripciondistrito
from empleado e
inner join distrito d on e.distrito=d.id
where e.id=COALESCE (null,  e.id);
END; $$;
 %   DROP FUNCTION public.getempleados();
       public       postgres    false    1    3            �            1255    40980 5   iniciar_session(character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.iniciar_session(pusuario character varying, pcontrasenia character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
 DECLARE
    repuesta  integer;
BEGIN

select count(*) into repuesta from usuario where usuario=pusuario and contrasenia=md5(pcontrasenia);
if repuesta>0 then 
	return 'CONCEDIDO';
else
	return 'DENEGADO';
end if;
 RETURN 'hola';
END; 
$$;
 b   DROP FUNCTION public.iniciar_session(pusuario character varying, pcontrasenia character varying);
       public       postgres    false    1    3                       1255    73887 %   insertar_empleados(public.empleado[])    FUNCTION     �  CREATE FUNCTION public.insertar_empleados(public.empleado[]) RETURNS TABLE(estado boolean, mensaje text)
    LANGUAGE plpgsql
    AS $_$
 declare arempleado empleado;
BEGIN
  foreach arempleado in array $1
  loop 
 	insert into empleado(documento,nombrescompletos,apellidopaterno,
					 apellidomaterno,direccion,correo,distrito,fechanacimiento)
		values(arempleado.documento,arempleado.nombrescompletos,arempleado.apellidopaterno
			   ,arempleado.apellidomaterno,
					 arempleado.direccion,
			    arempleado.correo,arempleado.distrito,arempleado.fechanacimiento);
 end loop;
 RETURN QUERY select true,'inserto correctamente';
END; $_$;
 <   DROP FUNCTION public.insertar_empleados(public.empleado[]);
       public       postgres    false    215    3    1            �            1255    40983 !   obtenerusuario(character varying)    FUNCTION     7  CREATE FUNCTION public.obtenerusuario(pusuario character varying) RETURNS TABLE(usid integer, usnombre character varying, ussuario character varying, ustipousuario smallint)
    LANGUAGE plpgsql
    AS $$
BEGIN

return query select id,nombre,usuario,tipousuario from usuario where usuario=pusuario ;

END; 
$$;
 A   DROP FUNCTION public.obtenerusuario(pusuario character varying);
       public       postgres    false    1    3            �            1255    16964    p_generarcodigoventa()    FUNCTION     �   CREATE FUNCTION public.p_generarcodigoventa() RETURNS integer
    LANGUAGE plpgsql
    AS $$
 DECLARE cantidad Integer;
BEGIN
	cantidad:=(select count(*) as cantidad from venta);
return cantidad;
END; $$;
 -   DROP FUNCTION public.p_generarcodigoventa();
       public       postgres    false    1    3            �            1255    16998    p_getventa(integer)    FUNCTION     u  CREATE FUNCTION public.p_getventa(cod integer) RETURNS TABLE(p_idcliente integer, p_nombrecompletos character varying, p_documento character varying, p_tipocliente character varying, p_detalle json)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY select  vt.idcliente,cl.nombrecompletos,cl.documento,
	cl.tipocliente,
	(select array_to_json(array_agg(colum.*))  AS json from (select * 
	from detalleventa  as dv inner join producto pr
	on pr.idproducto=dv.idproducto 
	) as colum where colum.idventa=vt.idventa) as detalle
	from venta  as vt
	inner join cliente cl on cl.idcliente=vt.idcliente
	where vt.idventa=cod;
END; $$;
 .   DROP FUNCTION public.p_getventa(cod integer);
       public       postgres    false    1    3            �            1255    16996    p_getventas()    FUNCTION     h  CREATE FUNCTION public.p_getventas() RETURNS TABLE(p_idcliente integer, p_nombrecompletos character varying, p_documento character varying, p_tipocliente character varying, pdetalle json)
    LANGUAGE plpgsql
    AS $$BEGIN
	RETURN QUERY select  vt.idcliente,cl.nombrecompletos,cl.documento,
	cl.tipocliente,
	(select array_to_json(array_agg(colum.*))  AS json from (select * 
	from detalleventa  as dv inner join producto pr
	on pr.idproducto=dv.idproducto 
	) as colum where colum.idventa=vt.idventa)
	from venta  as vt
	inner join cliente cl on cl.idcliente=vt.idcliente 
	order by  vt.fechaemision asc;
END; $$;
 $   DROP FUNCTION public.p_getventas();
       public       postgres    false    1    3            �            1255    16963    p_realizarventa(text)    FUNCTION      	  CREATE FUNCTION public.p_realizarventa(venta text) RETURNS integer
    LANGUAGE plpgsql
    AS $$ DECLARE myid venta.idventa%TYPE;
 DECLARE cantidad Integer;
BEGIN
cantidad:=(select count(*) as cantidad from venta)+1;
INSERT INTO venta (serie,tipodocumento, impuesto,subtotal,total, idtipocambio, idcliente) 
SELECT 
     ((xpath('//serie/text()', myTempTable.myXmlColumn))[1]::text)
    ,(xpath('//tipodocumento/text()', myTempTable.myXmlColumn))[1]::text AS tipodocumento 
    ,CAST((xpath('//impuesto/text()', myTempTable.myXmlColumn))[1]::text AS numeric)
	,CAST((xpath('//subtotal/text()', myTempTable.myXmlColumn))[1]::text AS numeric)
    ,CAST((xpath('//total/text()', myTempTable.myXmlColumn))[1]::text AS numeric)
    ,CAST((xpath('//idtipocambio/text()', myTempTable.myXmlColumn))[1]::text AS numeric)
    ,CAST((xpath('//idcliente/text()', myTempTable.myXmlColumn))[1]::text AS integer)
FROM unnest(xpath('//venta', 
 CAST(CONCAT('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',venta) AS xml)   
)) AS myTempTable(myXmlColumn) RETURNING idventa INTO myid;


INSERT INTO detalleventa(idproducto,cantidad, costounitario,idventa) 
SELECT 
CAST((xpath('//idproducto/text()', myTempTable.myXmlColumn))[1]::text AS integer) as producto
	,CAST((xpath('//cantidad/text()', myTempTable.myXmlColumn))[1]::text AS integer)
    ,CAST((xpath('//costounitario/text()', myTempTable.myXmlColumn))[1]::text AS numeric)
	 ,myid
FROM unnest(xpath('//detalle', 
 CAST(CONCAT('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',venta)  AS xml)   
)) AS myTempTable(myXmlColumn);

UPDATE 	producto  as pa
	set 
    stock=query.nuevostock
FROM  (SELECT
 pr.stock-CAST((xpath('//cantidad/text()', myTempTable.myXmlColumn))[1]::text AS integer) as nuevostock
	,CAST((xpath('//cantidad/text()', myTempTable.myXmlColumn))[1]::text AS integer) as stock
	,CAST((xpath('//idproducto/text()', myTempTable.myXmlColumn))[1]::text AS integer) as idproducto
FROM unnest(xpath('//detalle', 
 CAST(CONCAT('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',venta)  AS xml)   
)) AS myTempTable(myXmlColumn) 
inner join producto as pr on pr.idproducto=CAST((xpath('//idproducto/text()', myTempTable.myXmlColumn))[1]::text AS integer)
	  )AS query
where pa.idproducto=query.idproducto;
 return myid;
END; $$;
 2   DROP FUNCTION public.p_realizarventa(venta text);
       public       postgres    false    1    3            �            1259    16885    detalleventa    TABLE     �   CREATE TABLE public.detalleventa (
    idproducto integer NOT NULL,
    idventa integer NOT NULL,
    cantidad integer NOT NULL,
    costounitario numeric(8,2) NOT NULL
);
     DROP TABLE public.detalleventa;
       public         postgres    false    3            	           1255    57358 s   p_realizarventa02(character varying, character, numeric, numeric, integer, integer, numeric, public.detalleventa[])    FUNCTION     �  CREATE FUNCTION public.p_realizarventa02(character varying, character, numeric, numeric, integer, integer, numeric, public.detalleventa[]) RETURNS TABLE(restado boolean, rmensaje text)
    LANGUAGE plpgsql
    AS $_$
 declare pserie alias for $1;
 declare ptipodocumento alias for $2;
 declare pimpuesto alias for $3;
 declare ptotal alias for $4; 
 declare pidtipocambio alias for $5; 
 declare pidcliente alias for $6; 
 declare psubtotal alias for $7;
 declare detalle  detalleventa;
  DECLARE myid venta.idventa%TYPE;
begin 
 insert into venta(idventa,serie,tipodocumento,impuesto,total,idtipocambio,idcliente,subtotal)
 values(default,pserie,ptipodocumento,pimpuesto,ptotal,pidtipocambio,pidcliente,psubtotal) RETURNING idventa INTO myid;
 foreach detalle in array $8
 loop 
 insert into detalleventa values(detalle.idproducto,myid,detalle.cantidad,detalle.costounitario);
 update producto set stock=stock-detalle.cantidad where idproducto=detalle.idproducto;
 end loop;
 return query select true,'insertado correctamente';
 EXCEPTION
	WHEN not_null_violation THEN
		RAISE EXCEPTION 'Todos los campos son requeridos';
	WHEN foreign_key_violation THEN
		RAISE EXCEPTION 'La institución no puede ser borrada, existen dependencias para este registro.';
	WHEN string_data_right_truncation THEN
		RAISE EXCEPTION 'Se ha superado el maximo de caracteres permitidos.';
	WHEN unique_violation THEN
		RAISE EXCEPTION 'La institución % ya existe en la base de datos.', upper(trim(in_inst_nombre));
end;
$_$;
 �   DROP FUNCTION public.p_realizarventa02(character varying, character, numeric, numeric, integer, integer, numeric, public.detalleventa[]);
       public       postgres    false    1    3    206            �            1255    16933    realizarventa()    FUNCTION       CREATE FUNCTION public.realizarventa() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
   
    vretval text;
BEGIN
	vretval:='aaaa';
    SELECT 
     (xpath('//ID/text()', myTempTable.myXmlColumn))[1]::text AS id
    ,(xpath('//Name/text()', myTempTable.myXmlColumn))[1]::text AS Name 
    ,(xpath('//RFC/text()', myTempTable.myXmlColumn))[1]::text AS RFC
    ,(xpath('//Text/text()', myTempTable.myXmlColumn))[1]::text AS Text
    ,(xpath('//Desc/text()', myTempTable.myXmlColumn))[1]::text AS Desc
    ,myTempTable.myXmlColumn as myXmlElement
FROM unnest(xpath('//record', 
 CAST('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<data-set>
    <record>
        <ID>1</ID>
        <Name>A</Name>
        <RFC>RFC 1035[1]</RFC>
        <Text>Address record</Text>
        <Desc>Returns a 32-bit IPv4 address, most commonly used to map hostnames to an IP address of the host, but it is also used for DNSBLs, storing subnet masks in RFC 1101, etc.</Desc>
    </record>
    <record>
        <ID>2</ID>
        <Name>NS</Name>
        <RFC>RFC 1035[1]</RFC>
        <Text>Name server record</Text>
        <Desc>Delegates a DNS zone to use the given authoritative name servers</Desc>
    </record>
</data-set>
' AS xml)   
)) AS myTempTable(myXmlColumn);
    RETURN vretval;
END; $$;
 &   DROP FUNCTION public.realizarventa();
       public       postgres    false    1    3            �            1255    49171 I   registrarproducto(character varying, numeric, integer, character varying)    FUNCTION     �  CREATE FUNCTION public.registrarproducto(pnombre character varying, ppreciounitario numeric, pidcategoria integer, pdescripcion character varying) RETURNS TABLE(msg text)
    LANGUAGE plpgsql
    AS $$
BEGIN
	insert into producto(nombre,stock,preciounitario,idcategoria,descripcion) values(pnombre,0,ppreciounitario,pidcategoria,pdescripcion);
	 RETURN QUERY select 'se inserto correctamente' ;

END; $$;
 �   DROP FUNCTION public.registrarproducto(pnombre character varying, ppreciounitario numeric, pidcategoria integer, pdescripcion character varying);
       public       postgres    false    1    3                       1255    81931 "   validadocumento(character varying)    FUNCTION     I  CREATE FUNCTION public.validadocumento(pdocumento character varying) RETURNS TABLE(estado boolean)
    LANGUAGE plpgsql
    AS $$
declare 
existe integer:=0;
BEGIN
 existe:=count(*) from empleado e where e.documento=pdocumento ; 
 if existe=0 then
 	 RETURN QUERY select false;
else
  RETURN QUERY select true;
 end if;
END; $$;
 D   DROP FUNCTION public.validadocumento(pdocumento character varying);
       public       postgres    false    1    3            �            1259    24591 	   categoria    TABLE     ^   CREATE TABLE public.categoria (
    id integer NOT NULL,
    nombre character varying(100)
);
    DROP TABLE public.categoria;
       public         postgres    false    3            �            1259    24589    categoria_id_seq    SEQUENCE     �   CREATE SEQUENCE public.categoria_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.categoria_id_seq;
       public       postgres    false    3    210            �           0    0    categoria_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.categoria_id_seq OWNED BY public.categoria.id;
            public       postgres    false    209            �            1259    16918    cliente    TABLE     �   CREATE TABLE public.cliente (
    idcliente integer NOT NULL,
    nombrecompletos character varying(100) NOT NULL,
    tipocliente character varying(10),
    documento character varying(12) NOT NULL,
    direccion character varying(100) NOT NULL
);
    DROP TABLE public.cliente;
       public         postgres    false    3            �            1259    16916    cliente_idcliente_seq    SEQUENCE     �   CREATE SEQUENCE public.cliente_idcliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.cliente_idcliente_seq;
       public       postgres    false    3    208            �           0    0    cliente_idcliente_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.cliente_idcliente_seq OWNED BY public.cliente.idcliente;
            public       postgres    false    207            �            1259    73766    departamento    TABLE     o   CREATE TABLE public.departamento (
    descripcion character varying(150) NOT NULL,
    id integer NOT NULL
);
     DROP TABLE public.departamento;
       public         postgres    false    3            �            1259    73823    departamento_id_seq    SEQUENCE     �   CREATE SEQUENCE public.departamento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.departamento_id_seq;
       public       postgres    false    216    3            �           0    0    departamento_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.departamento_id_seq OWNED BY public.departamento.id;
            public       postgres    false    219            �            1259    16881    detalleventa_idproducto_seq    SEQUENCE     �   CREATE SEQUENCE public.detalleventa_idproducto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.detalleventa_idproducto_seq;
       public       postgres    false    3    206            �           0    0    detalleventa_idproducto_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.detalleventa_idproducto_seq OWNED BY public.detalleventa.idproducto;
            public       postgres    false    204            �            1259    16883    detalleventa_idventa_seq    SEQUENCE     �   CREATE SEQUENCE public.detalleventa_idventa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.detalleventa_idventa_seq;
       public       postgres    false    206    3            �           0    0    detalleventa_idventa_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.detalleventa_idventa_seq OWNED BY public.detalleventa.idventa;
            public       postgres    false    205            �            1259    73816    distrito    TABLE     �   CREATE TABLE public.distrito (
    id integer NOT NULL,
    descripcion character varying(200) NOT NULL,
    idprovincia integer
);
    DROP TABLE public.distrito;
       public         postgres    false    3            �            1259    73837    distrito_id_seq    SEQUENCE     �   CREATE SEQUENCE public.distrito_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.distrito_id_seq;
       public       postgres    false    218    3            �           0    0    distrito_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.distrito_id_seq OWNED BY public.distrito.id;
            public       postgres    false    220            �            1259    73800    empleado_id_seq    SEQUENCE     �   CREATE SEQUENCE public.empleado_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.empleado_id_seq;
       public       postgres    false    215    3            �           0    0    empleado_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.empleado_id_seq OWNED BY public.empleado.id;
            public       postgres    false    217            �            1259    16854    empresa    TABLE     �   CREATE TABLE public.empresa (
    ruc character(30) NOT NULL,
    razonsocial character varying(100) NOT NULL,
    direccion character varying(100) NOT NULL
);
    DROP TABLE public.empresa;
       public         postgres    false    3            �            1259    16836    producto    TABLE       CREATE TABLE public.producto (
    idproducto integer NOT NULL,
    nombre character varying(100) NOT NULL,
    stock integer NOT NULL,
    preciounitario numeric(8,2) NOT NULL,
    idcategoria integer,
    imgproducto text,
    descripcion character varying
);
    DROP TABLE public.producto;
       public         postgres    false    3            �            1259    16834    producto_idproducto_seq    SEQUENCE     �   CREATE SEQUENCE public.producto_idproducto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.producto_idproducto_seq;
       public       postgres    false    3    197            �           0    0    producto_idproducto_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.producto_idproducto_seq OWNED BY public.producto.idproducto;
            public       postgres    false    196            �            1259    73851 	   provincia    TABLE     �   CREATE TABLE public.provincia (
    iddepartamento integer NOT NULL,
    id integer NOT NULL,
    descripcion character varying(200) NOT NULL
);
    DROP TABLE public.provincia;
       public         postgres    false    3            �            1259    73849    provincia_id_seq    SEQUENCE     �   CREATE SEQUENCE public.provincia_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.provincia_id_seq;
       public       postgres    false    3    222            �           0    0    provincia_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.provincia_id_seq OWNED BY public.provincia.id;
            public       postgres    false    221            �            1259    16846 
   tipocambio    TABLE     �   CREATE TABLE public.tipocambio (
    idtipocambio integer NOT NULL,
    nombre character varying(100) NOT NULL,
    simbolo character(3) NOT NULL,
    principal boolean NOT NULL,
    valor numeric(8,2) NOT NULL
);
    DROP TABLE public.tipocambio;
       public         postgres    false    3            �            1259    16844    tipocambio_idtipocambio_seq    SEQUENCE     �   CREATE SEQUENCE public.tipocambio_idtipocambio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.tipocambio_idtipocambio_seq;
       public       postgres    false    199    3            �           0    0    tipocambio_idtipocambio_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.tipocambio_idtipocambio_seq OWNED BY public.tipocambio.idtipocambio;
            public       postgres    false    198            �            1259    24708    users    TABLE     x  CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.users;
       public         postgres    false    3            �            1259    24706    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public       postgres    false    214    3            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
            public       postgres    false    213            �            1259    24645    usuario    TABLE     �   CREATE TABLE public.usuario (
    id integer NOT NULL,
    nombre character varying(120) NOT NULL,
    usuario character varying(120) NOT NULL,
    contrasenia character varying(200) NOT NULL,
    tipousuario smallint NOT NULL
);
    DROP TABLE public.usuario;
       public         postgres    false    3            �            1259    24643    usuario_id_seq    SEQUENCE     �   CREATE SEQUENCE public.usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.usuario_id_seq;
       public       postgres    false    212    3            �           0    0    usuario_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.usuario_id_seq OWNED BY public.usuario.id;
            public       postgres    false    211            �            1259    16863    venta    TABLE     o  CREATE TABLE public.venta (
    idventa integer NOT NULL,
    serie character varying(100) NOT NULL,
    tipodocumento character(2) NOT NULL,
    fechaemision timestamp without time zone DEFAULT now(),
    impuesto numeric(8,2) NOT NULL,
    total numeric(8,2) NOT NULL,
    idtipocambio integer NOT NULL,
    idcliente integer NOT NULL,
    subtotal numeric(8,2)
);
    DROP TABLE public.venta;
       public         postgres    false    3            �            1259    16861    venta_idtipocambio_seq    SEQUENCE     �   CREATE SEQUENCE public.venta_idtipocambio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.venta_idtipocambio_seq;
       public       postgres    false    3    203            �           0    0    venta_idtipocambio_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.venta_idtipocambio_seq OWNED BY public.venta.idtipocambio;
            public       postgres    false    202            �            1259    16859    venta_idventa_seq    SEQUENCE     �   CREATE SEQUENCE public.venta_idventa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.venta_idventa_seq;
       public       postgres    false    3    203            �           0    0    venta_idventa_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.venta_idventa_seq OWNED BY public.venta.idventa;
            public       postgres    false    201            �
           2604    24594    categoria id    DEFAULT     l   ALTER TABLE ONLY public.categoria ALTER COLUMN id SET DEFAULT nextval('public.categoria_id_seq'::regclass);
 ;   ALTER TABLE public.categoria ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    210    209    210            �
           2604    16921    cliente idcliente    DEFAULT     v   ALTER TABLE ONLY public.cliente ALTER COLUMN idcliente SET DEFAULT nextval('public.cliente_idcliente_seq'::regclass);
 @   ALTER TABLE public.cliente ALTER COLUMN idcliente DROP DEFAULT;
       public       postgres    false    208    207    208            �
           2604    73825    departamento id    DEFAULT     r   ALTER TABLE ONLY public.departamento ALTER COLUMN id SET DEFAULT nextval('public.departamento_id_seq'::regclass);
 >   ALTER TABLE public.departamento ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    219    216            �
           2604    16888    detalleventa idproducto    DEFAULT     �   ALTER TABLE ONLY public.detalleventa ALTER COLUMN idproducto SET DEFAULT nextval('public.detalleventa_idproducto_seq'::regclass);
 F   ALTER TABLE public.detalleventa ALTER COLUMN idproducto DROP DEFAULT;
       public       postgres    false    204    206    206            �
           2604    16889    detalleventa idventa    DEFAULT     |   ALTER TABLE ONLY public.detalleventa ALTER COLUMN idventa SET DEFAULT nextval('public.detalleventa_idventa_seq'::regclass);
 C   ALTER TABLE public.detalleventa ALTER COLUMN idventa DROP DEFAULT;
       public       postgres    false    206    205    206            �
           2604    73839    distrito id    DEFAULT     j   ALTER TABLE ONLY public.distrito ALTER COLUMN id SET DEFAULT nextval('public.distrito_id_seq'::regclass);
 :   ALTER TABLE public.distrito ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    220    218            �
           2604    73802    empleado id    DEFAULT     j   ALTER TABLE ONLY public.empleado ALTER COLUMN id SET DEFAULT nextval('public.empleado_id_seq'::regclass);
 :   ALTER TABLE public.empleado ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    217    215            �
           2604    16839    producto idproducto    DEFAULT     z   ALTER TABLE ONLY public.producto ALTER COLUMN idproducto SET DEFAULT nextval('public.producto_idproducto_seq'::regclass);
 B   ALTER TABLE public.producto ALTER COLUMN idproducto DROP DEFAULT;
       public       postgres    false    197    196    197            �
           2604    73854    provincia id    DEFAULT     l   ALTER TABLE ONLY public.provincia ALTER COLUMN id SET DEFAULT nextval('public.provincia_id_seq'::regclass);
 ;   ALTER TABLE public.provincia ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    222    221    222            �
           2604    16849    tipocambio idtipocambio    DEFAULT     �   ALTER TABLE ONLY public.tipocambio ALTER COLUMN idtipocambio SET DEFAULT nextval('public.tipocambio_idtipocambio_seq'::regclass);
 F   ALTER TABLE public.tipocambio ALTER COLUMN idtipocambio DROP DEFAULT;
       public       postgres    false    199    198    199            �
           2604    24711    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    213    214    214            �
           2604    24648 
   usuario id    DEFAULT     h   ALTER TABLE ONLY public.usuario ALTER COLUMN id SET DEFAULT nextval('public.usuario_id_seq'::regclass);
 9   ALTER TABLE public.usuario ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    212    211    212            �
           2604    16866    venta idventa    DEFAULT     n   ALTER TABLE ONLY public.venta ALTER COLUMN idventa SET DEFAULT nextval('public.venta_idventa_seq'::regclass);
 <   ALTER TABLE public.venta ALTER COLUMN idventa DROP DEFAULT;
       public       postgres    false    203    201    203            �
           2604    16868    venta idtipocambio    DEFAULT     x   ALTER TABLE ONLY public.venta ALTER COLUMN idtipocambio SET DEFAULT nextval('public.venta_idtipocambio_seq'::regclass);
 A   ALTER TABLE public.venta ALTER COLUMN idtipocambio DROP DEFAULT;
       public       postgres    false    202    203    203            �          0    24591 	   categoria 
   TABLE DATA               /   COPY public.categoria (id, nombre) FROM stdin;
    public       postgres    false    210   ��       �          0    16918    cliente 
   TABLE DATA               `   COPY public.cliente (idcliente, nombrecompletos, tipocliente, documento, direccion) FROM stdin;
    public       postgres    false    208   =�       �          0    73766    departamento 
   TABLE DATA               7   COPY public.departamento (descripcion, id) FROM stdin;
    public       postgres    false    216   ��       �          0    16885    detalleventa 
   TABLE DATA               T   COPY public.detalleventa (idproducto, idventa, cantidad, costounitario) FROM stdin;
    public       postgres    false    206   �       �          0    73816    distrito 
   TABLE DATA               @   COPY public.distrito (id, descripcion, idprovincia) FROM stdin;
    public       postgres    false    218   �       �          0    73755    empleado 
   TABLE DATA               �   COPY public.empleado (nombrescompletos, apellidopaterno, apellidomaterno, direccion, correo, id, distrito, fechanacimiento, documento) FROM stdin;
    public       postgres    false    215   S�       �          0    16854    empresa 
   TABLE DATA               >   COPY public.empresa (ruc, razonsocial, direccion) FROM stdin;
    public       postgres    false    200   ��       �          0    16836    producto 
   TABLE DATA               t   COPY public.producto (idproducto, nombre, stock, preciounitario, idcategoria, imgproducto, descripcion) FROM stdin;
    public       postgres    false    197   ��       �          0    73851 	   provincia 
   TABLE DATA               D   COPY public.provincia (iddepartamento, id, descripcion) FROM stdin;
    public       postgres    false    222   (      �          0    16846 
   tipocambio 
   TABLE DATA               U   COPY public.tipocambio (idtipocambio, nombre, simbolo, principal, valor) FROM stdin;
    public       postgres    false    199   [(      �          0    24708    users 
   TABLE DATA               u   COPY public.users (id, name, email, email_verified_at, password, remember_token, created_at, updated_at) FROM stdin;
    public       postgres    false    214   �(      �          0    24645    usuario 
   TABLE DATA               P   COPY public.usuario (id, nombre, usuario, contrasenia, tipousuario) FROM stdin;
    public       postgres    false    212   �)      �          0    16863    venta 
   TABLE DATA               �   COPY public.venta (idventa, serie, tipodocumento, fechaemision, impuesto, total, idtipocambio, idcliente, subtotal) FROM stdin;
    public       postgres    false    203   �)      �           0    0    categoria_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.categoria_id_seq', 4, true);
            public       postgres    false    209            �           0    0    cliente_idcliente_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.cliente_idcliente_seq', 2, true);
            public       postgres    false    207            �           0    0    departamento_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.departamento_id_seq', 4, true);
            public       postgres    false    219            �           0    0    detalleventa_idproducto_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.detalleventa_idproducto_seq', 1, false);
            public       postgres    false    204            �           0    0    detalleventa_idventa_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.detalleventa_idventa_seq', 1, false);
            public       postgres    false    205            �           0    0    distrito_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.distrito_id_seq', 4, true);
            public       postgres    false    220            �           0    0    empleado_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.empleado_id_seq', 29, true);
            public       postgres    false    217            �           0    0    producto_idproducto_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.producto_idproducto_seq', 95, true);
            public       postgres    false    196            �           0    0    provincia_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.provincia_id_seq', 3, true);
            public       postgres    false    221            �           0    0    tipocambio_idtipocambio_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.tipocambio_idtipocambio_seq', 2, true);
            public       postgres    false    198            �           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 16, true);
            public       postgres    false    213            �           0    0    usuario_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.usuario_id_seq', 5, true);
            public       postgres    false    211            �           0    0    venta_idtipocambio_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.venta_idtipocambio_seq', 1, false);
            public       postgres    false    202            �           0    0    venta_idventa_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.venta_idventa_seq', 205, true);
            public       postgres    false    201            �
           2606    24596    categoria categoria_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.categoria DROP CONSTRAINT categoria_pkey;
       public         postgres    false    210            �
           2606    16923    cliente cliente_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (idcliente);
 >   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
       public         postgres    false    208                       2606    73827    departamento departamento_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.departamento
    ADD CONSTRAINT departamento_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.departamento DROP CONSTRAINT departamento_pkey;
       public         postgres    false    216                       2606    73841    distrito distrito_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.distrito
    ADD CONSTRAINT distrito_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.distrito DROP CONSTRAINT distrito_pkey;
       public         postgres    false    218                       2606    73804    empleado empleado_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.empleado DROP CONSTRAINT empleado_pkey;
       public         postgres    false    215            �
           2606    16843    producto nombreproducto_unique 
   CONSTRAINT     [   ALTER TABLE ONLY public.producto
    ADD CONSTRAINT nombreproducto_unique UNIQUE (nombre);
 H   ALTER TABLE ONLY public.producto DROP CONSTRAINT nombreproducto_unique;
       public         postgres    false    197            �
           2606    16853 "   tipocambio nombretipocambio_unique 
   CONSTRAINT     _   ALTER TABLE ONLY public.tipocambio
    ADD CONSTRAINT nombretipocambio_unique UNIQUE (nombre);
 L   ALTER TABLE ONLY public.tipocambio DROP CONSTRAINT nombretipocambio_unique;
       public         postgres    false    199            �
           2606    16841    producto producto_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (idproducto);
 @   ALTER TABLE ONLY public.producto DROP CONSTRAINT producto_pkey;
       public         postgres    false    197                       2606    73856    provincia provincia_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.provincia
    ADD CONSTRAINT provincia_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.provincia DROP CONSTRAINT provincia_pkey;
       public         postgres    false    222            �
           2606    16858    empresa ruc_unique 
   CONSTRAINT     Q   ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT ruc_unique PRIMARY KEY (ruc);
 <   ALTER TABLE ONLY public.empresa DROP CONSTRAINT ruc_unique;
       public         postgres    false    200            �
           2606    16851    tipocambio tipocambio_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.tipocambio
    ADD CONSTRAINT tipocambio_pkey PRIMARY KEY (idtipocambio);
 D   ALTER TABLE ONLY public.tipocambio DROP CONSTRAINT tipocambio_pkey;
       public         postgres    false    199            	           2606    73891    empleado un_documento 
   CONSTRAINT     U   ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT un_documento UNIQUE (documento);
 ?   ALTER TABLE ONLY public.empleado DROP CONSTRAINT un_documento;
       public         postgres    false    215                       2606    24718    users users_email_unique 
   CONSTRAINT     T   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_unique;
       public         postgres    false    214                       2606    24716    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public         postgres    false    214            �
           2606    24650    usuario usuario_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_pkey;
       public         postgres    false    212                       2606    24652    usuario usuario_usuario_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_usuario_key UNIQUE (usuario);
 E   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_usuario_key;
       public         postgres    false    212            �
           2606    16870    venta venta_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_pkey PRIMARY KEY (idventa);
 :   ALTER TABLE ONLY public.venta DROP CONSTRAINT venta_pkey;
       public         postgres    false    203                       2606    73876    empleado fk_distrito    FK CONSTRAINT     w   ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT fk_distrito FOREIGN KEY (distrito) REFERENCES public.distrito(id);
 >   ALTER TABLE ONLY public.empleado DROP CONSTRAINT fk_distrito;
       public       postgres    false    2829    215    218                       2606    24610    producto fk_idcategoria    FK CONSTRAINT     ~   ALTER TABLE ONLY public.producto
    ADD CONSTRAINT fk_idcategoria FOREIGN KEY (idcategoria) REFERENCES public.categoria(id);
 A   ALTER TABLE ONLY public.producto DROP CONSTRAINT fk_idcategoria;
       public       postgres    false    210    197    2813                       2606    16924    venta fk_idcliente    FK CONSTRAINT     |   ALTER TABLE ONLY public.venta
    ADD CONSTRAINT fk_idcliente FOREIGN KEY (idcliente) REFERENCES public.cliente(idcliente);
 <   ALTER TABLE ONLY public.venta DROP CONSTRAINT fk_idcliente;
       public       postgres    false    2811    208    203                       2606    73857    provincia fk_iddepartamento    FK CONSTRAINT     �   ALTER TABLE ONLY public.provincia
    ADD CONSTRAINT fk_iddepartamento FOREIGN KEY (iddepartamento) REFERENCES public.departamento(id);
 E   ALTER TABLE ONLY public.provincia DROP CONSTRAINT fk_iddepartamento;
       public       postgres    false    216    2827    222                       2606    16890    detalleventa fk_idproducto    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalleventa
    ADD CONSTRAINT fk_idproducto FOREIGN KEY (idproducto) REFERENCES public.producto(idproducto);
 D   ALTER TABLE ONLY public.detalleventa DROP CONSTRAINT fk_idproducto;
       public       postgres    false    2801    197    206                       2606    73862    distrito fk_idprovincia    FK CONSTRAINT     ~   ALTER TABLE ONLY public.distrito
    ADD CONSTRAINT fk_idprovincia FOREIGN KEY (idprovincia) REFERENCES public.provincia(id);
 A   ALTER TABLE ONLY public.distrito DROP CONSTRAINT fk_idprovincia;
       public       postgres    false    222    218    2831                       2606    16871    venta fk_idtipocambio    FK CONSTRAINT     �   ALTER TABLE ONLY public.venta
    ADD CONSTRAINT fk_idtipocambio FOREIGN KEY (idtipocambio) REFERENCES public.tipocambio(idtipocambio);
 ?   ALTER TABLE ONLY public.venta DROP CONSTRAINT fk_idtipocambio;
       public       postgres    false    2805    203    199                       2606    16876    venta fk_idventa    FK CONSTRAINT     t   ALTER TABLE ONLY public.venta
    ADD CONSTRAINT fk_idventa FOREIGN KEY (idventa) REFERENCES public.venta(idventa);
 :   ALTER TABLE ONLY public.venta DROP CONSTRAINT fk_idventa;
       public       postgres    false    203    203    2809                       2606    16895    detalleventa fk_idventa    FK CONSTRAINT     {   ALTER TABLE ONLY public.detalleventa
    ADD CONSTRAINT fk_idventa FOREIGN KEY (idventa) REFERENCES public.venta(idventa);
 A   ALTER TABLE ONLY public.detalleventa DROP CONSTRAINT fk_idventa;
       public       postgres    false    206    2809    203            �   =   x�3�L,*�L.��WHIUHN,N�2�LO,N�/N,�22srRK�LβԢ�ҢD�=... �_      �   �   x�̽
�@ �9�w����1J���)��K)�Pq��[�o�<��Ì��~.ӊ�a�
�����z��=T��nE��jcAO���8�9#��U0��$�I��1x�MM':v�b�e+�p�?�{����!�      �   2   x�	�ur�4�
�r�4��q�ur�tu�4����u�4����� ��	      �   �   x�U�Ar!е�л����ǤQVS��?45T�z�f�\���j[+�����)�I�	����7�S##d��;g��L�F-�&j��"�k����"h�	8��;B�����b�a1Z����V����^;> 	�#?#�b^�sKmsT���/K��c�]�����`��=�$i�%�2Ň�}����_iO������I�����&Y�J�]B֓(i$q��Z�Ay_      �   ?   x�3���vU�q��sr�W�
��4�2�t��t�q��rL8}�<�C��<��=... ���      �   V  x���QO� ǟ�O��R(xs&��������mӖ�7�٧�h�uO8��?w\��:�][���u�wڻ���t>kJ�����~k]��v��A�HS�p����ԙ�LJ	�%%J�.,�N�Tќ`mY})D��X��3	���`�s�U�I�5��zh��m��v<�5dgJ�Zc��sV{,���/q��S�+�Q�W)���!� F�Ό21��
nm���3F����aQ0!�񜞏q��1�EAQ�C�Đy�t�H�&4`Z���4gpxM��=������ �Y,���Z���[m�����S����Բ�?Nby"�
��,���.ii���c��-��      �   5   x�340431�40��P��%��y)�
�%��E�ŉ�7�+�q��qqq �}j      �      x����ҳڒ-x����7}E��D_t��	Qu��{��<AG�y��[�jmS���I�0�I2g��1@A�*�6����E��_ȯ�~-X���.?��H�W_E��D���Z�?=�E�X�?���/�$���D?߿�Яq��a�ә��s �?�?��R��R����o$���[K]�8��X.(����o$�쏰��ߝ������D�sT����蟽C���7���a����������9�+��e9��o��|��\�l������7��=��/�x�c�c����x����H���o�ǌ �?��̟�o�t����������#
�9����Z�U�o��o��l�����/�W�8�c�s?�c�^���3�Ӗ����j����S�ײTKU-Q�{_x����p�B,�ϰ�Y�ns�����vCZ�U��oЯ.[�_ؿ�C�wU�Q����O{v���ʶ���8���?k�A����/��y�'���?ڢ�߷��ڑ_Kն�g�/����bK��P���?��������������?�����������#�(���`�O���GG���Fп4��v�oڟ$�{�gn�l^�_(�F�r%��L��B�}���WZ4i]4���i��?�@=(�G?�iWȯ�%zȿ� �	!�I5��(E���'S�s����دu�5�E�����[-���/�~�4���P2������|���U�����kN=!�]��iË�U=�w	%p�=ے�$��2����,=*o�L=n�|Y��YQ~Q�=h�9	�|x��pL�����o#���b��̖�ŕ��)�s(&	��y��^0�J��V2�D��Az/��v�?��������ϔ�������E���[0~!���hZ4�j���C3O#�������C�����~=����Ї�fh�c��Ϗ]�����|��%�Ô�|�*1�W��������:�pH�V%�(����&�����ͤ����7��tB������ۦ��uȻ]�c�k`�H&�x�>�<dbLV�Yn;fANՀ[�8e�M�BX�:g���s��+�-��]h�8�Kt3,�{\�'2Wn��a�Uc����<c�2�������������<>�wz�nk2�S�����!�?�X�̛1�MğǷ�UH98O����I�]J���c�l�V'�n���qy,%���}�k� 6۰K���Tp�)�lxBQ����j��V���n��Q����i��U�����mQ�S�����kUlH�=��CxSjL�;�G|���h�`�|{~�%i`�dY������߶
&R!&A����q9a�EB��DL83H:�("��T�E+�ML�H߶~��U�'�d��Z�9�c�H
N!��v�<=ϖ,"����i��u�`Ѥ޽�^�Ĳ�)C��8t�z�D��"����)C�};���"�k�p�B�,f����m(��(J������so��@@���B���[�Co�MҎy�U�`,|�,^����!�uZ
�_�X�h�����2f����5����x���׬��Oՙ�	Q��m�B�ܕH��)�!#��x�Ѭ�����gy�"Z}Y�<؞��X�l��t��ջ��1٪N�ܿ�����Y�.�r�f���ݛ� ���%�Z5�ᣌ�X'�i�[��t����4i&�J,�������lӸ��MՒd���d��6	�k.yt����&5YdM�ij��]��,r�x�L��愁�2^j�Eb)�l�x=BLuS����f����4"}��в��w���߽��!x�f���\d	œ���R��kou�x��Ry��(�i2,�� {�Jܺ
�o����Y`��� Q�7�R�������(����T�@�* �Z��6M[��<a5��h�4�/�</�㣿����;���s�����ٞ����zY�X���¦|3_�i���>�8Jf�}d6D���t2=W�&�9��$!�뻤�$-s���"�ðQ�v��M/�����Ur��7nLzl�Zˇ�^�j9��_����7��[���J	�d!t���A�ƫ�q�6=��� :�f۳�@���6	�Ȗ懀��^:NI�}�us���x:>�4�'��J�܂
��(�h�I~kCa�k Y$ea��m��)�Ȇ���w�G�1�g?-IS�,��s�Q���6�H6�|0?=�6F�����mm�J�9eS��n~ �!�C���ԕa��Hy���&�r0x��,(:��L��k�~g�Ic%3��Jc+S]��]A���,4/� =�qQ�R���"jX*Q���*�N��Cސ�j���k�4t�<S�z@=+�*\=4C��97%T�r4V�������H�'�����#�AQ��~����F�t[F�y�ۢD��/k��Ĵ`�;���8���ύR�5�&9��^��&�V�q`*}r�g��c_3v���kYzK%Q���l)�%.Ȅ����ĕ,#$��_7|��S3eQ%�	v.������֩�u>BޒaE�������}=q'x�FKa����I�l����9iX�ھ�?� ���}�l��Α:�x!�U
w��j�D�]�|��Zm���j�q���,��L0�[�j}��ȴ��7��[�v\0g��}>��qQ�r/�p�rV�K��d�Ϟ]����}�I��|������u���g}���۲X�$'H�&y��Tw�dq'o���O,(���o���3rV��P&@�yv����bx�O�̀�w�h.͓E�R��	_Zj�עn���~��si�P k��+/\�ϫv��& �滅�Mֹ���{�O�u�O�a���u�F0�Z�$��/<�a��Jm�*߰Jg���[3�;���mjG�x�0E�>��<���"N0}�ʫ-h"��sxJziZ���,)D�a�ׂ�z�UK�ZJ�m�Z���3��#�AJ��lФ~�Z/��e���p���d���R.�j����h'R�Ýp�2�91�zN�
V�0Uخ�z�b��۷{]�<�M�RY�\|'���ޏ�k���Zwӎx-V�;���0���\O�g�����F��5�0X�y�5}?$�,�]���L+�@� �l�(=x}����^e�.6����}��3���d<�S'����4�譓�zېw�)����l�c�<hH��A�a�/E����ˆ�	��v�Ѿʅs�<��[�cs}���c����X������N��eDxxQYbL2�S3O�NV~��aHXuI�%��@�'��S2�v�[� �gb��D�ue�~��o�b���0��F6G�2y���M`��&����}�ۜ!����z�=�6G��I���+-[4w>���mKU���M�{�b�	���μ�'}_� eUƽ��>���e�*��R��B��-f]ݦ��9;gsJ�������Wա9<��J���0`s\m�j�u�~LIP���$8��Ɵ"qɵ"9�����14��a�f=ޙ��a5b���=�S�y(�*��${��܊q1e����?�`�U����'޶zU���Ѷ��)H��)qc8��!���>�b،�Zխ΍���#7Լ*�L��Ŧ���PY	h�.�Y.��4����T�n[��l�d
(}��BR��`-���dS��/��|iN���9�~?m�F��ҡ�?�������b�9�Ad�_�?���n�N�o�ߝ��䓮op)���Fm�	��	q����:��.UE'[�o�ҫ[���[�Q1�C��h�P���|�c}�{'���'�\�������@ә&���m���ݞɿ�+�'��-��o\�3���M��RT�4/y5�K��YTC�W2W����Q���=&c����D�&���cJ���HQ�Ss��"��D���C����--^�&O�	��h�i���v���xѪ�3 Pb<�_t���<~�΂�ԭ!�f=���^��xm����Dy��I��d~Q�*uvM�j�̉��:/<ږ��2<kN)>�/��f��W�C���ԡp#�`�%�%�Q�h�[�OnXCnoԿ	��*��}���    �Z�S-�5��τ�~��e���ӫM�?��{�8�l+��P�NBO�eL g�"�(��W�-^��n��Q�9�f��c懎�QU`�u��xht?���.
p��Rj`Y.V�C�ҭ����a1Y�;~��/E1��n�ͱ��:E�B����D�,
�'DԴ}d3���%�q���
������)Q0��dpƯܦ| ��D�8S%�Y�F�c��1��zԺ}�#�B��!�r�ZO�q!�H��O	1��֎�Z���&�e����lQ��*���E�d+�0����O_G��\����G�~"��<�kS��,_a�Ѧaaa�N/Hsv�8l�߸�6�Dn����2�7�^_��H����/"{��)�M��ќ�Y0ըl{D2EL�䇛2����9����>vP[
q��(M�8:|}"`ߞ�H�@B�,��Z�
��C�1O��+�t�/B�Lt�����x��_�]�!���x]�~��)�;\�U��yB��KT�=�0�1Ơ�m��/�M�yx�ӑ�i�d���CO�6L��o�A(A�2��{]�K�(W`��;�i�n"$%�"
	����L�F
'�'�eN�ʄ��dM �-�O�RD,wfn����	�j7� �Y�ٺ�6zC�b�ۯ����2C���l��,�l��?u��9�N|��P��D��\�	��\2��$�l�Đ�~\�x&�uτE�p�ʚ%luB&��H|��!��ſ��oh�Y5M�;��D��[F{x��nW��b\��%,��<���qQ��@[���<Ll����=�ԉ����)=�!��\1���������]ӛ�>��Wn,Ù���x�mP�0�[ၡ���h�fPM�*@��=��n܃�7̩`���I�y[�܏����<mK��+���o$�#N۲��v�)�{/՛G������
%U]׼�j^r�\YĲ�sv\���X�=��z�Qcf_��H�!6Kd���H5B��&ޭ�1B���e���wLK7��}SQ�Z7�)���$��^s��r��H���w{�W*ќ�c2�.��5c&�Jb��)v��] 葒�o} L�R�o�U�B�,5� 5}��&>��y�O�9��<�[ת�x�/��>��f�@��N7J,�ອ;VQz�y�,2R-��(m��u��%�)�Y)I�6��P�'�6��dS�(��\l|��ض�磇'�~=�_`�����E�3���܄��Z磼�KQ�@`��q�ShF�#�����:�������D0�nԡ.Г���w{Bc(6�1��� ��g�=I��V���o�%�������l#�1X���g��¢�n`ʋ����6s�i+�8���y+��@a�v�~m�6!� ��m�6*�ƤW�v�t���)Qp~������X&h�l����4��W.���a�H��ˮ˃��n[�U�7�LՏ��4Y(^j��%w�,���.���7ϴy'D�=ĺ�%�Sz��Ǯ�;�Uq��*�&Y�P��A��˫5Ɇ~e�j"E����2��Bb9��h���d���󓛷	�8�[jz��^AB��]�b:� l��������&C�{Dx�JK=
ϧ�F�A�X��f�w|��E��|�>�&��8��'�H:�R�'����Bݩu)h�%��tb�5�&���B�w2��6XN�>�᧧?ný&I]-�)���|����^8����>x��"=�v�LY� ������W+=��.5y��Q������c�@���))B"��:!��$[�=�K_#jN�&В��&DϞ�gÀ6�����)N%|� �edp/QZ���:׍x�~��iCZ�)T�Y���#��a�*����Įӝ�u�ᬚ��|jj���͌�p��m��dؔ�ߊaƦ���Z���G��8�����o�}g럅�_�����7߄X:[V����^i��7��R��}{�V%�4����!�%Z$!F�k�v�b73kJ&+H~����zBB��q~׆=�6�@�6��[1�fCc_:����&Q����������@r%�����zx����"p#�^:PR�8tB�z�9��.ܨ�nh־&hj�u߸�]��v���[�׻��D��ÎՖ�ᛣ&*:�����q6�S�%���@���/:vZ�K���T#��醌����);��� -D�]W���$v��I�AM7��M��9/�pqhU�- ~-���Lo�UP��2�L;�̼hS��eq��D�*e��4�(����FaKj� )�(��m������O6�[s������ƒ�F�d�i^Y���b��jW5����J��^*	P��h��ܫ)tV��a�x���we�.Sc�i;�tK�\R��}`�ǜ����x_�?Y#'�_�����>Tv��n%���b��]��%To=��mdv6�<����y�e���ЂW��'{?4*>�Q��u˚甽���}ߋ=�����I�3���1��^���4��fab����FN]�}�#N,����G��Z�-Q1,]�E]m��G�;�w�����t��ʓأ�݊�����lx�bԼ���h�c~�K_�q�%Hӣ+�yu����n�ŞT*0�4�y\�ƃ�"xi�uM��dY�99'����PĴ�'�ۍ�����-�����g]��hΦ8�,ވ9G�~�K�c�=��6m�~��I@p_L����WPW���B���{"!庄��a��B~�Z�y���8�Z�)~<�* �4�!�(�f/�t哬�!-,�u�F,�Z�`�}l���d`���G�1���u�G�{u#��JI�$ 7���䀶��H�JHl��J�K�	�� ���}^\� ޮ#$I2q<����"w;?msAdk�x��׮��D�b��&,�e�<�]L�k8w����})���1�y�F�N���̆q�i����pJ ������<z�~��G(ʲL��=�k�����]���*�"��VU0����?�1jɈ�;])܆:qME�� ���T=|2޺SC���'�M,F1h�G���Y�����q:�=E�ه͘ec�P�v\{�ޥ��[�����$���cY�~�����iVn
n��T�a{���^���f?���JUiB���&�w�?��=�G}�0>�ס����e�~k��oQ���v��v�up��f!~��+�^[���w��#�{I~H�9�[^n�-8�x�Z.��k2'&�a~�GM�����!�G�G��q>��gI�#AGnM͹I҇�ԧB��0~�Kk�͢�b ��E���-�c��'e���I�����\���2�� �G�{X$��*�<Z�f"'4wTp�u�=���i���냆��0q7?��;,��K��8tk4�7�R����?,qi%d���h�AE�:u��aoJ�C|{��w'��o�.���C����9�߄�+��2D�Iȗ�����$2���~Oo?�;�-�k��='�3Ǹ5E�孷q�"b:Y���RJ_�i2M�e
�}�[SR_u�)V�ub#M��.��t������isQf M[bh�-�	7��`w�xM������Q������g�y���'�N����%k����N-�=��Q��>/ޠ�A�:�uY��n$WcbH��0;f�n��z�0�o"�v�Xc��&^r $�<���S�`@���A�^pR]�{ܨͿ�20oSܸ­����X*G�k�y��F%����WFa��TD�I��P�8A�l_��1��J�	/(����;�(�몋�|/;��p(z����\(`Y����m#���e���:'���5��<	�����Ul��n�ǰOy��j�@B/���L>DY�͟���	��f%]n��$/���}�ut�|n��9��'�9�?J�I?�ӰK�KJr_9�aD�T�w��B٦�=E��:�X�J��l���Zw�W��)Ȯ͂Eg rJ6�]�H0��Q �2��SdF�#�I�;y�E�Q��� #��	�ex�P��}��.�}L��[��|}`����l-yt ��p���=ɕ�ĒA�	E��dY��$p���v��    �|�s����u}k�Zf�=�%期9h�^�ߖ���=����k��?a���B��%�z/R��cL�K��j��b \Dq���mJ�þ#��H-FF��\q.(G����C���D���]�%_���mb�u~4�[O��ql>Cl���)��m����/�$@*�8�c��k���3I�_ק��Lc_���f}���V�rL5^4�<�u�=�:�z��]S��ґ��HJ����g�s�*��Z�~�C�4R�-Ђ��N=��,r[z�g?:f�W��:��ʓ ���Tj�8�n�ێ�M�,�jPJSmf��7y�{�ߐ�ݝ��~f�.�> Cw��+��Pd��ϯ��P�l
^�,��N=QkvMɋH�ؒ^E�H,7�!�"�Ö���x��XwڳZ�\tÍf4�ܮ����nǟ"�WKn��~9����X�����WG�#q�0Y7(��F!��.�$��݀�Y5��}�đ:7e����J6Ct;[� �x_^e����Fw/vAB� �]��;�"�)̷�%Id^���G�/G��d4O��l\�k�+��:_�	(��G�[����L;���,P���|����U���`��"��H��ƛv>q�
*52�`Чo{����P���2qt��c����@��{2�h�A	��:�	�>�C��$�kF�[�^� -
��^�w���`�z���i�����0;��;�&�P�kD�*N�(��r��@,�OMh.f��t����v�����>�.���ħ
65���=}?�Y��&��T ����Wn��R�duH�&W{�,X� ��s�� g��ePZ��ڿw��C�`E�N>=�@� E������V_��1�%yH�kƅw0j?�8Ԁ�8��]�ZUˤҍ���:F����#��F����/F�w�Ò)�<���0ו��-�]~�HEĬ�^�&��Sn���&��N�w��aE÷)]TТ��Tӿ%��G��z����l�ލ`����KY��)>�����A�Co�<�~0��'v��+3W�vQzzΚ�eM��FK�U�\~͕��*α���{�~1�kX�������iS^�G�r��C�e�ٵ~M��)TX��O�~�:�s3Ck
J�1}���5����m���	����kO�
������<u�`D������?�>���8�9�P:d��������S�>���Y�.8)��m�I`H���'zӒ���IR�ԜWñp�	A�8��H�A�G'���2�R���K����W�����Y��,��5�c_°�\W`3�L� a	��(\� �j�`�����9U7
��G������6[�����yX3�0�ae����^5��r�c�ekI�]B�B6%9��v[����a;)]�8�`Dn�!�*����S���ߊ���#H���O-�L�Y�Mevk�J�L%w5�q��u�v�8��h*�vҪ�g�+Ȩ̸���Dºtb����q��Y=���FC�� ���.ᵓ�v��^-�-�5�-����O����GLْR.}�m���I���V\zT�9~߉�@��Ϸ/�!$� ,!�J_nt2��<??�,޶�6P�>oB|t�f�yD���WBA��.Q|QÍY�3ל~�, ����ƕ�#�։��q��,�#w�I�Aѻ�h�T�A�/��(e�y���{��"/q7�:��3y?|�,!f-�SHn���_-�@��:Z{��/�� �~�! ���ņ� w��8��z �i�|Ͱ��q�N^FT~�*�����K�;�5�"D1v�ƨ�5����I3P�Rʊ|A�y�&���k��,�n���(������{ǖ�}=����~���z�l�޻�kN�	���|g�훤'd��{��e�g��e��T;��P�����.���F�h�T�`���V���m糩�d>�ޣ�����g/��<^Ny8�Td�#�(����h����I�&Z�hA���޾� *u)Rp�-�H����EM������p7�Z�Yc�]
CQ/v#jp6�'�#=)�z�AѰ���VNT���v\+���J�⮥y��.���k���	�����@�fR=����،2 ����8��2m�A>�dr�0�D��ϊ9���3����Ԇ��xj]��� �ש���Ş���s_��L���n窄I�IxMk�?�pI�+�dӁu��X�B]/a��*�i��p�y�Щ��c���,��u,�ֳ��!_b��#§�o��0��5�A�072��R�����D�o���A��Q�=�l��$΀bc��Pb���IX
Z�4�OKU�!b��ݥ~���;F�I��`"��4�F;����!ޕ3v�G�U�&�5P5s[#��:�۲R2���	��cj*l���!j�ETh�h���$�.7�C�T��Y��|���[@�̈��]l��A�=�Q�S��am�M�l�=��	�d)��W��c���l�VY[f��! �&��n��	�J�l���b�k��
�e�+�pK��(�p�; ]���8�'	q�jr��w�Y��U�B0v�:^�aV޾&�C��d[�� c&O�h����ۍ����-��	L,�.���P�z7��PRiu��*�2!��4�6�{��(����#
^����v(�.j5.��2��CO�}�����u��^Ue�FY����y0����H�t�#s���N"ڹl��P��Xؽ/������'N}�J)��!N6�^{]���|��u%h�//���ڨ��D>;�h�m��6�HW�Plz,�6���߶�l�;��q�Q�G�N���Y��KE�B 2R[KE����g��'Hl�mJ+��N2A�&XGEN��?)/�S�L`?\_��N&���8���HhÅ�Ӕ�:uH��gf��~��h׵�}�Y�_�������v��i	hq��%�R����lVj�T���fe�h�4��|���!��pL��׎MB�/�=_���	��詖��ӄ�o�*�B�b�'���7��!y���-�N�q�e1OS��b�ů�%9��4��LG<uT�{����V����#y�,�2��o�����#��0�f �����ս�֎�>��c���Ć�xY}�0������|�y�u<6�i%��чh��U�w�I�����	i.O>�[��\@" /�y��,D��&�VS�X���x���О��
��}{	�Eϙ���}�S8��U4�k��:�O1'���^�~��S�QU�z���H�8(%د��%4��[|��������M�;G�i,F���o,|)D�~0(�M���5D��2x��@Z��_m��+�f���J\z�S����*�9�u�8w>���bg!_��^;Q�1.���%_�>����sW�i=���^"e��C���(T��7=a��;d<���
���ey�7f��@�qE�@A��� ŉl�ΐ}��������2?�@G{��C���"d��ׇ��&�o��$�z��M���@$JV�k���˨.C�%4����k&C�[��gJI�e3����C�s�kA_։��U<����z%+�1��i胅NW�=Li���(A��^�l��A<{�̺9یf��\��O�VN��b
k0���j�ic0HEs��¤�����Ha]u����7b��3:�1t=��x�����m�����ʹ�j���P~u����FbYX�I1��N-���E�xC}��q��d�8��Mx�*���jI��iZ�BKH��#3g��U�C6��J��(�Ф��^ÃE�Y�3�Y��<ו���a���﵋}"�r���\�u��Z��G�Ũ��s_��l�c:�cNBE�x$]�n����}A��^���u]����T�as()[�ԉC#��L,5�2�s.�ec�ģw�r��I��y�>Ik��
�p�A(ʧ߃�~�_�ALi�+��8��3���F��d���ߛa����� �I�M瀋ba�,Q9���cZ����$�EX#�C�=Z�ʳ�[�u��\|4��~�n�4���~t�c���d��=y����p���_���T��O,�^.b�4i=L泥'���䓭Ϡ    I�{�>NevǺ`��Y�E$�PHRֵ��|�vq_<�K�'�M�7����+�y|�,&����;�vclj��p6�o�۲t�Կy8ӂpk��F���Ϝ��K\�y˫d:mx�wvY��<�{���!m�5 :9���q;�&��4a�5@�@��6jON=�Q�+�W���!:=�o,�p�uXO�Y�y�2}�*j�s{^/�+�T��a�-o�4��H�[�����*e7��jxMd�3m���տц�Y�*���gO�l���0��lPKZщǧ��y=3?A��i%˂t�\�,��p;��[H��m������Y��gjw�I(Bl�⽇�n0���ܧ�B��ä��UL�� ,L��[[ߟ�nm���[U�m�5<���6gxkDM�7��ȍ���&k$I�꜕}�CGg��Lk�Z�p�ȶ���f�Ygr��3@��/�aw=l�r(��þ�}?��O`?����m��ת��O"*��e�*�)�Zxb�.[�ˈ�Ƃd6
��ڋ��D젒�n�;yJL���M�[`qQ-I> ���Hzw
��|���� eI���u���y^�"r�cc]��kW��̵sV%q��)L�,+N.zJ�Pw������ �"}�.�`�@O$ԋ68�Jp5�B���/�L��������:��/X��F��5igH7���P��`ڭ��8{�s�ll���ͧa��z��ތ8�|��m���{�vnT=��p����\�bx��,�h���i�Bv"U*��<�l=cf�&����T�g�ﾎ�g^�7��+�.���oX�'8���,�DF�Bh:���F�C����řa*x���SS,�JDbʿP>����L��|�oG�?P8�����K�gZzTA��p��&W@vL(����UK��s�q���4r��O�4�+ pMĲ����"i�v��}�� ��]�^���a?�[�&8v�� ��@N�_l�n� ��a{��\u�V�� SZ%���ɬ'Û^��	g_��,Mi��|NP����Q�Xj�7�R��C1c�Nw�y��o7M�G}�r�n��.RӋ�Hlغ��#�l�} �gQ{���=��r�0��"�<�cg����5�R����k���@��GK���4���WI]1��:�$d�\k}��DCǌ���b�2�H����V20�b��N� ��9C��� f����O�QZ��A� �qCkgb��c��3mt��hQ>�CfPp_�l�bg���X���J�堹Qh9|]�cޭe���| �d3�����b?w��ԑC�q5��� -�������6�]�͜�����w�}y�9��|)�Z0�rƧ������@	f1� ��Qx��yWn�L�-��q��c��^��I'/Y8����#��x��[%i�7*�� Ġ��<ha��v�����XQ J��A����:�H�� �큾O�%�C�N�Q)�⭗>�VjZ�N1�a�@Zu2�y�@��6��t�E^��p����lx�׃u��p\8�S�j"ӑ�\�UK]+�O�ׁ�x��͉�EsL�-y�z[�^����X�)x�~2��<y]Z��4-��&�4��NVw������>i��f�m�oK��M(��� �@M�L��B��aHe#�R=�!�A�̂Ň�Z�z�p�9�i�=B��q�T�����6)�G�]���6'Pgд��g�y4�
�E.G��+�����3����z��V����ls��������`ǰ,�{n�;.��@���k�,j�=�g�p5?	��CY�ۮ��ؗ�o%~*��o`ibO*,뷨�����^L
���	��]]1�-h
�ffZ|YMn�SV;n�m���ؕ��������9��ӑ9:P2��v�&&5��v+=��d���N��(�u��LYj���`�̰7�.Oyc�j�:k�Vwk/u��`�0ݵ֙Y���Y�_2	!؟�稝�j���b�3���i�1����Z��ξ`��"T�Ҙ�������M	��9"�~�RZ�v'd�m�M��[Rh�^)�-��e�Q��H.桲	�X�L��r{�,HF����|� a٤�}^�2������.+ү��ZkZ����ㄟ���~�~��~{h�������`H����|@rp�&���;�&J������A������<m;OQ0~AG!f�	�N)G+`oR�������Kp�P��w��N�a����[Mm��m�MWB|ݴ�(P�����_1����7����෡q��$6b��:2k�� w��J��So� ������їkХ�{Rh�����M��1��ݰ�w�	�	�ܦ��x9��61�7?"�z��W�Ҙ?=������쨘�֩��wf~0�<��T�]L|��?����>Ѹ|��m��ϱ�Y�ļ�B�m��]���MQ�~�z���������} �A;Nt�P�j��8��!�yxQ�hfq�o?u���/F��t�og]���ֿV�=Ps�ڥ �O�ɠ���KE���	�V�V(�-2����s��۰�H���|�11�^x��آ�%��Y��a���%UW��*�����Z�,O�~Ͻ�ֆ	��l���gS`#�k���둡��x�1 �ʟUO���v��9\
��A�,Yd���8k��>�덒t�!1^�ʀC�������q�`��T�Ug�Ȇ��YA�*ש^I�)�J�xWBM�����ؓ1�����������S�5M�j�y����b�d\�O{�.ޥ>T$z��4p�C�a�e���]��*
���{4R �SX��ݍ!a�]Dt�ޮvӔ��AG��������>sY����TԄ�g�}Ys`��뵹���9 y]Wī�yo�,$��Q�F�y[��'.�,�� ?%;CI${��M���2G����+�P�{�f��Pt��t!K�2γ�az�<i[_���s�9��ٟ'�.n<�����*��ZD� �LYRFVd�,���[<�m�mdQ����/\/�� ]��C&J�y�ʪ����� ��Q'�c�~]\0��۷�3\�l1���?sw
j$-��}�E��c]�.��]�Hg�&�qI����߭RXp�Q�f��{-���B�#�ʧ��3�\=J������w������1�?TiʪB�PP���c\�5�>M3�)x&�Ho�a���H��_�	����;G�A�~/w1&3�d�H���E��)&{�zq"���xWnۭ-HZl R�O0�<��1 ���[�(�E��Eۅ�8O���9�����ǈ�y<����m,�d�q�؜#��@wr����㞺�t������2S�3�?�e�m=��+��y��p��7��8��ǉZ��ڽ���gs#�g֨d���],��� a�M��赙�x����!T�������Gh{���U�^D����aqn_���b�K��Xĸ�r��ӱI8jZ��Oy׻�}	 �#��Ĝ�57�'��׮Z:��/��{�6�����q�d"<����v�q�_��i�	f�[d��̖[�������{�/����ߗj��@��0:�G��L�_�wr�4P���0�F��۬AX�⨜��9�3��e`XSWߍ��n�;�U���6Sup�����v���w�A4��-�N���(u�}�z����-���$XEj6lA#� X�`^7BB$�n��oc� �X��Y`���F���I�k���z�PC���J<\���`�cޙ�9�щ��k�V�����e�w�V3lA�Đo�Q��콥dO�r�_��p�'9��ҙ���s+H�O�e�a�ي�|��>����<��\��^�`����X��~��?�q1���q^T��_]�'s����fߊ&^���ŵ��8(��	����
�O���jT��]�w��~��Z4@���af�S��'$.7�o��{q�xF�����9��N���3t�}��ޔ��^1)�R��Rɧ\�w�O!�v��A����]��W����-E�X�m�	RiB��_�p|�;�	$�/�&�n�$�kcD�@��,    �6z�4�9k��ZvF��MV=3�["�A��C!�o)ZO�C�d/8���YY�H�,͈�Uƌ�)��bÉ�%w�SsUv�����@�[�C��w|;�X��ֳs<�4�YZH0A6��j���Q��-����������=�k6��sC�edH7Z"��и��#�)5Iҫ��ɉ5�d����Q�� �z?�dd"֘fn��!o+�#kI-�p���Y��l{��8�+*a��Ψ2�\'+�i쥔*g����7Ȣ�diU�2a�_X�;w���$$8��r�����D�l��@g̲o�����_�W�
��̱4¹��sa`*2h=۠OBeUO͖��$�QIO����9��^��Av���q	�-�6z�f��;F� AL��d���q�|�f6o�-�!��p�W8���]�l&/I����Y�D#$���<��?!�s���T�D8	�Ν6~M��3�I�C{�f3m_~ �йY�4�c_O+����I����+!���e�,��p��
�v���ZQ���0ԋ_�Րd��x~j���)U�L�[UL%�}ҟ���m8F\4�1�.˶,AyT�;S4״�i�� U���pd�vmAS }�W��Ț���פ���'�P�z+�Ձy�`� t	6��u9���m��c�g�<��o���=���� �*3�kh�yG}�o�vJ�p�󮻘I�l�>B���F�[W�5����m�����G�T�v�6fJ�������jj �E;���6��$:N77i �T�����N̤r�f�NO�Uz8yM��vZtu�uO/SeBg�^\�[8K���	�w�"�E~��,G��
��V"C�p�u�|�i�o�@�"�T��O\��܉l�)��A��B�Y/����x;��ހd��w��Go�u�Y��1��1��M�k�g��Fz��*7�m�i�z�9��*��i9�L�l�A���cg�f�.�K���lJ�,�v֗&�H�-���?q bC�a��*���J�ق8�&C@��Fѝ�,؁�3OG+��r=U�(�eni��Z�=@y��Q,^�tн�j1=��'��G��[+޹�	�%n�7��m�y%Z�Y�os��8��̔���7	{GΈ�f�i���L$�������7{�TNV���x��8K��p'��������f�u�60ͽ�%+�&tv!�C�LiU�G$pЋ�����gj��{l�׻	��XIܬ�6���jP�.���8�k=a�8;[��Si%a(�L��ǈ�dL�9+�$LC���Hq��|�	��L1�̧R��l/���/����Da�V�1B�#m��>���(`�c�X�	ɡ��Rt%yv|�rvC]A���Ԭ�ɐ�YQO-�|\���j�1�������L,��'�*�yE�畇d��|L��41�	����dB9��J�n�]I�?Ǯ�CH��S�38`�`�ι*r&���@8$d4Nσ���T�gr��4sf �. �� 2��C�h7W��=H�����r2�������4m(�Mq�E��(��g��=
C�eW�����g���)��qҊ��5
�L��}�\��ɖ]���Z}�Ur͕����z��}�_СtI7�~�u�w��#�m�Dqsw�[UМ�r㏅���x��0 �)nWNpIvV\�Y�<i��w�m�|���˭�d�1Q�
�f��<e��iZߎ����K�Y�VYG��FQ���C&E�ߵ(`�u��7����m��q���)�_�����}p�mc� ����q[�:��M|S�{�x���^$���|�i2��uy�%w �~�/7�$|�o���-�w�Un5{L0���8�j�+gZ�`ˈ�t�:~��w��3MFi���:h�@K-��YӟS�(�|T� �Q|�hm�Z�Ĉ�s�Z�9�~8A����7TJ�m ���Q�8<����Z��d�E����H�su~K2���љ��8��N��)��(����-�o�^<��2z�f5ZDy��Z=G@*1N���'{Iѕ�HY6FG��l�����&Cr��?.���)e0��5��@��x�J�vV'�9,�����
3m)�HC���� ��"�����	1@et�{j���U=\O�R��\{Z�R���f��k7�4:F�w�f�6=<��	�ë
�Ʀ2^��� -B��ǌ�@6�4��A�d��8&K�JH���r�E�4��?䲜Q&>��yN�FI
o��ͮ*2�-J����w�$#9���Й�<"Tgm��A�_O]���Tgpg�2ͯ]���1�l�z���]��zWn��C�{�؎�����_����� ��7�T�����)���;�<�x���,W����3��{_wf� �H����AZ�����l@�G�qR7T	�p����~�ER��rڔޙV���y�Gp�5�_\u^�(y�e������Q��f���-zS4��92�>��:�
�X!bwk���~�4��wD�;K�K2iY���o��&z^��~�Bh	T��F�w5& �,k�<��W����כ½�~��ĵ�jD�~c&�d�A����eȘ�G����L����3�c]����QP��)V��C�`�2�nX�jB9u�W��-�Z�v�^'�y��!���y�U�z$��k�rzc1�@�"�;1�,���?�R���U��ڲ@��Pk`m�D�l��d�׷1�5!H_u��᳧@pF/L=�?�=�<���8��+��Y��ǃ'��+�O`�;�y��\h��a�3�,�V�����?Ϳ�*|��[/���9�dH.�a�еĄ�F"�[鯚�l��.P�1W���~�|�]2���/�r�l.MÜd��`�-,H�vZ���i@=�ϩ�-��9L.t�9�d��Q�̶䆐-[#�޵�gp��a��\�Ǭx;\+t�� V�]�G{*���Řy�w��ދ#�����w8��-]���:�|c�=�m��<��q�o����=[vk�7 4��*w��J��PhQ]k�:�3o�U�]J\���&�B�!��Y>�_7=:�,����`$��k��6�E3G�ʘ�hm��ل�Io}��G2��Cr�4���;�DEݡX�ʃfz�\�n����	-�\�� qn�r���뺡�e�`]�����P��x����K&���l:��c��[���O��@P޾��,s�vP����#���_����=��M=�*�^���nr=���ʹ�Y8e!i���	C��W)f��	b+d$����4���m�LUP-��>��7h�Ժ��C��,�{�Z��~S�ð4��6�@R�f+k�'H��	��[r���M"V�4�ɗ�z�#�-�6��-�ߝ��
j:x2�B7
�CjtS]-P��B��m�Y����:;�����ڢ=�~���p�)�~��.����E�Ua!`�וׅ,7{u����|dJA�����>������<�m���_N4)��xz�y/l�+�@|�ϝ<��?(��w���9̭��"��<��-��d��@��X����p���Ria�p��S�h�1��қ-+���=���mt���ͨ��e���B����&�L�WP�
K�i�Ɓb>w���C� �������"�b�6�)(�/��4��\Nn���9yprMl�Q'����s�*.���P=f�$m�|H^�l�)�� 6�Z\6M=CUUz��;�t����Yf�`t>������z�4�g�Ԥ�2,�"A=�.<��
慳��`�+�E�a���P<֜�XA���@��Aҭ[���X5����sK��#�Ҍ+/�A�!�Y���>�f6�'���iJ� �^y+nv&Y�E��I��j��i�.���LH����HZ��t����M�:��D��CH��bo']�D4+�Gx(b�8�.�n?ޫ��y��XL��fքc���Q�
��׸�i��3��E'm�Rj�-����&���}<Y��oJ�B�Nq�B�_����#�������y�/�a�QP/�V�c	���0H��6^q\��z�)���S����P����|�    ��n��{�{���U7��n��,Q'H�: Du}T�����Q~�0�౅� �1 ����K̬Q{���$=�[iSx��� W��j=
�O��Rn<8��{?������߷3�;]|4���tY� w���p!��M��A�i�5v�N�h�ի��dJtDa��l�{�&v4%S���M�0�4Q��Lm���c�����/�\OP��Թr�fY��HE� ��ǭeed$M�� ���q�{��atG���JXYe�y��aQ�)B!�;;���^_���j��D�V���ʰfdUm��/ۣ��\Y���w,
�m�h����"P>�=���2B0/p��y�*���"3B�K���r�n�!�z�[-�q��ã�����`)Hy�o�W��E�gE�޲$m�%����JE:�6�J\�sq��(�DO\�7T�C���?���(�i^]n��zп

�"5�W3�����Z���~���1}��5�Ɗm���?k�z�n�)�/ݭ��r�)Vd�]�'��3�®���#^\\��ԁ�s�������S�G��~�\}�z�^3�?�"3j����������(o�]0e��
�]6�H��e�_м�\�U���m�z�L
�S�kC��7�v�(*�3 ����_�0{/�U6ș=^{sޤ��ዼGA�� �k�D���.�+���8��1%>�atq �D��փ�z�b:
"�]l w���>,�#��̉�,P�+���I�}���P3Pv��w�1eD&���F��5K>��j�ܧ{,����w����Z(����u�=[c�Ƞ�K�-�K�&iFB`�	�`��,�h_������P\s�\<�������|{���U�5
�a�ʃλ�@D91�Sw��_ӂ�d���ǅL��
�v��O��I�M�s�;��G�p���\��=� �0v$N(�d`�z"�ګ5�����y8-�൭i���>A���-[D=�QO��� /��@謣����
�!�Q����;�G��13E�qHSҤ���M�C��(�q=yJ~�&��SI�8���HlppE^#��Ke�n�5a�a����闸[��G�;���R���קu�+N�ɔ��'�߽Ur��n��M����V��	c�I��Q ��p}'e�'��#�5O� i*��[H�Hp׫n>�۶��5#�0����yB�������a���AWDQL���.��ݗ�M���PvX�x|3�96*_ �0ɴ�6!׶��<~T_�WȘ*^�!>L��#�]R���}摞����,��-�uN��m�벴X*Xc+��arQ�&D�~ ��l��v�k�TX"ky�|N9Ͽ�m�9����r(�n�d��-=�_��t�G���7F����'�y�����/�0"\l�BY%��<��/鞚B�\yi  �6��S��2�9�I��K�f�Ԟ{q@���o�K���s���,�؜uӨ5#�^'[��A��H�Z�1�^A������ѱ���U�H����iw�$T b�%��Jbqe��?xy��z�����b�{��)�	1�����w��(Ō�:vދKq���+��)�ʺW w�G��a�tҪ��`;*]=�kӏ���n�hb��\#�� �-Q����#�?0�Y��A��Z_���6���ϵ9A!F�1Ƹj�@M`UT��)�	�Q�^����Jk`b���d?>�������XݏN��e��Y)E'�X��.�Sz�V4Dr8��F��'�<Ŕ�#{�׮�߭n�9�C?�jb��t�v�Mf��o[ 7S�Bڌ0 C���n�S��?R�Ш���|�7�7$*~� �f{u1|�z��ҍ���
K��^��L�(���w�뢋d��T�]� �>�"j�m�?0RM6�״��,�C���v�r�"����@Z��p�W�Гbm�٩p��>����4�Ӫ">�xY�ޱE�L�bڃN�O� n����o[v���P�'�+���@4'�5�4�K@�����{U���(T%� ��Wgoim7��.:��%��.�3 L��?7�ߢO2�"���Ŷ�գ� #�
=���@���g�묏�z�������9�N�� >�������i��!�X""ū���ɳ̮@���w-��t�������T�]��sB�n(`,�~�g�����WM��X�[ֹ�)]��8�4a"�?ΠPݘ��}��xu�x����ڻd$#qDQ��?���W���iJ`���Y�����7�_ͮ���f2��3�u�E�ЄI��,��?�(�����H�a����O�B�����1#�{b����8��5i�jǏ��r�3|ӿ�e�*Q�O�{�P�__B)�����t�&����,���jbz^���婨 Q��ڮ�"�3G������m�sg�핧���'��Y\YB-��ͣ��+_��'9"s�����O�籮m��8<`ē�>���L���h����(�h��#J��I�W���s��N���<�����������h�܀�V��L��1F7����}��c��1���-Ǯ��߯Qx�����V�@����6[�8����f�0)R�tP��������ޯ#ln�qb�)%�����Eԍ�I/���T����yUF�Cn*�BB]�D�gt-Ή����'��$օd^���;i��7#��Р�k�'&��瓌�	0�Q�1��y3�}����I֫����h}X�����M�-��u���*sw�Le���;�_�Q!�`�5T��h��2�����>����N��^g��]�a����^�/�={�^��r�J�( X�'.:����GMD3�!�iG�s����J����M{��Ct�_lF~O����9��s��1��ܜĀ'�;e�ʑ� ����/���m4������ۆ�c��wa^��&~��@�b?�@�M�8�V4,eg |".\<��Hz�»�#��f��8�0�ԋ̈́M�ƻ��=��+M�����g'�R�۾��!�,F��e�ޤ�	�2�W=�Ja��K��\�m 5��0�?l�������Ǥ��_�`�Y��D|0-���E�upV$�/��uP�v�9��HP�*Շ�"�P��G<TM���0@e'���m�Qt���5[��[�o!���}�:eݷ��
�.8q.��IE@\$O��(���v�M1���f��Jl9����MD7Z�����BR�e�h�7\+�)&9����ܰy�"�>�\|j!�D�_!��l���[/��&��/Z���p���
��s��m?���i��7��wP�(�-G�� $8BS�߭Zү#Y�*����|�o�~:`��tƥ�u�6l�qؾ��o��,'��Z���F�H��Nn���EmZ�w��!^������EoZC_}H_�~9ɮ�o8���Ā�V2��$��3��U�����crq�����۝�.2��{<�6����l�\���OO�lQ f�B�H��Y�5�If�h�p�<3w���Ԛ\�(��E�V)�4����h���\�.��0��o^�s�0Q�H��^�O˵���1�;J@��pp.㶿My-�k��_��c�o�"G�d�ٿ5�g��NG��R%z�ٕ�Dg��A� 	�nN|�9��覍�[�s:�;I�R �4��N������8'g�p��<�&�@N�|�Z7�gD��r)��B���n��6�E� �C���7@�9 �y��� ��k��$�Щ56W�g���@9�`9/�̻J��V
����e -�6[���4 _C��w�iF�0��L9�m)��q��Ï��	i�K��6��|����-+��Z�b�p� ٴ���b�C�����3q�~Y��������o
�����a�����-ѷ������gD��}7�c%���o�j�%z�o�"�2ǯ�BW�1��4#�(+H���?��3`}���Zʛ���c|t	����!,�>!���^�Łŷ��>��M"��z<��1�]#>3o4h���7��=�����vۉ��oD��%סC��4�=    ��6��r�)v���.Y�3�~�������5`�Ľ4w�$U?+�����M���
C��uأ�ɱ�ا���"�\y����^���c� =��O?ʭ�J,a_`��H؉=�\O�?���ߍ���'�^��}?$���MN�
����^O��^�ن���p�S��;b�h�K��m�tI�Tw�� �57�����/P��ЉN2�A���)'��/�M���X��:�=(���5~��h�&%w��{+�AWnFo��'g�\;E�اù�О�(^�(�L~b[{�.QN�ꃂ�������u�濦Z��*׼m����n~9������6���j�g^&k�_�ƥ��?�������dK�{�'e�n����4Y���O��h�r�X�K�_�zwhF�iG�����y����Ǿ3g$���eb�ep�i���y|%���p�"{�� �M�Mm�덊����V�7��i
��������g�>K�fi٣��p)՗��/�,Z8ip��N�����������E����3���aIc������#�$�7
�(ʆ��p���I�%�["6|h`5'eu&9�+�d]�l� X�dKQ��W��w��юcY|�E�Y��v���D�c+����c�;�f������5M�����c �8�i��r<:qeRH�(��{�-�)nHv��Z�7T�����=q&���oci���O��hw��u�k��]�я����Ʈ̽"�eҐ+m�Ƽ�w+:�DI��<ҭ��\��}����5�v3��o�0'V\VV([��
�N�ťk5��q�o�Y�8<,�&#/�,y}���Q{+	!�S$���n�����i۔����� ����Hw��qe^ᜭ&zslZ��;�q��+��@�����3��D�k��s�7I�'���%{�L��ZxTF�]��)`z�"r?�(��Gh��{K����avsmc��Q�ۧ!��ǀ:�iv�E�	iz�U%/i%�ɶ���b׆��2C!������Z[��1ݸ�n�}\/+���Z홼K+˔(��^���H��UU�n���\���˰�yhi�Y�9rH�*3���ꂏ �!�C/�%�im�y",�æ<�c��Kh����8��(�2�IS��g����Fa�j�ׄj��uQN�P[�{���<�T��)����뢼Re~�'�w���Znx�e0|�SL���Ҳ�:�2z�2R�n2e�)���ˊ�J{���Xu"���i�|ԙ��
�>`�'�+ʐ�����'C�0���a<�#�E�����ՇK�a��'����-uh_��4�j�@[wN�B��]���A{�����K�W�(|ך��EQ��"˶�)���ɽo�Ϟa�GTA�_e��ݩݿ�f1�B�8M�7	?cQ�h���In�W�"�a�GBo\���át8�#B��=��I�{J=��|����0��R!�P��ޚv�ś�z�Y>е�]<;�Y(�8��OL$Q��GC�WI�{�&j���/<�?�>��l�0��d���m�
����ww~�?#_�������c�ks(�}��q���i����!���΀
,�����#�t��g����ƻ�1A2^l|�N4k�Nb\��d)W�}�7P�kו����pM~������� ��>ܟ�|�iҮi}�;�h�Q?��{���	ܬ�>�|M�8��+@��mk��=�v�A��b!*
��I���/+#�!��!<$�8�5m3:�,_I��s�������qX�p�?�yWO�ܤ�l��5��C�F��C���x�:�.�3Q[�����'!�}t�����:Z��YP�ZAQ�u�\p��pt���������{M{I#�(��v����nc�ݔ�������^�K]i�R��֛ۏ�8�&^�20}�私8V4����d��ܬ�?���c8ص�/3�RN)�s�Ez���P�b���>�.�d(P'1�Г�,=�H�w����� �%2�"�8��������hϡ�A��ҧn�0����K�8^o�����@���%:O�ޠvW�*K	�L�s�hE��L�ǒ�L����HK���Vx�~��11�#n����2�S�%�}-K�0����[�y©\�ӟ�S#��|�B��g����3��36ྒྷ���ǐ0��E0ΔK  �V��8�B��@��u�'�ƺX3��(}�7�ZZ�����4��Ƣ��â�+RK��X�th��bW�#�RG�,��#�Ό`{��F%�l	dίk���>�<��E.����-�N���^�������R:}=�v�rMR���v1��~XH����8U�	n5��(�lQ%�$8�OB+$��k M��z��ٞ���b�ݢ� ��<���Kȿ1/����M�����ƻ��J*h�f�G�s���ט�l.m���
^�yc��t�|��D���ލY_���*�2?%��1Lm���9�T�c5$�n�sr�CX�z��f�ͳ��u"�n��!Rz����Y�{��asN#hAO���a�<�@�-��rmb6�N��y���|1���ӏ�3��L�`��-��O]@gj��F��'*�a��i�L�V��g�m� �6}C��h܏4ەvXc2�:Õ8>��	�����-��+t��q���s��Y�,�r��P�'R�<���PZ��F����2ϕ
��SL ���c��NXޝ%1���R����1�ke�̒>��a��ŷlWH3^[�h�j��Jx?߶+'��08��cvAsV�"B�u?������)*���=c\�r���QJ�4,�)$�8=b�����ׯ�^wT�ݡ�Κ����n�j'|	�����z.�4?�����w�pM]cq�&�c~�z���"ۋ;?�W���i��σ2+�ѻ��3�LEй�P�7ڶ�Tr��H��r��\�	1�*=V�c��Y�f*��2"}Ĳ �[Q�$$@gmk�y,�
�8�Ӎ4�����-�8|�]�����]��P2`�9���Q=X3Mʍ�A��/����V��"!**����s����흆Ē�|HK�"9}bt�0b�</��e�fJǆ@�A���+dC��pǗԚ�g�3S�����MYf1�%��-G�m%��sX�V�[8)I��]~�+z���ѫ�'4��s��"�����/#x0�(^�x�wR5mjBV[S�c��!R#�#�֌s�$�8�K���
�z-�E�@O5��Z�:������Jt���'�8f�I�qR��y���y�#�C�,XR�ODd#���������`����Z�Kά0�)"�T⎌��Jllp�������Dlc�~<�0`��C�V��[�p
v�6��p�5��H,��%�$\c��˝�)�t���̎bH�4$�Hh&��ʙ>c^<�g}�����������=b��O2X)`�~�a��o��WI�Z�j<s���(Bxh�׉��@X�X�U������2C��� ~�nu�X}��0�-٪he��U�Pu�6�����bjrN���9��F���E��1� $��T3�y=��_��K�o��KǞ���9dE�ؤij�(v��i�2��8Z��[��u&�H�7�x��>~!����0z���i�c��\�~xW�!�$��
��'�$�$����/\�1~x�.�DL�3J��b�"V�I�k��3�X��~��j�U03?R�+�}/���^�Z�8�u�2�ot����3�S��eM���.x�B�-��U��9�g�F=t�Lv>�ui	MS���%D�#Gƀ������:�/�j��W�u͢�;���<+RIA6����p˞G���Z�$�ϼ�3v�X��`R�Οa��VJT���#&��Γج)�k�6��c��!�:����6��D�1	�_R%,o��1'*��,���5��q�D:rg߀����kZ�/�~��轭�nc긗h���^9k�V�镩@={"���i�T��Kf����8�����8<a���޹��3/w3a
�+���LS.o+�,P	�Ӯ����J��D4���$rr<��6��ԅ.�VZ���Fښ�l���_    Z	���~*M�~�M���y�~\��V�-Q�q�&wiI`g��J����)M?��9*��M��A�Ì�!A:JH_�,�RxJ,k�u�*5��&��S�ѐ"aB��NB?`fِ"�BR����W����ӯ���C����S	�����3��������	�������4�7ĭ���FS�g�g�ad�GHVs�64$,�8s$�_.��5ް'�+G�KP��,eʆ!��Y]�s7h�d��$�+��oEI&$Y9�@��c�6"~Dd��T�&r2mD�6:>IԌm�����?���˽�^���J���j�V�S����%'L4��$]�`_��h�;�,�8G�-��7�g����J@�ģ@�y��j�l�WR��ב
2�rE,c�{������g��;6}�"��!��=i�,��{'�BP HZd�z��g��U<��=�1ҝ�p�s�A�[��0,�&�Iy$�U�	���޾;���a"ě�ԥ�٬�Ș��=��Q�(�g*?.?��94�r3%_1�'�L�|�������s1�u6u0��*�"G�;���&�hbJ����q[p�\��hV����:�=��A4-5!ud`���?jk'I#��|٨����{�a�D@B�;��5�	���㞺�P���<e�l���oX,���N����?%���_7��!���?7Yt)�<�6�ӿځ:J�����1sC��2��W	S��q�ŪN1w:��ZO����z�駮����RS��
�ɕp����c^�<@��Ž�6�D�
0�GMO�]�[�NL}�V��0�Nݠ�g�U��0�Uuy�5�s�Pє�e��\���ە��(�zp��u}�]ۛ���q샧��k�����Ws����WӴ�1����\��˭�<��o;`Z�U��~i����>��ia� ��Խ�d�i*�IIX�Dh��H8���o�Xh��wj/�P��ϐ#̧b�sM���&6n��d�%��1��6�
�78��"-��ϩ����#,�{�x���~��s�'��ͦձ��Z�`�����?߹�U�a��9��=o�m���@bCj���J	�5�xP��uPO`o�Ƙ��~9Ŭ?V��9i8�	�'�ջz���������iŏm��;OW#`T��ءo���f$ؽ�*�fpb���I��De��/4��ӱmvyk*�d��ˬ���X~�ɲ��ȷ7�I���^�'��[�Br7o��?�] ��;o�����~�v{e0��t�J�G��ؠO���[�*�DU������J◵��0�4�`UqL�:���ydė��>��\>� �m5AM�������|�}�SZ�m:y��۪F@Ở[OQ�p�fn��#�qB�������gZ{�����u�|f��d��ښ��Լ<�o;�B�zۖ��D�������������j���3�`�<-��K���H'��4$���x�j%��xԇH�p}�4�,h
vB�p�k�3&�Fro�,��mB�k=����<3��ȷ>Z*��|����󙛪&�!�k��"ݍdӆ)�f�>O�w�
rͭ�沦B�eE>�h)���L<#ϖ̋�k�c��m+E�1��K����X۪��q;�q{���y�6K�/g��-'����}�c]�_PӉӔ�Ǣ�°�������Q��a�<�nB�Ř��1�����y�P�3Ly"���ۜ0���_�,�X/*�hFG���4�b)�E�c������ԏ��r�}61~�1��v	=��ٰ?AZt<�ꋩ�dw�r��#�Ε$����^�4��)m��q�R���]�?}��?�<�m���^�yL�o'��J���s۟)'�:�UJ3���Bq#a|���n�D}j9�k�ksh�C0�QF��zbߎh`��˘R��!��s����C��E:�&l0��V�X�y޷
�/G`�YU�5��2N���e�2�pC��x�h:b�@}�>���\��[FYW}!��ϒ�����2@�Aـl����<,0^�ae6�˦��ޓ��OP�/w ������}�:���r��g�?&1 �}�]b�|=����?��waMD����$�͈��F��_�Pb �B2�ґ�""8��8U��9�\�Sh�yr��B��D*��V�8f���}�98�0|_�)2�����bB�@0�_Lm�>À����W��|���s?Z�	�Xe^����|���ɛ���w8,~ N���[� K����m�nC��u�|}�g�L6� �(]�y	��bR�2E{;��I0jǀ�%����s߬`I�h�@� _���3�Y�&�/�}�/�)��*�[���<l�*/��]4�zw|����8��8��Ƿ���]G�����S��F�)���ֿnn���a�d���d�&>D�SI�A�IN��!w����V���M��CSx7b\��4��e���#��&���X�o�	xEa?�������)t��)u���gU�1v*��=0�A��n*�ؗrZ�r4|h�u�m�]����h�T�,"�M����[?�CY��zl�g��&��O��.#��z�x��JF?����`��yz^A��A&I @�����$�{$�����E��|oڋ�?�JƁ� ��o�[7�i�g����e�i�M�Gr�/I�Q\\��8�2���'������vG6�̤�w|_��9��C	څ��Z�_%�]�
��w8�c�>#�u���h��I���I��r��� �9�� F��	t�^�2	��O�T�V���O�}�T��=�
� ��i��c-�� vW�"���R�+�i�weY�
_�w�>4��.u`#�ߕ�G�[�� AϽ�f�����mR�Ds��&���#�R���`b~�h�E�هA�@�G����̟��?	P�]� ?��؁iۚ!�Yv�P��nqJ�"*q\���"��&7颈��-��޼!�����w�*��=|����%pt���Aɚ�Au��A�pE|�f�v��bq�w;f=Jw����_2*�xTp��D$�k��#s��l	K�(vVQ>	��!9�"!.���r_&*�o�l�Ub� �������'f_�BU8�����������^�ƒZޖf�
��.��5q%2��8����b�E󃉖�����޼��Y x���<�,A6R��g[���uMH��1�<_���J`�c\(��М�2һtf��\֔��Q^��b��nP��8�n�]|Z���S��`:]5���j�l������aCvyE�Nr}��_$#m�U"SagUsľd
fS�xvu;)�����S����΢����TU�
Y(��_A)9�i��{�w}��}���Ow>!��ȯڨF$��{�p��xh՚W����=��xiu{�*����6j�i�)�L�	SW���\в�R��u8��%�8`@�a�f�x��o������<��҃��z�3���%��6>���Ӿ��h��5��y�IЁ��Q!���M�j����G�qK"/������������ }���
�!���� E�W(����5��ҳ��^��<�C���3��:@����l߈�Q���[�<lء��n�E��6e4�]����D���'ԫNƼ�ҪѿV���L*S�3��Ht�'��X<���˫U��'�G�7�9���3���n�)-�V?�웂����}�w�QX��=b���1���f���I�<�j[��݇����>C3\Y�Gހj�M!zi�|�a��01tb�b�v��|L���'y)KÔڬ1�w�mIF����4�km�e�\���k?tZ�4�~L~�p9�O�L��?�x�-�O%�ma��q��Ҩ;�ߢ��k��M��������i���5�[��[=��e&O)@�a���\5S����X�)��BW�:�Y|.+�`���P��숀׎�8��'��<:���l]�zT�=^
!�����h��L�:vKѐ�����P��)�2hჀ� ���z�
�"W��j�Ǯ "    ��D^t6�<��^ȟ�E,����G�l3���|S��.Q��D2Ϳc�����]6` ?=s�H���>�:�Ytb�X���S ���;vSK�Kٲ��d�[����d@��j�z��<P��$U�����T�^��,��͡�W�i�ˎ��[�9q0:�~���^�q��9�o�J���EN;�7q|��i\��ӡ����6�$���}@������Am0�͌����3�XϿ'�f����["Ň#@�0se�+*^u�w˨��+}�C�o�"�C���:�a8A�7w�V�+d�[�F���]�E�9����ձ��t�e"B Qc�9�a�n��S��LjOi�VL��0��"�;�XN$��Xx�_M���է�r�1(j�CA`9Qä~}|���%��O�Շ���x�l�	��1��0���[@ʗ��W�tN
��8�3z��@�X�b�4����y݌=�����|��7�|��"=����څ.�l:z/���]深�6��{#h����	v���<�ST��
��>�]c1�v�L\;LhG��:�+g�j`�
�i�9�]���V�$Q�h���\N>��z���-�,�x���KF�i!bx'�t�\]AY�N�&'RC���BΖ���?��!K���a�e-��$��*Ki	!�ҋV��oĉ��dj5��u���!��J�����%�TKWD#��/�s��u)qwmV{��'��:�5��P��y��{���ۣKj��`�N(�~r�t_t�������p��E_3���^�'��>x�8;��&�⧏N��Vi,�2����o~+Dˉ�dSxe�z�F�ER�&L!}5�D$�e�9���Bk#�y����ʖF	�56ݨ�R ��zl۹��DQ>�m��S�㿺a���Ր5����T���g��H��dn��J|W�o;�a���)�Y�i��O�N>��{���g4�"H?>�~:�)��	��;��kx_ר��m=�I�U3+�3\��aD4,@����7�"�|�:zNEhOgX��.&&,��f�KED��Mӝ�=��˒��	�n����}���\.5��σƵ˾��w�-�Cd�3���*{���:��G���к��*��Vo�?����	���uJC x��+z	;b���=��5��<��ޢ�)hꮙ��5�^�E>��a��9�A��@�W.�-5ޭ����-11/+4^����)*�~lgOI�8+�@�,��sy���&�����vdя���v�NG��xL�)��l�š�Q8D��$C��d^�F������!gۺ�o[j�w` �:T 0����}�5/��](:�C[�З�����c
�3���E̐�ō�L�O2��D4ء�!2�e�{K�$�{@
��{������;�6��{�#�m�O:Ųm�q����+K�20�^��<׳]P�� #)�*�`(��u����Z��͐��|,����e} �źe!|,�J�$�dj������d�>�g=[3��V�Ja����`������6虁:^R�C��1��r �Z½�+pUep���NC�B�,(�7:U��	�0��Ìo2>f��DԒ �.;t�u�����|a{��)�3ۦX���%m�>����S�F �z���
S�٥`�/Ј���r3:m\���摚8ТK���"+aݒ�^c����s��<1tQoK$�`Dଢ2>�X�t�7�%�Ut��~���Դ�N�C�!tZ�ڏ&:���8�y0F��GF	+mp_g}c�[�G-*b���[|"�8Q�h$��aFV�T~�j������|�pRԢ��8��2�8(-���e~�({XI�w5U�n��e����׆��م�`;7_o�����@]$�.]L�$�kr�����h�p�0j1:gNJ5gs�9�|�e�����
�����Ew*?�I���},���>9[���Rk����i��8��SՑ[�i��I�7��^?������7�E�/mR��`}�s��UZ�^7*	I�>g���D�����A��gSFT�)6L�������
�w�[P®����Ι�p�XW!h0Ȣ�}0�ߗ�E,r�GL�Z(��'�ChGe�����D��,�et�<Ϙ^Rg�/�a��	�E�V�j��֋��M��/��(��\�2g�����WQ(
��&.�wp��偐�v
0e�29�zi�٘�X�O�[Q�˲F����T�[k�f����ba5R���u�)����N��-
��5	���B�Kpг֮�o	�&IC�� i����7!��/4����)n�4'
��a[���^n7�}Gv�Փ���Cwp�X���f�NWu�m�����za��h��b5�e�[���2�=�EE��o�(�8"q/*a�#!qyg��}H_S��E���o���p"&ļ�>
�M��Cb�,���"`�Gh	Z�{{{�/�V�gȻB'	����9_��c�W����O��A����39Z���ᎁ�9���5�俾�����?́��R���_k3 �ǰ���:n�R�-�m0��w4�b�F�̋̔j�INz��nӲ�=
�������2y!��|=�@����B���T�����lc����v]6b	�J����AD�<��|]�*�&�\�L=0�K�0`쯨�a��u+ɞkߵ�&Q��;k�G��;h�F�e�H�0��� ��I����gN�n]��1K��g�5�HE`�Ԏ)���r� ʯ$Z�2^B��C䕑Ř�-{JG8Z�ڷ�1AZ��w:P�e1�(+�[FB�HBI��_}0�;7�"��sN_��ڍ�wۑ��>ݍ���^�J�O�?ta�,#�TA�<r aky'�-9���Q�:p(QȦ�
��b��w�������S���(%��)�R���K·�����kB��.�'ȹLgy�|��F�����u��=i��k��'j�)|�0�X�H��P�J|���w�'�(hQ*��@�)�^�E�]�wI	������Mį�1e���BB��Ф�@V�C�_L3,W�Ȓo��#��,C�Ӷg�w�*��3��������_3s��/�^��
|�a��.	o���[e|�nҷ@}�*�G��B�J H����f|~=��)\n�%:b&�0��\��s�<_ɻm�f���v� p��^�8Lz�����\�
�&/i��e�W����*u�1��'�~�G~yV�O���#/h6�)�����&�����}f��#��7�q,�B��D�C���SO]
x*�{��«���]f�S�&�{���)S_�3�m�;������d&&��Q�1q�XK����b�~�n�o����W��`�|��m��E-�8����6�e��k>S�l�l��j�ܳT7�qn_�@ ���K���(��u�Z{�D�B����������L~�x���m�X}��N�2�W�5_)͚�E�@�
-�[�_�{pE|�����|�O�Wr���uR4�g{�R�{��B�!�� <�]�4����]���P�k��������ו�U��Y�u����GߖStPR%*���?( h�Xv���1�*19�&w&l��>ס~x����$P�;�\*����X~��ښό�4э�����+�t�j#�P�+��æ����ρ`�!����aI~�l�M��ð���o���J�v�2��N/����^%v�s�.��HH�X��Z��ۛ�"4�-D������}j��]B�bʋ�]��k�|P�3u�ҿ����|ͷnZ��z�R�i�N��oum�ʹ:[�T+�o�f�G��V�*5���~yz�Dk�zz<'�Ԝ�Ώeb�m�7�?�r��K*:�ԓ�\�Jz�K�-&�R#��$"4���5ћ\��b�3D]��4}U��;�>A�&�߉CPU܏���%�>�u�L�˜��Vpk�S�CI�MR�GԌ��x?�r�G���md.�TN��Ո�X���v�=D\O�������DuB`ٮ�!%�y��
��y$L����w3�`� [tI��=Md^$�Y�C    ��l��(q�ߝ&��M�[g��}�+~n3��ئK�JL��s��A���XE���ƶ(�^�i���wK0�k��<��Q��4\0��Մ���qx%���_�X�i�ۙ1�����JR��L��q��_��?��'�vJ����9��dd��ޢ�ڹ/98"������nKĸ�6E����[�!i$g�w�06��b�������M��,�_d�'�s;^f�����W\:J���(d���ƾ<��y����|�\	҅{��4�7��zC����t-ZQ��;X����=��c,����zYA��N��(��W���1_��W��������2��њ�}^�˃0E�O=�NC�*Үs�:Y�X���}V'B�ۑ��˾��Y��q ��;�"�o�D�n�C�Q
4��cAQI'��z1��'�󇜉�i�h�Ā/�Y���D�7�޲^P��3k)�*��r[�8L�$�He��z����9�lk�����w0���1i0}(W�B[K�}�VEW���$~������u��3�H�`P��򬝸>��m=���oV?��>�S�(XӚ�,�l��x���&^���Ҽ�	<!�B��w^��ER�����KR�C��΀�.>�+��R�����l,�c������t��Ȼ�&�QAX�H�ͰV����"FZ9jj�*h6���t*�Cד�s{_Ex��H����N���s����/o�,<ÿ�#��u��Ю������3���{��ߵ	�l� |?�KTU�s/�h|��^`|=M�]˫���Oh���Ƈ��:v�g�d��L+���&"/�~� ��2;N�:Q�w� �jF.���U_���l������m#R�~������YOb������CeD���P�Bw�;PE9O�5�����cM���NUk�W�V��u�W��jR����$���e��޽�V�����f��!ƭ����ф�~�7��7~��n����i4�Xh�����~D^Í0O{/|�	����𩛼~�n���S��ޣ$�!&5dzc����f��>Tg�]��r�d���a�/�J"Z\�)�y|Ÿ}������-�hT#K��7�'<B�S&2�����e-��`-�j�K��i,>�CC�`�T3�g�uz�)��pN�;�|ΧK:d5w}�|�1tA�!@��)<�}���b�y�2�lݢ����UpX���=���z*Ã,��g�<��/Gy��uW�x[f�[�y��'��?�����e� Kx=�,
�V�V�G1̚�E�4>�r� �����o ���jȹPU�����s؂��(�����WLq��rV�)���1�G��H}�X����r��w޾�jʼ��j�sIi#e����M�v�+�aI����4NW�8$oө4�_�>�X��S<���ͤ� a>B����Y�����B�@��;}�m[�����!�֞����r̰;�������|3�|U�	2��o?��7��s�ͧ��ݚ��m��1��Gi_S�L߿���ۖ�K�S����r�>�K֮�g��U_1M�9�|��H]����]����du�lS8D���=�rڪ����Ʌ�i��"�����MT���>P��	�4��u��ޯz�ι&�t�|����/�kMsp�`0y}�;��O\EE�6i[O>0�zO�v>)�Si��`�M��N&��Fa�������-�L����b�-J�pʵ�{�WB!x\��2X��240�*�v�$6i��0N�G���?#�������԰�rᱢ��0>9X���:c�G�{C�K�ʀCQu�?/�գo���:\ɦˊ���+�B�n�t�y�P��iѦ���K&�6S�fAU��Ie'F��;i�/��(у�w*�&�Kt*8��k_09���ӊ����\ٛ+�.��p WL[��h4C��p��JD[�Lt��� ź}o\<��UJ��LS���&���>ӻ�a%a.����KZ�s�Y�U��}�]���0븵��G���=9���R�]T�#��Ƅ����{|z}��A��_~���xNO9����N�?0A.|o/�Q�����jh��
�q�U��K�]kw�<��6�t*����u�\(؝��q?�?�'�U���
��	R��'��%ly�J��2Q:�����ћ���.����V���#�c�k���Y8��^�޼@,ӥ�.���|�}�)!m��f�
�d�F�-'Q$X���8�-�L�k�s+FB��=\��n��_�Z|~�����P�ڛ�M�o+㆗0���ܭΊN��q�?�|�����)
Ew�> )��ݠ�IV��*�L4����Ŕ���֠L�x����#��^#���1ڭ��zcȉ����i�Q�����/���o���F�<~\�U?.h��3h�W�|k�lط�w)��~�}��Qcե�@�j�{������AU��ǩN��x%0��wϧ�O��ه���=��<�C��$R����C��Re�H-�f��J"�H�bO��y�,)ޔ0K�`g���y���5��D�����U�)X)��#���@��?�b�آ��H=�$��Ga9���#!�7|�'�[}�"�N	�������}�P�(蚩�x"j_�%���N%��܉_lnI��J�!��u>�� �������GT���%��~4��{�����
�p�|��S7h�觰>G%��p�
�/��5�J����9e������b&���>bj�2g�Z��n[%��&w�=�o�8��L�oi�\k4�/�.S�Y.cV�m4J�s�w��t8>j܇��|E�l[��8j%�B~9�����p�ȧ�H��C%�����m�]}@۪��琺����T wx�Ûz��ӌ��>�)�{Pӯ���[���{�N�����݁�j.�{�/�Z㏨�	�R�%���<�w�} 7��_sKP6��A�db��� ��~4��Jwx�@�Quk�#[~ -.m13�3X���5s7w�_WW[	�D�Q%�z\�k��;�4Y��p���r&�&��@�jدѠ���͈a������R�/l���� ��וǓ�Ffmi|q]�g���*V�ԋþC�Q�O_0�e�g�N7+��'����ʄ�� C��i���tk�O1��7#L$�Lb�{��u���rF����F��efE���J�-����G���}�4�,���i�oCP-��j2������ܔO���_\�*.)g�Uֺ�#ʳL]����Ma��H�#»"T��w�u�a���+�[�o�t�^��Ө�=��-a��?��C��bqQ��{Am�(��c�������(>�jwd!�Mm�a�)=���^�Af�\��5 &?X�P��Hg�{�!����)���np����\$3�2S2c��0��$�Q�N�T}Jo�_#b��L38�O��i15Z	y���%5���FL�\ꟊmT���#�䃨cc�����y��ER�Iw9T�J��9�����|�.�<���n��P���� >Uk(~�2�P��0��n��5�{�,�����{�iT�I�ߣ>mԘ���jӂ�q	�c�v>����2�=��n#!U?�_,�D	 X�H#�<!/9��/�1&꥗�c��fd���w8�/���n�u~��X��]��G�"+������n���ѽ�?{|%֝���@?�L��5����z�,5�$�}̘z�	�Q�%���.��wIy���}�4�-���$����צZ�B���j�D����OJ�˕�S��B�\���aX�H\^�G|,�Gr���	t�[����,jrP����~Sj��NS#H�����K��ܓ�.��ʃ�9�^��QR�o�t�)����
�[�8���ˀq �.-���M�Jh��Y�1=�k6���b 6�I��2j!����v��|B_(��^��X�ɛ:G�}����KYffz`K�V�:�	,������w��l�ܾB����^��یp�n>=Y��=�b���P?���!	�T����4V�������t5<ƹ�d�c�^{A՚T���3�e�n�{���f5�"j�G(Y��~�fc    �8ɖD��}4�����՞���������1pۦ�}!�TDׯRY_K��D��Qi�Ɏ���lYx�)�X�/C^~Dor��`��qi*����ƾ�G�G�7}\��Dά��\2KΘ��☸P�D���"�h/�(�����X�Xe�QӦ�p}j\�` "vD:9�\�u7�sQ�?���Q=#E�V }�t���`9E���䫔�������j�*�s������ ,�mn�on}@�I�y=���x��0��-N��{B=������iH�@��.cu�)��1� ��)�c���t��f��rV�a�P�0�M��^-�Ѹ�Ⱥn_��Ҕ�����r���Ώlq[ʽ�����j3�y�������uu�/�'����{@P�<��gV�����h���~���6E�t�8O��?����t51�-s*�ẁJ?ә���aY�9�ߙ#�~��r9a#N��ň~ ��"d��<P�%�GN_�[p~������|���~"S��"UJ���C{1�����n�����|�3�{.��k6A�1���_��S����nP��6F���Q�7�/H�f�%�-��������^X�h_�.</���/���ۻ�_E��/��]�Q44a��j%�d�}���ohա��d�^<������|�����'�������_�ř�E��t8i�V<F��U17P��W�g5��|�G�����2�Vh�����D�Y�[>��2�A�͇��8��# ����n=G&!-TK�-.ju1=�����ar';�z�O$�~�3Ҵ	b~�C�?�f�w�)Wg��tݣ�T���3��"�#mm��cW��"��-ni��7�(���SJL�O�$|�|%��8i��"S^�-�Y��e)s?4���g`�i)��'���;�>�Ž[x���f5�� ���@�]#���ēL]��%;�Y�'Xh<���Z�X�MG\ԝ��(h�b #�Y�қ�ƕ�r�/H��l\'>�/���~(��=��[+�B{~�-���[��-($F�v�s�e��J	��ͭ|�|l���hK�[tH�U��nDxsޣ�Jy�XG��ڋj1 mt0�7P�D�X�+����D����AM��.P_H��E�I�ø�o��@�O�hO+̬A�1}�B��*DBS��������������RR�T#REiӺ�c�l��3V�p}���8��v�{*�=X�� {u�ob8��L³ �(_���d�W�� ��Y c�0�SX�X�Z���|�^��`?����H�45�d��~���|��\�z!<:=QA
ҁ.�Ѳ>ǿ7�K��-���JN�m!�b��	���w��)�����&P���Pn�ˏ����- ��x"�F�^��߶�|�y�R���Z_@X�y�(��'�u%H^�m���}�/T��$����H��N �B�Z�$ǣ��F�ϑ
���.��.����]?��C�R.�f��M��N�ȯk6�wjic��G���m"4���HhNF�Ы�:����.Ex�����q����4��-�(��˶����	�i����X;���M�D��ÀԒK�sx���k�.����~��l+�g�̘ ضi�<�˔%'M@[5��+C��{��'���\��PEq	TneC�C��.��4?���Q>&%E�D��^BX��p��-}�<�D\V���@د8�Pxى#S@����v]��������9��g�L�w>�����X�����k�۪A��Ed�D]M͆���"���c�=
}9�U4~�պ�F+�7�HY8����*��.="�@6gu]�1�ńr�� [ƞU�2=#�S@�/�[9ex�����������:Y1����H�h�)�q�U�	�,���%`qM?"D�@�߂^B�˱t�4VEt�������5L�Ոz�TK�`�(fj�X�2��h7���ɉ�/J{[gtg��ը�w`{�-L�o�� >��3��ȏ�rvP�ۙ{m�d��x##�	�Ja?��h�f:@�K�	�>�R@���{\�ԟi�,��*C��%��j�U��~T�J_}����%����6""mk�����.�b���V<��|cǵ�HB%�6p�wSWgZ��ԝܖ�
�IV���z�%���Sn��I�`;Lб��|V��#�_���qP�O�Aޛ��E�>.��?o�cی�b�@�,�j�T��a�Z��U�3Y"���7��. ��k�^�Ə����?䥴5���V�ISm^�"F�ל��=��Y�=�q_�� ����$L橼��{���T]������n-�t�b�����Gv���/�#eH�=��#_xɐ��$��8�_v��d�����G�N�}����(��0^�������r)tZ�	#�R4ٽ��Md�?��j�3h�n��`NV�����+�O���8G����ۘ|f��VK��Q�yD��%� �"V�7���rj~'���r	���]dD$?0����$���`]�Nq56�S;��E:�ң�`�M.>K��)Rڳµ^����K0���e���1��VیS"͵��/�ȗ� �%�+ͻe�g'��՟%�?��zK|hM���w��u��tc��O�����˸G�e<h'��MYy�b��4�����J�7J�;9��s��(�6�m �Zt;D���R��|�d<r@�=��,��i���N`ɝ�F�x�bba�I���I��8�؍�iEJ�D�x���u��I]JH��aXowp��U�����qo>vAC4�tP~^�S���&���gs�ǉ�����==,s�������wz�{\�5#9�@U��Ϛm�lkpi�;Sh,f�����j~�p�O/�����}��-0�b�� G(�P/�b�C�������>��{4^�j"DĦ�3���e���w���-ES/�m_���y �d�|H�(��<�w���)��XJ��S�s�oqѦ�m����o��i�aBC�zj��k�T(Ǫ�<�~aq�K�{�6 H����2]�D!��$;�"`��1���@�29̑��c�E�G�X��{�t�Kr�6��k��G��Ŷn����� �<����Q�ŴQ��%�[�^Y�s	)Ԅ�da���2r� ��鵧½��ŘAӻX�\��7>0a�4sQ��ڇ<��&I�ޫG���%��Ⱦ�H�ͣ���V4I­m	���S�BYM��;Iz���^lr>@Ԥ��RJ�	�m!�$���qVPK������;���������R�Y�Z�v+C�)z�QLe;�*P��,w��%_GF�#�ÿ3B�ZM`�;F
0˗���&��J�w��1��a�w!b^�(Ĕ\l0*�c��c�S �z�}G��b%Nм2j�Lz��	3�HB���		DE�=@$>!h#�&rJ���I���[��D ]+l/{����"|E�Rü2	�z��%�;D9���G6�90"�}����";��2,�~�~�� ��@Z���R�ɽԪy�@Je7�������;Ͽ{��������k��8��*�-�N�+]��7|���m"b窸��+�v��ɥ�� �+5�N���B��6�(�b#�p������l��Ɵ%p����1��ϦҦ�[7p�;'�V�>��<QA���*eY鑐6}2N$�t��`��n�I�$��x������vf�:��̹=׍g
6��2�|?�|G��Zw8�י�-.a1��/W;���˕g" .	�pcq�87�	���o rQ�!���3����;��} )X���l�Xo�|�@1.k�f�3uT�ʈ"�֝��&�+��[��Tdx�/�cR5�TU���O*rߤ�\u�W����TT�5�!,��v���-+^��Q�>������?��+ُ{Z���g����\�� ��o��Eu��Z��1������+,j�>�:�G����0�A��=�ы�#⦣���{bsݷ]�V���J��×~*S���z0����:    �k�i��x~i�eCW`l�y�m�s1���Mf�4�`�֝��-��2����,�3��md����MdӨK�Y��{���qB'y[}�_��ռ� ��Oʦ��&q�BΒ�D���n<\/ '��D�q��mJ�P�G�7Y&/t�oP���7w?��H��C3�$m83]����9��J��&��[�Hn<'ǊFַ�x��ZD>�<ſ�Y<h��E)�Ą�>'��#�.������ ,�O�:pN|~閹/6J�yw��X?j�zS`��y���!�8��Ъ�g"�JtV"M�y�}��*�N��x�`.	�,XݭU��s*W�+���3�j����|P�<+2y�̅�9�ު�L�˓�Y1�N���$��}S5�璑s����E�; n�F����& պSu���sq�b����I˘p�4�3�۱g�uzi��FV�D�IO��������/~���ӕ�GQS�4�R�^�~�~\ћ���	���	۽�z#˦���RbF2*��4#%��;�W���=b	ߒ|��n����� �|_~/O���}���yʭ�A�i��e��eUb�5�ҩ|�Ī��l���]���tݡ��o��nWWB:_uNnf������;��s���h�L���,��c�c��\�b~*]��G�h���W<�4���ٰ)8ڷu��'oD�x���fC�no��Bu��7���kj�z��i/VR���k�`[�Ԟ!�b,��X�ߠ� Ӕw!�C*�����>�����n'�W�*Ka�@S�o�2=j�ߙ婘Ưby����g^�)1�����$S����ǉd��p߫Z��r [����C����	�.8_�l��(��y?�:��Y��á�M6��M&x$��)oDTsO����)Ǥt�I}
N�w���Q��4л���=;s�m�;����p6ޛ���':�OHK˘x�՜��&��\\��c?#XB���VP��tp���"]^QGW���Ϧ�o{}X�4B��Z���_��x�[��J<���Ϡ3֫���Q���1�w"^)ܦ�{�}�]~+<^��&�UM��e��l���j�m��RN���\��|G��f��L�=]f�э�j�_�:U�	rX�����[J�(��O��R��[O���"��"�4V�oҌ��}�rV���6~F�B��A��w��M	�9  J�}�mUk�T�cb�w����z�9�����d���\�c߯�@�_u�l�Mvz_z��u��}!��N��S_�ƛy���d�A�K<��T���&
�5��V�H/(}÷M��]%h(��j��b9�#�A�MD^S�%Xk�*k��:���N&�"�nb+؜5H5�dlz�5����y ޗ]z���td�F�y+n�4��BR�d��x|I�'�:�AQ�Z2�	hB#�4/�P���f ���^��Su-�^b�Lz�ɰ�dY��܀h9�k����ɅN�_%5j�l"b�k�Cd���%�K�5)o�Y������r�]ѨFD�� oa���J��+�����8�kF�%�8�>�S��B{���P=��k[�[�n��O�oG��	m�W�����^�_��ܤy]�Gv�\��n{Xw����%fE|	qr��Os���졶ga_�4*�ܟ��]�^�9������k�%��U#^c�en������Z��c%prZ1L�6	��T��v 1ެ5����"Z���*G���uVd���~)�J��xI���]B�#/�i�<���ͷ��V;n2�mc�A��A��V�!%A����C$X1��5��Tj3]��⺗Uc9
[����k�J�Q��f6�#����z���oVs�ȣ�cQX�ll�x�����~��cԏE ~є��%��с��	q?ͥS���v�~%����ӌ�9�xNV�m��U�8�$\Dc6������T��%����~�=�c��(�|�Gr[g�k��Fs4���ud�p��~f� �)C�@_?����aH���0$�""�� �b�o��"���''�6b�~�%���ш���6u{���-���O<�3XGh6���,��G�������J�4�s�]���Q|�Zg="ٓ��TT{������"���>��H��s3����������=���Ӧ�n�k&mr��m�A��Dl������?���[�N�~|����������A\	^5�=�d<��E����ݖ;����y�����N}���.��eMH+���%�-)p�eL�cP�O�w��	��o����Y J:>�;�l��UJ'Z3�4,<-^���Y��d�^fD����@*l:�WgS�X
��0�>��Wz=�MaPu�Um��}�җ!����d��q_�����R���﬌��X>l$�Z���������`%!ո<+g`� �q�Zh�N�CV�!�)�.m��G��W�Z�7A՛�Z4nur+�ح�-ե>�Doheӿ%ƌ%���[m��n,��ޕ8��d���yױ�h��N�G7k7�(���#e�R�+ꒋ�������Eq�~#�R�*;���C��	�=�ۛ1}� �$fPC�ε��o�c�d�(�0҆K�)4O��K&�[�sp������ΚC��=27�;�a���;+��T�U�7�}��gfW	y�=�O7䴽#��z(s��ؕ�3IJM<�.�����p�Ͱ� f���R�0��(U��ʿ�����un��G�u/և8fQ��O�I1$j�5ۅ�L�v/�%��������H�����vA�p%��7d�,�n��sq�w�n�7��%�($ˮ��p$Dv�s��p!ݭ�^�;2���L�+1����-<��ؙ��E�W|�b>_p�V����x*?�$���$�{���m-��Y�v4e�=�ޟ?\0���� ��&����O~���f<��$hE�I�_xŬ­��0[~�|R�9^������w���f��MFs/.�wPD��ks��i%V����օ6	r�qw�r��`+vե��rM�&'�{ޠ
�Is\-�9�{��ΤB�C$�_r�(�E8�+�.��$HwoM������(���y\���ZE��!�zJC�bh�ߪ��3�{}�Q	h�[؄��s��f�X�n��hv��O?��S^��I���cU2�΢5U��!k�V�'�	�(����>5����n��R����Zy\ʋ� ��X�4�7���H7�"M��I��
o�~�N0+ Qg��C��'μF�bIq�Qkp�DN_Ri4W�%��ð���v����D[�p3ob�As<��y�(X��jW��ߑ7���ח߆t.� ����r'%ՠ/4�$@Jh)�KPd�d�xR�DA�HW�@F�W�KW�)e���}���̼3(��A^ܤ��1��߫Ŝf��#��ߖ;�3��7���C���dL_Φ(LsH�03��]��kb�,�!o��|��O��l�s�+����½�{�C#j�m�~�s�'n�ךn~�)x8�({Gn�rɇ���������*�D��Q�P��,D�N�&��l���H{3�mX$�y����MA� ��,�ͧ�t�����7+�"ȡ[N��z��Na0#����� /`�`İ�A
�_����9����!s�2[�z���s�����RK�z���nOW������9��Vfܐ>,�E�w*ـ��_��*�3���N��%�+*�%d����#M :����I�8Z����\�ʜ�5�O��D�<�^�B:8f|G�`� �U�0B�%����L=��f?wHz�hqs~4���vw��^a!tt�ݡ~j&����S��R\�t}fil|�O��u�Bf��')���$��?�����1�)���δ� �m�,	��<_���E��+?�"1�`<Xs~`�����u��忡�eZ�x��۞m�Շ5��۱��<_'U#���Tڠ�=�7�4�����鄓wN&?�_qM�_�x�ؐPK�_G��:bX���~C�� ���%�		s�W\y�{�{���s�^�R���:O�+�g-����ܩ����8���b:-[�����j�;���yz� �%�?�    U��ee�����)��kƖ�~v���(��_��?R�P�����f�Q%�I�&���������������������%��AWMfSyYm�I�՗��"0!Sw8��.	H~]a�=F
̛|�j-�%g(y,�f���������,�l*�J�GL��j�T���SK�̟~��d۷������mjm�$���}�1�~O� �@�/����,���a?����R���!�#֔G���!ag�UQL��u7P�C���joP��Զu�����I�öf��������7���*ă"�R}�'l_0u�)�某� ;� �5�Hi8,�������^Ϋ���BwF\5��v��;�E�3�C�U�v��|�"�{Rߛbֺ��Oe:�i
���a��r.�i;ӰI���K�<�0}�j�~���,"A�M%F��j��q�ݬA�ʻ�c/)�Bᭉ3���<���^oB B���*t�G�?�N�<-6�U/�o��y�������=N���b�
J��/�g�6��=LS�ͬЭ����q����f���>�:m�#
)�w)�5��.�H�A0�k��$U\t�����;yLw��ʞ�$��[*h�l��G��!�u�P�����c�>����d�=����O����us��撵6�gc�q���@�H�Z��[�=���������7p� +�L���Fߓv���sZ\)�>���HȮ�{�dl�T3�ݢ%g�Z��9�_V���%�M��`��@Z�}����<*D(S/��ЊN뙰��b(��rw��8��d"�����E;}q�9h̎�f�uXvV�0�:���DU/.uPzU̫�z�=���8�Jp����j�Z���sw���+�sM�H�u�}F5�����-* G�?��Z�&X�gG�ݫ޼ ������A4\F{���>$�Ǵ�9JP"Y��_��m7	K�˻f��Iq[��B�܌|�^Y&�cR-f��<�"��/�5���-r�iS<�c�ݭ��o���v9������4��D�0�;�GE��kma�隀v\�y?���v����.����[H�[�57�nQ4ÀJ*igg�gz�Xt���<EU4�e7<�8�M��%A��^r��k�%�����nVG9!{͞#8��y!u�LS~r"����W���ʅ��������\�T̗��Wc:L�A�CM�*�S92�twߏ�L�0�M:(҃Tр���4p�7�L!�y�����p�vLd��I5�S��mgH���B�K��DH��ҭ�XO��ȶ�n���?�'U,�e��x)g�k�j{i.s�.��9r������ �W���wZI�5�l�Dnj��D������$��W��n����`�x���#K뒡�̻����C�-�ߔ\�m��WV�yA��}�|#�ǽ��^�ӷO]Bp��u�+�v�l�w(���	רp8�q9��S�̹G���5��V�m^f�
�0������E�|��=���y��t�w���ؑ��d��y�����~��k�,�	�<FIvHs��Ŀ�}[6��/T��Z|Y�]�L����ߗ��!�n6g�(N�W��a�9 ��w˟ru��mp>����>��r�pU ���d$���Ox�R�ւ�԰D��o��𣜰/�)lO��3C�� k��뿠��z_#���1�G��`�#�ۇ>H�nf���U]D��K��6^
�hc�P�v���� ֚t8d�5�`����?�H6�������Ǿ^��:�/
莮���*?A��{�S�Z�	P�2�~ �[������=s��q�I������x��\,5|�X��v��4�>`�l;%�|�Ӵ��2F�*��\���ԻI4�(��=��g�!�K�_l��`Y�ܦBݧ7�K����˩�Zof��`�g=øaY��S�S�w����A��k^�+a��Me��uG�;����*nن}ߩRqؐz�]bk��� �:���˹,��|�����$�4�-Y�#U�)qM�m�=�i�$[E٨x�&tHq�[���j�w��R�F���vv�}b���~�C�n�.~���}X"y��6r��q{9��!2�����-u=�#X��ع�7/��e�"��U�W�n��X�W4KC�2S�F��ې�V��s�kf�?1L�א��ӰH|}٦;�9�1�ϰ$�tW��/��xP��5�pW_.4��|�v=��^�m���
��!%��Eܸ�:)S��A">��U�CK��[������P��W^�2͝��;��(>�5��nC�*F�XE:\.��M-�F|�M�S��w�G��r�c�ȦswG6���p��Y�$k�P82l���($#jV6H�_~�q>j_:����Ա��q��mX]\�4��/.��=�+=ȇL�[�Y�s"B.{\Į�C*�iQQH�B��ۢN��ϝR\x;�!B�d��kT��D�syL��r���[@d$�5����T��D�E�
�4��D�=�����-<�b1�ݔ�r׭ڿ/�On�Ͼ��&/���|
6iO�m��T @6lN�i�{��Ѱ���O�XdeCM�'��)�v|[G��Ep72�`X8;�W5�V��m��v;l6S�>q��rGH�0��b�J�h^V� `��N�S	��$���ӊG$a�`���!�K(����i��n`���n�>EF!) �Ǆmdi8���3��D'��Y��b8�ײ�M��g�]ޤ����1�Wݺ�z���;ǰ���2�w�-�6��}���kB�2�����E�mQ5�.���4@���˖���m�n��uT�N�LA�?JE="%���J�3�C��V��n�v)�N�²� I����W�[�n�,�&=^�b���E��V�V����$��_G�l��v�s�8]�l��g7H%��*����KE�b\����Ztpky:/:rL���n��q|���v�]���W����=���Da𗘿��u��
	7�߷�ĸ��;!��g�ܫvF�����#�M|��,��W���hv��`S(�o�~�M�)�S`,A�e>"<���d������7�A��{~_���h�~��ǮT�4Ty��Q��-�I�j;���yJ���&��s�A�!+8�W�_K^CpZT�՝�`��S�Du�H$�f���H?�;�|Q
��/�|�@j��Dȕ��,k����G� ��ó��1��S|;.d�C�^��0��t���F�uv)�Y�=ꖼ��:�د���E�%IOe%p]{���>[��D�~�_U�˻kx7�l�x3UP	Yc���1����g<��ׂ�,#����9T|���.����;�|7`�"qew6���I���pp�Ǫ���#�o8��1%4G��!Ӹ��Sʀ"�<�K����:�ԩ�3� �?C�����]P�ӏ�Y�k��û���i�A�H��2'�o���w=Rm؎�/�8�H�`<]���ޣ?<���)���w�>'��0��f|��u^2�B�\(���!�&m�F�@���aI��Ӷ�SzE��&T�!���1�H��<�{ؤ�N�}�D��Z>~��^��Гo�W���4^�t ���c��U�TG0B:x�SU�P�RiH����X[I����+��"��~wY�^��r�"��<8ٜ��i`� ���I���9�FƉ�&����Q�r�+c7>'��ľ�)?�3C�JH�D
g���=`�V��$>Q&���P>[�C.6ѻN�*uP��^X�����pqv��<Khj��#/�Ww��l]н�֟��I\瓁Pyސ�z0�a�;����;ڕ_g<!���Tc��r�fD�5�G�4+|t�X�?��5GP��0u;�K� �x�=;L�)���G??�H�V�t�q�t�!Hc�2�����Eo�N	1�w���{�����f�K`�hw���4�s�p���Pp������w'w�ɗA3eQ�Jr�ؔ^�7PO�}�y����T��ɮ�>�^-s��r�����]ù7A�w�^�'��tJ�����S7!/�����*>^��Y���Ȥ��S��yD��S���n�E+8�?zܾ��=����� ��%H��QB�<��    �Z��y�s�!�����]��x�m��FI��<V�P��@5cU%��g��7���x#e���o1z�B�k\I�=�����	�􅖐}^jrM����9��X|�&gi) '�&8R9Zsa��\��9�o>q$��W���(_G�:�y��z3�y���1&Ri}(w��<��}�ӌ= ��W�03t
��mUz�s��;Q�JUy����>�^�`�C6-ǥ4��*��اp���x�?�B��.��j�TUR�aӕd���6��M�(W�zk�{����Zz!'�M���d*���8OK7mܛE�#��S��^������Zٺϭ�Ι���
���:�,���_+L���xs����
������
�=�溞쫷��j�w�� ��M���q�y;Y1P�+@=4I�������Y��'��jG� �p-��gɐ�W�0�kW7C�@hF�7��lK�D�>�����>�E��o�+�N�K��lg�4$X���3�h��r°0x�?8�'W���Y�ŀ&�W}��拚TO5����j�D����R<�
~�;ٰ�m��3@���o&�oS���?�|����R�o0�������[ι_?��HzX�9�~�AIc��S#��>��<�ŵ��uF�K�o��KUJ�.!�rW�}��+�.F��E:��K;�L��rP�:���$k(#��'�;���e�,�{8�HV�8]~�8�gH�׭3�5�M��ړot,����`�U"9�b\
mm��A�Eܤ!��@�^W̧%�k'���C�\��\t蓻㷑�I�a��8��rhT6�7i�$���DLG\��e����O�y�4�]�x��iq���	�T�����_��EҬ�4[�]�Z�У�G=�G�����"65��B�w>W�]�/oU��9U��
� ;8��]�Z�s.�}S	u_T7[I�G�:�9,i����s;<&4����4k��>��ȍ�y�Z�7�lo�0��;=�A�\t�3kakm��#��^�؋���t�>P�s!���n�o�{M��H	��c�F�������ۥ>��t��%�/ڞ|���43��e�=�'�SD���ݚ���Κ�C�>U�~z�*�UQ�U���7Smpӵ^����@|Y��F�y7_�����������蚿x�D���X�p6aj$��#)3q�W�f����z���UU���~�-B�2�J��#��6��ق�LK�
^|)�����wY|�h�>�BbuU�X�卑�>j.�)�x/�G�<IcF$�B�oG����`���G�gL���^~�<����U���=�0.Rt����1�B���N8�r�qf>ݽ�KH9T<a�(���:�X�u�U�1������N�6BwT���S���7wr y�h��f�R�q��U'�%d�վ���G�� Y/�y�ֲps�'�d@ؘ��a�f�c�1�'�n��{��U�����Z�p�7�D�&�4�I�ݗC5��=޸Dg��yR���q�㒽�O��NA�FH��Ru-���%�7�)�}P�W�{��lp6�=(����'��[��s1a�����q���h����tU���?ʝ/��5E�zRX8u����Ůh�TF��ԃ�~���y	���$���L��{#ޥ�����le��;n�b����'u4����Q3o�p���@κ�HU��8�~R�����<\�.V�чz��9�y�M� g�1�ؖD��I�4����q�������l^�g�!���<О��^Y�2�W�'�dr��[*��Y�.T���C������-��o���t �.�+^m����2��pb�;�=s'wHxH���Y ����D��=+ڊ�?�4�+0f�����ռ�
���ٴ��58��/�d��f.�M〣��M����qS�u~��	�J�4c�g����u9�?#�5�m�yn���{�!�txˀ��n\)��6L��j���K??���Vs��{q:ٻ�a�Tr���2 ����6/�5xr�,�썸h �+�A���)BHz��F:ɨ�����l�7�6����eQ��L����N1�ٳ�PF���̶Q�f_V��5�����	�c�S|��Q#��xc��)�^5�v�5�A&��O<]�ȁ�0i",�^kS(�W�:BȺ&$ޮ�y`�E�6�o����[6��L���f1j~�{C����3K?\�kvM�|�����b���b�k?�qy�^A��^��s�y���T3)XMl�}�����������:��)F�b���Q1��̔��2�~�ͯk�If2�3����U�f��A]�5���0����o)�e�K�����j���!��b���r��4����������߬ ?iG��0���g(k���F2�D՘��M045��!)��^ط�Y�G��C�$�r�}�57&\�������J�/����MM&��Z��|7�I�R��$��_���$v
��S|K�F-Жn�B�C�Ǖ�C��ySh�SƘPe���H��:}�^k�?�L(X��&Y� �M%�e�����9E�^p���x���\��r���$���mz��Q�~�!z}�P$�Z
��������[V��4P��q�'�G�S�[ɠ��dC{;� �CD�Hy4���J~4½�w2n����n�+��wri���������� �����G?��E�_�$Ǩ˃����s��&}���S�Av��@�|�X���ۘ���GX��U��i�]XS�ٿ)aD#���y��Xodn�wt�_��0��jZ��Nqd��+�m�9���o��������Z���'OZ��=�_�¨W��v�l0�6���0~c���Y��F�ȅi�\��HGrKΣ��j�ƣ���+�ط�u�ѵ�Q�>����`p�.T���PB��ؑ���Y�������i��0�{_$�)��c��s��73~����v˅���%R߀�U�/��&��/)9=S%sD���n��J�Q��l|ެSt����Z�P�D΁�BP�{m�MB��Sկ�������ǋb�ÉaJ66���/��u�tY}�c�Λ��Ĝ������C����KRw��,*�tF:j�G��nפ`���H�C�H�~I�h���`���
�JhMV����ymB��t�4n"fr\��u;�ޜ�g����QM��6���O�uM���U�\ڰ�Ʉ��>�M7Ŵ��;�X�Ͽ��i�'���8
�f�^+��X�0�>���"���-~�j�qy����ɲ�(��ˠω=���-��p*�ёn(�f�a����Tt�X�� ���2R`}�Z����촥��{y�)13���,�Mc4:AYFZ���C@7x����+�V�^Vk�0T�KԠl9r���f�g��M2]�����Z<�Ƒ�Y��R)7�Q��z`����N�%4�km��#Zυ�qt O�L��H�s����'� �`Ң&Z�m^xT���A���vN��1 ��(���Po���%�:NEbJ�t��J�k�g�r�d��ަb5N{`���K��W�YGa˹)���a���g��}��/��徇7s�h9��ɥxv�K��5{����W��l>�B>����Z>(H��9��_����P��k���w���KVޤ���?a�l*:��1�3���#����Y���
�.6�3!���`.p �b'6����Y�ðS]��X���8(sM~��*}��r�-iC�6�6�_D�	ROܦ�0���d������i齲����FDK�/��J�Qn㮧�P��Pσ��X���{�v����*=��ܯ�Ȧ�W�ֻ����<9W���?��EOF?~�<gV9� �@cZ,nH��$���y��I,6m�lB(��ȍ�n;�I��Z�h��#M՗��O�5�@qtk���}���	9�&�6
��Q��P��*Ĵ@���"�of,5�aʛs��;�@Sp"7�̐�wr�٤�F���h�����/�����5��^+�l�z:š�z�����;� �W8 �9�S������J/��m�m    aȚ�8�a�7I�Ͷlۂ�e�r�?�iu�5?��3���ݿ)�B��3dx�Z�B�� P8�8_���yژ�~Mz�\L�L�}gf0��wjf�a�z\��WTL"�7�-C]:�V�<����(6�$T|�]h	�!�La�}ǡ��Q��80����k�/���"����%/���Z�������G��9�4�)/��/p��S��r	>�@�8��k�EK8�;\�6\�eJ���L� �m;��	��Uԃa������a��0H�~j�}�҂��&�>_̓_���"麼}*�NC���Z'�L>0�[�xq���nitgT�`gq�� 7�|�0,�Z�F��R����%�P<B>�}W@�~%�a�G�0m;�k�-�O
%�VK!��:[&���^[��w��p�ҝ���T޶t�"&v��/�/���'��pS�����I�o���$�^��&�ַ�p��l��L4H�
�
��)p_绗`���r�/F����"���js(�@)�2c�"ˍ�[9d�^䢝u.��!�k/�]�a��+<yS|���q_��)�rݩ�g�oU�mz��zE%ī�MZm�^��?������2�2�������>oH �$��@�{�_��s)�t����a:.�c���Ę٦�:?@+z�:� �Ԁ堎�6����3-���ݬ�)�w��k��C�{�S����ԁ�Κ�-��4���&�3LZs"�z�d��ND?�)�����8`�~Ge���g�=����k�.ɨKR�ˡo�W�ân��e�\ZeQ4��`�#>.�?%�ֺ\��LL�RG%��^F����s�қU����U�1T�4	&��tfƛ|ͨ0~�٩
�0d�7]1���R�Hƴ�/����2���TT5g+h rژ���	E���*��}�o�J?ͤ*�6�D�+��~��	��V7s>e��A�1?+��,|�_1Z�:-����7A˶�c�yJA*��gZ%���4U��H����2�ߌ,�W��I��+u�y�=rjć����K�w�o��t�[O��h뿥զ��/��Ͽ��?�1��4����OVDG�D���n���k� C�x����v�%)_��0|���n�S%J��v`����29���y�h����H��4�k5�iƚ~X���Zu�ɶ�ɗ���}2�+&���ێCH��䏣g����%v�$�+BJM�	%'��`�cç�~KN����ģ��b�������f��$o�ӄu�d�"@�����_���a��C�٨��o��ěM,�a�D��Ysa�"	�8���1�\es�I�����.������d�C�s\�K ��6L�����n�d�N�QL�����?=D��	�7|�����X\"Vf�x#�	����%N-s}t� J�0���ی~������\��0��j��#)��E�8$���7jX\Ȑ/��\j�Hp���������l� T���|C]�.;S�ڽa����}%k����e��xWK���4	FO?x-�Y?����[]�z �>�F`Gfm%��yV��=iz]��KLR|���Znp�M?~��i�
6$ˮ���"z�Y-�0a/��08�YاC�1�� *�ܾ�M%�~8�����j��nS�)�Km=�FPL��os�Okz2�Ҁ���/ŏƑ_�4��L��o>�v�;�:!v��B;L
�0
�.�� ޿���V��I��GjZq��N&��U�I�ZV�O��l�R���,u!i��n��]��i��s�4�ql&��ɫ������J�<$Pz���S=����;
��թKrE�����_иO��v�N䆰s�u�̼+)��EN]N������p�ȉ�(D�-l��e9��=�u0����N��%�l�(�5*�u����~W5���9��r6�*��I��rT֮4�a��<>uE��� {��竕M����i
��&t>7\i��ǢM0�h������f�������ԯ�i��[�"Q��V�٦5��7�\�է�r�����h!�f�`-'�r?�7b?tvJ�_R,� `�/��>rtҽe�9��G& �}c�~������[9Н��[��uB,A��tx<8m_X$�q�m{����7_�ᷫ�����Xw�o�B�6��[3e�|���7���D&W{�% 𸬇�S�0�嫫O;����Zt����w��}Ԇ>	�nE+��͞��U2��R2;.1�������i�o�*�pG�3��-xE�lM*�VW�oQ�A��wQTg��I� ?������0���rZ3K����X
#���@�8��������ئ��J������\�<pفP�茙�|��I:�g/�iߖ�J����tP);h�ٜ���^	��>m�$5p�������\׭�v�W�h���@���~���mN_�F��yEA?^���ߪ��m�7�~�*���6�}�]�}����L&�o�o��N�	�x�6'��8�X����|�)*'!�5��nKη�C���q7��9�Eq�A |`.N8H�Úi|��.��a�A��b�����٦b�MzHŲ;�G��P��e��J�/�1��%{s�$�T���B��=Į�f��R��h�[u~�;>�	�@,+��b)%j:1E�4�R�݉��aX��^fjk�#�R_���[��N���b ������c��N�t+5�Ͼۻ�;fB��~I��
��#x/�ZE����w�p����
���7߈��d����!x&��Hwe+%MXV��V���O�۴�������i<���Kt���"�=G)c\ۛ+�8��x�H��?T�A}斶�o/�����$�]���hO`{�F�X�U�Q�N&����҂�ZF 2�}0�✚�d�Q��q��{;�����x��~\�����N!��y�e�G�����P��,�$+�;��n{�G��&�K.�.����-b��Ƣ���f.�7@35.Ӿ�ہ.-Q�x5VU�I$��ũ�$N��F�����*����b� �V��Ĳ�(�o�W���y�ep�vëKD��>�{�� �W}iA��,cٹ ���m������¹���'ڃ�#$2:kq�_[Ǵ4Z]:J��n�kF
�im�lƅ6�����L��}�Z�ԭV�abZ奾 ���(��t�a�7��"�j�H0jG��,
آ_L���l(�����W��.�=��DlMo:@��E��?5ű���שL	��#��Q7���E�Q"���fɝa#oI����T@�*b��8�)5���)�}*$��&�u�����C��4��t���4O�9zT�92(`����|�A>m��_˒�6p���,�x�9�����h2iyI�:A �U����B^N������?s�������d��;y�Z�s�PI��뾧V��9���,Y���ޒo�*�����S6f��I`,���W�ç����4��*l�7r������J���Q�-�fm�+�L�-����V�P0g�Ybpl��b��ɿ�t�*�`j�!�g"���x�)2���[؇��j��{ �iK�Y_�N�D�%bN4#r#L��W�K�g�$����㉡I!��!µ?:Ǣ�>K�t �0T�߱���)!*�l�H�@��G�eo�����)ު�������$M�� �dUߤ����S��mB��*'��	��K����[����н4�>eTb��W��PW?����c�?��t|ӐP酂����p�Xrv�ܶ���"X�:q5��-3�,u>�Ր��K����ӊ[�A�<Pa G?6X� �R��W!:��Z2� ��i.Ec��7�~����.�����Z�>j��=���8	({,����q=��}]��@�!a�ZK�/��'���{�HO�a� ��^��e��k'���%����������d�KP~"^+?f���ꡈY�n�.m����)���~�Ơ�V���˛�u��������E�*�|X}���Ys���Q���=J�G�9ʉW��hFv�.��f�N��Ȩv���y��;�9���}�35�_�>=)W�-�!�A�zǾ͑�Ĩ+"    �S*�w#�L)�SGJx��Op�4^V���-lx�׌�hMw���FQ?}�8�]�T��,�h��=dx�ۮ`Ү�ݱ�ym���%N(��ZI��s�����B�O�4=3�I��2��yCg��=G��.o�](�\�B��C���d8w�����e60����#A�{�Ҍ�s�Ŝ�:�*�����R��CO��\�Nj5�j4k�bp���Ma�I�ƙ��	� Ҳ[l��z��\��T��Xؔ��'I>}߃�j@���A�o�x�@�E�^�H�T�&�6�ʙ�n�	�G:�(�+O�h�Pt���L�ߗ��m[`�N�ܝY-u��!n֧*�S��)z��(Q�d5��V�ƻ��t8���l�4�fc������zM���o��51S���|x4 X��4|Ș����C����Bݝ�d���1��Հ�}9�>�_TJs��#��%}J~���+�$$g/B��w5�Tc�f�����q��IE�r�w��>Ɗ��`1�ت3����,9�l3��="O_q�1�|/WJθ�T��n"�$�i,c�S���g��eu�����h/m�z��І��Y��7����X��Oӻk�����g<81�"Q�A�W�
\Wq�9'����*��;8�uYWi�|E��a1j��1��95y��Wn�)�X	%���/��6�s���1�&x��>샑ޯ�}�ի�#� Q|�C������^D=��T�,���ၒ>Q9��}%�(望V�3_���_ګr@���ɞX�fOi�{A؟�c�+j� 9r�7�%ߕA���ߍ�>��o�ج����<��soX�@{[椞z��dzFAO��Ҁ��/�r��W̆�i.��)��nY�o���R��d`ëQ Bjz�̀��'*����{p~L~���6<�>g�h��s�ݸ�(��-��yx�ǒ��w�m�6�d!�Wܣ���:e��P�_5�y�w��s?���&������C�0��Ժ�I�����Y�ƨ���HU���~3b�G0�"���ǉ�Pi{��r�^�k��j#g��H%+Q*�~)k��XЗ� =�ȉ�&�>%��3�u��@<7ד���n�8�B�t#!�撌���=*���Y5��`�X$��5��ٯZ8_w�%j�u��"����+���|�;�G`�{e�70�Uج/�Qu�"����o�hي|��;��������ұQ@���%L�~�Ԛ��	�u>j6�?�P�W=>K0�omo�Χ~j\h.<�����l�$()/n[S�U�/�W�|���4����j!*�����Ju��`L~�0K^���^jC��Na���uk>�%>VM��7��d�L�;��ι��F�G�׀���b����2���|����}��c(�뭆Ex��cO��!����OC�S���dʭ���!�̡��Hc]a���%^>���#Mdu�b�n�˸�=��U�4��1[�-�+����g\�A����zj�B%D�����N��(��\���\����r!�A6���#�8U���!/'<FJ�D���i�/V;����1p��!0�����{}؆?��je2���3��{ZR<����JY2��jJ�y�� #�k�3�铍��$�[L���cwr\�
�
X�c>ūa#�S�>^�`�=�����<�C��*VxSp��-��{�|�!q?!����q�x9m�̭1!�Vt��Z��^=�����9��5���˙Oo�޵gaj�����\!
۽5��U��:����χ�i�Tz*��T&�4fD{�]����_=}¨�]��G<��A+ӗ�W��86�@=��E�ej$"۟������d�Q�N�k��#i̒�i S~�!=S�����s*�tk��"�M�Kb*��d��᠀h&H>�:D:'/Vd���G	0���b{����.@$#��P�⫬p'����ۭX��n
m�[�	#dU��t��'t��=X���!%�����o�y-B b	���I�=����wVW�%	jU��xc��*����"���~��`��MK��x	q'J�L�C56�Й�s���n��q���~�Lfj^�J,Vi�5�AI���,��/�i�=eo���FU>A�� NP�ޖ���_����%����dE�|�Թ�`d��V�P$Zw��v�1/�>�?A����Ŭ�^_?�U�lۢt�nܞ�_��55����,]&xk �N;dC�ݬ�0�����_`Z��	���"Hˣպ�����,�t��Y��@�<0_զ�����������iƏ�Ě�_o�tD*!�TNt
�w1�0&��v��P(BU{bC#�`C8�tZ�0����/�h�8@�G^���ٍ��7[YSm�K���*�Z�|�86)ǄU���-[p��/C�J�J��4w5䧦1�ǅqW�)Z�Z+���T�5�J�_H�䠪�!�Tch�����0ш�f-o��d��u���t�d倲��n@��:Q�kk���C$g�j�D��ġp��ށ~r��e��$��μ9� �x�O�0���aλ�s�=X�Vbz�Μ�v`Ub�0\���9,��FC܄��{��B>U袡���F��d��5�5>�I^4�������К��2�@rx��7�=`�<����e ;}[�Ն>?w-�y�I��S([NdT2i���o��q&C"l`�VR~��#��C������s���߶�*_P�}th+���:G�4����9�夾�X����w�M<.���z
Y�Jˋ��ET!��VF�o���H�=׀�#aaJ�ȗՕ�s��@<�(X��Sw��3BFи��_0%L�n ����Jɑ�@f���v���%���l\�zL�*͎����`������I ��h_s��6��ڒ��"C.%����6%@�T�l��\��%~�T�ǜ�oU�M��7YqʝzFL*�Aҏq�.a�k��D�^CpyD3h��]ja�j6��A��5���� M]��c�����츞h���_jw���Im�at�����믑�OK	 ��J��/g*�RW	�Qc��뀗����<���[1����PȩT�����!�v����ίB��_je��g��;��)��d۵\���l:H��@�Vl Һ�=ؼYpCy�K��S�2��'f|X�vuR�}�:��V�f�C��FC�6������:�۸ҩ1���E��W| ��& ����l��/��W?��6tm����chm�uǕ��K.eq��e���Er>�X��W�:��V��X�Z�l�5��E0����H����u���m�SH�q��6�z��["�idQ'aCר�0����T�-��WPӼ� ;}#�Mَ���2_t��Zf����~�� ��nc�% �=��F\?� &��W�����)+�'q��@7�G��gS/1����YɻPa��M�T�B�z�I�i55�6]ֻ�Z���I�*��F��Y�zRd��k�����?� Rị4���̙!�.h���
!�S?������!3�T͊~�-^L�7}ؘ�O��:dI�=�L�#:����}��7����n�tA_0�B�)�/���f:�*Y��n#�z��d;yq�'�,�����
��Eޅ*�y�(p}�`�&�zHK	fW޴��Rg�*d��]�����x��;8��N(8N���m�_��2��a/�C��/�3��=�_��b��g�c�h����D���D�D�
�Uǎ�D��Svr�{^!%�����J$9��=DƣL�F}ήJ�����Km�L������D��T��x����@y�;�A����κ����2M(�ƞi�S>���'W"��ng��p������2y��i'�S�Y��\_˞��=��y���Z˲ɤ�&����t�u$������iWM�@��&��E�r��)%lsa��v!�z��>%Z�����]��qX�!mJ�\����6��U�`�=8w��Y���k�jQ^���T�<[?0�̺�`����"N"�j�xWB�`g�=�_�@��*K�\r<UOr�f���ma9�:6�C    ��6��!�����2I�I�_@@�B�\��i@n����`L/,�4�@���mg޿D��x\�0CBz���m�GG;cEH�/*Q^�
O�@m��h�Y��G� `_6����=���m��60�Ϋ7`�Մ[�d�IDϯ!xs��	h��<�c���;�#���|ւ��mh+9/�3��f5�}^`���xG���l��u�ڂ�7��c���+��[�8�S-0�V���n�7�R$g������y;V�g����:%Fdyw�L������ޮ$"P�Fk�ek0Z����/0��8�Vs�/ȴф�@h�g��N؝"�Ǒv��
s$zi��~��6k=��ě�K_Qh���	�2��,rf���!֧�Ǳ����m/E@�W:>��Jђ;��E�����*�6���.U�\�|��?V{+n��M��/�$=(yG�]�0[����G0�1��ă<f�+���H�aET�CI�gS��ql���H�^�����m�Uh�a�>�c{���b�����j�F�&������g\�H�o`95P��o+�!P���}ۥ���Gg�$)E�b���B
�R�;|������|��s�L�oq.���4���~�c���l p!|<յ`U,O|�xO��T}u��2:��B��8��P�{F4�J��52+�<���!^���)iWN���1�^�z��eM���٤�.�k�ˬ��}�s�����ϭ��~�*�爲��p��O����3�KKjo�"|���\��ӣ�P��vDJ�P�?}�����Z8XG3����`�u�+��Y�?�1C��֒6o�n��"�����˒�?��t"�`����7_�h�GQ�7'h�����")�/3��gW�e�_=�Syۨd���� ��G��x0.[��5�cy�`6G�h��u<7]κ�ʺ�(�l�`�*D��e=w���<�b<�����1���m�8Y���Ѹ�l�q���VI����~��Ko��ߚ�V�����R�n�ZM/2,��(-��L+�Z�>a�9�p��h ⮊��ɻ� 7�94���q��?�}���sH��UC:O���b�F���*4ٴ�l��-5߾C>����v�#����J]������r�/,��%�̏؞���O����9J��ULR	�q�(�@�P�ǆ��;� ��zrI�(ܽQ���ٺDy7�4����8i^NEs�f1�2q�m��5!A�������c����t9��]����g���R�ۇ�d|���/�v���Y��(�Hr��h|�U+��E��+��n���}�����c%-�	���>�����)@���N5Cq�����e9���h������^�	,M
%�nX~�K���ӵ�4wt����s� ЏY�.�G G��Հ�ƫ4D���'�4��c��K�݈�8�������U��G�l���2սF�5�ꋬ��f�3�pT_�+]��I{C[���T���bp�pZ!�'m�GX�e��E�-����������1��N�̘a[x2��BoI�q��1�HIO�7k�?���Tk�P?�j
�'�~����N�ҟ���ݐ���'�@<���� V���`��<�"��^�x5���T��{~�����x�|aNa���h�n��Q]z�`K��R�F�KVx�Ws5�H4GP�d#��p1p�������Hb��"=cx!� z�hm�H������a�o����N����F��ܮ�HdN�-ST#LN�^k�'/��;J6$����zm���tP~�rJsɰ������Ǣb�{,/�MZ��	2RPnU��`���!����ɋM5<"}C�c��,9�iݙ��~!��I����pDcSmNU���V ��DA='9��Yu"��p��g��h��R��ín�w�t|:GQ��}�$�d�P�a �����K5} C�-\{�5#�A�n����AY%��Y.LZ:��YI��H�I`)�����=[��MK�Z�4� ��Tl���,����)��O�K���m�Y��R��*�2���;�x*�=׿�)/�|���,鵏�D�j'Z�~M�/2ާI3�K���h-�w��*��߬M1�/"Rez<��8��?���*#6ڕ*����*�?���%����y�#b�y��I��Q�^��^<_���v��磸Y�"Wαr��#b3����mY(tP���"���Y�r�.���5�7���m�'�s�8 VE�N��%0��ρ��}��|��eQ)�f3	aK���,n��{[����ƂF���"�����]�4r���r��*�>����[|�e<YKpHf�݈�u��2W�.�q��꧚z5������(H�P��9}|�0��%�[��80��O
�pۓ�0�v�n������x��>��y��,P�)y(������� �Ćc��ؔ��G��?���i`�'�/:���q@�9�k��l"Z�Wa��d�Z���!� ���o���)o��%oJIZu���o��ˀt��GYv���6�������]H�&��1Ђt��;�[|��Q���$@���.Ȋ���a�#�58��\p���|���t5�RKo�vPn�7������\L���Ӱ��ŅJy;b�uGA�.:��#� >!���'�Y�ң]����N�Q �O�nN��䒌$ʿ�b��f`:�)��Z�m1��'�!5#)?ƾ8���
G?3�
��.��k�ϒ���0X(���=����e��gV������u���њ��?��]���s�im���m䮷�mg�\�'ٖ`31yp��g���iA+V��r;S�	I�oX�<��V��8"�,N��F3�'oX�E	�)���b5�/l[0���?��;��Kr��p����j��Z�k�?P�4P�Dلɑ��bۅ��������G����F�Hya�ȠJ�,�0��K�ů���R���ŏĥ���<Hvĩ�L����`e�&*.��8H��E�plAY��=���.�H�HĀ?3]�]��I71�����Yݼ��b���H��sK�OR$�:���H��0��,}6�Rsh��#�E��ET�-��i���t����*ӏ#��?K�h/�Xj/��cz��l�!�%<$L9�ȋ�	���_Ts�E�O�i]����{ZI������NsC����ix�Y�pԂ�J�U�՞a��
�@wC{�/����|T�3��H��uc����3�j��-F��$��F�jQM
�1|z��[J�4�����GL}��y�ƛ$��� 5�ʻ�T��X~&H(�z�7� 7�hD���ݢ��{]�c�g�Z�����.H�PYֹ�t���#��O���wp���pca���R�,���LfQo�cv�hk��
��} ��",ǉr�ٴ�NjީYR�Z$^�*��-��wx�]m)%����pP�h���]�\q���c*+#6����c�*��Y��r��.�})Ok1���A����L$C�v�mf�1�gzC}뻉R7��ߞ�9��N�տs�P�RھX����&)iu��F�[�����@�o�>�룇s㝮?qg���?��l�mI.Ã��J~�3m�=�B�x.�����!Y+*�w`��C
{7Q8�/�({'b"Ʃ}8ֈ�q����ڳ�o�u��^Y�5dn7x�٭����� �'[�=�Ǎ�n�Vӥ�Q�i��C`W�C= >>D�c����@zlL?܂���y�U}�Z��:<m�7����<���=���)��0����z�U��T;C�e���9�>�2���c k��M�҅�(�oB��tΪ�i�n+q0�8S�{�R�}�ʲ�-�x^���0��_Xv�_+)��������9�
+ ��,�9I�S#+q7:�����M�
��TW��fJ�� l�m�u���9-xe��]H�նGsr\v�����I��1��ͦ�Kcs����b�>�_$���,�KkZ�θ!?�7]��V�l���[���H�<����Fn��+8}#?�Ggv��W"�h�n�.�b�		�u�O�:
�7��|(�VHʞ��"��!�Ø\y��\���9��i���W�b��^(`iU9    �5�ʧRΦ`������xu)qZ�o�{k�ӯ������T^D���>四V7����Ҡ�,��FY�	��k��R(ƒjRq�"�_���x��]�Z�
�}��@-Cg�e 1�@�a��s�Ǥ�Ù�0����KP���=H�4�XM`�j7?�j�"𰾳'�Ⱥ�~ �mX,�)�au�Qp�a����u�T]}]�>�]x'����dhZo��f<2_R�wi���1��7v� uF~�T]�5Kw�.���02�[>�n��$Q(	�{j�F�����T��[\��V���^q�\K�dM۰�T�NQ�
P���`��t�\���m���`6~�� �&�G3�<�
�j��R��U��ދL��n�I&N�{����z�I��ٽpW�+3�&��͕���8����"��浪��k� iT�"��'�rSv�f��b̪�_<5�R��n�7?q��Y�~|6�c���(Y�q(�^�&�ϸ��r��8OM��7<s�4kW�AC�uH.�����ߛ/��t�78�&3�#-����E��őiX��PK�r
_g#2"�Q��=3#��V��Q9ڇS�f���������~u.����zU����/3k 
ђ�~}����2jYU��,)�3��s����FH��+
�u3���0��1�B�1p��!������Ǔ�a
��Z�g|?�=�A"��$?0.����?��tcQ���hr=��qT����7�7RB�c.�}�>VB:�d��,3���ok���cCf��2Aͤߵ���if������[������g��΅3��0����W�؆,edѤcV���Q��&������ Sa���A4�G��R��4�4o"�A���\��a�`��^�^�I���D�4�7];oW\�V.�bM���coK�jy3m�2h��l÷�G�g����K�hְ�;X�b�z�7(h�_P{�[c�7��Kvj�Բ�x�S_�0.���!�#-�ڽ�=�KH?m{6��k�,�U+/��xc�㸬q��s'�߂ z�B�$p�,fkP�
f�u����imK�5�l�{w�|ܘUup�50G�Lh�%��>u�u>�a���P�����苂;RݧU>B��a�'��b���On��	��j� �R�=���C>�Q��꼆Q�ߔ[���D����
��6�?C(;d
�Ŧᥗ�7Z�Xzh�3T  �d�x#�E��ERK�J�&��U�/�L%�P(TJ_!z���0��`�^��
F���6����T)W��QG��K߀|W�XJ5�;W8�Rڔ����N�By����3n�r����FN�֠�}���]�G�!iv�n���B
~�/�1ަ�Ǽ_b4���%�H����c�/�2Õ�T��$��;сQυ�xϡw��Gj�F��S��wN��tt/ffBoS����&����W�͐��UX�����V�{˖�H��/�a����=.��f *����t��A������~ ��r8*XN����@T,>��Ց��$!���эM��p�X�#Cr�̵D���a�a
2`�,��G��v�k��g�������`��Y��f�cE�%�b�V������D�
Nxv��՜X_4af??�QOyi"��f�Im���L�"�?ŧ�%n�n�L���W��2\-�����Wt��\@�έH�Xť)��_̞�nS�"�]���?ʩ��{)�N�=��#.cd7�#��ߒ�W�����3���B�D��[Ꞛ����qj�v�d=�~��C5P�0e�h�f[F���y�x].й�ť��Y������JW[�����G(ځ�;j���N��.��3p4v�p���<�K��M᧕����Շ�+�8�lŗ�d8v0P)"x֚��ɫ+ᰤ�!�w�^��vTd�W���0`ܼ*��נ�����>��m[v�J�jGPz�Y�K�͏� ��&���a�R`wi���jE�*Jj���gԨ։X���*��l�퍛��Wh]��|{�7���X~D��n�M~r+"zrf�P����@��"�E��sE�,͵?vZ�/P۽X�+VK��9�M@d��5`M�ux���[��t<��Y��v�g�q1�����3�����gsW���VG.Y`�r����eZ���bAH@��^���x�Ȧe�f�E�V�o� �W�y�q4FV+���q�\�[Q�S��Ȓ9l��ln��E��7)�*u;�IEYY�T�o�`X���V.�mK�>Ι��'����
�G,���_��J��h�������I]�SE��M��\|7�O6��߃Ǘ2F���E��-/h��
�m�p��5��̳��w�|D�2�|랓y!�����қ�T����g����k��b x�;����*�~Ӻ�	����N�M[�om�;*&��t½�A~>���E�%�)~g�֭V=u�  ���j�M'� :��W(�;T;-�x��^.O�MU�����9��`�1T�V�����ɺ-?n�w�&�d�	g����oP��C5ר>��Ҷ\:�ߺ�Ջ���ʹ9�I�9b���6��|R�C<\?��'��ׇC��,��_,/Z�h��lzS����]/Y{Xu��G;�h� Bd;�Ǣ����l2�B��!�e6�7��$� q}�F�$6`�R�(��Q��,�|�8qe�-�fЋ��؊:Ui��W�z�.�V �f������*�����ԖvzIS8W��B����=#A�[�������[��)�y�����'[��qa��c�_�[v�hZ qߡ�>���IHF���BwgO��pPy�?u�.WSϳ�P�p�[�`O�4��Wu�����'��50�TL�ƻ)�\ڠ,K�u�C�N| ������msw��	��-��@Q&P�bWN�*䕒RrW�%�^��,��kF����w��=�VT���-hF�X�?��Z�4\+�TB۶a�Nm�m�i�ltB�=�c-�e?.U�+�M��ȭ�y�7!�n�b�� O�#�A��\�/~=V���d-�������͎LO*�˰��5]���r����Tb�$~�����7��k|���|�z�?K��0#-J$��1+t�_�)�W�>7	�Rq��/qͺ�����k���18�9�V?�z�d��eb>�]�0�j�O=���?C$Sx��Zw,��^���.�7�f�)=>@���sa3Vja~$;1��eE��[U[Drz�d;�dfk�v�椯b��a}�\\#����������j�S�'�B��X�s?�ˍ��\'��p�����p���2��(��N�������f�{D�b��#5��!��KY/ V��~����~�e�b ڻ�	�Q��%��H���K�cpD���F���%��q��'�|�F��O����&�H��k__��iY������iS��ʯ%��>�y�r���R��g�P��9����y�D��0���q<���	�9P$Co�	&{l��;��}�!�ӭ�#e�̎�^rxd�l���?�Y�_({6�%)<Y�����8�&,b��?����Z�f��/�
FL[O��Ք�X�¶f b��I�^��8۞��I��#t+�f���I�{쭇%�~��ʯ�(|؊�3���Y��h��|�^|�ߍ4�j�uʨtG�4=f:�{~?��f��/�D��_J�'	�I�_I����W���Q�RI��U=�eP���W���QͿ�?Zp˶�7��4r�;,�=O,�ѴA�,���j΀���T�/��-����9��-v1�-̒x�U\�4y���������8�Q��W��vAV{�dg]�HO|�
J���)QD��Q�j�����
��9"S���[g���� ?�/ɖkK���h�:��u.�JKl?J��>:huw�����= �\��XM�ƭ��_^�Ȇ!��z��q,t�N�7-{�	̖�_a�Ѡ���[��1 V���#���&YFJ�O����վM �P�_	}�0yI~���ӝ���D��o��1��"�0C ��Ze�EW��X��tD�K%~e�+[���(�2X��N�i鄶��)��9��	�p�%bz|ǻN$�21+&�    l���I��lJJ�	�.��aSFo/����w&��#k������^�-��Bl�SYS�,PT��>*h�'1.o��Cx̑Wm-�X�゠*zDo�R.��q g�!�^�O#�h��)��y�'٤�1e���h_iM�'�D���zS"v_��5c��K���vm�J�������QB��g�܊�TɲF��[�����\R��D�ȇ=%�y�ve�;Y�k䁲o�"����j��z�q������^�Yn�] k\����0�o�g��F��i<.GL\�0��z�veכ�f|[1٣SΤw�X��Fg^waD���S�%,n�d+!sx��G�#q�Pk�����_l98x��`'��I�M�gW��N��}����M���z�����5xc�蓓�6����,����S��-�5g_�m���N�	s��q��;ʚ�����K��BV<�OY�3��Nk�D���K���>Q�W����h�f1�4�;�+�w��"�'���p��fGJ�ߛ�o9⠯n�P�5{�.�Îa>���f�Wէ�����5#x �@�vA�
��TQ���)��CT
a�y6��{�.�+b_.�E�J�f����J]�u���:y��Ț����J&���l���Cu�Y�ءa���,p1n�����I�˧P����SYN��ϯ�adla��=��B�b ;~�����o~߄�t�Yd����F�w�˩N;%�����T�"�id/Y4	��5?�)�k�e�)jR�ِʙ�o�)�gsc�CM���`_O�2/���E�5lҚ��QU�* 7o ��P!�]��t���e������{����rj��]���Δ�iY��.;�od�i*2������� tݳ��R-�i}���ê�,�K7K["�("٩�9��J:��Zެq�`�� 2|�se���E��u�?![f(�!�U�S+v�ֻ�-���	�Z��F����{dס	O̲T||��8f��>���de奝���#���:{���Z��,V�4��ց�H��?1�5]5�:L����)�T9��>լ�	����oft��Ts����z�/��T�p��^��-�'>���Q�C4������x��qE�,V�h:k�����GX���AH�6ᣎ��0ȗ��-�k��~r¢�Lg	YXH��c��/�c��޹GTvG��r��S���F����z83Qx� �L�Y3�}fE��Q����t��&� ��q��]�� �JD޽wxKx�e������]VV�w��J���?�`W����J����E�b���=^�F��7��3�zC��a���6��9b�ju�+�K�顉2��=*�+1�'��;<����������m���~*B^�OV�Ŏ��E|
�T���N�p���i��͇<�]J�N�����|�k9�w�������n���=t[��߈�I�����ђ�=1��\�V`��P��L}e= `nZ�M�%��{�j�k.8�V*�G����'�U�,�gL �J�*�n����y�c��|iNB�]��}�>+�M8X\��/v�t��X���@,�7�ϥI�3oё(�2`q��V:��@|U�Y�-n�
��m�Zk �s�!�H>�:D�~q�qZ��}�It��`�H�N��y��X�J!����m`��k��S�o��scȱ����N�c���j�������������/^��x9Kϸm�C��d"�^h.;����]�[$��w��,P�j����[B�Ԗ���M�L�+�_�������1��]���	ȕ��:�F+��"K�� �7���
3�lg)Ub��guj��F��<�3^(��j�m<}c���n��k�u �e�87��2���ф\ߓ$m)�w���:ID��@G�~�|����
��"m��ܰw�n�MW��A��^%OG:"?][��l[`	R�8�8��-���ۦ���^q����<��e�-�8��E�{�:kX$�������(;P*���`��qu�l�֡�=r�OsɜG#�ƶ��N�}��*���߫�uw��\?��1��o��}s]��y���'Or�w4�H0�?[
�EHf��=6ﴙ������v�K?O2$���I���¤gE�5�#���tU<�����0��W�	�?a�[��?�s����tp���jeq��=~�ž����cL �r>aw�;d�!pss%��M��B����E����<��ιƣ�ڼ]kum�etW��Ma&H�:V6�O�-~���%ג�0��IC�X����u[|�،9�Ʃ?�٬n����n08@F��md�E��#�9`d�����A1w�V+�9��"��źQC��ޟ����u��Q#o-))�T���RNZ�F�G��5��UȺ��`,F���%pH���t��۠yTP�.)	���3���S�+��zbwD���/{_�[�|����샗@X�u)�B�H�vL?�q��o���w�f�:~M�<���$����~��:/� ܂]�`���9����`?�2�4�T8��X��	S%k��T;J\�f�Ma̋�u1����Y�"p���5-$�Y3���i�k����O�H 0ΩG����Ď�O�r�ik7�ua�K`��3U�����y,oS�*��w�� �QY�޶�ӯ=T��Lrw��a6W��\��chxt96� N�VP�Օ��#�e����Z�l��u��>��=�� ���I�����l!bs�,�I��j\ ={�Z����@���%g�|%���WS�$��\D���Y�?���mIY?�R��b[��睜/.v�2��kIj���$b��G�����;t<L���w�f�!s���SN ��6.5<�n�]="�:Ja�ry��j����20�ɽ�(�`�aoauߕsNM̾�bӬ�/P���� �� ���{���"?<�f3�(�2��6����Jk
�Y��T�FD���L�9�����w���,x���F6�\�i��^���'��*�)�\v\=�t$�l���L�c���D�ޠ\��MD�0���������n�X�0��L�U�l�{f�Hy��?a�EG�*�E�6���U��a*���j�e�o�>a�� ƈ�x�������	)8+j�Q�/�	p�:]�>7�M	zZ+ۡÔ�� ��˵��V��E*�3Yy-�m�$n�?e<��u�����ixHߡ��#V��E�� �2�H�B���0z��"ˏ���!'H�y��@a�V����y�5u�_�/X�"\�J�Dl�Km5e�������sx��X��n>��J��m�6�M�+I5^�LK ?�W�,��A�r<UJ��g��o{�����҄%����TDΧ�x>�@gy1�>$Jg.5�Y����h2��h��Pu~g]�h^�ԠQT�10�'Wk�*L�4B���2x�Y�==�i�}�.}�>OU�&�}���YY��?#���I"<��Tq�p�����I-�7<ID&!`l.�|O���l� AY���2��gc���d���q�пo�"�c�O��Ԁ�?�X��
���L�Y��Z!�!S����}�B�ӽʀ���ёq;	K��Nn%��?��.Y�=���j�k���[�����1������!B��[���+�N���K�~�o�~�������H�6�<���`) E��	�@�:\y��*�����t7���(7����� \�ˆ?}D���Dn�� �~b�>yh�ɭ���T�b�;�_��#�nܵ�K�Z���'��{(b��ʲg��v7�yf�TA��R��|�X,�7��$Ș�u�*��K�D�(��� ���$DǠ3�He��6�qEM
�=�=("�g�{H����p�U碊�";���"E9�.ni�\p�ʥX�hJ"1�q	�!g?����y!E[p�C*�9�����L��K�"^8}��e�S���D�����⁒����T;��u��P�ܣ���qjb�X;�5���8��VG�	��t�wT�����uu��;�O��,�� �	  ֳa �N�U�÷��,�l��x'�|�hy��IY-�o՜[]H�"F"[͐�c3YD��6�c�{Tg�����2�;��X�1B��B�{�eн-����,9�̛UH&����h�.J=�oL5��2V�ᵁҟ���|��L`�XB%��yHl��8M)�-��f�7�^�-E�|��\"G����2bĮ�l���`�$UQ�ϰ�.:�l��Q��,b�o����s�m�y��>bf,"٭n���Kv̋49T!�N�{��) �Ђ�a�9|t��L|�^Rם�ʒ'�^Ur߃$����	�[�3����[�k�g��y�H�����BYFq�t��'�Y��[���`���i�JIKO=.:��^ܸ��߽�L?e���g���k��̱L!��8�����ARK;��3�T�>3$?[���J�9l���#|�͞����2"�2R��.��At�UȤ�q���8i
:Re�1�*O�t�lfd��8�desx >�]���ZD���Z����"��(�YD��k^�Wo$��WhU�'�&�hi����o�^_��,��,`�T���(�s�9�����p+����dI��U_�(Ɋw��<+��
�tѽP�@�H��FC�c�O4�Iw�6ȼHW�*ڛу��}Ĭ`���W��d�Q�nL������ҭ��p�eH�P�}E����<t꠱'�7*[9�O
R�m���7�8sB*��S%6�Be,^����?�_%�(�ȇ��a�`=zX���Ro�Ku��Z�G����w�DԊ���=)���L�|�Zm<�2�;6�6�J�SS����y�xǀ�bp&����%B����i����W&7k��t�F��s�t~ϯr�ym�����`A!��Ϩ.)��*���Q�o��	r*�͒�&��#W_��Ô�ee��cĕ��k^�D�j�ըq�q8�j<� �� @�!��P���w��
mٓן�j�x��᧿�v�_���{;?o��K����a_�N���.��hbo�ހů�D����$���SguS�U/�u/{d�&Q~�k���%�Wۏ���� ߯�A+�5j�1W�)q1�'�a��2�n:K���1p(:\BI$����p�J�s�ߢ�7%*3����t�bZ�޷���N��B��Ij�-�1� ���ۋ��<��0Y8�Xȫ�������3�"}����>�"��Q�f�꾅���1�����g��E~������^�}��]�e55���V���(ZN��N���dz~[���(<����/��"~�ɜ��xx�A�m�[0�<?T�9_���֕,��C�1�+Μ�BB3D�����$@:i"*~�����{�(&��읕d�S@�@�%C�VUr��ݺko�4Wo�M���Z�N�M?�<��S�1���%�x/Lz�W����G����o4і�3���Җ�d�:Y�L�K?1k.��S��Qn��	�l��S�<�2��)��Q��ٕ^�������mYTI�jt� ��pO��x>W/������߶�^�8�|#��5L�٘� �:E����q|mi���� ��dp=�<�h�3�Cr����En:η{���p���]+�,�=]��ٲ� p��Ծn��C�})��D�� n�r:l5G��y�]�SO��㉿d��m�^O�|�,�a�ϓ����,�R,]��S+��壓�YY���)詀�&�Dm���N��,�mU���Ǐ{|[ht)ji
i��68� �k�����r$)u*��6������������s]3��4�p��󔃏�Yw�� �w$��N��	�Al��e�[k��u�d����K��XV���S<�.#��㊒c!�Dx"�?�Ȑ�̀׺ҵ�]��.Y塻���?�K��㴔Е�� �.�J�5�����V�����j��:qw�6����:��L�g��-N�jn�;�<[qv������N%��2�v�뙻��v�c5���.:K��Ѕey�A5>]3-�(�6���~���N��9ۦ)�P��r��v�s�"�
/7Wi95=���rM>�n�Jh݉#�u<=�w���!��ܚg=�##��)�w4T�^S,�S�U6\`B8��웹,ХǕo�(-QH��`�CW�`�lÖ混��k��ՠ˙���lӔ(T���qɆ�������,�C���)?9 wd��ހqt�ߣ��c�0bx��yF��G	��D#�� $�B�	��!�\q����qRX~�! =�i�5J<��<G�w�1�7K�BA�- 0YNp�AU_�����Dy1	D���Zd�uM-��i ��J��H��̋h�̐�d�M�/�H
��BM�5�R�3_R��e��J����@#�^��/��m0=>.��D��wg�W>�	��U�`�� ����*����D�����T���@�M�t�ϗ�{� �?�弓��c�������?B��      �   7   x�3�4��q�ur�tu�2�4�t��t�q��r�9�\��\Otts����� �
�      �   3   x�3�L��I,�TQP�L�4�36�2�,��I-��W�,�4�30������ خ	      �   �   x�m�Qo�0ǟ�O�^��2X�I3۲�b\�/�QS�R��O?5K�/�������vNԍ�D���L��J(MrS�Mv۟{F!�`�<�bʆ�{f�-�(�����%f���w�dNYG,���"*g�n��8ϔIVe��I*��	b�1!�����ԉ6�Х��G�v�U�������ER����F~?�~%T�ۂ��Y���!#�������{\����_g^      �   ;   x�3��*M��LL����42426J3�4O4�DscK�D�T�DôdcNC�=... ��      �   �  x���Mr�:���)|���O��,f�N0�?�k*ˢ���Sv�G l�d��^۟�&�����ε;uђDu��ڦY�7����3o�S����.Y(�Y��1�X�>��z�z���X]ZF��
�&2b�C�S��֕�h���`����m�.�Գw���=�^�Bz�H���v^��%��mC����|L�_����I���bu)�+�:��g�d�$r�Q�S�s�/��Ku�"���P�k�mj��m���{eT7.��p�4�Ќ��D�w,څ�WԼ�a�3gṲ�VFΒݽd
�2��_<"g|��NF�f��:,G�!q�9o�?�g꥚�d5�\b�`]��;>c�� ��l �	h�:ZƜ)D ��A�܅����a�Q�5c�`��W�t�>L#���p�y�$� >� �Ρ���i-�r�s �s&�xG�1�v]N�i��g-��.,�$��nH�`�M �PNB7�k�`�Yy�j��-a��ll���P�)�I�r��Qpe���NK�^D`{WMH�%��&֋��[�N�yFh��\������;�b�1?�y��)suz�Q�l-���Hh� D��/	�&��0���^� �u��:ZiA�%A���^Rm�����P�e���sE�ϣa`�#��n�ka���{�����(驨�
�>�˸��I[�@^C1�S� > �`Ì���� �� ��`R�A�՛�x�}?r=�{h�s+��T���\���Z"�T����1�qA���.5u\j��!>�q:�R$��K}��Ǖ�57̢�>?�}�J�:�ÄR_�>F!�*%M�������g���J���R+N����'}`��q�z��@���:�Z��q���T���8�v���-���x3�     