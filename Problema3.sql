--PARCIAL PROBLEMA 3
CREATE SEQUENCE SEQUENCE1
    START WITH 1
    INCREMENT BY 1;

CREATE OR REPLACE TRIGGER auditorias
AFTER UPDATE OR DELETE ON prestamo FOR EACH ROW
DECLARE
    v_accion char;
    v_name_tabla varchar2(30) := 'Prestamo';
    v_monto number(9,2);
    v_saldo_anterior auditoria.saldo_anterior%type;
    v_saldofinal auditoria.saldofinal%type;
    v_id_cliente prestamo.id_cliente%type;
    v_cod_tipop prestamo.cod_tipop%type;
    --v_tipo_transac auditoria.tipo_transac%type;
BEGIN
    v_id_cliente := :NEW.id_cliente;
    v_cod_tipop := :NEW.cod_tipop;
    IF UPDATING THEN
        v_accion:= 'U';
        v_saldo_anterior :=:OLD.saldoactual;
        v_saldofinal := :NEW.saldoactual;
        v_monto := ABS(v_saldofinal - v_saldo_anterior);
    ELSIF DELETING THEN
        v_accion:= 'D';
    END IF;
INSERT INTO auditoria
(id_transaccion_au, tipo_op, monto_pago, saldo_anterior, saldofinal,tabla, id_cliente, cod_tipop, fecha, usuario)
VALUES
(SEQUENCE1.nextval, v_accion, v_monto, v_saldo_anterior, v_saldofinal,v_name_tabla, v_id_cliente, v_cod_tipop, SYSDATE(), user);
END auditorias_disp;
/


   /*ELSIF INSERTING THEN
        v_accion:= 'I';
        --v_tipo_transac:= 1;
        v_saldofinal := :NEW.saldoahorro;
        v_monto := 0;
        v_saldo_anterior := 0;*/
