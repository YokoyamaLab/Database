# データベース 講義内利用DB初期化スクリプト
[戻る](index.md)

## MySQL　および　PostgreSQL　データベース構築スクリプト
```sql
-- データベースを本講義用のものへ切替(MySQL)
USE fri5database;

-- データベースを本講義用のものへ切替(PostgreSQL)
\connect fri5database

-- もし同名のテーブルが存在していたら消す(リフレッシュ用)
DROP TABLE IF EXISTS cart,blend_recipe, blender ,beans ,member ,barista,roast ,origin;

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
('TZ',	'タンザニア'),
('ET',	'エチオピア');


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
CREATE TABLE member(
    id_member       int PRIMARY KEY,
    name            varchar(50),
    address         varchar(50)
);

    INSERT INTO member VALUES
    (1,	'山田 太郎',	'横浜市'),
    (2,	'鈴木 花子',	'札幌市'),
    (3, '佐藤 次郎', '浜松市');


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
(2,	'ブルーマウンテンNo.1',  2000,	'JM',   2,	1,	5,	3,	5),
(3,	'モカマタリ',	        800,	'YE',   4,	3,	4,	4,	5),
(4,	'エメラルドマウンテン',   700,	'CO',   2,	1,	5,	5,	5),
(5,	'マンデリンG1',	        600,	'ID',   2,	5,	3,	4,	3),
(6,	'ケニアAA',	            590,	'KE',   5,	1,	3,	5,	4),
(7,	'ジャバロブスタ',	    630,	'ID',   1,	5,	1,	3,	1),
(8,	'キリマンジャロAA',	    410,	'TZ',   5,	2,	4,	4,	4),
(9,	'にがにがブレンド',	    620,    NULL,   2,	5,	3,	4,	4),
(10,'阿弗利加の風',	        500,    NULL,   5,	2,	4,	5,	4),
(11, 'ブルーマウンテンピーベリー',2500,'JM',  3,  1,  5,  3,  4),
(12, 'コロンビアスプレモ',    410,    'CO',  3,  1,  4,   5,  4);


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
    id_member       int,
    id_beans        int,
    roast           int,
    amount          int,
    PRIMARY KEY(id_member,id_beans,roast),
    FOREIGN KEY (id_beans) REFERENCES beans(id_beans),
    FOREIGN KEY (id_member) REFERENCES member(id_member),
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

## MongoDB 構築スクリプト

```JavaScript
db.origin.insertMany([
{"id_origin": "HW", "origin": "ハワイ"},
{"id_origin": "JM", "origin": "ジャマイカ"},
{"id_origin": "YE", "origin": "イエメン"},
{"id_origin": "CO", "origin": "コロンビア"},
{"id_origin": "ID", "origin": "インドネシア"},
{"id_origin": "KE", "origin": "ケニア"},
{"id_origin": "TZ", "origin": "タンザニア"},
{"id_origin": "ET", "origin": "エチオピア"},
]);

