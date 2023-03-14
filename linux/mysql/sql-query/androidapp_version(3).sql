-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 03, 2023 at 11:04 AM
-- Server version: 5.5.53
-- PHP Version: 5.5.38

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_amazon`
--

-- --------------------------------------------------------

--
-- Table structure for table `androidapp_version`
--

CREATE TABLE `androidapp_version` (
  `ver_id` int(11) NOT NULL,
  `app_name` varchar(25) NOT NULL,
  `version_no` varchar(25) NOT NULL,
  `update_date` varchar(50) NOT NULL,
  `status` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `androidapp_version`
--

INSERT INTO `androidapp_version` (`ver_id`, `app_name`, `version_no`, `update_date`, `status`) VALUES
(1, 'RADIANT', '1.0', '2022-11-07', 'Y');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `androidapp_version`
--
ALTER TABLE `androidapp_version`
  ADD PRIMARY KEY (`ver_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `androidapp_version`
--
ALTER TABLE `androidapp_version`
  MODIFY `ver_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
