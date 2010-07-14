# Sequel Pro dump
# Version 1630
# http://code.google.com/p/sequel-pro
#
# Host: 127.0.0.1 (MySQL 5.0.51a-3ubuntu5.4)
# Database: www2_sw_staging
# Generation Time: 2010-02-10 11:08:04 -0800
# ************************************************************

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table products
# ------------------------------------------------------------

DROP TABLE IF EXISTS `products`;

CREATE TABLE `products` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` text,
  `recurring_month` int(11) default NULL,
  `status` varchar(255) default NULL,
  `kind` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `cost` decimal(10,2) default '0.00',
  `data` text,
  `whmappackage_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` (`id`,`name`,`description`,`recurring_month`,`status`,`kind`,`created_at`,`updated_at`,`cost`,`data`,`whmappackage_id`)
VALUES
	(1,'Basic Web Hosting Subscription','Basic Web Hosting Description',1,'enabled','package','2009-11-23 17:29:13','2009-11-23 17:29:13',10.00,'--- \n:package: wpdnet_basic\n',NULL),
	(2,'Small Business Web Hosting Subscription','Small Business Web Hosting Description',1,'enabled','package','2009-11-23 17:29:13','2009-11-23 17:29:13',20.00,'--- \n:package: wpdnet_sb\n',NULL),
	(3,'Professional Web Hosting Subscription','Professional Web Hosting Description',1,'enabled','package','2009-11-23 17:29:13','2009-11-23 17:29:13',30.00,'--- \n:package: wpdnet_pro\n',NULL),
	(4,'Basic Web Hosting Subscription','Basic Web Hosting Yearly',12,'enabled','package','2009-11-23 17:29:13','2009-11-23 17:29:13',100.00,'--- \n:package: wpdnet_basic\n',NULL),
	(5,'Small Business Web Hosting Subscription','Small Business Web Hosting Yearly',12,'enabled','package','2009-11-23 17:29:13','2009-11-23 17:29:13',199.00,'--- \n:package: wpdnet_sb\n',NULL),
	(6,'Professional Web Hosting Subscription','Professional Web Hosting Yearly',12,'enabled','package','2009-11-23 17:29:13','2009-11-23 17:29:13',299.00,'--- \n:package: wpdnet_pro\n',NULL),
	(7,'Dedicated IP Address','All accounts already come with a static shared IP. If you will be installing a secure certificate or have another need for a unique dedicated IP, you want this option. <strong>You do not need a dedicated IP address unless you have a SSL certificate already purchased and ready to install.</strong>',1,'enabled','addon','2009-11-23 17:29:13','2009-11-23 17:29:13',4.00,NULL,NULL),
	(8,'WordPress Pie','Professional installation of WordPress, including 10 of the most useful plugins and 10 site themes. Selecting this option will enable you to start editing your site right away with one of the most popular and effective systems available.  Use <a href=\"http://www.sustainablewebsites.com/wordpress-pie\">WordPress Pie</a> to learn to create a simple and effective website. Helps you grow your business, without needing to learn complex programming. Includes 30 minutes of telephone coaching and a 5 page tutorial document.',0,'enabled','addon','2009-11-23 17:29:13','2009-11-23 17:29:13',100.00,NULL,NULL),
	(9,'Free Domain Name','Free Domain Name',12,'active','domain','2009-11-23 17:30:22','2009-11-23 17:30:22',0.00,NULL,NULL),
	(10,'Domain Name','Domain Name',12,'active','domain','2009-12-03 05:20:16','2009-12-03 05:20:16',10.00,NULL,NULL);

/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table servers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `servers`;

CREATE TABLE `servers` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `ip_address` varchar(255) default NULL,
  `vendor` varchar(255) default NULL,
  `location` varchar(255) default NULL,
  `primary_ns` varchar(255) default NULL,
  `primary_ns_ip` varchar(255) default NULL,
  `secondary_ns` varchar(255) default NULL,
  `secondary_ns_ip` varchar(255) default NULL,
  `max_accounts` int(11) default NULL,
  `whm_user` varchar(255) default NULL,
  `whm_pass` varchar(255) default NULL,
  `whm_key` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

LOCK TABLES `servers` WRITE;
/*!40000 ALTER TABLE `servers` DISABLE KEYS */;
INSERT INTO `servers` (`id`,`name`,`ip_address`,`vendor`,`location`,`primary_ns`,`primary_ns_ip`,`secondary_ns`,`secondary_ns_ip`,`max_accounts`,`whm_user`,`whm_pass`,`whm_key`,`created_at`,`updated_at`)
VALUES
	(1,'Test Server','174.132.225.221',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'wpdnet','coo2man',NULL,'2009-11-23 17:29:13','2009-11-23 17:29:13');

/*!40000 ALTER TABLE `servers` ENABLE KEYS */;
UNLOCK TABLES;





/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
