
USE smartcoffee_functions_triggers;

-- ATIVIDADE AMPLIADA - AULAS 14 E 15
-- Aluno: Felipe Rodrigues
-- Turma: 2DEVIS


-- ==========================================
-- 1. FUNCTION calcular_total_item
-- ==========================================

DROP FUNCTION IF EXISTS calcular_total_item;

DELIMITER $$

CREATE FUNCTION calcular_total_item
(p_preco DECIMAL(10,2), p_quantidade INT)

RETURNS DECIMAL(10,2)
DETERMINISTIC

BEGIN
    RETURN p_preco * p_quantidade;
END $$

DELIMITER ;


-- ==========================================
-- 2. FUNCTION classificar_fidelidade
-- ==========================================

DROP FUNCTION IF EXISTS classificar_fidelidade;

DELIMITER $$

CREATE FUNCTION classificar_fidelidade
(p_pontos INT)

RETURNS VARCHAR(20)
DETERMINISTIC

BEGIN
    IF p_pontos >= 500 THEN
        RETURN 'OURO';

    ELSEIF p_pontos >= 200 THEN
        RETURN 'PRATA';

    ELSE
        RETURN 'BRONZE';

    END IF;
END $$

DELIMITER ;


-- ==========================================
-- 3. FUNCTION calcular_desconto
-- ==========================================

DROP FUNCTION IF EXISTS calcular_desconto;

DELIMITER $$

CREATE FUNCTION calcular_desconto
(p_preco DECIMAL(10,2), p_desconto DECIMAL(5,2))

RETURNS DECIMAL(10,2)
DETERMINISTIC

BEGIN
    RETURN p_preco - (p_preco * p_desconto / 100);
END $$

DELIMITER ;


-- ==========================================
-- 4. FUNCTION situacao_estoque
-- ==========================================

DROP FUNCTION IF EXISTS situacao_estoque;

DELIMITER $$

CREATE FUNCTION situacao_estoque
(p_quantidade INT)

RETURNS VARCHAR(20)
DETERMINISTIC

BEGIN
    IF p_quantidade = 0 THEN
        RETURN 'ESGOTADO';

    ELSEIF p_quantidade <= 5 THEN
        RETURN 'ESTOQUE BAIXO';

    ELSE
        RETURN 'DISPONIVEL';

    END IF;
END $$

DELIMITER ;


-- ==========================================
-- 5. TESTAR TODAS EM SELECT
-- ==========================================

SELECT calcular_total_item(10, 3) AS total_item;

SELECT classificar_fidelidade(600) AS nivel_fidelidade;

SELECT calcular_desconto(100, 10) AS preco_com_desconto;

SELECT situacao_estoque(3) AS situacao_estoque;


-- ==========================================
-- 6. CRIAR auditoria_preco
-- ==========================================

