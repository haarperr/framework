-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.7.3-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table nonstoprp_live.mdt_criminal_code
DROP TABLE IF EXISTS `mdt_criminal_code`;
CREATE TABLE IF NOT EXISTS `mdt_criminal_code` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('Federal Felony','State Felony','Misdemeanor','Traffic Infraction') DEFAULT NULL,
  `section` varchar(8) DEFAULT NULL,
  `charge` varchar(255) NOT NULL DEFAULT '',
  `definition` varchar(1024) NOT NULL DEFAULT '',
  `time` int(10) NOT NULL DEFAULT 0,
  `fine` int(10) unsigned NOT NULL DEFAULT 0,
  `active` tinyint(4) DEFAULT 1,
  UNIQUE KEY `mdt_criminal_code_unique` (`type`,`section`,`charge`),
  KEY `mdt_criminal_code_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1529 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table nonstoprp_live.mdt_paramedic_profiles
DROP TABLE IF EXISTS `mdt_paramedic_profiles`;
CREATE TABLE IF NOT EXISTS `mdt_paramedic_profiles` (
  `character_id` int(10) unsigned NOT NULL,
  `notes` text DEFAULT NULL,
  KEY `mdt_paramedic_profile_character_id` (`character_id`),
  CONSTRAINT `mdt_paramedic_profile_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table nonstoprp_live.mdt_paramedic_reports
DROP TABLE IF EXISTS `mdt_paramedic_reports`;
CREATE TABLE IF NOT EXISTS `mdt_paramedic_reports` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `character_id` int(10) unsigned NOT NULL,
  `author_id` int(10) unsigned NOT NULL,
  `injuries` text DEFAULT NULL,
  `treatment` text DEFAULT NULL,
  `other` text DEFAULT NULL,
  `date` datetime NOT NULL DEFAULT sysdate(),
  KEY `mdt_paramedic_reports_id` (`id`),
  KEY `mdt_paramedic_reports_character_id` (`character_id`),
  KEY `mdt_paramedic_reports_author_id` (`author_id`),
  CONSTRAINT `mdt_paramedic_reports_author_id` FOREIGN KEY (`author_id`) REFERENCES `characters` (`id`),
  CONSTRAINT `mdt_paramedic_reports_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table nonstoprp_live.mdt_police_profiles
DROP TABLE IF EXISTS `mdt_police_profiles`;
CREATE TABLE IF NOT EXISTS `mdt_police_profiles` (
  `character_id` int(10) unsigned NOT NULL,
  `mugshot_url` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  KEY `mdt_police_profile_character_id` (`character_id`),
  CONSTRAINT `mdt_police_profile_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table nonstoprp_live.mdt_police_reports
DROP TABLE IF EXISTS `mdt_police_reports`;
CREATE TABLE IF NOT EXISTS `mdt_police_reports` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `character_id` int(10) unsigned NOT NULL,
  `author_id` int(10) unsigned NOT NULL,
  `vehicle_id` int(10) unsigned DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  `details` mediumtext DEFAULT NULL,
  `charges` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`charges`)),
  `status` enum('Draft','Pending','Active','Awaiting Trial','Guilty','Not Guilty','Resolved') DEFAULT NULL,
  `plead` enum('Guilty','Not Guilty','No Contest') DEFAULT NULL,
  `date_start` datetime NOT NULL DEFAULT sysdate(),
  `date_end` datetime NOT NULL DEFAULT sysdate(),
  `served` bit(1) NOT NULL DEFAULT b'0',
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  KEY `mdt_police_report_id` (`id`),
  KEY `mdt_police_report_character_id` (`character_id`),
  KEY `mdt_police_report_author_id` (`author_id`),
  KEY `mdt_police_report_vehicle_id` (`vehicle_id`),
  CONSTRAINT `mdt_police_report_author_id` FOREIGN KEY (`author_id`) REFERENCES `characters` (`id`),
  CONSTRAINT `mdt_police_report_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`),
  CONSTRAINT `mdt_police_report_vehicle_id` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19973 DEFAULT CHARSET=utf8mb4;