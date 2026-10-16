-- ============================================================
-- Nome: Felipe Rodrigues
-- Turma: 2DEVIS Data: 02/10/2026
-- Base: smartcoffee_dml
-- ============================================================
USE SMARTCOFFE_DML_FELIPE;;

-- 1. Cadastre dois novos clientes com dados diferentes.
INSERT INTO cliente (nome, email, telefone, cidade, ativo) VALUES
('Dandara Silva', 'dandara@email.com', '19988887777', 'Limeira', TRUE),
('Ontem da Silva Junior', 'ontem.jr@email.com', '19977776666', 'Limeira', TRUE);


-- 2. Cadastre a categoria 'Especiais da Casa'.
INSERT INTO CATEGORIAS (nome) VALUES
('Especiais da Casa');


-- 3. Localize o id da categoria criada e cadastre três produtos nela.
SET @id_categoria_especiais = LAST_INSERT_ID();

INSERT INTO PRODUTO (nome, preco, ativo, id_categoria) VALUES
('Café Especial de Baunilha', 12.50, TRUE, @id_categoria_especiais),
('Mocha de Avelã', 14.00, TRUE, @id_categoria_especiais),
('Capuccino Canela Real', 11.00, TRUE, @id_categoria_especiais);


-- 4. Cadastre um terceiro cliente sem telefone.
INSERT INTO CLIENTE (nome, email, telefone, cidade, ativo) VALUES
('Lucas Santos', 'lucas.santos@email.com', NULL, 'Limeira', TRUE);


-- 5. Crie um novo pedido para um dos clientes cadastrados.
SET @id_cliente_lucas = LAST_INSERT_ID();

INSERT INTO PEDIDO (data_pedido, status_pedido, valor_total, id_cliente) VALUES
(NOW(), 'ABERTO', 0.00, @id_cliente_lucas);


-- 6. Use LAST_INSERT_ID() para guardar o id do pedido em @pedido_atividade
--    e insira pelo menos dois itens nesse pedido.
SET @pedido_atividade = LAST_INSERT_ID();

INSERT INTO ITEM_PEDIDO (id_pedido, id_produto, quantidade, preco_unitario, observacao) VALUES
(@pedido_atividade, 1, 2, 12.50, 'Pouco açúcar'),
(@pedido_atividade, 2, 1, 14.00, 'Com chantilly extra');


-- 7. Corrija o telefone de um dos clientes criados.

SELECT * FROM CLIENTE WHERE id_cliente = 1;

UPDATE CLIENTE
SET telefone = '19991234567'
WHERE id_cliente = 1;

SELECT * FROM CLIENTE WHERE email = 'lucas.santos@email.com';


-- 8. Altere cidade e telefone de outro cliente em um único UPDATE.

SELECT * FROM CLIENTE WHERE email = 'dandara@email.com';

UPDATE CLIENTE
SET cidade = 'Campinas',
    telefone = '19981112222'
WHERE email = 'dandara@email.com';

SELECT * FROM CLIENTE WHERE email = 'dandara@email.com';


-- 9. Aumente em 8% o preço dos produtos da categoria 'Especiais da Casa'.

SELECT * FROM PRODUTO WHERE id_categoria = @id_categoria_especiais;


UPDATE PRODUTO
SET preco = preco * 1.08
WHERE id_categoria = @id_categoria_especiais;

SELECT * FROM PRODUTO WHERE id_categoria = @id_categoria_especiais;


-- 10. Altere o status do pedido criado para 'PREPARANDO'.

SELECT * FROM PEDIDO WHERE id_pedido = @pedido_atividade;


UPDATE PEDIDO
SET status_pedido = 'PREPARANDO'
WHERE id_pedido = @pedido_atividade;

SELECT * FROM PEDIDO WHERE id_pedido = @pedido_atividade;


-- 11. Atualize valor_total do pedido de acordo com os itens cadastrados.

SELECT SUM(quantidade * preco_unitario) AS total_calculado 
FROM ITEM_PEDIDO 
WHERE id_pedido = @pedido_atividade;

UPDATE PEDIDO
SET valor_total = (
    SELECT SUM(quantidade * preco_unitario) 
    FROM ITEM_PEDIDO 
    WHERE id_pedido = @pedido_atividade
)
WHERE id_pedido = @pedido_atividade;

SELECT * FROM PEDIDO WHERE id_pedido = @pedido_atividade;


-- 12. Escolha um dos produtos criados e faça uma exclusão lógica (ativo = FALSE).

SELECT * FROM PRODUTO WHERE nome = 'Mocha de Avelã';

UPDATE PRODUTO
SET ativo = FALSE
WHERE nome = 'Mocha de Avelã';


-- 13. Crie um cliente de teste sem pedidos.

INSERT INTO CLIENTE (nome, email, telefone, cidade, ativo) VALUES
('bruna', 'bruna@email.com', '19900000000', 'Limeira', TRUE);

SELECT * FROM CLIENTE WHERE email = 'bruna@email.com';

DELETE FROM CLIENTE WHERE email = 'bruna@email.com';

SELECT * FROM CLIENTE WHERE email = 'bruna@email.com';


-- 14. Tente excluir um cliente da base original que possua pedidos.
--     Deixe o DELETE comentado após o teste e descreva o erro abaixo.

-- DELETE FROM CLIENTE WHERE id_cliente = 1;

-- Resultado observado:
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`smartcoffee_dml`.`pedido`, CONSTRAINT `fk_pedido_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`))


-- 15. Explique em comentário por que a FK bloqueou a exclusão.
-- Resposta: O Foreign Key garante a Integridade do banco de dados. 
-- Como existem registros na tabela filho apontando para o id_cliente = 1 da tabela pai, 
-- o SGBD impede a exclusão para não gerar "pedidos órfãos".


-- 16. Crie uma categoria temporária chamada 'Excluir Depois' e remova-a.
INSERT INTO CATEGORIAS (nome) VALUES ('Excluir Depois');

SELECT * FROM CATEGORIAS WHERE nome = 'Excluir Depois';

DELETE FROM CATEGORIAS WHERE nome = 'Excluir Depois';

SELECT * FROM CATEGORIAS WHERE nome = 'Excluir Depois';

-- PARTE D - INTEGRIDADE E ERROS CONTROLADOS
-- Execute uma tentativa por vez. Depois deixe o comando problemático comentado.

-- 17. Tente inserir um produto com id_categoria = 9999.
-- Qual restrição impediu a operação?

iNSERT INTO PRODUTO (nome, preco, ativo, id_categoria) VALUES
('Produto Inexistente', 10.00, TRUE, 9999);


-- 18. Tente cadastrar um cliente usando 'ana@email.com'.
-- Qual restrição impediu a operação?






-- 19. Tente criar um pedido com id_cliente = 9999.
-- Qual restrição impediu a operação?


-- 20. Escreva em comentários a diferença entre os três erros anteriores.


-- PARTE E - DESAFIO COMPLETO COM TRANSAÇÃO

-- 21. Inicie uma transação.


-- 22. Dentro dela, cadastre um cliente, um pedido e dois itens relacionados.


-- 23. Faça uma consulta com JOIN comprovando que os registros existem
--     enquanto a transação está aberta.


-- 24. Execute ROLLBACK e depois use SELECT para provar que o cadastro foi desfeito.


-- 25. Repita o processo com novos dados e finalize usando COMMIT.
--     Depois consulte os registros persistidos.


-- DESAFIO EXTRA
-- 26. Escolha uma situação realista do SmartCoffee que exija INSERT + UPDATE
--     ou UPDATE + DELETE lógico. Descreva a regra de negócio e implemente.