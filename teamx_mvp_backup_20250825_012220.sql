-- TeamX MVP Database Dump
-- Generated on 2025-08-25 01:22:20.032617

SET FOREIGN_KEY_CHECKS=0;


-- Table structure for `benefit_items`
DROP TABLE IF EXISTS `benefit_items`;
CREATE TABLE `benefit_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `required_total_score` int NOT NULL,
  `benefit_type` enum('クエスト参加権','セミナー参加権','相談権','インターン','金融優遇','起業支援','その他') DEFAULT 'その他',
  `monetary_value` decimal(12,0) DEFAULT '0',
  `unlock_school_year` enum('high1','high2','high3','univ1','univ2','univ3','univ4','any') DEFAULT 'any',
  `status` enum('available','coming_soon','disabled') DEFAULT 'available',
  `sort_order` int DEFAULT '1000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `benefit_items`
INSERT INTO `benefit_items` (`id`, `title`, `description`, `required_total_score`, `benefit_type`, `monetary_value`, `unlock_school_year`, `status`, `sort_order`) VALUES
(1, 'はじめてのクエスト参加権', '初級クエストに参加、抽選で500円特典', 150, 'クエスト参加権', '500', 'high2', 'available', 250),
(2, '実践型クエスト参加権', '達成で1,000～3,000円の報酬を獲得', 250, 'クエスト参加権', '2000', 'high2', 'available', 300),
(3, 'キャリア相談チケット', 'プロとの個別面談とギフト1,500円付', 300, '相談権', '1500', 'high2', 'available', 350),
(4, '奨学金金利優遇チケット', '融資金利を2.5%→1.0%に優遇', 400, '金融優遇', '0', 'high3', 'available', 500),
(5, '上級クエスト参加権', '高難度クエストで最大1万円の報酬', 500, 'クエスト参加権', '10000', 'univ1', 'available', 550),
(6, 'インターン応募パス', '限定企業のインターンに応募可能', 600, 'インターン', '0', 'univ1', 'available', 600),
(7, '就活アドバイザー相談権', '模擬面接やES添削など就活サポート', 700, '相談権', '0', 'univ2', 'available', 700),
(8, '応援プロジェクト起案権', '支援者から最大50万円の寄付を受け取れる', 750, '起業支援', '500000', 'univ2', 'available', 750),
(9, '起業応援プログラム', '支援金最大300万円＋起業支援を提供', 900, '起業支援', '3000000', 'univ3', 'available', 900);

-- Table structure for `learning_content_skills`
DROP TABLE IF EXISTS `learning_content_skills`;
CREATE TABLE `learning_content_skills` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content_id` bigint NOT NULL,
  `skill_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `content_id` (`content_id`),
  KEY `skill_id` (`skill_id`),
  CONSTRAINT `learning_content_skills_ibfk_1` FOREIGN KEY (`content_id`) REFERENCES `learning_contents` (`id`),
  CONSTRAINT `learning_content_skills_ibfk_2` FOREIGN KEY (`skill_id`) REFERENCES `skills_master` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table structure for `learning_contents`
DROP TABLE IF EXISTS `learning_contents`;
CREATE TABLE `learning_contents` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `cover_image_url` varchar(512) DEFAULT NULL,
  `provider_id` bigint DEFAULT NULL,
  `difficulty_level` tinyint DEFAULT '1',
  `duration_minutes` int DEFAULT '0',
  `points_find` int DEFAULT '0',
  `points_shape` int DEFAULT '0',
  `points_deliver` int DEFAULT '0',
  `reward_amount` int DEFAULT '0',
  `total_score` int GENERATED ALWAYS AS (((`points_find` + `points_shape`) + `points_deliver`)) STORED,
  `unlock_condition` text,
  `required_total_score` int DEFAULT '0',
  `prerequisite_content_id` bigint DEFAULT NULL,
  `status` enum('active','draft','archived') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `provider_id` (`provider_id`),
  KEY `prerequisite_content_id` (`prerequisite_content_id`),
  CONSTRAINT `learning_contents_ibfk_1` FOREIGN KEY (`provider_id`) REFERENCES `learning_providers` (`id`),
  CONSTRAINT `learning_contents_ibfk_2` FOREIGN KEY (`prerequisite_content_id`) REFERENCES `learning_contents` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `learning_contents`
INSERT INTO `learning_contents` (`id`, `title`, `description`, `cover_image_url`, `provider_id`, `difficulty_level`, `duration_minutes`, `points_find`, `points_shape`, `points_deliver`, `reward_amount`, `total_score`, `unlock_condition`, `required_total_score`, `prerequisite_content_id`, `status`, `created_at`) VALUES
(1, 'ゼロから始めるWebサイト制作', 'HTML/CSS基礎を学びポートフォリオ制作', NULL, 1, 2, 360, 24, 28, 8, 0, 60, '初期解放', 0, NULL, 'active', '2025-08-17 13:18:05'),
(2, 'Pythonで学ぶプログラミング基礎', '基本文法習得', NULL, 1, 2, 300, 36, 21, 12, 0, 69, '初期解放', 0, NULL, 'active', '2025-08-17 13:18:05'),
(3, 'JavaScriptで作る動くWebページ', '動的ページ制作', NULL, 6, 3, 300, 24, 28, 71, 0, 123, 'ゼロから始めるWebサイト制作クリア', 0, NULL, 'active', '2025-08-17 13:18:05'),
(4, 'Webサイト制作入門', 'HTML/CSS の基礎を学ぶコース', 'https://storage.cloud.google.com/teamx_mvp/eyechatch_progate.jpg', 1, 1, 60, 20, 20, 20, 0, 60, '初期解放', 0, NULL, 'active', '2025-08-24 03:38:08'),
(5, 'Git 入門', 'バージョン管理システム Git の基本を学ぶ', 'https://storage.cloud.google.com/teamx_mvp/game-progate.png', 1, 1, 45, 15, 15, 20, 0, 50, '初期解放', 0, NULL, 'active', '2025-08-24 03:38:08'),
(6, 'Python 基礎', 'Python でプログラミングに挑戦', 'https://storage.cloud.google.com/teamx_mvp/python_progate.png', 1, 1, 80, 25, 20, 25, 0, 70, '初期解放', 0, NULL, 'active', '2025-08-24 03:38:08'),
(7, 'React レッスン IV', 'React を使った SPA 開発を学ぶ', 'https://storage.cloud.google.com/teamx_mvp/react_ptogate.png', 1, 2, 120, 30, 30, 40, 0, 100, 'Python 基礎クリア', 0, NULL, 'active', '2025-08-24 03:38:08');

-- Table structure for `learning_providers`
DROP TABLE IF EXISTS `learning_providers`;
CREATE TABLE `learning_providers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `website_url` varchar(255) DEFAULT NULL,
  `provider_type` enum('platform','university','company','npo','government') DEFAULT 'platform',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `learning_providers`
INSERT INTO `learning_providers` (`id`, `name`, `website_url`, `provider_type`) VALUES
(1, 'Progate', NULL, 'platform'),
(2, 'Schoo', NULL, 'platform'),
(3, 'Coursera', NULL, 'platform'),
(4, '国連大学オンライン', NULL, 'university'),
(5, 'note大学', NULL, 'university'),
(6, 'ドットインストール', NULL, 'platform'),
(7, 'Udemy', NULL, 'platform'),
(8, 'Kaggle', NULL, 'platform'),
(9, 'JAXA E-learning', NULL, 'government'),
(10, 'Future Learn', NULL, 'platform'),
(11, 'edX', NULL, 'platform'),
(12, 'Qiita Learning', NULL, 'platform'),
(13, 'Bubble Academy', NULL, 'platform'),
(14, 'AWS Educate', NULL, 'company'),
(15, 'AgFunder', NULL, 'platform'),
(16, 'IDEO U', NULL, 'platform'),
(17, 'LOCAL GOOD', NULL, 'npo'),
(18, 'EF English Live', NULL, 'platform'),
(19, 'BBC Learning English', NULL, 'platform'),
(20, 'TED', NULL, 'platform'),
(21, 'Cambly', NULL, 'platform'),
(22, 'Facilitation Association', NULL, 'npo'),
(23, 'Peatix University', NULL, 'university');

-- Table structure for `organizations`
DROP TABLE IF EXISTS `organizations`;
CREATE TABLE `organizations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `type` enum('ngo','company','government','university','local') DEFAULT 'company',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `organizations`
INSERT INTO `organizations` (`id`, `name`, `type`) VALUES
(1, '○○商店街', 'local'),
(2, 'NPO法人 未来の街', 'ngo'),
(3, '漁港組合', 'local'),
(4, '地域商工会', 'ngo'),
(5, '市民農園運営組合', 'ngo'),
(6, '地元図書館', 'government'),
(7, '地元自治体', 'government'),
(8, '地元企業連合会', 'ngo'),
(9, '地域NPOネットワーク', 'ngo'),
(10, '地元高校広報部', 'local'),
(11, '地元観光協会', 'ngo'),
(12, '商店街振興組合', 'ngo'),
(13, '地元漁業協同組合', 'ngo'),
(14, '森林組合', 'ngo'),
(15, 'JA東京中央会', 'ngo'),
(16, '地元商工会議所', 'ngo'),
(17, '地方銀行システム部', 'company'),
(18, '地元自治体観光産業振興課', 'government'),
(19, 'FinTechデザイン部', 'company'),
(20, 'Sagri株式会社', 'company'),
(21, '海洋研究機構', 'government'),
(22, '林業技術センター', 'government'),
(23, '観光Tech企業', 'company'),
(24, '環境Tech企業', 'company'),
(25, '観光庁', 'government'),
(26, '国際環境データ研究機構', 'government');

-- Table structure for `quest_benefits`
DROP TABLE IF EXISTS `quest_benefits`;
CREATE TABLE `quest_benefits` (
  `id` int NOT NULL AUTO_INCREMENT,
  `quest_id` int NOT NULL,
  `benefit_name` varchar(255) NOT NULL COMMENT '特典名',
  `benefit_description` text COMMENT '特典説明',
  `benefit_type` enum('item','experience','access','recommendation','other') DEFAULT 'other',
  `monetary_value` int DEFAULT '0' COMMENT '金銭的価値（円）',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `quest_id` (`quest_id`),
  CONSTRAINT `quest_benefits_ibfk_1` FOREIGN KEY (`quest_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='クエスト特典テーブル';

