CREATE TABLE tb_ciclo (
id_ciclo INT IDENTITY(1,1) PRIMARY KEY,
cd_ciclo char(3) NOT NULL,
dt_ano SMALLINT NOT NULL,
dt_inicio DATE NOT NULL,
dt_fim DATE NOT NULL
);

CREATE TABLE tb_alavanca (
id_alavanca INT IDENTITY(1,1) PRIMARY KEY,
nm_alavanca VARCHAR(35) NOT NULL,
ds_categoria VARCHAR(35) NOT NULL,
ds_tipo VARCHAR(20)  NOT NULL
);

CREATE TABLE tb_canal (
id_canal INT IDENTITY(1,1) PRIMARY KEY,
nm_canal CHAR(10),
);

CREATE TABLE tb_cliente (
id_cliente INT IDENTITY(1,1) PRIMARY KEY,
nm_cliente VARCHAR(60) NOT NULL,
ds_tipoCliente CHAR(10) NOT NULL
);

CREATE TABLE tb_pedido (
id_pedido INT IDENTITY(1,1) PRIMARY KEY,
dt_pedido DATE NOT NULL,
id_cliente INT NOT NULL,
id_canal INT NOT NULL,
id_ciclo INT NOT NULL,

  CONSTRAINT FK_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES tb_cliente(id_cliente),
  CONSTRAINT FK_pedido_canal FOREIGN KEY (id_canal) REFERENCES tb_canal(id_canal),
  CONSTRAINT FK_pedido_ciclo FOREIGN KEY (id_ciclo) REFERENCES tb_ciclo(id_ciclo)
);

CREATE TABLE tb_item_pedido (
id_item_pedido INT IDENTITY(1,1) PRIMARY KEY,
id_pedido INT NOT NULL,
id_alavanca INT NOT NULL,
qt_item INT NOT NULL,
vl_unitario DECIMAL(10,2) NOT NULL,
vl_desconto DECIMAL(10,2) DEFAULT 0.00,

  CONSTRAINT FK_item_pedido FOREIGN KEY (id_pedido) REFERENCES tb_pedido(id_pedido),
    CONSTRAINT FK_item_alavanca FOREIGN KEY (id_alavanca) REFERENCES tb_alavanca(id_alavanca)
);

ALTER TABLE tb_canal 
ALTER COLUMN nm_canal VARCHAR(30) NOT NULL;