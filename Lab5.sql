--LABORATORIO 5
---------------------------------------------------------------------------------------------------------
--TABLAS
---------------------------------------------------------------------------------------------------------
CREATE TABLE profesion(
	cod_profesion varchar2(4) NOT NULL,
	descripcion varchar2(50) NOT NULL,
	CONSTRAINT cod_profesion_PK PRIMARY KEY (cod_profesion)
);

CREATE TABLE cliente(
	id_cliente number(4) NOT NULL,
	cedula varchar2(15) NOT NULL,
	nombre varchar2(50) NOT NULL,
	apellido varchar2(50) NOT NULL,
	sexo char NOT NULL,
	fecha_nac date NOT NULL,
	cod_profesion varchar2(4) NOT NULL,
	CONSTRAINT id_cliente_PK PRIMARY KEY(id_cliente),
	CONSTRAINT FK_cod_profesion
		FOREIGN KEY (cod_profesion)
		REFERENCES profesion(cod_profesion)
);

CREATE TABLE tipo_email(
	cod_tipoe varchar2(4) NOT NULL,
	descripcion varchar(50) NOT NULL,
	CONSTRAINT cod_tipoe_PK PRIMARY KEY(cod_tipoe)
);

CREATE TABLE email(
	id_cliente number(4) NOT NULL,
	cod_tipoe varchar2(4) NOT NULL,
	email varchar2(50) NOT NULL,
	CONSTRAINT FK_cod_tipoe
		FOREIGN KEY (cod_tipoe)
		REFERENCES tipo_email(cod_tipoe),
	CONSTRAINT FK_id_cliente
		FOREIGN KEY (id_cliente)
		REFERENCES cliente(id_cliente)
);

CREATE TABLE tipo_tel(
	cod_tipotel varchar2(4) NOT NULL,
	descripcion varchar(50) NOT NULL,
	CONSTRAINT cod_tipotel_PK PRIMARY KEY(cod_tipotel)
);

CREATE TABLE telefono(
	id_cliente number(4) NOT NULL,
	cod_tipotel varchar2(4) NOT NULL,
	telefono varchar2(9) NOT NULL,
	CONSTRAINT FK_cod_tipotel
		FOREIGN KEY (cod_tipotel)
		REFERENCES tipo_tel(cod_tipotel),
	CONSTRAINT FK_id_cliente2
		FOREIGN KEY (id_cliente)
		REFERENCES cliente(id_cliente)
);

CREATE TABLE tipo_prestamo(
	cod_tipop varchar2(4) NOT NULL,
	descripcion varchar(50) NOT NULL,
	cod_sucursal varchar2(4) NOT NULL,
	CONSTRAINT cod_tipop_PK PRIMARY KEY(cod_tipop)
);

CREATE TABLE prestamo(
	id_cliente number(4) NOT NULL,
	cod_tipop varchar2(4) NOT NULL,
	num_p number(10) NOT NULL,
	f_aprobado date NOT NULL,
	m_aprobado number(9,2) NOT NULL,
	tasa number(9,2) NOT NULL,
	letra number(9,2) NOT NULL,
	m_pagado number(9,2) NOT NULL,
	f_pago date NOT NULL,
	CONSTRAINT FK_id_cliente3
		FOREIGN KEY (id_cliente)
		REFERENCES cliente(id_cliente),
	CONSTRAINT FK_cod_tipop
		FOREIGN KEY (cod_tipop)
		REFERENCES tipo_prestamo(cod_tipop)
);

ALTER TABLE cliente
	ADD edad number(3) DEFAULT 0 NOT NULL;

CREATE TABLE sucursales(
	cod_sucursal varchar2(4) NOT NULL,
	nombre_suc varchar2(50) NOT NULL,
	monto number (9,2) DEFAULT 0 NOT NULL, 
	cantidad_pres number(12) DEFAULT 0 NOT NULL,
	CONSTRAINT codsuc_PK PRIMARY KEY(cod_sucursal)
);

ALTER TABLE cliente
	ADD cod_sucursal varchar(4) NOT NULL
		CONSTRAINT cliente_cod_sucursal_fk
			REFERENCES sucursales(cod_sucursal);

