-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Aug 24, 2023 at 02:02 AM
-- Server version: 10.3.38-MariaDB-0ubuntu0.20.04.1
-- PHP Version: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sisawit_db_v1`
--

-- --------------------------------------------------------

--
-- Table structure for table `bibit`
--

CREATE TABLE `bibit` (
  `id_bibit` int(11) NOT NULL,
  `varietas_bibit` varchar(255) NOT NULL,
  `jumlah_bibit` int(11) NOT NULL,
  `umur_bibit` int(11) NOT NULL,
  `kondisi_bibit` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ch`
--

CREATE TABLE `ch` (
  `thn` int(11) NOT NULL,
  `jan` int(11) NOT NULL,
  `feb` int(11) NOT NULL,
  `mar` int(11) NOT NULL,
  `apr` int(11) NOT NULL,
  `mei` int(11) NOT NULL,
  `jun` int(11) NOT NULL,
  `jul` int(11) NOT NULL,
  `agt` int(11) NOT NULL,
  `sep` int(11) NOT NULL,
  `okt` int(11) NOT NULL,
  `nov` int(11) NOT NULL,
  `des` int(11) NOT NULL,
  `akurasi` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `ch`
--

INSERT INTO `ch` (`thn`, `jan`, `feb`, `mar`, `apr`, `mei`, `jun`, `jul`, `agt`, `sep`, `okt`, `nov`, `des`, `akurasi`) VALUES
(2022, 235, 180, 139, 385, 209, 153, 176, 209, 122, 292, 346, 281, '100'),
(2023, 230, 201, 141, 355, 221, 179, 178, 186, 135, 308, 337, 278, '86.389'),
(2024, 230, 212, 146, 331, 229, 195, 178, 172, 143, 315, 330, 278, '89.953'),
(2025, 229, 227, 161, 290, 239, 189, 167, 153, 159, 309, 323, 261, '78.931');

-- --------------------------------------------------------

--
-- Table structure for table `kebun`
--

CREATE TABLE `kebun` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `kode_kebun` varchar(100) NOT NULL,
  `luas` int(11) NOT NULL,
  `usia` varchar(100) NOT NULL,
  `jenis_tanah` varchar(255) NOT NULL,
  `desa` varchar(255) NOT NULL,
  `kec` varchar(255) NOT NULL,
  `kab` varchar(255) NOT NULL,
  `sph` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kebun`
--

INSERT INTO `kebun` (`id`, `nama`, `kode_kebun`, `luas`, `usia`, `jenis_tanah`, `desa`, `kec`, `kab`, `sph`) VALUES
(1, 'Kebun 1', 'K1', 66300, '1998', 'Mineral', 'Sei Kuning', 'Tandun', 'Rokan Hulu', 776),
(2, 'Kebun 2', 'K2', 47172, '2006', 'Mineral', 'Lubuk Bendahara', 'Rokan IV Koto', 'Rokan Hulu', 552),
(3, 'Kebun 3', 'K3', 20200, '2004', 'Mineral', 'Lubuk Bendahara', 'Rokan IV Koto', 'Rokan Hulu', 236),
(4, 'Kebun 5', 'K5', 148000, '2000', 'Mineral', 'Lubuk Bendahara', 'Rokan IV Koto', 'Rokan Hulu', 1732),
(5, 'Kebun 24', 'K24', 240000, '1998', 'Mineral', 'Tandun', 'Tandun', 'Rokan Hulu', 2652);

-- --------------------------------------------------------

--
-- Table structure for table `panen`
--

CREATE TABLE `panen` (
  `id_panen` int(11) NOT NULL,
  `id_kebun` int(11) NOT NULL,
  `tanggal_panen` varchar(255) NOT NULL,
  `jumlah_panen` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pemupukan`
--

CREATE TABLE `pemupukan` (
  `id_pemupukan` int(11) NOT NULL,
  `id_kebun` int(11) NOT NULL,
  `id_pupuk` int(11) NOT NULL,
  `tanggal_mulai` varchar(255) NOT NULL,
  `tanggal_selesai` varchar(255) NOT NULL DEFAULT '-',
  `dosis` int(11) NOT NULL,
  `status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pemupukan`
--

INSERT INTO `pemupukan` (`id_pemupukan`, `id_kebun`, `id_pupuk`, `tanggal_mulai`, `tanggal_selesai`, `dosis`, `status`) VALUES
(1, 1, 4, 'Selasa, 20 Juni 2023', 'Selasa, 15 Agustus 2023', 1230, 'Sudah Selesai'),
(2, 2, 2, 'Rabu, 21 Juni 2023', 'Rabu, 16 Agustus 2023', 5000, 'Sudah Selesai'),
(8, 3, 2, 'Rabu, 16 Agustus 2023', 'Rabu, 16 Agustus 2023', 250, 'Dibatalkan'),
(9, 4, 2, 'Rabu, 16 Agustus 2023', 'Jumat, 18 Agustus 2023', 1000, 'Dalam Proses'),
(10, 5, 4, 'Kamis, 17 Agustus 2023', 'Jumat, 18 Agustus 2023', 1500, 'Sudah Selesai'),
(11, 3, 3, 'Rabu, 23 Agustus 2023', 'Kamis, 24 Agustus 2023', 124, 'Belum Dipupuk'),
(12, 4, 3, 'Rabu, 23 Agustus 2023', '-', 222, 'Belum Dipupuk');

-- --------------------------------------------------------

--
-- Table structure for table `pohon`
--

CREATE TABLE `pohon` (
  `id_pohon` int(11) NOT NULL,
  `id_kebun` int(11) NOT NULL,
  `banyak_tandan` int(11) NOT NULL,
  `tandan_mentah` int(11) NOT NULL,
  `tandan_matang` int(11) NOT NULL,
  `tandan_segera_matang` int(11) NOT NULL,
  `kondisi_daun` varchar(255) NOT NULL,
  `kondisi_batang` varchar(255) NOT NULL,
  `tanggal_pemeriksaan` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pupuk`
--

CREATE TABLE `pupuk` (
  `id_pupuk` int(11) NOT NULL,
  `nama_pupuk` varchar(255) NOT NULL,
  `harga` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pupuk`
--

INSERT INTO `pupuk` (`id_pupuk`, `nama_pupuk`, `harga`) VALUES
(1, 'Urea', 16000),
(2, 'SP-36', 15000),
(3, 'MOP', 20000),
(4, 'Kieserite', 13000),
(5, 'NPK', 25000);

-- --------------------------------------------------------

--
-- Table structure for table `tanam`
--

CREATE TABLE `tanam` (
  `id_tanam` int(11) NOT NULL,
  `id_bibit` int(11) NOT NULL,
  `id_kebun` int(11) NOT NULL,
  `tanggal_tanam` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` varchar(255) NOT NULL,
  `level` varchar(100) NOT NULL DEFAULT 'spv'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `email`, `password`, `created_at`, `level`) VALUES
(1, 'Owner', 'owner@gmail.com', 'owner123', '18-02-2023', 'owner'),
(2, 'admin', 'admin@gmail.com', 'admin123', '18-02-2023', 'owner'),
(3, 'spv1', 'spv1@gmail.com', 'spv123', '18-02-2023', 'spv'),
(5, 'tes1', 'tes1@gmail.com', 'tes111', '16-06-2023', 'spv'),
(12, 'yuda', 'yuda@gmail.com', 'yuda', '10-08-2023', 'spv');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bibit`
--
ALTER TABLE `bibit`
  ADD PRIMARY KEY (`id_bibit`);

--
-- Indexes for table `kebun`
--
ALTER TABLE `kebun`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `panen`
--
ALTER TABLE `panen`
  ADD PRIMARY KEY (`id_panen`),
  ADD KEY `kebun_pnn` (`id_kebun`);

--
-- Indexes for table `pemupukan`
--
ALTER TABLE `pemupukan`
  ADD PRIMARY KEY (`id_pemupukan`),
  ADD KEY `kebun_pmpk` (`id_kebun`),
  ADD KEY `pupuk_pmpk` (`id_pupuk`);

--
-- Indexes for table `pohon`
--
ALTER TABLE `pohon`
  ADD PRIMARY KEY (`id_pohon`),
  ADD KEY `kebun_phn` (`id_kebun`);

--
-- Indexes for table `pupuk`
--
ALTER TABLE `pupuk`
  ADD PRIMARY KEY (`id_pupuk`);

--
-- Indexes for table `tanam`
--
ALTER TABLE `tanam`
  ADD PRIMARY KEY (`id_tanam`),
  ADD KEY `kebun_tnm` (`id_kebun`),
  ADD KEY `bibit_tnm` (`id_bibit`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bibit`
--
ALTER TABLE `bibit`
  MODIFY `id_bibit` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kebun`
--
ALTER TABLE `kebun`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `panen`
--
ALTER TABLE `panen`
  MODIFY `id_panen` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pemupukan`
--
ALTER TABLE `pemupukan`
  MODIFY `id_pemupukan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `pohon`
--
ALTER TABLE `pohon`
  MODIFY `id_pohon` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pupuk`
--
ALTER TABLE `pupuk`
  MODIFY `id_pupuk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tanam`
--
ALTER TABLE `tanam`
  MODIFY `id_tanam` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `panen`
--
ALTER TABLE `panen`
  ADD CONSTRAINT `kebun_pnn` FOREIGN KEY (`id_kebun`) REFERENCES `kebun` (`id`);

--
-- Constraints for table `pemupukan`
--
ALTER TABLE `pemupukan`
  ADD CONSTRAINT `kebun_pmpk` FOREIGN KEY (`id_kebun`) REFERENCES `kebun` (`id`),
  ADD CONSTRAINT `pupuk_pmpk` FOREIGN KEY (`id_pupuk`) REFERENCES `pupuk` (`id_pupuk`);

--
-- Constraints for table `pohon`
--
ALTER TABLE `pohon`
  ADD CONSTRAINT `kebun_phn` FOREIGN KEY (`id_kebun`) REFERENCES `kebun` (`id`);

--
-- Constraints for table `tanam`
--
ALTER TABLE `tanam`
  ADD CONSTRAINT `bibit_tnm` FOREIGN KEY (`id_bibit`) REFERENCES `bibit` (`id_bibit`),
  ADD CONSTRAINT `kebun_tnm` FOREIGN KEY (`id_kebun`) REFERENCES `kebun` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
