-- MySQL dump 8.22
--
-- Host: localhost    Database: alleg
---------------------------------------------------------
-- Server version	3.23.54

--
-- Table structure for table 'factions'
--

CREATE TABLE factions (
  F_ID bigint(20) unsigned NOT NULL auto_increment,
  CORE varchar(100) NOT NULL default '',
  F_uid int(10) unsigned NOT NULL default '0',
  F_name varchar(100) NOT NULL default '',
  F_payday_mod decimal(16,14) NOT NULL default '0.00000000000000',
  F_start_money_mod decimal(16,14) NOT NULL default '0.00000000000000',
  F_ship_speed decimal(16,14) NOT NULL default '0.00000000000000',
  F_ship_accel decimal(16,14) NOT NULL default '0.00000000000000',
  F_turn_rate decimal(16,14) NOT NULL default '0.00000000000000',
  F_turn_torque decimal(16,14) NOT NULL default '0.00000000000000',
  F_station_hull decimal(16,14) NOT NULL default '0.00000000000000',
  F_station_shield decimal(16,14) NOT NULL default '0.00000000000000',
  F_station_shield_repair decimal(16,14) NOT NULL default '0.00000000000000',
  F_ship_hull decimal(16,14) NOT NULL default '0.00000000000000',
  F_ship_shield decimal(16,14) NOT NULL default '0.00000000000000',
  F_ship_shield_repair decimal(16,14) NOT NULL default '0.00000000000000',
  F_ship_sensors decimal(16,14) NOT NULL default '0.00000000000000',
  F_ship_signature decimal(16,14) NOT NULL default '0.00000000000000',
  F_ship_energy decimal(16,14) NOT NULL default '0.00000000000000',
  F_pw_range decimal(16,14) NOT NULL default '0.00000000000000',
  F_ew_range decimal(16,14) NOT NULL default '0.00000000000000',
  F_missile_track decimal(16,14) NOT NULL default '0.00000000000000',
  F_ripcord decimal(16,14) NOT NULL default '0.00000000000000',
  F_pw_damage decimal(16,14) NOT NULL default '0.00000000000000',
  F_missile_damage decimal(16,14) NOT NULL default '0.00000000000000',
  F_cost decimal(16,14) NOT NULL default '0.00000000000000',
  F_research_time decimal(16,14) NOT NULL default '0.00000000000000',
  F_miners_capacity decimal(16,14) NOT NULL default '0.00000000000000',
  F_he3_speed decimal(16,14) NOT NULL default '0.00000000000000',
  F_he3_yield decimal(16,14) NOT NULL default '0.00000000000000',
  F_model decimal(16,14) NOT NULL default '0.00000000000000',
  F_garrison_id decimal(10,0) NOT NULL default '0',
  F_obj_type decimal(10,0) NOT NULL default '0',
  PRIMARY KEY  (F_ID)
) TYPE=MyISAM;

--
-- Dumping data for table 'factions'
--



