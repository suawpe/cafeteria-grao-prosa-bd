-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: cafeteria
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (2,'Bebidas Geladas'),(1,'Cafés'),(4,'Doces'),(5,'Grãos e Acessórios'),(3,'Salgados');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `cpf` char(11) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefone` varchar(15) DEFAULT NULL,
  `data_cadastro` date NOT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `cpf` (`cpf`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Maria Silva','12345678901','maria.silva@email.com','11987654321','2026-01-10'),(2,'João Pereira','23456789012','joao.pereira@email.com','11976543210','2026-02-15'),(3,'Ana Souza','34567890123','ana.souza@email.com','11965432109','2026-03-05'),(4,'Carlos Oliveira','45678901234','carlos.oliveira@email.com','11954321098','2026-04-20'),(5,'Mariana Costa','56789012345','mariana.costa@email.com',NULL,'2026-06-01'),(6,'Pedro Santos','67890123456','pedro.santos@email.com','11943210987','2026-08-12');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque`
--

DROP TABLE IF EXISTS `estoque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque` (
  `id_produto` int NOT NULL,
  `quantidade` int NOT NULL,
  `estoque_minimo` int NOT NULL,
  `atualizado_em` datetime NOT NULL,
  PRIMARY KEY (`id_produto`),
  CONSTRAINT `estoque_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id_produto`),
  CONSTRAINT `estoque_chk_1` CHECK ((`quantidade` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque`
--

LOCK TABLES `estoque` WRITE;
/*!40000 ALTER TABLE `estoque` DISABLE KEYS */;
INSERT INTO `estoque` VALUES (1,80,20,'2026-10-27 18:00:00'),(2,60,20,'2026-10-27 18:00:00'),(3,55,20,'2026-10-27 18:00:00'),(4,40,15,'2026-10-27 18:00:00'),(5,30,10,'2026-10-27 18:00:00'),(6,25,10,'2026-10-27 18:00:00'),(7,12,20,'2026-10-27 18:00:00'),(8,18,15,'2026-10-27 18:00:00'),(9,8,10,'2026-10-27 18:00:00'),(10,25,10,'2026-10-27 18:00:00'),(11,15,5,'2026-10-27 18:00:00'),(12,30,10,'2026-10-27 18:00:00');
/*!40000 ALTER TABLE `estoque` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `formas_pagamento`
--

DROP TABLE IF EXISTS `formas_pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formas_pagamento` (
  `id_forma_pagamento` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(30) NOT NULL,
  PRIMARY KEY (`id_forma_pagamento`),
  UNIQUE KEY `descricao` (`descricao`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formas_pagamento`
--

LOCK TABLES `formas_pagamento` WRITE;
/*!40000 ALTER TABLE `formas_pagamento` DISABLE KEYS */;
INSERT INTO `formas_pagamento` VALUES (3,'Cartão de Crédito'),(2,'Cartão de Débito'),(1,'Dinheiro'),(4,'Pix'),(5,'Vale-Refeição');
/*!40000 ALTER TABLE `formas_pagamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fornecedor_produto`
--

DROP TABLE IF EXISTS `fornecedor_produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fornecedor_produto` (
  `id_fornecedor` int NOT NULL,
  `id_produto` int NOT NULL,
  `preco_custo` decimal(8,2) NOT NULL,
  PRIMARY KEY (`id_fornecedor`,`id_produto`),
  KEY `id_produto` (`id_produto`),
  CONSTRAINT `fornecedor_produto_ibfk_1` FOREIGN KEY (`id_fornecedor`) REFERENCES `fornecedores` (`id_fornecedor`),
  CONSTRAINT `fornecedor_produto_ibfk_2` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id_produto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fornecedor_produto`
--

LOCK TABLES `fornecedor_produto` WRITE;
/*!40000 ALTER TABLE `fornecedor_produto` DISABLE KEYS */;
INSERT INTO `fornecedor_produto` VALUES (1,1,2.50),(1,2,4.80),(1,11,22.00),(2,2,5.00),(2,3,5.50),(2,4,6.00),(3,7,2.50),(3,8,5.00),(4,9,4.00),(4,10,4.50),(4,12,3.00),(5,5,6.00),(5,6,3.00);
/*!40000 ALTER TABLE `fornecedor_produto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fornecedores`
--

DROP TABLE IF EXISTS `fornecedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fornecedores` (
  `id_fornecedor` int NOT NULL AUTO_INCREMENT,
  `razao_social` varchar(100) NOT NULL,
  `cnpj` char(14) NOT NULL,
  `telefone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_fornecedor`),
  UNIQUE KEY `cnpj` (`cnpj`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fornecedores`
--

LOCK TABLES `fornecedores` WRITE;
/*!40000 ALTER TABLE `fornecedores` DISABLE KEYS */;
INSERT INTO `fornecedores` VALUES (1,'Café Serra Alta Ltda','11222333000181','1133334444','contato@serraalta.com.br'),(2,'Laticínios Vale Verde S/A','22333444000172','1144445555','vendas@valeverde.com.br'),(3,'Padaria Pão Quente ME','33444555000163','1155556666','pedidos@paoquente.com.br'),(4,'Doces & Cia Ltda','44555666000154','1166667777','comercial@docesecia.com.br'),(5,'Distribuidora Gelo Norte','55666777000145','1177778888','atendimento@gelonorte.com.br');
/*!40000 ALTER TABLE `fornecedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `funcionarios`
--

DROP TABLE IF EXISTS `funcionarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `funcionarios` (
  `id_funcionario` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `cpf` char(11) NOT NULL,
  `cargo` varchar(40) NOT NULL,
  `salario` decimal(8,2) NOT NULL,
  `data_admissao` date NOT NULL,
  PRIMARY KEY (`id_funcionario`),
  UNIQUE KEY `cpf` (`cpf`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `funcionarios`
--

LOCK TABLES `funcionarios` WRITE;
/*!40000 ALTER TABLE `funcionarios` DISABLE KEYS */;
INSERT INTO `funcionarios` VALUES (1,'Fernanda Lima','11122233344','Gerente',5500.00,'2023-03-01'),(2,'Rafael Mendes','22233344455','Barista',2800.00,'2024-01-15'),(3,'Juliana Rocha','33344455566','Barista',2800.00,'2024-06-10'),(4,'Lucas Almeida','44455566677','Atendente',2200.00,'2025-02-03'),(5,'Camila Duarte','55566677788','Atendente',2200.00,'2025-09-01'),(6,'Bruno Ferreira','66677788899','Auxiliar de Cozinha',2100.00,'2026-01-20');
/*!40000 ALTER TABLE `funcionarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itens_pedido`
--

DROP TABLE IF EXISTS `itens_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `itens_pedido` (
  `id_pedido` int NOT NULL,
  `id_produto` int NOT NULL,
  `quantidade` int NOT NULL,
  `preco_unitario` decimal(8,2) NOT NULL,
  PRIMARY KEY (`id_pedido`,`id_produto`),
  KEY `id_produto` (`id_produto`),
  CONSTRAINT `itens_pedido_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`),
  CONSTRAINT `itens_pedido_ibfk_2` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id_produto`),
  CONSTRAINT `itens_pedido_chk_1` CHECK ((`quantidade` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itens_pedido`
--

LOCK TABLES `itens_pedido` WRITE;
/*!40000 ALTER TABLE `itens_pedido` DISABLE KEYS */;
INSERT INTO `itens_pedido` VALUES (1,2,1,12.00),(1,7,2,7.00),(2,3,2,13.00),(2,9,1,10.00),(3,1,1,6.00),(3,7,1,7.00),(4,2,2,12.00),(4,8,1,12.00),(4,10,1,9.50),(5,2,1,12.00),(5,7,1,7.00),(6,5,2,16.00),(6,12,2,8.00),(7,6,1,9.00),(7,8,1,12.00),(8,4,1,14.00),(8,9,1,10.00),(9,3,1,13.00),(9,7,2,7.00),(10,1,2,6.00),(10,11,1,38.00),(11,2,2,12.00),(11,10,1,9.50),(12,5,1,16.00),(12,8,1,12.00),(12,12,1,8.00);
/*!40000 ALTER TABLE `itens_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `id_pedido` int NOT NULL AUTO_INCREMENT,
  `data_pedido` datetime NOT NULL,
  `id_cliente` int DEFAULT NULL,
  `id_funcionario` int NOT NULL,
  `id_forma_pagamento` int NOT NULL,
  PRIMARY KEY (`id_pedido`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_funcionario` (`id_funcionario`),
  KEY `id_forma_pagamento` (`id_forma_pagamento`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  CONSTRAINT `pedidos_ibfk_2` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionarios` (`id_funcionario`),
  CONSTRAINT `pedidos_ibfk_3` FOREIGN KEY (`id_forma_pagamento`) REFERENCES `formas_pagamento` (`id_forma_pagamento`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,'2026-09-28 08:15:00',1,4,4),(2,'2026-10-01 09:30:00',2,4,3),(3,'2026-10-02 10:05:00',NULL,5,1),(4,'2026-10-05 14:20:00',3,4,2),(5,'2026-10-08 08:45:00',1,5,4),(6,'2026-10-12 16:10:00',4,5,3),(7,'2026-10-15 12:30:00',NULL,4,5),(8,'2026-10-18 15:00:00',5,5,4),(9,'2026-10-20 09:10:00',2,4,3),(10,'2026-10-22 17:45:00',6,5,2),(11,'2026-10-25 11:20:00',1,4,4),(12,'2026-10-27 13:00:00',3,5,3);
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos` (
  `id_produto` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(80) NOT NULL,
  `descricao` varchar(200) DEFAULT NULL,
  `preco` decimal(8,2) NOT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `id_categoria` int NOT NULL,
  PRIMARY KEY (`id_produto`),
  KEY `id_categoria` (`id_categoria`),
  CONSTRAINT `produtos_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`),
  CONSTRAINT `produtos_chk_1` CHECK ((`preco` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'Espresso','Café expresso tradicional 50 ml',6.00,1,1),(2,'Cappuccino','Espresso com leite vaporizado e espuma',12.00,1,1),(3,'Latte','Espresso com bastante leite vaporizado',13.00,1,1),(4,'Mocha','Espresso com chocolate e leite',14.00,1,1),(5,'Frappé de Caramelo','Bebida gelada batida com caramelo',16.00,1,2),(6,'Chá Gelado de Limão','Chá preto com limão siciliano',9.00,1,2),(7,'Pão de Queijo','Porção com 3 unidades',7.00,1,3),(8,'Croissant de Presunto e Queijo','Croissant folhado recheado',12.00,1,3),(9,'Bolo de Cenoura','Fatia com cobertura de chocolate',10.00,1,4),(10,'Brownie','Brownie de chocolate meio amargo',9.50,1,4),(11,'Café em Grãos 250g','Pacote de grãos torrados, arábica',38.00,1,5),(12,'Cookie de Chocolate','Cookie com gotas de chocolate',8.00,1,4);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-28 11:06:02
