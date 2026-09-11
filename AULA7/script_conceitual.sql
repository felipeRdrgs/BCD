CREATE DATABASE IF NOT EXISTS SESI_CR_TA;

USE SESI_CR_TA;

CREATE TABLE cliente (
nome_cliente varchar(60),
id_cliente INT AUTO_INCREMENT PRIMARY KEY
);

CREATE TABLE PEDIDO (
id_pedido INT AUTO_INCREMENT PRIMARY KEY,
data_pedido DATETIME,
id_cliente INT AUTO_INCREMENT PRIMARY KEY,
FOREIGN KEY(id_cliente) REFERENCES cliente (id_cliente)
);

CREATE TABLE estoques (
nome_produto VARCHAR(100) NOT NULL,
id_produto INT NOT NULL UNIQUE,
id_estoque INT AUTO_INCREMENT PRIMARY KEY,
quantidade INT NOT NULL
-- PRIMARY KEY(id_produto,id_estoque)
);

CREATE TABLE fornecedores (
id_fornecedor INT AUTO_INCREMENT PRIMARY KEY ,
razo_social VARCHAR(100) NOT NULL
);

CREATE TABLE produto (
nome_produto varchar(60),
id_produto INT AUTO_INCREMENT PRIMARY KEY 
);

-CREATE TABLE cliente (
id_cliente INT AUTO_INCREMENT PRIMARY KEY ,
CPF INT NOT NULL UNIQUE,
id_pedido INT NOT NULL
);

CREATE TABLE pedido (
id_pedido INT AUTO_INCREMENT PRIMARY KEY,
data_pedido DATETIME
);

CREATE TABLE ITEM_PRODUTO (
valor DECIMAL(10,2),
id_produto INT NOT NULL ,
id_fornecedor INT NOT NULL ,
id_item INT AUTO_INCREMENT PRIMARY KEY,
OBSERVACAO TEXT,
FOREIGN KEY(id_produto) REFERENCES produto (id_produto) 
);

