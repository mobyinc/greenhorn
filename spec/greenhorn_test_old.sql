# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: localhost (MySQL 5.6.25)
# Database: greenhorn_dev
# Generation Time: 2016-08-16 21:02:50 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table craft_assetfiles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_assetfiles`;

CREATE TABLE `craft_assetfiles` (
  `id` int(11) NOT NULL,
  `sourceId` int(11) DEFAULT NULL,
  `folderId` int(11) NOT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `kind` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'unknown',
  `width` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `size` bigint(20) unsigned DEFAULT NULL,
  `dateModified` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_assetfiles_filename_folderId_unq_idx` (`filename`,`folderId`),
  KEY `craft_assetfiles_sourceId_fk` (`sourceId`),
  KEY `craft_assetfiles_folderId_fk` (`folderId`),
  CONSTRAINT `craft_assetfiles_folderId_fk` FOREIGN KEY (`folderId`) REFERENCES `craft_assetfolders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_assetfiles_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_assetfiles_sourceId_fk` FOREIGN KEY (`sourceId`) REFERENCES `craft_assetsources` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_assetfolders
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_assetfolders`;

CREATE TABLE `craft_assetfolders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentId` int(11) DEFAULT NULL,
  `sourceId` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_assetfolders_name_parentId_sourceId_unq_idx` (`name`,`parentId`,`sourceId`),
  KEY `craft_assetfolders_parentId_fk` (`parentId`),
  KEY `craft_assetfolders_sourceId_fk` (`sourceId`),
  CONSTRAINT `craft_assetfolders_parentId_fk` FOREIGN KEY (`parentId`) REFERENCES `craft_assetfolders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_assetfolders_sourceId_fk` FOREIGN KEY (`sourceId`) REFERENCES `craft_assetsources` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_assetindexdata
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_assetindexdata`;

CREATE TABLE `craft_assetindexdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sessionId` varchar(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `sourceId` int(10) NOT NULL,
  `offset` int(10) NOT NULL,
  `uri` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `size` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `recordId` int(10) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_assetindexdata_sessionId_sourceId_offset_unq_idx` (`sessionId`,`sourceId`,`offset`),
  KEY `craft_assetindexdata_sourceId_fk` (`sourceId`),
  CONSTRAINT `craft_assetindexdata_sourceId_fk` FOREIGN KEY (`sourceId`) REFERENCES `craft_assetsources` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_assetsources
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_assetsources`;

CREATE TABLE `craft_assetsources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `handle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `type` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `settings` text COLLATE utf8_unicode_ci,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `fieldLayoutId` int(10) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_assetsources_name_unq_idx` (`name`),
  UNIQUE KEY `craft_assetsources_handle_unq_idx` (`handle`),
  KEY `craft_assetsources_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `craft_assetsources_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_assettransformindex
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_assettransformindex`;

CREATE TABLE `craft_assettransformindex` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fileId` int(11) NOT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `format` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `sourceId` int(11) DEFAULT NULL,
  `fileExists` tinyint(1) DEFAULT NULL,
  `inProgress` tinyint(1) DEFAULT NULL,
  `dateIndexed` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_assettransformindex_sourceId_fileId_location_idx` (`sourceId`,`fileId`,`location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_assettransforms
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_assettransforms`;

CREATE TABLE `craft_assettransforms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `handle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `mode` enum('stretch','fit','crop') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'crop',
  `position` enum('top-left','top-center','top-right','center-left','center-center','center-right','bottom-left','bottom-center','bottom-right') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'center-center',
  `height` int(10) DEFAULT NULL,
  `width` int(10) DEFAULT NULL,
  `format` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `quality` int(10) DEFAULT NULL,
  `dimensionChangeTime` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_assettransforms_name_unq_idx` (`name`),
  UNIQUE KEY `craft_assettransforms_handle_unq_idx` (`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_categories`;

CREATE TABLE `craft_categories` (
  `id` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_categories_groupId_fk` (`groupId`),
  CONSTRAINT `craft_categories_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `craft_categorygroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_categories_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_categorygroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_categorygroups`;

CREATE TABLE `craft_categorygroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `handle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `hasUrls` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `template` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_categorygroups_name_unq_idx` (`name`),
  UNIQUE KEY `craft_categorygroups_handle_unq_idx` (`handle`),
  KEY `craft_categorygroups_structureId_fk` (`structureId`),
  KEY `craft_categorygroups_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `craft_categorygroups_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `craft_categorygroups_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `craft_structures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_categorygroups_i18n
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_categorygroups_i18n`;

CREATE TABLE `craft_categorygroups_i18n` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `locale` char(12) COLLATE utf8_unicode_ci NOT NULL,
  `urlFormat` text COLLATE utf8_unicode_ci,
  `nestedUrlFormat` text COLLATE utf8_unicode_ci,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_categorygroups_i18n_groupId_locale_unq_idx` (`groupId`,`locale`),
  KEY `craft_categorygroups_i18n_locale_fk` (`locale`),
  CONSTRAINT `craft_categorygroups_i18n_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `craft_categorygroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_categorygroups_i18n_locale_fk` FOREIGN KEY (`locale`) REFERENCES `craft_locales` (`locale`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_addresses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_addresses`;

CREATE TABLE `craft_commerce_addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstName` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `lastName` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `countryId` int(10) DEFAULT NULL,
  `stateId` int(10) DEFAULT NULL,
  `address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zipCode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `alternativePhone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `businessName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `businessTaxId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `stateName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_commerce_addresses_countryId_fk` (`countryId`),
  KEY `craft_commerce_addresses_stateId_fk` (`stateId`),
  CONSTRAINT `craft_commerce_addresses_countryId_fk` FOREIGN KEY (`countryId`) REFERENCES `craft_commerce_countries` (`id`) ON DELETE SET NULL,
  CONSTRAINT `craft_commerce_addresses_stateId_fk` FOREIGN KEY (`stateId`) REFERENCES `craft_commerce_states` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_countries
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_countries`;

CREATE TABLE `craft_commerce_countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `iso` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `stateRequired` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_countries_name_unq_idx` (`name`),
  UNIQUE KEY `craft_commerce_countries_iso_unq_idx` (`iso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_commerce_countries` WRITE;
/*!40000 ALTER TABLE `craft_commerce_countries` DISABLE KEYS */;

INSERT INTO `craft_commerce_countries` (`id`, `name`, `iso`, `stateRequired`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Andorra','AD',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','f36d3f56-5b3d-4790-b0f6-8e7962b5290f'),
	(2,'United Arab Emirates','AE',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','09b47ef8-4d2d-49cd-b80a-0b898e01b276'),
	(3,'Afghanistan','AF',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','4525614d-4af1-4022-86a8-238618c4fe4c'),
	(4,'Antigua and Barbuda','AG',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','5c49cea8-bac8-431f-bdf6-05787c862eb9'),
	(5,'Anguilla','AI',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','04602d28-c363-4004-9919-f4d67aed7a97'),
	(6,'Albania','AL',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','13bf06f6-37f2-4c3f-bea4-fd198ef30599'),
	(7,'Armenia','AM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','137c1dd8-7a91-42f1-953e-0f793d6f77f8'),
	(8,'Angola','AO',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','7eb3e565-993d-43f2-a7da-f5e6452a97cf'),
	(9,'Antarctica','AQ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','2f2b6b81-3f79-45d7-82b0-7a38f52c8f8f'),
	(10,'Argentina','AR',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','1f87acd4-fb61-461a-9c84-c729607a1594'),
	(11,'American Samoa','AS',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','f9e2766f-ce5f-47b0-becd-07e50eef7381'),
	(12,'Austria','AT',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','aef5d099-7959-49fd-bfd4-690abd45dff1'),
	(13,'Australia','AU',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','e513b29d-f185-4374-914c-b0f210418618'),
	(14,'Aruba','AW',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','a97d0170-ccf7-4e72-a09a-c5b09e5cf5c2'),
	(15,'Aland Islands','AX',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','94b4ccba-a44b-4d90-961f-e45df29761f7'),
	(16,'Azerbaijan','AZ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','edb197fe-c3b7-49c8-a9e1-2caba0a7020d'),
	(17,'Bosnia and Herzegovina','BA',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','cf655315-c20b-4a4d-bc6c-4aa759b1b8e1'),
	(18,'Barbados','BB',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','4432d58e-eeb6-47e3-9020-8edca0d5e748'),
	(19,'Bangladesh','BD',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','35b2c387-990a-4095-a319-13e7dcda2802'),
	(20,'Belgium','BE',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','ca090aec-1f76-4471-8e32-2b4d1aef4d1c'),
	(21,'Burkina Faso','BF',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','8b57d457-6213-4f80-8a05-8f4d9cff208f'),
	(22,'Bulgaria','BG',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','5b251e4f-3dfd-443d-bd68-66ae4a0d1128'),
	(23,'Bahrain','BH',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','37ae613d-4755-4623-95a3-9e3a994fdf83'),
	(24,'Burundi','BI',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','251ac829-4d34-401b-b1f3-6ffd76ca8127'),
	(25,'Benin','BJ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','e5fdc425-159a-45f1-b32c-b96eaf4b2e50'),
	(26,'Saint Barthelemy','BL',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','2ff85441-1f93-4148-b80b-48f15b503868'),
	(27,'Bermuda','BM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','6729871c-b598-4b47-9253-a7660d01d0d7'),
	(28,'Brunei Darussalam','BN',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','39e000eb-f9ed-46ba-91aa-e5d2d5e0655b'),
	(29,'Bolivia','BO',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','4a1ee0a7-62b6-420e-8193-301d038504ed'),
	(30,'Bonaire, Sint Eustatius and Saba','BQ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','d46831df-b3a7-40a6-9fe4-c71be8471c9e'),
	(31,'Brazil','BR',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','d09521eb-5ac9-4cc9-979c-0b85a33695c2'),
	(32,'Bahamas','BS',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','a6307c60-0d92-4ed6-85c7-a7fda98ba8bd'),
	(33,'Bhutan','BT',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','ae95b52c-c02c-48c3-ae4f-078bd0c91e0a'),
	(34,'Bouvet Island','BV',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','e45659bb-0676-4c61-a699-45669279a329'),
	(35,'Botswana','BW',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','ff2db6fd-3fc6-42f1-8e94-99578d088a78'),
	(36,'Belarus','BY',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','e689ee49-c7e3-47af-bbc7-9e574fbb55eb'),
	(37,'Belize','BZ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','78789749-efd4-4f75-8432-4ac783c03615'),
	(38,'Canada','CA',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','c1aaa9dd-af65-4ca1-8076-6f69500039db'),
	(39,'Cocos (Keeling) Islands','CC',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','ac037704-2e5b-409a-90d4-a45bef3c39c4'),
	(40,'Democratic Republic of Congo','CD',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','3109034f-c896-4ce7-8358-8e0647018fc6'),
	(41,'Central African Republic','CF',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','2718da40-e023-41b8-95aa-6dad2ce57429'),
	(42,'Congo','CG',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','d024c31b-97bd-426d-ad4a-b7b8389cccb0'),
	(43,'Switzerland','CH',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','5030e94a-3fb2-4d66-8ec3-a9edccdaee23'),
	(44,'Ivory Coast','CI',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','3f5e95c6-ff16-45ef-b394-7fab76300800'),
	(45,'Cook Islands','CK',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','ff7ffd93-d785-4cca-bd95-8506eac2892a'),
	(46,'Chile','CL',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','99b4c65a-8cdc-4774-92d4-b03f64b9321a'),
	(47,'Cameroon','CM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','4fd5dd73-f480-42f0-a485-b92a93711656'),
	(48,'China','CN',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','440ed5c7-6ddf-43c9-93d2-91eef753b570'),
	(49,'Colombia','CO',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','98447bec-16df-4a4d-8147-8162685301ab'),
	(50,'Costa Rica','CR',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','d49dbdbb-9f72-4f71-b366-8e1c6773774e'),
	(51,'Cuba','CU',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','64214d0b-6499-416f-a5a3-88327bff2dc0'),
	(52,'Cape Verde','CV',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','364dc506-ce83-43a5-99e4-6b90cf6874ea'),
	(53,'Curacao','CW',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','8037f00c-95f2-4a63-bd79-50e5b1a65ca5'),
	(54,'Christmas Island','CX',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','ec0aa6e0-9c5a-46b5-a6fc-0ae5689041ae'),
	(55,'Cyprus','CY',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','b9bcf987-4602-40a4-b299-9142f5e0089e'),
	(56,'Czech Republic','CZ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','ddf190d5-b4e5-4155-9b43-9e5b11ad7dbb'),
	(57,'Germany','DE',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','f9a13945-e070-4a3b-9755-ea0c62d4fdc7'),
	(58,'Djibouti','DJ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','7a81433d-f1af-4467-822e-193d531aebb6'),
	(59,'Denmark','DK',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','d7199d2a-29d4-49f2-9235-03015998b7ed'),
	(60,'Dominica','DM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','8fc11953-5d5c-4c09-801f-b9e4f12f0073'),
	(61,'Dominican Republic','DO',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','efa87e26-8751-4a3c-be52-3fe87fba1c9e'),
	(62,'Algeria','DZ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','90f5a51b-1a63-4ccf-886e-0013f45b44b4'),
	(63,'Ecuador','EC',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','72657f56-cf74-4fc0-b7a1-ce080cb8f905'),
	(64,'Estonia','EE',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','892b018a-b5db-4914-bb41-05e0399dfe02'),
	(65,'Egypt','EG',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','dd8c9c74-233f-4a2e-94cb-806c3a969c79'),
	(66,'Western Sahara','EH',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','8d02726f-6ee3-480b-a0cd-a0045aedd81d'),
	(67,'Eritrea','ER',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','88cd45f0-d8c7-4a5c-83a8-24077900a94b'),
	(68,'Spain','ES',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','42e83ec8-f5c6-4c99-a02d-856bfb15bd7c'),
	(69,'Ethiopia','ET',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','7f5211c6-f71c-4b39-950c-3f79d07a4a6b'),
	(70,'Finland','FI',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','0751a1db-6ab1-48d8-b8df-78f249e0768d'),
	(71,'Fiji','FJ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','2e84e6fd-90d2-4a73-9143-56ca84919c16'),
	(72,'Falkland Islands (Malvinas)','FK',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','8c914fbb-d5de-4baa-b0af-124c6f8787a5'),
	(73,'Micronesia','FM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','e51d9427-c7bf-43ec-bc41-b1655b117f4b'),
	(74,'Faroe Islands','FO',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','df7ee641-275c-497d-bc83-c0edb92b18f8'),
	(75,'France','FR',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','04a9aef5-bd6a-40fe-93de-c242f438f070'),
	(76,'Gabon','GA',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','5bac9fb8-8d5f-40e7-be0e-448ca74dd814'),
	(77,'United Kingdom','GB',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','9bc5efed-7aec-466c-9c9a-c717b3dd93c3'),
	(78,'Grenada','GD',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','23b2318e-4b04-4b38-b29a-fd450f5b962a'),
	(79,'Georgia','GE',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','d143ea15-9671-42ac-bfa1-c41115030d35'),
	(80,'French Guiana','GF',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','79af53dc-e240-4260-ba6e-0a319b260d6e'),
	(81,'Guernsey','GG',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','d06b5bd1-df46-49e7-a017-8f32c547cf38'),
	(82,'Ghana','GH',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','ea47caac-fae3-4b43-b124-4c8775a9220c'),
	(83,'Gibraltar','GI',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','7a510931-f23e-494b-aca4-cc6a5c479b34'),
	(84,'Greenland','GL',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','0be9fc51-fa17-4b3e-a88d-a54e0264f3a2'),
	(85,'Gambia','GM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','70e72418-c125-4871-88bc-be003d8c98c7'),
	(86,'Guinea','GN',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','6764703d-ea06-40c1-8f76-c8a42331a895'),
	(87,'Guadeloupe','GP',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','cc4bd784-eb3f-4288-b513-368f57fd26f2'),
	(88,'Equatorial Guinea','GQ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','e5d39731-4995-46f6-a2d5-54468db042be'),
	(89,'Greece','GR',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','b29e7237-471a-4ec5-b44b-e2a5240edf99'),
	(90,'S. Georgia and S. Sandwich Isls.','GS',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','ad3baacc-f872-4702-8726-2024518c1877'),
	(91,'Guatemala','GT',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','276e0844-0e05-4ee1-8e15-308057b7335c'),
	(92,'Guam','GU',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','2266d5af-4d0e-471f-9db5-90197047dca9'),
	(93,'Guinea-Bissau','GW',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','5dd46948-8203-4a4f-a9ae-a2e12d9e3e98'),
	(94,'Guyana','GY',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','892cd8bc-68ec-4ff4-b4c9-0cb45d8578e4'),
	(95,'Hong Kong','HK',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','85717bde-77c6-458c-89b5-72097bee389b'),
	(96,'Heard and McDonald Islands','HM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','9588a7e0-8be6-4c07-9c13-b1f7e6008b93'),
	(97,'Honduras','HN',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','e39d8ecf-0cbc-4955-ae75-88ab91aa100b'),
	(98,'Croatia (Hrvatska)','HR',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','ba430893-370c-4cd2-97d2-38833fd230ed'),
	(99,'Haiti','HT',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','274bbe7d-87ca-4910-b4c0-c87231bcbe93'),
	(100,'Hungary','HU',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','f713e801-e8fd-4662-b358-6d261dd0f80d'),
	(101,'Indonesia','ID',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','8f0a7acc-84e1-4798-88e0-43a76a4e6b44'),
	(102,'Ireland','IE',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','41fb3c27-a506-45ca-8927-c715ef7339e9'),
	(103,'Israel','IL',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','8d25f0de-7f92-4866-9862-f90ff19e394e'),
	(104,'Isle Of Man','IM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','d30c2e55-15bc-4a88-9ee7-a2554ef8e1fd'),
	(105,'India','IN',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','8d3a5202-1134-4b83-af36-deb66c4cb05a'),
	(106,'British Indian Ocean Territory','IO',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','e3959436-43d3-4d23-a992-79da9b03286b'),
	(107,'Iraq','IQ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','28bbfeb9-1ed4-4bd6-835d-c8f3f9f6e809'),
	(108,'Iran','IR',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','d6e11f19-01ef-4807-a7a4-65048fe26fe7'),
	(109,'Iceland','IS',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','e1fe14f5-d25f-4996-a0a9-c2a49687889c'),
	(110,'Italy','IT',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','5b6d6bab-de34-4b3b-8649-09c8338bf0f1'),
	(111,'Jersey','JE',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','fabe616b-b31c-425b-b990-1acd161a51ea'),
	(112,'Jamaica','JM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','9738de03-f86c-49e7-a81e-48343cc5f9f4'),
	(113,'Jordan','JO',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','aa7c457a-4cd8-44b0-b975-26c68e768f9b'),
	(114,'Japan','JP',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','ef72daf9-0115-4e6d-9928-531e8e9e27fa'),
	(115,'Kenya','KE',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','1fac5737-ccd8-4a4b-a07e-76cd4f1be4ed'),
	(116,'Kyrgyzstan','KG',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','25dd2e27-afe0-4399-ab1d-8c51774ea468'),
	(117,'Cambodia','KH',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','4cca43c8-e84a-458a-80c4-2d06cae2575d'),
	(118,'Kiribati','KI',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','df070226-61f3-4923-997a-72a542afcd15'),
	(119,'Comoros','KM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','9be6b194-7b4b-4900-b887-91145701bc89'),
	(120,'Saint Kitts and Nevis','KN',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','bbbb12b3-e51e-4a58-bc48-ce99ffc72432'),
	(121,'Korea (North)','KP',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','ad412ada-d166-43cb-9f59-ecee6ef27abd'),
	(122,'Korea (South)','KR',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','948a8e90-cf68-40e7-a929-26b36fe61d5f'),
	(123,'Kuwait','KW',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','dda3edda-c693-47b7-9078-418cf5fa2e66'),
	(124,'Cayman Islands','KY',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','2765b3bc-2ca3-4c41-b0a9-8ffa7e8b823b'),
	(125,'Kazakhstan','KZ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','c7b83e8e-a1e5-40f6-92a2-76b6547a79de'),
	(126,'Laos','LA',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','b76e0416-f81b-445e-9a1b-39b8e74fa7d8'),
	(127,'Lebanon','LB',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','1738637d-70e6-49dc-b5e0-4dafa405e6de'),
	(128,'Saint Lucia','LC',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','0c41d75c-ab20-4110-bd8d-c811541ae213'),
	(129,'Liechtenstein','LI',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','b723d087-a9ab-4438-9ea2-79a6dc8c7fc8'),
	(130,'Sri Lanka','LK',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','20545881-a71b-4bdf-9841-7830199eb87c'),
	(131,'Liberia','LR',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','ea5051ca-a43c-4bc2-aa19-bc4b237e03f0'),
	(132,'Lesotho','LS',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','1f02e949-c1a4-4cc4-9682-d2a6fcfae396'),
	(133,'Lithuania','LT',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','1c3cd1c4-e67d-4194-8a4d-ff2d6570648c'),
	(134,'Luxembourg','LU',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','893e0bbb-40e8-4222-844c-851aea60e39c'),
	(135,'Latvia','LV',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','de4a88db-78dd-4086-aa5b-bd565837fe26'),
	(136,'Libya','LY',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','8ea7bf5e-75c0-416f-bf22-3412dd73ed09'),
	(137,'Morocco','MA',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','f975b28a-4398-44c7-8605-d5b47b11a404'),
	(138,'Monaco','MC',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','63027f89-9964-4969-8c30-c061814be295'),
	(139,'Moldova','MD',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','fe681411-826e-4e0e-b227-5a600c6ad1c3'),
	(140,'Montenegro','ME',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','7acb008a-8cf8-4589-87b7-9e5318fdf0c5'),
	(141,'Saint Martin (French part)','MF',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','73ed58e5-cf23-49f5-be6d-93ec0d54ede1'),
	(142,'Madagascar','MG',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','e0994109-f7b0-4461-9840-b3943b211b76'),
	(143,'Marshall Islands','MH',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','8d0eab5e-a1b0-4693-95f9-875ad068cc79'),
	(144,'Macedonia','MK',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','d1842ad3-d7b9-4c77-bbc6-26e6faffa964'),
	(145,'Mali','ML',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','9617a3e2-318e-49cf-833f-8b8f62446de1'),
	(146,'Burma (Myanmar)','MM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','394db3cf-3624-4184-86bf-1885ceb197a2'),
	(147,'Mongolia','MN',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','e98872ed-ba6a-4511-a33e-c27f5488f782'),
	(148,'Macau','MO',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','cd166dc4-1dd4-4433-a67e-d63b0971109c'),
	(149,'Northern Mariana Islands','MP',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','f232d51e-d64a-477d-9684-55e56f9a7578'),
	(150,'Martinique','MQ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','5fd7e2a8-7fe0-4d0a-a4b2-f9696a23b28c'),
	(151,'Mauritania','MR',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','f3f9ceaa-31fd-46ae-b51c-956de1688628'),
	(152,'Montserrat','MS',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','2ad68a29-0292-4109-84ee-f01419d4129c'),
	(153,'Malta','MT',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','a7878f4e-e101-420e-a104-0766882c6163'),
	(154,'Mauritius','MU',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','69710114-a066-40f4-9c9b-842a43f06428'),
	(155,'Maldives','MV',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','4211c9aa-bba5-4fdf-b2ba-8d999297660b'),
	(156,'Malawi','MW',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','754a5bc7-d2b2-41f8-8eed-8ee74edd9811'),
	(157,'Mexico','MX',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','f4a4bf8f-c929-494f-96f0-6b33eb69c1a4'),
	(158,'Malaysia','MY',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','2a527ba7-8353-44f5-927a-aa36235ced14'),
	(159,'Mozambique','MZ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','6d7e429b-0150-4b50-ba54-f2e5aa84967e'),
	(160,'Namibia','NA',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','b49c14b7-0a2b-4cd2-bcf0-c106bdf95923'),
	(161,'New Caledonia','NC',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','bf82c801-1a2e-4b28-8672-5208642deb7c'),
	(162,'Niger','NE',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','768fe5a2-831a-492d-9be1-e419ad421d66'),
	(163,'Norfolk Island','NF',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','b602f854-f22e-4a87-b1fa-1564cd89cf63'),
	(164,'Nigeria','NG',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','69714bd8-35ec-406d-9c78-167cbf2dc2fb'),
	(165,'Nicaragua','NI',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','aa8bfd42-3587-4df2-aa56-e86dd590a970'),
	(166,'Netherlands','NL',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','d4482024-3902-495a-956c-9cf5e97ef93d'),
	(167,'Norway','NO',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','12a95e96-2a50-4386-87ae-f48779c5fa90'),
	(168,'Nepal','NP',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','1dd31e69-e7da-4ad9-8120-e70e85861a7e'),
	(169,'Nauru','NR',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','05ed41d6-eac2-47e8-82f2-b6cd77b94a83'),
	(170,'Niue','NU',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','aa3d0c39-c29d-414e-9a96-582753ab756d'),
	(171,'New Zealand','NZ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','eaf87a4f-8522-4626-956c-f306a5a07dcd'),
	(172,'Oman','OM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','c2030478-b66e-4f4f-a21b-28511076a311'),
	(173,'Panama','PA',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','9e893aca-5f24-4ab1-aca2-0da57f47f6e2'),
	(174,'Peru','PE',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','395b20eb-1418-4b67-a78e-0a5d976d6167'),
	(175,'French Polynesia','PF',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','5c087beb-8f96-4ee5-9d52-34b54e2cc82f'),
	(176,'Papua New Guinea','PG',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','0251af14-9709-48e5-b822-e397f7447fed'),
	(177,'Philippines','PH',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','5c7f7fc5-e906-4b58-b6f3-9af3e27f640c'),
	(178,'Pakistan','PK',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','239f6629-8ff1-4eaf-b170-f4c8e0da9257'),
	(179,'Poland','PL',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','22f43655-0cf9-4c35-9320-5b79152891e4'),
	(180,'St. Pierre and Miquelon','PM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','c84086cf-febc-4427-95c2-a3f3d0905ca1'),
	(181,'Pitcairn','PN',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','5d8a52d3-d122-4496-97ce-95498eb0c695'),
	(182,'Puerto Rico','PR',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','59f036ff-1ed7-49fe-aaaa-fd487c6b3750'),
	(183,'Palestinian Territory, Occupied','PS',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','83199e68-79ce-461f-a083-6ea5b300e05e'),
	(184,'Portugal','PT',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','4d6eba9b-4168-4a52-a79d-b0694b0c44ee'),
	(185,'Palau','PW',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','6b9f5739-eae9-45b0-a096-7c4de2ca2bcc'),
	(186,'Paraguay','PY',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','cd7cbfb7-ec1a-4bce-b1c2-b35731b1a0af'),
	(187,'Qatar','QA',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','007047a6-ca7c-4cf3-9af3-f6c42f01473c'),
	(188,'Reunion','RE',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','a47d9854-586a-43e9-9717-1bfafeb9d7e3'),
	(189,'Romania','RO',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','ca92b9cc-9108-4a24-af4e-ee8cf9ab4620'),
	(190,'Republic of Serbia','RS',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','12f2e2d2-6567-46e0-8eab-3537d92921b7'),
	(191,'Russia','RU',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','5a8ce4d5-612b-44ee-b417-f710860caacd'),
	(192,'Rwanda','RW',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','d2c2a56c-08d3-45f7-bf3e-055cef958bbf'),
	(193,'Saudi Arabia','SA',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','113a21c9-fe87-485b-8942-850be0c463d0'),
	(194,'Solomon Islands','SB',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','24ceb2e9-01a3-4c4c-85ab-f39be592b7e2'),
	(195,'Seychelles','SC',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','f3c7137a-afdd-4fb6-aaa2-67c8b50ce55c'),
	(196,'Sudan','SD',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','04c6d3c8-a4ae-4647-b399-dc54f3823e99'),
	(197,'Sweden','SE',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','c4d99643-ecd5-4c69-9e6a-28aa6487096c'),
	(198,'Singapore','SG',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','4ce849ce-6f41-402b-a1ed-4d21237622d4'),
	(199,'St. Helena','SH',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','f91f98ce-1aa5-4950-9436-05fa7cd15ade'),
	(200,'Slovenia','SI',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','b9f4322c-7308-4cf1-9e01-d1afd7d6cae4'),
	(201,'Svalbard and Jan Mayen Islands','SJ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','79ac2739-2596-41c1-9612-1655a8ac9c51'),
	(202,'Slovak Republic','SK',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','c120a0b1-cd7e-4c14-bff9-d91121191b7b'),
	(203,'Sierra Leone','SL',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','3aa39505-aa1f-4b20-9b1f-b56919235a75'),
	(204,'San Marino','SM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','ff906f94-5320-49ca-9e10-95f31168ac75'),
	(205,'Senegal','SN',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','048004ef-814b-4251-b1af-b1bd3b231f1b'),
	(206,'Somalia','SO',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','3db5d9fe-066d-4383-a2d9-e2260c69c72b'),
	(207,'Suriname','SR',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','20875b98-be10-46e2-968d-355ebf529baa'),
	(208,'South Sudan','SS',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','d5b32a1c-5eff-4717-b022-bd297a31346f'),
	(209,'Sao Tome and Principe','ST',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','c19bcdf7-a0c9-4e2f-9dfd-2ccb8596e58c'),
	(210,'El Salvador','SV',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','04c377b0-efcb-442c-bdab-387fa4dc3f1a'),
	(211,'Sint Maarten (Dutch part)','SX',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','b8d7d5d4-67a1-4238-9912-b8105ea23334'),
	(212,'Syria','SY',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','f542fd98-4d9b-4ba7-80e4-8e0516f70383'),
	(213,'Swaziland','SZ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','f0081ade-88df-4904-aa39-549de0f111d5'),
	(214,'Turks and Caicos Islands','TC',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','085a833c-ecc3-47ef-a97f-c1b48261a9a9'),
	(215,'Chad','TD',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','9787cdfe-455c-47a5-a732-c33b86832d4c'),
	(216,'French Southern Territories','TF',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','dc0a6687-5b35-40c4-a6a4-f134ee303b3f'),
	(217,'Togo','TG',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','017bda35-6271-4fc8-a701-83b7733f17cf'),
	(218,'Thailand','TH',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','fe86510b-9a79-42ff-8ef2-97aafbcfd03b'),
	(219,'Tajikistan','TJ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','34dbdeb0-bdaf-4431-849d-b9f2e6217665'),
	(220,'Tokelau','TK',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','fba8e0c3-93f4-4ba7-8f2f-ccd548574ed4'),
	(221,'Timor-Leste','TL',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','3a25e766-7c9e-4192-af65-79271d05b622'),
	(222,'Turkmenistan','TM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','6215788c-1e97-4b72-864b-61a72789bafd'),
	(223,'Tunisia','TN',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','80b935f1-cd23-42cc-a218-7d29d78be47d'),
	(224,'Tonga','TO',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','f6f3f5f8-c7a7-446e-a92b-f7123c86855d'),
	(225,'Turkey','TR',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','f50c0f83-172b-4fec-9bc5-be7c038b6602'),
	(226,'Trinidad and Tobago','TT',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','2f980aa3-ed3d-4e45-84a6-5bd94675c478'),
	(227,'Tuvalu','TV',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','8250e929-1721-49cc-ab1e-2bb620a516d3'),
	(228,'Taiwan','TW',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','33e0e717-37db-48ed-a40d-c823565d37d9'),
	(229,'Tanzania','TZ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','51a811c7-fc5d-4c01-99ed-4890b2f067e2'),
	(230,'Ukraine','UA',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','fb93b855-2aaf-4577-94da-09957b9e0213'),
	(231,'Uganda','UG',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','dfb6f014-35ca-4bb5-9668-17d0c9a532d3'),
	(232,'United States Minor Outlying Islands','UM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','26e19144-dbce-41e4-932f-e9c1bb421190'),
	(233,'United States','US',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','7d636cae-d0fd-41ba-b95e-a8e478e1095f'),
	(234,'Uruguay','UY',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','e1dbbccf-f3f9-4cd0-86db-0508de29bf49'),
	(235,'Uzbekistan','UZ',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','6bb781d3-b67e-46c1-a3cb-73119e783093'),
	(236,'Vatican City State (Holy See)','VA',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','5cafc12b-a52d-4d10-a909-c93a01513d35'),
	(237,'Saint Vincent and the Grenadines','VC',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','a287cec5-26e2-4c61-b762-d490516b1294'),
	(238,'Venezuela','VE',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','9d670b1f-54c6-458b-9e32-3bf4ff6d2737'),
	(239,'Virgin Islands (British)','VG',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','0d06e3f3-fd30-4882-ac24-b9a6041bd766'),
	(240,'Virgin Islands (U.S.)','VI',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','b54350a6-ef23-4f9d-887a-50c846009aa1'),
	(241,'Viet Nam','VN',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','1ab439fc-26f2-4d73-a367-5e7b39c4af7a'),
	(242,'Vanuatu','VU',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','ad9b4b02-2833-4139-9ce6-ec7ffd56e83d'),
	(243,'Wallis and Futuna Islands','WF',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','dba43f77-250c-46d9-a62a-b695987437cf'),
	(244,'Samoa','WS',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','41497eec-517b-47b5-a6a9-9715308a2e4b'),
	(245,'Yemen','YE',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','7558f86b-644b-4a59-9cb5-ff9013d6febf'),
	(246,'Mayotte','YT',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','6b6c2b0d-0fb5-4e04-b372-cddf2027fb4f'),
	(247,'South Africa','ZA',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','52095568-0ff3-4a0c-91dc-ec9d8767b2d4'),
	(248,'Zambia','ZM',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','5684dd13-1005-4a21-a87e-2177204a7394'),
	(249,'Zimbabwe','ZW',0,'2016-08-16 21:02:40','2016-08-16 21:02:40','93691846-6ac0-4c87-8b9b-9c029a0d881c');

/*!40000 ALTER TABLE `craft_commerce_countries` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_commerce_customer_discountuses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_customer_discountuses`;

CREATE TABLE `craft_commerce_customer_discountuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `discountId` int(10) NOT NULL,
  `customerId` int(10) NOT NULL,
  `uses` int(10) unsigned NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_customer_discountuses_customerId_discountId_unq_i` (`customerId`,`discountId`),
  KEY `craft_commerce_customer_discountuses_discountId_fk` (`discountId`),
  CONSTRAINT `craft_commerce_customer_discountuses_customerId_fk` FOREIGN KEY (`customerId`) REFERENCES `craft_commerce_customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_customer_discountuses_discountId_fk` FOREIGN KEY (`discountId`) REFERENCES `craft_commerce_discounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_customers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_customers`;

CREATE TABLE `craft_commerce_customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastUsedBillingAddressId` int(10) DEFAULT NULL,
  `lastUsedShippingAddressId` int(10) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_commerce_customers_userId_fk` (`userId`),
  CONSTRAINT `craft_commerce_customers_userId_fk` FOREIGN KEY (`userId`) REFERENCES `craft_users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_customers_addresses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_customers_addresses`;

CREATE TABLE `craft_commerce_customers_addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customerId` int(11) NOT NULL,
  `addressId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_customers_addresses_customerId_addressId_unq_idx` (`customerId`,`addressId`),
  KEY `craft_commerce_customers_addresses_customerId_idx` (`customerId`),
  KEY `craft_commerce_customers_addresses_addressId_idx` (`addressId`),
  CONSTRAINT `craft_commerce_customers_addresses_addressId_fk` FOREIGN KEY (`addressId`) REFERENCES `craft_commerce_addresses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_customers_addresses_customerId_fk` FOREIGN KEY (`customerId`) REFERENCES `craft_commerce_customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_discount_products
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_discount_products`;

CREATE TABLE `craft_commerce_discount_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `discountId` int(10) NOT NULL,
  `productId` int(10) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_discount_products_discountId_productId_unq_idx` (`discountId`,`productId`),
  KEY `craft_commerce_discount_products_productId_fk` (`productId`),
  CONSTRAINT `craft_commerce_discount_products_discountId_fk` FOREIGN KEY (`discountId`) REFERENCES `craft_commerce_discounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_discount_products_productId_fk` FOREIGN KEY (`productId`) REFERENCES `craft_commerce_products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_discount_producttypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_discount_producttypes`;

CREATE TABLE `craft_commerce_discount_producttypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `discountId` int(10) NOT NULL,
  `productTypeId` int(10) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerc_discoun_producttype_discountI_productTypeI_unq_idx` (`discountId`,`productTypeId`),
  KEY `craft_commerce_discount_producttypes_productTypeId_fk` (`productTypeId`),
  CONSTRAINT `craft_commerce_discount_producttypes_discountId_fk` FOREIGN KEY (`discountId`) REFERENCES `craft_commerce_discounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_discount_producttypes_productTypeId_fk` FOREIGN KEY (`productTypeId`) REFERENCES `craft_commerce_producttypes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_discount_usergroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_discount_usergroups`;

CREATE TABLE `craft_commerce_discount_usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `discountId` int(10) NOT NULL,
  `userGroupId` int(10) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_discount_usergroups_discountId_userGroupId_unq_id` (`discountId`,`userGroupId`),
  KEY `craft_commerce_discount_usergroups_userGroupId_fk` (`userGroupId`),
  CONSTRAINT `craft_commerce_discount_usergroups_discountId_fk` FOREIGN KEY (`discountId`) REFERENCES `craft_commerce_discounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_discount_usergroups_userGroupId_fk` FOREIGN KEY (`userGroupId`) REFERENCES `craft_usergroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_discounts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_discounts`;

CREATE TABLE `craft_commerce_discounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `perUserLimit` int(10) unsigned NOT NULL DEFAULT '0',
  `perEmailLimit` int(10) unsigned NOT NULL DEFAULT '0',
  `totalUseLimit` int(10) unsigned NOT NULL DEFAULT '0',
  `totalUses` int(10) unsigned NOT NULL DEFAULT '0',
  `dateFrom` datetime DEFAULT NULL,
  `dateTo` datetime DEFAULT NULL,
  `purchaseTotal` int(10) NOT NULL DEFAULT '0',
  `purchaseQty` int(10) NOT NULL DEFAULT '0',
  `baseDiscount` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `perItemDiscount` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `percentDiscount` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `excludeOnSale` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `freeShipping` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `allGroups` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `allProducts` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `allProductTypes` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_discounts_code_unq_idx` (`code`),
  KEY `craft_commerce_discounts_dateFrom_idx` (`dateFrom`),
  KEY `craft_commerce_discounts_dateTo_idx` (`dateTo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_emails
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_emails`;

CREATE TABLE `craft_commerce_emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `to` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `bcc` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `templatePath` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_lineitems
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_lineitems`;

CREATE TABLE `craft_commerce_lineitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orderId` int(11) NOT NULL,
  `purchasableId` int(11) DEFAULT NULL,
  `options` text COLLATE utf8_unicode_ci,
  `optionsSignature` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `price` decimal(14,4) unsigned NOT NULL,
  `saleAmount` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `salePrice` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `tax` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `taxIncluded` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `shippingCost` decimal(14,4) unsigned NOT NULL DEFAULT '0.0000',
  `discount` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `weight` decimal(14,4) unsigned NOT NULL DEFAULT '0.0000',
  `height` decimal(14,4) unsigned NOT NULL DEFAULT '0.0000',
  `length` decimal(14,4) unsigned NOT NULL DEFAULT '0.0000',
  `width` decimal(14,4) unsigned NOT NULL DEFAULT '0.0000',
  `total` decimal(14,4) unsigned NOT NULL DEFAULT '0.0000',
  `qty` int(10) unsigned NOT NULL,
  `note` text COLLATE utf8_unicode_ci,
  `snapshot` text COLLATE utf8_unicode_ci NOT NULL,
  `taxCategoryId` int(10) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craf_commerc_lineitem_orderI_purchasableI_optionsSignatu_unq_idx` (`orderId`,`purchasableId`,`optionsSignature`),
  KEY `craft_commerce_lineitems_purchasableId_fk` (`purchasableId`),
  KEY `craft_commerce_lineitems_taxCategoryId_fk` (`taxCategoryId`),
  CONSTRAINT `craft_commerce_lineitems_orderId_fk` FOREIGN KEY (`orderId`) REFERENCES `craft_commerce_orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_commerce_lineitems_purchasableId_fk` FOREIGN KEY (`purchasableId`) REFERENCES `craft_elements` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_lineitems_taxCategoryId_fk` FOREIGN KEY (`taxCategoryId`) REFERENCES `craft_commerce_taxcategories` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_orderadjustments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_orderadjustments`;

CREATE TABLE `craft_commerce_orderadjustments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `amount` decimal(14,4) NOT NULL,
  `included` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `optionsJson` text COLLATE utf8_unicode_ci NOT NULL,
  `orderId` int(10) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_commerce_orderadjustments_orderId_idx` (`orderId`),
  CONSTRAINT `craft_commerce_orderadjustments_orderId_fk` FOREIGN KEY (`orderId`) REFERENCES `craft_commerce_orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_orderhistories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_orderhistories`;

CREATE TABLE `craft_commerce_orderhistories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prevStatusId` int(11) DEFAULT NULL,
  `newStatusId` int(11) DEFAULT NULL,
  `orderId` int(10) NOT NULL,
  `customerId` int(10) NOT NULL,
  `message` text COLLATE utf8_unicode_ci,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_commerce_orderhistories_orderId_fk` (`orderId`),
  KEY `craft_commerce_orderhistories_prevStatusId_fk` (`prevStatusId`),
  KEY `craft_commerce_orderhistories_newStatusId_fk` (`newStatusId`),
  KEY `craft_commerce_orderhistories_customerId_fk` (`customerId`),
  CONSTRAINT `craft_commerce_orderhistories_customerId_fk` FOREIGN KEY (`customerId`) REFERENCES `craft_commerce_customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_orderhistories_newStatusId_fk` FOREIGN KEY (`newStatusId`) REFERENCES `craft_commerce_orderstatuses` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_orderhistories_orderId_fk` FOREIGN KEY (`orderId`) REFERENCES `craft_commerce_orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_orderhistories_prevStatusId_fk` FOREIGN KEY (`prevStatusId`) REFERENCES `craft_commerce_orderstatuses` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_orders
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_orders`;

CREATE TABLE `craft_commerce_orders` (
  `billingAddressId` int(11) DEFAULT NULL,
  `shippingAddressId` int(11) DEFAULT NULL,
  `paymentMethodId` int(11) DEFAULT NULL,
  `customerId` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `orderStatusId` int(11) DEFAULT NULL,
  `number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `couponCode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `itemTotal` decimal(14,4) DEFAULT '0.0000',
  `baseDiscount` decimal(14,4) DEFAULT '0.0000',
  `baseShippingCost` decimal(14,4) DEFAULT '0.0000',
  `totalPrice` decimal(14,4) DEFAULT '0.0000',
  `totalPaid` decimal(14,4) DEFAULT '0.0000',
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `isCompleted` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `dateOrdered` datetime DEFAULT NULL,
  `datePaid` datetime DEFAULT NULL,
  `currency` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastIp` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `returnUrl` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cancelUrl` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shippingMethod` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_commerce_orders_number_idx` (`number`),
  KEY `craft_commerce_orders_billingAddressId_fk` (`billingAddressId`),
  KEY `craft_commerce_orders_shippingAddressId_fk` (`shippingAddressId`),
  KEY `craft_commerce_orders_paymentMethodId_fk` (`paymentMethodId`),
  KEY `craft_commerce_orders_customerId_fk` (`customerId`),
  KEY `craft_commerce_orders_orderStatusId_fk` (`orderStatusId`),
  CONSTRAINT `craft_commerce_orders_billingAddressId_fk` FOREIGN KEY (`billingAddressId`) REFERENCES `craft_commerce_addresses` (`id`) ON DELETE SET NULL,
  CONSTRAINT `craft_commerce_orders_customerId_fk` FOREIGN KEY (`customerId`) REFERENCES `craft_commerce_customers` (`id`) ON DELETE SET NULL,
  CONSTRAINT `craft_commerce_orders_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_commerce_orders_orderStatusId_fk` FOREIGN KEY (`orderStatusId`) REFERENCES `craft_commerce_orderstatuses` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_orders_paymentMethodId_fk` FOREIGN KEY (`paymentMethodId`) REFERENCES `craft_commerce_paymentmethods` (`id`) ON DELETE SET NULL,
  CONSTRAINT `craft_commerce_orders_shippingAddressId_fk` FOREIGN KEY (`shippingAddressId`) REFERENCES `craft_commerce_addresses` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_ordersettings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_ordersettings`;

CREATE TABLE `craft_commerce_ordersettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `handle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_ordersettings_handle_unq_idx` (`handle`),
  KEY `craft_commerce_ordersettings_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `craft_commerce_ordersettings_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_commerce_ordersettings` WRITE;
/*!40000 ALTER TABLE `craft_commerce_ordersettings` DISABLE KEYS */;

INSERT INTO `craft_commerce_ordersettings` (`id`, `fieldLayoutId`, `name`, `handle`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,6,'Order','order','2016-08-16 21:02:39','2016-08-16 21:02:39','31972dab-b8d7-4670-9991-569b6faf6ee5');

/*!40000 ALTER TABLE `craft_commerce_ordersettings` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_commerce_orderstatus_emails
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_orderstatus_emails`;

CREATE TABLE `craft_commerce_orderstatus_emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orderStatusId` int(11) NOT NULL,
  `emailId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_commerce_orderstatus_emails_orderStatusId_fk` (`orderStatusId`),
  KEY `craft_commerce_orderstatus_emails_emailId_fk` (`emailId`),
  CONSTRAINT `craft_commerce_orderstatus_emails_emailId_fk` FOREIGN KEY (`emailId`) REFERENCES `craft_commerce_emails` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_orderstatus_emails_orderStatusId_fk` FOREIGN KEY (`orderStatusId`) REFERENCES `craft_commerce_orderstatuses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_orderstatuses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_orderstatuses`;

CREATE TABLE `craft_commerce_orderstatuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `handle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `color` enum('green','orange','red','blue','yellow','pink','purple','turquoise','light','grey','black') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'green',
  `sortOrder` int(10) DEFAULT NULL,
  `default` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_commerce_orderstatuses` WRITE;
/*!40000 ALTER TABLE `craft_commerce_orderstatuses` DISABLE KEYS */;

INSERT INTO `craft_commerce_orderstatuses` (`id`, `name`, `handle`, `color`, `sortOrder`, `default`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Processing','processing','green',999,1,'2016-08-16 21:02:39','2016-08-16 21:02:39','3b8629be-3f8a-4954-93c7-78040571c661'),
	(2,'Shipped','shipped','blue',999,0,'2016-08-16 21:02:39','2016-08-16 21:02:39','ff3fdcae-3a70-4d0f-8508-76e858c2f803');

/*!40000 ALTER TABLE `craft_commerce_orderstatuses` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_commerce_paymentmethods
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_paymentmethods`;

CREATE TABLE `craft_commerce_paymentmethods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `settings` text COLLATE utf8_unicode_ci,
  `paymentType` enum('authorize','purchase') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'purchase',
  `frontendEnabled` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `isArchived` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `dateArchived` datetime DEFAULT NULL,
  `sortOrder` int(10) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_paymentmethods_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_commerce_paymentmethods` WRITE;
/*!40000 ALTER TABLE `craft_commerce_paymentmethods` DISABLE KEYS */;

INSERT INTO `craft_commerce_paymentmethods` (`id`, `class`, `name`, `settings`, `paymentType`, `frontendEnabled`, `isArchived`, `dateArchived`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Dummy','Dummy','[]','purchase',1,0,NULL,NULL,'2016-08-16 21:02:40','2016-08-16 21:02:40','1f734830-9b37-434f-b111-8a3820f2b2fc');

/*!40000 ALTER TABLE `craft_commerce_paymentmethods` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_commerce_products
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_products`;

CREATE TABLE `craft_commerce_products` (
  `id` int(11) NOT NULL,
  `typeId` int(11) DEFAULT NULL,
  `taxCategoryId` int(11) NOT NULL,
  `postDate` datetime DEFAULT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `promotable` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `freeShipping` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `defaultVariantId` int(10) DEFAULT NULL,
  `defaultSku` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `defaultPrice` decimal(14,4) DEFAULT NULL,
  `defaultHeight` decimal(14,4) DEFAULT NULL,
  `defaultLength` decimal(14,4) DEFAULT NULL,
  `defaultWidth` decimal(14,4) DEFAULT NULL,
  `defaultWeight` decimal(14,4) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_commerce_products_typeId_idx` (`typeId`),
  KEY `craft_commerce_products_postDate_idx` (`postDate`),
  KEY `craft_commerce_products_expiryDate_idx` (`expiryDate`),
  KEY `craft_commerce_products_taxCategoryId_fk` (`taxCategoryId`),
  CONSTRAINT `craft_commerce_products_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_commerce_products_taxCategoryId_fk` FOREIGN KEY (`taxCategoryId`) REFERENCES `craft_commerce_taxcategories` (`id`),
  CONSTRAINT `craft_commerce_products_typeId_fk` FOREIGN KEY (`typeId`) REFERENCES `craft_commerce_producttypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_commerce_products` WRITE;
/*!40000 ALTER TABLE `craft_commerce_products` DISABLE KEYS */;

INSERT INTO `craft_commerce_products` (`id`, `typeId`, `taxCategoryId`, `postDate`, `expiryDate`, `promotable`, `freeShipping`, `defaultVariantId`, `defaultSku`, `defaultPrice`, `defaultHeight`, `defaultLength`, `defaultWidth`, `defaultWeight`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(4,1,1,'2016-08-16 21:02:39',NULL,1,0,5,'A New Toga',10.0000,0.0000,0.0000,0.0000,0.0000,'2016-08-16 21:02:39','2016-08-16 21:02:39','16772a0f-7593-4d75-8f14-5a16d391f9d9'),
	(6,1,1,'2016-08-16 21:02:39',NULL,1,0,7,'Parka with Stripes on Back',20.0000,0.0000,0.0000,0.0000,0.0000,'2016-08-16 21:02:39','2016-08-16 21:02:40','4afed2b8-8c23-409d-b8ea-a4fb0769b9bb'),
	(8,1,1,'2016-08-16 21:02:40',NULL,1,0,9,'Romper for a Red Eye',30.0000,0.0000,0.0000,0.0000,0.0000,'2016-08-16 21:02:40','2016-08-16 21:02:40','290ac69c-9ee3-4b0b-bfa4-85cbeed79151'),
	(10,1,1,'2016-08-16 21:02:40',NULL,1,0,11,'The Fleece Awakens',40.0000,0.0000,0.0000,0.0000,0.0000,'2016-08-16 21:02:40','2016-08-16 21:02:40','8767b2a5-cde5-4fd1-bbba-ad16c527fa05');

/*!40000 ALTER TABLE `craft_commerce_products` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_commerce_producttypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_producttypes`;

CREATE TABLE `craft_commerce_producttypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `variantFieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `handle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `hasUrls` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `hasDimensions` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `hasVariants` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `hasVariantTitleField` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `titleFormat` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `skuFormat` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `template` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_producttypes_handle_unq_idx` (`handle`),
  KEY `craft_commerce_producttypes_fieldLayoutId_fk` (`fieldLayoutId`),
  KEY `craft_commerce_producttypes_variantFieldLayoutId_fk` (`variantFieldLayoutId`),
  CONSTRAINT `craft_commerce_producttypes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `craft_commerce_producttypes_variantFieldLayoutId_fk` FOREIGN KEY (`variantFieldLayoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_commerce_producttypes` WRITE;
/*!40000 ALTER TABLE `craft_commerce_producttypes` DISABLE KEYS */;

INSERT INTO `craft_commerce_producttypes` (`id`, `fieldLayoutId`, `variantFieldLayoutId`, `name`, `handle`, `hasUrls`, `hasDimensions`, `hasVariants`, `hasVariantTitleField`, `titleFormat`, `skuFormat`, `template`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,9,10,'Clothing','clothing',1,1,0,0,'{product.title}',NULL,'commerce/products/_product','2016-08-16 21:02:39','2016-08-16 21:02:39','064582a9-f788-498e-b93c-692659ad4ee7');

/*!40000 ALTER TABLE `craft_commerce_producttypes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_commerce_producttypes_i18n
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_producttypes_i18n`;

CREATE TABLE `craft_commerce_producttypes_i18n` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `productTypeId` int(11) NOT NULL,
  `locale` char(12) COLLATE utf8_unicode_ci NOT NULL,
  `urlFormat` text COLLATE utf8_unicode_ci,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_producttypes_i18n_productTypeId_locale_unq_idx` (`productTypeId`,`locale`),
  KEY `craft_commerce_producttypes_i18n_locale_fk` (`locale`),
  CONSTRAINT `craft_commerce_producttypes_i18n_locale_fk` FOREIGN KEY (`locale`) REFERENCES `craft_locales` (`locale`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_producttypes_i18n_productTypeId_fk` FOREIGN KEY (`productTypeId`) REFERENCES `craft_commerce_producttypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_commerce_producttypes_i18n` WRITE;
/*!40000 ALTER TABLE `craft_commerce_producttypes_i18n` DISABLE KEYS */;

INSERT INTO `craft_commerce_producttypes_i18n` (`id`, `productTypeId`, `locale`, `urlFormat`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,'en_us','commerce/products/{slug}','2016-08-16 21:02:39','2016-08-16 21:02:39','16d5647f-a856-4f5b-a39e-004ce10aa414');

/*!40000 ALTER TABLE `craft_commerce_producttypes_i18n` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_commerce_purchasables
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_purchasables`;

CREATE TABLE `craft_commerce_purchasables` (
  `id` int(11) NOT NULL,
  `sku` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `price` decimal(14,4) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_purchasables_sku_unq_idx` (`sku`),
  CONSTRAINT `craft_commerce_purchasables_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_commerce_purchasables` WRITE;
/*!40000 ALTER TABLE `craft_commerce_purchasables` DISABLE KEYS */;

INSERT INTO `craft_commerce_purchasables` (`id`, `sku`, `price`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(5,'A New Toga',10.0000,'2016-08-16 21:02:39','2016-08-16 21:02:39','0a1c9a76-497f-4253-beda-d6bfb0f1ddab'),
	(7,'Parka with Stripes on Back',20.0000,'2016-08-16 21:02:40','2016-08-16 21:02:40','2b6f586f-109d-431f-a267-8a15cd7ffb28'),
	(9,'Romper for a Red Eye',30.0000,'2016-08-16 21:02:40','2016-08-16 21:02:40','53575dd8-deeb-4b3b-a3b8-e8781d950e0a'),
	(11,'The Fleece Awakens',40.0000,'2016-08-16 21:02:40','2016-08-16 21:02:40','09a96861-ffc2-4855-957c-5de257cead23');

/*!40000 ALTER TABLE `craft_commerce_purchasables` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_commerce_sale_products
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_sale_products`;

CREATE TABLE `craft_commerce_sale_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `saleId` int(10) NOT NULL,
  `productId` int(10) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_sale_products_saleId_productId_unq_idx` (`saleId`,`productId`),
  KEY `craft_commerce_sale_products_productId_fk` (`productId`),
  CONSTRAINT `craft_commerce_sale_products_productId_fk` FOREIGN KEY (`productId`) REFERENCES `craft_commerce_products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_sale_products_saleId_fk` FOREIGN KEY (`saleId`) REFERENCES `craft_commerce_sales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_sale_producttypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_sale_producttypes`;

CREATE TABLE `craft_commerce_sale_producttypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `saleId` int(10) NOT NULL,
  `productTypeId` int(10) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_sale_producttypes_saleId_productTypeId_unq_idx` (`saleId`,`productTypeId`),
  KEY `craft_commerce_sale_producttypes_productTypeId_fk` (`productTypeId`),
  CONSTRAINT `craft_commerce_sale_producttypes_productTypeId_fk` FOREIGN KEY (`productTypeId`) REFERENCES `craft_commerce_producttypes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_sale_producttypes_saleId_fk` FOREIGN KEY (`saleId`) REFERENCES `craft_commerce_sales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_sale_usergroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_sale_usergroups`;

CREATE TABLE `craft_commerce_sale_usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `saleId` int(10) NOT NULL,
  `userGroupId` int(10) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_sale_usergroups_saleId_userGroupId_unq_idx` (`saleId`,`userGroupId`),
  KEY `craft_commerce_sale_usergroups_userGroupId_fk` (`userGroupId`),
  CONSTRAINT `craft_commerce_sale_usergroups_saleId_fk` FOREIGN KEY (`saleId`) REFERENCES `craft_commerce_sales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_sale_usergroups_userGroupId_fk` FOREIGN KEY (`userGroupId`) REFERENCES `craft_usergroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_sales
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_sales`;

CREATE TABLE `craft_commerce_sales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `dateFrom` datetime DEFAULT NULL,
  `dateTo` datetime DEFAULT NULL,
  `discountType` enum('percent','flat') COLLATE utf8_unicode_ci NOT NULL,
  `discountAmount` decimal(14,4) NOT NULL,
  `allGroups` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `allProducts` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `allProductTypes` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_shippingmethods
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_shippingmethods`;

CREATE TABLE `craft_commerce_shippingmethods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `handle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_shippingmethods_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_commerce_shippingmethods` WRITE;
/*!40000 ALTER TABLE `craft_commerce_shippingmethods` DISABLE KEYS */;

INSERT INTO `craft_commerce_shippingmethods` (`id`, `name`, `handle`, `enabled`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Free Shipping','freeShipping',1,'2016-08-16 21:02:39','2016-08-16 21:02:39','8e2bc727-fa66-43c9-97da-4a25674ad0a5');

/*!40000 ALTER TABLE `craft_commerce_shippingmethods` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_commerce_shippingrules
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_shippingrules`;

CREATE TABLE `craft_commerce_shippingrules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shippingZoneId` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `methodId` int(10) NOT NULL,
  `priority` int(10) NOT NULL DEFAULT '0',
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `minQty` int(10) NOT NULL DEFAULT '0',
  `maxQty` int(10) NOT NULL DEFAULT '0',
  `minTotal` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `maxTotal` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `minWeight` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `maxWeight` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `baseRate` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `perItemRate` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `weightRate` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `percentageRate` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `minRate` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `maxRate` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_shippingrules_name_unq_idx` (`name`),
  KEY `craft_commerce_shippingrules_methodId_idx` (`methodId`),
  KEY `craft_commerce_shippingrules_shippingZoneId_fk` (`shippingZoneId`),
  CONSTRAINT `craft_commerce_shippingrules_methodId_fk` FOREIGN KEY (`methodId`) REFERENCES `craft_commerce_shippingmethods` (`id`),
  CONSTRAINT `craft_commerce_shippingrules_shippingZoneId_fk` FOREIGN KEY (`shippingZoneId`) REFERENCES `craft_commerce_shippingzones` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_commerce_shippingrules` WRITE;
/*!40000 ALTER TABLE `craft_commerce_shippingrules` DISABLE KEYS */;

INSERT INTO `craft_commerce_shippingrules` (`id`, `shippingZoneId`, `name`, `description`, `methodId`, `priority`, `enabled`, `minQty`, `maxQty`, `minTotal`, `maxTotal`, `minWeight`, `maxWeight`, `baseRate`, `perItemRate`, `weightRate`, `percentageRate`, `minRate`, `maxRate`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,NULL,'Free Everywhere ','All Countries, free shipping.',1,0,1,0,0,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,'2016-08-16 21:02:39','2016-08-16 21:02:39','d85ece58-8d62-4669-a8aa-fdf7d2183629');

/*!40000 ALTER TABLE `craft_commerce_shippingrules` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_commerce_shippingzone_countries
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_shippingzone_countries`;

CREATE TABLE `craft_commerce_shippingzone_countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shippingZoneId` int(11) NOT NULL,
  `countryId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerc_shippingzon_countrie_shippingZoneI_countryI_unq_id` (`shippingZoneId`,`countryId`),
  KEY `craft_commerce_shippingzone_countries_shippingZoneId_idx` (`shippingZoneId`),
  KEY `craft_commerce_shippingzone_countries_countryId_idx` (`countryId`),
  CONSTRAINT `craft_commerce_shippingzone_countries_countryId_fk` FOREIGN KEY (`countryId`) REFERENCES `craft_commerce_countries` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_shippingzone_countries_shippingZoneId_fk` FOREIGN KEY (`shippingZoneId`) REFERENCES `craft_commerce_shippingzones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_shippingzone_states
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_shippingzone_states`;

CREATE TABLE `craft_commerce_shippingzone_states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shippingZoneId` int(11) NOT NULL,
  `stateId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_shippingzone_states_shippingZoneId_stateId_unq_id` (`shippingZoneId`,`stateId`),
  KEY `craft_commerce_shippingzone_states_shippingZoneId_idx` (`shippingZoneId`),
  KEY `craft_commerce_shippingzone_states_stateId_idx` (`stateId`),
  CONSTRAINT `craft_commerce_shippingzone_states_shippingZoneId_fk` FOREIGN KEY (`shippingZoneId`) REFERENCES `craft_commerce_shippingzones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_shippingzone_states_stateId_fk` FOREIGN KEY (`stateId`) REFERENCES `craft_commerce_states` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_shippingzones
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_shippingzones`;

CREATE TABLE `craft_commerce_shippingzones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `countryBased` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_shippingzones_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_states
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_states`;

CREATE TABLE `craft_commerce_states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `abbreviation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `countryId` int(10) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_states_name_countryId_unq_idx` (`name`,`countryId`),
  KEY `craft_commerce_states_countryId_fk` (`countryId`),
  CONSTRAINT `craft_commerce_states_countryId_fk` FOREIGN KEY (`countryId`) REFERENCES `craft_commerce_countries` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_commerce_states` WRITE;
/*!40000 ALTER TABLE `craft_commerce_states` DISABLE KEYS */;

INSERT INTO `craft_commerce_states` (`id`, `name`, `abbreviation`, `countryId`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Australian Capital Territory','ACT',13,'2016-08-16 21:02:40','2016-08-16 21:02:40','c18b8489-abb1-49b9-8cc3-c6882df2e8c3'),
	(2,'New South Wales','NSW',13,'2016-08-16 21:02:40','2016-08-16 21:02:40','e9a42547-545a-46c1-af8f-56157a96df3b'),
	(3,'Northern Territory','NT',13,'2016-08-16 21:02:40','2016-08-16 21:02:40','9af0d9a2-7d99-410b-b7b1-7c0a57d07a18'),
	(4,'Queensland','QLD',13,'2016-08-16 21:02:40','2016-08-16 21:02:40','98b58c80-f383-4204-abce-39b48db3a7c6'),
	(5,'South Australia','SA',13,'2016-08-16 21:02:40','2016-08-16 21:02:40','77be9c22-04b0-4016-ba43-740069b9dcf7'),
	(6,'Tasmania','TAS',13,'2016-08-16 21:02:40','2016-08-16 21:02:40','5611e6d4-dd8d-469c-acb2-b7c2c5bd50ef'),
	(7,'Victoria','VIC',13,'2016-08-16 21:02:40','2016-08-16 21:02:40','67cde2d6-5be8-48c3-ade8-eca632a63ce3'),
	(8,'Western Australia','WA',13,'2016-08-16 21:02:40','2016-08-16 21:02:40','cd1d5fa6-4b5d-411c-9d70-e836e754addf'),
	(9,'Alberta','AB',38,'2016-08-16 21:02:40','2016-08-16 21:02:40','bdba7f3f-d36a-4ab8-a042-f3d836c4568c'),
	(10,'British Columbia','BC',38,'2016-08-16 21:02:40','2016-08-16 21:02:40','f3fdfc7e-5998-4fd8-b33e-471a6610cb22'),
	(11,'Manitoba','MB',38,'2016-08-16 21:02:40','2016-08-16 21:02:40','6a1cb0b6-7f6f-454f-8ea8-eb6c340013e7'),
	(12,'New Brunswick','NB',38,'2016-08-16 21:02:40','2016-08-16 21:02:40','15e5b9bc-25a2-4aba-a6f2-6e2365d4d625'),
	(13,'Newfoundland and Labrador','NL',38,'2016-08-16 21:02:40','2016-08-16 21:02:40','64891ce5-e30a-42ab-97cb-72f8b80bfbeb'),
	(14,'Northwest Territories','NT',38,'2016-08-16 21:02:40','2016-08-16 21:02:40','16ce2dc7-a23f-4397-ab64-b459fe1f820c'),
	(15,'Nova Scotia','NS',38,'2016-08-16 21:02:40','2016-08-16 21:02:40','00421807-534f-4054-ae46-6b7567820cb0'),
	(16,'Nunavut','NU',38,'2016-08-16 21:02:40','2016-08-16 21:02:40','a7c91014-cbd5-4c09-b9a1-05cdb172f802'),
	(17,'Ontario','ON',38,'2016-08-16 21:02:40','2016-08-16 21:02:40','5dd9fa1e-857a-48da-aba5-5d8dd3b40f72'),
	(18,'Prince Edward Island','PE',38,'2016-08-16 21:02:40','2016-08-16 21:02:40','23401bec-f0b4-4d34-be3b-fe9552cb04d4'),
	(19,'Quebec','QC',38,'2016-08-16 21:02:40','2016-08-16 21:02:40','4fc93f5b-c357-4a5e-9e94-7b3bae4ee002'),
	(20,'Saskatchewan','SK',38,'2016-08-16 21:02:40','2016-08-16 21:02:40','8e5242c2-102e-4af5-b4bd-f66ee2150ef5'),
	(21,'Yukon','YT',38,'2016-08-16 21:02:40','2016-08-16 21:02:40','71446c66-f2a0-42d8-ad9d-bb1be1053bef'),
	(22,'Alabama','AL',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','bf417f4d-0632-445c-b960-1df9cf0c2e05'),
	(23,'Alaska','AK',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','5046dac2-e16f-498e-960a-5bbdae6b656b'),
	(24,'Arizona','AZ',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','6ba9ee6d-ea55-477c-888b-832fb191da55'),
	(25,'Arkansas','AR',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','49736315-5061-4c44-b3c8-fa5a66d28218'),
	(26,'California','CA',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','60fe320d-056a-4d89-9e00-5367d60245c2'),
	(27,'Colorado','CO',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','f0a4f648-8cdf-4185-8036-0dc0f7094946'),
	(28,'Connecticut','CT',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','5cc0bec2-9f0b-4253-85f6-503db51a0ede'),
	(29,'Delaware','DE',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','41ede94e-3176-4ab9-8fad-5428db2b3b95'),
	(30,'District of Columbia','DC',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','88da97b5-23ff-4440-a5e4-5e669b3753c8'),
	(31,'Florida','FL',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','19bd8f65-b3f4-4aac-bffa-06de7633f4e4'),
	(32,'Georgia','GA',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','dbec9836-7c50-4558-99d7-fd7e22734d43'),
	(33,'Hawaii','HI',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','a015b3fc-e808-4b0d-8a70-f82f5c5b020f'),
	(34,'Idaho','ID',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','ed4ea416-2ea3-46f9-83e4-50e27670f4f3'),
	(35,'Illinois','IL',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','919758c6-9593-4581-9df9-2f337ecc9c6d'),
	(36,'Indiana','IN',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','9a3f00c4-96cb-4304-9cef-acf7b337c9f7'),
	(37,'Iowa','IA',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','cd02283c-076f-4e17-9a90-fa06d6156bb0'),
	(38,'Kansas','KS',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','cdf01afb-b670-44a8-afaa-b9a689160749'),
	(39,'Kentucky','KY',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','e7a5f850-cca9-4cb0-a264-29b5be7f46ce'),
	(40,'Louisiana','LA',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','84a1057b-8aae-489b-9a4c-04a11c4ade22'),
	(41,'Maine','ME',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','4b69be7f-44f0-4841-8ec6-5e6d923d719e'),
	(42,'Maryland','MD',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','7c52c37d-c467-417b-b362-6f9e3dff86e7'),
	(43,'Massachusetts','MA',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','ec9a48d0-2e37-48a5-ad22-d26f8c152aa9'),
	(44,'Michigan','MI',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','eb9dcd55-e1e5-4a1e-b0b3-2aa8fcae210c'),
	(45,'Minnesota','MN',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','39bf66f4-ef97-4fb8-8849-8bf74b7326ed'),
	(46,'Mississippi','MS',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','38f36daf-bdab-4232-8a8a-0115330138c5'),
	(47,'Missouri','MO',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','21272550-5944-4961-b3bb-a7de5d00db1a'),
	(48,'Montana','MT',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','ba25c204-ae64-441c-a9c0-8dfb21b66a3b'),
	(49,'Nebraska','NE',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','b2c881de-3f40-4205-972e-456f342cbab4'),
	(50,'Nevada','NV',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','001c358b-555a-491e-a09b-31aeb1b9e658'),
	(51,'New Hampshire','NH',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','81e91c3d-328c-4fe9-96bb-db6ec4c0e429'),
	(52,'New Jersey','NJ',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','9cdbf89e-1a8e-440d-b8cf-69192f7ed3ec'),
	(53,'New Mexico','NM',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','d451e4de-f139-42ab-87db-4e193261428d'),
	(54,'New York','NY',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','a65e6189-d1d4-4c9b-841a-fc96b3a9e8a7'),
	(55,'North Carolina','NC',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','312d03e8-e985-4e78-8c68-2f22a3f593a2'),
	(56,'North Dakota','ND',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','e5e1620d-831e-40b2-9b1b-26cc464cd36a'),
	(57,'Ohio','OH',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','0e1fc725-c880-4b56-91bb-cbe74532c743'),
	(58,'Oklahoma','OK',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','e235f678-830c-49b7-806f-823471eebb5e'),
	(59,'Oregon','OR',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','28a40125-9df5-4808-968e-6efe901ce63e'),
	(60,'Pennsylvania','PA',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','a69234ee-8c03-47e8-bd6c-e47d1b64ecc4'),
	(61,'Rhode Island','RI',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','dcc90643-949a-437c-9940-e79e2f408dc4'),
	(62,'South Carolina','SC',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','d7c06aa0-f0d7-4556-9913-2035a4e6a539'),
	(63,'South Dakota','SD',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','3c804734-4012-422c-a917-c32e21f0a851'),
	(64,'Tennessee','TN',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','763ab955-19bf-41f7-a44d-f6d1c2b553ac'),
	(65,'Texas','TX',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','afd5befa-4c5a-47a6-8ad7-925f62bb3d11'),
	(66,'Utah','UT',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','8a99b42f-0ee6-43cf-a084-3970093aac56'),
	(67,'Vermont','VT',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','64641c6f-cde2-4353-9842-d88607b0d0d8'),
	(68,'Virginia','VA',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','7ba38853-7e8c-4b9a-b977-ce6dc2f37a2c'),
	(69,'Washington','WA',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','e562d55c-bab7-410e-b315-150b8f89560f'),
	(70,'West Virginia','WV',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','10da4cc9-439f-4ff6-a07d-e414398a6731'),
	(71,'Wisconsin','WI',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','fcb98347-6c63-443b-97fa-bc363d056df0'),
	(72,'Wyoming','WY',233,'2016-08-16 21:02:40','2016-08-16 21:02:40','85bb39d9-6f05-4df6-bead-b29816804a1d');

/*!40000 ALTER TABLE `craft_commerce_states` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_commerce_taxcategories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_taxcategories`;

CREATE TABLE `craft_commerce_taxcategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `handle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `default` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_taxcategories_handle_unq_idx` (`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_commerce_taxcategories` WRITE;
/*!40000 ALTER TABLE `craft_commerce_taxcategories` DISABLE KEYS */;

INSERT INTO `craft_commerce_taxcategories` (`id`, `name`, `handle`, `description`, `default`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'General','general',NULL,1,'2016-08-16 21:02:39','2016-08-16 21:02:39','35f7c81a-27b2-43de-b193-457af8aca464');

/*!40000 ALTER TABLE `craft_commerce_taxcategories` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_commerce_taxrates
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_taxrates`;

CREATE TABLE `craft_commerce_taxrates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taxZoneId` int(11) NOT NULL,
  `taxCategoryId` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `rate` decimal(14,4) NOT NULL,
  `include` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `showInLabel` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `taxable` enum('price','shipping','price_shipping') COLLATE utf8_unicode_ci NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_commerce_taxrates_taxZoneId_idx` (`taxZoneId`),
  KEY `craft_commerce_taxrates_taxCategoryId_idx` (`taxCategoryId`),
  CONSTRAINT `craft_commerce_taxrates_taxCategoryId_fk` FOREIGN KEY (`taxCategoryId`) REFERENCES `craft_commerce_taxcategories` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_taxrates_taxZoneId_fk` FOREIGN KEY (`taxZoneId`) REFERENCES `craft_commerce_taxzones` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_taxzone_countries
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_taxzone_countries`;

CREATE TABLE `craft_commerce_taxzone_countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taxZoneId` int(11) NOT NULL,
  `countryId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_taxzone_countries_taxZoneId_countryId_unq_idx` (`taxZoneId`,`countryId`),
  KEY `craft_commerce_taxzone_countries_taxZoneId_idx` (`taxZoneId`),
  KEY `craft_commerce_taxzone_countries_countryId_idx` (`countryId`),
  CONSTRAINT `craft_commerce_taxzone_countries_countryId_fk` FOREIGN KEY (`countryId`) REFERENCES `craft_commerce_countries` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_taxzone_countries_taxZoneId_fk` FOREIGN KEY (`taxZoneId`) REFERENCES `craft_commerce_taxzones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_taxzone_states
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_taxzone_states`;

CREATE TABLE `craft_commerce_taxzone_states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taxZoneId` int(11) NOT NULL,
  `stateId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_taxzone_states_taxZoneId_stateId_unq_idx` (`taxZoneId`,`stateId`),
  KEY `craft_commerce_taxzone_states_taxZoneId_idx` (`taxZoneId`),
  KEY `craft_commerce_taxzone_states_stateId_idx` (`stateId`),
  CONSTRAINT `craft_commerce_taxzone_states_stateId_fk` FOREIGN KEY (`stateId`) REFERENCES `craft_commerce_states` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_taxzone_states_taxZoneId_fk` FOREIGN KEY (`taxZoneId`) REFERENCES `craft_commerce_taxzones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_taxzones
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_taxzones`;

CREATE TABLE `craft_commerce_taxzones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `countryBased` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `default` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_taxzones_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_transactions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_transactions`;

CREATE TABLE `craft_commerce_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentId` int(11) DEFAULT NULL,
  `paymentMethodId` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `hash` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` enum('authorize','capture','purchase','refund') COLLATE utf8_unicode_ci NOT NULL,
  `amount` decimal(17,4) DEFAULT NULL,
  `status` enum('pending','redirect','success','failed') COLLATE utf8_unicode_ci NOT NULL,
  `reference` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8_unicode_ci,
  `response` text COLLATE utf8_unicode_ci,
  `orderId` int(10) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_commerce_transactions_parentId_fk` (`parentId`),
  KEY `craft_commerce_transactions_paymentMethodId_fk` (`paymentMethodId`),
  KEY `craft_commerce_transactions_orderId_fk` (`orderId`),
  KEY `craft_commerce_transactions_userId_fk` (`userId`),
  CONSTRAINT `craft_commerce_transactions_orderId_fk` FOREIGN KEY (`orderId`) REFERENCES `craft_commerce_orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_commerce_transactions_parentId_fk` FOREIGN KEY (`parentId`) REFERENCES `craft_commerce_transactions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_transactions_paymentMethodId_fk` FOREIGN KEY (`paymentMethodId`) REFERENCES `craft_commerce_paymentmethods` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `craft_commerce_transactions_userId_fk` FOREIGN KEY (`userId`) REFERENCES `craft_users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_commerce_variants
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_commerce_variants`;

CREATE TABLE `craft_commerce_variants` (
  `productId` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `sku` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `isDefault` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `price` decimal(14,4) NOT NULL,
  `sortOrder` int(10) DEFAULT NULL,
  `width` decimal(14,4) DEFAULT NULL,
  `height` decimal(14,4) DEFAULT NULL,
  `length` decimal(14,4) DEFAULT NULL,
  `weight` decimal(14,4) DEFAULT NULL,
  `stock` int(10) NOT NULL DEFAULT '0',
  `unlimitedStock` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `minQty` int(10) DEFAULT NULL,
  `maxQty` int(10) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_commerce_variants_sku_unq_idx` (`sku`),
  KEY `craft_commerce_variants_productId_fk` (`productId`),
  CONSTRAINT `craft_commerce_variants_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_commerce_variants_productId_fk` FOREIGN KEY (`productId`) REFERENCES `craft_commerce_products` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_commerce_variants` WRITE;
/*!40000 ALTER TABLE `craft_commerce_variants` DISABLE KEYS */;

INSERT INTO `craft_commerce_variants` (`productId`, `id`, `sku`, `isDefault`, `price`, `sortOrder`, `width`, `height`, `length`, `weight`, `stock`, `unlimitedStock`, `minQty`, `maxQty`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(4,5,'A New Toga',1,10.0000,NULL,0.0000,0.0000,0.0000,0.0000,0,1,NULL,NULL,'2016-08-16 21:02:39','2016-08-16 21:02:39','e8df31b5-fd02-41f6-9de5-408cb6c72d5c'),
	(6,7,'Parka with Stripes on Back',1,20.0000,NULL,0.0000,0.0000,0.0000,0.0000,0,1,NULL,NULL,'2016-08-16 21:02:40','2016-08-16 21:02:40','105f0ca5-e7ea-4960-a292-576567a33e40'),
	(8,9,'Romper for a Red Eye',1,30.0000,NULL,0.0000,0.0000,0.0000,0.0000,0,1,NULL,NULL,'2016-08-16 21:02:40','2016-08-16 21:02:40','c7cc6622-b78c-4c0a-8ce1-0ab08cb1257c'),
	(10,11,'The Fleece Awakens',1,40.0000,NULL,0.0000,0.0000,0.0000,0.0000,0,1,NULL,NULL,'2016-08-16 21:02:40','2016-08-16 21:02:40','0e1834b9-0aa5-4779-bfc5-0839dd77e605');

/*!40000 ALTER TABLE `craft_commerce_variants` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_content
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_content`;

CREATE TABLE `craft_content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `locale` char(12) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field_body` text COLLATE utf8_unicode_ci,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_content_elementId_locale_unq_idx` (`elementId`,`locale`),
  KEY `craft_content_title_idx` (`title`),
  KEY `craft_content_locale_fk` (`locale`),
  CONSTRAINT `craft_content_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_content_locale_fk` FOREIGN KEY (`locale`) REFERENCES `craft_locales` (`locale`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_content` WRITE;
/*!40000 ALTER TABLE `craft_content` DISABLE KEYS */;

INSERT INTO `craft_content` (`id`, `elementId`, `locale`, `title`, `field_body`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,'en_us',NULL,NULL,'2016-08-04 22:18:04','2016-08-04 22:18:04','b4852cb2-81fc-4b69-a3b5-cc01860b8a23'),
	(2,2,'en_us','Welcome to Greenhorn.dev!','<p>It’s true, this site doesn’t have a whole lot of content yet, but don’t worry. Our web developers have just installed the CMS, and they’re setting things up for the content editors this very moment. Soon Greenhorn.dev will be an oasis of fresh perspectives, sharp analyses, and astute opinions that will keep you coming back again and again.</p>','2016-08-04 22:18:06','2016-08-04 22:18:06','cb23cf84-e578-429c-9d9e-8a4979ed7365'),
	(3,3,'en_us','We just installed Craft!','<p>Craft is the CMS that’s powering Greenhorn.dev. It’s beautiful, powerful, flexible, and easy-to-use, and it’s made by Pixel &amp; Tonic. We can’t wait to dive in and see what it’s capable of!</p><!--pagebreak--><p>This is even more captivating content, which you couldn’t see on the News index page because it was entered after a Page Break, and the News index template only likes to show the content on the first page.</p><p>Craft: a nice alternative to Word, if you’re making a website.</p>','2016-08-04 22:18:06','2016-08-04 22:18:06','b45bebd8-a838-40ac-9037-43dfec36c0ec'),
	(4,4,'en_us','A New Toga',NULL,'2016-08-16 21:02:39','2016-08-16 21:02:39','55cad2b4-604c-49ef-94b3-8b8211ebcd1c'),
	(5,5,'en_us','A New Toga',NULL,'2016-08-16 21:02:39','2016-08-16 21:02:39','63c4935c-4a1a-41e4-81d3-436725a58d94'),
	(6,6,'en_us','Parka with Stripes on Back',NULL,'2016-08-16 21:02:39','2016-08-16 21:02:39','a172a1e6-ba91-4ca9-b37d-da9b7864c4c9'),
	(7,7,'en_us','Parka with Stripes on Back',NULL,'2016-08-16 21:02:39','2016-08-16 21:02:39','8483eb6c-5397-4a32-a0a1-78384e0206c1'),
	(8,8,'en_us','Romper for a Red Eye',NULL,'2016-08-16 21:02:40','2016-08-16 21:02:40','8ea75cdc-2267-4690-a142-6d855200bc15'),
	(9,9,'en_us','Romper for a Red Eye',NULL,'2016-08-16 21:02:40','2016-08-16 21:02:40','79355e18-c657-423b-941a-ba334d2e5f55'),
	(10,10,'en_us','The Fleece Awakens',NULL,'2016-08-16 21:02:40','2016-08-16 21:02:40','00f5a396-c6da-4d11-8275-4d20c65cd57a'),
	(11,11,'en_us','The Fleece Awakens',NULL,'2016-08-16 21:02:40','2016-08-16 21:02:40','d3243399-41f5-4043-8705-2a7985851250');

/*!40000 ALTER TABLE `craft_content` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_deprecationerrors
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_deprecationerrors`;

CREATE TABLE `craft_deprecationerrors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `fingerprint` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `lastOccurrence` datetime NOT NULL,
  `file` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `line` smallint(6) unsigned NOT NULL,
  `class` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `method` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `template` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `templateLine` smallint(6) unsigned DEFAULT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `traces` text COLLATE utf8_unicode_ci,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_deprecationerrors_key_fingerprint_unq_idx` (`key`,`fingerprint`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_elementindexsettings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_elementindexsettings`;

CREATE TABLE `craft_elementindexsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `settings` text COLLATE utf8_unicode_ci,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_elementindexsettings_type_unq_idx` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_elements
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_elements`;

CREATE TABLE `craft_elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `archived` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_elements_type_idx` (`type`),
  KEY `craft_elements_enabled_idx` (`enabled`),
  KEY `craft_elements_archived_dateCreated_idx` (`archived`,`dateCreated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_elements` WRITE;
/*!40000 ALTER TABLE `craft_elements` DISABLE KEYS */;

INSERT INTO `craft_elements` (`id`, `type`, `enabled`, `archived`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'User',1,0,'2016-08-04 22:18:04','2016-08-04 22:18:04','7930510a-052d-4238-bbaa-565e58f11d08'),
	(2,'Entry',1,0,'2016-08-04 22:18:06','2016-08-04 22:18:06','9c346626-5d18-45ec-aba1-4110a6764d58'),
	(3,'Entry',1,0,'2016-08-04 22:18:06','2016-08-04 22:18:06','53495d51-c983-431e-8d81-6f072ab4d133'),
	(4,'Commerce_Product',1,0,'2016-08-16 21:02:39','2016-08-16 21:02:39','2e6888b4-1435-4e92-a2e9-b3be1e80dea0'),
	(5,'Commerce_Variant',1,0,'2016-08-16 21:02:39','2016-08-16 21:02:39','13d152ca-ed69-483d-87da-cb058b0abf2c'),
	(6,'Commerce_Product',1,0,'2016-08-16 21:02:39','2016-08-16 21:02:39','b0c36368-570e-4533-ab6c-5f7d0ffbfd22'),
	(7,'Commerce_Variant',1,0,'2016-08-16 21:02:39','2016-08-16 21:02:39','08f3aa79-5d8c-45cf-b00b-ff4cd7ba5597'),
	(8,'Commerce_Product',1,0,'2016-08-16 21:02:40','2016-08-16 21:02:40','afeffc00-b56c-4a04-b2f0-7a6ecb802b26'),
	(9,'Commerce_Variant',1,0,'2016-08-16 21:02:40','2016-08-16 21:02:40','7a11b77c-cd21-444a-aa54-43ca64569ea2'),
	(10,'Commerce_Product',1,0,'2016-08-16 21:02:40','2016-08-16 21:02:40','d5be2dfa-61f8-4ba4-bcf3-dafc3c46c902'),
	(11,'Commerce_Variant',1,0,'2016-08-16 21:02:40','2016-08-16 21:02:40','a2bcd855-4843-4788-9770-87692bd00b41');

/*!40000 ALTER TABLE `craft_elements` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_elements_i18n
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_elements_i18n`;

CREATE TABLE `craft_elements_i18n` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `locale` char(12) COLLATE utf8_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `uri` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_elements_i18n_elementId_locale_unq_idx` (`elementId`,`locale`),
  UNIQUE KEY `craft_elements_i18n_uri_locale_unq_idx` (`uri`,`locale`),
  KEY `craft_elements_i18n_slug_locale_idx` (`slug`,`locale`),
  KEY `craft_elements_i18n_enabled_idx` (`enabled`),
  KEY `craft_elements_i18n_locale_fk` (`locale`),
  CONSTRAINT `craft_elements_i18n_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_elements_i18n_locale_fk` FOREIGN KEY (`locale`) REFERENCES `craft_locales` (`locale`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_elements_i18n` WRITE;
/*!40000 ALTER TABLE `craft_elements_i18n` DISABLE KEYS */;

INSERT INTO `craft_elements_i18n` (`id`, `elementId`, `locale`, `slug`, `uri`, `enabled`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,'en_us','',NULL,1,'2016-08-04 22:18:04','2016-08-04 22:18:04','410e25ac-9144-4c89-9161-b7ffe2251260'),
	(2,2,'en_us','homepage','__home__',1,'2016-08-04 22:18:06','2016-08-04 22:18:06','73d53fcb-eaa0-43fa-adbf-cb278274da91'),
	(3,3,'en_us','we-just-installed-craft','news/2016/we-just-installed-craft',1,'2016-08-04 22:18:06','2016-08-04 22:18:06','540dc09e-9920-48fe-a9f4-d16802a7863b'),
	(4,4,'en_us','a-new-toga','commerce/products/a-new-toga',1,'2016-08-16 21:02:39','2016-08-16 21:02:39','e36cf59c-320e-4b91-a6c7-7b1e6f725404'),
	(5,5,'en_us','a-new-toga',NULL,1,'2016-08-16 21:02:39','2016-08-16 21:02:39','467b8fa3-e7bd-406e-9821-de1db2996283'),
	(6,6,'en_us','parka-with-stripes-on-back','commerce/products/parka-with-stripes-on-back',1,'2016-08-16 21:02:39','2016-08-16 21:02:39','c9d498e2-f8c8-409d-95f4-53a4d1901ccd'),
	(7,7,'en_us','parka-with-stripes-on-back',NULL,1,'2016-08-16 21:02:39','2016-08-16 21:02:39','629b456c-abaa-455c-8d1a-d086a7309e9c'),
	(8,8,'en_us','romper-for-a-red-eye','commerce/products/romper-for-a-red-eye',1,'2016-08-16 21:02:40','2016-08-16 21:02:40','6c6f1805-1e6e-4810-8dbf-984d75126dc7'),
	(9,9,'en_us','romper-for-a-red-eye',NULL,1,'2016-08-16 21:02:40','2016-08-16 21:02:40','608d4967-7c62-4303-b6d7-789bf19de009'),
	(10,10,'en_us','the-fleece-awakens','commerce/products/the-fleece-awakens',1,'2016-08-16 21:02:40','2016-08-16 21:02:40','54706012-165b-473d-9811-579df7d1b86b'),
	(11,11,'en_us','the-fleece-awakens',NULL,1,'2016-08-16 21:02:40','2016-08-16 21:02:40','419b2540-4bd4-4424-8665-98c4a35c6527');

/*!40000 ALTER TABLE `craft_elements_i18n` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_emailmessages
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_emailmessages`;

CREATE TABLE `craft_emailmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` char(150) COLLATE utf8_unicode_ci NOT NULL,
  `locale` char(12) COLLATE utf8_unicode_ci NOT NULL,
  `subject` varchar(1000) COLLATE utf8_unicode_ci NOT NULL,
  `body` text COLLATE utf8_unicode_ci NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_emailmessages_key_locale_unq_idx` (`key`,`locale`),
  KEY `craft_emailmessages_locale_fk` (`locale`),
  CONSTRAINT `craft_emailmessages_locale_fk` FOREIGN KEY (`locale`) REFERENCES `craft_locales` (`locale`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_entries
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_entries`;

CREATE TABLE `craft_entries` (
  `id` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `typeId` int(11) DEFAULT NULL,
  `authorId` int(11) DEFAULT NULL,
  `postDate` datetime DEFAULT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_entries_sectionId_idx` (`sectionId`),
  KEY `craft_entries_typeId_idx` (`typeId`),
  KEY `craft_entries_postDate_idx` (`postDate`),
  KEY `craft_entries_expiryDate_idx` (`expiryDate`),
  KEY `craft_entries_authorId_fk` (`authorId`),
  CONSTRAINT `craft_entries_authorId_fk` FOREIGN KEY (`authorId`) REFERENCES `craft_users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_entries_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_entries_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `craft_sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_entries_typeId_fk` FOREIGN KEY (`typeId`) REFERENCES `craft_entrytypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_entries` WRITE;
/*!40000 ALTER TABLE `craft_entries` DISABLE KEYS */;

INSERT INTO `craft_entries` (`id`, `sectionId`, `typeId`, `authorId`, `postDate`, `expiryDate`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(2,1,NULL,NULL,'2016-08-04 22:18:06',NULL,'2016-08-04 22:18:06','2016-08-04 22:18:06','3649d7b4-a370-4be2-a3b1-8452d9e49cd9'),
	(3,2,2,1,'2016-08-04 22:18:06',NULL,'2016-08-04 22:18:06','2016-08-04 22:18:06','5e312554-f1e2-4887-8fb8-60c0a41c3708');

/*!40000 ALTER TABLE `craft_entries` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_entrydrafts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_entrydrafts`;

CREATE TABLE `craft_entrydrafts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `creatorId` int(11) NOT NULL,
  `locale` char(12) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `notes` tinytext COLLATE utf8_unicode_ci,
  `data` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_entrydrafts_entryId_locale_idx` (`entryId`,`locale`),
  KEY `craft_entrydrafts_sectionId_fk` (`sectionId`),
  KEY `craft_entrydrafts_creatorId_fk` (`creatorId`),
  KEY `craft_entrydrafts_locale_fk` (`locale`),
  CONSTRAINT `craft_entrydrafts_creatorId_fk` FOREIGN KEY (`creatorId`) REFERENCES `craft_users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_entrydrafts_entryId_fk` FOREIGN KEY (`entryId`) REFERENCES `craft_entries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_entrydrafts_locale_fk` FOREIGN KEY (`locale`) REFERENCES `craft_locales` (`locale`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_entrydrafts_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `craft_sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_entrytypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_entrytypes`;

CREATE TABLE `craft_entrytypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sectionId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `handle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `hasTitleField` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `titleLabel` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'Title',
  `titleFormat` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_entrytypes_name_sectionId_unq_idx` (`name`,`sectionId`),
  UNIQUE KEY `craft_entrytypes_handle_sectionId_unq_idx` (`handle`,`sectionId`),
  KEY `craft_entrytypes_sectionId_fk` (`sectionId`),
  KEY `craft_entrytypes_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `craft_entrytypes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `craft_entrytypes_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `craft_sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_entrytypes` WRITE;
/*!40000 ALTER TABLE `craft_entrytypes` DISABLE KEYS */;

INSERT INTO `craft_entrytypes` (`id`, `sectionId`, `fieldLayoutId`, `name`, `handle`, `hasTitleField`, `titleLabel`, `titleFormat`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,3,'Homepage','homepage',1,'Title',NULL,NULL,'2016-08-04 22:18:06','2016-08-04 22:18:06','5b3d91fd-0286-420d-9d7a-7bfa7b03f833'),
	(2,2,5,'News','news',1,'Title',NULL,NULL,'2016-08-04 22:18:06','2016-08-04 22:18:06','bcefc717-2d90-4668-b9c5-25b1810cfbc8');

/*!40000 ALTER TABLE `craft_entrytypes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_entryversions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_entryversions`;

CREATE TABLE `craft_entryversions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `creatorId` int(11) DEFAULT NULL,
  `locale` char(12) COLLATE utf8_unicode_ci NOT NULL,
  `num` smallint(6) unsigned NOT NULL,
  `notes` tinytext COLLATE utf8_unicode_ci,
  `data` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_entryversions_entryId_locale_idx` (`entryId`,`locale`),
  KEY `craft_entryversions_sectionId_fk` (`sectionId`),
  KEY `craft_entryversions_creatorId_fk` (`creatorId`),
  KEY `craft_entryversions_locale_fk` (`locale`),
  CONSTRAINT `craft_entryversions_creatorId_fk` FOREIGN KEY (`creatorId`) REFERENCES `craft_users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `craft_entryversions_entryId_fk` FOREIGN KEY (`entryId`) REFERENCES `craft_entries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_entryversions_locale_fk` FOREIGN KEY (`locale`) REFERENCES `craft_locales` (`locale`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_entryversions_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `craft_sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_entryversions` WRITE;
/*!40000 ALTER TABLE `craft_entryversions` DISABLE KEYS */;

INSERT INTO `craft_entryversions` (`id`, `entryId`, `sectionId`, `creatorId`, `locale`, `num`, `notes`, `data`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,2,1,1,'en_us',1,NULL,'{\"typeId\":\"1\",\"authorId\":null,\"title\":\"Homepage\",\"slug\":\"homepage\",\"postDate\":1470349086,\"expiryDate\":null,\"enabled\":1,\"parentId\":null,\"fields\":[]}','2016-08-04 22:18:06','2016-08-04 22:18:06','86ebb012-46ce-4f94-8f36-626df3f262d8'),
	(2,2,1,1,'en_us',2,NULL,'{\"typeId\":null,\"authorId\":null,\"title\":\"Welcome to Greenhorn.dev!\",\"slug\":\"homepage\",\"postDate\":1470349086,\"expiryDate\":null,\"enabled\":\"1\",\"parentId\":null,\"fields\":{\"1\":\"<p>It\\u2019s true, this site doesn\\u2019t have a whole lot of content yet, but don\\u2019t worry. Our web developers have just installed the CMS, and they\\u2019re setting things up for the content editors this very moment. Soon Greenhorn.dev will be an oasis of fresh perspectives, sharp analyses, and astute opinions that will keep you coming back again and again.<\\/p>\"}}','2016-08-04 22:18:06','2016-08-04 22:18:06','9d64a107-1db3-46fd-a1e0-c46343280828'),
	(3,3,2,1,'en_us',1,NULL,'{\"typeId\":\"2\",\"authorId\":\"1\",\"title\":\"We just installed Craft!\",\"slug\":\"we-just-installed-craft\",\"postDate\":1470349086,\"expiryDate\":null,\"enabled\":1,\"parentId\":null,\"fields\":[]}','2016-08-04 22:18:06','2016-08-04 22:18:06','6f2082d4-715f-4052-81de-9261d91c99c6');

/*!40000 ALTER TABLE `craft_entryversions` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_fieldgroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_fieldgroups`;

CREATE TABLE `craft_fieldgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_fieldgroups_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_fieldgroups` WRITE;
/*!40000 ALTER TABLE `craft_fieldgroups` DISABLE KEYS */;

INSERT INTO `craft_fieldgroups` (`id`, `name`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Default','2016-08-04 22:18:06','2016-08-04 22:18:06','c8e4e306-ccec-4d45-acef-0af31ab46749');

/*!40000 ALTER TABLE `craft_fieldgroups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_fieldlayoutfields
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_fieldlayoutfields`;

CREATE TABLE `craft_fieldlayoutfields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `layoutId` int(11) NOT NULL,
  `tabId` int(11) NOT NULL,
  `fieldId` int(11) NOT NULL,
  `required` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_fieldlayoutfields_layoutId_fieldId_unq_idx` (`layoutId`,`fieldId`),
  KEY `craft_fieldlayoutfields_sortOrder_idx` (`sortOrder`),
  KEY `craft_fieldlayoutfields_tabId_fk` (`tabId`),
  KEY `craft_fieldlayoutfields_fieldId_fk` (`fieldId`),
  CONSTRAINT `craft_fieldlayoutfields_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `craft_fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_fieldlayoutfields_layoutId_fk` FOREIGN KEY (`layoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_fieldlayoutfields_tabId_fk` FOREIGN KEY (`tabId`) REFERENCES `craft_fieldlayouttabs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_fieldlayoutfields` WRITE;
/*!40000 ALTER TABLE `craft_fieldlayoutfields` DISABLE KEYS */;

INSERT INTO `craft_fieldlayoutfields` (`id`, `layoutId`, `tabId`, `fieldId`, `required`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,3,1,1,1,1,'2016-08-04 22:18:06','2016-08-04 22:18:06','c085c303-a708-4887-afbe-0597e1122371'),
	(2,5,2,1,1,1,'2016-08-04 22:18:06','2016-08-04 22:18:06','d0bee922-20aa-4113-ad7e-31e00f2f975c'),
	(3,5,2,2,0,2,'2016-08-04 22:18:06','2016-08-04 22:18:06','62f60a1b-da84-46ac-87ba-64397c56f0cf');

/*!40000 ALTER TABLE `craft_fieldlayoutfields` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_fieldlayouts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_fieldlayouts`;

CREATE TABLE `craft_fieldlayouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_fieldlayouts_type_idx` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_fieldlayouts` WRITE;
/*!40000 ALTER TABLE `craft_fieldlayouts` DISABLE KEYS */;

INSERT INTO `craft_fieldlayouts` (`id`, `type`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Tag','2016-08-04 22:18:06','2016-08-04 22:18:06','c8fd8288-b1f4-4a40-985e-3ec2a5bf553b'),
	(3,'Entry','2016-08-04 22:18:06','2016-08-04 22:18:06','f8637e9b-4a3f-45e3-bf48-1e45f24d0d93'),
	(5,'Entry','2016-08-04 22:18:06','2016-08-04 22:18:06','6e052e48-7323-400a-9ba9-b534ad9c8740'),
	(6,'Commerce_Order','2016-08-16 21:02:39','2016-08-16 21:02:39','1361b614-d9c5-402f-9581-6db6c726351e'),
	(7,'Commerce_Product','2016-08-16 21:02:39','2016-08-16 21:02:39','00d9e5ef-9f3e-4d87-8b7a-b06757b60891'),
	(8,'Commerce_Variant','2016-08-16 21:02:39','2016-08-16 21:02:39','4ee1c537-3a79-4553-85b2-d9fdab7df6f1'),
	(9,'Commerce_Product','2016-08-16 21:02:39','2016-08-16 21:02:39','ce7d6f25-8e7b-4ccf-b45e-71ae0b741668'),
	(10,'Commerce_Variant','2016-08-16 21:02:39','2016-08-16 21:02:39','19b56ced-136d-4e2b-b9df-cfb733955ec3');

/*!40000 ALTER TABLE `craft_fieldlayouts` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_fieldlayouttabs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_fieldlayouttabs`;

CREATE TABLE `craft_fieldlayouttabs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `layoutId` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_fieldlayouttabs_sortOrder_idx` (`sortOrder`),
  KEY `craft_fieldlayouttabs_layoutId_fk` (`layoutId`),
  CONSTRAINT `craft_fieldlayouttabs_layoutId_fk` FOREIGN KEY (`layoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_fieldlayouttabs` WRITE;
/*!40000 ALTER TABLE `craft_fieldlayouttabs` DISABLE KEYS */;

INSERT INTO `craft_fieldlayouttabs` (`id`, `layoutId`, `name`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,3,'Content',1,'2016-08-04 22:18:06','2016-08-04 22:18:06','3bb5c2c7-a135-4548-9c21-4b7a384269ae'),
	(2,5,'Content',1,'2016-08-04 22:18:06','2016-08-04 22:18:06','787a4fd1-2e3e-4093-a383-4ebdaa768754');

/*!40000 ALTER TABLE `craft_fieldlayouttabs` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_fields
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_fields`;

CREATE TABLE `craft_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `handle` varchar(58) COLLATE utf8_unicode_ci NOT NULL,
  `context` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'global',
  `instructions` text COLLATE utf8_unicode_ci,
  `translatable` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `type` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `settings` text COLLATE utf8_unicode_ci,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_fields_handle_context_unq_idx` (`handle`,`context`),
  KEY `craft_fields_context_idx` (`context`),
  KEY `craft_fields_groupId_fk` (`groupId`),
  CONSTRAINT `craft_fields_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `craft_fieldgroups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_fields` WRITE;
/*!40000 ALTER TABLE `craft_fields` DISABLE KEYS */;

INSERT INTO `craft_fields` (`id`, `groupId`, `name`, `handle`, `context`, `instructions`, `translatable`, `type`, `settings`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,'Body','body','global',NULL,1,'RichText','{\"configFile\":\"Standard.json\",\"columnType\":\"text\"}','2016-08-04 22:18:06','2016-08-04 22:18:06','d51b19f9-56f3-4982-b971-b95bcfc09a1e'),
	(2,1,'Tags','tags','global',NULL,0,'Tags','{\"source\":\"taggroup:1\"}','2016-08-04 22:18:06','2016-08-04 22:18:06','9f2cf121-1405-413d-8e4b-1c1594e75f49');

/*!40000 ALTER TABLE `craft_fields` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_globalsets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_globalsets`;

CREATE TABLE `craft_globalsets` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `handle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `fieldLayoutId` int(10) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_globalsets_name_unq_idx` (`name`),
  UNIQUE KEY `craft_globalsets_handle_unq_idx` (`handle`),
  KEY `craft_globalsets_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `craft_globalsets_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `craft_globalsets_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_info
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_info`;

CREATE TABLE `craft_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `build` int(11) unsigned NOT NULL,
  `schemaVersion` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `releaseDate` datetime NOT NULL,
  `edition` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `siteName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `siteUrl` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `timezone` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `on` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `maintenance` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `track` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_info` WRITE;
/*!40000 ALTER TABLE `craft_info` DISABLE KEYS */;

INSERT INTO `craft_info` (`id`, `version`, `build`, `schemaVersion`, `releaseDate`, `edition`, `siteName`, `siteUrl`, `timezone`, `on`, `maintenance`, `track`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'2.6',2903,'2.6.5','2016-08-02 23:22:42',0,'Greenhorn','http://greenhorn.dev','UTC',1,0,'stable','2016-08-04 22:18:01','2016-08-04 22:18:01','f761274b-55e2-46df-8828-62495c415b31');

/*!40000 ALTER TABLE `craft_info` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_locales
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_locales`;

CREATE TABLE `craft_locales` (
  `locale` char(12) COLLATE utf8_unicode_ci NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`locale`),
  KEY `craft_locales_sortOrder_idx` (`sortOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_locales` WRITE;
/*!40000 ALTER TABLE `craft_locales` DISABLE KEYS */;

INSERT INTO `craft_locales` (`locale`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	('en_us',1,'2016-08-04 22:18:01','2016-08-04 22:18:01','bb016845-814c-4f74-be50-5fa741f1bc35');

/*!40000 ALTER TABLE `craft_locales` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_matrixblocks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_matrixblocks`;

CREATE TABLE `craft_matrixblocks` (
  `id` int(11) NOT NULL,
  `ownerId` int(11) NOT NULL,
  `fieldId` int(11) NOT NULL,
  `typeId` int(11) DEFAULT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `ownerLocale` char(12) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_matrixblocks_ownerId_idx` (`ownerId`),
  KEY `craft_matrixblocks_fieldId_idx` (`fieldId`),
  KEY `craft_matrixblocks_typeId_idx` (`typeId`),
  KEY `craft_matrixblocks_sortOrder_idx` (`sortOrder`),
  KEY `craft_matrixblocks_ownerLocale_fk` (`ownerLocale`),
  CONSTRAINT `craft_matrixblocks_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `craft_fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_matrixblocks_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_matrixblocks_ownerId_fk` FOREIGN KEY (`ownerId`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_matrixblocks_ownerLocale_fk` FOREIGN KEY (`ownerLocale`) REFERENCES `craft_locales` (`locale`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_matrixblocks_typeId_fk` FOREIGN KEY (`typeId`) REFERENCES `craft_matrixblocktypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_matrixblocktypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_matrixblocktypes`;

CREATE TABLE `craft_matrixblocktypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `handle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_matrixblocktypes_name_fieldId_unq_idx` (`name`,`fieldId`),
  UNIQUE KEY `craft_matrixblocktypes_handle_fieldId_unq_idx` (`handle`,`fieldId`),
  KEY `craft_matrixblocktypes_fieldId_fk` (`fieldId`),
  KEY `craft_matrixblocktypes_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `craft_matrixblocktypes_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `craft_fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_matrixblocktypes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_migrations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_migrations`;

CREATE TABLE `craft_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pluginId` int(11) DEFAULT NULL,
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `applyTime` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_migrations_version_unq_idx` (`version`),
  KEY `craft_migrations_pluginId_fk` (`pluginId`),
  CONSTRAINT `craft_migrations_pluginId_fk` FOREIGN KEY (`pluginId`) REFERENCES `craft_plugins` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_migrations` WRITE;
/*!40000 ALTER TABLE `craft_migrations` DISABLE KEYS */;

INSERT INTO `craft_migrations` (`id`, `pluginId`, `version`, `applyTime`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,NULL,'m000000_000000_base','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','9212a03b-dd01-4c0c-aad3-8c1a88311094'),
	(2,NULL,'m140730_000001_add_filename_and_format_to_transformindex','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','c5089878-55bd-46c7-b334-b9ce37f6d8d7'),
	(3,NULL,'m140815_000001_add_format_to_transforms','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','63e469cc-d3bb-4594-aa8b-b634c319aba7'),
	(4,NULL,'m140822_000001_allow_more_than_128_items_per_field','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','b27f9de4-c841-409c-9f54-ee18a6d25f82'),
	(5,NULL,'m140829_000001_single_title_formats','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','7cac1c20-f6d4-46eb-9d94-49454eaf8c3d'),
	(6,NULL,'m140831_000001_extended_cache_keys','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','b2b25208-978e-46c5-afec-af1b5ddb78aa'),
	(7,NULL,'m140922_000001_delete_orphaned_matrix_blocks','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','8cc563b2-23f2-439c-aa79-3fdd189c9dcd'),
	(8,NULL,'m141008_000001_elements_index_tune','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','706f851d-1e57-4e7d-a53e-062f6953c70f'),
	(9,NULL,'m141009_000001_assets_source_handle','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','9e10f872-b3c4-4c42-9d25-f348c33b5d94'),
	(10,NULL,'m141024_000001_field_layout_tabs','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','88988d06-52a5-4ce4-8f9c-99bad1fe49c0'),
	(11,NULL,'m141030_000000_plugin_schema_versions','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','5346587b-0a04-4807-b430-b90bd1aa4a65'),
	(12,NULL,'m141030_000001_drop_structure_move_permission','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','c7de834d-e490-43a2-a6a5-3420982d1f35'),
	(13,NULL,'m141103_000001_tag_titles','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','27362829-424c-4c60-8ce6-382f9bc2b5ec'),
	(14,NULL,'m141109_000001_user_status_shuffle','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','b3610af3-8a5c-4bca-b679-cdd67df707da'),
	(15,NULL,'m141126_000001_user_week_start_day','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','34b8f855-eebb-4b00-af8a-00f5510b6e3c'),
	(16,NULL,'m150210_000001_adjust_user_photo_size','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','2c3b7170-0917-4e20-8567-138de1e77793'),
	(17,NULL,'m150724_000001_adjust_quality_settings','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','7b6b34e9-befa-4b8d-8b7c-7b6ea9096d5d'),
	(18,NULL,'m150827_000000_element_index_settings','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','09b0d930-70ac-4609-b6e0-4614500be0f3'),
	(19,NULL,'m150918_000001_add_colspan_to_widgets','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','78f3ed73-ee46-4e5a-962c-f027a3dfd296'),
	(20,NULL,'m151007_000000_clear_asset_caches','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','dda43078-0cf3-4397-9678-20b02edf172c'),
	(21,NULL,'m151109_000000_text_url_formats','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','b4eb4c97-0322-4394-8e09-2bb7a85dd1a4'),
	(22,NULL,'m151110_000000_move_logo','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','90e44ecc-067f-40d2-81e9-557c27e49082'),
	(23,NULL,'m151117_000000_adjust_image_widthheight','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','b439f2f2-c822-44b9-961d-baed60bd978d'),
	(24,NULL,'m151127_000000_clear_license_key_status','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','5ca22e61-d94a-45a9-8c59-fb7429cbd2a9'),
	(25,NULL,'m151127_000000_plugin_license_keys','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','e4a09c09-9c65-4910-af22-611ff61afdc9'),
	(26,NULL,'m151130_000000_update_pt_widget_feeds','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','22e79a72-9f29-472e-aaa0-21e53812f011'),
	(27,NULL,'m160114_000000_asset_sources_public_url_default_true','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','efbf9366-defe-4149-9d95-1038b2534a7d'),
	(28,NULL,'m160223_000000_sortorder_to_smallint','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','b422b1fa-c9c1-4e34-8a8d-6f16d79c3684'),
	(29,NULL,'m160229_000000_set_default_entry_statuses','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','1d451659-bf08-4b3a-b4d6-9f0dbfa89635'),
	(30,NULL,'m160304_000000_client_permissions','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','778b7556-0fa9-451a-bc27-355b0ad1ba63'),
	(31,NULL,'m160322_000000_asset_filesize','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','9317ca3d-8862-41af-812a-dfb54c4ff580'),
	(32,NULL,'m160503_000000_orphaned_fieldlayouts','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','b7a4e9e9-4a4b-4ab9-90d8-58149b0fc63a'),
	(33,NULL,'m160510_000000_tasksettings','2016-08-04 22:18:01','2016-08-04 22:18:01','2016-08-04 22:18:01','adf72e79-db4d-474b-8dea-d02c5033a1d3'),
	(34,1,'m150916_010101_Commerce_Rename','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','e4194383-356b-46a1-8584-5e464414719f'),
	(35,1,'m150917_010101_Commerce_DropEmailTypeColumn','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','edb580bb-ceae-4c98-a67b-daa6f8d5dd68'),
	(36,1,'m150917_010102_Commerce_RenameCodeToHandletaxCatColumn','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','a3158fd2-366a-469c-a245-ba6f94914459'),
	(37,1,'m150918_010101_Commerce_AddProductTypeLocales','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','778e17b9-3288-4053-a09e-cb21a98ad732'),
	(38,1,'m150918_010102_Commerce_RemoveNonLocaleBasedUrlFormat','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','297a93e1-7477-4218-9159-0c557804e344'),
	(39,1,'m150919_010101_Commerce_AddHasDimensionsToProductType','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','120568ee-df6f-4436-97a8-d490d696523c'),
	(40,1,'m151004_142113_commerce_PaymentMethods_name_unique','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','a3d7edf7-c992-418f-b94f-a363d4ddd736'),
	(41,1,'m151018_010101_Commerce_DiscountCodeNull','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','9555b1d3-f2d2-410a-b57c-02667dffb01f'),
	(42,1,'m151025_010101_Commerce_AddHandleToShippingMethod','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','c0488b66-0e20-4f2a-ad74-cbcbeabb6138'),
	(43,1,'m151027_010101_Commerce_NewVariantUI','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','f03ae62e-479f-4f39-ae4d-6c08bd8864ec'),
	(44,1,'m151027_010102_Commerce_ProductDateNames','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','8524dcc7-6841-4d73-a43b-a9e1f3025bd1'),
	(45,1,'m151102_010101_Commerce_PaymentTypeInMethodNotSettings','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','9df76c73-1beb-42f4-982a-5c864544e2ab'),
	(46,1,'m151103_010101_Commerce_DefaultVariant','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','4f80c15b-1e9b-44b0-adda-8e1bf83f5325'),
	(47,1,'m151109_010101_Commerce_AddCompanyNumberToAddress','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','b9cb6dcc-6fbb-42e2-9b09-52a06d32514a'),
	(48,1,'m151109_010102_Commerce_AddOptionsToLineItems','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','c0df2843-aace-44f2-8dfd-71185ffcbee4'),
	(49,1,'m151110_010101_Commerce_RenameCompanyToAddress','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','a2d22e85-128c-4577-8771-d7be262a1f1a'),
	(50,1,'m151111_010101_Commerce_ShowVariantTitleField','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','a5d16bd9-a1cd-4c7c-b07e-0bdf18c566ac'),
	(51,1,'m151112_010101_Commerce_AutoSkuFormat','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','b0c0b41b-0c20-418b-ae30-b3b1776cdb16'),
	(52,1,'m151117_010101_Commerce_TaxIncluded','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','80199f9a-fa6e-4d15-a0f8-5a9371129a79'),
	(53,1,'m151124_010101_Commerce_AddressManagement','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','f8aa1404-4161-4590-9694-ddd10a5f8b81'),
	(54,1,'m151127_010101_Commerce_TaxRateTaxableOptions','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','60484114-9a2b-4e97-9090-d12fd86c0bc5'),
	(55,1,'m151210_010101_Commerce_FixMissingLineItemDimensionData','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','c12ff336-eb08-46d2-a505-e1f2e64f6009'),
	(56,1,'m160215_010101_Commerce_ConsistentDecimalType','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','b200e703-6ee7-4297-933b-0a4c5dfcc246'),
	(57,1,'m160226_010101_Commerce_OrderStatusSortOrder','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','9d4bdd04-21aa-42bb-8326-ca07274f7dd5'),
	(58,1,'m160226_010102_Commerce_isCompleted','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','ea115118-f086-4efc-a10b-809b169575b0'),
	(59,1,'m160227_010101_Commerce_OrderAdjustmentIncludedFlag','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','52c99012-7a57-403a-9087-5858681058a7'),
	(60,1,'m160229_010101_Commerce_ShippingZone','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','02369052-c7a4-4b77-8e7e-77ff85f71196'),
	(61,1,'m160229_010104_Commerce_SoftDeleteAndReorderPaymentMethod','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','f6b8076f-9c5e-4745-93c3-8148acaf7895'),
	(62,1,'m160401_010101_Commerce_KeepAllTransactions','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','ac232d8a-4776-400f-885b-a1ffece1a213'),
	(63,1,'m160405_010101_Commerce_FixDefaultVariantId','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','edbec91b-6454-4a8a-9ad3-60c7b469795e'),
	(64,1,'m160406_010101_Commerce_RemoveUnusedAuthorId','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','262281d1-68ba-479e-bf04-1107bd3b59b0'),
	(65,1,'m160425_010101_Commerce_DeleteCountriesAndStates','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','3f890b2e-5fd0-4459-b4e8-e524758bd3d1'),
	(66,1,'m160606_010101_Commerce_PerEmailLimitOnDiscount','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:37','189f0b39-ed29-47b6-a341-b1d98dd47e8b');

/*!40000 ALTER TABLE `craft_migrations` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_plugins
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_plugins`;

CREATE TABLE `craft_plugins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `version` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `schemaVersion` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `licenseKey` char(24) COLLATE utf8_unicode_ci DEFAULT NULL,
  `licenseKeyStatus` enum('valid','invalid','mismatched','unknown') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'unknown',
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `settings` text COLLATE utf8_unicode_ci,
  `installDate` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_plugins` WRITE;
/*!40000 ALTER TABLE `craft_plugins` DISABLE KEYS */;

INSERT INTO `craft_plugins` (`id`, `class`, `version`, `schemaVersion`, `licenseKey`, `licenseKeyStatus`, `enabled`, `settings`, `installDate`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Commerce','1.1.1213','1.0.13',NULL,'unknown',1,'{\"defaultCurrency\":\"USD\",\"weightUnits\":\"g\",\"dimensionUnits\":\"mm\",\"emailSenderAddress\":null,\"emailSenderName\":null,\"orderPdfPath\":\"commerce\\/_pdf\\/order\"}','2016-08-16 21:02:37','2016-08-16 21:02:37','2016-08-16 21:02:40','1facc0ca-b54d-4e94-9c25-2ea103cadb92');

/*!40000 ALTER TABLE `craft_plugins` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_rackspaceaccess
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_rackspaceaccess`;

CREATE TABLE `craft_rackspaceaccess` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `connectionKey` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `storageUrl` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `cdnUrl` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_rackspaceaccess_connectionKey_unq_idx` (`connectionKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_relations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_relations`;

CREATE TABLE `craft_relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldId` int(11) NOT NULL,
  `sourceId` int(11) NOT NULL,
  `sourceLocale` char(12) COLLATE utf8_unicode_ci DEFAULT NULL,
  `targetId` int(11) NOT NULL,
  `sortOrder` smallint(6) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_relations_fieldId_sourceId_sourceLocale_targetId_unq_idx` (`fieldId`,`sourceId`,`sourceLocale`,`targetId`),
  KEY `craft_relations_sourceId_fk` (`sourceId`),
  KEY `craft_relations_sourceLocale_fk` (`sourceLocale`),
  KEY `craft_relations_targetId_fk` (`targetId`),
  CONSTRAINT `craft_relations_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `craft_fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_relations_sourceId_fk` FOREIGN KEY (`sourceId`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_relations_sourceLocale_fk` FOREIGN KEY (`sourceLocale`) REFERENCES `craft_locales` (`locale`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_relations_targetId_fk` FOREIGN KEY (`targetId`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_routes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_routes`;

CREATE TABLE `craft_routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `locale` char(12) COLLATE utf8_unicode_ci DEFAULT NULL,
  `urlParts` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `urlPattern` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `template` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_routes_urlPattern_unq_idx` (`urlPattern`),
  KEY `craft_routes_locale_idx` (`locale`),
  CONSTRAINT `craft_routes_locale_fk` FOREIGN KEY (`locale`) REFERENCES `craft_locales` (`locale`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_searchindex
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_searchindex`;

CREATE TABLE `craft_searchindex` (
  `elementId` int(11) NOT NULL,
  `attribute` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `fieldId` int(11) NOT NULL,
  `locale` char(12) COLLATE utf8_unicode_ci NOT NULL,
  `keywords` text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`elementId`,`attribute`,`fieldId`,`locale`),
  FULLTEXT KEY `craft_searchindex_keywords_idx` (`keywords`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_searchindex` WRITE;
/*!40000 ALTER TABLE `craft_searchindex` DISABLE KEYS */;

INSERT INTO `craft_searchindex` (`elementId`, `attribute`, `fieldId`, `locale`, `keywords`)
VALUES
	(1,'username',0,'en_us',' admin '),
	(1,'firstname',0,'en_us',''),
	(1,'lastname',0,'en_us',''),
	(1,'fullname',0,'en_us',''),
	(1,'email',0,'en_us',' admin greenhorn dev '),
	(1,'slug',0,'en_us',''),
	(2,'slug',0,'en_us',' homepage '),
	(2,'title',0,'en_us',' welcome to greenhorn dev '),
	(2,'field',1,'en_us',' it s true this site doesn t have a whole lot of content yet but don t worry our web developers have just installed the cms and they re setting things up for the content editors this very moment soon greenhorn dev will be an oasis of fresh perspectives sharp analyses and astute opinions that will keep you coming back again and again '),
	(3,'field',1,'en_us',' craft is the cms that s powering greenhorn dev it s beautiful powerful flexible and easy to use and it s made by pixel tonic we can t wait to dive in and see what it s capable of this is even more captivating content which you couldn t see on the news index page because it was entered after a page break and the news index template only likes to show the content on the first page craft a nice alternative to word if you re making a website '),
	(3,'field',2,'en_us',''),
	(3,'slug',0,'en_us',''),
	(3,'title',0,'en_us',' we just installed craft '),
	(4,'title',0,'en_us',' a new toga '),
	(4,'defaultsku',0,'en_us',''),
	(4,'slug',0,'en_us',''),
	(5,'sku',0,'en_us',' a new toga '),
	(5,'price',0,'en_us',' 10 '),
	(5,'width',0,'en_us',''),
	(5,'height',0,'en_us',''),
	(5,'length',0,'en_us',''),
	(5,'weight',0,'en_us',''),
	(5,'stock',0,'en_us',' 0 '),
	(5,'unlimitedstock',0,'en_us',' 1 '),
	(5,'minqty',0,'en_us',''),
	(5,'maxqty',0,'en_us',''),
	(5,'slug',0,'en_us',''),
	(5,'title',0,'en_us',' a new toga '),
	(6,'title',0,'en_us',' parka with stripes on back '),
	(6,'defaultsku',0,'en_us',''),
	(6,'slug',0,'en_us',''),
	(7,'sku',0,'en_us',' parka with stripes on back '),
	(7,'price',0,'en_us',' 20 '),
	(7,'width',0,'en_us',''),
	(7,'height',0,'en_us',''),
	(7,'length',0,'en_us',''),
	(7,'weight',0,'en_us',''),
	(7,'stock',0,'en_us',' 0 '),
	(7,'unlimitedstock',0,'en_us',' 1 '),
	(7,'minqty',0,'en_us',''),
	(7,'maxqty',0,'en_us',''),
	(7,'slug',0,'en_us',''),
	(7,'title',0,'en_us',' parka with stripes on back '),
	(8,'title',0,'en_us',' romper for a red eye '),
	(8,'defaultsku',0,'en_us',''),
	(8,'slug',0,'en_us',''),
	(9,'sku',0,'en_us',' romper for a red eye '),
	(9,'price',0,'en_us',' 30 '),
	(9,'width',0,'en_us',''),
	(9,'height',0,'en_us',''),
	(9,'length',0,'en_us',''),
	(9,'weight',0,'en_us',''),
	(9,'stock',0,'en_us',' 0 '),
	(9,'unlimitedstock',0,'en_us',' 1 '),
	(9,'minqty',0,'en_us',''),
	(9,'maxqty',0,'en_us',''),
	(9,'slug',0,'en_us',''),
	(9,'title',0,'en_us',' romper for a red eye '),
	(10,'title',0,'en_us',' the fleece awakens '),
	(10,'defaultsku',0,'en_us',''),
	(10,'slug',0,'en_us',''),
	(11,'sku',0,'en_us',' the fleece awakens '),
	(11,'price',0,'en_us',' 40 '),
	(11,'width',0,'en_us',''),
	(11,'height',0,'en_us',''),
	(11,'length',0,'en_us',''),
	(11,'weight',0,'en_us',''),
	(11,'stock',0,'en_us',' 0 '),
	(11,'unlimitedstock',0,'en_us',' 1 '),
	(11,'minqty',0,'en_us',''),
	(11,'maxqty',0,'en_us',''),
	(11,'slug',0,'en_us',''),
	(11,'title',0,'en_us',' the fleece awakens ');

/*!40000 ALTER TABLE `craft_searchindex` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_sections
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_sections`;

CREATE TABLE `craft_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `handle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `type` enum('single','channel','structure') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'channel',
  `hasUrls` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `template` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enableVersioning` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_sections_name_unq_idx` (`name`),
  UNIQUE KEY `craft_sections_handle_unq_idx` (`handle`),
  KEY `craft_sections_structureId_fk` (`structureId`),
  CONSTRAINT `craft_sections_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `craft_structures` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_sections` WRITE;
/*!40000 ALTER TABLE `craft_sections` DISABLE KEYS */;

INSERT INTO `craft_sections` (`id`, `structureId`, `name`, `handle`, `type`, `hasUrls`, `template`, `enableVersioning`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,NULL,'Homepage','homepage','single',1,'index',1,'2016-08-04 22:18:06','2016-08-04 22:18:06','6dfea3e4-6496-4956-89d8-8eacbca20da6'),
	(2,NULL,'News','news','channel',1,'news/_entry',1,'2016-08-04 22:18:06','2016-08-04 22:18:06','7d30aa44-352a-4fee-9b45-e50e68c34ab7');

/*!40000 ALTER TABLE `craft_sections` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_sections_i18n
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_sections_i18n`;

CREATE TABLE `craft_sections_i18n` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sectionId` int(11) NOT NULL,
  `locale` char(12) COLLATE utf8_unicode_ci NOT NULL,
  `enabledByDefault` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `urlFormat` text COLLATE utf8_unicode_ci,
  `nestedUrlFormat` text COLLATE utf8_unicode_ci,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_sections_i18n_sectionId_locale_unq_idx` (`sectionId`,`locale`),
  KEY `craft_sections_i18n_locale_fk` (`locale`),
  CONSTRAINT `craft_sections_i18n_locale_fk` FOREIGN KEY (`locale`) REFERENCES `craft_locales` (`locale`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `craft_sections_i18n_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `craft_sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_sections_i18n` WRITE;
/*!40000 ALTER TABLE `craft_sections_i18n` DISABLE KEYS */;

INSERT INTO `craft_sections_i18n` (`id`, `sectionId`, `locale`, `enabledByDefault`, `urlFormat`, `nestedUrlFormat`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,'en_us',1,'__home__',NULL,'2016-08-04 22:18:06','2016-08-04 22:18:06','05050711-0c09-4389-ab57-a27867373023'),
	(2,2,'en_us',1,'news/{postDate.year}/{slug}',NULL,'2016-08-04 22:18:06','2016-08-04 22:18:06','15b8c47a-dd2a-48b6-a2ce-993bc7c8da2a');

/*!40000 ALTER TABLE `craft_sections_i18n` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_sessions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_sessions`;

CREATE TABLE `craft_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `token` char(100) COLLATE utf8_unicode_ci NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_sessions_uid_idx` (`uid`),
  KEY `craft_sessions_token_idx` (`token`),
  KEY `craft_sessions_dateUpdated_idx` (`dateUpdated`),
  KEY `craft_sessions_userId_fk` (`userId`),
  CONSTRAINT `craft_sessions_userId_fk` FOREIGN KEY (`userId`) REFERENCES `craft_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_sessions` WRITE;
/*!40000 ALTER TABLE `craft_sessions` DISABLE KEYS */;

INSERT INTO `craft_sessions` (`id`, `userId`, `token`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,'8849c15ffb691200b37b3e3007ac74037f578716czozMjoiTHFveDdPRWtoaTR4R0kyM0R2RDN0ZEp6YjBjY3JxSHYiOw==','2016-08-04 22:18:06','2016-08-04 22:18:06','29b895e2-d01c-4c70-bcb5-f7752af95fba');

/*!40000 ALTER TABLE `craft_sessions` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_shunnedmessages
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_shunnedmessages`;

CREATE TABLE `craft_shunnedmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_shunnedmessages_userId_message_unq_idx` (`userId`,`message`),
  CONSTRAINT `craft_shunnedmessages_userId_fk` FOREIGN KEY (`userId`) REFERENCES `craft_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_structureelements
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_structureelements`;

CREATE TABLE `craft_structureelements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) NOT NULL,
  `elementId` int(11) DEFAULT NULL,
  `root` int(11) unsigned DEFAULT NULL,
  `lft` int(11) unsigned NOT NULL,
  `rgt` int(11) unsigned NOT NULL,
  `level` smallint(6) unsigned NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_structureelements_structureId_elementId_unq_idx` (`structureId`,`elementId`),
  KEY `craft_structureelements_root_idx` (`root`),
  KEY `craft_structureelements_lft_idx` (`lft`),
  KEY `craft_structureelements_rgt_idx` (`rgt`),
  KEY `craft_structureelements_level_idx` (`level`),
  KEY `craft_structureelements_elementId_fk` (`elementId`),
  CONSTRAINT `craft_structureelements_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_structureelements_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `craft_structures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_structures
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_structures`;

CREATE TABLE `craft_structures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `maxLevels` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_systemsettings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_systemsettings`;

CREATE TABLE `craft_systemsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `settings` text COLLATE utf8_unicode_ci,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_systemsettings_category_unq_idx` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_systemsettings` WRITE;
/*!40000 ALTER TABLE `craft_systemsettings` DISABLE KEYS */;

INSERT INTO `craft_systemsettings` (`id`, `category`, `settings`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'email','{\"protocol\":\"php\",\"emailAddress\":\"admin@greenhorn.dev\",\"senderName\":\"Greenhorn\"}','2016-08-04 22:18:06','2016-08-04 22:18:06','e34080da-82b1-45ba-913b-eae02dedb2a7');

/*!40000 ALTER TABLE `craft_systemsettings` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_taggroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_taggroups`;

CREATE TABLE `craft_taggroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `handle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `fieldLayoutId` int(10) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_taggroups_name_unq_idx` (`name`),
  UNIQUE KEY `craft_taggroups_handle_unq_idx` (`handle`),
  KEY `craft_taggroups_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `craft_taggroups_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `craft_fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_taggroups` WRITE;
/*!40000 ALTER TABLE `craft_taggroups` DISABLE KEYS */;

INSERT INTO `craft_taggroups` (`id`, `name`, `handle`, `fieldLayoutId`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Default','default',1,'2016-08-04 22:18:06','2016-08-04 22:18:06','732a586d-8fae-4d7f-a5f4-5d524da001ff');

/*!40000 ALTER TABLE `craft_taggroups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_tags
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_tags`;

CREATE TABLE `craft_tags` (
  `id` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_tags_groupId_fk` (`groupId`),
  CONSTRAINT `craft_tags_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `craft_taggroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_tags_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_tasks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_tasks`;

CREATE TABLE `craft_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `root` int(11) unsigned DEFAULT NULL,
  `lft` int(11) unsigned NOT NULL,
  `rgt` int(11) unsigned NOT NULL,
  `level` smallint(6) unsigned NOT NULL,
  `currentStep` int(11) unsigned DEFAULT NULL,
  `totalSteps` int(11) unsigned DEFAULT NULL,
  `status` enum('pending','error','running') COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `settings` mediumtext COLLATE utf8_unicode_ci,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_tasks_root_idx` (`root`),
  KEY `craft_tasks_lft_idx` (`lft`),
  KEY `craft_tasks_rgt_idx` (`rgt`),
  KEY `craft_tasks_level_idx` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_templatecachecriteria
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_templatecachecriteria`;

CREATE TABLE `craft_templatecachecriteria` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cacheId` int(11) NOT NULL,
  `type` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `criteria` text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `craft_templatecachecriteria_cacheId_fk` (`cacheId`),
  KEY `craft_templatecachecriteria_type_idx` (`type`),
  CONSTRAINT `craft_templatecachecriteria_cacheId_fk` FOREIGN KEY (`cacheId`) REFERENCES `craft_templatecaches` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_templatecacheelements
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_templatecacheelements`;

CREATE TABLE `craft_templatecacheelements` (
  `cacheId` int(11) NOT NULL,
  `elementId` int(11) NOT NULL,
  KEY `craft_templatecacheelements_cacheId_fk` (`cacheId`),
  KEY `craft_templatecacheelements_elementId_fk` (`elementId`),
  CONSTRAINT `craft_templatecacheelements_cacheId_fk` FOREIGN KEY (`cacheId`) REFERENCES `craft_templatecaches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_templatecacheelements_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_templatecaches
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_templatecaches`;

CREATE TABLE `craft_templatecaches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cacheKey` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `locale` char(12) COLLATE utf8_unicode_ci NOT NULL,
  `path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `expiryDate` datetime NOT NULL,
  `body` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `craft_templatecaches_expiryDate_cacheKey_locale_path_idx` (`expiryDate`,`cacheKey`,`locale`,`path`),
  KEY `craft_templatecaches_locale_fk` (`locale`),
  CONSTRAINT `craft_templatecaches_locale_fk` FOREIGN KEY (`locale`) REFERENCES `craft_locales` (`locale`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_tokens
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_tokens`;

CREATE TABLE `craft_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` char(32) COLLATE utf8_unicode_ci NOT NULL,
  `route` text COLLATE utf8_unicode_ci,
  `usageLimit` tinyint(3) unsigned DEFAULT NULL,
  `usageCount` tinyint(3) unsigned DEFAULT NULL,
  `expiryDate` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_tokens_token_unq_idx` (`token`),
  KEY `craft_tokens_expiryDate_idx` (`expiryDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_usergroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_usergroups`;

CREATE TABLE `craft_usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `handle` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_usergroups_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_usergroups_users`;

CREATE TABLE `craft_usergroups_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_usergroups_users_groupId_userId_unq_idx` (`groupId`,`userId`),
  KEY `craft_usergroups_users_userId_fk` (`userId`),
  CONSTRAINT `craft_usergroups_users_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `craft_usergroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_usergroups_users_userId_fk` FOREIGN KEY (`userId`) REFERENCES `craft_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_userpermissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_userpermissions`;

CREATE TABLE `craft_userpermissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_userpermissions_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_userpermissions_usergroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_userpermissions_usergroups`;

CREATE TABLE `craft_userpermissions_usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permissionId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_userpermissions_usergroups_permissionId_groupId_unq_idx` (`permissionId`,`groupId`),
  KEY `craft_userpermissions_usergroups_groupId_fk` (`groupId`),
  CONSTRAINT `craft_userpermissions_usergroups_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `craft_usergroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_userpermissions_usergroups_permissionId_fk` FOREIGN KEY (`permissionId`) REFERENCES `craft_userpermissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_userpermissions_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_userpermissions_users`;

CREATE TABLE `craft_userpermissions_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permissionId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_userpermissions_users_permissionId_userId_unq_idx` (`permissionId`,`userId`),
  KEY `craft_userpermissions_users_userId_fk` (`userId`),
  CONSTRAINT `craft_userpermissions_users_permissionId_fk` FOREIGN KEY (`permissionId`) REFERENCES `craft_userpermissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_userpermissions_users_userId_fk` FOREIGN KEY (`userId`) REFERENCES `craft_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table craft_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_users`;

CREATE TABLE `craft_users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `photo` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `firstName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `password` char(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `preferredLocale` char(12) COLLATE utf8_unicode_ci DEFAULT NULL,
  `weekStartDay` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `admin` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `client` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `locked` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `suspended` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `pending` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `archived` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `lastLoginDate` datetime DEFAULT NULL,
  `lastLoginAttemptIPAddress` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `invalidLoginWindowStart` datetime DEFAULT NULL,
  `invalidLoginCount` tinyint(4) unsigned DEFAULT NULL,
  `lastInvalidLoginDate` datetime DEFAULT NULL,
  `lockoutDate` datetime DEFAULT NULL,
  `verificationCode` char(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `verificationCodeIssuedDate` datetime DEFAULT NULL,
  `unverifiedEmail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `passwordResetRequired` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `lastPasswordChangeDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `craft_users_username_unq_idx` (`username`),
  UNIQUE KEY `craft_users_email_unq_idx` (`email`),
  KEY `craft_users_verificationCode_idx` (`verificationCode`),
  KEY `craft_users_uid_idx` (`uid`),
  KEY `craft_users_preferredLocale_fk` (`preferredLocale`),
  CONSTRAINT `craft_users_id_fk` FOREIGN KEY (`id`) REFERENCES `craft_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `craft_users_preferredLocale_fk` FOREIGN KEY (`preferredLocale`) REFERENCES `craft_locales` (`locale`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_users` WRITE;
/*!40000 ALTER TABLE `craft_users` DISABLE KEYS */;

INSERT INTO `craft_users` (`id`, `username`, `photo`, `firstName`, `lastName`, `email`, `password`, `preferredLocale`, `weekStartDay`, `admin`, `client`, `locked`, `suspended`, `pending`, `archived`, `lastLoginDate`, `lastLoginAttemptIPAddress`, `invalidLoginWindowStart`, `invalidLoginCount`, `lastInvalidLoginDate`, `lockoutDate`, `verificationCode`, `verificationCodeIssuedDate`, `unverifiedEmail`, `passwordResetRequired`, `lastPasswordChangeDate`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'admin',NULL,NULL,NULL,'admin@greenhorn.dev','$2y$13$kMiOkQrG9b48d8Vg8O7.cOc/QvuieGBHZHH08BWobOoGUku3r6XCS',NULL,0,1,0,0,0,0,0,'2016-08-04 22:18:06','::1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2016-08-04 22:18:04','2016-08-04 22:18:04','2016-08-04 22:18:06','559c1ea3-4964-41b5-91dc-9fc24256db6c');

/*!40000 ALTER TABLE `craft_users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table craft_widgets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `craft_widgets`;

CREATE TABLE `craft_widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `type` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `colspan` tinyint(4) unsigned DEFAULT NULL,
  `settings` text COLLATE utf8_unicode_ci,
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `craft_widgets_userId_fk` (`userId`),
  CONSTRAINT `craft_widgets_userId_fk` FOREIGN KEY (`userId`) REFERENCES `craft_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `craft_widgets` WRITE;
/*!40000 ALTER TABLE `craft_widgets` DISABLE KEYS */;

INSERT INTO `craft_widgets` (`id`, `userId`, `type`, `sortOrder`, `colspan`, `settings`, `enabled`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,'RecentEntries',1,NULL,NULL,1,'2016-08-04 22:18:30','2016-08-04 22:18:30','d91ff043-5fab-4ed8-b110-1a45cae15249'),
	(2,1,'GetHelp',2,NULL,NULL,1,'2016-08-04 22:18:30','2016-08-04 22:18:30','d004937d-9291-4db2-aa5e-a2726cef8bbf'),
	(3,1,'Updates',3,NULL,NULL,1,'2016-08-04 22:18:30','2016-08-04 22:18:30','f3d04c34-97bb-48d9-85be-d69021b7146e'),
	(4,1,'Feed',4,NULL,'{\"url\":\"https:\\/\\/craftcms.com\\/news.rss\",\"title\":\"Craft News\"}',1,'2016-08-04 22:18:30','2016-08-04 22:18:30','93b5aec2-9346-4e6e-98d7-a2501557861a');

/*!40000 ALTER TABLE `craft_widgets` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;