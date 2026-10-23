-- Active: 1788520782564@@127.0.0.1@3306@smartcoffee_dml_felipe
-- ============================================================
-- Nome: Felipe Rodrigues
-- Turma: 2DEVIS Data: 02/10/2026
-- Base: smartcoffee_dml
-- ============================================================

USE SMARTCOFFE_DML_FELIPE;


-- 1. Cadastre dois novos clientes com dados diferentes.

INSERT INTO CLIENTE (nome, email, telefone, cidade, ativo) VALUES
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
-- e insira pelo menos dois itens nesse pedido.

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
-- Deixe o DELETE comentado após o teste e descreva o erro abaixo.

-- DELETE FROM CLIENTE WHERE id_cliente = 1;

-- Resultado observado:
-- Error Code: 1451. Cannot delete or update a parent row:
-- a foreign key constraint fails.
-- A tabela PEDIDO possui registros relacionados a esse cliente.


-- 15. Explique em comentário por que a FK bloqueou a exclusão.

-- Resposta:
-- A FOREIGN KEY garante a integridade referencial do banco de dados.
-- Como existem registros na tabela filha PEDIDO apontando para
-- o id_cliente = 1 da tabela CLIENTE, o SGBD impede a exclusão
-- para evitar pedidos órfãos.


-- 16. Crie uma categoria temporária chamada 'Excluir Depois' e remova-a.

INSERT INTO CATEGORIAS (nome) VALUES ('Excluir Depois');

SELECT * FROM CATEGORIAS WHERE nome = 'Excluir Depois';

DELETE FROM CATEGORIAS WHERE nome = 'Excluir Depois';

SELECT * FROM CATEGORIAS WHERE nome = 'Excluir Depois';


-- PARTE D - INTEGRIDADE E ERROS CONTROLADOS
-- Execute uma tentativa por vez.
-- Os comandos problemáticos permanecem comentados.


-- 17. Tente inserir um produto com id_categoria = 9999.
-- Qual restrição impediu a operação?

-- INSERT INTO PRODUTO (nome, preco, ativo, id_categoria) VALUES
-- ('Produto Inexistente', 10.00, TRUE, 9999);

-- Resposta:
-- A restrição FOREIGN KEY impede o cadastro porque não existe
-- uma categoria com id 9999 na tabela CATEGORIAS.


-- 18. Tente cadastrar um cliente usando 'ana@email.com'.
-- Qual restrição impediu a operação?

-- Execute a consulta para verificar se o e-mail já existe.

SELECT *
FROM CLIENTE
WHERE email = 'ana@email.com';

-- Execute a tentativa abaixo somente se o e-mail já estiver cadastrado.
-- INSERT INTO CLIENTE (nome, email, telefone, cidade, ativo) VALUES
-- ('Ana Oliveira', 'ana@email.com', '19988889999', 'Limeira', TRUE);

-- Resposta:
-- A restrição UNIQUE impede a duplicação do e-mail,
-- caso ele já esteja cadastrado.
-- Se não existir, a inserção poderá ser realizada sem erro.


-- 19. Tente criar um pedido com id_cliente = 9999.
-- Qual restrição impediu a operação?

INSERT INTO PEDIDO (data_pedido, status_pedido, valor_total, id_cliente) VALUES
(NOW(), 'ABERTO', 0.00, 9999);

-- Resposta:
-- A restrição FOREIGN KEY impede o cadastro porque não existe
-- um cliente com id 9999 na tabela CLIENTE.


-- 20. Escreva em comentários a diferença entre os três erros anteriores.

-- Exercício 17:
-- Erro de FOREIGN KEY, pois o produto referencia uma categoria inexistente.
--
-- Exercício 18:
-- Erro de UNIQUE, caso o e-mail já esteja cadastrado.
-- Essa restrição impede valores duplicados em uma coluna única.
--
-- Exercício 19:
-- Erro de FOREIGN KEY, pois o pedido referencia um cliente inexistente.
--
-- Diferença:
-- UNIQUE impede duplicidade de valores.
-- FOREIGN KEY impede referências a registros inexistentes em outra tabela.