CREATE TABLE IF NOT EXISTS auditoria_preco (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT,
    preco_anterior DECIMAL(10,2),
    preco_novo DECIMAL(10,2),
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- ==========================================
-- 7. TRIGGER AFTER UPDATE DE PREÇO
-- ==========================================

DROP TRIGGER IF EXISTS trg_auditoria_preco;

DELIMITER $$

CREATE TRIGGER trg_auditoria_preco
AFTER UPDATE ON produto
FOR EACH ROW

BEGIN
    IF OLD.preco <> NEW.preco THEN

        INSERT INTO auditoria_preco
        (id_produto, preco_anterior, preco_novo)

        VALUES
        (OLD.id_produto, OLD.preco, NEW.preco);

    END IF;
END $$

DELIMITER ;


-- ==========================================
-- 8. TRIGGER BEFORE UPDATE
--    IMPEDINDO ESTOQUE NEGATIVO
-- ==========================================

DROP TRIGGER IF EXISTS trg_estoque_before_update;

DELIMITER $$

CREATE TRIGGER trg_estoque_before_update
BEFORE UPDATE ON estoque
FOR EACH ROW

BEGIN
    IF NEW.quantidade < 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ESTOQUE NAO PODE FICAR NEGATIVO';

    END IF;
END $$

DELIMITER ;


-- ==========================================
-- 9. CRIAR log_exclusao_produto
-- ==========================================

CREATE TABLE IF NOT EXISTS log_exclusao_produto (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT,
    nome_produto VARCHAR(120),
    excluido_em DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- ==========================================
-- 10. TRIGGER AFTER DELETE
-- ==========================================

DROP TRIGGER IF EXISTS trg_log_exclusao_produto;

DELIMITER $$

CREATE TRIGGER trg_log_exclusao_produto
AFTER DELETE ON produto
FOR EACH ROW

BEGIN
    INSERT INTO log_exclusao_produto
    (id_produto, nome_produto)

    VALUES
    (OLD.id_produto, OLD.nome);

END $$

DELIMITER ;


-- ==========================================
-- 11. DEMONSTRAR OPERACAO BLOQUEADA
-- ==========================================

-- Esta operacao deve ser bloqueada
-- porque a quantidade nao pode ser negativa.

UPDATE estoque
SET quantidade = -5
WHERE id_produto = 1;


-- ==========================================
-- 12. DEMONSTRAR HISTORICO AUTOMATICO
-- ==========================================

-- Alterar o preco de um produto

UPDATE produto
SET preco = 15.50
WHERE id_produto = 1;


-- Consultar historico de preco

SELECT *
FROM auditoria_preco
ORDER BY id_auditoria DESC;


-- Excluir um produto de teste

DELETE FROM produto
WHERE id_produto = 1;


-- Consultar historico de exclusao

SELECT *
FROM log_exclusao_produto
ORDER BY id_log DESC;


-- ==========================================
-- 13. SHOW TRIGGERS
-- ==========================================

SHOW TRIGGERS;


-- ==========================================
-- 14. SHOW CREATE TRIGGER
-- ==========================================

SHOW CREATE TRIGGER trg_auditoria_preco;


-- ==========================================
-- 15. FUNCTION X PROCEDURE X VIEW X TRIGGER
-- ==========================================

-- FUNCTION:
-- Executa um calculo ou classificacao
-- e retorna um valor usando RETURN.

-- PROCEDURE:
-- Executa um processo com varias etapas.
-- E chamada usando CALL.

-- VIEW:
-- E uma consulta salva que pode ser reutilizada
-- usando SELECT.

-- TRIGGER:
-- E executado automaticamente quando ocorre
-- um INSERT, UPDATE ou DELETE.


-- ==========================================
-- 16. 3 REGRAS EM QUE CHECK, UNIQUE E FK
-- SERIAM MELHORES QUE TRIGGER
-- ==========================================

-- CHECK:
-- Impedir que o preco seja menor ou igual a zero.

-- UNIQUE:
-- Impedir que dois clientes tenham
-- o mesmo CPF.

-- FOREIGN KEY:
-- Impedir que um pedido tenha um cliente
-- que nao existe na tabela cliente.


-- ==========================================
-- DESAFIO: AUTOMACAO PROPRIA
-- ==========================================

-- Criar uma automacao para registrar
-- quando um produto ficar com estoque baixo.

CREATE TABLE IF NOT EXISTS log_estoque_baixo (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT,
    quantidade INT,
    data_log DATETIME DEFAULT CURRENT_TIMESTAMP
);


DROP TRIGGER IF EXISTS trg_estoque_baixo;

DELIMITER $$

CREATE TRIGGER trg_estoque_baixo
AFTER UPDATE ON estoque
FOR EACH ROW

BEGIN
    IF NEW.quantidade <= 5 AND OLD.quantidade > 5 THEN

        INSERT INTO log_estoque_baixo
        (id_produto, quantidade)

        VALUES
        (NEW.id_produto, NEW.quantidade);

    END IF;
END $$

DELIMITER ;


-- Consultar o registro de estoque baixo

SELECT *
FROM log_estoque_baixo;


-- JUSTIFICATIVA:
-- Escolhi o TRIGGER porque ele registra
-- automaticamente quando o estoque fica baixo,
-- sem precisar executar um INSERT manual.
