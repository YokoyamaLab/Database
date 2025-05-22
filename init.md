# データベース 講義内利用DB初期化スクリプト
[戻る](index.md)

## MySQL　および　PostgreSQL　データベース構築スクリプト
```sql
-- データベースを本講義用のものへ切替(MySQL)
USE fri5database;

-- データベースを本講義用のものへ切替(PostgreSQL)
\connect fri5database

-- もし同名のテーブルが存在していたら消す(リフレッシュ用)
DROP TABLE IF EXISTS cart,blend_recipe,blender,beans,user,barista,roast,origin;

-- 原産地
CREATE TABLE origin(
    id_origin       char(2) PRIMARY KEY,
    origin          varchar(50)
);

INSERT INTO origin VALUES
('HW',	'ハワイ'),
('JM',	'ジャマイカ'),
('YE',	'イエメン'),
('CO',	'コロンビア'),
('ID',	'インドネシア'),
('KE',	'ケニア'),
('TZ',	'タンザニア');


-- 焙煎
CREATE TABLE roast(
    roast           int PRIMARY KEY,
    description     varchar(50)
);

INSERT INTO roast VALUES
(0,	'生豆'),
(1,	'ライト'),
(2,	'シナモン'),
(3,	'ミディアム'),
(4,	'ハイ'),
(5,	'シティ'),
(6,	'フルシティ'),
(7,	'フレンチ'),
(8,	'イタリアン');


-- バリスタ
CREATE TABLE barista(
    id_barista      int PRIMARY KEY,
    name            varchar(50),
    affiliation     varchar(50)
);

INSERT INTO barista VALUES
(1,	'豆生田 浅吉','Café Mame'),
(2,	'種田 豆子','喫茶豆子');


-- ユーザ
CREATE TABLE "user"(
    id_user         int PRIMARY KEY,
    name            varchar(50),
    address         varchar(50)
);

INSERT INTO "user" VALUES
(1,	'山田 太郎',	'横浜市'),
(2,	'鈴木 花子',	'札幌市'),
(3, '佐藤 次郎',    '浜松市');


-- 豆
CREATE TABLE beans(
    id_beans        int PRIMARY KEY,
    beans           varchar(50) UNIQUE,
    price           int,
    id_origin       char(2),
    acidity         smallint CHECK (acidity BETWEEN 0 AND 5),
    bitterness      smallint CHECK (bitterness BETWEEN 0 AND 5),
    sweetness       smallint CHECK (sweetness BETWEEN 0 AND 5),
    richness        smallint CHECK (richness BETWEEN 0 AND 5),
    aroma           smallint CHECK (aroma BETWEEN 0 AND 5),
    FOREIGN KEY (id_origin) REFERENCES origin(id_origin) 
);

INSERT INTO beans VALUES
(1,	'ハワイコナファンシー',	3500,	'HW',   5,	2,	4,	4,	5),
(2,	'ブルーマウンテンNo.1', 2000,	'JM',   2,	1,	5,	3,	5),
(3,	'モカマタリ',	        800,	'YE',   4,	3,	4,	4,	5),
(4,	'エメラルドマウンテン',  700,	'CO',   2,	1,	5,	5,	5),
(5,	'マンデリンG1',	        600,	'ID',   2,	5,	3,	4,	3),
(6,	'ケニアAA',	            590,	'KE',   5,	1,	3,	5,	4),
(7,	'ジャバロブスタ',	    630,	'ID',   1,	5,	1,	3,	1),
(8,	'キリマンジャロAA',	    300,	'TZ',   5,	2,	4,	4,	4),
(9,	'にがにがブレンド',	 620,   NULL,   2,	5,	3,	4,	4),
(10,'阿弗利加の風',	        500,    NULL,   5,	2,	4,	5,	4);


-- ブレンダー
CREATE TABLE blender(
    id_blend        int PRIMARY KEY,
    id_barista      int,
    FOREIGN KEY (id_blend) REFERENCES beans(id_beans) 
);

INSERT INTO blender VALUES
(9,     1),
(10,    2);

-- ブレンドレシピ
CREATE TABLE blend_recipe(
    id_blend        int,
    id_beans        int,
    PRIMARY KEY(id_blend,id_beans),
    FOREIGN KEY (id_blend) REFERENCES blender(id_blend),
    FOREIGN KEY (id_beans) REFERENCES beans(id_beans) 
);

INSERT INTO blend_recipe VALUES
(9,     5),
(9,     7),
(10,    6),
(10,    8);

-- カート
CREATE TABLE cart(
    id_user         int,
    id_beans        int,
    roast           int,
    amount          int,
    PRIMARY KEY(id_user,id_beans,roast),
    FOREIGN KEY (id_beans) REFERENCES beans(id_beans),
    FOREIGN KEY (roast) REFERENCES roast(roast) 
);

INSERT INTO cart VALUES
(1,	1,	5,	1),
(1,	1,	2,	2),
(1,	2,	4,	2),
(1,	5,	4,	1),
(1,	3,	6,	1),
(2,	2,	3,	1),
(2,	4,	6,	1),
(2,	5,	8,	2),
(2,	6,	5,	2),
(2,	7,	7,	3),
(2,	8,	2,	3),
(3,	9,	8,	5),
(3,	1,	4,	1);

```