ALTER TABLE prestamo
	ADD (
		cod_sucursal varchar(4) NOT NULL
			CONSTRAINT prestamo_cod_sucursal_fk
				REFERENCES sucursales(cod_sucursal)
);

ALTER TABLE prestamo
	ADD (
		saldoactual number(9,2) DEFAULT 0 NOT NULL,
		interespagado number(9,2) DEFAULT 0 NOT NULL,
		usuario varchar(15) NOT NULL,
		fechamodificacion date NOT NULL
);

CREATE TABLE transacpagos (
	cod_sucursal varchar2(4) NOT NULL,
	id_transaccion varchar2(4) NOT NULL, 
	id_cliente number(4) NOT NULL, 
	cod_tipop varchar2(4) NOT NULL,  
	fecha_transaccion date NOT NULL, 
	monto_pago number(9,2) NOT NULL, 
	fecha_insercion date,
	status char DEFAULT 'N' NOT NULL,
	usuario varchar(15) NOT NULL, 
	CONSTRAINT transaccion_PK PRIMARY KEY (id_transaccion),
	CONSTRAINT FK_id_cliente4
		FOREIGN KEY (id_cliente)
		REFERENCES cliente(id_cliente),
	CONSTRAINT FK_cod_tipop3
		FOREIGN KEY (cod_tipop)
		REFERENCES tipo_prestamo(cod_tipop)
);

CREATE TABLE suc_tipo_prest(
	cod_sucursal varchar2(4) NOT NULL, 
	cod_tipop varchar2(4) NOT NULL, 
	monto number(9,2) DEFAULT 0 NOT NULL, 
	cantidad_pres number(12) DEFAULT 0 NOT NULL,
	CONSTRAINT FK_cod_sucursal2
		FOREIGN KEY (cod_sucursal)
		REFERENCES sucursales(cod_sucursal),
	CONSTRAINT FK_cod_tipop4
		FOREIGN KEY (cod_tipop)
		REFERENCES tipo_prestamo(cod_tipop)
);

CREATE TABLE auditoria(
	id_transaccion_au number(4) NULL,
	tabla varchar2(20) NULL,
	tipo_op char NULL,
    id_cliente number(4) NULL,
	cod_tipop varchar2(4) NULL,
	--tipo_transac number(1) NULL,
	saldo_anterior number(9,2) NULL,
	monto_pago number(9,2) NULL,
	saldofinal number(9,2) NULL,
	usuario varchar2(10) NULL,
	fecha date,
	CONSTRAINT PK_id_transaccion_au PRIMARY KEY (id_transaccion_au),
	CONSTRAINT FK_id_cliente_auditoria FOREIGN KEY (id_cliente)
		REFERENCES cliente(id_cliente),
	CONSTRAINT FK_cod_tipop_auditoria FOREIGN KEY (cod_tipop)
		REFERENCES tipo_prestamo(cod_tipop),
    CONSTRAINT ch_tipo_op
        CHECK (tipo_op IN ('I', 'U', 'D'))
    --, CONSTRAINT ch_tipo_transac
      --  CHECK (tipo_transac IN ('1','2'))
);

---------------------------------------------------------------------------------------------------------
--PROCEDIMIENTOS
---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE nuevo_tipo_profesion(
	p_codigo in profesion.cod_profesion%Type,
	P_Tipo_profesion in profesion.descripcion%type) is
BEGIN
	insert into profesion(cod_profesion, descripcion) 
	values (p_codigo, p_tipo_profesion);
exception
	WHEN dup_val_on_index THEN
		DBMS_OUTPUT.PUT_LINE('Valores duplicados');
	WHEN others THEN
		DBMS_OUTPUT.PUT_LINE('Error desconocido');
END;
/


CREATE OR REPLACE PROCEDURE nueva_sucursal(
	p_codigo_sucursal in sucursales.cod_sucursal%type,
	P_nombre_sucursal in sucursales.nombre_suc%type) is
BEGIN
	insert into sucursales
	values (p_codigo_sucursal, p_nombre_sucursal, 0, 0);
