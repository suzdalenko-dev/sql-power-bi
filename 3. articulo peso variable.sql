-- que desglose el cajas por cliente

select CODIGO_ARTICULO, TIPO_CADENA_LOGISTICA
from articulos
where 
CODIGO_ARTICULO = '41111' AND
TIPO_CADENA_LOGISTICA = 'PV' ;


-- 
select *
from CLIENTES
;

select pv.CLIENTE || ' ' || (SELECT cl.NOMBRE FROM CLIENTES cl WHERE cl.CODIGO_RAPIDO = pv.CLIENTE) NOMBRE_CLIENTE 
from PEDIDOS_VENTAS pv

;

SELECT ma_hoja_carga.numero_propuesta,
                  pedidos_ventas_lin.articulo,
                  articulos.codigo_familia,
                  pedidos_ventas_lin.descripcion_articulo,
                  NVL(sum(PEDIDOS_VENTAS_LIN.UNI_RESALM) , 0) PREPARADO,
                  NVL(sum(PEDIDOS_VENTAS_LIN.UNI_PEDALM) , 0) PEDIDO,
                  NVL(sum(PEDIDOS_VENTAS_LIN.UNI_PEDSOB) , 0) UND_PED,
                  NVL(sum(PEDIDOS_VENTAS_LIN.UNI_PEDALM2), 0) CAJAS_PED, 
                  (SELECT MIN(art.TIPO_CADENA_LOGISTICA) FROM articulos art WHERE art.CODIGO_ARTICULO = pedidos_ventas_lin.articulo) TIPO_CADENA_LOGISTICA,
                  PEDIDOS_VENTAS.CLIENTE, 
                  MIN((SELECT cl.nombre
                        FROM clientes cl
                        WHERE cl.codigo_rapido = pedidos_ventas.cliente AND cl.codigo_empresa  = pedidos_ventas.empresa)) AS nombre_cliente
 FROM MA_HOJA_CARGA, PEDIDOS_VENTAS, PEDIDOS_VENTAS_LIN, ARTICULOS 
            WHERE PEDIDOS_VENTAS.NUMERO_PEDIDO=PEDIDOS_VENTAS_LIN.NUMERO_PEDIDO
              and PEDIDOS_VENTAS.NUMERO_SERIE=PEDIDOS_VENTAS_LIN.NUMERO_SERIE
              and PEDIDOS_VENTAS.EJERCICIO=PEDIDOS_VENTAS_LIN.EJERCICIO 
              and PEDIDOS_VENTAS.ORGANIZACION_COMERCIAL=PEDIDOS_VENTAS_LIN.ORGANIZACION_COMERCIAL 
              and PEDIDOS_VENTAS.EMPRESA=PEDIDOS_VENTAS_LIN.EMPRESA 
              and MA_HOJA_CARGA.CODIGO_EMPRESA=PEDIDOS_VENTAS_LIN.EMPRESA 
              and MA_HOJA_CARGA.NUMERO_PROPUESTA=PEDIDOS_VENTAS_LIN.NUMERO_PROPUESTA 
              and MA_HOJA_CARGA.SERIE_HOJA_CARGA=PEDIDOS_VENTAS_LIN.SERIE_HOJA_CARGA 
              and ARTICULOS.CODIGO_ARTICULO=PEDIDOS_VENTAS_LIN.ARTICULO 
              and ARTICULOS.CODIGO_EMPRESA=PEDIDOS_VENTAS_LIN.EMPRESA 
              AND ma_hoja_carga.codigo_empresa = '001'
              AND pedidos_ventas_lin.empresa = '001'
              AND articulos.codigo_empresa = '001'
              AND ma_hoja_carga.serie_hoja_carga = '02' 
              AND ma_hoja_carga.ejercicio = '2025'
              AND ma_hoja_carga.numero_propuesta IN ('3067', '863', '2212')  
              GROUP BY PEDIDOS_VENTAS.CLIENTE, ma_hoja_carga.numero_propuesta, pedidos_ventas_lin.articulo, articulos.codigo_familia, pedidos_ventas_lin.descripcion_articulo
              ORDER BY PEDIDOS_VENTAS.CLIENTE ASC;