DELIMITER //
CREATE FUNCTION `bank_generateAccountNumber`() RETURNS int(10)
    DETERMINISTIC
BEGIN
	SET @random_num = 0;

	WHILE @random_num=0 OR EXISTS (SELECT 1 FROM bank_accounts WHERE bank_accounts.account_id=@random_num) DO
		SET @random_num = FLOOR(RAND() * 999999999);
	END WHILE;

	RETURN @random_num;
END//
DELIMITER ;

CREATE TABLE `bank_accounts` (
	`id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`account_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
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

CREATE TRIGGER IF NOT EXISTS `banking_generateAccountNumber` BEFORE INSERT ON `bank_accounts` FOR EACH ROW BEGIN
	SET NEW.account_number = bank_generateAccountNumber()
END