SET telefone = '(11) 97777-1001'
WHERE id_cliente = 1;

SELECT id_cliente, nome, telefone
FROM CLIENTE
WHERE id_cliente = 1;

-- Exercicio 11 - Acrescentar 2 unidades aos jogos lançados a partir de 2000.
UPDATE JOGO
SET quantidade_disponivel = quantidade_disponivel + 2
WHERE ano_lancamento >= 2000;

-- Exercicio 12 - Criar e excluir um cliente que nao possui locacoes.
INSERT INTO CLIENTE (nome, email, telefone)
VALUES ('Cliente Temporario', 'temporario@retrogame.com', NULL);

DELETE FROM CLIENTE
WHERE email = 'temporario@retrogame.com';

-- Teste controlado: tenta excluir o cliente 1, que possui locacao.
-- O erro de chave estrangeira 1451 e capturado para que o arquivo continue.
DROP PROCEDURE IF EXISTS testar_exclusao_cliente_com_locacao;
DELIMITER $$
CREATE PROCEDURE testar_exclusao_cliente_com_locacao()
BEGIN
    DECLARE exclusao_bloqueada BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR 1451 SET exclusao_bloqueada = TRUE;

    DELETE FROM CLIENTE
    WHERE id_cliente = 1;

    IF exclusao_bloqueada THEN
        SELECT 'EXCLUSAO BLOQUEADA: o cliente possui historico de locacao.' AS resultado;
    ELSE
        SELECT 'O cliente foi excluido; confira se ele possuia locacoes.' AS resultado;
    END IF;
END$$
DELIMITER ;

CALL testar_exclusao_cliente_com_locacao();
DROP PROCEDURE IF EXISTS testar_exclusao_cliente_com_locacao;

-- Evidencia: o cliente 1 continua cadastrado porque possui locacao.
SELECT c.id_cliente, c.nome, l.id_locacao
FROM CLIENTE AS c
INNER JOIN LOCACAO AS l ON l.id_cliente = c.id_cliente
WHERE c.id_cliente = 1;

-- ================================================================
-- FASE 3 - DQL: CONSULTAS E ANALISE
-- ================================================================

-- Exercicio 13 - Titulo, ano e quantidade disponivel de todos os jogos.
SELECT titulo, ano_lancamento, quantidade_disponivel
FROM JOGO;

-- Exercicio 14 - Jogos com estoque maior que 2, do maior para o menor.
SELECT titulo, quantidade_disponivel
FROM JOGO
WHERE quantidade_disponivel > 2
ORDER BY quantidade_disponivel DESC;

-- Exercicio 15 - Jogos cujo titulo contem a palavra 'Mario'.
SELECT titulo
FROM JOGO
WHERE titulo LIKE '%Mario%';

-- Exercicio 16 - Jogos lancados entre 1990 e 2005.
SELECT titulo, ano_lancamento
FROM JOGO
WHERE ano_lancamento BETWEEN 1990 AND 2005;

-- Exercicio 17 - Funcoes agregadas sobre o estoque.
SELECT
    COUNT(*) AS total_de_jogos,
    SUM(quantidade_disponivel) AS estoque_total,
    ROUND(AVG(quantidade_disponivel), 2) AS media_do_estoque,
    MIN(quantidade_disponivel) AS menor_estoque,
    MAX(quantidade_disponivel) AS maior_estoque
FROM JOGO;

-- Exercicio 18 - INNER JOIN: locacao, cliente e jogo.
SELECT
    l.id_locacao,
    c.nome AS nome_cliente,
    j.titulo AS titulo_jogo,
    l.data_retirada,
    l.status_locacao
FROM LOCACAO AS l
INNER JOIN CLIENTE AS c ON c.id_cliente = l.id_cliente
INNER JOIN JOGO AS j ON j.id_jogo = l.id_jogo;

-- Exercicio 19 - Apenas locacoes ABERTAS.
SELECT
    l.id_locacao,
    c.nome AS nome_cliente,
    j.titulo AS titulo_jogo,
    l.status_locacao
FROM LOCACAO AS l
INNER JOIN CLIENTE AS c ON c.id_cliente = l.id_cliente
INNER JOIN JOGO AS j ON j.id_jogo = l.id_jogo
WHERE l.status_locacao = 'ABERTA';

-- Exercicio 20 - Quantidade de locacoes por cliente que ja locou.
SELECT
    c.id_cliente,
    c.nome,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM CLIENTE AS c
INNER JOIN LOCACAO AS l ON l.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY quantidade_locacoes DESC;

-- Exercicio 21 - Todos os clientes, inclusive os que nunca locaram.
SELECT
    c.id_cliente,
    c.nome,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM CLIENTE AS c
LEFT JOIN LOCACAO AS l ON l.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY quantidade_locacoes DESC, c.nome ASC;

-- ================================================================
-- FASE 4 - TCL: TRANSACOES E INTEGRIDADE
-- ================================================================

-- Exercicio 22 - Registrar locacao com baixa condicional de estoque.
-- ROW_COUNT() informa se o UPDATE encontrou uma unidade disponivel.
-- O INSERT ... SELECT so cadastra a locacao se a baixa ocorreu (valor 1).
START TRANSACTION;

UPDATE JOGO
SET quantidade_disponivel = quantidade_disponivel - 1
WHERE id_jogo = 6
  AND quantidade_disponivel > 0;

SET @estoque_baixado = ROW_COUNT();

INSERT INTO LOCACAO (data_prevista, id_cliente, id_jogo)
SELECT DATE_ADD(CURDATE(), INTERVAL 7 DAY), 4, 6
FROM DUAL
WHERE @estoque_baixado = 1;

SELECT @estoque_baixado AS baixa_de_estoque_realizada;

SELECT
    l.id_locacao,
    c.nome AS nome_cliente,
    j.titulo AS titulo_jogo,
    l.status_locacao,
    j.quantidade_disponivel AS estoque_atual
FROM LOCACAO AS l
INNER JOIN CLIENTE AS c ON c.id_cliente = l.id_cliente
INNER JOIN JOGO AS j ON j.id_jogo = l.id_jogo
WHERE l.id_cliente = 4
  AND l.id_jogo = 6
  AND l.status_locacao = 'ABERTA'
ORDER BY l.id_locacao DESC
LIMIT 1;

COMMIT;

-- Exercicio 23 - Demonstrar ROLLBACK e retorno ao estoque original.
SELECT id_jogo, titulo, quantidade_disponivel AS estoque_antes
FROM JOGO
WHERE id_jogo = 1;

START TRANSACTION;

UPDATE JOGO
SET quantidade_disponivel = quantidade_disponivel + 5
WHERE id_jogo = 1;

SELECT id_jogo, titulo, quantidade_disponivel AS estoque_durante_transacao
FROM JOGO
WHERE id_jogo = 1;

ROLLBACK;

SELECT id_jogo, titulo, quantidade_disponivel AS estoque_apos_rollback
FROM JOGO
WHERE id_jogo = 1;

-- Exercicio 24 - SAVEPOINT: manter a primeira alteracao e desfazer a segunda.
START TRANSACTION;

UPDATE JOGO
SET quantidade_disponivel = quantidade_disponivel + 1
WHERE id_jogo = 1;

SAVEPOINT apos_primeira_alteracao;