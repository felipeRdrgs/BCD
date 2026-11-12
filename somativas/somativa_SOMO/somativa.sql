-- Active: 1788520782564@@127.0.0.1@3306@biblioteca_felipe_som2

-- 1
CREATE DATABASE IF NOT EXISTS biblioteca_felipe_som2;

USE biblioteca_felipe_som2;

-- 2
CREATE TABLE USUARIO (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    ativo BOOLEAN DEFAULT TRUE
);

-- 3
CREATE TABLE LIVRO (
    id_livro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    autor VARCHAR(120) NOT NULL,
    isbn CHAR(13) NOT NULL UNIQUE,
    ano_publicacao INT,
    quantidade_disponivel INT DEFAULT 0,
    CHECK (quantidade_disponivel >= 0)
);

-- 4
CREATE TABLE EMPRESTIMO (
    id_emprestimo INT AUTO_INCREMENT PRIMARY KEY,
    data_emprestimo DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_prevista DATE NOT NULL,
    data_devolucao DATE,
    status_emprestimo VARCHAR(20) DEFAULT 'ABERTO',
    id_usuario INT NOT NULL,
    id_livro INT NOT NULL,

    FOREIGN KEY (id_usuario)
        REFERENCES USUARIO(id_usuario)
        ON DELETE RESTRICT,

    FOREIGN KEY (id_livro)
        REFERENCES LIVRO(id_livro)
        ON DELETE RESTRICT,

    CHECK (status_emprestimo IN ('ABERTO', 'DEVOLVIDO', 'ATRASADO'))
);


-- 5
ALTER TABLE LIVRO
ADD editora VARCHAR(100);

-- 6
INSERT INTO USUARIO (nome, email, telefone, ativo) VALUES
('Felipe Rodrigues', 'felipe@email.com', '1996486720', TRUE),
('Davi Ferreira', 'davi@email.com', NULL, TRUE),
('Francisco Magri', 'chico@email.com', '1995674547', TRUE),
('Bruno Moraes', 'bruno@email.com', '1993680453', TRUE);

-- 7
INSERT INTO LIVRO (titulo, autor, isbn, quantidade_disponivel, ano_publicacao) VALUES
('Dom Quixote', 'Miguel de Cervantes', '9788520923092', 10, 2021),
('A Divina Comédia', 'Dante Alighieri', '9786559102303', 4, 2022),
('Orgulho e Preconceito', 'Jane Austen', '8544001823000', 11, 2018),
('Crime e Castigo', 'Fiódor Dostoiévski', '9788573266467', 3, 2019),
('Cem Anos de Solidão', 'Gabriel García Márquez', '9788501012074', 15, 2020),
('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', '9788595081512', 1, 2023);

-- 8
INSERT INTO EMPRESTIMO
(data_prevista, id_usuario, id_livro)
VALUES
('2026-11-05', 1, 1),
('2026-11-07', 2, 2),
('2026-11-10', 3, 3);

-
SELECT * FROM USUARIO
WHERE id_usuario = 1;

-- 9
UPDATE USUARIO
SET telefone = '19991234567'
WHERE id_usuario = 1;

-- 10
UPDATE LIVRO
SET quantidade_disponivel = 2,
WHERE ano_publicacao => 2020;

SELECT * FROM USUARIO;

SELECT * FROM LIVRO;

SELECT * FROM EMPRESTIMO;

-- 11

-- DELETE DO USUARIO SEM EMPRESTIMO
INSERT INTO USUARIO (nome, email, telefone, ativo) VALUES
('bruna', 'bruna@email.com', '19900000000', TRUE);

SELECT * FROM USUARIO;

DELETE FROM USUARIO WHERE nome = 'bruna';

SELECT * FROM USUARIO;

-- DELETE DO USUARIO COM EMPRESTIMO

DELETE FROM USUARIO WHERE nome = 'Francisco Magri';

SELECT * FROM USUARIO;

-- o usuário que possui empréstimos não pode ser excluído, porque a chave estrangeira com a regra delete impede a exclusão. Isso garante a integridade

