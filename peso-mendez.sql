-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Oct 21, 2025 at 01:27 PM
-- Server version: 9.1.0
-- PHP Version: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `peso_mendez`
--

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
CREATE TABLE IF NOT EXISTS `announcements` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `content` text COLLATE utf8mb4_general_ci NOT NULL,
  `posted_on` datetime DEFAULT CURRENT_TIMESTAMP,
  `target_audience` enum('all','job_seeker','employer','admin') COLLATE utf8mb4_general_ci DEFAULT 'all',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `announcements`
--

INSERT INTO `announcements` (`id`, `title`, `content`, `posted_on`, `target_audience`) VALUES
(1, 'try', 'try', '2025-09-17 21:20:00', 'all'),
(2, 'jience', 'ence c', '2025-09-23 19:51:41', 'admin'),
(3, 'Hello', 'Hello', '2025-10-05 16:35:24', 'admin'),
(4, 'TESTING', 'TESTING', '2025-10-14 15:21:45', 'admin'),
(5, 'JOB SEEKER1', 'JOB SEEKER1', '2025-10-14 15:58:20', 'job_seeker'),
(6, 'EMPLOYER1', 'EMPLOYER1', '2025-10-14 16:01:59', 'employer'),
(7, 'JOBSEEKERANNOUNCEMENT1', 'JOBSEEKERANNOUNCEMENT1', '2025-10-20 14:21:08', 'job_seeker'),
(8, 'EMPLOYERANNOUNCEMENT1', 'EMPLOYERANNOUNCEMENT1', '2025-10-20 14:24:31', 'employer'),
(9, 'EMPLOYERANNOUNCEMENT2', 'EMPLOYERANNOUNCEMENT2', '2025-10-20 14:25:48', 'employer'),
(10, 'JOBSEEKERANNOUNCEMENT2', 'JOBSEEKERANNOUNCEMENT2', '2025-10-20 14:26:31', 'job_seeker'),
(11, 'JOBSEEKERANNOUNCEMENT3', 'JOBSEEKERANNOUNCEMENT3', '2025-10-20 14:27:26', 'job_seeker'),
(12, 'ANNOUNCEMENT1', 'ANNOUNCEMENT1', '2025-10-20 14:28:13', 'employer');

