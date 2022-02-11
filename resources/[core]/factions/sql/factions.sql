CREATE TABLE IF NOT EXISTS `factions` (
	`character_id` INT(10) UNSIGNED NOT NULL,
	`name` VARCHAR(50) NOT NULL COLLATE 'latin1_swedish_ci',
	`group` VARCHAR(50) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`level` INT(11) NOT NULL,
	INDEX `factions_name` (`name`) USING BTREE,
	INDEX `factions_character_id` (`character_id`) USING BTREE,
	INDEX `factions_group` (`group`) USING BTREE,
	CONSTRAINT `factions_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;