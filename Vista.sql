CREATE OR REPLACE VIEW vista_tel AS 
SELECT c.nombre, c.apellido, t.telefono, tt.descripcion
FROM cliente c, telefono t, tipo_tel tt 
WHERE (c.id_cliente = t.id_cliente) AND (t.cod_tipotel = tt.cod_tipotel); 