-- Active: 1788520782564@@127.0.0.1@3306@smartcoffee_dml_felipe
-- LINGUAGEM DE CONSULTA DE DADOS

-- EX01
-- SELECT SIMPLES
SELECT coluna
FROM tabela;

-- FROM tabela;
SELECT * FROM cliente;
-- CONSULTA TODAS AS COLUNAS NA ABELA


SELECT nome, telefone FROM cliente;

SELECT nome, ativo FROM produto;
-- CONSULTA APENAS AS COLUNAS NOME E TELEFONE NA TABELA

-- EX02


-- "AS" É USADO PARA RENOMEAR COLUNAS E TABELAS
SELECT nome AS nome_cliente, telefone AS contato_cliente FROM cliente;

SELECT nome, preco, preco * 2.00 AS preco_ajustado FROM produto;

-- EX03

SELECT DISTINCT cidade FROM cliente;
-- CONSULTA TODAS AS CIDADES SEM REPETIÇÃO

SELECT cidade FROM clientes;

-- COM DISTINCT CADA RESULTADO É APRESENTADO UMA UNICA VEZ
-- SEM DISTINCT CADA RESULTADO E APRESNTADO VARIAS VEZES, MESMO QUE SE REPITA

-- EX04

-- INSERIR CONIÇÕES E UTILIZAR OPERADORES DE COMPARAÇÃO

-- =IGUAL 
-- <> OU ! = DIFERENTE
-- >= MAIOR OU IGUAL
-- <= MENOR OU IGUAL
-- < MENOR QUE 

SELECT nome, preco FROM produto WHERE preco > 10;

-- CONSULTAR PRECOS QUE POSSUEM VALOR ACIMA DE 10 REAIS 

SELECT nome, preco, ativo FROM produto WHERE ativo = TRUE;

-- CONSULTAR PRODUTOS QUE ESTÃO ATIVOS

SELECT id_pedido, data_pedido, valor_total FROM pedido WHERE valor_total >= 25.00;
-- CONSULTAR VALOR TOTAL DE PRODUTOS ACIMA DE 25 REAIS   

-- EX05
-- AND - TODAS AS CONDIÇÕES VERDADEIRAS

SELECT nome, preco FROM produto
WHERE preco >= 10 AND preco <= 25.00;

-- OR - PELO MENOS UMA CONDIÇÃO VERDADEIRA

SELECT nome, preco FROM produto
WHERE cidade= 'Limeira' OR cidade = 'Boston';

-- NOT - INVERTE O RESULTADO DA CONDIÇÃO

SELECT nome, cidade FROM cliente
WHERE NOT cidade = 'itapira';

-- AND E OR JUNTOS PRECISAMOS INSERIR PARENTESES PARA DEFINIR A ORDEM DE EXECUÇÃO

SELECT nome, cidade, ativo FROM cliente
WHERE ativo = TRUE AND (cidade = 'Limeira' OR cidade = 'itapira');

-- EX06
-- LIMITE INICIAL E FINAL 

SELECT nome, preco FROM produto WHERE preco BETWEEN 10 AND 15;

-- CONSULTAR POR INERVALO DE VALORES
SELECT id_pedido, data_pedido, valor, valor_total FROM pedido WHERE valor_total BETWEEN 20 AND 30;

-- BETWEEN - É INCLUSIVO, OU SEJA, ELE INCLUI OS VALORES INICIAL E FINAL DO INTERVALO

SELECT id_pedido, data_pedido, valor_total FROM pedido WHERE valor_total NOT BETWEEN '2026-01-01 00:00:00' AND '2026-12-31 23:59:59';
-- CONSULTAR PEDIDOS QUE NÃO ESTÃO ENTRE O INTERVALO DE DATAS INFORMADO

-- EX 7: IN - MUITAS POSSIBILIDADES
SELECT nome, cidade FROM cliente
WHERE cidade IN ('Limeira','Piracicaba','Americana');

SELECT nome, cidade FROM cliente
WHERE cidade NOT IN ('Limeira','Piracicaba');