-- Data for table `quest_benefits`
INSERT INTO `quest_benefits` (`id`, `quest_id`, `benefit_name`, `benefit_description`, `benefit_type`, `monetary_value`, `created_at`) VALUES
(1, 1, 'クエストのサポーター参加権', '次回クエストにサポーターとして参加できる権利', 'access', 0, '2025-08-23 10:48:47'),
(2, 2, 'クエストのサポーター参加権', '次回クエストにサポーターとして参加できる権利', 'access', 0, '2025-08-23 10:48:47'),
(3, 3, 'クエストのサポーター参加権', '次回クエストにサポーターとして参加できる権利', 'access', 0, '2025-08-23 10:48:47'),
(4, 4, '社会課題に関するセミナー参加権', '社会課題解決に関するセミナーへの参加権', 'access', 0, '2025-08-23 10:48:47'),
(5, 5, '社会課題に関するセミナー参加権', '社会課題解決に関するセミナーへの参加権', 'access', 0, '2025-08-23 10:48:47'),
(6, 6, '社会課題に関するセミナー参加権', '社会課題解決に関するセミナーへの参加権', 'access', 0, '2025-08-23 10:48:47'),
(7, 7, '学校オリジナルグッズ', '学校のオリジナルグッズをプレゼント', 'item', 1000, '2025-08-23 10:48:47'),
(8, 8, '地域通貨で使えるクーポン', '地域通貨500円分のクーポン', 'item', 500, '2025-08-23 10:48:47'),
(9, 9, '商店街商品券', '商店街で使える商品券1000円分', 'item', 1000, '2025-08-23 10:48:47'),
(10, 10, '地元海産物セット', '地元で獲れた新鮮な海産物セット', 'item', 3000, '2025-08-23 10:48:47'),
(11, 11, '森林体験ツアー招待', '森林での体験ツアーへの招待券', 'experience', 5000, '2025-08-23 10:48:47'),
(12, 12, '農業体験チケット', '農業体験への参加チケット', 'experience', 3000, '2025-08-23 10:48:47'),
(13, 13, '地元飲食店ペア食事券', '地元飲食店で使えるペア食事券', 'item', 5000, '2025-08-23 10:48:47'),
(14, 14, 'BaaS企業プレインターン体験', 'BaaS企業でのプレインターン体験機会', 'experience', 0, '2025-08-23 10:48:47'),
(15, 15, 'BaaS企業プレインターン体験', 'BaaS企業でのプレインターン体験機会', 'experience', 0, '2025-08-23 10:48:47'),
(16, 16, 'BaaS企業プレインターン体験', 'BaaS企業でのプレインターン体験機会', 'experience', 0, '2025-08-23 10:48:47'),
(17, 17, 'Sagriインターン応募資格', 'Sagri株式会社のインターンへの応募資格', 'access', 0, '2025-08-23 10:48:47'),
(18, 18, '海洋研究所インターン参加権', '海洋研究所でのインターン参加権', 'access', 0, '2025-08-23 10:48:47'),
(19, 19, '林業企業インターン参加権', '林業関連企業でのインターン参加権', 'access', 0, '2025-08-23 10:48:47'),
(20, 20, '観光地無料宿泊券', '提携観光地での無料宿泊券', 'item', 10000, '2025-08-23 10:48:47'),
(21, 21, 'Sagri内定推薦', 'Sagri株式会社への内定推薦状', 'recommendation', 0, '2025-08-23 10:48:47'),
(22, 22, '環境Tech企業採用推薦', '環境Tech企業への採用推薦状', 'recommendation', 0, '2025-08-23 10:48:47'),
(23, 23, '観光庁プロジェクト参加権', '観光庁プロジェクトへの参加権', 'access', 0, '2025-08-23 10:48:47'),
(24, 24, '海外出張参加権', '海外プロジェクトへの出張参加権', 'experience', 50000, '2025-08-23 10:48:47'),
(25, 25, 'データサイエンティスト認定証', 'データサイエンススキルの認定証', 'other', 0, '2025-08-23 10:50:08'),
(26, 26, 'ブロックチェーン開発者証明', 'ブロックチェーン開発スキルの証明書', 'other', 0, '2025-08-23 10:50:08'),
(27, 27, 'AI開発実績証明', 'AI開発プロジェクト参加実績の証明', 'other', 0, '2025-08-23 10:50:08');