-- --------------------------------------------------------

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
CREATE TABLE IF NOT EXISTS `applications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `job_id` int NOT NULL,
  `job_seeker_id` int NOT NULL,
  `status` enum('Sent','Reviewed','Interview','Rejected','Hired') COLLATE utf8mb4_general_ci DEFAULT 'Sent',
  `applied_on` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_applications_job` (`job_id`),
  KEY `fk_applications_user` (`job_seeker_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `applications`
--

INSERT INTO `applications` (`id`, `job_id`, `job_seeker_id`, `status`, `applied_on`) VALUES
(4, 36, 38, 'Sent', '2025-09-17 21:15:44'),
(5, 37, 38, 'Sent', '2025-09-17 21:17:20'),
(6, 9, 39, 'Sent', '2025-09-23 19:59:06'),
(7, 76, 39, 'Interview', '2025-09-23 20:06:08'),
(8, 77, 39, 'Hired', '2025-09-30 22:24:34'),
(27, 77, 43, 'Reviewed', '2025-10-07 21:04:00'),
(28, 76, 43, 'Reviewed', '2025-10-07 21:13:52'),
(29, 37, 43, 'Sent', '2025-10-07 21:13:59'),
(30, 36, 43, 'Sent', '2025-10-07 21:14:05');

-- --------------------------------------------------------

--
-- Table structure for table `conversations`
--

DROP TABLE IF EXISTS `conversations`;
CREATE TABLE IF NOT EXISTS `conversations` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_a` int NOT NULL,
  `user_b` int NOT NULL,
  `latest_message` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_conversation_pair` (`user_a`,`user_b`),
  KEY `fk_conversation_user_b` (`user_b`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `conversations`
--

INSERT INTO `conversations` (`id`, `user_a`, `user_b`, `latest_message`, `created_at`, `updated_at`) VALUES
(8, 43, 40, 'Hello Worlds 2', '2025-10-20 16:24:19', '2025-10-20 16:24:43');

-- --------------------------------------------------------

--
-- Table structure for table `educational_backgrounds`
--

DROP TABLE IF EXISTS `educational_backgrounds`;
CREATE TABLE IF NOT EXISTS `educational_backgrounds` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `elem_year_grad` varchar(50) DEFAULT NULL,
  `elem_level_reached` varchar(100) DEFAULT NULL,
  `elem_year_last_attended` varchar(50) DEFAULT NULL,
  `seco_year_grad` varchar(50) DEFAULT NULL,
  `seco_level_reached` varchar(100) DEFAULT NULL,
  `seco_year_last_attended` varchar(50) DEFAULT NULL,
  `ter_course` varchar(150) DEFAULT NULL,
  `ter_year_grad` varchar(50) DEFAULT NULL,
  `ter_level_reached` varchar(100) DEFAULT NULL,
  `ter_year_last_attended` varchar(50) DEFAULT NULL,
  `gs_course` varchar(150) DEFAULT NULL,
  `gs_year_grad` varchar(50) DEFAULT NULL,
  `gs_level_reached` varchar(100) DEFAULT NULL,
  `gs_year_last_attended` varchar(50) DEFAULT NULL,
  `is_kto12` tinyint(1) DEFAULT '0',
  `shs_strand` varchar(150) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_user` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `educational_backgrounds`
--

INSERT INTO `educational_backgrounds` (`id`, `user_id`, `elem_year_grad`, `elem_level_reached`, `elem_year_last_attended`, `seco_year_grad`, `seco_level_reached`, `seco_year_last_attended`, `ter_course`, `ter_year_grad`, `ter_level_reached`, `ter_year_last_attended`, `gs_course`, `gs_year_grad`, `gs_level_reached`, `gs_year_last_attended`, `is_kto12`, `shs_strand`, `created_at`, `updated_at`) VALUES
(1, 30, '2016', '', '', '2020', '', '', 'Bachelor of Science in Information Technology', '2026', '', '', '', '', '', '', 1, 'STEM', '2025-08-20 06:23:25', '2025-08-20 06:23:25'),
(2, 30, '2016', '', '', '2020', '', '', 'Bachelor of Science in Information Technology', '2026', '', '', '', '', '', '', 1, 'STEM', '2025-08-20 06:27:38', '2025-08-20 06:27:38'),
(3, 30, 'cwrver', 'errcre', 'fwrrefrwef', 'rfeg', 'ervgegv', 'erve', 'efegf', 'gfegfe', 'evev', 'erveg', '', '', '', '', 1, 'wferfe', '2025-08-20 10:57:09', '2025-08-20 10:57:09'),
(4, 30, 'vef', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, '', '2025-08-21 02:17:52', '2025-08-21 02:17:52'),
(5, 30, 'v', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, '', '2025-08-21 02:32:27', '2025-08-21 02:32:27'),
(6, 30, '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, '', '2025-08-21 07:11:58', '2025-08-21 07:11:58'),
(7, 30, '2016', '', '', '2020', '', '', 'BSIT', '2026', '', '', '', '', '', '', 1, 'STEM', '2025-08-21 14:35:24', '2025-08-21 14:35:24'),
(8, 36, '2020', '', '', 'trbrhyr', '', '', '', '', '', '', '', '', '', '', 1, 'hunet', '2025-09-06 15:26:39', '2025-09-06 15:26:39'),
(9, 37, '2016', '', '', '2022', '', '', 'BSIT', '2026', '', '', '', '', '', '', 1, 'STEM', '2025-09-17 13:08:11', '2025-09-17 13:08:11'),
(10, 39, '2016', '', '', '2022', '', '', '2025', '2026', '', '', 'BSIT2026', '', '', '', 1, 'STEM', '2025-09-23 11:56:50', '2025-09-23 11:56:50'),
(11, 43, '2018', '', '', '2024', '', '', 'Bachelor of Science in Tourism Management', 'Not Gradueted yet', '', '', '', '', '', '', 1, 'STEM', '2025-10-04 07:10:25', '2025-10-04 07:10:25'),
(12, 49, '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, '', '2025-10-10 13:00:36', '2025-10-10 13:00:36');

-- --------------------------------------------------------

--
-- Table structure for table `eligibilities`
--

DROP TABLE IF EXISTS `eligibilities`;
CREATE TABLE IF NOT EXISTS `eligibilities` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `eligibility` varchar(255) DEFAULT NULL,
  `date_taken` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_eligibilities_user` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `eligibilities`
--

INSERT INTO `eligibilities` (`id`, `user_id`, `eligibility`, `date_taken`, `created_at`, `updated_at`) VALUES
(1, 30, 'Civil Service 1', '2020-09-07', '2025-08-21 02:45:48', '2025-08-21 02:45:48'),
(2, 30, '', '0000-00-00', '2025-08-21 02:45:49', '2025-08-21 02:45:49'),
(3, 30, 'Civil Service 1', '2020-09-07', '2025-08-21 03:08:05', '2025-08-21 03:08:05'),
(4, 30, '', '0000-00-00', '2025-08-21 03:08:05', '2025-08-21 03:08:05'),
(5, 30, 'Civil Service 1', '2020-09-07', '2025-08-21 03:08:45', '2025-08-21 03:08:45'),
(6, 30, '', '0000-00-00', '2025-08-21 03:08:46', '2025-08-21 03:08:46'),
(7, 30, '', '0000-00-00', '2025-08-21 07:12:08', '2025-08-21 07:12:08'),
(8, 30, '', '0000-00-00', '2025-08-21 07:12:09', '2025-08-21 07:12:09'),
(9, 30, '', '0000-00-00', '2025-08-21 14:35:36', '2025-08-21 14:35:36'),
(10, 30, '', '0000-00-00', '2025-08-21 14:35:37', '2025-08-21 14:35:37'),
(11, 36, '', '0000-00-00', '2025-09-06 15:26:51', '2025-09-06 15:26:51'),
(12, 36, '', '0000-00-00', '2025-09-06 15:26:51', '2025-09-06 15:26:51'),
(13, 37, '', '0000-00-00', '2025-09-17 13:08:24', '2025-09-17 13:08:24'),
(14, 37, '', '0000-00-00', '2025-09-17 13:08:24', '2025-09-17 13:08:24'),
(15, 39, '', '0000-00-00', '2025-09-23 11:57:02', '2025-09-23 11:57:02'),
(16, 39, '', '0000-00-00', '2025-09-23 11:57:02', '2025-09-23 11:57:02'),
(17, 43, 'Civil Service', '2024-11-29', '2025-10-04 07:14:22', '2025-10-08 17:14:23'),
(18, 43, 'Civil Service 2', '2023-09-06', '2025-10-04 07:14:22', '2025-10-08 17:14:23'),
(19, 49, '', '0000-00-00', '2025-10-10 13:00:50', '2025-10-10 13:00:50'),
(20, 49, '', '0000-00-00', '2025-10-10 13:00:50', '2025-10-10 13:00:50');

-- --------------------------------------------------------

--
-- Table structure for table `employer_verification`
--

DROP TABLE IF EXISTS `employer_verification`;
CREATE TABLE IF NOT EXISTS `employer_verification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employer_id` int NOT NULL,
  `documents` text COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_general_ci DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `employer_id` (`employer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employer_verification`
--

INSERT INTO `employer_verification` (`id`, `employer_id`, `documents`, `status`, `created_at`) VALUES
(20, 40, 'uploads/employer-documents/reviewerdaw_1760675240674_941413303.pdf', 'pending', '2025-10-17 04:27:20');

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
CREATE TABLE IF NOT EXISTS `events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `event_date` date NOT NULL,
  `type` enum('job fair','training') COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `company` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `location` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `salary` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `posted_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `employer_id` int NOT NULL,
  `visibility` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Lite',
  `status` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jobs`
--

INSERT INTO `jobs` (`id`, `title`, `company`, `location`, `salary`, `type`, `description`, `posted_on`, `employer_id`, `visibility`, `status`) VALUES
(1, 'Cashier', 'Jollibee Mendez', 'Mendez, Cavite', '₱12,000/month', 'Full-Time', 'Handle cashier duties and customer service.', '2025-05-21 01:10:54', 9, 'Lite', 'active'),
(2, 'Customer Service Representative', 'PLDT Mendez', 'Mendez, Cavite', '₱15,000/month', 'Full-Time', 'Assist customers with inquiries and complaints.', '2025-05-21 01:10:54', 9, 'Lite', 'active'),
(3, 'Barangay Health Worker', 'Mendez Health Office', 'Mendez, Cavite', '₱10,000/month', 'Part-Time', 'Provide health services and assist in community health programs.', '2025-05-21 01:10:54', 9, 'Lite', 'active'),
(4, 'Sales Associate', 'SM Mendez', 'Mendez, Cavite', '₱13,000/month', 'Full-Time', 'Manage sales floor and assist customers.', '2025-05-21 01:10:54', 9, 'Lite', 'active'),
(6, 'Teacher Assistant', 'Mendez Elementary School', 'Mendez, Cavite', '₱11,000/month', 'Part-Time', 'Assist teachers with classroom activities.', '2025-05-21 01:10:54', 9, 'Lite', 'active'),
(7, 'Waiter', 'McDonald\'s Mendez', 'Mendez, Cavite', '₱10,000/month', 'Full-Time', 'Serving customers in a fast food environment.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(8, 'Delivery Driver', 'LBC Express', 'Mendez, Cavite', '₱15,000/month', 'Full-Time', 'Deliver parcels and documents in the local area.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(9, 'Security Guard', 'Mendez Security Agency', 'Mendez, Cavite', '₱9,000/month', 'Full-Time', 'Maintain safety and security of assigned premises.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(10, 'Receptionist', 'Mendez Dental Clinic', 'Mendez, Cavite', '₱11,000/month', 'Full-Time', 'Manage appointments and client inquiries.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(11, 'Graphic Designer', 'Creative Studio', 'Mendez, Cavite', '₱18,000/month', 'Part-Time', 'Design marketing materials and social media graphics.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(12, 'Cashier', '7-Eleven Mendez', 'Mendez, Cavite', '₱10,500/month', 'Full-Time', 'Handle cash transactions and customer service.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(13, 'Housekeeper', 'Mendez Hotel', 'Mendez, Cavite', '₱8,000/month', 'Full-Time', 'Clean and maintain guest rooms and common areas.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(14, 'Administrative Assistant', 'Mendez Local Government', 'Mendez, Cavite', '₱16,000/month', 'Full-Time', 'Assist office operations and documentation.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(16, 'Data Encoder', 'Mendez Data Solutions', 'Mendez, Cavite', '₱14,000/month', 'Full-Time', 'Input data accurately into company systems.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(17, 'Waiter', 'McDonald\'s Mendez', 'Mendez, Cavite', '₱10,000/month', 'Full-Time', 'Serving customers in a fast food environment.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(18, 'Delivery Driver', 'LBC Express', 'Mendez, Cavite', '₱15,000/month', 'Full-Time', 'Deliver parcels and documents in the local area.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(19, 'Security Guard', 'Mendez Security Agency', 'Mendez, Cavite', '₱9,000/month', 'Full-Time', 'Maintain safety and security of assigned premises.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(20, 'Receptionist', 'Mendez Dental Clinic', 'Mendez, Cavite', '₱11,000/month', 'Full-Time', 'Manage appointments and client inquiries.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(21, 'Graphic Designer', 'Creative Studio', 'Mendez, Cavite', '₱18,000/month', 'Part-Time', 'Design marketing materials and social media graphics.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(22, 'Cashier', '7-Eleven Mendez', 'Mendez, Cavite', '₱10,500/month', 'Full-Time', 'Handle cash transactions and customer service.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(23, 'Housekeeper', 'Mendez Hotel', 'Mendez, Cavite', '₱8,000/month', 'Full-Time', 'Clean and maintain guest rooms and common areas.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(24, 'Administrative Assistant', 'Mendez Local Government', 'Mendez, Cavite', '₱16,000/month', 'Full-Time', 'Assist office operations and documentation.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(25, 'Barista', 'Coffee Hub Mendez', 'Mendez, Cavite', '₱12,000/month', 'Part-Time', 'Prepare coffee and serve customers.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(26, 'Data Encoder', 'Mendez Data Solutions', 'Mendez, Cavite', '₱14,000/month', 'Full-Time', 'Input data accurately into company systems.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(27, 'Waiter', 'McDonald\'s Mendez', 'Mendez, Cavite', '₱10,000/month', 'Full-Time', 'Serving customers in a fast food environment.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(28, 'Delivery Driver', 'LBC Express', 'Mendez, Cavite', '₱15,000/month', 'Full-Time', 'Deliver parcels and documents in the local area.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(29, 'Security Guard', 'Mendez Security Agency', 'Mendez, Cavite', '₱9,000/month', 'Full-Time', 'Maintain safety and security of assigned premises.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(30, 'Receptionist', 'Mendez Dental Clinic', 'Mendez, Cavite', '₱11,000/month', 'Full-Time', 'Manage appointments and client inquiries.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(31, 'Graphic Designer', 'Creative Studio', 'Mendez, Cavite', '₱18,000/month', 'Part-Time', 'Design marketing materials and social media graphics.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(32, 'Cashier', '7-Eleven Mendez', 'Mendez, Cavite', '₱10,500/month', 'Full-Time', 'Handle cash transactions and customer service.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(33, 'Housekeeper', 'Mendez Hotel', 'Mendez, Cavite', '₱8,000/month', 'Full-Time', 'Clean and maintain guest rooms and common areas.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(34, 'Administrative Assistant', 'Mendez Local Government', 'Mendez, Cavite', '₱16,000/month', 'Full-Time', 'Assist office operations and documentation.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(35, 'Barista', 'Coffee Hub Mendez', 'Mendez, Cavite', '₱12,000/month', 'Part-Time', 'Prepare coffee and serve customers.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(36, 'Data Encoder', 'Mendez Data Solutions', 'Mendez, Cavite', '₱14,000/month', 'Full-Time', 'Input data accurately into company systems.', '2025-05-21 01:27:29', 9, 'Lite', 'active'),
(37, 'Cahsier', 'Jollibee Mendez', 'Mendez, Cavite', '₱12,000/month', 'Full-time', 'dsjhdbfjhsdb', '2025-05-28 01:55:22', 9, 'Lite', 'active'),
(76, 'Driver', 'CvSU', 'Mendez, Cavite', 'P2000/per hr', 'Full-time', 'Driver', '2025-09-23 12:04:44', 40, 'Premium', 'active'),
(77, 'Delivery Driver', 'FoodPanda', 'Mendez, Cavite', 'P19,000/hr', 'Part-time', 'Delivery Driver around Mendez', '2025-09-23 12:11:43', 40, 'Branded', 'active'),
(78, 'Software Engineer', 'TechNova Solutions', 'Makati City', '85000', 'Full-time', 'Develop and maintain web applications using modern frameworks and tools. Collaborate with cross-functional teams to deliver high-quality software.', '2025-10-16 03:42:27', 1, 'Premium', 'active'),
(79, 'Electrician', 'PowerPro Services', 'Davao City', '35000', 'Full-time', 'Install, maintain, and repair electrical systems for residential and commercial clients. Must have knowledge of safety regulations and electrical codes.', '2025-10-16 03:44:06', 3, 'Branded', 'active'),
(80, 'Administrative Assistant', 'Sunrise Trading Co.', 'Quezon City', '28000', 'Full-time', 'Provide administrative support to ensure efficient office operations. Handle scheduling, documentation, and customer correspondence.', '2025-10-16 03:45:04', 4, 'Lite', 'active'),
(82, 'Programmer', 'Accenture', 'Mendez, Cavite', 'P50,000/per month', 'Full-time', 'Java Programmer', '2025-10-16 03:54:26', 40, 'Premium', 'active'),
(85, 'JOBTESTING1', 'JOBTESTING1', 'JOBTESTING1', 'JOBTESTING1', 'Part-time', 'JOBTESTING1', '2025-10-17 04:23:09', 40, 'Lite', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `job_references`
--

DROP TABLE IF EXISTS `job_references`;
CREATE TABLE IF NOT EXISTS `job_references` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `occupation_type` varchar(100) DEFAULT NULL,
  `occupation1` varchar(255) DEFAULT NULL,
  `occupation2` varchar(255) DEFAULT NULL,
  `occupation3` varchar(255) DEFAULT NULL,
  `location_type` varchar(100) DEFAULT NULL,
  `location1` varchar(255) DEFAULT NULL,
  `location2` varchar(255) DEFAULT NULL,
  `location3` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_job_references_user` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_references`
--

INSERT INTO `job_references` (`id`, `user_id`, `occupation_type`, `occupation1`, `occupation2`, `occupation3`, `location_type`, `location1`, `location2`, `location3`, `created_at`, `updated_at`) VALUES
(1, 37, 'Full-time', 'Delivery Boy', 'ETC', 'ETC', 'Overseas', 'Paris France', 'ETC', 'ETC', '2025-09-17 13:07:26', '2025-09-17 13:07:26'),
(2, 39, 'Part-time', 'eckec', 'crc', 'crv', 'Overseas', '4vf4', '4f4vf', 'v4tv', '2025-09-23 11:55:45', '2025-09-23 11:55:45'),
(3, 43, 'Full-time', 'Waitress', 'Diswasher', 'Cashier', 'Local', 'Cavite', 'Cavite', 'Cavite', '2025-10-04 07:09:02', '2025-10-08 03:20:10'),
(4, 49, 'Full-time', 'vrv', 'vr', 'rbr', 'Overseas', 'tbtb', 'tbt', 'tbt', '2025-10-10 13:00:20', '2025-10-10 13:00:20');

-- --------------------------------------------------------

--
-- Table structure for table `job_seeker_verification`
--

DROP TABLE IF EXISTS `job_seeker_verification`;
CREATE TABLE IF NOT EXISTS `job_seeker_verification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `job_seeker_id` int NOT NULL,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `job_seeker_id` (`job_seeker_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_skills`
--

DROP TABLE IF EXISTS `job_skills`;
CREATE TABLE IF NOT EXISTS `job_skills` (
  `id` int NOT NULL AUTO_INCREMENT,
  `job_id` int NOT NULL,
  `skill` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `job_skills`
--

INSERT INTO `job_skills` (`id`, `job_id`, `skill`) VALUES
(16, 85, 'Painter/Artist'),
(17, 85, 'Gardening');

-- --------------------------------------------------------

--
-- Table structure for table `language_profeciencies`
--

DROP TABLE IF EXISTS `language_profeciencies`;
CREATE TABLE IF NOT EXISTS `language_profeciencies` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `language` varchar(50) NOT NULL,
  `read` tinyint(1) NOT NULL DEFAULT '0',
  `write` tinyint(1) NOT NULL DEFAULT '0',
  `speak` tinyint(1) NOT NULL DEFAULT '0',
  `understand` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_user` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `language_profeciencies`
--

INSERT INTO `language_profeciencies` (`id`, `user_id`, `language`, `read`, `write`, `speak`, `understand`, `created_at`, `updated_at`) VALUES
(1, 37, 'English', 1, 1, 1, 1, '2025-09-17 13:07:40', '2025-09-17 13:07:40'),
(2, 37, 'Filipino', 1, 1, 1, 1, '2025-09-17 13:07:40', '2025-09-17 13:07:40'),
(3, 37, 'Mandarin', 0, 0, 0, 0, '2025-09-17 13:07:40', '2025-09-17 13:07:40'),
(4, 39, 'English', 1, 1, 1, 1, '2025-09-23 11:55:55', '2025-09-23 11:55:55'),
(5, 39, 'Filipino', 0, 0, 0, 0, '2025-09-23 11:55:55', '2025-09-23 11:55:55'),
(6, 39, 'Mandarin', 1, 0, 0, 0, '2025-09-23 11:55:55', '2025-09-23 11:55:55'),
(7, 43, 'English', 1, 1, 1, 1, '2025-10-04 07:09:12', '2025-10-04 07:09:12'),
(8, 43, 'Filipino', 1, 1, 1, 1, '2025-10-04 07:09:12', '2025-10-04 07:09:12'),
(9, 43, 'Mandarin', 0, 0, 0, 0, '2025-10-04 07:09:12', '2025-10-04 07:09:12'),
(10, 49, 'English', 1, 0, 0, 0, '2025-10-10 13:00:25', '2025-10-10 13:00:25'),
(11, 49, 'Filipino', 0, 0, 0, 0, '2025-10-10 13:00:25', '2025-10-10 13:00:25'),
(12, 49, 'Mandarin', 0, 0, 0, 0, '2025-10-10 13:00:25', '2025-10-10 13:00:25');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
CREATE TABLE IF NOT EXISTS `messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sender_id` int NOT NULL,
  `receiver_id` int NOT NULL,
  `message_text` text COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('unread','read') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'unread',
  PRIMARY KEY (`id`),
  KEY `sender_id` (`sender_id`),
  KEY `receiver_id` (`receiver_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `sender_id`, `receiver_id`, `message_text`, `created_at`, `status`) VALUES
(14, 43, 40, 'Hello Worlds', '2025-10-21 00:24:18', 'unread'),
(15, 43, 40, 'Hello Worlds 2', '2025-10-21 00:24:43', 'unread');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `content` text COLLATE utf8mb4_general_ci NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `read_status` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `content`, `type`, `read_status`, `created_at`) VALUES
(4, 7, 'job_seeker TESTING1 has been registered.', 'ACCOUNT CREATED', 0, '2025-10-17 12:12:27'),
(5, 7, 'Job Seeker TESTING2 has been registered.', 'ACCOUNT CREATED', 0, '2025-10-17 12:13:34'),
(8, 7, 'Job JOBTESTING1 has been created.', 'JOB CREATED', 0, '2025-10-17 12:23:09'),
(9, 7, 'Jhonane Santons applied for an accreditation.', 'ACCREDITATION CREATED', 0, '2025-10-17 12:27:20'),
(10, 43, 'Application status updated to Reviewed', 'APPLICATION STATUS', 0, '2025-10-17 12:48:33'),
(11, 7, 'Admin has announced something.', 'JOB SEEKER ANNOUNCEMENT', 0, '2025-10-20 14:21:08'),
(12, 7, 'Admin has announced something.', 'FOR ALL ANNOUNCEMENT', 0, '2025-10-20 14:24:31'),
(13, 7, 'Admin has announced something.', 'FOR ALL ANNOUNCEMENT', 0, '2025-10-20 14:25:48'),
(14, 7, 'Admin has announced something.', 'FOR ALL ANNOUNCEMENT', 0, '2025-10-20 14:26:31'),
(15, 7, 'Admin has announced something.', 'JOB SEEKER ANNOUNCEMENT', 0, '2025-10-20 14:27:26'),
(16, 7, 'Admin has announced something.', 'EMPLOYER ANNOUNCEMENT', 0, '2025-10-20 14:28:13');

-- --------------------------------------------------------

--
-- Table structure for table `notifications_reads`
--

DROP TABLE IF EXISTS `notifications_reads`;
CREATE TABLE IF NOT EXISTS `notifications_reads` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `notification_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_notification` (`user_id`,`notification_id`),
  KEY `fk_notification_reads_notification` (`notification_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `other_skills`
--

DROP TABLE IF EXISTS `other_skills`;
CREATE TABLE IF NOT EXISTS `other_skills` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `skill` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_other_skills_user` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `other_skills`
--

INSERT INTO `other_skills` (`id`, `user_id`, `skill`, `created_at`) VALUES
(1, 43, 'Auto Mechnanic', '2025-10-04 07:15:33'),
(2, 43, 'Beautician', '2025-10-04 07:15:33'),
(3, 43, 'Driver', '2025-10-04 07:15:33'),
(4, 43, 'Gardening', '2025-10-04 07:15:33'),
(5, 43, 'Painting Jobs', '2025-10-04 07:15:33'),
(6, 43, 'Plumbing', '2025-10-04 07:15:33'),
(7, 49, 'Beautician', '2025-10-10 13:01:06');

-- --------------------------------------------------------

--
-- Table structure for table `personal_informations`
--

DROP TABLE IF EXISTS `personal_informations`;
CREATE TABLE IF NOT EXISTS `personal_informations` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `surname` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `middle_name` varchar(255) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `suffix` varchar(50) DEFAULT NULL,
  `religion` varchar(100) DEFAULT NULL,
  `present_address` text,
  `tin` varchar(50) DEFAULT NULL,
  `sex` varchar(20) DEFAULT NULL,
  `civil_status` varchar(50) DEFAULT NULL,
  `disability` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'N/A',
  `employment_status` varchar(50) DEFAULT NULL,
  `employment_type` varchar(50) DEFAULT NULL,
  `is_ofw` varchar(10) DEFAULT NULL,
  `is_former_ofw` varchar(10) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_persons_user` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `personal_informations`
--

INSERT INTO `personal_informations` (`id`, `user_id`, `surname`, `first_name`, `middle_name`, `date_of_birth`, `suffix`, `religion`, `present_address`, `tin`, `sex`, `civil_status`, `disability`, `employment_status`, `employment_type`, `is_ofw`, `is_former_ofw`, `created_at`, `updated_at`) VALUES
(1, 37, 'Aguinaldo', 'Emilio', '', NULL, 'IV', 'IV-A', 'Cavite', '8888-0000-0000', 'Male', 'Married', 'Others', 'Employed', 'Self-employed', 'No', 'No', '2025-09-17 13:06:48', '2025-09-17 13:06:48'),
(2, 39, 'h ececv', 'vrvr', 'rvvr', NULL, 'vrv', '4Acrcr', 're4fv', 'rvrvt', 'Female', 'Married', NULL, 'Unemployed', 'Finished Contract', 'No', 'No', '2025-09-23 11:55:11', '2025-09-23 11:55:11'),
(4, 42, 'Del Pillar', 'Gregorio', '', '2015-10-22', 'III.', '4A', 'Philippines', '24554', 'Male', 'Married', 'Physical', 'Employed', 'Wage employed', 'Yes', 'Yes', '2025-10-01 03:45:26', '2025-10-01 03:45:26'),
(5, 43, 'Del Pillar', 'Marcela', '', '2025-08-30', '', 'Roman Catholic', 'Dapitan, Cavite', '7553-9766-00000', 'Female', 'Single', 'N/A', 'Unemployed', 'New/Fresh Graduate', 'No', 'Yes', '2025-10-04 07:08:23', '2025-10-16 14:24:32'),
(6, 49, 'vrv', 'vrv', 'rvr', '2025-10-14', 'vrvr', 'rrvr', 'vrvrv', 'rv', 'Female', 'Married', 'Physical', 'Employed', 'Wage employed', 'No', 'No', '2025-10-10 13:00:07', '2025-10-10 13:00:07');

-- --------------------------------------------------------

--
-- Table structure for table `professional_licenses`
--

DROP TABLE IF EXISTS `professional_licenses`;
CREATE TABLE IF NOT EXISTS `professional_licenses` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `license` varchar(255) DEFAULT NULL,
  `valid_until` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_eligibilities_user` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `professional_licenses`
--

INSERT INTO `professional_licenses` (`id`, `user_id`, `license`, `valid_until`, `created_at`, `updated_at`) VALUES
(1, 37, '', '0000-00-00', '2025-09-17 13:08:24', '2025-09-17 13:08:24'),
(2, 37, '', '0000-00-00', '2025-09-17 13:08:24', '2025-09-17 13:08:24'),
(3, 39, '', '0000-00-00', '2025-09-23 11:57:02', '2025-09-23 11:57:02'),
(4, 39, '', '0000-00-00', '2025-09-23 11:57:02', '2025-09-23 11:57:02'),
(5, 43, 'Professional Teacher', '2028-01-30', '2025-10-04 07:14:22', '2025-10-08 17:14:23'),
(6, 43, 'Professional Engineer', '2029-09-07', '2025-10-04 07:14:22', '2025-10-08 17:14:23'),
(7, 49, '', '0000-00-00', '2025-10-10 13:00:50', '2025-10-10 13:00:50'),
(8, 49, '', '0000-00-00', '2025-10-10 13:00:50', '2025-10-10 13:00:50');

-- --------------------------------------------------------

--
-- Table structure for table `saved_jobs`
--

DROP TABLE IF EXISTS `saved_jobs`;
CREATE TABLE IF NOT EXISTS `saved_jobs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `job_id` int NOT NULL,
  `saved_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `job_id` (`job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `saved_jobs`
--

INSERT INTO `saved_jobs` (`id`, `user_id`, `job_id`, `saved_at`) VALUES
(1, 38, 36, '2025-09-17 13:16:39'),
(2, 43, 36, '2025-10-07 08:22:13'),
(3, 43, 77, '2025-10-07 08:50:43'),
(5, 43, 9, '2025-10-07 13:00:16'),
(6, 43, 8, '2025-10-07 13:56:57');

-- --------------------------------------------------------

--
-- Table structure for table `tech_voc_trainings`
--

DROP TABLE IF EXISTS `tech_voc_trainings`;
CREATE TABLE IF NOT EXISTS `tech_voc_trainings` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `course` varchar(255) DEFAULT NULL,
  `hours_training` varchar(255) DEFAULT NULL,
  `institution` varchar(255) DEFAULT NULL,
  `skills_acquired` varchar(255) DEFAULT NULL,
  `cert_received` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_techvoc_user` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `tech_voc_trainings`
--

INSERT INTO `tech_voc_trainings` (`id`, `user_id`, `course`, `hours_training`, `institution`, `skills_acquired`, `cert_received`, `created_at`, `updated_at`) VALUES
(1, 37, '', '', '', '', '', '2025-09-17 13:08:19', '2025-09-17 13:08:19'),
(2, 37, '', '', '', '', '', '2025-09-17 13:08:19', '2025-09-17 13:08:19'),
(3, 37, '', '', '', '', '', '2025-09-17 13:08:19', '2025-09-17 13:08:19'),
(4, 39, '', '', '', '', '', '2025-09-23 11:56:57', '2025-09-23 11:56:57'),
(5, 39, NULL, NULL, NULL, NULL, NULL, '2025-09-23 11:56:57', '2025-10-08 17:13:36'),
(6, 39, NULL, NULL, NULL, NULL, NULL, '2025-09-23 11:56:57', '2025-10-08 17:13:36'),
(7, 43, 'TESDA', '17', 'PhilHealth', 'Nothing', 'NC I', '2025-10-04 07:12:36', '2025-10-08 15:11:34'),
(8, 43, 'DPWHAAA', '18', 'CvSU', 'WALA', 'NC II', '2025-10-04 07:12:36', '2025-10-08 15:11:34'),
(9, 43, 'DOJAAA', '54', 'Law Firm', 'Law', 'NC III', '2025-10-04 07:12:36', '2025-10-08 15:11:34'),
(10, 49, '', '', '', '', '', '2025-10-10 13:00:45', '2025-10-10 13:00:45'),
(11, 49, '', '', '', '', '', '2025-10-10 13:00:45', '2025-10-10 13:00:45'),
(12, 49, '', '', '', '', '', '2025-10-10 13:00:45', '2025-10-10 13:00:45');

-- --------------------------------------------------------

--
-- Table structure for table `trainings`
--

DROP TABLE IF EXISTS `trainings`;
CREATE TABLE IF NOT EXISTS `trainings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `date` date NOT NULL,
  `location` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `contact` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `skills` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `document_path` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `role` enum('job_seeker','employer','admin') COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_active` tinyint(1) DEFAULT '1',
  `status` enum('active','inactive') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `full_name`, `email`, `contact`, `skills`, `document_path`, `username`, `password`, `role`, `created_at`, `is_active`, `status`) VALUES
(1, 'Job Seeker', 'jobseeker@gmail.com', '09770115814', 'Senior Engineer', '', 'jobseeker', '$2y$10$NAMOrPItLA/hpXyAlhDQ8uodQcI7rkwoTH9t9bLaZ2tHp1tI65yb6', 'job_seeker', '2025-05-21 01:01:41', 1, 'inactive'),
(7, 'Admin', 'admin@gmail.com', '09887576647', '', '', 'admin', '$2y$10$s613cbUJx8WeRZiq/M8HT.nn3DWYRAupNB6DzaJqmFyCNVyDakWRS', 'admin', '2025-05-21 06:41:44', 1, 'active'),
(9, 'Employer', 'employer@gmail.com', '09770115814', '', '', 'employer', '$2y$10$S1ZrlfzR065sgS163kRH7OasMVJUujsDFO/wSGAMlG/2lNtEaevuS', 'employer', '2025-05-21 10:03:46', 1, 'inactive'),
(10, 'Kiel Anne Villajin', 'kielannevillajin@gmail.com', '09770115814', '', '', 'kielanne', '$2y$10$wCewtEOGmtkb3srktTWaReALJRCwlSR3JC5MfAVHAXKUvXIr/xRIO', 'employer', '2025-05-27 10:41:02', 1, 'inactive'),
(11, 'Jhon Mark Magtibay', 'jhonmarkmagtibay21@gmail.com', '09053364069', 'Adaptive', '/mendez-peso-portal/files/resumes/resume_11_20250528_102315.pdf', 'jhonmark', '$2y$10$1haahDFP2pRzLyeT.JlWPOicKgZmixeMufhQ.IaPXsxi.SnLYHM5S', 'job_seeker', '2025-05-28 01:56:21', 1, 'inactive'),
(15, 'Joseph Emanuel Oliva Bataller', 'batallerjem1133@gmail.com', '09475453783', '', '', 'yoona', '$2y$10$0HTMyy4LazE.iJuhOWwZMek3qjWdSzOUEOGyjC6ZQ5CODGjLnTRSS', 'employer', '2025-06-26 03:14:58', 1, 'active'),
(16, 'John', 'john.doe@example.com', '1234567890', '', '', 'johndoe', '$2b$10$j06CMPkxNeMJkyGYX62.6uHH1jvnRG5yaxaRAn1jjj/9zxm/x.1RS', 'job_seeker', '2025-06-26 07:04:27', 1, 'active'),
(17, 'Kareem Abdul Jabar', 'kk@gmail.com', '02827273', '', '', 'kareem', '$2b$10$kzdHGEvCrb6ku80lEy0dZ.JhLYRRaleIhDw27pOmNsa35XMSY2Cte', 'job_seeker', '2025-06-26 07:26:44', 1, 'active'),
(18, 'kdkdn', 'ndndn', 'ndnxxn', '', '', 'trial1', '$2b$10$Esr6JnjSDjOXzqZlYEA7Bux0CLT0b91kmtcC2GQKV7.8GMynrQe5u', 'employer', '2025-06-26 07:35:51', 1, 'active'),
(19, 'Joseph Emanuel Oliva Bataller', 'innn@gmail.com', '09475453783', '', '', 'pikachu', '$2y$10$rF7/DssKSP1RRDJSZUqYgOc/tthEQnlWGo68IVLJdfoXKQVvdrqXi', 'admin', '2025-06-30 13:22:54', 1, 'active'),
(20, 'Fujiyoshi Kotoko', 'kotoko@unis.jp', '927363828', '', '', 'okotok', '$2b$10$KGieezVPydnaaNA/EMRnQu1Nte255gV5Owo7ncbEwqFtiVR60TRke', 'job_seeker', '2025-07-06 16:27:07', 1, 'active'),
(30, 'Rome Jay Fojas', 'rome@gmail.com', '09111111111', '', '', 'emoryaj', '$2b$10$mBHWtgFJZVD.KBY8AxZBj.4tka3Yge4A0VLHNe6PHsTFv5qDEMKCu', 'job_seeker', '2025-08-21 14:31:57', 1, 'inactive'),
(31, 'Makmak', 'mak@gmail.com', '09233311111', '', '', 'makmak', '$2b$10$1c3NFe0G2thPBfNBVVSDt.nKlS9BdvKispP6JRtRN5boAWc/cmTy2', 'employer', '2025-08-21 14:37:44', 1, 'inactive'),
(32, 'nocenoc', 'fk3kf@gmail.com', 'knkkmk3fm', '', '', 'Haliburton', '$2y$10$YiGvrnBIpvMT.V1hd8.Xluw2o2abJI8Z9DdHY43N4N5.KJO11gKa2', 'employer', '2025-09-01 05:22:38', 1, 'inactive'),
(33, 'nwnrf3', 'wedjndi@gmail.com', 'krfnknf3', '', '', 'Irving', '$2y$10$tZ5V8dwq2YG5q5zSHoxczuTjqvR0grBi/8/uW41kSYwwfy44Jyu4m', 'employer', '2025-09-01 05:26:04', 1, 'inactive'),
(34, 'John Doe', 'johndoe@example.comxx', '09123456789', '', '', 'johndoexx', '$2b$10$K5DdkPNK3J97AbRLX1f8yOz3igN3kTIQ0DHcEEzR87Yl8gqkU4tAq', '', '2025-09-05 16:39:38', 1, 'active'),
(36, 'Khael Sieun', 'siun@gmail.com', '09475453783', '', '', 'sieun', '$2b$10$3GYA2O3055KrV5haOqfd1.JmzzpQKpG6VQ/AUZE96Xs6/2qGlTXm6', 'job_seeker', '2025-09-06 15:03:52', 1, 'active'),
(37, 'Emilio Aguinaldo', 'aguinalddo@gmail.com', '09172993388', '', '', 'emilio', '$2b$10$fXtOgAeAJ/x97Nxhe/YCW.EMpaEF5XIp6qBhHBuwtHD/V8HDXK2d2', 'employer', '2025-09-17 13:05:30', 1, 'active'),
(38, 'Andres Bonifacio', 'bonifacio@gmail.com', '0922100111', '', '', 'andres', '$2b$10$x9y8wIgcGOB7M1tl.I56oejyZpZC0T39zyrPWBrMYyC.ZF2rqcoiq', 'job_seeker', '2025-09-17 13:14:48', 1, 'inactive'),
(39, 'Sheryn Mesina', 'mesina@gmail.com', '0918377733', '', '', 'sheryn', '$2b$10$hUht495twEAIl39Ua/5lVe0mb2V42vRmJC2VVcI3k/HUOONJsPklG', 'job_seeker', '2025-09-23 11:53:54', 1, 'active'),
(40, 'Jhonane Santons', 'santos@gmail.com', '0927773838', '', '', 'jhonane', '$2b$10$p7NJIdEpL67bs5IBCeJEiuC47zC3N/fgLYhpcgCd.1OUrwGw9XqdK', 'employer', '2025-09-23 12:03:11', 1, 'active'),
(42, 'Gregorio Del Pillar', 'delpillar@gmail.com', '029390294023', '', '', 'del pillar', '$2b$10$xlpLu.aYmr5ADXjCbp9A5ukD/UDW5NNv4YAK3juCXfx89q3kdTP9W', 'job_seeker', '2025-10-01 03:40:17', 1, 'active'),
(43, 'Marcela Del Pillar', 'cela@gmail.com', '09475453783', '', 'uploads/job-seeker-documents/BATALLER_IMPLEMENTING_SECURITY_POLICIES_1760977017123_326888362.pdf', 'cela', '$2b$10$i84PkZfjbeIV6rx16r1Y9uEoWU7Cd2ua4HokWVu45f5uOCfrFx7p6', 'job_seeker', '2025-10-04 07:07:11', 1, 'active'),
(48, 'Olympia Rizal', 'rizal@gmail.com', '09746637726', '', '', 'olympia', '$2b$10$zV58up.1z8vLvIR08H.dGusNyOB0dZ8m3x/o7Y7VdnFPvCoV83Hwm', 'employer', '2025-10-08 14:20:47', 1, 'active'),
(50, 'Paquito Ochoa', 'paq@gmail.com', '09475453783', '', '', 'paq', '$2b$10$sEMWG2I9jHEhGgZAhQ7c0..qpP8GtaQ8eZjEhZ/lKTNRuguVwrwf.', 'job_seeker', '2025-10-14 14:31:52', 1, 'active'),
(52, 'John Doe', 'johndoe@example.com', '+1234567890', '', '', 'johndoe123', '$2b$10$3/EHmq2fEZ9LLoikTs3xeuyHRYqLcRy/mDNCsja3SyDL.Xoyn5Aty', 'admin', '2025-10-17 04:06:32', 1, 'active'),
(57, 'TESTING1', 'TESTING1', 'TESTING1', '', '', 'TESTING1', '$2b$10$vbrt8x2EqptvpvHrR1K9auMPvNW3fPqPwL3ImkLGK15sMweRbkRni', 'job_seeker', '2025-10-17 04:12:27', 1, 'active'),
(58, 'TESTING2', 'TESTING2', 'TESTING2', '', '', 'TESTING2', '$2b$10$D9zxNXXq9ECsNLpOLJfBd.IV7tCN5WA2V8HAE1voRVvhRflcM9TKO', 'job_seeker', '2025-10-17 04:13:35', 1, 'active');

-- --------------------------------------------------------

--
-- Table structure for table `work_experiences`
--

DROP TABLE IF EXISTS `work_experiences`;
CREATE TABLE IF NOT EXISTS `work_experiences` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `no_of_month` varchar(255) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_work_experiences_user` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `work_experiences`
--

INSERT INTO `work_experiences` (`id`, `user_id`, `company_name`, `address`, `position`, `no_of_month`, `status`, `created_at`, `updated_at`) VALUES
(1, 37, '', '', '', '', '', '2025-09-17 13:08:30', '2025-09-17 13:08:30'),
(2, 37, '', '', '', '', '', '2025-09-17 13:08:30', '2025-09-17 13:08:30'),
(3, 37, '', '', '', '', '', '2025-09-17 13:08:31', '2025-09-17 13:08:31'),
(4, 39, '', '', '', '', '', '2025-09-23 11:57:07', '2025-09-23 11:57:07'),
(5, 39, '', '', '', '', '', '2025-09-23 11:57:07', '2025-09-23 11:57:07'),
(6, 39, '', '', '', '', '', '2025-09-23 11:57:07', '2025-09-23 11:57:07'),
(7, 43, 'DPWHSSS', 'Indang, CaviteSS', '69SSS', '12SSS', 'ContractualSS', '2025-10-04 07:15:21', '2025-10-08 17:24:28'),
(8, 43, 'AKO BICOLSS', 'BicolSS', '34 + 35SS', '12SSS', 'PermanentSS', '2025-10-04 07:15:21', '2025-10-08 17:24:28'),
(9, 43, 'SS', 'SS', 'SS', 'SSS', 'SS', '2025-10-04 07:15:21', '2025-10-08 17:24:28'),
(10, 49, '', '', '', '', '', '2025-10-10 13:00:58', '2025-10-10 13:00:58'),
(11, 49, '', '', '', '', '', '2025-10-10 13:00:58', '2025-10-10 13:00:58'),
(12, 49, '', '', '', '', '', '2025-10-10 13:00:58', '2025-10-10 13:00:58');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `applications`
--
ALTER TABLE `applications`
  ADD CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`),
  ADD CONSTRAINT `applications_ibfk_2` FOREIGN KEY (`job_seeker_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_applications_job` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_applications_user` FOREIGN KEY (`job_seeker_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `conversations`
--
ALTER TABLE `conversations`
  ADD CONSTRAINT `fk_conversation_user_a` FOREIGN KEY (`user_a`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_conversation_user_b` FOREIGN KEY (`user_b`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `employer_verification`
--
ALTER TABLE `employer_verification`
  ADD CONSTRAINT `employer_verification_ibfk_1` FOREIGN KEY (`employer_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `job_seeker_verification`
--
ALTER TABLE `job_seeker_verification`
  ADD CONSTRAINT `job_seeker_verification_ibfk_1` FOREIGN KEY (`job_seeker_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `saved_jobs`
--
ALTER TABLE `saved_jobs`
  ADD CONSTRAINT `saved_jobs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `saved_jobs_ibfk_2` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
