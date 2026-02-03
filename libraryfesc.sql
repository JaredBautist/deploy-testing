-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         8.4.7 - MySQL Community Server - GPL
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.14.0.7165
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Volcando datos para la tabla libraryfesc.accounts_user: ~0 rows (aproximadamente)
INSERT IGNORE INTO `accounts_user` (`id`, `password`, `last_login`, `email`, `first_name`, `last_name`, `role`, `is_active`, `date_joined`, `is_superuser`) VALUES
	(1, 'pbkdf2_sha256$600000$HZQcmpbRsZfWpDsoCx1vOn$UPOCH9Q1fkC1Z9B0au1Vnn3eexCmOrbP0WVsaUJzitk=', NULL, 'admin@fesc.local', 'Daniel', 'Arevalo', 'ADMIN', 1, '2026-01-21 00:43:57.664066', 0),
	(2, 'pbkdf2_sha256$600000$UX05GWvqbgkBHgHcvqcnsr$IKmGbiiRbClwPam9ktG5PqwXjjQkfrIBgxBZyU6ZO4s=', NULL, 'danielarevalobussines@gmail.com', 'Jared', 'Bautista', 'ADMIN', 1, '2026-01-21 00:52:19.836976', 0),
	(3, 'pbkdf2_sha256$600000$P7zbfaBGwkV1TlJKHo3TKv$y/kb4E3GUDeboB/asmJPsIcoQrimRmMQZYKstImIUPs=', NULL, 'tecnicoSena@gmail.com', 'Carlitos', 'stupid nigger', 'TEACHER', 1, '2026-01-21 04:06:48.986138', 0);

-- Volcando datos para la tabla libraryfesc.accounts_user_groups: ~0 rows (aproximadamente)

-- Volcando datos para la tabla libraryfesc.accounts_user_user_permissions: ~0 rows (aproximadamente)

-- Volcando datos para la tabla libraryfesc.auth_group: ~0 rows (aproximadamente)

-- Volcando datos para la tabla libraryfesc.auth_group_permissions: ~0 rows (aproximadamente)

-- Volcando datos para la tabla libraryfesc.auth_permission: ~40 rows (aproximadamente)
INSERT IGNORE INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
	(1, 'Can add log entry', 1, 'add_logentry'),
	(2, 'Can change log entry', 1, 'change_logentry'),
	(3, 'Can delete log entry', 1, 'delete_logentry'),
	(4, 'Can view log entry', 1, 'view_logentry'),
	(5, 'Can add permission', 2, 'add_permission'),
	(6, 'Can change permission', 2, 'change_permission'),
	(7, 'Can delete permission', 2, 'delete_permission'),
	(8, 'Can view permission', 2, 'view_permission'),
	(9, 'Can add group', 3, 'add_group'),
	(10, 'Can change group', 3, 'change_group'),
	(11, 'Can delete group', 3, 'delete_group'),
	(12, 'Can view group', 3, 'view_group'),
	(13, 'Can add content type', 4, 'add_contenttype'),
	(14, 'Can change content type', 4, 'change_contenttype'),
	(15, 'Can delete content type', 4, 'delete_contenttype'),
	(16, 'Can view content type', 4, 'view_contenttype'),
	(17, 'Can add session', 5, 'add_session'),
	(18, 'Can change session', 5, 'change_session'),
	(19, 'Can delete session', 5, 'delete_session'),
	(20, 'Can view session', 5, 'view_session'),
	(21, 'Can add Token', 6, 'add_token'),
	(22, 'Can change Token', 6, 'change_token'),
	(23, 'Can delete Token', 6, 'delete_token'),
	(24, 'Can view Token', 6, 'view_token'),
	(25, 'Can add token', 7, 'add_tokenproxy'),
	(26, 'Can change token', 7, 'change_tokenproxy'),
	(27, 'Can delete token', 7, 'delete_tokenproxy'),
	(28, 'Can view token', 7, 'view_tokenproxy'),
	(29, 'Can add user', 8, 'add_user'),
	(30, 'Can change user', 8, 'change_user'),
	(31, 'Can delete user', 8, 'delete_user'),
	(32, 'Can view user', 8, 'view_user'),
	(33, 'Can add space', 9, 'add_space'),
	(34, 'Can change space', 9, 'change_space'),
	(35, 'Can delete space', 9, 'delete_space'),
	(36, 'Can view space', 9, 'view_space'),
	(37, 'Can add reservation', 10, 'add_reservation'),
	(38, 'Can change reservation', 10, 'change_reservation'),
	(39, 'Can delete reservation', 10, 'delete_reservation'),
	(40, 'Can view reservation', 10, 'view_reservation');

-- Volcando datos para la tabla libraryfesc.authtoken_token: ~0 rows (aproximadamente)

-- Volcando datos para la tabla libraryfesc.django_admin_log: ~0 rows (aproximadamente)

-- Volcando datos para la tabla libraryfesc.django_content_type: ~10 rows (aproximadamente)
INSERT IGNORE INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
	(1, 'admin', 'logentry'),
	(2, 'auth', 'permission'),
	(3, 'auth', 'group'),
	(4, 'contenttypes', 'contenttype'),
	(5, 'sessions', 'session'),
	(6, 'authtoken', 'token'),
	(7, 'authtoken', 'tokenproxy'),
	(8, 'accounts', 'user'),
	(9, 'spaces', 'space'),
	(10, 'reservations', 'reservation');