-- Table structure for `quest_skills`
DROP TABLE IF EXISTS `quest_skills`;
CREATE TABLE `quest_skills` (
  `id` int NOT NULL AUTO_INCREMENT,
  `quest_id` int NOT NULL,
  `skill_name` varchar(100) NOT NULL COMMENT 'スキル名',
  `skill_type` enum('required','recommended','acquired') NOT NULL DEFAULT 'required',
  `skill_level` enum('beginner','intermediate','advanced') DEFAULT 'beginner',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_quest_skill` (`quest_id`,`skill_type`),
  CONSTRAINT `quest_skills_ibfk_1` FOREIGN KEY (`quest_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='クエスト必要・習得スキルテーブル';

-- Data for table `quest_skills`
INSERT INTO `quest_skills` (`id`, `quest_id`, `skill_name`, `skill_type`, `skill_level`, `created_at`) VALUES
(1, 1, 'コミュニケーション', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(2, 1, '協力作業', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(3, 2, '屋外作業', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(4, 2, '基本的な農作業', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(5, 3, '接客', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(6, 3, '会場準備', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(7, 4, '情報収集', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(8, 4, 'レポート作成', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(9, 5, 'インタビュー', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(10, 5, '記事作成', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(11, 6, 'ボランティア体験', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(12, 6, '発表', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(13, 7, 'HTML', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(14, 7, 'CSS', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(15, 8, 'HTML', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(16, 8, 'CSS', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(17, 8, 'JavaScript', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(18, 9, 'HTML', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(19, 9, 'CSS', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(20, 10, 'JavaScript', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(21, 10, 'Matplotlib', 'recommended', 'beginner', '2025-08-23 10:48:47'),
(22, 11, 'HTML', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(23, 11, 'CSS', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(24, 11, 'Git', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(25, 12, 'HTML', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(26, 12, 'CSS', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(27, 12, 'JavaScript', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(28, 13, 'Webマーケティング基礎', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(29, 13, 'SEO', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(30, 14, 'Python', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(31, 14, 'データ可視化', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(32, 14, 'SQL', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(33, 15, 'API活用', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(34, 15, 'JavaScript', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(35, 15, 'HTML', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(36, 16, 'UI/UX設計', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(37, 16, 'Figma', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(38, 16, 'ユーザーテスト', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(39, 17, 'Python', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(40, 17, 'API活用', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(41, 17, 'データ分析', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(42, 18, 'Python', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(43, 18, 'データ可視化', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(44, 18, 'クラウド', 'recommended', 'intermediate', '2025-08-23 10:48:47'),
(45, 19, 'Python', 'recommended', 'advanced', '2025-08-23 10:48:47'),
(46, 19, '画像認識', 'recommended', 'advanced', '2025-08-23 10:48:47'),
(47, 20, 'Python', 'recommended', 'advanced', '2025-08-23 10:48:47'),
(48, 20, '機械学習基礎', 'recommended', 'advanced', '2025-08-23 10:48:47'),
(49, 21, 'Python', 'recommended', 'advanced', '2025-08-23 10:48:47'),
(50, 21, 'API', 'recommended', 'advanced', '2025-08-23 10:48:47'),
(51, 21, '国際協力', 'recommended', 'advanced', '2025-08-23 10:48:47'),
(52, 22, 'アプリ開発', 'recommended', 'advanced', '2025-08-23 10:48:47'),
(53, 22, '翻訳・ローカライズ', 'recommended', 'advanced', '2025-08-23 10:48:47'),
(54, 23, '機械学習', 'recommended', 'advanced', '2025-08-23 10:48:47'),
(55, 23, 'データ可視化', 'recommended', 'advanced', '2025-08-23 10:48:47'),
(56, 24, 'Python', 'recommended', 'advanced', '2025-08-23 10:48:47'),
(57, 24, 'API活用', 'recommended', 'advanced', '2025-08-23 10:48:47'),
(58, 24, 'データ可視化', 'recommended', 'advanced', '2025-08-23 10:48:47'),
(59, 24, '国際協力', 'recommended', 'advanced', '2025-08-23 10:48:47'),
(60, 25, 'Python', 'recommended', 'advanced', '2025-08-23 10:50:07'),
(61, 25, '機械学習', 'recommended', 'advanced', '2025-08-23 10:50:07'),
(62, 25, 'データ分析', 'recommended', 'advanced', '2025-08-23 10:50:07'),
(63, 26, 'Solidity', 'recommended', 'intermediate', '2025-08-23 10:50:07'),
(64, 26, 'スマートコントラクト', 'recommended', 'intermediate', '2025-08-23 10:50:07'),
(65, 26, 'ブロックチェーン基礎', 'recommended', 'intermediate', '2025-08-23 10:50:07'),
(66, 27, 'Python', 'recommended', 'advanced', '2025-08-23 10:50:07'),
(67, 27, 'ChatGPT API', 'recommended', 'advanced', '2025-08-23 10:50:07'),
(68, 27, 'Webサービス開発', 'recommended', 'advanced', '2025-08-23 10:50:07');

-- Table structure for `quest_tags`
DROP TABLE IF EXISTS `quest_tags`;
CREATE TABLE `quest_tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `quest_id` int NOT NULL,
  `tag_name` varchar(50) NOT NULL,
  `tag_category` varchar(50) DEFAULT NULL COMMENT 'タグカテゴリ（skill/tool/domain等）',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_quest_tag` (`quest_id`,`tag_name`),
  CONSTRAINT `quest_tags_ibfk_1` FOREIGN KEY (`quest_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='クエストタグテーブル';


-- Table structure for `quests`
DROP TABLE IF EXISTS `quests`;
CREATE TABLE `quests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL COMMENT 'クエストタイトル',
  `description` text COMMENT 'クエストの説明',
  `objective` text COMMENT 'クエストの目的',
  `difficulty_level` int DEFAULT '1' COMMENT '難易度レベル（1:初級, 2-3:中級, 4-5:上級）',
  `difficulty_name` enum('beginner','intermediate','advanced') DEFAULT 'beginner',
  `provider_id` bigint DEFAULT NULL COMMENT '提供組織ID',
  `provider_name` varchar(255) DEFAULT NULL COMMENT '提供団体/企業名（直接入力用）',
  `duration_months` decimal(3,1) DEFAULT '1.0' COMMENT 'クエスト期間（月）',
  `estimated_hours` int DEFAULT '0' COMMENT '推定所要時間',
  `max_participants` int DEFAULT NULL COMMENT '募集人数',
  `current_participants` int DEFAULT '0' COMMENT '応募人数',
  `points_find` int DEFAULT '0' COMMENT 'みつける力ポイント',
  `points_shape` int DEFAULT '0' COMMENT 'かたちにする力ポイント',
  `points_deliver` int DEFAULT '0' COMMENT 'とどける力ポイント',
  `total_points` int GENERATED ALWAYS AS (((`points_find` + `points_shape`) + `points_deliver`)) STORED COMMENT '合計ポイント',
  `status` enum('draft','available','in_progress','completed','archived') DEFAULT 'available',
  `match_rate` int DEFAULT '0' COMMENT 'マッチ度（%）',
  `quest_type` enum('quest','benefit_use') DEFAULT 'quest' COMMENT '区分（クエスト/特典利用）',
  `prerequisite_text` text COMMENT '参加条件（テキスト）',
  `prerequisite_score` int DEFAULT '0' COMMENT '必要な総合スコア',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `start_date` date DEFAULT NULL COMMENT '開始日',
  `end_date` date DEFAULT NULL COMMENT '終了日',
  `deadline` date DEFAULT NULL COMMENT '応募締切日',
  PRIMARY KEY (`id`),
  KEY `provider_id` (`provider_id`),
  KEY `idx_quest_status` (`status`),
  KEY `idx_quest_type` (`quest_type`),
  CONSTRAINT `quests_ibfk_1` FOREIGN KEY (`provider_id`) REFERENCES `organizations` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='クエスト情報テーブル';

-- Data for table `quests`
INSERT INTO `quests` (`id`, `title`, `description`, `objective`, `difficulty_level`, `difficulty_name`, `provider_id`, `provider_name`, `duration_months`, `estimated_hours`, `max_participants`, `current_participants`, `points_find`, `points_shape`, `points_deliver`, `total_points`, `status`, `match_rate`, `quest_type`, `prerequisite_text`, `prerequisite_score`, `created_at`, `updated_at`, `start_date`, `end_date`, `deadline`) VALUES
(1, '地域イベント運営サポート', '地域祭りやマルシェでの会場設営・受付補助を行い、運営者から企画の話を聞く', 'イベント運営の裏側体験', 1, 'beginner', 4, '地域商工会', '0.1', 0, 5, 4, 0, 0, 0, 0, 'available', 88, 'benefit_use', NULL, 50, '2025-08-20 22:53:33', '2025-08-20 23:02:56', '2025-09-01', NULL, '2025-08-30'),
(2, '市民農園作業補助', '市民農園での植え付け・水やり・収穫の補助を行い、農園運営者から地域農業の話を聞く', '農作業と地域交流体験', 1, 'beginner', 5, '市民農園運営組合', '0.1', 0, 6, 5, 0, 0, 0, 0, 'available', 92, 'benefit_use', NULL, 50, '2025-08-20 22:53:33', '2025-08-20 23:02:56', '2025-09-01', NULL, '2025-08-30'),
(3, '地元図書館イベント手伝い', '地元図書館の朗読会やワークショップで会場準備や参加者案内を行い、司書から企画意図を聞く', '文化活動の支援体験', 1, 'beginner', 6, '地元図書館', '0.1', 0, 4, 3, 0, 0, 0, 0, 'available', 86, 'benefit_use', NULL, 50, '2025-08-20 22:53:33', '2025-08-20 23:02:56', '2025-09-01', NULL, '2025-08-30'),
(4, '地域の社会課題調査レポート作成', '地域の高齢化・環境・産業などの課題を調査しレポートにまとめる', '地域課題の現状把握', 1, 'beginner', 7, '地元自治体', '0.3', 0, 10, 8, 0, 0, 0, 0, 'available', 95, 'benefit_use', NULL, 100, '2025-08-20 22:53:33', '2025-08-20 23:02:56', '2025-09-01', NULL, '2025-09-30'),
(5, '企業CSR事例インタビュー', '地元企業のCSR担当者へ取材し、取り組みを記事化する', '企業の社会貢献事例の理解', 1, 'beginner', 8, '地元企業連合会', '0.5', 0, 8, 6, 0, 0, 0, 0, 'available', 91, 'benefit_use', NULL, 100, '2025-08-20 22:53:33', '2025-08-20 23:02:56', '2025-09-01', NULL, '2025-09-30'),
(6, 'NPO活動1日体験記', 'NPOの活動に1日参加し、学んだことをまとめて発表する', '市民活動の現場理解', 1, 'beginner', 9, '地域NPOネットワーク', '0.5', 0, 10, 7, 0, 0, 0, 0, 'available', 89, 'benefit_use', NULL, 100, '2025-08-20 22:53:33', '2025-08-20 23:02:56', '2025-09-01', NULL, '2025-09-30'),
(7, '学校部活動紹介ページリニューアル', '部活動紹介ページを刷新し、新入生の参加意欲を高める', '部活動への参加促進', 1, 'beginner', 10, '地元高校広報部', '1.0', 0, 6, 5, 30, 30, 40, 100, 'available', 91, 'quest', 'HTML/CSS初級修了、在校生またはOB/OG', 150, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(8, '地域の飲食店レビューサイト開発', '地域の飲食店レビューを集め、観光促進に活用するWebサイトを制作', '若者の発信で地域飲食店の魅力を可視化', 2, 'intermediate', 11, '地元観光協会', '0.8', 0, 10, 8, 30, 20, 30, 80, 'available', 87, 'quest', 'HTML/CSS初級修了、事前WS参加', 150, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(9, '商店街デジタルマップ制作', '商店街の位置情報・イベント情報を集約したデジタルマップを制作', '来街者増加による商店街活性化', 2, 'intermediate', 12, '商店街振興組合', '1.0', 0, 8, 7, 25, 24, 28, 77, 'available', 95, 'quest', 'HTML/CSS初級修了', 150, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(10, '漁港水揚げデータ可視化', '水揚げデータを可視化し、観光PRや地域ブランド強化に活用', '漁業資源の魅力発信', 3, 'intermediate', 13, '地元漁業協同組合', '0.8', 0, 6, 6, 35, 35, 45, 115, 'available', 86, 'quest', 'JavaScript基礎修了、初級1件完了', 250, '2025-08-20 22:53:33', '2025-08-21 05:00:51', '2025-09-01', NULL, '2025-10-01'),
(11, '森林管理団体作業記録アプリ開発補助', '森林作業記録アプリのUI改善や機能追加を行う', '森林管理の効率化', 3, 'intermediate', 14, '森林組合', '1.0', 0, 6, 4, 30, 40, 45, 115, 'available', 84, 'quest', 'HTML/CSS中級修了、初級1件完了', 250, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(12, '地域農産物PR用SNS運用', '地域農産物の特長を取材・撮影し、InstagramやTikTokなどで発信。季節感や生産者の思いを伝えるコンテンツを制作し、販売促進に繋げる。', '地域農産物の魅力をSNSで発信し、認知拡大と販路拡大を図る', 3, 'intermediate', 15, 'JA東京中央会', '1.0', 0, 8, 6, 35, 45, 40, 120, 'available', 93, 'quest', 'JavaScript中級修了、初級1件完了', 250, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(13, '中小企業オンライン集客改善', 'SNS・SEOを使ったオンライン集客を支援', '地域企業の売上向上', 3, 'intermediate', 16, '地元商工会議所', '1.5', 0, 10, 9, 30, 45, 50, 125, 'available', 89, 'quest', 'Webマーケ基礎修了、初級1件完了', 250, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(14, '地域金融データ可視化ダッシュボード開発', '地域の融資・取引データを匿名加工し、経済動向を可視化するダッシュボードを開発', '地域経済の見える化', 4, 'advanced', 17, '地方銀行システム部', '1.0', 0, 6, 5, 0, 0, 0, 0, 'available', 85, 'benefit_use', NULL, 450, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(15, '地域通貨×来店スタンプMVP開発（店舗QR×LINE API）', '店舗QRとLINE APIを活用し、来店ごとにスタンプ付与・地域通貨還元ができるMVPを開発。地域農産物PRと連動し、集客〜購買促進の流れを実証。', '地域通貨と来店スタンプで地域経済の循環を促進する', 4, 'advanced', 18, '地元自治体観光産業振興課', '1.5', 0, 5, 5, 0, 0, 0, 0, 'available', 93, 'benefit_use', NULL, 450, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(16, 'UX改善型モバイルバンキングアプリ設計', '既存バンキングアプリの利用データを分析し、UI/UX改善案を設計・プロトタイプ化する', '顧客体験向上', 4, 'advanced', 19, 'FinTechデザイン部', '2.0', 0, 6, 4, 0, 0, 0, 0, 'available', 89, 'benefit_use', NULL, 450, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(17, '耕作放棄地検知プロトタイプ作成', '衛星データを用いて耕作放棄地を特定する試作システム開発', '農地有効活用促進', 4, 'advanced', 20, 'Sagri株式会社', '1.0', 0, 5, 4, 45, 55, 55, 155, 'available', 92, 'quest', 'Python基礎修了、チーム開発経験', 500, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(18, '漁業IoTセンサーデータ分析', 'IoTセンサーから取得した漁獲・環境データを可視化', '漁業効率化支援', 4, 'advanced', 21, '海洋研究機構', '1.0', 0, 5, 4, 50, 60, 50, 160, 'available', 86, 'quest', 'Python基礎修了、データ分析経験', 500, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(19, 'スマート林業空撮解析', 'ドローン空撮データをAIで解析し伐採計画に活用', '森林保護と効率化', 4, 'advanced', 22, '林業技術センター', '1.5', 0, 4, 3, 50, 55, 60, 165, 'available', 76, 'quest', 'Python基礎修了、画像解析経験', 500, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(20, '観光AIプランナー開発', 'AIで観光客に合わせた旅行プランを自動生成', '観光産業のデジタル化', 4, 'advanced', 23, '観光Tech企業', '2.0', 0, 6, 5, 50, 50, 55, 155, 'available', 75, 'quest', 'Python基礎修了、機械学習入門修了', 500, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(21, 'アフリカ農村耕作放棄地検知導入', 'Sagriの衛星データ解析システムをアフリカ農村に導入', '農業課題の国際解決', 5, 'advanced', 20, 'Sagri株式会社', '2.0', 0, 3, 3, 0, 0, 0, 0, 'available', 92, 'benefit_use', NULL, 600, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(22, '海洋プラ削減アプリ国際展開', '海洋プラスチック削減アプリを国際市場向けにローカライズ', '環境保護の国際展開', 5, 'advanced', 24, '環境Tech企業', '2.5', 0, 3, 2, 0, 0, 0, 0, 'available', 88, 'benefit_use', NULL, 650, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(23, '世界遺産観光地混雑予測AI', '世界遺産観光地で混雑予測AIを導入し観光管理に活用', '観光資源の持続利用', 5, 'advanced', 25, '観光庁', '2.5', 0, 3, 2, 0, 0, 0, 0, 'available', 86, 'benefit_use', NULL, 650, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(24, '新興国向け気候変動データ活用プロジェクト', '新興国の農業・都市部を対象に、衛星データと現地気象データを組み合わせ、気候変動影響を可視化', '気候変動対策の国際展開支援', 5, 'advanced', 26, '国際環境データ研究機構', '3.0', 0, 3, 2, 0, 0, 0, 0, 'available', 83, 'benefit_use', NULL, 750, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01'),
(25, '上級データサイエンス実践', '実データを使った機械学習プロジェクト', '機械学習モデルの実装', 4, 'advanced', NULL, 'AI Institute', '3.0', 0, 8, 2, 50, 60, 50, 160, 'available', 88, 'quest', NULL, 1000, '2025-08-21 04:10:41', '2025-08-21 04:10:41', NULL, NULL, '2025-12-31'),
(26, 'ブロックチェーン開発入門', 'Solidityを使ったスマートコントラクト開発', 'DApp開発の基礎', 4, 'advanced', NULL, 'Blockchain Lab', '2.5', 0, 6, 1, 45, 55, 45, 145, 'available', 82, 'quest', NULL, 1050, '2025-08-21 04:10:41', '2025-08-21 04:10:41', NULL, NULL, '2025-11-30'),
(27, 'AIプロダクト開発', 'ChatGPT APIを活用したWebサービス開発', 'AI搭載Webアプリ開発', 5, 'advanced', NULL, 'AI Startup', '4.0', 0, 5, 0, 60, 70, 60, 190, 'available', 90, 'quest', NULL, 1100, '2025-08-21 04:10:41', '2025-08-21 04:10:41', NULL, NULL, '2026-01-31');

-- Table structure for `skills_master`
DROP TABLE IF EXISTS `skills_master`;
CREATE TABLE `skills_master` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `category` enum('technical','business','language','soft','domain') DEFAULT 'technical',
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table structure for `user_benefits`
DROP TABLE IF EXISTS `user_benefits`;
CREATE TABLE `user_benefits` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `benefit_id` bigint NOT NULL,
  `status` enum('available','used','in_use') DEFAULT 'available',
  `used_at` datetime DEFAULT NULL,
  `school_year_used` enum('high1','high2','high3','univ1','univ2','univ3','univ4') DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `benefit_id` (`benefit_id`),
  CONSTRAINT `user_benefits_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `user_benefits_ibfk_2` FOREIGN KEY (`benefit_id`) REFERENCES `benefit_items` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `user_benefits`
INSERT INTO `user_benefits` (`id`, `user_id`, `benefit_id`, `status`, `used_at`, `school_year_used`) VALUES
(1, 1, 1, 'used', '2022-04-01 00:00:00', 'high2'),
(2, 1, 2, 'used', '2022-09-01 00:00:00', 'high2'),
(3, 1, 3, 'used', '2022-12-01 00:00:00', 'high2'),
(4, 1, 4, 'used', '2023-09-01 00:00:00', 'high3'),
(5, 1, 5, 'used', '2024-04-01 00:00:00', 'univ1'),
(6, 1, 6, 'used', '2024-09-01 00:00:00', 'univ1'),
(7, 1, 7, 'used', '2025-06-01 00:00:00', 'univ2'),
(8, 1, 8, 'used', '2025-08-01 00:00:00', 'univ2');

-- Table structure for `user_learning_history`
DROP TABLE IF EXISTS `user_learning_history`;
CREATE TABLE `user_learning_history` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `content_id` bigint DEFAULT NULL,
  `school_year` enum('high1','high2','high3','univ1','univ2','univ3','univ4') NOT NULL,
  `activity_type` enum('学習','クエスト','特典','特典利用') NOT NULL,
  `activity_title` varchar(255) DEFAULT NULL,
  `period_months` decimal(3,2) DEFAULT NULL,
  `points_earned_find` int DEFAULT '0',
  `points_earned_shape` int DEFAULT '0',
  `points_earned_deliver` int DEFAULT '0',
  `reward_amount` int DEFAULT '0',
  `total_score_at_time` int DEFAULT '0',
  `status` enum('completed','in_progress','available','locked') DEFAULT 'available',
  `completed_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `content_id` (`content_id`),
  CONSTRAINT `user_learning_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `user_learning_history_ibfk_2` FOREIGN KEY (`content_id`) REFERENCES `learning_contents` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `user_learning_history`
INSERT INTO `user_learning_history` (`id`, `user_id`, `content_id`, `school_year`, `activity_type`, `activity_title`, `period_months`, `points_earned_find`, `points_earned_shape`, `points_earned_deliver`, `reward_amount`, `total_score_at_time`, `status`, `completed_at`, `created_at`) VALUES
(1, 1, 1, 'high1', '学習', 'ゼロから始めるWebサイト制作', NULL, 24, 28, 8, 0, 60, 'completed', '2021-04-01 00:00:00', '2025-08-17 13:18:05'),
(2, 1, 2, 'high1', '学習', 'Pythonで学ぶプログラミング基礎', NULL, 36, 21, 12, 0, 129, 'completed', '2021-06-01 00:00:00', '2025-08-17 13:18:05'),
(3, 1, NULL, 'high2', 'クエスト', '商店街デジタルマップ制作', '1.00', 25, 24, 28, 0, 206, 'completed', '2022-12-01 00:00:00', '2025-08-17 13:18:05'),
(4, 1, NULL, 'high2', 'クエスト', '漁港水揚げデータ可視化', '1.00', 35, 35, 45, 0, 321, 'completed', '2023-02-01 00:00:00', '2025-08-17 13:18:05'),
(5, 1, NULL, 'univ1', 'クエスト', '地域通貨×来店スタンプMVP開発', '1.50', 38, 43, 52, 0, 454, 'completed', '2024-07-01 00:00:00', '2025-08-17 13:18:05'),
(6, 1, NULL, 'univ2', 'クエスト', '地域農産物PR用SNS運用', '1.00', 50, 50, 55, 0, 609, 'completed', '2025-01-01 00:00:00', '2025-08-17 13:18:05'),
(7, 1, NULL, 'univ3', 'クエスト', 'アフリカ農村耕作放棄地検知導入', '2.00', 58, 52, 63, 0, 782, 'completed', '2026-03-01 00:00:00', '2025-08-17 13:18:05'),
(8, 1, 4, 'univ2', '学習', 'Webサイト制作入門', NULL, 10, 8, 5, 0, 0, 'in_progress', NULL, '2025-08-24 08:25:21'),
(9, 1, 5, 'univ2', '学習', 'Git入門', NULL, 5, 10, 0, 0, 0, 'in_progress', NULL, '2025-08-24 08:25:21');

-- Table structure for `user_quests`
DROP TABLE IF EXISTS `user_quests`;
CREATE TABLE `user_quests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT 'ユーザーID',
  `quest_id` int NOT NULL COMMENT 'クエストID',
  `status` enum('applied','in_progress','completed','abandoned') DEFAULT 'applied',
  `progress_percentage` int DEFAULT '0' COMMENT '進捗率（%）',
  `applied_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '応募日時',
  `started_at` timestamp NULL DEFAULT NULL COMMENT '開始日時',
  `completed_at` timestamp NULL DEFAULT NULL COMMENT '完了日時',
  `last_activity_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `earned_points_find` int DEFAULT '0',
  `earned_points_shape` int DEFAULT '0',
  `earned_points_deliver` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_quest` (`user_id`,`quest_id`),
  KEY `quest_id` (`quest_id`),
  KEY `idx_user_quest_status` (`user_id`,`status`),
  CONSTRAINT `user_quests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `user_quests_ibfk_2` FOREIGN KEY (`quest_id`) REFERENCES `quests` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='ユーザークエスト参加履歴テーブル';

-- Data for table `user_quests`
INSERT INTO `user_quests` (`id`, `user_id`, `quest_id`, `status`, `progress_percentage`, `applied_at`, `started_at`, `completed_at`, `last_activity_at`, `earned_points_find`, `earned_points_shape`, `earned_points_deliver`) VALUES
(1, 1, 7, 'in_progress', 30, '2025-07-15 10:00:00', '2025-07-16 09:00:00', NULL, '2025-08-21 04:19:07', 0, 0, 0),
(2, 1, 8, 'in_progress', 65, '2025-07-20 14:30:00', '2025-07-21 10:00:00', NULL, '2025-08-21 04:19:07', 0, 0, 0),
(3, 1, 12, 'in_progress', 45, '2025-08-01 09:00:00', '2025-08-02 11:00:00', NULL, '2025-08-21 04:19:07', 0, 0, 0),
(4, 1, 17, 'in_progress', 20, '2025-08-10 13:00:00', '2025-08-11 10:00:00', NULL, '2025-08-21 04:19:07', 0, 0, 0),
(5, 1, 18, 'in_progress', 80, '2025-08-05 11:00:00', '2025-08-06 09:00:00', NULL, '2025-08-21 04:19:07', 0, 0, 0),
(6, 1, 10, 'applied', NULL, NULL, NULL, NULL, '2025-08-21 05:00:51', 0, 0, 0);

-- Table structure for `users`
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `display_name` varchar(100) NOT NULL,
  `nickname` varchar(50) DEFAULT NULL,
  `headline` varchar(255) DEFAULT NULL,
  `bio` text,
  `memo` text,
  `avatar_url` varchar(512) DEFAULT NULL,
  `school_year` enum('high1','high2','high3','univ1','univ2','univ3','univ4','graduate') DEFAULT NULL,
  `current_total_score` int DEFAULT '0',
  `role` enum('user','admin') DEFAULT 'user',
  `onboarded_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `users`
INSERT INTO `users` (`id`, `email`, `display_name`, `nickname`, `headline`, `bio`, `memo`, `avatar_url`, `school_year`, `current_total_score`, `role`, `onboarded_at`, `created_at`, `updated_at`) VALUES
(1, 'takuto@example.com', '木村 拓叶', '拓叶', 'プログラミングで地域課題を解決したい', '大学2年生として地域貢献に興味があります。', 'どんなことに興味がありますか？', NULL, 'univ2', 967, 'user', NULL, '2025-08-17 13:18:05', '2025-08-17 13:18:05');

-- Table structure for `v_quest_display`
DROP TABLE IF EXISTS `v_quest_display`;
CREATE ALGORITHM=UNDEFINED DEFINER=`osyooooo`@`%` SQL SECURITY DEFINER VIEW `v_quest_display` AS select `q`.`id` AS `id`,`q`.`title` AS `title`,`q`.`objective` AS `objective`,`q`.`description` AS `description`,`q`.`difficulty_level` AS `difficulty_level`,`q`.`provider_name` AS `provider_name`,`q`.`match_rate` AS `match_rate`,`q`.`quest_type` AS `quest_type`,`q`.`deadline` AS `deadline`,`q`.`total_points` AS `total_points`,(case when (`q`.`duration_months` < 1) then concat(round((`q`.`duration_months` * 4),0),'週間') else concat(`q`.`duration_months`,'ヶ月') end) AS `duration_display`,concat(`q`.`current_participants`,'名') AS `participants_display`,concat('+',`q`.`total_points`) AS `points_display`,coalesce(`qs`.`skills_display`,'') AS `recommended_skills`,coalesce(`qb`.`benefit_names`,'') AS `benefits`,(to_days(`q`.`deadline`) - to_days(curdate())) AS `days_until_deadline`,(case when ((to_days(`q`.`deadline`) - to_days(curdate())) <= 7) then true else false end) AS `is_urgent` from ((`quests` `q` left join `v_quest_skills_display` `qs` on((`q`.`id` = `qs`.`quest_id`))) left join (select `quest_benefits`.`quest_id` AS `quest_id`,group_concat(`quest_benefits`.`benefit_name` separator ', ') AS `benefit_names` from `quest_benefits` group by `quest_benefits`.`quest_id`) `qb` on((`q`.`id` = `qb`.`quest_id`))) where (`q`.`status` = 'available');

-- Data for table `v_quest_display`
INSERT INTO `v_quest_display` (`id`, `title`, `objective`, `description`, `difficulty_level`, `provider_name`, `match_rate`, `quest_type`, `deadline`, `total_points`, `duration_display`, `participants_display`, `points_display`, `recommended_skills`, `benefits`, `days_until_deadline`, `is_urgent`) VALUES
(1, '地域イベント運営サポート', 'イベント運営の裏側体験', '地域祭りやマルシェでの会場設営・受付補助を行い、運営者から企画の話を聞く', 1, '地域商工会', 88, 'benefit_use', '2025-08-30', 0, '0週間', '4名', '+0', 'コミュニケーション（初級） / 協力作業（初級）', 'クエストのサポーター参加権', 6, 1),
(2, '市民農園作業補助', '農作業と地域交流体験', '市民農園での植え付け・水やり・収穫の補助を行い、農園運営者から地域農業の話を聞く', 1, '市民農園運営組合', 92, 'benefit_use', '2025-08-30', 0, '0週間', '5名', '+0', '屋外作業（初級） / 基本的な農作業（初級）', 'クエストのサポーター参加権', 6, 1),
(3, '地元図書館イベント手伝い', '文化活動の支援体験', '地元図書館の朗読会やワークショップで会場準備や参加者案内を行い、司書から企画意図を聞く', 1, '地元図書館', 86, 'benefit_use', '2025-08-30', 0, '0週間', '3名', '+0', '接客（初級） / 会場準備（初級）', 'クエストのサポーター参加権', 6, 1),
(4, '地域の社会課題調査レポート作成', '地域課題の現状把握', '地域の高齢化・環境・産業などの課題を調査しレポートにまとめる', 1, '地元自治体', 95, 'benefit_use', '2025-09-30', 0, '1週間', '8名', '+0', '情報収集（初級） / レポート作成（初級）', '社会課題に関するセミナー参加権', 37, 0),
(5, '企業CSR事例インタビュー', '企業の社会貢献事例の理解', '地元企業のCSR担当者へ取材し、取り組みを記事化する', 1, '地元企業連合会', 91, 'benefit_use', '2025-09-30', 0, '2週間', '6名', '+0', 'インタビュー（初級） / 記事作成（初級）', '社会課題に関するセミナー参加権', 37, 0),
(6, 'NPO活動1日体験記', '市民活動の現場理解', 'NPOの活動に1日参加し、学んだことをまとめて発表する', 1, '地域NPOネットワーク', 89, 'benefit_use', '2025-09-30', 0, '2週間', '7名', '+0', 'ボランティア体験（初級） / 発表（初級）', '社会課題に関するセミナー参加権', 37, 0),
(7, '学校部活動紹介ページリニューアル', '部活動への参加促進', '部活動紹介ページを刷新し、新入生の参加意欲を高める', 1, '地元高校広報部', 91, 'quest', '2025-10-01', 100, '1.0ヶ月', '5名', '+100', 'HTML（初級） / CSS（初級）', '学校オリジナルグッズ', 38, 0),
(8, '地域の飲食店レビューサイト開発', '若者の発信で地域飲食店の魅力を可視化', '地域の飲食店レビューを集め、観光促進に活用するWebサイトを制作', 2, '地元観光協会', 87, 'quest', '2025-10-01', 80, '3週間', '8名', '+80', 'HTML（初級） / CSS（初級） / JavaScript（初級）', '地域通貨で使えるクーポン', 38, 0),
(9, '商店街デジタルマップ制作', '来街者増加による商店街活性化', '商店街の位置情報・イベント情報を集約したデジタルマップを制作', 2, '商店街振興組合', 95, 'quest', '2025-10-01', 77, '1.0ヶ月', '7名', '+77', 'HTML（初級） / CSS（初級）', '商店街商品券', 38, 0),
(10, '漁港水揚げデータ可視化', '漁業資源の魅力発信', '水揚げデータを可視化し、観光PRや地域ブランド強化に活用', 3, '地元漁業協同組合', 86, 'quest', '2025-10-01', 115, '3週間', '6名', '+115', 'JavaScript（初級） / Matplotlib（初級）', '地元海産物セット', 38, 0),
(11, '森林管理団体作業記録アプリ開発補助', '森林管理の効率化', '森林作業記録アプリのUI改善や機能追加を行う', 3, '森林組合', 84, 'quest', '2025-10-01', 115, '1.0ヶ月', '4名', '+115', 'HTML（中級） / CSS（中級） / Git（中級）', '森林体験ツアー招待', 38, 0),
(12, '地域農産物PR用SNS運用', '地域農産物の魅力をSNSで発信し、認知拡大と販路拡大を図る', '地域農産物の特長を取材・撮影し、InstagramやTikTokなどで発信。季節感や生産者の思いを伝えるコンテンツを制作し、販売促進に繋げる。', 3, 'JA東京中央会', 93, 'quest', '2025-10-01', 120, '1.0ヶ月', '6名', '+120', 'HTML（中級） / CSS（中級） / JavaScript（中級）', '農業体験チケット', 38, 0),
(13, '中小企業オンライン集客改善', '地域企業の売上向上', 'SNS・SEOを使ったオンライン集客を支援', 3, '地元商工会議所', 89, 'quest', '2025-10-01', 125, '1.5ヶ月', '9名', '+125', 'Webマーケティング基礎（中級） / SEO（中級）', '地元飲食店ペア食事券', 38, 0),
(14, '地域金融データ可視化ダッシュボード開発', '地域経済の見える化', '地域の融資・取引データを匿名加工し、経済動向を可視化するダッシュボードを開発', 4, '地方銀行システム部', 85, 'benefit_use', '2025-10-01', 0, '1.0ヶ月', '5名', '+0', 'Python（中級） / データ可視化（中級） / SQL（中級）', 'BaaS企業プレインターン体験', 38, 0),
(15, '地域通貨×来店スタンプMVP開発（店舗QR×LINE API）', '地域通貨と来店スタンプで地域経済の循環を促進する', '店舗QRとLINE APIを活用し、来店ごとにスタンプ付与・地域通貨還元ができるMVPを開発。地域農産物PRと連動し、集客〜購買促進の流れを実証。', 4, '地元自治体観光産業振興課', 93, 'benefit_use', '2025-10-01', 0, '1.5ヶ月', '5名', '+0', 'API活用（中級） / JavaScript（中級） / HTML（中級）', 'BaaS企業プレインターン体験', 38, 0),
(16, 'UX改善型モバイルバンキングアプリ設計', '顧客体験向上', '既存バンキングアプリの利用データを分析し、UI/UX改善案を設計・プロトタイプ化する', 4, 'FinTechデザイン部', 89, 'benefit_use', '2025-10-01', 0, '2.0ヶ月', '4名', '+0', 'UI/UX設計（中級） / Figma（中級） / ユーザーテスト（中級）', 'BaaS企業プレインターン体験', 38, 0),
(17, '耕作放棄地検知プロトタイプ作成', '農地有効活用促進', '衛星データを用いて耕作放棄地を特定する試作システム開発', 4, 'Sagri株式会社', 92, 'quest', '2025-10-01', 155, '1.0ヶ月', '4名', '+155', 'Python（中級） / API活用（中級） / データ分析（中級）', 'Sagriインターン応募資格', 38, 0),
(18, '漁業IoTセンサーデータ分析', '漁業効率化支援', 'IoTセンサーから取得した漁獲・環境データを可視化', 4, '海洋研究機構', 86, 'quest', '2025-10-01', 160, '1.0ヶ月', '4名', '+160', 'Python（中級） / データ可視化（中級） / クラウド（中級）', '海洋研究所インターン参加権', 38, 0),
(19, 'スマート林業空撮解析', '森林保護と効率化', 'ドローン空撮データをAIで解析し伐採計画に活用', 4, '林業技術センター', 76, 'quest', '2025-10-01', 165, '1.5ヶ月', '3名', '+165', 'Python（上級） / 画像認識（上級）', '林業企業インターン参加権', 38, 0),
(20, '観光AIプランナー開発', '観光産業のデジタル化', 'AIで観光客に合わせた旅行プランを自動生成', 4, '観光Tech企業', 75, 'quest', '2025-10-01', 155, '2.0ヶ月', '5名', '+155', 'Python（上級） / 機械学習基礎（上級）', '観光地無料宿泊券', 38, 0),
(21, 'アフリカ農村耕作放棄地検知導入', '農業課題の国際解決', 'Sagriの衛星データ解析システムをアフリカ農村に導入', 5, 'Sagri株式会社', 92, 'benefit_use', '2025-10-01', 0, '2.0ヶ月', '3名', '+0', 'Python（上級） / API（上級） / 国際協力（上級）', 'Sagri内定推薦', 38, 0),
(22, '海洋プラ削減アプリ国際展開', '環境保護の国際展開', '海洋プラスチック削減アプリを国際市場向けにローカライズ', 5, '環境Tech企業', 88, 'benefit_use', '2025-10-01', 0, '2.5ヶ月', '2名', '+0', 'アプリ開発（上級） / 翻訳・ローカライズ（上級）', '環境Tech企業採用推薦', 38, 0),
(23, '世界遺産観光地混雑予測AI', '観光資源の持続利用', '世界遺産観光地で混雑予測AIを導入し観光管理に活用', 5, '観光庁', 86, 'benefit_use', '2025-10-01', 0, '2.5ヶ月', '2名', '+0', '機械学習（上級） / データ可視化（上級）', '観光庁プロジェクト参加権', 38, 0),
(24, '新興国向け気候変動データ活用プロジェクト', '気候変動対策の国際展開支援', '新興国の農業・都市部を対象に、衛星データと現地気象データを組み合わせ、気候変動影響を可視化', 5, '国際環境データ研究機構', 83, 'benefit_use', '2025-10-01', 0, '3.0ヶ月', '2名', '+0', 'Python（上級） / API活用（上級） / データ可視化（上級） / 国際協力（上級）', '海外出張参加権', 38, 0),
(25, '上級データサイエンス実践', '機械学習モデルの実装', '実データを使った機械学習プロジェクト', 4, 'AI Institute', 88, 'quest', '2025-12-31', 160, '3.0ヶ月', '2名', '+160', 'Python（上級） / 機械学習（上級） / データ分析（上級）', 'データサイエンティスト認定証', 129, 0),
(26, 'ブロックチェーン開発入門', 'DApp開発の基礎', 'Solidityを使ったスマートコントラクト開発', 4, 'Blockchain Lab', 82, 'quest', '2025-11-30', 145, '2.5ヶ月', '1名', '+145', 'Solidity（中級） / スマートコントラクト（中級） / ブロックチェーン基礎（中級）', 'ブロックチェーン開発者証明', 98, 0),
(27, 'AIプロダクト開発', 'AI搭載Webアプリ開発', 'ChatGPT APIを活用したWebサービス開発', 5, 'AI Startup', 90, 'quest', '2026-01-31', 190, '4.0ヶ月', '0名', '+190', 'Python（上級） / ChatGPT API（上級） / Webサービス開発（上級）', 'AI開発実績証明', 160, 0);

-- Table structure for `v_quest_list`
DROP TABLE IF EXISTS `v_quest_list`;
CREATE ALGORITHM=UNDEFINED DEFINER=`osyooooo`@`%` SQL SECURITY DEFINER VIEW `v_quest_list` AS select `q`.`id` AS `id`,`q`.`title` AS `title`,`q`.`objective` AS `objective`,`q`.`description` AS `description`,`q`.`difficulty_level` AS `difficulty_level`,`q`.`difficulty_name` AS `difficulty_name`,`q`.`provider_name` AS `provider_name`,`q`.`duration_months` AS `duration_months`,`q`.`deadline` AS `deadline`,`q`.`total_points` AS `total_points`,`q`.`match_rate` AS `match_rate`,`q`.`current_participants` AS `current_participants`,`q`.`max_participants` AS `max_participants`,`q`.`quest_type` AS `quest_type`,`q`.`prerequisite_score` AS `prerequisite_score`,(case when (`q`.`duration_months` < 1) then concat(round((`q`.`duration_months` * 4),0),'週間') else concat(`q`.`duration_months`,'ヶ月') end) AS `duration_display`,concat(`q`.`current_participants`,'名') AS `participants_display`,(to_days(`q`.`deadline`) - to_days(curdate())) AS `days_until_deadline` from `quests` `q` where (`q`.`status` = 'available');

-- Data for table `v_quest_list`
INSERT INTO `v_quest_list` (`id`, `title`, `objective`, `description`, `difficulty_level`, `difficulty_name`, `provider_name`, `duration_months`, `deadline`, `total_points`, `match_rate`, `current_participants`, `max_participants`, `quest_type`, `prerequisite_score`, `duration_display`, `participants_display`, `days_until_deadline`) VALUES
(1, '地域イベント運営サポート', 'イベント運営の裏側体験', '地域祭りやマルシェでの会場設営・受付補助を行い、運営者から企画の話を聞く', 1, 'beginner', '地域商工会', '0.1', '2025-08-30', 0, 88, 4, 5, 'benefit_use', 50, '0週間', '4名', 6),
(2, '市民農園作業補助', '農作業と地域交流体験', '市民農園での植え付け・水やり・収穫の補助を行い、農園運営者から地域農業の話を聞く', 1, 'beginner', '市民農園運営組合', '0.1', '2025-08-30', 0, 92, 5, 6, 'benefit_use', 50, '0週間', '5名', 6),
(3, '地元図書館イベント手伝い', '文化活動の支援体験', '地元図書館の朗読会やワークショップで会場準備や参加者案内を行い、司書から企画意図を聞く', 1, 'beginner', '地元図書館', '0.1', '2025-08-30', 0, 86, 3, 4, 'benefit_use', 50, '0週間', '3名', 6),
(4, '地域の社会課題調査レポート作成', '地域課題の現状把握', '地域の高齢化・環境・産業などの課題を調査しレポートにまとめる', 1, 'beginner', '地元自治体', '0.3', '2025-09-30', 0, 95, 8, 10, 'benefit_use', 100, '1週間', '8名', 37),
(5, '企業CSR事例インタビュー', '企業の社会貢献事例の理解', '地元企業のCSR担当者へ取材し、取り組みを記事化する', 1, 'beginner', '地元企業連合会', '0.5', '2025-09-30', 0, 91, 6, 8, 'benefit_use', 100, '2週間', '6名', 37),
(6, 'NPO活動1日体験記', '市民活動の現場理解', 'NPOの活動に1日参加し、学んだことをまとめて発表する', 1, 'beginner', '地域NPOネットワーク', '0.5', '2025-09-30', 0, 89, 7, 10, 'benefit_use', 100, '2週間', '7名', 37),
(7, '学校部活動紹介ページリニューアル', '部活動への参加促進', '部活動紹介ページを刷新し、新入生の参加意欲を高める', 1, 'beginner', '地元高校広報部', '1.0', '2025-10-01', 100, 91, 5, 6, 'quest', 150, '1.0ヶ月', '5名', 38),
(8, '地域の飲食店レビューサイト開発', '若者の発信で地域飲食店の魅力を可視化', '地域の飲食店レビューを集め、観光促進に活用するWebサイトを制作', 2, 'intermediate', '地元観光協会', '0.8', '2025-10-01', 80, 87, 8, 10, 'quest', 150, '3週間', '8名', 38),
(9, '商店街デジタルマップ制作', '来街者増加による商店街活性化', '商店街の位置情報・イベント情報を集約したデジタルマップを制作', 2, 'intermediate', '商店街振興組合', '1.0', '2025-10-01', 77, 95, 7, 8, 'quest', 150, '1.0ヶ月', '7名', 38),
(10, '漁港水揚げデータ可視化', '漁業資源の魅力発信', '水揚げデータを可視化し、観光PRや地域ブランド強化に活用', 3, 'intermediate', '地元漁業協同組合', '0.8', '2025-10-01', 115, 86, 6, 6, 'quest', 250, '3週間', '6名', 38),
(11, '森林管理団体作業記録アプリ開発補助', '森林管理の効率化', '森林作業記録アプリのUI改善や機能追加を行う', 3, 'intermediate', '森林組合', '1.0', '2025-10-01', 115, 84, 4, 6, 'quest', 250, '1.0ヶ月', '4名', 38),
(12, '地域農産物PR用SNS運用', '地域農産物の魅力をSNSで発信し、認知拡大と販路拡大を図る', '地域農産物の特長を取材・撮影し、InstagramやTikTokなどで発信。季節感や生産者の思いを伝えるコンテンツを制作し、販売促進に繋げる。', 3, 'intermediate', 'JA東京中央会', '1.0', '2025-10-01', 120, 93, 6, 8, 'quest', 250, '1.0ヶ月', '6名', 38),
(13, '中小企業オンライン集客改善', '地域企業の売上向上', 'SNS・SEOを使ったオンライン集客を支援', 3, 'intermediate', '地元商工会議所', '1.5', '2025-10-01', 125, 89, 9, 10, 'quest', 250, '1.5ヶ月', '9名', 38),
(14, '地域金融データ可視化ダッシュボード開発', '地域経済の見える化', '地域の融資・取引データを匿名加工し、経済動向を可視化するダッシュボードを開発', 4, 'advanced', '地方銀行システム部', '1.0', '2025-10-01', 0, 85, 5, 6, 'benefit_use', 450, '1.0ヶ月', '5名', 38),
(15, '地域通貨×来店スタンプMVP開発（店舗QR×LINE API）', '地域通貨と来店スタンプで地域経済の循環を促進する', '店舗QRとLINE APIを活用し、来店ごとにスタンプ付与・地域通貨還元ができるMVPを開発。地域農産物PRと連動し、集客〜購買促進の流れを実証。', 4, 'advanced', '地元自治体観光産業振興課', '1.5', '2025-10-01', 0, 93, 5, 5, 'benefit_use', 450, '1.5ヶ月', '5名', 38),
(16, 'UX改善型モバイルバンキングアプリ設計', '顧客体験向上', '既存バンキングアプリの利用データを分析し、UI/UX改善案を設計・プロトタイプ化する', 4, 'advanced', 'FinTechデザイン部', '2.0', '2025-10-01', 0, 89, 4, 6, 'benefit_use', 450, '2.0ヶ月', '4名', 38),
(17, '耕作放棄地検知プロトタイプ作成', '農地有効活用促進', '衛星データを用いて耕作放棄地を特定する試作システム開発', 4, 'advanced', 'Sagri株式会社', '1.0', '2025-10-01', 155, 92, 4, 5, 'quest', 500, '1.0ヶ月', '4名', 38),
(18, '漁業IoTセンサーデータ分析', '漁業効率化支援', 'IoTセンサーから取得した漁獲・環境データを可視化', 4, 'advanced', '海洋研究機構', '1.0', '2025-10-01', 160, 86, 4, 5, 'quest', 500, '1.0ヶ月', '4名', 38),
(19, 'スマート林業空撮解析', '森林保護と効率化', 'ドローン空撮データをAIで解析し伐採計画に活用', 4, 'advanced', '林業技術センター', '1.5', '2025-10-01', 165, 76, 3, 4, 'quest', 500, '1.5ヶ月', '3名', 38),
(20, '観光AIプランナー開発', '観光産業のデジタル化', 'AIで観光客に合わせた旅行プランを自動生成', 4, 'advanced', '観光Tech企業', '2.0', '2025-10-01', 155, 75, 5, 6, 'quest', 500, '2.0ヶ月', '5名', 38),
(21, 'アフリカ農村耕作放棄地検知導入', '農業課題の国際解決', 'Sagriの衛星データ解析システムをアフリカ農村に導入', 5, 'advanced', 'Sagri株式会社', '2.0', '2025-10-01', 0, 92, 3, 3, 'benefit_use', 600, '2.0ヶ月', '3名', 38),
(22, '海洋プラ削減アプリ国際展開', '環境保護の国際展開', '海洋プラスチック削減アプリを国際市場向けにローカライズ', 5, 'advanced', '環境Tech企業', '2.5', '2025-10-01', 0, 88, 2, 3, 'benefit_use', 650, '2.5ヶ月', '2名', 38),
(23, '世界遺産観光地混雑予測AI', '観光資源の持続利用', '世界遺産観光地で混雑予測AIを導入し観光管理に活用', 5, 'advanced', '観光庁', '2.5', '2025-10-01', 0, 86, 2, 3, 'benefit_use', 650, '2.5ヶ月', '2名', 38),
(24, '新興国向け気候変動データ活用プロジェクト', '気候変動対策の国際展開支援', '新興国の農業・都市部を対象に、衛星データと現地気象データを組み合わせ、気候変動影響を可視化', 5, 'advanced', '国際環境データ研究機構', '3.0', '2025-10-01', 0, 83, 2, 3, 'benefit_use', 750, '3.0ヶ月', '2名', 38),
(25, '上級データサイエンス実践', '機械学習モデルの実装', '実データを使った機械学習プロジェクト', 4, 'advanced', 'AI Institute', '3.0', '2025-12-31', 160, 88, 2, 8, 'quest', 1000, '3.0ヶ月', '2名', 129),
(26, 'ブロックチェーン開発入門', 'DApp開発の基礎', 'Solidityを使ったスマートコントラクト開発', 4, 'advanced', 'Blockchain Lab', '2.5', '2025-11-30', 145, 82, 1, 6, 'quest', 1050, '2.5ヶ月', '1名', 98),
(27, 'AIプロダクト開発', 'AI搭載Webアプリ開発', 'ChatGPT APIを活用したWebサービス開発', 5, 'advanced', 'AI Startup', '4.0', '2026-01-31', 190, 90, 0, 5, 'quest', 1100, '4.0ヶ月', '0名', 160);

-- Table structure for `v_quest_skills_display`
DROP TABLE IF EXISTS `v_quest_skills_display`;
CREATE ALGORITHM=UNDEFINED DEFINER=`osyooooo`@`%` SQL SECURITY DEFINER VIEW `v_quest_skills_display` AS select `quest_skills`.`quest_id` AS `quest_id`,group_concat(concat(`quest_skills`.`skill_name`,(case `quest_skills`.`skill_level` when 'beginner' then '（初級）' when 'intermediate' then '（中級）' when 'advanced' then '（上級）' else '' end)) separator ' / ') AS `skills_display` from `quest_skills` where (`quest_skills`.`skill_type` in ('required','recommended')) group by `quest_skills`.`quest_id`;

-- Data for table `v_quest_skills_display`
INSERT INTO `v_quest_skills_display` (`quest_id`, `skills_display`) VALUES
(1, 'コミュニケーション（初級） / 協力作業（初級）'),
(2, '屋外作業（初級） / 基本的な農作業（初級）'),
(3, '接客（初級） / 会場準備（初級）'),
(4, '情報収集（初級） / レポート作成（初級）'),
(5, 'インタビュー（初級） / 記事作成（初級）'),
(6, 'ボランティア体験（初級） / 発表（初級）'),
(7, 'HTML（初級） / CSS（初級）'),
(8, 'HTML（初級） / CSS（初級） / JavaScript（初級）'),
(9, 'HTML（初級） / CSS（初級）'),
(10, 'JavaScript（初級） / Matplotlib（初級）'),
(11, 'HTML（中級） / CSS（中級） / Git（中級）'),
(12, 'HTML（中級） / CSS（中級） / JavaScript（中級）'),
(13, 'Webマーケティング基礎（中級） / SEO（中級）'),
(14, 'Python（中級） / データ可視化（中級） / SQL（中級）'),
(15, 'API活用（中級） / JavaScript（中級） / HTML（中級）'),
(16, 'UI/UX設計（中級） / Figma（中級） / ユーザーテスト（中級）'),
(17, 'Python（中級） / API活用（中級） / データ分析（中級）'),
(18, 'Python（中級） / データ可視化（中級） / クラウド（中級）'),
(19, 'Python（上級） / 画像認識（上級）'),
(20, 'Python（上級） / 機械学習基礎（上級）'),
(21, 'Python（上級） / API（上級） / 国際協力（上級）'),
(22, 'アプリ開発（上級） / 翻訳・ローカライズ（上級）'),
(23, '機械学習（上級） / データ可視化（上級）'),
(24, 'Python（上級） / API活用（上級） / データ可視化（上級） / 国際協力（上級）'),
(25, 'Python（上級） / 機械学習（上級） / データ分析（上級）'),
(26, 'Solidity（中級） / スマートコントラクト（中級） / ブロックチェーン基礎（中級）'),
(27, 'Python（上級） / ChatGPT API（上級） / Webサービス開発（上級）');

-- Table structure for `v_user_quest_status`
DROP TABLE IF EXISTS `v_user_quest_status`;
CREATE ALGORITHM=UNDEFINED DEFINER=`osyooooo`@`%` SQL SECURITY DEFINER VIEW `v_user_quest_status` AS select `q`.`id` AS `id`,`q`.`title` AS `title`,`q`.`description` AS `description`,`q`.`objective` AS `objective`,`q`.`difficulty_level` AS `difficulty_level`,`q`.`difficulty_name` AS `difficulty_name`,`q`.`provider_id` AS `provider_id`,`q`.`provider_name` AS `provider_name`,`q`.`duration_months` AS `duration_months`,`q`.`estimated_hours` AS `estimated_hours`,`q`.`max_participants` AS `max_participants`,`q`.`current_participants` AS `current_participants`,`q`.`points_find` AS `points_find`,`q`.`points_shape` AS `points_shape`,`q`.`points_deliver` AS `points_deliver`,`q`.`total_points` AS `total_points`,`q`.`status` AS `status`,`q`.`match_rate` AS `match_rate`,`q`.`quest_type` AS `quest_type`,`q`.`prerequisite_text` AS `prerequisite_text`,`q`.`prerequisite_score` AS `prerequisite_score`,`q`.`created_at` AS `created_at`,`q`.`updated_at` AS `updated_at`,`q`.`start_date` AS `start_date`,`q`.`end_date` AS `end_date`,`q`.`deadline` AS `deadline`,`uq`.`user_id` AS `user_id`,`uq`.`status` AS `user_status`,`uq`.`progress_percentage` AS `progress_percentage`,(case when (`uq`.`id` is null) then '応募可能' when (`uq`.`status` = 'applied') then '応募済み' when (`uq`.`status` = 'in_progress') then '進行中' when (`uq`.`status` = 'completed') then '完了済み' else '応募可能' end) AS `status_display`,(case when (`uq`.`id` is not null) then false when (`u`.`current_total_score` < `q`.`prerequisite_score`) then false when (`q`.`current_participants` >= `q`.`max_participants`) then false else true end) AS `can_apply` from ((`quests` `q` join `users` `u`) left join `user_quests` `uq` on(((`q`.`id` = `uq`.`quest_id`) and (`u`.`id` = `uq`.`user_id`))));

-- Data for table `v_user_quest_status`
INSERT INTO `v_user_quest_status` (`id`, `title`, `description`, `objective`, `difficulty_level`, `difficulty_name`, `provider_id`, `provider_name`, `duration_months`, `estimated_hours`, `max_participants`, `current_participants`, `points_find`, `points_shape`, `points_deliver`, `total_points`, `status`, `match_rate`, `quest_type`, `prerequisite_text`, `prerequisite_score`, `created_at`, `updated_at`, `start_date`, `end_date`, `deadline`, `user_id`, `user_status`, `progress_percentage`, `status_display`, `can_apply`) VALUES
(1, '地域イベント運営サポート', '地域祭りやマルシェでの会場設営・受付補助を行い、運営者から企画の話を聞く', 'イベント運営の裏側体験', 1, 'beginner', 4, '地域商工会', '0.1', 0, 5, 4, 0, 0, 0, 0, 'available', 88, 'benefit_use', NULL, 50, '2025-08-20 22:53:33', '2025-08-20 23:02:56', '2025-09-01', NULL, '2025-08-30', NULL, NULL, NULL, '応募可能', 1),
(2, '市民農園作業補助', '市民農園での植え付け・水やり・収穫の補助を行い、農園運営者から地域農業の話を聞く', '農作業と地域交流体験', 1, 'beginner', 5, '市民農園運営組合', '0.1', 0, 6, 5, 0, 0, 0, 0, 'available', 92, 'benefit_use', NULL, 50, '2025-08-20 22:53:33', '2025-08-20 23:02:56', '2025-09-01', NULL, '2025-08-30', NULL, NULL, NULL, '応募可能', 1),
(3, '地元図書館イベント手伝い', '地元図書館の朗読会やワークショップで会場準備や参加者案内を行い、司書から企画意図を聞く', '文化活動の支援体験', 1, 'beginner', 6, '地元図書館', '0.1', 0, 4, 3, 0, 0, 0, 0, 'available', 86, 'benefit_use', NULL, 50, '2025-08-20 22:53:33', '2025-08-20 23:02:56', '2025-09-01', NULL, '2025-08-30', NULL, NULL, NULL, '応募可能', 1),
(4, '地域の社会課題調査レポート作成', '地域の高齢化・環境・産業などの課題を調査しレポートにまとめる', '地域課題の現状把握', 1, 'beginner', 7, '地元自治体', '0.3', 0, 10, 8, 0, 0, 0, 0, 'available', 95, 'benefit_use', NULL, 100, '2025-08-20 22:53:33', '2025-08-20 23:02:56', '2025-09-01', NULL, '2025-09-30', NULL, NULL, NULL, '応募可能', 1),
(5, '企業CSR事例インタビュー', '地元企業のCSR担当者へ取材し、取り組みを記事化する', '企業の社会貢献事例の理解', 1, 'beginner', 8, '地元企業連合会', '0.5', 0, 8, 6, 0, 0, 0, 0, 'available', 91, 'benefit_use', NULL, 100, '2025-08-20 22:53:33', '2025-08-20 23:02:56', '2025-09-01', NULL, '2025-09-30', NULL, NULL, NULL, '応募可能', 1),
(6, 'NPO活動1日体験記', 'NPOの活動に1日参加し、学んだことをまとめて発表する', '市民活動の現場理解', 1, 'beginner', 9, '地域NPOネットワーク', '0.5', 0, 10, 7, 0, 0, 0, 0, 'available', 89, 'benefit_use', NULL, 100, '2025-08-20 22:53:33', '2025-08-20 23:02:56', '2025-09-01', NULL, '2025-09-30', NULL, NULL, NULL, '応募可能', 1),
(7, '学校部活動紹介ページリニューアル', '部活動紹介ページを刷新し、新入生の参加意欲を高める', '部活動への参加促進', 1, 'beginner', 10, '地元高校広報部', '1.0', 0, 6, 5, 30, 30, 40, 100, 'available', 91, 'quest', 'HTML/CSS初級修了、在校生またはOB/OG', 150, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', 1, 'in_progress', 30, '進行中', 0),
(8, '地域の飲食店レビューサイト開発', '地域の飲食店レビューを集め、観光促進に活用するWebサイトを制作', '若者の発信で地域飲食店の魅力を可視化', 2, 'intermediate', 11, '地元観光協会', '0.8', 0, 10, 8, 30, 20, 30, 80, 'available', 87, 'quest', 'HTML/CSS初級修了、事前WS参加', 150, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', 1, 'in_progress', 65, '進行中', 0),
(9, '商店街デジタルマップ制作', '商店街の位置情報・イベント情報を集約したデジタルマップを制作', '来街者増加による商店街活性化', 2, 'intermediate', 12, '商店街振興組合', '1.0', 0, 8, 7, 25, 24, 28, 77, 'available', 95, 'quest', 'HTML/CSS初級修了', 150, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', NULL, NULL, NULL, '応募可能', 1),
(10, '漁港水揚げデータ可視化', '水揚げデータを可視化し、観光PRや地域ブランド強化に活用', '漁業資源の魅力発信', 3, 'intermediate', 13, '地元漁業協同組合', '0.8', 0, 6, 6, 35, 35, 45, 115, 'available', 86, 'quest', 'JavaScript基礎修了、初級1件完了', 250, '2025-08-20 22:53:33', '2025-08-21 05:00:51', '2025-09-01', NULL, '2025-10-01', 1, 'applied', NULL, '応募済み', 0),
(11, '森林管理団体作業記録アプリ開発補助', '森林作業記録アプリのUI改善や機能追加を行う', '森林管理の効率化', 3, 'intermediate', 14, '森林組合', '1.0', 0, 6, 4, 30, 40, 45, 115, 'available', 84, 'quest', 'HTML/CSS中級修了、初級1件完了', 250, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', NULL, NULL, NULL, '応募可能', 1),
(12, '地域農産物PR用SNS運用', '地域農産物の特長を取材・撮影し、InstagramやTikTokなどで発信。季節感や生産者の思いを伝えるコンテンツを制作し、販売促進に繋げる。', '地域農産物の魅力をSNSで発信し、認知拡大と販路拡大を図る', 3, 'intermediate', 15, 'JA東京中央会', '1.0', 0, 8, 6, 35, 45, 40, 120, 'available', 93, 'quest', 'JavaScript中級修了、初級1件完了', 250, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', 1, 'in_progress', 45, '進行中', 0),
(13, '中小企業オンライン集客改善', 'SNS・SEOを使ったオンライン集客を支援', '地域企業の売上向上', 3, 'intermediate', 16, '地元商工会議所', '1.5', 0, 10, 9, 30, 45, 50, 125, 'available', 89, 'quest', 'Webマーケ基礎修了、初級1件完了', 250, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', NULL, NULL, NULL, '応募可能', 1),
(14, '地域金融データ可視化ダッシュボード開発', '地域の融資・取引データを匿名加工し、経済動向を可視化するダッシュボードを開発', '地域経済の見える化', 4, 'advanced', 17, '地方銀行システム部', '1.0', 0, 6, 5, 0, 0, 0, 0, 'available', 85, 'benefit_use', NULL, 450, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', NULL, NULL, NULL, '応募可能', 1),
(15, '地域通貨×来店スタンプMVP開発（店舗QR×LINE API）', '店舗QRとLINE APIを活用し、来店ごとにスタンプ付与・地域通貨還元ができるMVPを開発。地域農産物PRと連動し、集客〜購買促進の流れを実証。', '地域通貨と来店スタンプで地域経済の循環を促進する', 4, 'advanced', 18, '地元自治体観光産業振興課', '1.5', 0, 5, 5, 0, 0, 0, 0, 'available', 93, 'benefit_use', NULL, 450, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', NULL, NULL, NULL, '応募可能', 0),
(16, 'UX改善型モバイルバンキングアプリ設計', '既存バンキングアプリの利用データを分析し、UI/UX改善案を設計・プロトタイプ化する', '顧客体験向上', 4, 'advanced', 19, 'FinTechデザイン部', '2.0', 0, 6, 4, 0, 0, 0, 0, 'available', 89, 'benefit_use', NULL, 450, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', NULL, NULL, NULL, '応募可能', 1),
(17, '耕作放棄地検知プロトタイプ作成', '衛星データを用いて耕作放棄地を特定する試作システム開発', '農地有効活用促進', 4, 'advanced', 20, 'Sagri株式会社', '1.0', 0, 5, 4, 45, 55, 55, 155, 'available', 92, 'quest', 'Python基礎修了、チーム開発経験', 500, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', 1, 'in_progress', 20, '進行中', 0),
(18, '漁業IoTセンサーデータ分析', 'IoTセンサーから取得した漁獲・環境データを可視化', '漁業効率化支援', 4, 'advanced', 21, '海洋研究機構', '1.0', 0, 5, 4, 50, 60, 50, 160, 'available', 86, 'quest', 'Python基礎修了、データ分析経験', 500, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', 1, 'in_progress', 80, '進行中', 0),
(19, 'スマート林業空撮解析', 'ドローン空撮データをAIで解析し伐採計画に活用', '森林保護と効率化', 4, 'advanced', 22, '林業技術センター', '1.5', 0, 4, 3, 50, 55, 60, 165, 'available', 76, 'quest', 'Python基礎修了、画像解析経験', 500, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', NULL, NULL, NULL, '応募可能', 1),
(20, '観光AIプランナー開発', 'AIで観光客に合わせた旅行プランを自動生成', '観光産業のデジタル化', 4, 'advanced', 23, '観光Tech企業', '2.0', 0, 6, 5, 50, 50, 55, 155, 'available', 75, 'quest', 'Python基礎修了、機械学習入門修了', 500, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', NULL, NULL, NULL, '応募可能', 1),
(21, 'アフリカ農村耕作放棄地検知導入', 'Sagriの衛星データ解析システムをアフリカ農村に導入', '農業課題の国際解決', 5, 'advanced', 20, 'Sagri株式会社', '2.0', 0, 3, 3, 0, 0, 0, 0, 'available', 92, 'benefit_use', NULL, 600, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', NULL, NULL, NULL, '応募可能', 0),
(22, '海洋プラ削減アプリ国際展開', '海洋プラスチック削減アプリを国際市場向けにローカライズ', '環境保護の国際展開', 5, 'advanced', 24, '環境Tech企業', '2.5', 0, 3, 2, 0, 0, 0, 0, 'available', 88, 'benefit_use', NULL, 650, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', NULL, NULL, NULL, '応募可能', 1),
(23, '世界遺産観光地混雑予測AI', '世界遺産観光地で混雑予測AIを導入し観光管理に活用', '観光資源の持続利用', 5, 'advanced', 25, '観光庁', '2.5', 0, 3, 2, 0, 0, 0, 0, 'available', 86, 'benefit_use', NULL, 650, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', NULL, NULL, NULL, '応募可能', 1),
(24, '新興国向け気候変動データ活用プロジェクト', '新興国の農業・都市部を対象に、衛星データと現地気象データを組み合わせ、気候変動影響を可視化', '気候変動対策の国際展開支援', 5, 'advanced', 26, '国際環境データ研究機構', '3.0', 0, 3, 2, 0, 0, 0, 0, 'available', 83, 'benefit_use', NULL, 750, '2025-08-20 22:53:33', '2025-08-20 23:01:11', '2025-09-01', NULL, '2025-10-01', NULL, NULL, NULL, '応募可能', 1),
(25, '上級データサイエンス実践', '実データを使った機械学習プロジェクト', '機械学習モデルの実装', 4, 'advanced', NULL, 'AI Institute', '3.0', 0, 8, 2, 50, 60, 50, 160, 'available', 88, 'quest', NULL, 1000, '2025-08-21 04:10:41', '2025-08-21 04:10:41', NULL, NULL, '2025-12-31', NULL, NULL, NULL, '応募可能', 0),
(26, 'ブロックチェーン開発入門', 'Solidityを使ったスマートコントラクト開発', 'DApp開発の基礎', 4, 'advanced', NULL, 'Blockchain Lab', '2.5', 0, 6, 1, 45, 55, 45, 145, 'available', 82, 'quest', NULL, 1050, '2025-08-21 04:10:41', '2025-08-21 04:10:41', NULL, NULL, '2025-11-30', NULL, NULL, NULL, '応募可能', 0),
(27, 'AIプロダクト開発', 'ChatGPT APIを活用したWebサービス開発', 'AI搭載Webアプリ開発', 5, 'advanced', NULL, 'AI Startup', '4.0', 0, 5, 0, 60, 70, 60, 190, 'available', 90, 'quest', NULL, 1100, '2025-08-21 04:10:41', '2025-08-21 04:10:41', NULL, NULL, '2026-01-31', NULL, NULL, NULL, '応募可能', 0);

-- Table structure for `v_user_radar_chart`
DROP TABLE IF EXISTS `v_user_radar_chart`;
CREATE ALGORITHM=UNDEFINED DEFINER=`osyooooo`@`%` SQL SECURITY DEFINER VIEW `v_user_radar_chart` AS select `u`.`id` AS `user_id`,`u`.`display_name` AS `display_name`,coalesce(sum(`ulh`.`points_earned_find`),0) AS `find_points`,coalesce(sum(`ulh`.`points_earned_shape`),0) AS `shape_points`,coalesce(sum(`ulh`.`points_earned_deliver`),0) AS `deliver_points`,coalesce(sum(((`ulh`.`points_earned_find` + `ulh`.`points_earned_shape`) + `ulh`.`points_earned_deliver`)),0) AS `total_points`,least(round((coalesce(sum(((`ulh`.`points_earned_find` + `ulh`.`points_earned_shape`) + `ulh`.`points_earned_deliver`)),0) * 0.15),0),125) AS `trust_score` from (`users` `u` left join `user_learning_history` `ulh` on(((`u`.`id` = `ulh`.`user_id`) and (`ulh`.`status` = 'completed')))) group by `u`.`id`,`u`.`display_name`;

-- Data for table `v_user_radar_chart`
INSERT INTO `v_user_radar_chart` (`user_id`, `display_name`, `find_points`, `shape_points`, `deliver_points`, `total_points`, `trust_score`) VALUES
(1, '木村 拓叶', '266', '253', '263', '782', '117');

-- Table structure for `yell_projects`
DROP TABLE IF EXISTS `yell_projects`;
CREATE TABLE `yell_projects` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `owner_user_id` bigint NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `why_text` text,
  `what_features` json DEFAULT NULL,
  `cover_image_url` varchar(512) DEFAULT NULL,
  `target_amount` decimal(12,0) NOT NULL,
  `current_amount` decimal(12,0) DEFAULT '0',
  `supporters_count` int DEFAULT '0',
  `due_date` date DEFAULT NULL,
  `status` enum('planning','fundraising','running','completed') DEFAULT 'fundraising',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `owner_user_id` (`owner_user_id`),
  CONSTRAINT `yell_projects_ibfk_1` FOREIGN KEY (`owner_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `yell_projects`
INSERT INTO `yell_projects` (`id`, `owner_user_id`, `title`, `description`, `why_text`, `what_features`, `cover_image_url`, `target_amount`, `current_amount`, `supporters_count`, `due_date`, `status`, `created_at`) VALUES
(1, 1, 'Memory Palette（メモリーパレット）', '高齢者の大切な思い出をデジタルで残し、家族と共有できるサービス', 'なぜつくるのか？
祖父母との思い出を残したいという想いから', '["簡単な操作で思い出を記録", "家族との共有機能", "AIによる思い出の整理"]', 'https://example.com/memory_palette_cover.jpg', '500000', '450000', 127, '2025-08-24', 'fundraising', '2025-08-17 13:18:05');

SET FOREIGN_KEY_CHECKS=1;
