-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: 127.0.0.1    Database: tugas_bi
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `anggota`
--

DROP TABLE IF EXISTS `anggota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anggota` (
  `id_anggota` int(3) NOT NULL AUTO_INCREMENT,
  `nim_anggota` varchar(32) NOT NULL,
  `alamat` text NOT NULL,
  `ttl_anggota` text NOT NULL,
  `status_anggota` varchar(1) NOT NULL,
  PRIMARY KEY (`id_anggota`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `anggota`
--

/*!40000 ALTER TABLE `anggota` DISABLE KEYS */;
INSERT INTO `anggota` VALUES (1,'2308378','Garut','Garut, 2005-09-24','Y'),(2,'2308948','Jakarta','Jakarta, 2000-02-22','Y'),(3,'2304565','Surabaya','Surabaya, 2000-03-10','Y'),(4,'2304535','Medan','Medan, 2000-04-18','Y'),(5,'2309493','Yogyakarta','Yogyakarta, 2000-05-05','Y'),(6,'2302334','Palembang','Palembang, 2000-06-30','Y'),(7,'2309859','Semarang','Semarang, 2000-07-15','Y'),(8,'2302312','Denpasar','Denpasar, 2000-08-25','N'),(9,'2305478','Makassar','Makassar, 2000-09-12','N'),(10,'2308345','Padang','Padang, 2000-10-01','N');
/*!40000 ALTER TABLE `anggota` ENABLE KEYS */;

--
-- Table structure for table `buku`
--

DROP TABLE IF EXISTS `buku`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `buku` (
  `kd_buku` int(5) NOT NULL AUTO_INCREMENT,
  `judul_buku` varchar(32) NOT NULL,
  `pengarang` varchar(32) NOT NULL,
  `jenis_buuku` varchar(32) NOT NULL,
  `penerbit` varchar(32) NOT NULL,
  PRIMARY KEY (`kd_buku`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buku`
--

/*!40000 ALTER TABLE `buku` DISABLE KEYS */;
INSERT INTO `buku` VALUES (1,'Belajar SQL','Andi Setiawan','Teknologi','Gramedia'),(2,'Pemrograman Web','Rina Hartati','Teknologi','Informatika'),(3,'Biologi Laut','Samuel Silaban','Sains','Ocean Press'),(4,'Fisika Dasar','Dedi Suhendra','Sains','Cerdas Publisher'),(5,'Matematika Lanjut','Sinta Dewi','Pendidikan','Eduka'),(6,'Bahasa Inggris','John Smith','Bahasa','Oxford'),(7,'Algoritma Pemrograman','Budi Santoso','Teknologi','Erlangga'),(8,'Ekologi Laut','Ahmad Fauzi','Sains','Maritim'),(9,'Pengantar AI','Lisa Adelia','Teknologi','Informatika'),(10,'Sistem Informasi','Slamet Riyadi','Teknologi','Andi Publisher');
/*!40000 ALTER TABLE `buku` ENABLE KEYS */;

--
-- Table structure for table `meminjam`
--

DROP TABLE IF EXISTS `meminjam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meminjam` (
  `id_pinjam` int(3) NOT NULL AUTO_INCREMENT,
  `tgl_pinjam` date NOT NULL,
  `jumlah_pinjam` int(2) DEFAULT NULL,
  `tgl_kembali` date NOT NULL,
  `anggota_id` int(3) NOT NULL,
  `kode_buku` int(5) NOT NULL,
  `kembali` int(1) NOT NULL,
  PRIMARY KEY (`id_pinjam`),
  KEY `fk_anggota` (`anggota_id`),
  KEY `fk_buku` (`kode_buku`),
  CONSTRAINT `fk_anggota` FOREIGN KEY (`anggota_id`) REFERENCES `anggota` (`id_anggota`),
  CONSTRAINT `fk_buku` FOREIGN KEY (`kode_buku`) REFERENCES `buku` (`kd_buku`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meminjam`
--

/*!40000 ALTER TABLE `meminjam` DISABLE KEYS */;
INSERT INTO `meminjam` VALUES (1,'2025-09-10',2,'2025-09-17',1,1,1),(2,'2025-09-10',1,'2025-09-17',1,2,1),(3,'2025-09-25',1,'2025-10-02',2,3,0),(4,'2025-08-15',1,'2025-08-22',3,4,1),(5,'2025-08-16',1,'2025-08-23',3,5,1),(6,'2025-08-17',1,'2025-08-24',3,6,1),(7,'2025-08-18',1,'2025-08-25',3,7,1),(8,'2025-10-08',1,'2025-10-15',4,8,0),(9,'2025-09-29',1,'2025-10-05',5,9,0),(10,'2025-08-01',1,'2025-08-08',6,10,1),(11,'2025-10-08',1,'2025-10-13',7,1,0);
/*!40000 ALTER TABLE `meminjam` ENABLE KEYS */;

--
-- Dumping routines for database 'tugas_bi'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-08 18:18:47
