-- Active: 1794485071597@@127.0.0.1@3306@retrogame_recuperacao_felipe
-- 1
CREATE DATABASE IF NOT EXISTS retrogame_recuperacao_felipe;

USE retrogame_recuperacao_felipe;


-- 2
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(80) NOT NULL,
    email VARCHAR(80) NOT NULL,
    telefone varchar(20)
)

-- 3
CREATE  TABLE plataforma (
    id_plataforma INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(80) NOT NULL,
    CONSTRAINT uq_plataforma_nome UNIQUE (nome)
)

CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(80) NOT NULL
)

-- 4

CREATE TABLE JOGO (
    id_jogo INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    codigo VARCHAR(15) NOT NULL,
    ano_lancamento INT NOT NULL,
    quantidade_disponivel INT NOT NULL DEFAULT 0,
    id_plataforma INT NOT NULL,
    id_categoria INT NOT NULL,
    CONSTRAINT uq_jogo_codigo UNIQUE (codigo),
    CONSTRAINT chk_jogo_estoque CHECK (quantidade_disponivel >= 0),
    CONSTRAINT fk_jogo_plataforma
        FOREIGN KEY (id_plataforma)
        REFERENCES PLATAFORMA (id_plataforma)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_jogo_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES CATEGORIA (id_categoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) 

-- 5

CREATE TABLE LOCACAO (
    id_locacao INT AUTO_INCREMENT PRIMARY KEY,
    data_retirada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_prevista DATE NOT NULL,
    data_devolucao DATE NULL,
    status_locacao VARCHAR(20) NOT NULL DEFAULT 'ABERTA',
    id_cliente INT NOT NULL,
    id_jogo INT NOT NULL,
    CONSTRAINT chk_locacao_status
        CHECK (status_locacao IN ('ABERTA', 'DEVOLVIDA', 'ATRASADA')),
    CONSTRAINT fk_locacao_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE (id_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_locacao_jogo
        FOREIGN KEY (id_jogo)
        REFERENCES JOGO (id_jogo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) 

-- 6
ALTER TABLE jogo 
ADD COLUMN desenvolvedora VARCHAR(100) NULL;

-- 8

INSERT INTO cliente (id_cliente, nome, email, telefone) VALUES 
(1, 'Ana Silva', 'ana@exemplo.com', '(11) 98888-1001'),
(2, 'Bruno Costa', 'bruno@exemplo.com', '(11) 98888-1002'),
(3, 'Carla Souza', 'carla@exemplo.com', NULL),
(4, 'Diego Lima', 'diego@exemplo.com', '(11) 98888-1004');

INSERT INTO PLATAFORMA (id_plataforma, nome) VALUES
(1, 'Mega Drive'),loiro
(2, 'Nintendo swicth'),
(3, 'Playstation 5'),
(4, 'Xbox Series S');

INSERT INTO categoria (id_categoria, descricao) VALUES
(1, 'Aventura'),
(2, 'ação');

INSERT INTO jogo (id_jogo, titulo, codigo, ano_lancamento, quantidade_disponivel) VALUES
(1, 'Granf teft Auto VI', 'J001', '2026', '10'),
(2, 'God of War Ragnarok', 'J002', '2022', '8'),
(3, 'Minecraft', 'J003', '2011', '15'),
(4, 'Counter Strike 2', 'J004', '2023', '12'),
(5, 'Forza Horizon 6', 'J005', '2026', '6'),
(6, 'Resident Evil 4 ', 'J006', '2005', '9');

-- 9

START TRANSACTION;

UPDATE JOGO
SET quantidade_disponivel = quantidade_disponivel - 1
WHERE id_jogo = 1 AND quantidade_disponivel > 0;

UPDATE JOGO
SET quantidade_disponivel = quantidade_disponivel - 1
WHERE id_jogo = 2 AND quantidade_disponivel > 0;

UPDATE JOGO
SET quantidade_disponivel = quantidade_disponivel - 1
WHERE id_jogo = 5 AND quantidade_disponivel > 0;

INSERT INTO LOCACAO (id_locacao, data_prevista, status_locacao, id_cliente, id_jogo) VALUES
(1, DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'ABERTA', 1, 1),
(2, DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'ABERTA', 2, 2),
(3, DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'ABERTA', 3, 5);

COMMIT;

-- 10

SELECT id_cliente, nome, email, telefone
FROM CLIENTE
WHERE id_cliente = 1;

UPDATE CLIENTE
SET telefone = '(11) 97777-1001'
WHERE id_cliente = 1;

SELECT id_cliente, nome, telefone
FROM CLIENTE
WHERE id_cliente = 1;

-- 11 

UPDATE JOGO
SET quantidade_disponivel = quantidade_disponivel + 2
WHERE ano_lancamento >= 2000;

-- 12 

-- 13

SELECT titulo, ano_lancamento, quantidade_disponivel
FROM JOGO;

-- 14

SELECT titulo, quantidade_disponivel
FROM JOGO
WHERE quantidade_disponivel > 2
ORDER BY quantidade_disponivel DESC;

-- 15
SELECT titulo
FROM JOGO
WHERE titulo LIKE '%Mario%';

-- 16 
SELECT titulo, ano_lancamento
FROM JOGO
WHERE ano_lancamento BETWEEN 1990 AND 2005;

-- 17
SELECT
    COUNT(*) AS total_de_jogos,
    SUM(quantidade_disponivel) AS estoque_total,
    ROUND(AVG(quantidade_disponivel), 2) AS media_do_estoque,
    MIN(quantidade_disponivel) AS menor_estoque,
    MAX(quantidade_disponivel) AS maior_estoque
FROM JOGO;

-- 18
SELECT
    l.id_locacao,
    c.nome AS nome_cliente,
    j.titulo AS titulo_jogo,
    l.data_retirada,
    l.status_locacao
FROM LOCACAO AS l
INNER JOIN CLIENTE AS c ON c.id_cliente = l.id_cliente
INNER JOIN JOGO AS j ON j.id_jogo = l.id_jogo;

-- 19
SELECT
    l.id_locacao,
    c.nome AS nome_cliente,
    j.titulo AS titulo_jogo,
    l.status_locacao
FROM LOCACAO AS l
INNER JOIN CLIENTE AS c ON c.id_cliente = l.id_cliente
INNER JOIN JOGO AS j ON j.id_jogo = l.id_jogo
WHERE l.status_locacao = 'ABERTA';

-- 20

SELECT
    c.id_cliente,
    c.nome,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM CLIENTE AS c
INNER JOIN LOCACAO AS l ON l.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY quantidade_locacoes DESC;

-- 21

SELECT
    c.id_cliente,
    c.nome,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM CLIENTE AS c
LEFT JOIN LOCACAO AS l ON l.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY quantidade_locacoes DESC, c.nome ASC;

-- 22 

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

-- 23

SELECT id_jogo, titulo, quantidade_disponivel AS estoque_antes
FROM jogo
WHERE id_jogo = 1;

START TRANSACTION; 

UPDATE jogo 
SET quantidade_disponivel = quantidade_disponivel + 5 
WHERE id_jogo = 1

SELECT id_jogo, titulo, quantidade_disponivel AS estoque_durante_transacao
FROM JOGO
WHERE id_jogo = 1;

ROLLBACK;

SELECT id_jogo, titulo, quantidade_disponivel AS estoque_apos_rollback
FROM JOGO
WHERE id_jogo = 1;

-- 24 

START TRANSACTION;

UPDATE JOGO
SET quantidade_disponivel = quantidade_disponivel + 1
WHERE id_jogo = 1;

SAVEPOINT apos_primeira_alteracao;

-- 25

START TRANSACTION;

UPDATE LOCACAO
SET status_locacao = 'DEVOLVIDA',
    data_devolucao = CURDATE()
WHERE id_locacao = 1
  AND status_locacao = 'ABERTA';

SET @devolucao_registrada = ROW_COUNT();

UPDATE JOGO AS j
INNER JOIN LOCACAO AS l ON l.id_jogo = j.id_jogo
SET j.quantidade_disponivel = j.quantidade_disponivel + 1
WHERE l.id_locacao = 1
  AND @devolucao_registrada = 1;

SELECT
    l.id_locacao,
    l.status_locacao,
    l.data_devolucao,
    j.titulo,
    j.quantidade_disponivel AS estoque_apos_devolucao
FROM LOCACAO AS l
INNER JOIN JOGO AS j ON j.id_jogo = l.id_jogo
WHERE l.id_locacao = 1;

COMMIT;
