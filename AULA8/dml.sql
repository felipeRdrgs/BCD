DROP DATABASE IF EXISTS SMARTCOFFE_DML_FELIPE;
CREATE DATABASE SMARTCOFFE_DML_FELIPE;

USE SMARTCOFFE_DML_FELIPE;


CREATE TABLE CATEGORIA (
    id_categorias INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE CLIENTE (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE,
    telefone VARCHAR(15),
    cidade VARCHAR(60) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    qtd_clientes INT NOT NULL
);

CREATE TABLE PRODUTO (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    id_categoria INT NOT NULL,
    qtd_produtos INT NOT NULL

    CONSTRAINT fk_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES CATEGORIAS (id_categorias)
);

CREATE TABLE PEDIDO (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_pedido ENUM(
        'ABERTO',
        'PREPARANDO',
        'FINALIZADO',
        'CANCELADO'
    ) NOT NULL DEFAULT 'ABERTO',
    valor_total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    id_cliente INT NOT NULL,
    faturamento_total INT NOT NULL

    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE (id_cliente)
);

CREATE TABLE ITEM_PEDIDO (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    observacao VARCHAR(150),

    CONSTRAINT fk_item_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES PEDIDO (id_pedido),

    CONSTRAINT fk_item_produto
        FOREIGN KEY (id_produto)
        REFERENCES PRODUTO (id_produto)
);

CREATE TABLE FORMA_PAGAMENTO (
    id_forma_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE PAGAMENTOS (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_forma_pagamento INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_pagamento_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES PEDIDO (id_pedido),

    CONSTRAINT fk_pagamento_forma_pagamento
        FOREIGN KEY (id_forma_pagamento)
        REFERENCES FORMA_PAGAMENTO (id_forma_pagamento)
);


INSERT INTO CLIENTE (nome, email, telefone, cidade, ativo) VALUES
('Arthur Nunes', 'arthur@email.com', '199999901', 'Rondonia', TRUE),
('Beatriz Raissa', 'beatriz@email.com', '199999902', 'Limeira', TRUE),
('Davi Ferreira', 'davi@email.com', '199999912', 'Limeira', TRUE),
('Felipe Rodrigues', 'felipe@email.com', '1996486720', 'Limeira', TRUE),
('Francisco Magri', 'chico@email.com', '199999903', 'Limeira', TRUE),
('Franz Kramer', 'franz@email.com', '199999904', 'Limeira', TRUE),
('Gabriel Nogueira', 'gabriel@email.com', '199999905', 'Limeira', TRUE),
('Gabrielli Araujo', 'gabrielli@email.com', '199999906', 'Americana', TRUE),
('Isabella Alves', 'isabella@email.com', '199999907', 'Limeira', TRUE),
('Keynan Santos', 'keynan@email.com', '199999913', 'Santos', TRUE),
('Larissa Ramires', 'larissa@email.com', '199999908', 'Limeira', TRUE),
('Leonardo Dias', 'leonardo@email.com', '199999909', 'Valinhos', TRUE),
('Luana Lima', 'luana@email.com', '199999910', 'Limeira', TRUE),
('Luccas Manfredi', 'lucas@email.com', '199999911', 'Campinas', TRUE);

INSERT INTO CATEGORIAS (nome) VALUES
('cafés'),
('bebidas geladas'),
('bebidas quentes'),
('salgados'),
('sobremesas'),
('combo'),
('doces');

INSERT INTO FORMA_PAGAMENTO (nome) VALUES
('Dinheiro'),
('Cartão de Crédito'),
('Cartão de Débito'),
('PIX');

INSERT INTO PRODUTO (nome, preco, ativo, id_categoria) VALUES
('Café Puro', 5.00, TRUE, 1),
('Café Expresso', 4.50, TRUE, 1),
('Cappuccino', 6.00, TRUE, 1),
('Café com Chocolate', 7.00, TRUE, 1);

UPDATE CLIENTE
SET telefone = '19945739756',
    cidade = 'Piracicaba'
WHERE id_cliente = 9;

INSERT INTO PEDIDO (data_pedido, status_pedido, valor_total, id_cliente) VALUES
(NOW(), 'ABERTO', 14.50, 1),
(NOW(), 'ABERTO', 25.00, 2);

INSERT INTO ITEM_PEDIDO (id_pedido, id_produto, quantidade, preco_unitario, observacao) VALUES
(1, 1, 2, 5.00, 'Sem açúcar'),
(1, 2, 1, 4.50, 'Com leite'),
(2, 3, 3, 6.00, 'Sem canela'),
(2, 4, 1, 7.00, 'Com chantilly');


INSERT INTO CLIENTE (nome, email, telefone, cidade, ativo) 
VALUES ('Carlos Silva', 'carlos.silva3@email.com', '19999999999', 'Santos', TRUE);

SET @cliente_compra = LAST_INSERT_ID();


INSERT INTO PEDIDO (data_pedido, status_pedido, valor_total, id_cliente) 
VALUES (NOW(), 'ABERTO', 0.00, @cliente_compra);

SET @pedido_compra = LAST_INSERT_ID();


INSERT INTO ITEM_PEDIDO (id_pedido, id_produto, quantidade, preco_unitario) 
VALUES 
(@pedido_compra, 4, 1, 13.00),
(@pedido_compra, 1, 1, 9.00);


UPDATE PEDIDO
SET valor_total = 22.00,
    status_pedido = 'PREPARANDO'
WHERE id_pedido = @pedido_compra;

INSERT INTO PAGAMENTOS (id_pedido, id_forma_pagamento, valor, data_pagamento) 
VALUES (@pedido_compra, 2, 22.00, NOW());


SELECT p.id_pedido,
       c.nome AS nome_cliente,
       p.status_pedido AS Status_pedido,
       p.valor_total AS compra_total
FROM PEDIDO p
JOIN CLIENTE c ON c.id_cliente = p.id_cliente
WHERE p.id_pedido = @pedido_compra;

START TRANSACTION;

UPDATE produto 
SET preco = preco * 2.80
WHERE id_categoria = 1;

SELECT id_produto, nome, preco
FROM produto 
WHERE id_categoria = 1;

ROLLBACK;

COMMIT;

START TRANSACTION;

UPDATE cliente SET cidade - 'santos' WHERE id_cliente = 121;

SELECT * FROM cliente WHERE id_cliente = 121;

COMMIT;

ROLLBACK; 