exception
	WHEN dup_val_on_index THEN
		DBMS_OUTPUT.PUT_LINE('Valores duplicados');
	WHEN others THEN
		DBMS_OUTPUT.PUT_LINE('Error desconocido');
END;
/


create or replace function edad_cliente(
	p_fecha_nac in cliente.fecha_nac%type)
	return cliente.edad%type is
BEGIN
	return (sysdate- to_date(p_fecha_nac))/365.25;
END edad_cliente;
/

create sequence cont_cliente
start with 1
increment by 1;

CREATE OR REPLACE PROCEDURE Insertar_cliente (
	p_cedula in cliente.cedula%type,
	p_nombre in cliente.nombre%type,
	p_apellido in cliente.apellido%type,
	p_sexo in cliente.sexo%type,
 	p_fecha_nac in cliente.fecha_nac%Type,
	p_profesion in cliente.cod_profesion%type,
	p_sucursal in cliente.cod_sucursal%type) is
	v_edad cliente.edad%type;
BEGIN
	v_edad := edad_cliente(p_fecha_nac);
	insert into cliente (id_cliente, cedula, nombre, apellido, sexo, fecha_nac, cod_profesion, edad, cod_sucursal) 
	values (cont_cliente.nextval, p_cedula, p_nombre, p_apellido, p_sexo, p_fecha_nac, p_profesion, v_edad, p_sucursal);
EXCEPTION
	WHEN dup_val_on_index THEN
		DBMS_OUTPUT.PUT_LINE('Valores duplicados');
	WHEN others THEN
		DBMS_OUTPUT.PUT_LINE('Error desconocido');
END;
/


CREATE OR REPLACE PROCEDURE nuevo_tipo_telefono(
	p_codigo in tipo_tel.cod_tipotel%type,
	p_tipo_telefono in tipo_tel.descripcion%type) is
BEGIN
	insert into tipo_tel (cod_tipotel, descripcion) 
	values (p_codigo, p_tipo_telefono);
exception
	WHEN dup_val_on_index THEN
		DBMS_OUTPUT.PUT_LINE('Valores duplicados');
	WHEN others THEN
		DBMS_OUTPUT.PUT_LINE('Error desconocido');
END;
/


CREATE OR REPLACE PROCEDURE nuevo_telefono(
	p_codigo in telefono.id_cliente%type,
	p_telefono in telefono.telefono%type,
	p_cod_tipotel in telefono.cod_tipotel%type) is
BEGIN
	insert into telefono (id_cliente, telefono, cod_tipotel) 
	values (p_codigo, p_telefono, p_cod_tipotel);
exception
	WHEN dup_val_on_index THEN
		DBMS_OUTPUT.PUT_LINE('Valores duplicados');
	WHEN others THEN
		DBMS_OUTPUT.PUT_LINE('Error desconocido');
END;
/


CREATE OR REPLACE PROCEDURE nuevo_tipo_email(
	p_codigo in tipo_email.cod_tipoe%Type,
	p_tipo_email in tipo_email.descripcion%type) is
BEGIN
	insert into tipo_email (cod_tipoe, descripcion) 
	values (p_codigo, p_tipo_email);
exception
	WHEN dup_val_on_index THEN
		DBMS_OUTPUT.PUT_LINE('Valores duplicados');
	WHEN others THEN
		DBMS_OUTPUT.PUT_LINE('Error desconocido');
END;
/


CREATE OR REPLACE PROCEDURE nuevo_email(
	p_codigo in email.id_cliente%Type,
	P_cod_tipoe in email.cod_tipoe%type,
	p_email in email.email%Type) is
BEGIN
	insert into email (id_cliente, cod_tipoe, email) 
	values (p_codigo, p_cod_tipoe, p_email);
exception
	WHEN dup_val_on_index THEN
		DBMS_OUTPUT.PUT_LINE('Valores duplicados');
	WHEN others THEN
		DBMS_OUTPUT.PUT_LINE('Error desconocido');
END;
/


CREATE OR REPLACE PROCEDURE nuevo_tipo_prestamo(
	p_codigo in tipo_prestamo.cod_tipop%Type,
	p_tipo_prestamo in tipo_prestamo.descripcion%type,
	p_cod_sucursal in tipo_prestamo.cod_sucursal%type) is