db.beans.insertMany([
{"id_beans": 1, "beans": "ハワイコナファンシー", "price": 3500, "id_origin": "HW", "acidity": 5, "bitterness": 2, "sweetness": 4, "richness": 4, "aroma": 5},
{"id_beans": 2, "beans": "ブルーマウンテンNo.1", "price": 2000, "id_origin": "JM", "acidity": 2, "bitterness": 1, "sweetness": 5, "richness": 3, "aroma": 5},
{"id_beans": 3, "beans": "モカマタリ", "price": 800, "id_origin": "YE", "acidity": 4, "bitterness": 3, "sweetness": 4, "richness": 4, "aroma": 5},
{"id_beans": 4, "beans": "エメラルドマウンテン", "price": 700, "id_origin": "CO", "acidity": 2, "bitterness": 1, "sweetness": 5, "richness": 5, "aroma": 5},
{"id_beans": 5, "beans": "マンデリンＧ１", "price": 600, "id_origin": "ID", "acidity": 2, "bitterness": 5, "sweetness": 3, "richness": 4, "aroma": 3},
{"id_beans": 6, "beans": "ケニアAA", "price": 590, "id_origin": "KE", "acidity": 5, "bitterness": 1, "sweetness": 3, "richness": 5, "aroma": 4},
{"id_beans": 7, "beans": "ジャバロブスタ", "price": 630, "id_origin": "ID", "acidity": 1, "bitterness": 5, "sweetness": 1, "richness": 3, "aroma": 1},
{"id_beans": 8, "beans": "キリマンジャロＡＡ", "price": 410, "id_origin": "TZ", "acidity": 5, "bitterness": 2, "sweetness": 4, "richness": 4, "aroma": 4},
{"id_beans": 9, "beans": "にがにがブレンド", "price": 620, "id_origin": null, "acidity": 2, "bitterness": 5, "sweetness": 3, "richness": 4, "aroma": 4},
{"id_beans": 10, "beans": "阿弗利加の風", "price": 500, "id_origin": null, "acidity": 5, "bitterness": 2, "sweetness": 4, "richness": 5, "aroma": 4},
{"id_beans": 11, "beans": "ブルーマウンテンピーベリー", "price": 2500, "id_origin": "JM", "acidity": 3, "bitterness": 1, "sweetness": 5, "richness": 3, "aroma": 4},
{"id_beans": 12, "beans": "コロンビアスプレモ", "price": 410, "id_origin": "CO", "acidity": 3, "bitterness": 1, "sweetness": 4, "richness": 5, "aroma": 4},
]);

