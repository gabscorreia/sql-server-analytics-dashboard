CREATE TABLE tb_ciclo(
id_ciclo int PRIMARY KEY,
cod_ciclo char(3),
dt_ano smallint,
dt_inicio date,
dt_fim date,
);

CREATE TABLE tb_alavanca(
id_alavanca int PRIMARY KEY,
nm_alavanca varchar(25),
nm_categoria varchar(25),
nm_tipo varchar(20)
);

CREATE TABLE tb_canal(
id_canal int PRIMARY KEY,
nome_canal char(10),
);
EXEC sp_rename 'tb_canal.nome_canal', 'nm_canal', 'COLUMN';

CREATE TABLE tb_cliente(
id_cliente int PRIMARY KEY,
nm_cliente varchar(68),
ds_tipoCliente varchar(20),
);