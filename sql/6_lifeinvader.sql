CREATE TABLE `lifeinvader` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`character_id` INT(10) UNSIGNED NULL DEFAULT NULL,
	`message` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `id` (`id`) USING BTREE,
	INDEX `character_id` (`character_id`) USING BTREE,
	CONSTRAINT `FK_lifeinvader_characters` FOREIGN KEY (`character_id`) REFERENCES `nonstoprp_dev`.`characters` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB;
