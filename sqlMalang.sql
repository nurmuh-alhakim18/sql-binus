-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 20, 2021 at 06:21 PM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.2.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sqlMalang`
--

-- --------------------------------------------------------

--
-- Table structure for table `kampus`
--

CREATE TABLE `kampus` (
  `idKampus` char(5) NOT NULL,
  `namaKampus` varchar(50) DEFAULT NULL,
  `alamatKampus` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `kampus`
--

INSERT INTO `kampus` (`idKampus`, `namaKampus`, `alamatKampus`) VALUES
('00001', 'Kampus BINUS Malang', 'Perumahan Araya'),
('00002', 'Kampus BINUS Kemanggisan', 'Kebon Jeruk'),
('00003', 'Kampus BINUS FX', 'Mall FX'),
('00004', 'Kampus BINUS JWC', 'Senayan');

-- --------------------------------------------------------

--
-- Table structure for table `mahasiswa`
--

CREATE TABLE `mahasiswa` (
  `binusianID` char(10) NOT NULL,
  `namaDepan` varchar(50) NOT NULL,
  `namaBelakang` varchar(50) NOT NULL,
  `kampusID` char(5) NOT NULL,
  `IPK` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `mahasiswa`
--

INSERT INTO `mahasiswa` (`binusianID`, `namaDepan`, `namaBelakang`, `kampusID`, `IPK`) VALUES
('0900902291', 'Budi', 'Komar', '00002', 3.88),
('0900902893', 'Chacha', 'Wilmoz', '00004', 3.59),
('0900909291', 'Handi', 'Purmono', '00002', 3.83),
('0900909331', 'Mei', 'liana', '00002', 3.23),
('0900909332', 'Toni', 'Sutoyo', '00005', 2.43),
('0900909821', 'Tono', 'Jaja', '00001', 3.99),
('0900909891', 'Anto', 'Budiman', '00001', 3.49),
('0900909892', 'Claire', 'Cantika', '00003', 3.43),
('0900909893', 'Clara', 'Purmono', '00004', 3.33),
('0900909894', 'Kevin', 'Bacon', '00004', 2.43),
('0900909895', 'Karen', 'Ame', '00003', 2.43),
('0900909896', 'Dwi', 'Januar', '00001', 1.43),
('0900909897', 'Dewi', 'Wiliam', '00003', 4),
('0900909898', 'Chairul', 'Wijaya', '00002', 4),
('0900929391', 'Juni', 'Jani', '00001', 3.23),
('0900929892', 'Chica', 'Chacha', '00005', 3.3);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `kampus`
--
ALTER TABLE `kampus`
  ADD PRIMARY KEY (`idKampus`);

--
-- Indexes for table `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD PRIMARY KEY (`binusianID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
