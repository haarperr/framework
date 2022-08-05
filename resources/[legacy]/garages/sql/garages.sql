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