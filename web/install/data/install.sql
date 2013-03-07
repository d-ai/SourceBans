SET FOREIGN_KEY_CHECKS = 0;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_actions'
--

CREATE TABLE {prefix}actions (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  name varchar(64) DEFAULT NULL,
  steam varchar(32) DEFAULT NULL,
  ip varchar(15) DEFAULT NULL,
  message varchar(255) NOT NULL,
  server_id smallint(5) unsigned NOT NULL,
  admin_id smallint(5) unsigned DEFAULT NULL,
  admin_ip varchar(32) NOT NULL,
  time int(10) unsigned NOT NULL,
  PRIMARY KEY (id),
  KEY admin_id (admin_id),
  KEY server_id (server_id),
  CONSTRAINT action_admin FOREIGN KEY (admin_id) REFERENCES {prefix}admins (id),
  CONSTRAINT action_server FOREIGN KEY (server_id) REFERENCES {prefix}servers (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_admins'
--

CREATE TABLE {prefix}admins (
  id smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  name varchar(64) NOT NULL,
  auth enum('steam','name','ip') NOT NULL,
  identity varchar(64) NOT NULL,
  password varchar(64) DEFAULT NULL,
  password_key varchar(64) DEFAULT NULL,
  group_id tinyint(3) unsigned DEFAULT NULL,
  email varchar(128) DEFAULT NULL,
  language varchar(2) DEFAULT NULL,
  theme varchar(32) DEFAULT NULL,
  srv_password varchar(64) DEFAULT NULL,
  validate varchar(64) DEFAULT NULL,
  lastvisit int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY name (name),
  UNIQUE KEY auth (auth,identity),
  KEY group_id (group_id),
  CONSTRAINT admin_group FOREIGN KEY (group_id) REFERENCES {prefix}groups (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_admins_server_groups'
--

CREATE TABLE {prefix}admins_server_groups (
  admin_id smallint(5) unsigned NOT NULL,
  group_id smallint(5) unsigned NOT NULL,
  inherit_order int(10) NOT NULL,
  PRIMARY KEY (admin_id,group_id),
  KEY admin_id (admin_id),
  KEY group_id (group_id),
  CONSTRAINT admin_server_group FOREIGN KEY (group_id) REFERENCES {prefix}server_groups (id),
  CONSTRAINT server_group_admin FOREIGN KEY (admin_id) REFERENCES {prefix}admins (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_bans'
--

CREATE TABLE {prefix}bans (
  id mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  type tinyint(1) NOT NULL DEFAULT '0',
  steam varchar(32) DEFAULT NULL,
  ip varchar(15) DEFAULT NULL,
  name varchar(64) DEFAULT NULL,
  reason varchar(255) NOT NULL,
  length mediumint(8) unsigned NOT NULL,
  server_id smallint(5) unsigned DEFAULT NULL,
  admin_id smallint(5) unsigned DEFAULT NULL,
  admin_ip varchar(15) NOT NULL,
  unban_admin_id smallint(5) unsigned DEFAULT NULL,
  unban_reason varchar(255) DEFAULT NULL,
  unban_time int(10) unsigned DEFAULT NULL,
  time int(10) unsigned NOT NULL,
  PRIMARY KEY (id),
  KEY server_id (server_id),
  KEY admin_id (admin_id),
  KEY unban_admin_id (unban_admin_id),
  CONSTRAINT ban_admin FOREIGN KEY (admin_id) REFERENCES {prefix}admins (id),
  CONSTRAINT ban_server FOREIGN KEY (server_id) REFERENCES {prefix}servers (id),
  CONSTRAINT ban_unban_admin FOREIGN KEY (unban_admin_id) REFERENCES {prefix}admins (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_blocks'
--

CREATE TABLE {prefix}blocks (
  ban_id mediumint(8) unsigned NOT NULL,
  name varchar(64) NOT NULL,
  server_id smallint(5) unsigned NOT NULL,
  time int(10) unsigned NOT NULL,
  KEY ban_id (ban_id),
  KEY server_id (server_id),
  CONSTRAINT block_ban FOREIGN KEY (ban_id) REFERENCES {prefix}bans (id),
  CONSTRAINT block_server FOREIGN KEY (server_id) REFERENCES {prefix}servers (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_comments'
--

CREATE TABLE {prefix}comments (
  id mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  type varchar(1) NOT NULL,
  ban_id mediumint(8) unsigned NOT NULL,
  admin_id smallint(5) unsigned NOT NULL,
  message varchar(255) NOT NULL,
  time int(10) unsigned NOT NULL,
  edit_admin_id smallint(5) unsigned DEFAULT NULL,
  edit_time int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (id),
  KEY ban_id (ban_id),
  KEY admin_id (admin_id),
  KEY edit_admin_id (edit_admin_id),
  CONSTRAINT comment_admin FOREIGN KEY (admin_id) REFERENCES {prefix}admins (id),
  CONSTRAINT comment_ban FOREIGN KEY (ban_id) REFERENCES {prefix}bans (id),
  CONSTRAINT comment_edit_admin FOREIGN KEY (edit_admin_id) REFERENCES {prefix}admins (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_demos'
--

CREATE TABLE {prefix}demos (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  object_id mediumint(8) unsigned NOT NULL,
  object_type varchar(1) NOT NULL,
  filename varchar(255) NOT NULL,
  PRIMARY KEY (id),
  KEY object (object_id,object_type) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_games'
--

CREATE TABLE {prefix}games (
  id tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  name varchar(32) NOT NULL,
  folder varchar(32) NOT NULL,
  icon varchar(32) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_group_permissions'
--

CREATE TABLE {prefix}group_permissions (
  group_id tinyint(3) unsigned NOT NULL,
  name varchar(32) NOT NULL,
  PRIMARY KEY (group_id,name),
  KEY group_id (group_id) USING BTREE,
  CONSTRAINT permission_group FOREIGN KEY (group_id) REFERENCES {prefix}groups (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_groups'
--

CREATE TABLE {prefix}groups (
  id tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  name varchar(32) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY name (name)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_logs'
--

CREATE TABLE {prefix}logs (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  type enum('m','w','e') NOT NULL,
  title varchar(64) NOT NULL,
  message varchar(255) NOT NULL,
  function varchar(500) NOT NULL,
  query varchar(255) NOT NULL,
  admin_id smallint(5) unsigned NOT NULL,
  admin_ip varchar(15) NOT NULL,
  time int(10) unsigned NOT NULL,
  PRIMARY KEY (id),
  KEY admin_id (admin_id),
  CONSTRAINT log_admin FOREIGN KEY (admin_id) REFERENCES {prefix}admins (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_overrides'
--

CREATE TABLE {prefix}overrides (
  type enum('command','group') NOT NULL,
  name varchar(32) NOT NULL,
  flags varchar(30) NOT NULL,
  PRIMARY KEY (type,name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_plugins'
--

CREATE TABLE {prefix}plugins (
  class varchar(32) NOT NULL,
  enabled tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (class)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_protests'
--

CREATE TABLE {prefix}protests (
  id mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  ban_id mediumint(8) unsigned NOT NULL,
  reason varchar(255) NOT NULL,
  email varchar(128) NOT NULL,
  ip varchar(15) NOT NULL,
  archived tinyint(1) unsigned NOT NULL DEFAULT '0',
  time int(10) unsigned NOT NULL,
  PRIMARY KEY (id),
  KEY ban_id (ban_id),
  CONSTRAINT protest_ban FOREIGN KEY (ban_id) REFERENCES {prefix}bans (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_server_group_overrides'
--

CREATE TABLE {prefix}server_group_overrides (
  group_id smallint(5) unsigned NOT NULL,
  type enum('command','group') NOT NULL,
  name varchar(32) NOT NULL,
  access enum('allow','deny') NOT NULL,
  PRIMARY KEY (group_id,type,name),
  KEY group_id (group_id),
  CONSTRAINT server_group_override_group FOREIGN KEY (group_id) REFERENCES {prefix}server_groups (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_server_groups'
--

CREATE TABLE {prefix}server_groups (
  id smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  name varchar(32) NOT NULL,
  flags varchar(32) NOT NULL,
  immunity smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (id),
  UNIQUE KEY name (name)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_server_groups_immunity'
--

CREATE TABLE {prefix}server_groups_immunity (
  group_id smallint(5) unsigned NOT NULL,
  other_id smallint(5) unsigned NOT NULL,
  PRIMARY KEY (group_id,other_id),
  KEY group_id (group_id),
  KEY other_id (other_id),
  CONSTRAINT server_group_immunity_group FOREIGN KEY (group_id) REFERENCES {prefix}server_groups (id),
  CONSTRAINT server_group_immunity_other FOREIGN KEY (other_id) REFERENCES {prefix}server_groups (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_servers'
--

CREATE TABLE {prefix}servers (
  id smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  ip varchar(15) NOT NULL,
  port smallint(5) unsigned NOT NULL DEFAULT '27015',
  rcon varchar(32) DEFAULT NULL,
  game_id tinyint(3) unsigned NOT NULL,
  enabled tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (id),
  KEY game_id (game_id) USING BTREE,
  CONSTRAINT server_game FOREIGN KEY (game_id) REFERENCES {prefix}games (id)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_servers_server_groups'
--

CREATE TABLE {prefix}servers_server_groups (
  server_id smallint(5) unsigned NOT NULL,
  group_id smallint(5) unsigned NOT NULL,
  PRIMARY KEY (server_id,group_id),
  KEY server_id (server_id),
  KEY group_id (group_id),
  CONSTRAINT server_server_group FOREIGN KEY (group_id) REFERENCES {prefix}server_groups (id),
  CONSTRAINT server_group_server FOREIGN KEY (server_id) REFERENCES {prefix}servers (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_settings'
--

CREATE TABLE {prefix}settings (
  name varchar(32) NOT NULL,
  value text NOT NULL,
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table 'sb_submissions'
--

CREATE TABLE {prefix}submissions (
  id mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  name varchar(64) NOT NULL,
  steam varchar(32) DEFAULT NULL,
  ip varchar(15) DEFAULT NULL,
  reason varchar(255) NOT NULL,
  server_id smallint(5) unsigned DEFAULT NULL,
  subname varchar(64) NOT NULL,
  subemail varchar(128) NOT NULL,
  subip varchar(15) NOT NULL,
  archived tinyint(1) unsigned NOT NULL DEFAULT '0',
  time int(10) unsigned NOT NULL,
  PRIMARY KEY (id),
  KEY server_id (server_id),
  CONSTRAINT submission_server FOREIGN KEY (server_id) REFERENCES {prefix}servers (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Dumping data for table 'sb_games'
--

INSERT INTO {prefix}games (name, folder, icon) VALUES
('Alien Swarm', 'alienswarm', 'alienswarm.png'),
('Counter-Strike: Source', 'cstrike', 'csource.png'),
('CSPromod', 'cspromod', 'cspromod.png'),
('Day of Defeat: Source', 'dod', 'dods.png'),
('Dystopia', 'dystopia', 'dys.gif'),
('E.Y.E: Divine Cybermancy', 'eye', 'eye.png'),
('Fortress Forever', 'FortressForever', 'fortressforever.gif'),
('Garry''s Mod', 'garrysmod', 'gmod.png'),
('GoldenEye: Source', 'gesource', 'gesource.png'),
('Half-Life 2 Capture the Flag', 'hl2ctf', 'hl2ctf.png'),
('Half-Life 2 Deathmatch', 'hl2mp', 'hl2dm.png'),
('Hidden: Source', 'hidden', 'hidden.png'),
('Insurgency', 'insurgency', 'ins.gif'),
('Left 4 Dead', 'left4dead', 'l4d.png'),
('Left 4 Dead 2', 'left4dead2', 'l4d2.png'),
('Nuclear Dawn', 'nucleardawn', 'nucleardawn.png'),
('Obsidian Conflict', 'obsidian', 'obsidian.gif'),
('Perfect Dark: Source', 'pdark', 'pdark.gif'),
('Pirates Vikings and Knights II', 'pvkii', 'pvkii.gif'),
('SourceForts', 'sourceforts', 'sourceforts.gif'),
('Synergy', 'synergy', 'synergy.gif'),
('Team Fortress 2', 'tf', 'tf2.gif'),
('The Ship', 'ship', 'ship.gif'),
('Zombie Panic: Source', 'zps', 'zps.gif');

-- --------------------------------------------------------

--
-- Dumping data for table 'sb_settings'
--

INSERT INTO {prefix}settings (name, value) VALUES
('bans_hide_admin', '0'),
('bans_hide_ip', '0'),
('bans_public_export', '0'),
('dashboard_text', '<img alt="SourceBans Logo" src="/images/logo-large.jpg" title="SourceBans Logo" /><h3>Your new SourceBans install</h3><p>SourceBans successfully installed!</p>'),
('dashboard_title', 'Your SourceBans install'),
('date_format', 'm-d-y H:i'),
('default_page', 'dashboard'),
('disable_log_popup', '0'),
('enable_debug', '0'),
('enable_protest', '1'),
('enable_smtp', '0'),
('enable_submit', '1'),
('items_per_page', '10'),
('language', 'en'),
('password_min_length', '4'),
('smtp_host', ''),
('smtp_password', ''),
('smtp_port', '25'),
('smtp_secure', ''),
('smtp_username', ''),
('summer_time', '0'),
('theme', 'bootstrap'),
('timezone', '0');

-- --------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 1;