-- PARTE E - DESAFIO COMPLETO COM TRANSAÇÃO


-- 21. Inicie uma transação.

START TRANSACTION;


-- 22. Dentro dela, cadastre um cliente, um pedido e dois itens relacionados.

INSERT INTO CLIENTE (nome, email, telefone, cidade, ativo) VALUES
('Carlos Teste Rollback', 'carlos.rollback@email.com',
 '19912345678', 'Limeira', TRUE);

SET @id_cliente_rollback = LAST_INSERT_ID();

INSERT INTO PEDIDO (data_pedido, status_pedido, valor_total, id_cliente) VALUES
(NOW(), 'ABERTO', 0.00, @id_cliente_rollback);

SET @id_pedido_rollback = LAST_INSERT_ID();

INSERT INTO ITEM_PEDIDO
(id_pedido, id_produto, quantidade, preco_unitario, observacao) VALUES
(@id_pedido_rollback, 1, 2, 12.50, 'Teste de transação'),
(@id_pedido_rollback, 2, 1, 14.00, 'Segundo item de teste');

UPDATE PEDIDO
SET valor_total = (
    SELECT SUM(quantidade * preco_unitario)
    FROM ITEM_PEDIDO
    WHERE id_pedido = @id_pedido_rollback
)
WHERE id_pedido = @id_pedido_rollback;


-- 23. Faça uma consulta com JOIN comprovando que os registros existem
-- enquanto a transação está aberta.

SELECT
    c.nome AS cliente,
    c.email,
    p.id_pedido,
    p.status_pedido,
    p.valor_total,
    pr.nome AS produto,
    ip.quantidade,
    ip.preco_unitario
FROM CLIENTE c
INNER JOIN PEDIDO p
    ON c.id_cliente = p.id_cliente
INNER JOIN ITEM_PEDIDO ip
    ON p.id_pedido = ip.id_pedido
INNER JOIN PRODUTO pr
    ON ip.id_produto = pr.id_produto
WHERE c.email = 'carlos.rollback@email.com';

-- 24. Execute ROLLBACK e depois use SELECT para provar
-- que o cadastro foi desfeito.

ROLLBACK;

SELECT *
FROM CLIENTE
WHERE email = 'carlos.rollback@email.com';

SELECT *
FROM PEDIDO
WHERE id_pedido = @id_pedido_rollback;

SELECT *
FROM ITEM_PEDIDO
WHERE id_pedido = @id_pedido_rollback;

-- Resultado esperado:
-- As três consultas devem retornar zero registros.
-- O ROLLBACK desfez as inserções realizadas na transação.
-- Isso pressupõe que as tabelas utilizem um mecanismo transacional,
-- como o InnoDB.


-- 25. Repita o processo com novos dados e finalize usando COMMIT.
-- Depois consulte os registros persistidos.

START TRANSACTION;

INSERT INTO CLIENTE (nome, email, telefone, cidade, ativo)
VALUES (
    'Mariana Teste Commit',
    'mariana.commit@email.com',
    '19987654321',
    'Campinas',
    TRUE
);

SET @id_cliente_commit = LAST_INSERT_ID();

INSERT INTO PEDIDO (data_pedido, status_pedido, valor_total, id_cliente)
VALUES (
    NOW(),
    'ABERTO',
    0.00,
    @id_cliente_commit
);

SET @id_pedido_commit = LAST_INSERT_ID();

INSERT INTO ITEM_PEDIDO
(id_pedido, id_produto, quantidade, preco_unitario, observacao)
VALUES
(@id_pedido_commit, 1, 1, 12.50, 'Pedido confirmado'),
(@id_pedido_commit, 2, 2, 14.00, 'Duas unidades');