-- Volcando datos para la tabla libraryfesc.django_migrations: ~25 rows (aproximadamente)
INSERT IGNORE INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
	(1, 'contenttypes', '0001_initial', '2026-01-21 00:40:25.132725'),
	(2, 'contenttypes', '0002_remove_content_type_name', '2026-01-21 00:40:25.188486'),
	(3, 'auth', '0001_initial', '2026-01-21 00:40:25.319504'),
	(4, 'auth', '0002_alter_permission_name_max_length', '2026-01-21 00:40:25.354100'),
	(5, 'auth', '0003_alter_user_email_max_length', '2026-01-21 00:40:25.359539'),
	(6, 'auth', '0004_alter_user_username_opts', '2026-01-21 00:40:25.364122'),
	(7, 'auth', '0005_alter_user_last_login_null', '2026-01-21 00:40:25.369942'),
	(8, 'auth', '0006_require_contenttypes_0002', '2026-01-21 00:40:25.374113'),
	(9, 'auth', '0007_alter_validators_add_error_messages', '2026-01-21 00:40:25.382553'),
	(10, 'auth', '0008_alter_user_username_max_length', '2026-01-21 00:40:25.387665'),
	(11, 'auth', '0009_alter_user_last_name_max_length', '2026-01-21 00:40:25.392155'),
	(12, 'auth', '0010_alter_group_name_max_length', '2026-01-21 00:40:25.406882'),
	(13, 'auth', '0011_update_proxy_permissions', '2026-01-21 00:40:25.413700'),
	(14, 'auth', '0012_alter_user_first_name_max_length', '2026-01-21 00:40:25.418524'),
	(15, 'accounts', '0001_initial', '2026-01-21 00:40:25.581378'),
	(16, 'accounts', '0002_alter_user_managers_alter_user_groups_and_more', '2026-01-21 00:40:25.593427'),
	(17, 'admin', '0001_initial', '2026-01-21 00:40:25.678198'),
	(18, 'admin', '0002_logentry_remove_auto_add', '2026-01-21 00:40:25.683998'),
	(19, 'admin', '0003_logentry_add_action_flag_choices', '2026-01-21 00:40:25.690233'),
	(20, 'authtoken', '0001_initial', '2026-01-21 00:40:25.758966'),
	(21, 'authtoken', '0002_auto_20160226_1747', '2026-01-21 00:40:25.771980'),
	(22, 'authtoken', '0003_tokenproxy', '2026-01-21 00:40:25.775119'),
	(23, 'spaces', '0001_initial', '2026-01-21 00:40:25.790938'),
	(24, 'reservations', '0001_initial', '2026-01-21 00:40:25.962015'),
	(25, 'sessions', '0001_initial', '2026-01-21 00:40:25.988612');

-- Volcando datos para la tabla libraryfesc.django_session: ~0 rows (aproximadamente)

-- Volcando datos para la tabla libraryfesc.reservations_reservation: ~4 rows (aproximadamente)
INSERT IGNORE INTO `reservations_reservation` (`id`, `created_at`, `updated_at`, `title`, `description`, `start_at`, `end_at`, `status`, `decision_at`, `decision_note`, `approved_by_id`, `created_by_id`, `space_id`) VALUES
	(1, '2026-01-21 00:46:41.514741', '2026-01-21 00:50:37.076001', 'daisys destruccion', 'me gusta el black hole of younger phililna gilr', '2026-01-21 14:46:00.000000', '2026-01-21 16:46:00.000000', 'APPROVED', '2026-01-21 00:50:37.075879', '', 1, 1, 2),
	(2, '2026-01-21 03:43:31.096653', '2026-01-21 03:46:53.095714', 'class with Epstein', 'dang my g:3', '2026-01-21 19:00:00.000000', '2026-01-21 21:43:00.000000', 'REJECTED', '2026-01-21 03:46:53.095628', 'nop niggy', 1, 2, 3),
	(3, '2026-01-21 04:05:55.332869', '2026-01-21 23:35:33.830670', 'xddddddx', 'dddddddddddddddddddddddddddddddx', '2026-01-24 17:00:00.000000', '2026-01-24 20:09:00.000000', 'APPROVED', '2026-01-21 23:35:33.830586', '', 1, 2, 2),
	(4, '2026-01-21 04:07:59.126023', '2026-01-21 23:35:31.898789', 'hiii twin, lets do a funny dumm class:3, wha u thinkin boy', 'i hate black people', '2026-01-30 21:00:00.000000', '2026-01-30 22:07:00.000000', 'APPROVED', '2026-01-21 23:35:31.898696', '', 1, 3, 3);

-- Volcando datos para la tabla libraryfesc.spaces_space: ~0 rows (aproximadamente)
INSERT IGNORE INTO `spaces_space` (`id`, `created_at`, `updated_at`, `name`, `description`, `location`, `is_active`) VALUES
	(1, '2026-01-21 00:45:26.150441', '2026-01-21 00:45:26.150465', 'CP CLASRROM', 'DIDDY OIL ME A LOT', 'FAGGOT NIGGA', 1),
	(2, '2026-01-21 00:46:41.500730', '2026-01-21 03:46:36.656362', 'Módulo 3', 'Espacio único de Biblioteca FESC', 'XD', 1),
	(3, '2026-01-21 03:42:34.618370', '2026-01-21 03:42:34.618395', 'niggas on the hood', 'dayum homie', 'FESC Modulo 3°', 1);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
