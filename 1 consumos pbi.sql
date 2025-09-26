
SELECT 
    A.CODIGO_ARTICULO || ' ' || (SELECT DESCRIP_COMERCIAL FROM ARTICULOS ART WHERE ART.CODIGO_ARTICULO = B.CODIGO_ARTICULO) D_ARTICULO_SUZ,
    (select f.descripcion  from familias f where f.numero_tabla = '1' and f.codigo_familia = B.codigo_familia and f.codigo_empresa = '001') as d_codigo_familia,
    (select f.descripcion  from familias f where f.numero_tabla = '2' and f.codigo_familia = B.codigo_estad2 and f.codigo_empresa = '001') as d_codigo_subfamilia,
    (select descripcion from familias where numero_tabla = '3' AND codigo_familia = B.codigo_estad3 AND codigo_empresa = '001') clasificacion,
    (select descripcion from familias where numero_tabla = '7' AND codigo_familia = B.codigo_estad7 AND codigo_empresa = '001') tipo_material,
    (select descripcion from familias where numero_tabla = '8' AND codigo_familia = B.codigo_estad8 AND codigo_empresa = '001') mercado,
    A.FECHA_VALOR
    ,A.CODIGO_EMPRESA
    ,A.CODIGO_ALMACEN
    ,A.CODIGO_ARTICULO
   -- ,A.CANTIDAD_UNIDAD1
     ,TO_CHAR(A.CANTIDAD_UNIDAD1, '9999999990D00', 'NLS_NUMERIC_CHARACTERS = '', ''') AS CANTIDAD_UNIDAD1
    ,NVL(A.PRESENTACION, 'SIN PRESENTACION') PRESENTACION
    ,A.TIPO_MOVIMIENTO
    ,A.TIPO_SITUACION
    ,A.TIPO_LINEA
    ,B.CODIGO_FAMILIA||'_'||B.CODIGO_EMPRESA AS PRIMARY_KEY_FAMILIA
    ,B.CODIGO_ESTAD2||'_'||B.CODIGO_EMPRESA AS PRIMARY_KEY_SUBFAMILIA
    ,B.CODIGO_ESTAD3||'_'||B.CODIGO_EMPRESA AS PRIMARY_KEY_CLASIFICACION
    ,B.CODIGO_ESTAD4||'_'||B.CODIGO_EMPRESA AS PRIMARY_KEY_PRESENTACION
    ,B.CODIGO_ESTAD5||'_'||B.CODIGO_EMPRESA AS PRIMARY_KEY_NOMBRE_COMUN
    ,B.CODIGO_ESTAD6||'_'||B.CODIGO_EMPRESA AS PRIMARY_KEY_PROPIEDAD_DESTINO
    ,B.CODIGO_ESTAD7||'_'||B.CODIGO_EMPRESA AS PRIMARY_KEY_TIPO_MATERIAL
    ,B.CODIGO_FAMILIA
    ,B.CODIGO_ESTAD2 
    ,B.CODIGO_ESTAD3
    ,B.CODIGO_ESTAD4
    ,B.CODIGO_ESTAD5
    ,B.CODIGO_ESTAD6
    ,B.CODIGO_ESTAD7
    ,A.TIPO_SITUACION||'_'||A.CODIGO_EMPRESA AS PRIMARY_KEY_TIPO_SITUACION
    ,A.CODIGO_ARTICULO||'_'||A.CODIGO_EMPRESA AS PRIMARY_KEY_ARTICULO    
    ,A.CODIGO_ALMACEN||'_'||A.CODIGO_EMPRESA AS PRIMARY_KEY_ALMACEN 
    FROM HISTORICO_MOVIM_ALMACEN A
    LEFT JOIN ARTICULOS B ON A.CODIGO_EMPRESA = B.CODIGO_EMPRESA AND A.CODIGO_ARTICULO = B.CODIGO_ARTICULO  
    WHERE B.CODIGO_FAMILIA NOT IN ( '001', '017')              -- FAM AUXILIARES - REPLICADO DE LA VISTA STOCK PESCA - EXCLU 017 A SOLIC DENIS 26/05
      AND B.TIPO_MATERIAL IN ('A' , 'M' ,'P')                  -- ACABADO, PRODUCTO COMERCIAL, MATERIAS PRIMAS - REPLICADO DE LA VISTA STOCK PESCA
      AND A.CODIGO_ALMACEN NOT IN ( '98')                      -- REPLICADO DE LA VISTA STOCK PESCA (ALM:TRANSITOS IMPORTACIONES) AL APLICAR SE QUITA TIPO_MOV 06-SALIDAS INTERNAS
      AND (A.TIPO_MOVIMIENTO IN ('03', '06')                   -- SALIDAS A VENTAS Y SALIDAS INTERNAS
         OR (A.TIPO_MOVIMIENTO = '20' AND A.TIPO_LINEA ='S')); -- ENTRADAS-SALIDAS PRODUCCION SOLO SALIDAS CON S;

-- Calculos en el informe de promedio 3 y 6 meses

Consumo Kg = ABS(SUM(HISTORICO_MOVIM_ALMACEN[CANTIDAD_UNIDAD1]))

Linea MM 3S = [MM3S Kg]

Linea MM 6S = [MM6S Kg]

MM3S Kg = 
    VAR FechaActual = MAX(dimCalendarioStock[Fecha Corte])
    RETURN
    CALCULATE(
        [Consumo Kg],
        DATESINPERIOD(
            dimCalendarioStock[Fecha Corte],
            FechaActual,
            -21, -- 3 semanas hacia atrás (incluye la actual)
            DAY
        )
    ) / 3

MM6S Kg = 
    VAR FechaActual = MAX(dimCalendarioStock[Fecha Corte])
    RETURN
    CALCULATE(
        [Consumo Kg],
        DATESINPERIOD(
            dimCalendarioStock[Fecha Corte],
            FechaActual,
            -42, -- 3 semanas hacia atrás (incluye la actual)
            DAY
        )
    ) / 6