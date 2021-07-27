CREATE TABLE IF NOT EXISTS `properties` (
	`id` INT(10) NOT NULL AUTO_INCREMENT,
	`character_id` INT(10) UNSIGNED NULL DEFAULT NULL,
	`business_id` INT(10) UNSIGNED NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `id_UNIQUE` (`id`) USING BTREE,
	INDEX `id_idx` (`character_id`) USING BTREE,
	INDEX `property_business_id` (`business_id`) USING BTREE,
	CONSTRAINT `property_character_id` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON UPDATE RESTRICT ON DELETE RESTRICT
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;