
-- Cafeteria Grão & Prosa - Carga de dados

USE cafeteria;

INSERT INTO categorias (nome) VALUES
('Cafés'), ('Bebidas Geladas'), ('Salgados'), ('Doces'), ('Grãos e Acessórios');

INSERT INTO produtos (nome, descricao, preco, ativo, id_categoria) VALUES
('Espresso',                       'Café expresso tradicional 50 ml',        6.00, TRUE, 1),
('Cappuccino',                     'Espresso com leite vaporizado e espuma', 12.00, TRUE, 1),
('Latte',                          'Espresso com bastante leite vaporizado', 13.00, TRUE, 1),
('Mocha',                          'Espresso com chocolate e leite',         14.00, TRUE, 1),
('Frappé de Caramelo',             'Bebida gelada batida com caramelo',      16.00, TRUE, 2),
('Chá Gelado de Limão',            'Chá preto com limão siciliano',           9.00, TRUE, 2),
('Pão de Queijo',                  'Porção com 3 unidades',                   7.00, TRUE, 3),
('Croissant de Presunto e Queijo', 'Croissant folhado recheado',             12.00, TRUE, 3),
('Bolo de Cenoura',                'Fatia com cobertura de chocolate',       10.00, TRUE, 4),
('Brownie',                        'Brownie de chocolate meio amargo',        9.50, TRUE, 4),
('Café em Grãos 250g',             'Pacote de grãos torrados, arábica',      38.00, TRUE, 5),
('Cookie de Chocolate',            'Cookie com gotas de chocolate',           8.00, TRUE, 4);

INSERT INTO estoque (id_produto, quantidade, estoque_minimo, atualizado_em) VALUES
(1, 80, 20, '2026-10-27 18:00:00'),
(2, 60, 20, '2026-10-27 18:00:00'),
(3, 55, 20, '2026-10-27 18:00:00'),
(4, 40, 15, '2026-10-27 18:00:00'),
(5, 30, 10, '2026-10-27 18:00:00'),
(6, 25, 10, '2026-10-27 18:00:00'),
(7, 12, 20, '2026-10-27 18:00:00'),
(8, 18, 15, '2026-10-27 18:00:00'),
(9,  8, 10, '2026-10-27 18:00:00'),
(10, 25, 10, '2026-10-27 18:00:00'),
(11, 15,  5, '2026-10-27 18:00:00'),
(12, 30, 10, '2026-10-27 18:00:00');

INSERT INTO fornecedores (razao_social, cnpj, telefone, email) VALUES
('Café Serra Alta Ltda',       '11222333000181', '1133334444', 'contato@serraalta.com.br'),
('Laticínios Vale Verde S/A',  '22333444000172', '1144445555', 'vendas@valeverde.com.br'),
('Padaria Pão Quente ME',      '33444555000163', '1155556666', 'pedidos@paoquente.com.br'),
('Doces & Cia Ltda',           '44555666000154', '1166667777', 'comercial@docesecia.com.br'),
('Distribuidora Gelo Norte',   '55666777000145', '1177778888', 'atendimento@gelonorte.com.br');

INSERT INTO fornecedor_produto (id_fornecedor, id_produto, preco_custo) VALUES
(1, 1, 2.50), (1, 2, 4.80), (1, 11, 22.00),
(2, 2, 5.00), (2, 3, 5.50), (2, 4, 6.00),
(3, 7, 2.50), (3, 8, 5.00),
(4, 9, 4.00), (4, 10, 4.50), (4, 12, 3.00),
(5, 5, 6.00), (5, 6, 3.00);

INSERT INTO clientes (nome, cpf, email, telefone, data_cadastro) VALUES
('Maria Silva',     '12345678901', 'maria.silva@email.com',     '11987654321', '2026-01-10'),
('João Pereira',    '23456789012', 'joao.pereira@email.com',    '11976543210', '2026-02-15'),
('Ana Souza',       '34567890123', 'ana.souza@email.com',       '11965432109', '2026-03-05'),
('Carlos Oliveira', '45678901234', 'carlos.oliveira@email.com', '11954321098', '2026-04-20'),
('Mariana Costa',   '56789012345', 'mariana.costa@email.com',   NULL,          '2026-06-01'),
('Pedro Santos',    '67890123456', 'pedro.santos@email.com',    '11943210987', '2026-08-12');

INSERT INTO funcionarios (nome, cpf, cargo, salario, data_admissao) VALUES
('Fernanda Lima',   '11122233344', 'Gerente',            5500.00, '2023-03-01'),
('Rafael Mendes',   '22233344455', 'Barista',            2800.00, '2024-01-15'),
('Juliana Rocha',   '33344455566', 'Barista',            2800.00, '2024-06-10'),
('Lucas Almeida',   '44455566677', 'Atendente',          2200.00, '2025-02-03'),
('Camila Duarte',   '55566677788', 'Atendente',          2200.00, '2025-09-01'),
('Bruno Ferreira',  '66677788899', 'Auxiliar de Cozinha',2100.00, '2026-01-20');

INSERT INTO formas_pagamento (descricao) VALUES
('Dinheiro'), ('Cartão de Débito'), ('Cartão de Crédito'), ('Pix'), ('Vale-Refeição');

INSERT INTO pedidos (data_pedido, id_cliente, id_funcionario, id_forma_pagamento) VALUES
('2026-09-28 08:15:00', 1,    4, 4),
('2026-10-01 09:30:00', 2,    4, 3),
('2026-10-02 10:05:00', NULL, 5, 1),
('2026-10-05 14:20:00', 3,    4, 2),
('2026-10-08 08:45:00', 1,    5, 4),
('2026-10-12 16:10:00', 4,    5, 3),
('2026-10-15 12:30:00', NULL, 4, 5),
('2026-10-18 15:00:00', 5,    5, 4),
('2026-10-20 09:10:00', 2,    4, 3),
('2026-10-22 17:45:00', 6,    5, 2),
('2026-10-25 11:20:00', 1,    4, 4),
('2026-10-27 13:00:00', 3,    5, 3);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 2, 1, 12.00), (1, 7, 2, 7.00),
(2, 3, 2, 13.00), (2, 9, 1, 10.00),
(3, 1, 1, 6.00),  (3, 7, 1, 7.00),
(4, 2, 2, 12.00), (4, 8, 1, 12.00), (4, 10, 1, 9.50),
(5, 2, 1, 12.00), (5, 7, 1, 7.00),
(6, 5, 2, 16.00), (6, 12, 2, 8.00),
(7, 8, 1, 12.00), (7, 6, 1, 9.00),
(8, 4, 1, 14.00), (8, 9, 1, 10.00),
(9, 3, 1, 13.00), (9, 7, 2, 7.00),
(10, 11, 1, 38.00), (10, 1, 2, 6.00),
(11, 2, 2, 12.00), (11, 10, 1, 9.50),
(12, 5, 1, 16.00), (12, 8, 1, 12.00), (12, 12, 1, 8.00);
