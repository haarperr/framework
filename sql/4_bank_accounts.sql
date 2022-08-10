CREATE TABLE `bank_accounts` (
	`id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`account_id` INT(10) UNSIGNED NOT NULL DEFAULT (floor(rand() * (587456432 - 187356432 + 1)) + 187356432),
	`character_id` INT(10) UNSIGNED NOT NULL,
	`account_name` TEXT NOT NULL COLLATE 'utf8_general_ci',
	`account_type` INT(10) NOT NULL DEFAULT '0',
	`account_balance` BIGINT(10) NOT NULL DEFAULT '0',
	`account_primary` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `id` (`id`) USING BTREE,
	UNIQUE INDEX `account_id` (`account_id`) USING BTREE,
	INDEX `owner_id` (`character_id`) USING BTREE,
	CONSTRAINT `FK_bank_accounts_characters` FOREIGN KEY (`character_id`) REFERENCES `nonstoprp_dev`.`characters` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;



CREATE TABLE `bank_accounts_shared` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`account_id` INT(10) UNSIGNED NOT NULL,
	`character_id` INT(10) UNSIGNED NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `id` (`id`) USING BTREE,
	INDEX `FK_bank_accounts_shared_characters` (`character_id`) USING BTREE,
	INDEX `account_id` (`account_id`) USING BTREE,
	CONSTRAINT `FK_bank_accounts_shared_bank_accounts` FOREIGN KEY (`account_id`) REFERENCES `nonstoprp_dev`.`bank_accounts` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT `FK_bank_accounts_shared_characters` FOREIGN KEY (`character_id`) REFERENCES `nonstoprp_dev`.`characters` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB;

CREATE TABLE `bank_accounts_transactions` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`account_id` INT(10) UNSIGNED NOT NULL,
	`transaction_type` INT(11) NOT NULL,
	`transaction_person` TEXT NOT NULL COLLATE 'utf8_general_ci',
	`transaction_date` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
	`transaction_note` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`transaction_amount` BIGINT(10) NOT NULL,
	`transaction_from` INT(10) UNSIGNED NULL DEFAULT NULL,
	`transaction_to` INT(10) UNSIGNED NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `id` (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;