BEGIN
	insert into tipo_prestamo
	values (p_codigo, p_tipo_prestamo, p_cod_sucursal);
exception
	WHEN dup_val_on_index THEN
		DBMS_OUTPUT.PUT_LINE('Valores duplicados');
	WHEN others THEN
		DBMS_OUTPUT.PUT_LINE('Error desconocido');
END;
/


create sequence num_p
start with 1
increment by 1;


/*
BEGIN 
	insertar_prestamo( 1,'TP01','09/07/2021',2300.00, 2.5, 115.00, 0.00, '12/09/2021','S001',2300.00, 0.00, '03/06/2022');
	insertar_prestamo( 2,'TP02','09/07/2021',5000.00, 1.5, 500.00, 0.00, '12/09/2021','S001',5000.00, 0.00, '03/06/2022');
	insertar_prestamo( 3,'TP03','09/07/2021',6000.00, 2.0, 600.00, 0.00, '12/09/2021','S001',6000.00, 0.00, '03/06/2022');
	insertar_prestamo( 4,'TP05','09/07/2021',8300.00, 3.0, 600.00, 0.00, '12/09/2021','S001',8300.00, 0.00, '03/06/2022');
END;
/
*/

CREATE OR REPLACE PROCEDURE insertar_prestamo(
	p_id_cliente in prestamo.id_cliente%type,
	p_cod_tipop in prestamo.cod_tipop%type,
	p_f_aprobado in prestamo.f_aprobado%type,
	p_m_aprobado in prestamo.m_aprobado%type,
	p_tasa in prestamo.tasa%Type,
	p_letra in prestamo.letra%type,
	p_m_pagado in prestamo.m_pagado%type,
	p_f_pago in prestamo.f_pago%type,
	p_cod_sucursal in prestamo.cod_sucursal%type,
	p_saldo_actual in prestamo.saldoactual%type,
	p_interes_pagado in prestamo.interespagado%type,
	p_fecha_modificacion in prestamo.fechamodificacion%type) is
BEGIN
	insert into prestamo values (p_id_cliente, p_cod_tipop, num_p.nextval, 
	p_f_aprobado, p_m_aprobado, p_tasa, p_letra, p_m_pagado, p_f_pago, 
	p_cod_sucursal, p_saldo_actual, p_interes_pagado,
	user, p_fecha_modificacion);
	
	update sucursales
	set monto = monto + p_m_aprobado,
            cantidad_pres = cantidad_pres + 1
	where cod_sucursal = p_cod_sucursal;

	update suc_tipo_prest
	set monto = monto + p_m_aprobado,
	cantidad_pres = cantidad_pres +1
	where (cod_sucursal = p_cod_sucursal) and (cod_tipop = p_cod_tipop);

	if sql%notfound then
		insert into suc_tipo_prest values (p_cod_sucursal, p_cod_tipop, p_m_aprobado,
		1);
	end if;
EXCEPTION
	WHEN dup_val_on_index THEN
		DBMS_OUTPUT.PUT_LINE('Valores duplicados');
END;
/



create sequence id_transac
	start with 1 
	increment by 1;

CREATE OR REPLACE PROCEDURE introducir_transac_pago(
	p_id_cliente in transacpagos.id_cliente%type,
	p_cod_tipop in transacpagos.cod_tipop%type,
	p_cod_sucursal in transacpagos.cod_sucursal%Type,
	p_fecha_transaccion in transacpagos.fecha_transaccion%type,
	p_monto_pago in transacpagos.monto_pago%type) is
BEGIN
	insert into transacpagos (id_transaccion, id_cliente, cod_tipop, 
cod_sucursal, fecha_transaccion, monto_pago, status, usuario)
	values (id_transac.nextval, p_id_cliente, p_cod_tipop, 
p_cod_sucursal, p_fecha_transaccion, p_monto_pago, 'N', user);
EXCEPTION
	WHEN dup_val_on_index THEN
		DBMS_OUTPUT.PUT_LINE('Valores duplicados');
	WHEN others THEN
		DBMS_OUTPUT.PUT_LINE('Error desconocido');
