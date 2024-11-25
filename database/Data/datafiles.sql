-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: books
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Table structure for table `authors`
--

DROP TABLE IF EXISTS `authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `birth_year` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authors`
--

LOCK TABLES `authors` WRITE;
/*!40000 ALTER TABLE `authors` DISABLE KEYS */;
INSERT INTO `authors` VALUES (2,'George R.R. Martin',1948),(3,'J.R.R. Tolkien',1892),(4,'Agatha Christie',1890),(5,'Stephen King',1947),(6,'Mark Twain',1835),(7,'Jane Austen',1775),(8,'Charles Dickens',1812),(9,'F. Scott Fitzgerald',1896),(10,'Ernest Hemingway',1899),(11,'Isaac Asimov',1920),(12,'Ray Bradbury',1920),(13,'H.G. Wells',1866),(14,'Leo Tolstoy',1828),(15,'Virginia Woolf',1882),(16,'Gabriel Garcia Marquez',1927),(17,'Harper Lee',1926),(18,'Toni Morrison',1931),(19,'Kurt Vonnegut',1922),(20,'C.S. Lewis',1898),(21,'Margaret Atwood',1939),(22,'Neil Gaiman',1960),(23,'Philip K. Dick',1928),(24,'John Steinbeck',1902),(25,'Dante Alighieri',1265),(26,'Herman Melville',1819),(27,'Oscar Wilde',1854),(28,'Chinua Achebe',1930),(29,'Maya Angelou',1928),(30,'David Foster Wallace',1962),(31,'Christian Uanan',2003),(32,'Andrei Sta. Rosa',2003);
/*!40000 ALTER TABLE `authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `author_id` int DEFAULT NULL,
  `published_year` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `author_id` (`author_id`),
  CONSTRAINT `books_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (4,'A Game of Thrones',2,1996),(5,'A Clash of Kings',2,1998),(6,'A Storm of Swords',2,2000),(7,'The Hobbit',3,1937),(8,'The Lord of the Rings: The Fellowship of the Ring',3,1954),(9,'Murder on the Orient Express',4,1934),(10,'And Then There Were None',4,1939),(11,'The Shining',5,1977),(12,'It',5,1986),(13,'The Adventures of Tom Sawyer',6,1876),(14,'Pride and Prejudice',7,1813),(15,'Great Expectations',8,1860),(16,'The Great Gatsby',9,1925),(17,'For Whom the Bell Tolls',10,1940),(18,'Foundation',11,1951),(19,'Fahrenheit 451',12,1953),(20,'The Time Machine',13,1895),(21,'War and Peace',14,1869),(22,'Mrs. Dalloway',15,1925),(23,'One Hundred Years of Solitude',16,1967),(24,'To Kill a Mockingbird',17,1960),(25,'Beloved',18,1987),(26,'Slaughterhouse-Five',19,1969),(27,'The Chronicles of Narnia: The Lion, the Witch and the Wardrobe',20,1950),(28,'The Handmaid\'s Tale',21,1985),(29,'American Gods',22,2001),(30,'Do Androids Dream of Electric Sheep?',23,1968),(31,'East of Eden',24,1952),(32,'The Divine Comedy',25,1320),(33,'Moby-Dick',26,1851),(34,'The Picture of Dorian Gray',27,1890),(35,'Things Fall Apart',28,1958),(36,'I Know Why the Caged Bird Sings',29,1969),(37,'Infinite Jest',30,1996);
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `borrowedbooks`
--

DROP TABLE IF EXISTS `borrowedbooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `borrowedbooks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `borrower_id` int DEFAULT NULL,
  `book_id` int DEFAULT NULL,
  `borrow_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `borrower_id` (`borrower_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `borrowedbooks_ibfk_1` FOREIGN KEY (`borrower_id`) REFERENCES `borrowers` (`id`),
  CONSTRAINT `borrowedbooks_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `borrowedbooks`
--

LOCK TABLES `borrowedbooks` WRITE;
/*!40000 ALTER TABLE `borrowedbooks` DISABLE KEYS */;
INSERT INTO `borrowedbooks` VALUES (2,1,4,'2024-11-25'),(3,1,13,'2024-11-26');
/*!40000 ALTER TABLE `borrowedbooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `borrowers`
--

DROP TABLE IF EXISTS `borrowers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `borrowers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `contact_info` varchar(255) DEFAULT NULL,
  `borrowed_book` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `borrowed_book` (`borrowed_book`),
  CONSTRAINT `borrowers_ibfk_1` FOREIGN KEY (`borrowed_book`) REFERENCES `books` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `borrowers`
--

LOCK TABLES `borrowers` WRITE;
/*!40000 ALTER TABLE `borrowers` DISABLE KEYS */;
INSERT INTO `borrowers` VALUES (1,'Daniel Garcia','123 123 123',NULL);
/*!40000 ALTER TABLE `borrowers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-25 15:08:24