UPDATE PEDIDO
SET valor_total = (
    SELECT SUM(quantidade * preco_unitario)
    FROM ITEM_PEDIDO
    WHERE id_pedido = @id_pedido_commit
)
WHERE id_pedido = @id_pedido_commit;


-- Conferência dos registros antes do COMMIT.

SELECT
    c.nome AS cliente,
    c.email,
    p.id_pedido,
    p.status_pedido,
    p.valor_total,
    pr.nome AS produto,
    ip.quantidade,
    ip.preco_unitario
FROM CLIENTE c
INNER JOIN PEDIDO p
    ON c.id_cliente = p.id_cliente
INNER JOIN ITEM_PEDIDO ip
    ON p.id_pedido = ip.id_pedido
INNER JOIN PRODUTO pr
    ON ip.id_produto = pr.id_produto
WHERE c.email = 'mariana.commit@email.com';


-- Confirma definitivamente as alterações.

COMMIT;


-- Consulta os dados persistidos após o COMMIT.

SELECT *
FROM CLIENTE
WHERE email = 'mariana.commit@email.com';

SELECT *
FROM PEDIDO
WHERE id_cliente = @id_cliente_commit;

SELECT *
FROM ITEM_PEDIDO
WHERE id_pedido = @id_pedido_commit;


-- DESAFIO EXTRA


-- 26. Situação realista:
-- Um cliente realiza um pedido com dois produtos.
-- O sistema cadastra o cliente, cria o pedido, registra os itens
-- e atualiza o valor total conforme as quantidades e preços.
--
-- Regra de negócio:
-- O valor total do pedido deve ser igual à soma dos subtotais dos itens.
-- A transação permite confirmar os cadastros em conjunto.


START TRANSACTION;

INSERT INTO CLIENTE (nome, email, telefone, cidade, ativo)
VALUES (
    'Roberto Cliente Extra',
    'roberto.extra@email.com',
    '19955556666',
    'Limeira',
    TRUE
);

SET @id_cliente_extra = LAST_INSERT_ID();

INSERT INTO PEDIDO (data_pedido, status_pedido, valor_total, id_cliente)
VALUES (
    NOW(),
    'ABERTO',
    0.00,
    @id_cliente_extra
);

SET @id_pedido_extra = LAST_INSERT_ID();

INSERT INTO ITEM_PEDIDO
(id_pedido, id_produto, quantidade, preco_unitario, observacao)
VALUES
(@id_pedido_extra, 1, 1, 12.50, 'Pedido do cliente'),
(@id_pedido_extra, 3, 2, 11.00, 'Duas unidades');

UPDATE PEDIDO
SET valor_total = (
    SELECT SUM(quantidade * preco_unitario)
    FROM ITEM_PEDIDO
    WHERE id_pedido = @id_pedido_extra
)
WHERE id_pedido = @id_pedido_extra;


-- Consulta de conferência antes de confirmar a transação.

SELECT
    c.nome AS cliente,
    c.email,
    p.id_pedido,
    p.status_pedido,
    p.valor_total,
    pr.nome AS produto,
    ip.quantidade,
    ip.preco_unitario,
    ip.quantidade * ip.preco_unitario AS subtotal
FROM CLIENTE c
INNER JOIN PEDIDO p
    ON c.id_cliente = p.id_cliente
INNER JOIN ITEM_PEDIDO ip
    ON p.id_pedido = ip.id_pedido
INNER JOIN PRODUTO pr
    ON ip.id_produto = pr.id_produto
WHERE c.email = 'roberto.extra@email.com';


-- Confirma o cadastro do cliente, pedido e itens.

COMMIT;


-- Consulta final para comprovar que os dados foram persistidos.

SELECT
    c.nome AS cliente,
    c.email,
    p.id_pedido,
    p.status_pedido,
    p.valor_total
FROM CLIENTE c
INNER JOIN PEDIDO p
    ON c.id_cliente = p.id_cliente
WHERE c.email = 'roberto.extra@email.com';

SELECT *
FROM ITEM_PEDIDO
WHERE id_pedido = @id_pedido_extra;