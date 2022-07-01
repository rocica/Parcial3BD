CREATE SEQUENCE id_auditoria
    START WITH 1
    INCREMENT BY 1;

CREATE OR REPLACE TRIGGER insert_auditoria
AFTER INSERT ON prestamo FOR EACH ROW
BEGIN
INSERT INTO auditoria (id_transaccion_au, tabla, id_cliente, cod_tipop, tipo_op, saldo_anterior, monto_pago, saldofinal, Usuario, Fecha)
VALUES (id_auditoria.nextval, 'prestamo', :NEW.id_cliente, :NEW.cod_tipop, 'I', 0, 0,  :NEW.saldoactual,  user, sysdate ());
END insert_auditoria;
/
