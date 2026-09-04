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