-- ofs 
select * -- ORDEN_DE_FABRICACION, CODIGO_ARTICULO, EJERCICIO_PERIODO, ORDENES_FABRICA_CAB.SITUACION_OF
  from ordenes_fabrica_cab
 where codigo_articulo = '40090';

-- articulos de la receta
select c.num_linea,
       c.codigo_articulo_compo codigo_engrediente,
       (
          select art.descrip_comercial
            from articulos art
           where art.codigo_articulo = c.codigo_articulo_compo
       ) d_ingrediente
  from ordenes_fabrica_cab ofc,
       estructuras_compo c,
       estructuras_cab h
 where ofc.orden_de_fabricacion = '1132'
   and ofc.codigo_articulo = c.codigo_articulo
   and ofc.codigo_org_planta = h.codigo_org_planta
   and ofc.codigo_empresa = h.codigo_empresa
   and c.codigo_empresa = h.codigo_empresa
   and c.codigo_org_planta = h.codigo_org_planta
   and c.codigo_articulo = h.codigo_articulo
   and c.codigo_presentacion = h.codigo_presentacion
   and c.version_estru = h.version_estru
   and h.situ_estru = 'V'
   and trunc(sysdate) between trunc(h.fecha_validez_desde) and trunc(h.fecha_validez_hasta);



select codigo_articulo_equiv,
       codigo_empresa,
       codigo_articulo,
       codigo_presentacion,
       num_linea
  from (
   select estructuras_compo_equiv.*,
          (
             select decode(
                nvl(
                   (
                      select u.tipo_desc_art
                        from usuarios u
                       where u.usuario = pkpantallas.usuario_validado
                   ),
                   'V'
                ),
                'C',
                a.descrip_compra,
                'T',
                a.descrip_tecnica,
                a.descrip_comercial
             )
               from articulos a
              where a.codigo_articulo = estructuras_compo_equiv.codigo_articulo_equiv
                and a.codigo_empresa = estructuras_compo_equiv.codigo_empresa
          ) d_codigo_articulo_equiv,
          (
             select descripcion
               from presentaciones p
              where p.codigo = estructuras_compo_equiv.codigo_presentacion_equiv
          ) d_codigo_presentacion_equiv
     from estructuras_compo_equiv
) estructuras_compo_equiv
 where ( codigo_empresa = '001' )
   and ( codigo_org_planta = '0' )
   and ( codigo_articulo = '40090' )
   and ( codigo_presentacion = 'KG' )
   and ( version_estru = '001' )
   and ( num_linea = '1' );



-- 
-- materiales empleados
select *
  from ordenes_fabrica_compo
 where codigo_articulo = '1233';

-- equivalentes
select codigo_articulo,
       num_linea,
       codigo_articulo_equiv
  from estructuras_compo_equiv;


------------------------------------------

-- Equivalentes de los componentes de la receta del artículo 40224
select codigo_articulo_equiv,
       d_codigo_articulo_equiv,
       codigo_presentacion_equiv,
       d_codigo_presentacion_equiv,
       cantidad_tecnica,
       cantidad_tecnica_2,
       codigo_empresa,
       codigo_org_planta,
       codigo_articulo,
       codigo_presentacion,
       version_estru,
       num_linea
  from (
   select estructuras_compo_equiv.*,
          (
             select decode(
                nvl(
                   (
                      select u.tipo_desc_art
                        from usuarios u
                       where u.usuario = pkpantallas.usuario_validado
                   ),
                   'V'
                ),
                'C',
                a.descrip_compra,
                'T',
                a.descrip_tecnica,
                a.descrip_comercial
             )
               from articulos a
              where a.codigo_articulo = estructuras_compo_equiv.codigo_articulo_equiv
                and a.codigo_empresa = estructuras_compo_equiv.codigo_empresa
          ) d_codigo_articulo_equiv,
          (
             select descripcion
               from presentaciones p
              where p.codigo = estructuras_compo_equiv.codigo_presentacion_equiv
          ) d_codigo_presentacion_equiv
     from estructuras_compo_equiv
) estructuras_compo_equiv
 where ( codigo_empresa = '001' )
   and ( codigo_org_planta = '0' )
   and ( codigo_articulo = '40224' )
   and ( codigo_presentacion = 'KG' )
   and ( version_estru = '001' )
   and ( num_linea = '15' );

select codigo_articulo_equiv,
       d_codigo_articulo_equiv,
       codigo_presentacion_equiv,
       d_codigo_presentacion_equiv,
       cantidad_tecnica,
       cantidad_tecnica_2,
       codigo_empresa,
       codigo_org_planta,
       codigo_articulo,
       codigo_presentacion,
       version_estru,
       num_linea
  from (
   select ece.*,
          (
             select a.descrip_comercial
               from articulos a
              where a.codigo_articulo = ece.codigo_articulo_equiv
                and a.codigo_empresa = ece.codigo_empresa
          ) d_codigo_articulo_equiv,
          (
             select p.descripcion
               from presentaciones p
              where p.codigo = ece.codigo_presentacion_equiv
          ) d_codigo_presentacion_equiv
     from estructuras_compo_equiv ece
) estructuras_compo_equiv
 where codigo_empresa = '001'
   and codigo_org_planta = '0'
   and codigo_articulo = '40224'
   and codigo_presentacion = 'KG'
   and version_estru = '001'
--  AND NUM_LINEA          = '15'
   ;


select distinct version_estru
  from estructuras_cab;


select orden_de_fabricacion,
       codigo_componente,
       compo_desc_comercial, d_codigo_presentacion_compo
  from (
   select ordenes_fabrica_compo.*,
          ( select descrip_comercial from articulos where codigo_empresa = ordenes_fabrica_compo.codigo_empresa and codigo_articulo = ordenes_fabrica_compo.codigo_componente) compo_desc_comercial,
          (
             select a.descripcion
               from presentaciones a
              where a.codigo = ordenes_fabrica_compo.codigo_presentacion_compo
          ) d_codigo_presentacion_compo
     from ordenes_fabrica_compo
) ordenes_fabrica_compo
 where ( codigo_empresa = '001' )
   and ( codigo_org_planta = '0' )
   and ( orden_de_fabricacion = '1233' );

-- of ingredientes en uso
select orden_de_fabricacion,
       codigo_componente,
       compo_desc_comercial
  from (
   select ordenes_fabrica_compo.*,
          ( select descrip_comercial from articulos where codigo_empresa = ordenes_fabrica_compo.codigo_empresa and codigo_articulo = ordenes_fabrica_compo.codigo_componente) compo_desc_comercial
     from ordenes_fabrica_compo
) ordenes_fabrica_compo
 where ( codigo_empresa = '001' )
   and ( codigo_org_planta = '0' )
   and ( orden_de_fabricacion = '1233' );


select orden_de_fabricacion,
       codigo_componente,
       ( select descrip_comercial from articulos where codigo_empresa = ordenes_fabrica_compo.codigo_empresa and codigo_articulo = ordenes_fabrica_compo.codigo_componente) compo_desc_comercial
from ordenes_fabrica_compo
 where ( codigo_empresa = '001' )
   and ( ejercicio = '2025' )
   and ( orden_de_fabricacion = '1233' )
;