-- 12

SELECT titulo, autor, quantidade_disponivel
FROM LIVRO 

-- 13 

SELECT titulo, quantidade_disponivel
FROM LIVRO
WHERE quantidade_disponivel > 2
ORDER BY quantidade_disponivel DESC;

-- 14

SELECT titulo
FROM LIVRO
WHERE titulo LIKE '%comédia%';

-- 15

SELECT titulo, ano_publicacao
FROM LIVRO 
WHERE ano_publicacao BETWEEN '2015' AND  '2025'

-- 16

SELECT
    COUNT(*) AS total_livros,
    SUM(quantidade_disponivel) AS soma_estoque,
    AVG(quantidade_disponivel) AS media_estoque,
    MIN(quantidade_disponivel) AS menor_estoque,
    MAX(quantidade_disponivel) AS maior_estoque
FROM LIVRO;

-- 17
SELECT
    EMPRESTIMO.id_emprestimo,
    USUARIO.nome,
    LIVRO.titulo,
    EMPRESTIMO.data_emprestimo,
    EMPRESTIMO.status_emprestimo
FROM EMPRESTIMO
INNER JOIN USUARIO
    ON EMPRESTIMO.id_usuario = USUARIO.id_usuario
INNER JOIN LIVRO
    ON EMPRESTIMO.id_livro = LIVRO.id_livro;

-- 18


-- 19 
SELECT
    USUARIO.nome,
    COUNT(EMPRESTIMO.id_emprestimo) AS total_emprestimos
FROM USUARIO
INNER JOIN EMPRESTIMO
    ON USUARIO.id_usuario = EMPRESTIMO.id_usuario
GROUP BY USUARIO.id_usuario, USUARIO.nome
ORDER BY total_emprestimos DESC;

-- 20

SELECT
    USUARIO.nome,
    COUNT(EMPRESTIMO.id_emprestimo) AS total_emprestimos
FROM USUARIO
LEFT JOIN EMPRESTIMO
    ON USUARIO.id_usuario = EMPRESTIMO.id_usuario
GROUP BY USUARIO.id_usuario, USUARIO.nome
ORDER BY total_emprestimos DESC;

-- 21

-- 22. ROLLBACK

START TRANSACTION;

UPDATE LIVRO
SET quantidade_disponivel = quantidade_disponivel + 5
WHERE id_livro = 1;

SELECT * FROM LIVRO
WHERE id_livro = 1;

ROLLBACK;

SELECT * FROM LIVRO
WHERE id_livro = 1;

-- 22
START TRANSACTION;

UPDATE LIVRO
SET quantidade_disponivel = quantidade_disponivel + 5
WHERE id_livro = 1;

SELECT * FROM LIVRO
WHERE id_livro = 1;

ROLLBACK;

SELECT * FROM LIVRO
WHERE id_livro = 1;

-- 23

START TRANSACTION;

UPDATE LIVRO
SET quantidade_disponivel = quantidade_disponivel + 3
WHERE id_livro = 1;

SAVEPOINT primeira_alteracao;

UPDATE LIVRO
SET quantidade_disponivel = quantidade_disponivel + 5
WHERE id_livro = 2;

ROLLBACK TO SAVEPOINT primeira_alteracao;

SELECT * FROM LIVRO
WHERE id_livro IN (1, 2);

COMMIT;

-- 24

START TRANSACTION;

SELECT * FROM EMPRESTIMO
WHERE id_emprestimo = 1
AND status_emprestimo = 'ABERTO';

UPDATE EMPRESTIMO
SET status_emprestimo = 'DEVOLVIDO',
    data_devolucao = CURRENT_DATE
WHERE id_emprestimo = 1
AND status_emprestimo = 'ABERTO';

UPDATE LIVRO
SET quantidade_disponivel = quantidade_disponivel + 1
WHERE id_livro = 1;

SELECT * FROM EMPRESTIMO
WHERE id_emprestimo = 1;

SELECT * FROM LIVRO
WHERE id_livro = 1;

COMMIT;