-- EX 8: LIKE - PESQUISA POR TEXTOS
-- CORINGAS
-- % VÁRIAS CARACTERES
-- _APENAS
SELECT nome FROM produto
WHERE nome LIKE 'Café%';
-- CONSULTA PELA PALAVRA QUE DESEJA E QUAL COMEÇA

SELECT nome FROM produto
WHERE nome LIKE '%Chocolate%';

-- CONSULTA PELA PALAVRA QUE CONTEM CHOCOLATE

SELECT nome FROM cliente
WHERE nome LIKE '%Silva';

SELECT nome FROM produto
WHERE nome LIKE '%o_co%';

-- EX 9: NULL - AUSÊNCIA DE VALOR
SELECT nome, telefone FROM cliente
WHERE telefone IS NULL;

SELECT nome, telefone FROM cliente
WHERE telefone IS NOT NULL;

SELECT nome, telefone FROM cliente
WHERE telefone = 'NULL';

-- EX 10: ORDER BY - ORDENAR RESULTADOS
-- ASC É CRESCENTE
-- DESC É DECRESCENTE

SELECT nome, preco FROM produto
ORDER BY preco ASC;

SELECT nome, preco FROM produto
ORDER BY preco DESC;

SELECT nome, preco FROM produto
ORDER BY nome ASC , preco DESC;

SELECT cidade, nome FROM cliente
ORDER BY cidade ASC, nome DESC;
-- ORDENAR POR MAIS DE UMA COLUNA

-- EX 11: LIMIT DETERMINAR UMA QUANTIDADE DE LINHAS
SELECT nome, preco
FROM produto
ORDER BY preco DESC
LIMIT 10;

SELECT nome, preco
FROM produto
ORDER BY nome
LIMIT 10 OFFSET 5;

-- EX 12: CÁLCULOS EM COLUNAS
SELECT nome, preco, preco * 1.30 AS Preco_Reajuste
FROM produto;

SELECT id_item, quantidade, preco_unitario, quantidade * preco_unitario AS Subtotal FROM item_pedido;

-- EX 13: FUNÇÕES
-- TEXTOS
SELECT UPPER(nome) AS NOME_M , LOWER(cidade) AS cidade_m
FROM cliente;

-- USO DE MAIÚSCULO E MINÚSCULO
SELECT CONCAT(nome, ' -- ', cidade) AS Cliente_Cidades
FROM cliente;

-- NÚMEROS
SELECT nome, preco, ROUND(preco * 0.90, 2) AS Preco_Desconto
FROM produto;

-- DATAS
SELECT id_pedido, data_pedido, valor_total, DATE(data_pedido) AS DATAS, MONTH(data_pedido) AS MÊS, YEAR(data_pedido) AS ANO, DAY(data_pedido) AS DIAS, TIME(data_pedido) AS Horário
FROM pedido;

-- SUBSTITUIR O NULL NO RESULTADO COM COALESCE
SELECT nome, COALESCE(telefone, 'Não Possui Telefone') AS Telefone
FROM cliente;

-- EX 14: FUNÇÕES DE AGREGAÇÃO
-- COUNT = CONTAR UM QUANTIDADE
-- SUM = SOMAR VALORES
-- AVG = CALCULAR MÉDIA
-- MIN = MÍNIMO VALOR
-- MAX = MÁXIMO VALOR
SELECT COUNT(*) AS TOTAL_CLIENTE
FROM cliente;
-- QUANTOS CLIENTES EXISTEM NA TABELA

SELECT AVG(preco) AS Preco_Médio_Produtos
FROM produto;
-- PRECO MEDIO DOS PRODUTOS

SELECT ROUND(MIN(preco),2) AS preços_baixos,
       ROUND(MAX(preco),2) AS preços_altos,
       ROUND(AVG(preco),2) AS Média_preços
FROM pedido
WHERE status = 'PREPARANDO';
-- TOTAL DE PEDIDOS COM CRITERIOS

EX15: GROUP BY - AGRUPAR RESULTADOS
SELECT cidade, COUNT(*) AS total_clientes
FROM cliente
GROUP BY cidade;

-- QUANTOS CLIENTES TENHO EM CADA CIDADE

SELECT id_categoria, COUNT(*) AS qtde_produtos FROM produto
GROUP BY id_categoria;











      