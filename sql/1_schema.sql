-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.13-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.1.0.6116
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping structure for table gtarp_dev.garages
CREATE TABLE IF NOT EXISTS `garages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `property_id` int(10) unsigned DEFAULT NULL,
  `limit` tinyint(3) unsigned NOT NULL DEFAULT 4,
  `hidden` bit(1) NOT NULL DEFAULT b'0',
  `name` varchar(32) DEFAULT NULL,
  `type` enum('Car','Helicopter','Boat','Emergency') NOT NULL DEFAULT 'Car',
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `z` float DEFAULT NULL,
  `w` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `property_id_idx` (`property_id`),
  CONSTRAINT `garage_property_id` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for view gtarp_dev.garages_properties
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `garages_properties` (
	`id` INT(10) UNSIGNED NOT NULL,
	`property_id` INT(10) UNSIGNED NULL,
	`limit` TINYINT(3) UNSIGNED NOT NULL,
	`hidden` BIT(1) NOT NULL,
	`name` VARCHAR(32) NULL COLLATE 'utf8_general_ci',
	`type` ENUM('Car','Helicopter','Boat','Emergency') NOT NULL COLLATE 'utf8_general_ci',
	`x` FLOAT NULL,
	`y` FLOAT NULL,
	`z` FLOAT NULL,
	`w` FLOAT NULL
) ENGINE=MyISAM;

-- Dumping structure for view gtarp_dev.garages_static
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `garages_static` (
	`id` INT(10) UNSIGNED NOT NULL,
	`property_id` INT(10) UNSIGNED NULL,
	`limit` TINYINT(3) UNSIGNED NOT NULL,
	`hidden` BIT(1) NOT NULL,
	`name` VARCHAR(32) NULL COLLATE 'utf8_general_ci',
	`type` ENUM('Car','Helicopter','Boat','Emergency') NOT NULL COLLATE 'utf8_general_ci',
	`x` FLOAT NULL,
	`y` FLOAT NULL,
	`z` FLOAT NULL,
	`w` FLOAT NULL
) ENGINE=MyISAM;

-- Dumping structure for table gtarp_dev.jail
CREATE TABLE IF NOT EXISTS `jail` (
  `character_id` int(10) unsigned NOT NULL,
  `sender_id` int(10) unsigned DEFAULT NULL,
  `type` enum('prison','parsons') NOT NULL DEFAULT 'prison',
  `start_time` datetime NOT NULL DEFAULT sysdate(),
  `end_time` datetime NOT NULL DEFAULT sysdate(),
  KEY `jail_character_id` (`character_id`),
  KEY `jail_sender_id` (`sender_id`),
  CONSTRAINT `jail_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`),
  CONSTRAINT `jail_sender_id` FOREIGN KEY (`sender_id`) REFERENCES `characters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for view gtarp_dev.jail_active
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `jail_active` (
	`character_id` INT(10) UNSIGNED NOT NULL,
	`sender_id` INT(10) UNSIGNED NULL,
	`type` ENUM('prison','parsons') NOT NULL COLLATE 'utf8mb4_general_ci',
	`start_time` DATETIME NOT NULL,
	`end_time` DATETIME NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for procedure gtarp_dev.jail_add
DELIMITER //
CREATE PROCEDURE `jail_add`(
	IN `character_id` INT,
	IN `sender_id` INT,
	IN `minutes` INT,
	IN `type` TINYTEXT
)
BEGIN
	INSERT INTO jail SET
		`character_id`=`character_id`,
		`sender_id`=`sender_id`,
		`type`=`type`,
		`end_time`=SYSDATE() + INTERVAL `minutes` MINUTE;
END//
DELIMITER ;

-- Dumping structure for table gtarp_dev.keys
CREATE TABLE IF NOT EXISTS `keys` (
  `character_id` int(10) unsigned NOT NULL,
  `property_id` int(10) unsigned NOT NULL,
  UNIQUE KEY `id_UNIQUE` (`character_id`,`property_id`),
  KEY `id_idx` (`character_id`),
  KEY `property_id_idx` (`property_id`),
  CONSTRAINT `key_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`),
  CONSTRAINT `key_property_id` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for table gtarp_dev.licenses
CREATE TABLE IF NOT EXISTS `licenses` (
  `character_id` int(10) unsigned NOT NULL,
  `name` varchar(32) DEFAULT NULL,
  `points` tinyint(3) unsigned NOT NULL DEFAULT 0,
  UNIQUE KEY `id_UNIQUE` (`character_id`,`name`),
  KEY `id_idx` (`character_id`),
  CONSTRAINT `license_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for table gtarp_dev.mdt_criminal_code
CREATE TABLE IF NOT EXISTS `mdt_criminal_code` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('Federal Felony','State Felony','Misdemeanor','Traffic Infraction') DEFAULT NULL,
  `section` varchar(8) DEFAULT NULL,
  `charge` varchar(255) NOT NULL DEFAULT '',
  `definition` varchar(1024) NOT NULL DEFAULT '',
  `time` int(10) NOT NULL DEFAULT 0,
  `fine` int(10) unsigned NOT NULL DEFAULT 0,
  UNIQUE KEY `mdt_criminal_code_unique` (`type`,`section`,`charge`),
  KEY `mdt_criminal_code_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for function gtarp_dev.mdt_get_random_case_number
DELIMITER //
CREATE FUNCTION `mdt_get_random_case_number`() RETURNS int(11)
    DETERMINISTIC
BEGIN
	SET @case_id = 0;
	SET @max_range = 65536;

	WHILE @case_id=0 OR EXISTS (SELECT 1 FROM mdt_reports WHERE mdt_reports.case_id=@case_id) DO
		SET @case_id = FLOOR(RAND() * @max_range);
		SET @max_range = LEAST(@max_range + 32768, 4294967296);
	END WHILE;

	RETURN @case_id;
END//
DELIMITER ;

-- Dumping structure for table gtarp_dev.mdt_groups
CREATE TABLE IF NOT EXISTS `mdt_groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for table gtarp_dev.mdt_ranks
CREATE TABLE IF NOT EXISTS `mdt_ranks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for table gtarp_dev.mdt_reports
CREATE TABLE IF NOT EXISTS `mdt_reports` (
  `case_id` int(10) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for table gtarp_dev.mdt_users
CREATE TABLE IF NOT EXISTS `mdt_users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `character_id` int(10) unsigned NOT NULL,
  `nickname` varchar(32) NOT NULL,
  `call_sign` smallint(5) unsigned NOT NULL,
  `groups` int(11) NOT NULL DEFAULT 0,
  `last_played` datetime NOT NULL DEFAULT sysdate(),
  PRIMARY KEY (`id`),
  KEY `mdt_users_character_id` (`character_id`),
  CONSTRAINT `mdt_users_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for table gtarp_dev.payments
CREATE TABLE IF NOT EXISTS `payments` (
  `character_id` int(10) unsigned NOT NULL,
  `lender_id` int(10) unsigned DEFAULT NULL,
  `property_id` int(10) unsigned DEFAULT NULL,
  `vehicle_id` int(10) unsigned DEFAULT NULL,
  `last_payment` date NOT NULL DEFAULT sysdate(),
  `next_payment` date NOT NULL DEFAULT sysdate(),
  `payed` mediumint(8) unsigned NOT NULL DEFAULT 0,
  `due` mediumint(8) unsigned NOT NULL DEFAULT 0,
  `mortgage` mediumint(8) unsigned NOT NULL DEFAULT 0,
  `expired` bit(1) NOT NULL DEFAULT b'0',
  KEY `payments_character_id` (`character_id`),
  KEY `payments_property_id` (`property_id`),
  KEY `payments_vehicle_id` (`vehicle_id`),
  KEY `payments_lender_id` (`lender_id`),
  CONSTRAINT `payments_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`),
  CONSTRAINT `payments_lender_id` FOREIGN KEY (`lender_id`) REFERENCES `characters` (`id`),
  CONSTRAINT `payments_property_id` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`),
  CONSTRAINT `payments_vehicle_id` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for procedure gtarp_dev.payments_add
DELIMITER //
CREATE PROCEDURE `payments_add`(
	IN `character_id` INT,
	IN `lender_id` INT,
	IN `property_id` INT,
	IN `vehicle_id` INT,
	IN `interval` MEDIUMINT,
	IN `due` MEDIUMINT,
	IN `mortgage` MEDIUMINT
)
    DETERMINISTIC
BEGIN
	INSERT INTO `payments` SET
		`character_id`=`character_id`,
		`lender_id` = `lender_id`,
		`property_id`=`property_id`,
		`vehicle_id`=`vehicle_id`,
		`due`=`due`,
		`mortgage`=`mortgage`,
		`last_payment`=SYSDATE(),
		`next_payment`=(SYSDATE() + INTERVAL `interval` DAY);
END//
DELIMITER ;

-- Dumping structure for view gtarp_dev.payments_expired
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `payments_expired` (
	`character_id` INT(10) UNSIGNED NOT NULL,
	`lender_id` INT(10) UNSIGNED NULL,
	`property_id` INT(10) UNSIGNED NULL,
	`vehicle_id` INT(10) UNSIGNED NULL,
	`last_payment` DATE NOT NULL,
	`next_payment` DATE NOT NULL,
	`payed` MEDIUMINT(8) UNSIGNED NOT NULL,
	`due` MEDIUMINT(8) UNSIGNED NOT NULL,
	`expired` BIT(1) NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for table gtarp_dev.properties
DROP TABLE IF EXISTS `properties`;
CREATE TABLE `properties` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `character_id` int(10) unsigned DEFAULT NULL,
  `type` enum('apartment','arcadius_office','beeker_garage','benny_original_motorwork','bunker','burger_shot','burton_auto','clubhouse1','clubhouse2','counterfeit','drugroom','east_side_auto','facility','forge','garage1','garage2','garage3','growroom','hangar','house','importgarage','luxury_auto','mansion','motel','nightclub','sewer','stripclub','warehouse1','warehouse2','warehouse3','warehouse4','weed_shop') NOT NULL DEFAULT 'motel',
  `business_id` int(10) unsigned DEFAULT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `w` float NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `id_idx` (`character_id`),
  KEY `property_business_id` (`business_id`),
  CONSTRAINT `property_business_id` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`id`),
  CONSTRAINT `property_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for procedure gtarp_dev.properties_expire
DELIMITER //
CREATE PROCEDURE `properties_expire`()
BEGIN
	UPDATE `properties`
	SET `character_id`=NULL
	WHERE EXISTS
		(SELECT * FROM `payments_expired`
		WHERE `payments_expired`.property_id=`properties`.id);

	DELETE FROM `keys`
	WHERE EXISTS
		(SELECT 1 FROM `payments_expired`
		WHERE `keys`.property_id=`payments_expired`.property_id);

	UPDATE `payments_expired`
	SET `expired`=1;
END//
DELIMITER ;

-- Dumping structure for table gtarp_dev.serials
CREATE TABLE IF NOT EXISTS `serials` (
  `character_id` int(10) unsigned DEFAULT NULL,
  `serial_number` varchar(8) NOT NULL,
  KEY `serials_character_id` (`character_id`) USING BTREE,
  CONSTRAINT `serials_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for table gtarp_dev.territories
CREATE TABLE IF NOT EXISTS `territories` (
  `zone` varchar(16) NOT NULL,
  `factions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`zone`) USING BTREE,
  UNIQUE KEY `terrirtories_zone_UQ` (`zone`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for table gtarp_dev.vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `character_id` int(10) unsigned NOT NULL,
  `garage_id` int(10) unsigned NOT NULL DEFAULT 0,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `model` varchar(64) NOT NULL,
  `plate` varchar(8) DEFAULT NULL,
  `colors` varchar(64) DEFAULT NULL,
  `fuel` tinyint(4) DEFAULT 100,
  `body_health` smallint(5) unsigned NOT NULL DEFAULT 1000,
  `engine_health` smallint(5) unsigned NOT NULL DEFAULT 1000,
  `fuel_health` smallint(5) unsigned NOT NULL DEFAULT 1000,
  `other_health` varchar(64) DEFAULT NULL,
  `components` varchar(256) DEFAULT NULL,
  `mods` varchar(256) DEFAULT NULL,
  `extras` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `id_idx` (`character_id`),
  KEY `garage_id_idx` (`garage_id`),
  CONSTRAINT `vehicle_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`),
  CONSTRAINT `vehicle_garage_id` FOREIGN KEY (`garage_id`) REFERENCES `garages` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

--Dumping structure for trigger gtarp_dev.characters_after_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `characters_after_insert` AFTER INSERT ON `characters` FOR EACH ROW BEGIN

      INSERT INTO `licenses` (
         `character_id`,
          `name`
      ) VALUES (
        NEW.id,
        'drivers'
      );
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger gtarp_dev.mdt_reports_before_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `mdt_reports_before_insert` BEFORE INSERT ON `mdt_reports` FOR EACH ROW BEGIN
	SET NEW.case_id=mdt_get_random_case_number();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger gtarp_dev.properties_before_delete
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `properties_before_delete` BEFORE DELETE ON `properties` FOR EACH ROW BEGIN
	DELETE FROM `payments` WHERE property_id=OLD.id;
	DELETE FROM `keys` WHERE property_id=OLD.id;
	DELETE FROM `containers` WHERE property_id=OLD.id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger gtarp_dev.vehicles_before_delete
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `vehicles_before_delete` BEFORE DELETE ON `vehicles` FOR EACH ROW BEGIN
	DELETE FROM containers WHERE vehicle_id=OLD.id;
	DELETE FROM mdt_police_reports WHERE vehicle_id=OLD.id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for view gtarp_dev.garages_properties
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `garages_properties`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `garages_properties` AS SELECT * FROM garages WHERE property_id IS NOT NULL ;

-- Dumping structure for view gtarp_dev.garages_static
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `garages_static`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `garages_static` AS SELECT * FROM garages WHERE `name` IS NOT NULL ;

-- Dumping structure for view gtarp_dev.jail_active
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `jail_active`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `jail_active` AS SELECT * FROM jail WHERE TIMESTAMPDIFF(SECOND, SYSDATE(), end_time) > 0 ;

-- Dumping structure for view gtarp_dev.payments_expired
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `payments_expired`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `payments_expired` AS SELECT * FROM `payments` WHERE NOT expired AND `payed` < `due` AND DATEDIFF(SYSDATE(), `next_payment`) >= 0 ;
