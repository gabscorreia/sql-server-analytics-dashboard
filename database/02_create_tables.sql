-- 1. Tabela de Clientes
CREATE TABLE tb_cliente (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50) NOT NULL,
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(2)
);

-- 2. Tabela de Vendedores
CREATE TABLE tb_vendedor (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(2)
);

-- 3. Tabela de Produtos
CREATE TABLE tb_produto (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- 4. Tabela de Pedidos (Fato Transacional de Cabeçalho)
CREATE TABLE tb_pedido (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    order_status VARCHAR(50) NOT NULL,
    purchase_timestamp DATETIME,
    approved_at DATETIME,
    delivered_carrier_date DATETIME,
    delivered_customer_date DATETIME,
    estimated_delivery_date DATETIME,
    lead_time_dias INT,
    CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (customer_id) REFERENCES tb_cliente(customer_id)
);

-- 5. Tabela de Itens do Pedido (Relacão N:N entre Pedidos e Produtos/Vendedores)
CREATE TABLE tb_item_pedido (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50) NOT NULL,
    seller_id VARCHAR(50) NOT NULL,
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id),
    CONSTRAINT FK_Item_Pedido FOREIGN KEY (order_id) REFERENCES tb_pedido(order_id),
    CONSTRAINT FK_Item_Produto FOREIGN KEY (product_id) REFERENCES tb_produto(product_id),
    CONSTRAINT FK_Item_Vendedor FOREIGN KEY (seller_id) REFERENCES tb_vendedor(seller_id)
);

-- 6. Tabela de Pagamentos
CREATE TABLE tb_pagamento (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential),
    CONSTRAINT FK_Pagamento_Pedido FOREIGN KEY (order_id) REFERENCES tb_pedido(order_id)
);

-- 7. Tabela de Geolocalização
CREATE TABLE tb_geolocalizacao (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(2)
);