-- ============================================================
-- AULA 09 - ATIVIDADE PRÁTICA DE DQL
-- Nome: FELIPE RODRIGUES
-- Turma: 2DEVIS Data: 09/10/2026
-- Base: smartcoffee_dql
-- ============================================================
USE SMARTCOFFE_DML_FELIPE;
-- PARTE A - AQUECIMENTO

-- 1. Liste todos os clientes cadastrados.
SELECT * FROM CLIENTE;

-- 2. Exiba apenas nome, cidade e e-mail dos clientes.
SELECT nome, cidade, email
FROM CLIENTE;

-- 3. Liste os nomes das cidades sem repetir valores.
SELECT DISTINCT cidade
FROM CLIENTE;

-- 4. Liste todos os produtos em ordem crescente de preço.
SELECT *
FROM PRODUTO
ORDER BY preco ASC;

-- 5. Mostre apenas os 5 produtos mais caros.
SELECT *
FROM PRODUTO
ORDER BY preco DESC
LIMIT 5;


-- PARTE B - FILTROS

-- 6. Liste os produtos com preço entre R$ 8,00 e R$ 15,00.
SELECT *
FROM PRODUTO
WHERE preco BETWEEN 8 AND 15;

-- 7. Liste os clientes das cidades Limeira ou Americana.
SELECT *
FROM CLIENTE
WHERE cidade IN ('Limeira', 'Americana');

-- 8. Localize os produtos cujo nome contém a palavra "Café".
SELECT *
FROM PRODUTO
WHERE nome LIKE '%Café%';

-- 9. Liste os clientes que não informaram telefone.
SELECT *
FROM CLIENTE
WHERE telefone IS NULL OR telefone = '';

-- 10. Mostre os pedidos FINALIZADOS com valor acima de R$ 20,00,
-- do maior para o menor valor.
SELECT *
FROM PEDIDO
WHERE status_pedido = 'FINALIZADO'
  AND valor_total > 20
ORDER BY valor_total DESC;  


-- PARTE C - CÁLCULOS E AGRUPAMENTOS

-- 11. Informe quantos produtos estão cadastrados.
SELECT COUNT(*) AS qtd_produtos
FROM PRODUTO;

-- 12. Mostre menor preço, maior preço e preço médio dos produtos.
SELECT
    MIN(preco) AS menor_preco,
    MAX(preco) AS maior_preco,
    AVG(preco) AS preco_medio
FROM PRODUTO;

-- 13. Informe quantos clientes existem em cada cidade.
SELECT cidade, COUNT(*) AS qtd_clientes
FROM CLIENTE
GROUP BY cidade;

-- 14. Mostre somente as cidades que possuem dois ou mais clientes.
SELECT cidade, COUNT(*) AS qtd_clientes
FROM clientes
GROUP BY cidade
HAVING COUNT(*) >= 2;

-- 15. Calcule o faturamento total considerando apenas pedidos FINALIZADOS.
SELECT SUM(valor_total) AS faturamento_total
FROM PEDIDO
WHERE status_pedido = 'FINALIZADO';


-- PARTE D - RELACIONAMENTOS

-- 16. Liste cada pedido com id, data, nome do cliente, status e valor total.
SELECT
    p.id AS id_pedido,
    p.data_pedido,
    c.nome AS nome_cliente,
    p.status_pedido,
    p.valor_total
FROM PEDIDO p
INNER JOIN CLIENTE c ON p.id_cliente = c.id;

-- 17. Liste cada produto acompanhado do nome de sua categoria.
SELECT
    pr.nome AS PRODUTO,
    ca.nome AS CATEGORIA
FROM PRODUTO pr
INNER JOIN CATEGORIA ca ON pr.categoria_id = ca.id;

-- 18. Gere um relatório dos itens vendidos.
SELECT
    ip.pedido_id,
    pr.nome AS PRODUTO,
    ip.quantidade,
    ip.preco_unitario,
    ip.quantidade * ip.preco_unitario AS subtotal
FROM ITEM_PEDIDO ip
INNER JOIN PRODUTO pr ON ip.produto_id = pr.id;

-- 19. Mostre todos os clientes, inclusive aqueles que nunca fizeram pedidos.
SELECT
    c.*,
    p.id AS id_pedido,
    p.data_pedido,
    p.status_pedido,
    p.valor_total
FROM CLIENTE c
LEFT JOIN PEDIDO p ON c.id = p.cliente_id;

-- 20. Liste apenas os clientes que nunca fizeram pedidos.
SELECT c.*
FROM CLIENTE c
LEFT JOIN PEDIDO p ON c.id = p.cliente_id
WHERE p.id IS NULL;


-- PARTE E - DESAFIO GERENCIAL

-- 21. Quantidade de pedidos FINALIZADOS e total gasto por cliente.
SELECT
    c.id,
    c.nome,
    COUNT(p.id) AS quantidade_pedidos,
    COALESCE(SUM(p.valor_total), 0) AS total_gasto
FROM CLIENTE c
LEFT JOIN pedidos p
    ON c.id = p.cliente_id
    AND p.status = 'FINALIZADO'
GROUP BY c.id, c.nome
ORDER BY total_gasto DESC;

-- 22. Quantidade de produtos e preço médio de cada categoria.
SELECT
    ca.nome AS CATEGORIA,
    COUNT(pr.id) AS quantidade_produtos,
    AVG(pr.preco) AS preco_medio
FROM CATEGORIA ca
LEFT JOIN PRODUTO pr ON ca.id = pr.categoria_id
GROUP BY ca.id, ca.nome;

-- 23. Produtos com preço superior ao preço médio geral.
SELECT *
FROM PRODUTO
WHERE preco > (
    SELECT AVG(preco)
    FROM PRODUTO
);

-- 24. Classificação dos produtos por faixa de preço.
-- Econômico: até R$ 10,00.
-- Intermediário: acima de R$ 10,00 até R$ 25,00.
-- Premium: acima de R$ 25,00.
SELECT
    nome,
    preco,
    CASE
        WHEN preco <= 10 THEN 'Econômico'
        WHEN preco <= 25 THEN 'Intermediário'
        ELSE 'Premium'
    END AS classificacao
FROM PRODUTO
ORDER BY preco ASC;

-- 25. CONSULTA AUTORAL
-- Pergunta de negócio: Quais são os 5 produtos mais vendidos?
-- Por que essa informação é útil?
-- Ajuda a identificar os produtos mais populares,
-- planejar o estoque e orientar decisões de compra.

SELECT
    pr.id,
    pr.nome AS PRODUTO,
    SUM(ip.quantidade) AS quantidade_vendida
FROM PRODUTO pr
INNER JOIN itens_pedido ip ON pr.id = ip.produto_id
INNER JOIN PEDIDO p ON ip.pedido_id = p.id
WHERE p.status = 'FINALIZADO'
GROUP BY pr.id, pr.nome
ORDER BY quantidade_vendida DESC
LIMIT 5;

