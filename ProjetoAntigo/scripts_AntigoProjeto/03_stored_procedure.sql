INSERT INTO tb_canal (nm_canal) VALUES 
('Lojas Próprias'), ('Venda Direta'), ('E-Commerce');

INSERT INTO tb_alavanca (nm_alavanca, ds_categoria, ds_tipo) VALUES
('Boleto Promocionado', 'Alavancas Comerciais', 'Fluxo'),
('Boleto Turbinado', 'Alavancas Comerciais', 'Fluxo'),
('Compre e Leve', 'Alavancas Comerciais', 'Fluxo'),
('Desconto Sarrafo', 'Alavancas Comerciais', 'Fluxo'),
('Desconto Progressivo', 'Alavancas de Produtividade', 'Produtividade');

INSERT INTO tb_cliente (nm_cliente, ds_tipoCliente) VALUES
('Mariana Silva', 'CP'),
('Fernanda Lima', 'CP'),
('Lucas Rocha', 'Consumidor'),
('Camila Alves', 'CP');

INSERT INTO tb_ciclo (cd_ciclo, dt_ano, dt_inicio, dt_fim) VALUES
('C01', 2026, '2026-01-01', '2026-01-21'),
('C02', 2026, '2026-01-22', '2026-02-15'),
('C03', 2026, '2026-02-16', '2026-03-08'),
('C04', 2026, '2026-03-09', '2026-03-29'),
('C05', 2026, '2026-03-30', '2026-04-19'),
('C06', 2026, '2026-04-20', '2026-05-10'); -- <-- Cobre os dias 20/04 a 23/04


CREATE PROCEDURE sp_InjetarVendasDia
    @dt_venda DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_ciclo INT,
            @id_cliente INT,
            @id_canal INT,
            @id_alavanca INT,
            @id_pedido INT,
            @qtd_itens INT,
            @i INT = 1,
            @qtd_pedidos_hoje INT;

    SELECT TOP 1 @id_ciclo = id_ciclo 
    FROM tb_ciclo 
    WHERE @dt_venda BETWEEN dt_inicio AND dt_fim;

    IF @id_ciclo IS NULL
    BEGIN
        RAISERROR('Erro: A data informada não pertence a nenhum ciclo cadastrado em tb_ciclo.', 16, 1);
        RETURN;
    END

    SET @qtd_pedidos_hoje = FLOOR(RAND() * 6) + 3;

    WHILE @i <= @qtd_pedidos_hoje
    BEGIN
        
        SELECT TOP 1 @id_cliente = id_cliente FROM tb_cliente ORDER BY NEWID();
        SELECT TOP 1 @id_canal = id_canal FROM tb_canal ORDER BY NEWID();

        INSERT INTO tb_pedido (dt_pedido, id_cliente, id_canal, id_ciclo)
        VALUES (
            CAST(@dt_venda AS DATETIME) + CAST(TIMEFROMPARTS(FLOOR(RAND()*12)+8, FLOOR(RAND()*59), FLOOR(RAND()*59), 0, 0) AS DATETIME),
            @id_cliente, 
            @id_canal, 
            @id_ciclo
        );

        SET @id_pedido = SCOPE_IDENTITY();

        SELECT TOP 1 @id_alavanca = id_alavanca FROM tb_alavanca ORDER BY NEWID();
        SET @qtd_itens = FLOOR(RAND() * 12) + 1;

        INSERT INTO tb_item_pedido (id_pedido, id_alavanca, qt_item, vl_unitario, vl_desconto)
        VALUES (
            @id_pedido, 
            @id_alavanca, 
            @qtd_itens, 
            ROUND((RAND() * 70) + 15, 2), 
            ROUND(RAND() * 4, 2)
        );

        SET @i = @i + 1;
    END

    PRINT 'Massa de dados gerada com sucesso para a data: ' + CAST(@dt_venda AS VARCHAR);
END;
GO