END;
/


CREATE OR REPLACE FUNCTION calcularInteres(
	p_interes in prestamo.interespagado%type, 
	p_monto in prestamo.m_aprobado%type)
	RETURN prestamo.interespagado%type is
BEGIN
	return (p_monto * p_interes)/100;
END calcularInteres;
/

CREATE OR REPLACE PROCEDURE ActualizarPagos IS
	v_idcliente prestamo.id_cliente%type;
	v_tasa prestamo.tasa%type;
	v_interes prestamo.tasa%type;
	v_NewMonto prestamo.saldoactual%type;
	v_NewSalPrestamo prestamo.saldoactual%type;
	v_salPrestamo prestamo.saldoActual%type;
	v_m_pagado prestamo.m_pagado%type;
	v_interespagado prestamo.interespagado%type;
	v_cod_tipop prestamo.cod_tipop%type;

	v_montoPagado transacpagos.monto_pago%type;
	
	v_codSucursal sucursales.cod_sucursal%type;	
	v_montoSucursal sucursales.monto%type;
	v_cantidadPrestamos sucursales.cantidad_pres%type;

	v_montoxtipo suc_tipo_prest.monto%type;

	CURSOR c_calPrestamo IS 
		SELECT m_aprobado, tasa, m_pagado, interespagado
		FROM prestamo;

	CURSOR c_calTransacPagos IS 
		SELECT monto_pago, id_cliente, cod_tipop  
		FROM transacpagos
		WHERE (status = 'N');
	
	CURSOR c_sucursal IS 
		SELECT cod_sucursal, cantidad_pres, monto 
		FROM sucursales;
	
	CURSOR c_suc_tipo_prest IS
		SELECT monto
		FROM suc_tipo_prest;

	BEGIN	
		OPEN c_calPrestamo;
		OPEN c_calTransacPagos;
		OPEN c_sucursal;
		OPEN c_suc_tipo_prest;
		LOOP
			FETCH c_calPrestamo INTO v_salPrestamo, v_tasa,
			v_m_pagado, v_interespagado;
			FETCH c_calTransacPagos INTO v_montoPagado, v_idcliente, 
			v_cod_tipop;
			FETCH c_sucursal INTO v_codSucursal, v_cantidadPrestamos,
			v_montoSucursal;
			FETCH c_suc_tipo_prest INTO v_montoxtipo;

			EXIT WHEN c_calPrestamo%NOTFOUND;

			v_interes := calcularInteres(v_tasa, v_salPrestamo);
			v_NewMonto := v_montoPagado - v_interes;
			v_NewSalPrestamo := v_salPrestamo - v_NewMonto;
			v_montoSucursal := v_montoSucursal - v_NewMonto;
			v_m_pagado := v_m_pagado + v_NewMonto;
			v_interespagado := v_interespagado + v_interes;
			v_montoxtipo := v_montoxtipo - v_NewMonto;
			
			IF (v_NewSalPrestamo = 0) THEN 
				v_cantidadPrestamos := v_cantidadPrestamos - 1;
			END IF;
		
		UPDATE transacpagos
		SET status = 'S';

		UPDATE prestamo
		SET saldoActual= v_NewSalPrestamo,
			f_pago = sysdate, 
			m_pagado = v_m_pagado, 
			interespagado = v_interespagado 
		WHERE (id_cliente = v_idcliente)
		AND (cod_tipop = v_cod_tipop);
	
		UPDATE sucursales 
		SET monto = v_montoSucursal 
		WHERE cod_sucursal = v_codSucursal;
		
		UPDATE suc_tipo_prest
		SET monto = v_montoxtipo 
		WHERE (cod_sucursal = v_codSucursal) 
		AND (cod_tipop = v_cod_tipop);

	END LOOP;

	CLOSE c_calPrestamo;
	CLOSE c_calTransacPagos;
	CLOSE c_sucursal;
	CLOSE c_suc_tipo_prest;

END;
/

