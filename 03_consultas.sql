
-- Cafeteria Grão & Prosa - 15 consultas

USE cafeteria;

-- Consulta 1: Cardápio ativo com a categoria de cada produto (INNER JOIN, WHERE, ORDER BY)
SELECT cat.nome AS categoria, prod.nome AS produto, prod.preco
FROM produtos prod
INNER JOIN categorias cat ON cat.id_categoria = prod.id_categoria
WHERE prod.ativo = TRUE
ORDER BY cat.nome, prod.nome;

-- Consulta 2: Produtos com preço entre R$ 8,00 e R$ 13,00 (BETWEEN, ORDER BY)
SELECT nome, preco
FROM produtos
WHERE preco BETWEEN 8.00 AND 13.00
ORDER BY preco DESC, nome;

-- Consulta 3: Clientes cujo nome começa com "Mari" (LIKE)
SELECT id_cliente, nome, email
FROM clientes
WHERE nome LIKE 'Mari%';

-- Consulta 4: Faturamento total da cafeteria (SUM)
SELECT SUM(quantidade * preco_unitario) AS faturamento_total
FROM itens_pedido;

-- Consulta 5: Faturamento por forma de pagamento (INNER JOIN, GROUP BY, SUM, ORDER BY)
SELECT fpag.descricao AS forma_pagamento,
       SUM(item.quantidade * item.preco_unitario) AS total
FROM formas_pagamento fpag
INNER JOIN pedidos ped       ON ped.id_forma_pagamento = fpag.id_forma_pagamento
INNER JOIN itens_pedido item ON item.id_pedido = ped.id_pedido
GROUP BY fpag.descricao
ORDER BY total DESC;

-- Consulta 6: Top 5 produtos mais vendidos em quantidade (GROUP BY, SUM, ORDER BY, LIMIT)
SELECT prod.nome AS produto, SUM(item.quantidade) AS unidades_vendidas
FROM itens_pedido item
INNER JOIN produtos prod ON prod.id_produto = item.id_produto
GROUP BY prod.nome
ORDER BY unidades_vendidas DESC, prod.nome
LIMIT 5;

-- Consulta 7: Valor total de cada pedido com o nome do cliente (INNER JOIN, GROUP BY, SUM)
SELECT ped.id_pedido, cli.nome AS cliente, ped.data_pedido,
       SUM(item.quantidade * item.preco_unitario) AS valor_pedido
FROM pedidos ped
INNER JOIN clientes cli      ON cli.id_cliente = ped.id_cliente
INNER JOIN itens_pedido item ON item.id_pedido = ped.id_pedido
GROUP BY ped.id_pedido, cli.nome, ped.data_pedido
ORDER BY ped.id_pedido;

-- Consulta 8: Pedidos feitos entre 01/10/2026 e 15/10/2026 (BETWEEN com datas)
SELECT id_pedido, data_pedido
FROM pedidos
WHERE data_pedido BETWEEN '2026-10-01 00:00:00' AND '2026-10-15 23:59:59'
ORDER BY data_pedido;

-- Consulta 9: Produtos com estoque abaixo do mínimo (INNER JOIN, WHERE comparando colunas)
SELECT prod.nome AS produto, est.quantidade, est.estoque_minimo,
       (est.estoque_minimo - est.quantidade) AS falta_repor
FROM estoque est
INNER JOIN produtos prod ON prod.id_produto = est.id_produto
WHERE est.quantidade < est.estoque_minimo
ORDER BY falta_repor DESC;

-- Consulta 10: Faturamento por categoria de produto (INNER JOIN, GROUP BY, SUM)
SELECT cat.nome AS categoria,
       SUM(item.quantidade * item.preco_unitario) AS total
FROM categorias cat
INNER JOIN produtos prod     ON prod.id_categoria = cat.id_categoria
INNER JOIN itens_pedido item ON item.id_produto = prod.id_produto
GROUP BY cat.nome
ORDER BY total DESC;

-- Consulta 11: Total vendido por funcionário (INNER JOIN, GROUP BY, SUM, ORDER BY)
SELECT func.nome AS funcionario,
       SUM(item.quantidade * item.preco_unitario) AS total_vendido
FROM funcionarios func
INNER JOIN pedidos ped       ON ped.id_funcionario = func.id_funcionario
INNER JOIN itens_pedido item ON item.id_pedido = ped.id_pedido
GROUP BY func.nome
ORDER BY total_vendido DESC;

-- Consulta 12: Total gasto por cliente (INNER JOIN, GROUP BY, SUM, ORDER BY)
SELECT cli.nome AS cliente,
       SUM(item.quantidade * item.preco_unitario) AS total_gasto
FROM clientes cli
INNER JOIN pedidos ped       ON ped.id_cliente = cli.id_cliente
INNER JOIN itens_pedido item ON item.id_pedido = ped.id_pedido
GROUP BY cli.nome
ORDER BY total_gasto DESC;

-- Consulta 13: Produtos fornecidos com custo de R$ 5,00 ou mais (INNER JOIN, WHERE, ORDER BY)
SELECT prod.nome AS produto, forn.razao_social AS fornecedor, fprod.preco_custo
FROM fornecedor_produto fprod
INNER JOIN produtos prod     ON prod.id_produto = fprod.id_produto
INNER JOIN fornecedores forn ON forn.id_fornecedor = fprod.id_fornecedor
WHERE fprod.preco_custo >= 5.00
ORDER BY fprod.preco_custo DESC, prod.nome;

-- Consulta 14: Pedidos de balcão, sem cliente identificado (WHERE IS NULL)
SELECT id_pedido, data_pedido
FROM pedidos
WHERE id_cliente IS NULL
ORDER BY id_pedido;

-- Consulta 15: Quantidade de produtos e preço médio por categoria (INNER JOIN, GROUP BY, COUNT, AVG)
SELECT cat.nome AS categoria,
       COUNT(prod.id_produto) AS qtd_produtos,
       ROUND(AVG(prod.preco), 2) AS preco_medio
FROM categorias cat
INNER JOIN produtos prod ON prod.id_categoria = cat.id_categoria
GROUP BY cat.nome
ORDER BY preco_medio DESC;