db.review.insertMany([
{"user": {"id": 1, "name": "レビュアー1", "genderAge": "F2"}, "star": 2, "keywords": ["酸味", "爽やか"], "review": "このコーヒーは酸味が特徴で、爽やかが楽しめます。 期待していたほどの深みは感じられませんでした。", "timestamp": {"$date": "2021-09-01T00:00:00Z"}, "beans": "ハワイコナファンシー", "id_beans": 1},
{"user": {"id": 1, "name": "レビュアー1", "genderAge": "F2"}, "star": 5, "keywords": ["酸味", "爽やか"], "review": "これ以上のコーヒーはないと言っても過言ではありません。まさに芸術品です。", "timestamp": {"$date": "2022-07-06T00:00:00Z"}, "beans": "ブルーマウンテンNo.1", "id_beans": 2},
{"user": {"id": 1, "name": "レビュアー1", "genderAge": "F2"}, "star": 5, "keywords": ["酸味", "爽やか"], "review": "過去最高のコーヒー体験でした。洗練された風味が感動を与えてくれます。", "timestamp": {"$date": "2024-08-06T00:00:00Z"}, "beans": "モカマタリ", "id_beans": 3},
{"user": {"id": 1, "name": "レビュアー1", "genderAge": "F2"}, "star": 5, "keywords": ["スパイシー", "個性派"], "review": "濃厚でありながら繊細な味わい。まるで特別な瞬間のために用意されたような豆です。", "timestamp": {"$date": "2024-04-08T00:00:00Z"}, "beans": "エメラルドマウンテン", "id_beans": 4},
{"user": {"id": 1, "name": "レビュアー1", "genderAge": "F2"}, "star": 5, "keywords": ["スパイシー", "個性派"], "review": "これはまさに極上の一杯です。香り、味わい、余韻のすべてが完璧でした。", "timestamp": {"$date": "2020-06-02T00:00:00Z"}, "beans": "マンデリンＧ１", "id_beans": 5},
{"user": {"id": 1, "name": "レビュアー1", "genderAge": "F2"}, "star": 3, "keywords": ["香り高い", "濃厚"], "review": "濃厚を感じさせる香りと、香り高いな味わいが魅力です。", "timestamp": {"$date": "2022-12-23T00:00:00Z"}, "beans": "ケニアAA", "id_beans": 6},
{"user": {"id": 1, "name": "レビュアー1", "genderAge": "F2"}, "star": 4, "keywords": ["苦味", "余韻"], "review": "苦味と余韻が絶妙に調和した逸品です。", "timestamp": {"$date": "2023-03-20T00:00:00Z"}, "beans": "ジャバロブスタ", "id_beans": 7},
{"user": {"id": 1, "name": "レビュアー1", "genderAge": "F2"}, "star": 1, "keywords": ["高級", "アロマ"], "review": "雑味が強く、飲むに堪えないレベルでした。", "timestamp": {"$date": "2021-09-19T00:00:00Z"}, "beans": "キリマンジャロＡＡ", "id_beans": 8},
{"user": {"id": 1, "name": "レビュアー1", "genderAge": "F2"}, "star": 3, "keywords": ["深煎り", "コク"], "review": "コクを感じさせる香りと、深煎りな味わいが魅力です。", "timestamp": {"$date": "2023-09-16T00:00:00Z"}, "beans": "にがにがブレンド", "id_beans": 9},
{"user": {"id": 1, "name": "レビュアー1", "genderAge": "F2"}, "star": 3, "keywords": ["スパイシー", "個性派"], "review": "このコーヒーはスパイシーが特徴で、個性派が楽しめます。", "timestamp": {"$date": "2024-08-21T00:00:00Z"}, "beans": "阿弗利加の風", "id_beans": 10},
{"user": {"id": 1, "name": "レビュアー1", "genderAge": "F2"}, "star": 4, "keywords": ["深煎り", "コク"], "review": "飲み口が深煎りで、後味にコクが残ります。", "timestamp": {"$date": "2022-06-28T00:00:00Z"}, "beans": "ブルーマウンテンピーベリー", "id_beans": 11},
{"user": {"id": 1, "name": "レビュアー1", "genderAge": "F2"}, "star": 3, "keywords": ["酸味", "爽やか"], "review": "飲み口が酸味で、後味に爽やかが残ります。", "timestamp": {"$date": "2024-10-22T00:00:00Z"}, "beans": "コロンビアスプレモ", "id_beans": 12},
{"user": {"id": 3, "name": "レビュアー3", "genderAge": "M1"}, "star": 3, "keywords": ["香り高い", "濃厚"], "review": "このコーヒーは香り高いが特徴で、濃厚が楽しめます。", "timestamp": {"$date": "2023-09-03T00:00:00Z"}, "beans": "阿弗利加の風", "id_beans": 10},
{"user": {"id": 5, "name": "レビュアー5", "genderAge": "M3"}, "star": 3, "keywords": ["酸味", "爽やか"], "review": "酸味な風味が口に広がり、爽やかが印象的でした。", "timestamp": {"$date": "2023-09-09T00:00:00Z"}, "beans": "ケニアAA", "id_beans": 6},
{"user": {"id": 2, "name": "レビュアー2", "genderAge": "F1"}, "star": 2, "keywords": ["マイルド", "軽やか"], "review": "このコーヒーはマイルドが特徴で、軽やかが楽しめます。 期待していたほどの深みは感じられませんでした。", "timestamp": {"$date": "2021-05-18T00:00:00Z"}, "beans": "にがにがブレンド", "id_beans": 9},
{"user": {"id": 10, "name": "レビュアー10", "genderAge": "M1"}, "star": 5, "keywords": ["マイルド", "軽やか"], "review": "一口飲んだ瞬間に感動しました。香り高く、豊かな味わいが長く続きます。", "timestamp": {"$date": "2023-08-13T00:00:00Z"}, "beans": "エメラルドマウンテン", "id_beans": 4},
{"user": {"id": 8, "name": "レビュアー8", "genderAge": "M1"}, "star": 5, "keywords": ["深煎り", "コク"], "review": "濃厚でありながら繊細な味わい。まるで特別な瞬間のために用意されたような豆です。", "timestamp": {"$date": "2022-02-14T00:00:00Z"}, "beans": "エメラルドマウンテン", "id_beans": 4},
{"user": {"id": 4, "name": "レビュアー4", "genderAge": "M3"}, "star": 2, "keywords": ["深煎り", "コク"], "review": "深煎りな風味が口に広がり、コクが印象的でした。 しかし、後味に雑味が残る印象があります。", "timestamp": {"$date": "2020-08-08T00:00:00Z"}, "beans": "にがにがブレンド", "id_beans": 9},
{"user": {"id": 10, "name": "レビュアー10", "genderAge": "M1"}, "star": 4, "keywords": ["苦味", "余韻"], "review": "苦味と余韻が絶妙に調和した逸品です。", "timestamp": {"$date": "2021-06-11T00:00:00Z"}, "beans": "ブルーマウンテンNo.1", "id_beans": 2},
{"user": {"id": 2, "name": "レビュアー2", "genderAge": "F1"}, "star": 3, "keywords": ["スパイシー", "個性派"], "review": "個性派を感じさせる香りと、スパイシーな味わいが魅力です。", "timestamp": {"$date": "2021-10-08T00:00:00Z"}, "beans": "マンデリンＧ１", "id_beans": 5},
{"user": {"id": 5, "name": "レビュアー5", "genderAge": "M3"}, "star": 3, "keywords": ["苦味", "余韻"], "review": "苦味と余韻が絶妙に調和した逸品です。", "timestamp": {"$date": "2024-05-17T00:00:00Z"}, "beans": "エメラルドマウンテン", "id_beans": 4},
{"user": {"id": 5, "name": "レビュアー5", "genderAge": "M3"}, "star": 4, "keywords": ["香り高い", "濃厚"], "review": "香り高いな風味が口に広がり、濃厚が印象的でした。", "timestamp": {"$date": "2023-04-11T00:00:00Z"}, "beans": "モカマタリ", "id_beans": 3},
{"user": {"id": 6, "name": "レビュアー6", "genderAge": "F2"}, "star": 3, "keywords": ["マイルド", "軽やか"], "review": "マイルドと軽やかが絶妙に調和した逸品です。", "timestamp": {"$date": "2021-11-23T00:00:00Z"}, "beans": "マンデリンＧ１", "id_beans": 5},
{"user": {"id": 7, "name": "レビュアー7", "genderAge": "M1"}, "star": 5, "keywords": ["スパイシー", "個性派"], "review": "これはまさに極上の一杯です。香り、味わい、余韻のすべてが完璧でした。", "timestamp": {"$date": "2022-06-18T00:00:00Z"}, "beans": "エメラルドマウンテン", "id_beans": 4},
{"user": {"id": 7, "name": "レビュアー7", "genderAge": "M1"}, "star": 4, "keywords": ["高級", "アロマ"], "review": "高級な風味が口に広がり、アロマが印象的でした。", "timestamp": {"$date": "2021-10-10T00:00:00Z"}, "beans": "モカマタリ", "id_beans": 3},
{"user": {"id": 5, "name": "レビュアー5", "genderAge": "M3"}, "star": 3, "keywords": ["苦味", "余韻"], "review": "苦味な風味が口に広がり、余韻が印象的でした。", "timestamp": {"$date": "2021-08-07T00:00:00Z"}, "beans": "マンデリンＧ１", "id_beans": 5},
{"user": {"id": 2, "name": "レビュアー2", "genderAge": "F1"}, "star": 4, "keywords": ["深煎り", "コク"], "review": "飲み口が深煎りで、後味にコクが残ります。", "timestamp": {"$date": "2022-08-15T00:00:00Z"}, "beans": "モカマタリ", "id_beans": 3},
{"user": {"id": 3, "name": "レビュアー3", "genderAge": "M1"}, "star": 5, "keywords": ["深煎り", "コク"], "review": "これ以上のコーヒーはないと言っても過言ではありません。まさに芸術品です。", "timestamp": {"$date": "2023-03-25T00:00:00Z"}, "beans": "ブルーマウンテンピーベリー", "id_beans": 11},
{"user": {"id": 3, "name": "レビュアー3", "genderAge": "M1"}, "star": 5, "keywords": ["深煎り", "コク"], "review": "これはまさに極上の一杯です。香り、味わい、余韻のすべてが完璧でした。", "timestamp": {"$date": "2022-07-23T00:00:00Z"}, "beans": "ケニアAA", "id_beans": 6},
{"user": {"id": 2, "name": "レビュアー2", "genderAge": "F1"}, "star": 5, "keywords": ["深煎り", "コク"], "review": "一口飲んだ瞬間に感動しました。香り高く、豊かな味わいが長く続きます。", "timestamp": {"$date": "2023-01-12T00:00:00Z"}, "beans": "ブルーマウンテンNo.1", "id_beans": 2},
{"user": {"id": 6, "name": "レビュアー6", "genderAge": "F2"}, "star": 4, "keywords": ["スパイシー", "個性派"], "review": "飲み口がスパイシーで、後味に個性派が残ります。", "timestamp": {"$date": "2021-10-30T00:00:00Z"}, "beans": "ハワイコナファンシー", "id_beans": 1},
{"user": {"id": 5, "name": "レビュアー5", "genderAge": "M3"}, "star": 4, "keywords": ["高級", "アロマ"], "review": "このコーヒーは高級が特徴で、アロマが楽しめます。", "timestamp": {"$date": "2020-07-02T00:00:00Z"}, "beans": "にがにがブレンド", "id_beans": 9},
{"user": {"id": 8, "name": "レビュアー8", "genderAge": "M1"}, "star": 3, "keywords": ["高級", "アロマ"], "review": "このコーヒーは高級が特徴で、アロマが楽しめます。", "timestamp": {"$date": "2024-07-18T00:00:00Z"}, "beans": "阿弗利加の風", "id_beans": 10},
{"user": {"id": 5, "name": "レビュアー5", "genderAge": "M3"}, "star": 3, "keywords": ["高級", "アロマ"], "review": "高級とアロマが絶妙に調和した逸品です。", "timestamp": {"$date": "2024-02-19T00:00:00Z"}, "beans": "コロンビアスプレモ", "id_beans": 12},
{"user": {"id": 4, "name": "レビュアー4", "genderAge": "M3"}, "star": 4, "keywords": ["高級", "アロマ"], "review": "アロマを感じさせる香りと、高級な味わいが魅力です。", "timestamp": {"$date": "2023-10-27T00:00:00Z"}, "beans": "マンデリンＧ１", "id_beans": 5},
{"user": {"id": 10, "name": "レビュアー10", "genderAge": "M1"}, "star": 1, "keywords": ["深煎り", "コク"], "review": "風味が全く感じられず、非常にがっかりしました。", "timestamp": {"$date": "2021-05-12T00:00:00Z"}, "beans": "コロンビアスプレモ", "id_beans": 12},
{"user": {"id": 3, "name": "レビュアー3", "genderAge": "M1"}, "star": 3, "keywords": ["酸味", "爽やか"], "review": "爽やかを感じさせる香りと、酸味な味わいが魅力です。", "timestamp": {"$date": "2022-05-25T00:00:00Z"}, "beans": "ハワイコナファンシー", "id_beans": 1},
{"user": {"id": 5, "name": "レビュアー5", "genderAge": "M3"}, "star": 4, "keywords": ["マイルド", "軽やか"], "review": "このコーヒーはマイルドが特徴で、軽やかが楽しめます。", "timestamp": {"$date": "2020-12-31T00:00:00Z"}, "beans": "キリマンジャロＡＡ", "id_beans": 8},
{"user": {"id": 6, "name": "レビュアー6", "genderAge": "F2"}, "star": 4, "keywords": ["スパイシー", "個性派"], "review": "個性派を感じさせる香りと、スパイシーな味わいが魅力です。", "timestamp": {"$date": "2022-09-07T00:00:00Z"}, "beans": "キリマンジャロＡＡ", "id_beans": 8},
{"user": {"id": 10, "name": "レビュアー10", "genderAge": "M1"}, "star": 4, "keywords": ["酸味", "爽やか"], "review": "このコーヒーは酸味が特徴で、爽やかが楽しめます。", "timestamp": {"$date": "2020-01-16T00:00:00Z"}, "beans": "ジャバロブスタ", "id_beans": 7},
{"user": {"id": 2, "name": "レビュアー2", "genderAge": "F1"}, "star": 5, "keywords": ["香り高い", "濃厚"], "review": "これはまさに極上の一杯です。香り、味わい、余韻のすべてが完璧でした。", "timestamp": {"$date": "2020-12-06T00:00:00Z"}, "beans": "ハワイコナファンシー", "id_beans": 1},
{"user": {"id": 6, "name": "レビュアー6", "genderAge": "F2"}, "star": 1, "keywords": ["苦味", "余韻"], "review": "風味が全く感じられず、非常にがっかりしました。", "timestamp": {"$date": "2020-02-18T00:00:00Z"}, "beans": "ジャバロブスタ", "id_beans": 7},
{"user": {"id": 9, "name": "レビュアー9", "genderAge": "M3"}, "star": 5, "keywords": ["酸味", "爽やか"], "review": "これ以上のコーヒーはないと言っても過言ではありません。まさに芸術品です。", "timestamp": {"$date": "2020-04-23T00:00:00Z"}, "beans": "ブルーマウンテンピーベリー", "id_beans": 11},
{"user": {"id": 3, "name": "レビュアー3", "genderAge": "M1"}, "star": 5, "keywords": ["香り高い", "濃厚"], "review": "濃厚でありながら繊細な味わい。まるで特別な瞬間のために用意されたような豆です。", "timestamp": {"$date": "2021-09-09T00:00:00Z"}, "beans": "エメラルドマウンテン", "id_beans": 4},
{"user": {"id": 7, "name": "レビュアー7", "genderAge": "M1"}, "star": 5, "keywords": ["バランス", "甘み"], "review": "一口飲んだ瞬間に感動しました。香り高く、豊かな味わいが長く続きます。", "timestamp": {"$date": "2020-07-16T00:00:00Z"}, "beans": "コロンビアスプレモ", "id_beans": 12},
{"user": {"id": 2, "name": "レビュアー2", "genderAge": "F1"}, "star": 3, "keywords": ["香り高い", "濃厚"], "review": "香り高いと濃厚が絶妙に調和した逸品です。", "timestamp": {"$date": "2020-03-11T00:00:00Z"}, "beans": "コロンビアスプレモ", "id_beans": 12},
{"user": {"id": 10, "name": "レビュアー10", "genderAge": "M1"}, "star": 2, "keywords": ["高級", "アロマ"], "review": "アロマを感じさせる香りと、高級な味わいが魅力です。 しかし、後味に雑味が残る印象があります。", "timestamp": {"$date": "2024-03-12T00:00:00Z"}, "beans": "モカマタリ", "id_beans": 3},
{"user": {"id": 9, "name": "レビュアー9", "genderAge": "M3"}, "star": 2, "keywords": ["酸味", "爽やか"], "review": "酸味と爽やかが絶妙に調和した逸品です。 しかし、後味に雑味が残る印象があります。", "timestamp": {"$date": "2021-01-15T00:00:00Z"}, "beans": "にがにがブレンド", "id_beans": 9},
{"user": {"id": 8, "name": "レビュアー8", "genderAge": "M1"}, "star": 5, "keywords": ["マイルド", "軽やか"], "review": "過去最高のコーヒー体験でした。洗練された風味が感動を与えてくれます。", "timestamp": {"$date": "2021-05-05T00:00:00Z"}, "beans": "ブルーマウンテンピーベリー", "id_beans": 11},
{"user": {"id": 5, "name": "レビュアー5", "genderAge": "M3"}, "star": 4, "keywords": ["苦味", "余韻"], "review": "このコーヒーは苦味が特徴で、余韻が楽しめます。", "timestamp": {"$date": "2023-11-02T00:00:00Z"}, "beans": "ブルーマウンテンピーベリー", "id_beans": 11},
])
```
