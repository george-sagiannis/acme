CREATE DATABASE `acme` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;

USE `acme`;

CREATE TABLE `country` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `code` char(2) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(80) COLLATE utf8_unicode_ci NOT NULL,
  `phonecode` int(5) NOT NULL,
  `lat` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `lng` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iso_UNIQUE` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `currency` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(3) CHARACTER SET utf8 NOT NULL,
  `sign_format` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `place` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `place_id` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `lat` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `lng` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `country_code` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `is_country` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `place_lang` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `place_id` int(11) unsigned NOT NULL,
  `locality` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `country` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `lang` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_place_lang_place_id_place_idx` (`place_id`),
  CONSTRAINT `FK_place_lang_place_id_place` FOREIGN KEY (`place_id`) REFERENCES `place` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `username` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `contact_email` bit(1) NOT NULL DEFAULT b'0',
  `contact_phone` bit(1) NOT NULL DEFAULT b'0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `phone_number` (
  `id` int(11) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `country_id` int(10) unsigned NOT NULL,
  `number` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `verification_code` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `verified` bit(1) NOT NULL DEFAULT b'0',
  `active` bit(1) NOT NULL DEFAULT b'1',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_phone_number_user_id_user_idx` (`user_id`),
  KEY `FK_phone_number_country_id_country_idx` (`country_id`),
  CONSTRAINT `FK_phone_number_country_id_country` FOREIGN KEY (`country_id`) REFERENCES `country` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_phone_number_user_id_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `trip` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `from` int(10) unsigned NOT NULL,
  `to` int(10) unsigned NOT NULL,
  `date` datetime NOT NULL,
  `number_seats` tinyint(4) NOT NULL,
  `duration` decimal(10,1) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `currency_id` int(10) unsigned NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `FK_trip_user_id_user_idx` (`user_id`),
  KEY `FK_trip_from_place_idx` (`from`),
  KEY `FK_trip_to_place_idx` (`to`),
  KEY `FK_trip_currency_id_currency_idx` (`currency_id`),
  CONSTRAINT `FK_trip_currency_id_currency` FOREIGN KEY (`currency_id`) REFERENCES `currency` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_trip_from_place` FOREIGN KEY (`from`) REFERENCES `place` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_trip_to_place` FOREIGN KEY (`to`) REFERENCES `place` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_trip_user_id_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `message` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `from_user_id` int(10) unsigned NOT NULL,
  `to_user_id` int(10) unsigned NOT NULL,
  `trip_id` int(10) unsigned NOT NULL,
  `text` text CHARACTER SET utf8 NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_message_from_user_id_user_idx` (`from_user_id`),
  KEY `FK_message_to_user_id_user_idx` (`to_user_id`),
  KEY `FK_message_trip_id_trip_idx` (`trip_id`),
  CONSTRAINT `FK_message_from_user_id_user` FOREIGN KEY (`from_user_id`) REFERENCES `user` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_message_to_user_id_user` FOREIGN KEY (`to_user_id`) REFERENCES `user` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_message_trip_id_trip` FOREIGN KEY (`trip_id`) REFERENCES `trip` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

