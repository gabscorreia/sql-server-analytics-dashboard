-- Altera o modelo de recuperação para SIMPLE
ALTER DATABASE dbEcommerce SET RECOVERY SIMPLE;
GO

-- Libera/reduz o espaço ocupado pelo arquivo de log de transações
DBCC SHRINKFILE (2);
GO

-- Retorna o banco para o modelo de recuperação padrão
ALTER DATABASE dbEcommerce SET RECOVERY FULL;
GO



-- nome lógico do arquivo de log do seu banco de dados
SELECT name AS LogicalName, physical_name, size * 8 / 1024 AS Size_MB 
FROM sys.database_files;
