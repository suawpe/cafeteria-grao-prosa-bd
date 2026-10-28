-- Cafeteria Grão & Prosa - Criação do banco e das tabelas

DROP DATABASE IF EXISTS cafeteria;
CREATE DATABASE cafeteria;
USE cafeteria;

CREATE TABLE clientes (
    id_cliente    INT AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL,
    cpf           CHAR(11)     NOT NULL UNIQUE,
    email         VARCHAR(100) UNIQUE,
    telefone      VARCHAR(15),
    data_cadastro DATE         NOT NULL
);

CREATE TABLE funcionarios (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome           VARCHAR(100) NOT NULL,
    cpf            CHAR(11)     NOT NULL UNIQUE,
    cargo          VARCHAR(40)  NOT NULL,
    salario        DECIMAL(8,2) NOT NULL,
    data_admissao  DATE         NOT NULL
);

CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome         VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE produtos (
    id_produto   INT AUTO_INCREMENT PRIMARY KEY,
    nome         VARCHAR(80)  NOT NULL,
    descricao    VARCHAR(200),
    preco        DECIMAL(8,2) NOT NULL CHECK (preco > 0),
    ativo        BOOLEAN      NOT NULL DEFAULT TRUE,
    id_categoria INT          NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categorias (id_categoria)
);

CREATE TABLE estoque (
    id_produto     INT      PRIMARY KEY,
    quantidade     INT      NOT NULL CHECK (quantidade >= 0),
    estoque_minimo INT      NOT NULL,
    atualizado_em  DATETIME NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES produtos (id_produto)
);

CREATE TABLE fornecedores (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    razao_social  VARCHAR(100) NOT NULL,
    cnpj          CHAR(14)     NOT NULL UNIQUE,
    telefone      VARCHAR(15),
    email         VARCHAR(100)
);

CREATE TABLE fornecedor_produto (
    id_fornecedor INT          NOT NULL,
    id_produto    INT          NOT NULL,
    preco_custo   DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (id_fornecedor, id_produto),
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedores (id_fornecedor),
    FOREIGN KEY (id_produto)    REFERENCES produtos (id_produto)
);

CREATE TABLE formas_pagamento (
    id_forma_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    descricao          VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE pedidos (
    id_pedido          INT AUTO_INCREMENT PRIMARY KEY,
    data_pedido        DATETIME NOT NULL,
    id_cliente         INT NULL,
    id_funcionario     INT NOT NULL,
    id_forma_pagamento INT NOT NULL,
    FOREIGN KEY (id_cliente)         REFERENCES clientes (id_cliente),
    FOREIGN KEY (id_funcionario)     REFERENCES funcionarios (id_funcionario),
    FOREIGN KEY (id_forma_pagamento) REFERENCES formas_pagamento (id_forma_pagamento)
);

CREATE TABLE itens_pedido (
    id_pedido      INT          NOT NULL,
    id_produto     INT          NOT NULL,
    quantidade     INT          NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto),
    FOREIGN KEY (id_pedido)  REFERENCES pedidos (id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produtos (id_produto)
);