---------------------------------------------------------------------------------------------------------
--INSERT
---------------------------------------------------------------------------------------------------------
--PROFESIÓN
BEGIN
	nuevo_tipo_profesion('PR01', 'Abogado');
	nuevo_tipo_profesion('PR02', 'Profesor');
	nuevo_tipo_profesion('PR03', 'Mecánico');
END;
/

--SUCURSAL
BEGIN
	nueva_sucursal('S001', 'Casa Matriz');
END;
/

--CLIENTE
BEGIN
	Insertar_cliente('8-979-2047', 'Daniela', 'Mosocoso', 'F', '08/07/1997', 'PR01', 'S001');
	Insertar_cliente('8-258-455', 'Chantal', 'De Gracia', 'F', '08/07/2000', 'PR02', 'S001');
	Insertar_cliente('8-987-8125', 'Rocio', 'Cortez', 'F', '08/05/2001', 'PR03', 'S001');
	Insertar_cliente('8-441-2588', 'Romas', 'Lescure', 'M', '09/04/2001', 'PR03', 'S001');
END;
/

--TIPO TELÉFONO
BEGIN
	nuevo_tipo_telefono('TT01', 'Celular');
	nuevo_tipo_telefono('TT02', 'Residencia');
	nuevo_tipo_telefono('TT03', 'Familiar cercano');
	nuevo_tipo_telefono('TT05', 'Laboral');
END;
/

--TELÉFONO
BEGIN
	Nuevo_Telefono('4', '6258-5877', 'TT01');
	Nuevo_Telefono('2', '6675-2258', 'TT02');
	Nuevo_Telefono('3', '6675-4458', 'TT03');
	Nuevo_Telefono('1', '6675-8875', 'TT05');
END;
/

--TIPO EMAIL
BEGIN
	nuevo_tipo_email('EM01', 'Personal');
END;
/

--EMAIL
BEGIN
	nuevo_email(1, 'EM04', 'danikarma@gmail.COM');
	nuevo_email(2, 'EM04', 'itgirl@hotmail.COM');
	nuevo_email(3, 'EM04', 'rocioca@gmail.COM');
	nuevo_email(4, 'EM04', 'romasalex@gmail.COM');
END;
/

--TIPO PRÉSTAMO
BEGIN
	nuevo_tipo_prestamo('TP01', 'Personal', 'S001');
	nuevo_tipo_prestamo('TP02', 'Auto', 'S001');
	nuevo_tipo_prestamo('TP03', 'Hipoteca', 'S001');
	nuevo_tipo_prestamo('TP05', 'Escolar', 'S001');
END;
/

--PRÉSTAMO
BEGIN 
	insertar_prestamo( 1,'TP01','09/07/2021',2300.00, 2.5, 115.00, 0.00, '12/09/2021','S001',2300.00, 0.00, '03/06/2022');
	insertar_prestamo( 2,'TP02','09/07/2021',5000.00, 1.5, 500.00, 0.00, '12/09/2021','S001',5000.00, 0.00, '03/06/2022');
	insertar_prestamo( 3,'TP03','09/07/2021',6000.00, 2.0, 600.00, 0.00, '12/09/2021','S001',6000.00, 0.00, '03/06/2022');
	insertar_prestamo( 4,'TP05','09/07/2021',8300.00, 3.0, 600.00, 0.00, '12/09/2021','S001',8300.00, 0.00, '03/06/2022');
END;
/

--TRANSAC_PAGOS
BEGIN 
	introducir_transac_pago(1, 'TP01', 'S001', '05/08/2021', 15);
	introducir_transac_pago(2, 'TP02', 'S001', '05/08/2021', 500);
	introducir_transac_pago(3, 'TP03', 'S001', '05/08/2021', 600);
	introducir_transac_pago(4, 'TP05', 'S001', '05/08/2021', 600);
END;
/


--Procedimientos de actualización
/*
BEGIN 
	ActualizarPagos();
END;
/

SELECT * FROM PRESTAMO;

SELECT * FROM transacpagos;

SELECT * FROM suc_tipo_prest;

SELECT * FROM sucursales;

SELECT * from auditoria;

--Procedimientos de actualización
BEGIN 
	ActualizarPagos();
END;
/
*/