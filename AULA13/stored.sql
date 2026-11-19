
-- Active: 1794485071597@@127.0.0.1@3306@smartcoffe_dml_felipe
USE smartcoffe_dml_felipe;

-- AULA 13 - ATIVIDADE STORED PROCEDURES
-- Aluno: Felipe Rodrigues
-- Turma: 2DEVIS 

-- 1. 
DELIMITER $$

CREATE PROCEDURE LISTAR_CLIENTES()
BEGIN
    SELECT ID_CLIENTE AS CODIGO, NOME, EMAIL, TELEFONE
    FROM CLIENTE
    ORDER BY NOME;
END $$

DELIMITER ;

CALL LISTAR_CLIENTES();

-- 2. 
DELIMITER $$

CREATE PROCEDURE buscar_produto_por_nome(IN p_busca VARCHAR(100))
BEGIN
    SELECT ID_PRODUTO AS CODIGO, NOME, PRECO
    FROM PRODUTO
    WHERE NOME LIKE CONCAT('%', p_busca, '%')
    AND ATIVO = TRUE
    ORDER BY NOME;
END $$

DELIMITER ;

CALL buscar_produto_por_nome('Cappuccino');

-- 3. 
DELIMITER $$

CREATE PROCEDURE buscar_produto_categoria(IN p_id_categoria INT)
BEGIN
    SELECT ID_PRODUTO AS CODIGO, NOME, PRECO
    FROM PRODUTO
    WHERE ID_CATEGORIA = p_id_categoria
    AND ATIVO = TRUE
    ORDER BY NOME;
END $$

DELIMITER ;

CALL buscar_produto_categoria(1);

-- 4. 
DELIMITER $$

CREATE PROCEDURE total_clientes(OUT p_total INT)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM CLIENTE;
END $$

DELIMITER ;

CALL total_clientes(@total);
SELECT @total;

-- 5. 
DELIMITER $$

CREATE PROCEDURE consultar_estoque(IN p_id_produto INT)
BEGIN
    DECLARE v_quantidade INT;

    SELECT quantidade INTO v_quantidade
    FROM estoque
    WHERE id_produto = p_id_produto;

    IF v_quantidade IS NULL THEN
        SELECT 'Produto não encontrado no estoque.' AS mensagem;
    ELSE
        SELECT v_quantidade AS quantidade_disponivel;
    END IF;
END $$

DELIMITER ;

CALL consultar_estoque(1);

-- 6. 
DELIMITER $$

CREATE PROCEDURE classificar_estoque(IN p_id_estoque INT)
BEGIN
    DECLARE v_quantidade INT;

    SELECT quantidade INTO v_quantidade
    FROM estoque
    WHERE id_estoque = p_id_estoque;

    IF v_quantidade = 0 THEN
        SELECT 'SEM ESTOQUE' AS MENSAGEM;
    ELSEIF v_quantidade <= 5 THEN
        SELECT 'BAIXO' AS MENSAGEM;
    ELSE
        SELECT 'NORMAL' AS MENSAGEM;
    END IF;
END $$

DELIMITER ;

CALL classificar_estoque(1);

-- 7.
DELIMITER $$

CREATE PROCEDURE cadastrar_cliente(
    IN p_nome VARCHAR(100),
    IN p_email VARCHAR(120),
    IN p_telefone VARCHAR(20)
)
BEGIN
    INSERT INTO cliente (nome, email, telefone)
    VALUES (p_nome, p_email, p_telefone);

    SELECT 'Cliente cadastrado com sucesso!' AS mensagem;
END $$

DELIMITER ;

CALL cadastrar_cliente('Felipe Rodrigues', 'felipe@email.com', '19999999999');

-- 8. 
DELIMITER $$

CREATE PROCEDURE alterar_preco(
    IN p_id_produto INT,
    IN p_novo_preco DECIMAL(10,2)
)
BEGIN
    IF p_novo_preco <= 0 THEN
        SELECT 'Erro: O preço deve ser maior que zero.' AS mensagem;
    ELSE
        UPDATE produto
        SET preco = p_novo_preco
        WHERE id_produto = p_id_produto;

        SELECT 'Preço atualizado com sucesso!' AS mensagem;
    END IF;
END $$

DELIMITER ;

CALL alterar_preco(1, 12.50);

-- 9 & 10. 
DELIMITER $$

CREATE PROCEDURE criar_pedido(
    IN p_id_cliente INT,
    OUT p_id_pedido INT
)
BEGIN
    INSERT INTO pedido (id_cliente, data_pedido, status_pedido)
    VALUES (p_id_cliente, NOW(), 'ABERTO');

    SET p_id_pedido = LAST_INSERT_ID();
END $$

DELIMITER ;

CALL criar_pedido(1, @novo_pedido);
SELECT @novo_pedido AS id_pedido_gerado;

-- 11. 

DELIMITER $$

CREATE PROCEDURE adicionar_item_pedido(
    IN p_id_pedido INT,
    IN p_id_produto INT,
    IN p_quantidade INT
)
BEGIN
    DECLARE v_preco_atual DECIMAL(10,2);

    SELECT preco INTO v_preco_atual
    FROM produto
    WHERE id_produto = p_id_produto;

    INSERT INTO item_pedido (
        id_pedido,
        id_produto,
        quantidade,
        preco_unitario
    )
    VALUES (
        p_id_pedido,
        p_id_produto,
        p_quantidade,
        v_preco_atual
    );
END $$

DELIMITER ;

CALL adicionar_item_pedido(@novo_pedido, 1, 2);

-- 12. 
CALL cadastrar_cliente('Apenas Um Parametro');
