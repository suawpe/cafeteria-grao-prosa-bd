#  Banco de Dados da Cafeteria Grão & Prosa

Atividade III – SEDUC DEST2: planejar, criar e testar um banco de dados relacional.
**SGBD:** MySQL 8 · **Domínio:** gestão de uma cafeteria (clientes, cardápio, estoque, fornecedores e vendas).

## Sumário

1. [Domínio](#1-domínio)
2. [Contextualização](#2-contextualização)
3. [Proposta de melhoria](#3-proposta-de-melhoria)
4. [Modelagem lógica](#4-modelagem-lógica)
5. [Formas normais](#5-formas-normais-1fn-2fn-3fn-e-4fn)
6. [Scripts SQL e consultas](#6-scripts-sql-e-consultas)
7. [Dump do banco](#7-dump-do-banco-estrutura-e-dados)
8. [Estrutura do repositório e commit](#8-estrutura-do-repositório-e-commit)

---

## 1. Domínio

Sistema de gestão de uma cafeteria de bairro, a **Grão & Prosa**: cadastro de clientes e funcionários, cardápio por categorias, controle de estoque, fornecedores e registro de vendas (pedidos e itens).

## 2. Contextualização

A Grão & Prosa fica em São Paulo, tem 6 funcionários e cerca de 150 pedidos por dia. Hoje tudo é controlado em **planilhas e cadernos de papel**, o que causa vários problemas:

- **Redundância:** nome e telefone do cliente são digitados a cada compra, e o preço do produto é copiado em cada linha de venda.
- **Inconsistência:** o mesmo cliente aparece como "Maria S." e "Maria Silva", e o preço de um café muda numa planilha mas não na outra.
- **Estoque descontrolado:** não há baixa automática, então o grão de café acaba sem aviso.
- **Relatórios lentos:** descobrir o produto mais vendido do mês ou o faturamento por forma de pagamento exige somar tudo à mão.
- **Sem integridade:** é possível vender um produto que não existe ou registrar um pedido sem atendente.
- **Sem segurança e concorrência:** vários funcionários editam o mesmo arquivo, com risco de sobrescrita e perda de dados, e não existe backup confiável.

## 3. Proposta de melhoria

Implantar um **banco de dados relacional (MySQL)** que centralize as informações:

- cada dado é gravado **uma única vez**, e as tabelas se ligam por chaves estrangeiras;
- **restrições** (`PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, `CHECK`) garantem a consistência;
- o **estoque** fica ligado aos produtos, com comparação contra o estoque mínimo;
- consultas SQL geram relatórios em segundos;
- **dumps periódicos** garantem backup e recuperação.

## 4. Modelagem lógica

### 4.1 Diagrama entidade-relacionamento

<img width="868" height="699" alt="Diagrama ER da cafeteria" src="https://github.com/user-attachments/assets/7f8dcc79-60e9-47b4-aa22-d42a2c7d76c4" />

### 4.2 Tabelas, campos e tipos

**clientes**

| Campo | Tipo | Restrição |
|---|---|---|
| id_cliente | INT AUTO_INCREMENT | PK |
| nome | VARCHAR(100) | NOT NULL |
| cpf | CHAR(11) | UNIQUE, NOT NULL |
| email | VARCHAR(100) | UNIQUE |
| telefone | VARCHAR(15) | |
| data_cadastro | DATE | NOT NULL |

**funcionarios**

| Campo | Tipo | Restrição |
|---|---|---|
| id_funcionario | INT AUTO_INCREMENT | PK |
| nome | VARCHAR(100) | NOT NULL |
| cpf | CHAR(11) | UNIQUE, NOT NULL |
| cargo | VARCHAR(40) | NOT NULL |
| salario | DECIMAL(8,2) | NOT NULL |
| data_admissao | DATE | NOT NULL |

**categorias**

| Campo | Tipo | Restrição |
|---|---|---|
| id_categoria | INT AUTO_INCREMENT | PK |
| nome | VARCHAR(50) | UNIQUE, NOT NULL |

**produtos**

| Campo | Tipo | Restrição |
|---|---|---|
| id_produto | INT AUTO_INCREMENT | PK |
| nome | VARCHAR(80) | NOT NULL |
| descricao | VARCHAR(200) | |
| preco | DECIMAL(8,2) | NOT NULL, CHECK (> 0) |
| ativo | BOOLEAN | NOT NULL, DEFAULT TRUE |
| id_categoria | INT | NOT NULL, FK → categorias |

**estoque**

| Campo | Tipo | Restrição |
|---|---|---|
| id_produto | INT | PK e FK → produtos |
| quantidade | INT | NOT NULL, CHECK (>= 0) |
| estoque_minimo | INT | NOT NULL |
| atualizado_em | DATETIME | NOT NULL |

**fornecedores**

| Campo | Tipo | Restrição |
|---|---|---|
| id_fornecedor | INT AUTO_INCREMENT | PK |
| razao_social | VARCHAR(100) | NOT NULL |
| cnpj | CHAR(14) | UNIQUE, NOT NULL |
| telefone | VARCHAR(15) | |
| email | VARCHAR(100) | |

**fornecedor_produto** (tabela associativa)

| Campo | Tipo | Restrição |
|---|---|---|
| id_fornecedor | INT | PK composta, FK → fornecedores |
| id_produto | INT | PK composta, FK → produtos |
| preco_custo | DECIMAL(8,2) | NOT NULL |

**formas_pagamento**

| Campo | Tipo | Restrição |
|---|---|---|
| id_forma_pagamento | INT AUTO_INCREMENT | PK |
| descricao | VARCHAR(30) | UNIQUE, NOT NULL |

**pedidos**

| Campo | Tipo | Restrição |
|---|---|---|
| id_pedido | INT AUTO_INCREMENT | PK |
| data_pedido | DATETIME | NOT NULL |
| id_cliente | INT | FK → clientes (NULL em venda de balcão) |
| id_funcionario | INT | NOT NULL, FK → funcionarios |
| id_forma_pagamento | INT | NOT NULL, FK → formas_pagamento |

**itens_pedido** (tabela associativa)

| Campo | Tipo | Restrição |
|---|---|---|
| id_pedido | INT | PK composta, FK → pedidos |
| id_produto | INT | PK composta, FK → produtos |
| quantidade | INT | NOT NULL, CHECK (> 0) |
| preco_unitario | DECIMAL(8,2) | NOT NULL |

> `preco_unitario` guarda o preço **no momento da venda**. Assim, mudar o preço no cardápio não altera o histórico.

### 4.3 Relacionamentos e cardinalidades

| Relacionamento | Tipo | Explicação |
|---|---|---|
| categorias → produtos | **1:N** | Uma categoria tem vários produtos; cada produto pertence a uma categoria. |
| produtos → estoque | **1:1** | Cada produto tem um único registro de estoque. |
| clientes → pedidos | **1:N** | Um cliente faz vários pedidos (o cliente é opcional no pedido). |
| funcionarios → pedidos | **1:N** | Um funcionário atende vários pedidos. |
| formas_pagamento → pedidos | **1:N** | Uma forma de pagamento é usada em vários pedidos. |
| pedidos ↔ produtos | **N:N** | Resolvido pela tabela `itens_pedido`. |
| fornecedores ↔ produtos | **N:N** | Resolvido pela tabela `fornecedor_produto`. |

## 5. Formas normais (1FN, 2FN, 3FN e 4FN)

**Normalizar** é organizar as tabelas para que cada informação fique guardada em **um só lugar**, evitando repetição e dados contraditórios. Ponto de partida: uma linha da planilha atual da cafeteria.

| pedido | data | cliente | telefones | itens | pagamento |
|---|---|---|---|---|---|
| 1 | 28/09/2026 | Maria Silva | 11987654321, 1133334444 | 1x Cappuccino, 2x Pão de Queijo | Pix |

### 1FN: um valor por célula

- **Regra:** cada campo guarda um único valor, sem listas dentro da célula.
- **Problema:** `telefones` e `itens` misturam vários valores, e o SQL não consegue somar nem filtrar.
- **Solução:** cada item vendido vira uma linha.

| id_pedido | produto | quantidade |
|---|---|---|
| 1 | Cappuccino | 1 |
| 1 | Pão de Queijo | 2 |

**Na proposta:** originou a tabela `itens_pedido`.

### 2FN: cada campo depende da chave inteira

- **Regra:** em tabelas com chave composta, todo campo depende de **toda** a chave, e não de uma parte.
- **Problema:** em `itens_pedido` (chave `id_pedido` + `id_produto`), o `nome_produto` dependeria só do `id_produto` e se repetiria em cada venda.

| id_pedido | id_produto | nome_produto | quantidade |
|---|---|---|---|
| 1 | 2 | Cappuccino | 1 |
| 4 | 2 | Cappuccino | 2 |

- **Solução:** o nome fica em `produtos`, e `itens_pedido` guarda só `quantidade` e `preco_unitario`.

**Na proposta:** o mesmo vale para `preco_custo` em `fornecedor_produto`.

### 3FN: nenhum campo depende de outro que não é a chave

- **Regra:** um campo comum não pode depender de outro campo comum.
- **Problema:** se `produtos` guardasse `nome_categoria`, ele dependeria de `id_categoria`, e "Cafés" se repetiria em várias linhas.

| id_produto | nome | id_categoria | nome_categoria |
|---|---|---|---|
| 1 | Espresso | 1 | Cafés |
| 2 | Cappuccino | 1 | Cafés |

- **Solução:** criar a tabela `categorias`. Renomear uma categoria passa a ser uma única alteração.

**Na proposta:** o mesmo raciocínio criou `clientes`, `funcionarios` e `formas_pagamento`. Em `pedidos` ficam só os códigos.

### 4FN: não misturar listas independentes na mesma tabela

- **Regra:** uma tabela não deve guardar duas listas de valores que não têm relação entre si.
- **Problema:** se um produto tem vários fornecedores **e** vários ingredientes na mesma tabela, cada fornecedor se repete com cada ingrediente.
- **Solução:** uma tabela para cada lista.

**Na proposta:** os fornecedores ficam em `fornecedor_produto`, e o pedido (`pedidos`) fica separado do conteúdo (`itens_pedido`). Nenhuma tabela mistura listas independentes. O exemplo de ingredientes serve só para explicar a regra e não existe no banco.

### Resumo

| Forma normal | Pergunta para checar | Tabela que surgiu |
|---|---|---|
| 1FN | Cada célula tem um único valor? | `itens_pedido` |
| 2FN | Todo campo depende da chave inteira? | `produtos`, `fornecedor_produto` |
| 3FN | Algum campo depende de outro que não é a chave? | `categorias`, `clientes`, `funcionarios`, `formas_pagamento` |
| 4FN | A tabela mistura duas listas independentes? | `fornecedor_produto` |

## 6. Scripts SQL e consultas

Execute os arquivos nesta ordem:

| Ordem | Arquivo | O que faz |
|---|---|---|
| 1 | [`sql/01_criar_banco_e_tabelas.sql`](sql/01_criar_banco_e_tabelas.sql) | Cria o banco `cafeteria` e as 10 tabelas |
| 2 | [`sql/02_inserir_dados.sql`](sql/02_inserir_dados.sql) | Popula as tabelas (mínimo de 5 registros cada) |
| 3 | [`sql/03_consultas.sql`](sql/03_consultas.sql) | As 15 consultas abaixo |

```bash
mysql -u root -p < sql/01_criar_banco_e_tabelas.sql
mysql -u root -p < sql/02_inserir_dados.sql
mysql -u root -p < sql/03_consultas.sql
```

Registros inseridos: categorias (5), produtos (12), estoque (12), fornecedores (5), fornecedor_produto (13), clientes (6), funcionarios (6), formas_pagamento (5), pedidos (12), itens_pedido (26).

### Comandos usados nas consultas

| Comando | Para que serve |
|---|---|
| `SELECT ... FROM` | escolhe quais colunas mostrar e de qual tabela |
| `INNER JOIN ... ON` | junta duas tabelas pela chave (só traz linhas que têm par nas duas) |
| `WHERE` | filtra as linhas |
| `LIKE` | busca por parte do texto (`%` significa "qualquer coisa") |
| `BETWEEN ... AND` | filtra valores dentro de um intervalo |
| `IS NULL` | encontra campos sem valor |
| `SUM`, `COUNT`, `AVG` | somam, contam e calculam a média |
| `GROUP BY` | agrupa linhas para usar `SUM`, `COUNT` ou `AVG` por grupo |
| `ORDER BY` | ordena o resultado (`DESC` é decrescente) |
| `LIMIT` | limita a quantidade de linhas |
| apelido (ex.: `produtos prod`) | nome curto da tabela dentro da consulta; `prod.nome` é a coluna `nome` da tabela `produtos` |
| `AS` | dá um nome à coluna no resultado (ex.: `cat.nome AS categoria`) |

### Apelidos das tabelas

Cada tabela usa **sempre o mesmo apelido** nas consultas, o que evita confusão quando duas tabelas têm uma coluna com o mesmo nome (como `nome`).

| Tabela | Apelido | Tabela | Apelido |
|---|---|---|---|
| `clientes` | `cli` | `fornecedores` | `forn` |
| `funcionarios` | `func` | `fornecedor_produto` | `fprod` |
| `categorias` | `cat` | `formas_pagamento` | `fpag` |
| `produtos` | `prod` | `pedidos` | `ped` |
| `estoque` | `est` | `itens_pedido` | `item` |

Consultas com uma tabela só (como a 2, a 3 e a 14) não precisam de apelido.

As 15 consultas abaixo têm contexto, SQL e resultado.

### Consulta 1: Cardápio ativo com a categoria de cada produto (INNER JOIN, WHERE, ORDER BY)

**Contexto:** A gerente quer imprimir o cardápio completo, organizado por categoria.

```sql
SELECT cat.nome AS categoria, prod.nome AS produto, prod.preco
FROM produtos prod
INNER JOIN categorias cat ON cat.id_categoria = prod.id_categoria
WHERE prod.ativo = TRUE
ORDER BY cat.nome, prod.nome;
```

**Resultado:**

| categoria | produto | preco |
|---|---|---|
| Bebidas Geladas | Chá Gelado de Limão | 9.00 |
| Bebidas Geladas | Frappé de Caramelo | 16.00 |
| Cafés | Cappuccino | 12.00 |
| Cafés | Espresso | 6.00 |
| Cafés | Latte | 13.00 |
| Cafés | Mocha | 14.00 |
| Doces | Bolo de Cenoura | 10.00 |
| Doces | Brownie | 9.50 |
| Doces | Cookie de Chocolate | 8.00 |
| Grãos e Acessórios | Café em Grãos 250g | 38.00 |
| Salgados | Croissant de Presunto e Queijo | 12.00 |
| Salgados | Pão de Queijo | 7.00 |

### Consulta 2: Produtos com preço entre R$ 8,00 e R$ 13,00 (BETWEEN, ORDER BY)

**Contexto:** A cafeteria vai montar um combo e precisa listar os itens de preço intermediário (de R$ 8,00 a R$ 13,00).

```sql
SELECT nome, preco
FROM produtos
WHERE preco BETWEEN 8.00 AND 13.00
ORDER BY preco DESC, nome;
```

**Resultado:**

| nome | preco |
|---|---|
| Latte | 13.00 |
| Cappuccino | 12.00 |
| Croissant de Presunto e Queijo | 12.00 |
| Bolo de Cenoura | 10.00 |
| Brownie | 9.50 |
| Chá Gelado de Limão | 9.00 |
| Cookie de Chocolate | 8.00 |

### Consulta 3: Clientes cujo nome começa com "Mari" (LIKE)

**Contexto:** A equipe quer enviar uma promoção a clientes cujo nome começa com "Mari" (busca com `LIKE`).

```sql
SELECT id_cliente, nome, email
FROM clientes
WHERE nome LIKE 'Mari%';
```

**Resultado:**

| id_cliente | nome | email |
|---|---|---|
| 1 | Maria Silva | maria.silva@email.com |
| 5 | Mariana Costa | mariana.costa@email.com |

### Consulta 4: Faturamento total da cafeteria (SUM)

**Contexto:** A gerente quer saber quanto a cafeteria faturou desde o início dos registros.

```sql
SELECT SUM(quantidade * preco_unitario) AS faturamento_total
FROM itens_pedido;
```

**Resultado:**

| faturamento_total |
|---|
| 379.00 |

### Consulta 5: Faturamento por forma de pagamento (INNER JOIN, GROUP BY, SUM, ORDER BY)

**Contexto:** O financeiro precisa conferir quanto entrou por cada forma de pagamento (útil para negociar taxas das maquininhas).

```sql
SELECT fpag.descricao AS forma_pagamento,
       SUM(item.quantidade * item.preco_unitario) AS total
FROM formas_pagamento fpag
INNER JOIN pedidos ped       ON ped.id_forma_pagamento = fpag.id_forma_pagamento
INNER JOIN itens_pedido item ON item.id_pedido = ped.id_pedido
GROUP BY fpag.descricao
ORDER BY total DESC;
```

**Resultado:**

| forma_pagamento | total |
|---|---|
| Cartão de Crédito | 147.00 |
| Pix | 102.50 |
| Cartão de Débito | 95.50 |
| Vale-Refeição | 21.00 |
| Dinheiro | 13.00 |

### Consulta 6: Top 5 produtos mais vendidos em quantidade (GROUP BY, SUM, ORDER BY, LIMIT)

**Contexto:** O marketing quer saber quais são os 5 itens mais vendidos para destacá-los no cardápio. Em caso de empate, vale a ordem alfabética.

```sql
SELECT prod.nome AS produto, SUM(item.quantidade) AS unidades_vendidas
FROM itens_pedido item
INNER JOIN produtos prod ON prod.id_produto = item.id_produto
GROUP BY prod.nome
ORDER BY unidades_vendidas DESC, prod.nome
LIMIT 5;
```

**Resultado:**

| produto | unidades_vendidas |
|---|---|
| Cappuccino | 6 |
| Pão de Queijo | 6 |
| Cookie de Chocolate | 3 |
| Croissant de Presunto e Queijo | 3 |
| Espresso | 3 |

### Consulta 7: Valor total de cada pedido com o nome do cliente (INNER JOIN, GROUP BY, SUM)

**Contexto:** O atendimento quer ver o valor de cada pedido identificado por cliente, para conferir comprovantes.

```sql
SELECT ped.id_pedido, cli.nome AS cliente, ped.data_pedido,
       SUM(item.quantidade * item.preco_unitario) AS valor_pedido
FROM pedidos ped
INNER JOIN clientes cli      ON cli.id_cliente = ped.id_cliente
INNER JOIN itens_pedido item ON item.id_pedido = ped.id_pedido
GROUP BY ped.id_pedido, cli.nome, ped.data_pedido
ORDER BY ped.id_pedido;
```

**Resultado:**

| id_pedido | cliente | data_pedido | valor_pedido |
|---|---|---|---|
| 1 | Maria Silva | 2026-09-28 08:15:00 | 26.00 |
| 2 | João Pereira | 2026-10-01 09:30:00 | 36.00 |
| 4 | Ana Souza | 2026-10-05 14:20:00 | 45.50 |
| 5 | Maria Silva | 2026-10-08 08:45:00 | 19.00 |
| 6 | Carlos Oliveira | 2026-10-12 16:10:00 | 48.00 |
| 8 | Mariana Costa | 2026-10-18 15:00:00 | 24.00 |
| 9 | João Pereira | 2026-10-20 09:10:00 | 27.00 |
| 10 | Pedro Santos | 2026-10-22 17:45:00 | 50.00 |
| 11 | Maria Silva | 2026-10-25 11:20:00 | 33.50 |
| 12 | Ana Souza | 2026-10-27 13:00:00 | 36.00 |

### Consulta 8: Pedidos feitos entre 01/10/2026 e 15/10/2026 (BETWEEN com datas)

**Contexto:** A gerente quer revisar todos os pedidos da primeira quinzena de outubro de 2026.

```sql
SELECT id_pedido, data_pedido
FROM pedidos
WHERE data_pedido BETWEEN '2026-10-01 00:00:00' AND '2026-10-15 23:59:59'
ORDER BY data_pedido;
```

**Resultado:**

| id_pedido | data_pedido |
|---|---|
| 2 | 2026-10-01 09:30:00 |
| 3 | 2026-10-02 10:05:00 |
| 4 | 2026-10-05 14:20:00 |
| 5 | 2026-10-08 08:45:00 |
| 6 | 2026-10-12 16:10:00 |
| 7 | 2026-10-15 12:30:00 |

### Consulta 9: Produtos com estoque abaixo do mínimo (INNER JOIN, WHERE comparando colunas)

**Contexto:** O comprador precisa de uma lista de reposição: produtos cuja quantidade em estoque está abaixo do mínimo.

```sql
SELECT prod.nome AS produto, est.quantidade, est.estoque_minimo,
       (est.estoque_minimo - est.quantidade) AS falta_repor
FROM estoque est
INNER JOIN produtos prod ON prod.id_produto = est.id_produto
WHERE est.quantidade < est.estoque_minimo
ORDER BY falta_repor DESC;
```

**Resultado:**

| produto | quantidade | estoque_minimo | falta_repor |
|---|---|---|---|
| Pão de Queijo | 12 | 20 | 8 |
| Bolo de Cenoura | 8 | 10 | 2 |

### Consulta 10: Faturamento por categoria de produto (INNER JOIN, GROUP BY, SUM)

**Contexto:** A gerente quer saber qual categoria rende mais para decidir onde ampliar o cardápio.

```sql
SELECT cat.nome AS categoria,
       SUM(item.quantidade * item.preco_unitario) AS total
FROM categorias cat
INNER JOIN produtos prod     ON prod.id_categoria = cat.id_categoria
INNER JOIN itens_pedido item ON item.id_produto = prod.id_produto
GROUP BY cat.nome
ORDER BY total DESC;
```

**Resultado:**

| categoria | total |
|---|---|
| Cafés | 143.00 |
| Salgados | 78.00 |
| Doces | 63.00 |
| Bebidas Geladas | 57.00 |
| Grãos e Acessórios | 38.00 |

### Consulta 11: Total vendido por funcionário (INNER JOIN, GROUP BY, SUM, ORDER BY)

**Contexto:** A gerente quer saber quanto cada funcionário vendeu. Só aparecem funcionários que registraram pedidos.

```sql
SELECT func.nome AS funcionario,
       SUM(item.quantidade * item.preco_unitario) AS total_vendido
FROM funcionarios func
INNER JOIN pedidos ped       ON ped.id_funcionario = func.id_funcionario
INNER JOIN itens_pedido item ON item.id_pedido = ped.id_pedido
GROUP BY func.nome
ORDER BY total_vendido DESC;
```

**Resultado:**

| funcionario | total_vendido |
|---|---|
| Camila Duarte | 190.00 |
| Lucas Almeida | 189.00 |

### Consulta 12: Total gasto por cliente (INNER JOIN, GROUP BY, SUM, ORDER BY)

**Contexto:** A cafeteria quer conhecer seus clientes que mais compram, do maior para o menor gasto.

```sql
SELECT cli.nome AS cliente,
       SUM(item.quantidade * item.preco_unitario) AS total_gasto
FROM clientes cli
INNER JOIN pedidos ped       ON ped.id_cliente = cli.id_cliente
INNER JOIN itens_pedido item ON item.id_pedido = ped.id_pedido
GROUP BY cli.nome
ORDER BY total_gasto DESC;
```

**Resultado:**

| cliente | total_gasto |
|---|---|
| Ana Souza | 81.50 |
| Maria Silva | 78.50 |
| João Pereira | 63.00 |
| Pedro Santos | 50.00 |
| Carlos Oliveira | 48.00 |
| Mariana Costa | 24.00 |

### Consulta 13: Produtos fornecidos com custo de R$ 5,00 ou mais (INNER JOIN, WHERE, ORDER BY)

**Contexto:** O comprador quer ver quais produtos têm custo de pelo menos R$ 5,00 e de qual fornecedor vêm.

```sql
SELECT prod.nome AS produto, forn.razao_social AS fornecedor, fprod.preco_custo
FROM fornecedor_produto fprod
INNER JOIN produtos prod     ON prod.id_produto = fprod.id_produto
INNER JOIN fornecedores forn ON forn.id_fornecedor = fprod.id_fornecedor
WHERE fprod.preco_custo >= 5.00
ORDER BY fprod.preco_custo DESC, prod.nome;
```

**Resultado:**

| produto | fornecedor | preco_custo |
|---|---|---|
| Café em Grãos 250g | Café Serra Alta Ltda | 22.00 |
| Frappé de Caramelo | Distribuidora Gelo Norte | 6.00 |
| Mocha | Laticínios Vale Verde S/A | 6.00 |
| Latte | Laticínios Vale Verde S/A | 5.50 |
| Cappuccino | Laticínios Vale Verde S/A | 5.00 |
| Croissant de Presunto e Queijo | Padaria Pão Quente ME | 5.00 |

### Consulta 14: Pedidos de balcão, sem cliente identificado (WHERE IS NULL)

**Contexto:** A gerente quer identificar os pedidos feitos sem cadastro de cliente (balcão). Nesses pedidos, `id_cliente` fica vazio (`NULL`).

```sql
SELECT id_pedido, data_pedido
FROM pedidos
WHERE id_cliente IS NULL
ORDER BY id_pedido;
```

**Resultado:**

| id_pedido | data_pedido |
|---|---|
| 3 | 2026-10-02 10:05:00 |
| 7 | 2026-10-15 12:30:00 |

### Consulta 15: Quantidade de produtos e preço médio por categoria (INNER JOIN, GROUP BY, COUNT, AVG)

**Contexto:** A gerente quer comparar as categorias do cardápio: quantos produtos cada uma tem e qual o preço médio.

```sql
SELECT cat.nome AS categoria,
       COUNT(prod.id_produto) AS qtd_produtos,
       ROUND(AVG(prod.preco), 2) AS preco_medio
FROM categorias cat
INNER JOIN produtos prod ON prod.id_categoria = cat.id_categoria
GROUP BY cat.nome
ORDER BY preco_medio DESC;
```

**Resultado:**

| categoria | qtd_produtos | preco_medio |
|---|---|---|
| Grãos e Acessórios | 1 | 38.00 |
| Bebidas Geladas | 2 | 12.50 |
| Cafés | 4 | 11.25 |
| Salgados | 2 | 9.50 |
| Doces | 3 | 9.17 |


## 7. Dump do banco (estrutura e dados)

O `mysqldump` gera um arquivo `.sql` com os `CREATE TABLE` (estrutura) e os `INSERT` (dados).

1. Abra o terminal (no Windows, use o Prompt de Comando).
2. Gere o dump:
   ```bash
   mysqldump -u root -p --databases cafeteria > sql/dump_cafeteria.sql
   ```
   O `--databases` inclui `CREATE DATABASE` e `USE` no arquivo.
3. Digite a senha do MySQL quando pedir.
4. Abra `sql/dump_cafeteria.sql` e confira se aparecem `CREATE TABLE` e `INSERT INTO`.
5. Para restaurar o banco em outro computador:
   ```bash
   mysql -u root -p < sql/dump_cafeteria.sql
   ```

## 8. Estrutura do repositório e commit

```
cafeteria-grao-prosa-bd/
├── README.md
└── sql/
    ├── 01_criar_banco_e_tabelas.sql
    ├── 02_inserir_dados.sql
    ├── 03_consultas.sql
    └── dump_cafeteria.sql
```

Para enviar ao GitHub:

```bash
git init
git add README.md sql/
git commit -m "Banco de dados da cafeteria: modelagem, scripts SQL, consultas e dump"
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/cafeteria-grao-prosa-bd.git
git push -u origin main
```
