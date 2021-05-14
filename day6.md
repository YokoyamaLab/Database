# データベースday6
[戻る](README.md)

## 全行全列を返す

```SQL
SELECT * FROM wine;
```

### その2

```SQL
SELECT * FROM wiNe;
```

## 射影演算

```SQL
SELECT wid, name FROM wine;
```

## リネーム演算

```SQL
SELECT wid, name AS 名前 FROM wine;
```

## 選択演算

```SQL
SELECT * FROM wine
 WHERE price < 3000 AND price >= 2200;
```

## 整列演算（数値）
```SQL
--　昇順
SELECT * FROM wine ORDER BY price;

--　降順
SELECT * FROM wine ORDER BY price DESC;
```

## 整列演算（アルファベット）
```SQL
--　昇順
SELECT name,did FROM wine ORDER BY did;

--　降順
SELECT name,did FROM wine ORDER BY did DESC;
```

## 整列演算（カタカナ）
```SQL
--　昇順
SELECT wid,name FROM wine ORDER BY name;

--　降順
SELECT wid,name FROM wine ORDER BY name DESC;
```

## 試行問題（漢字かなカナ交じり）

### テーブルの作成とデータの流し込み

```SQL
CREATE TABLE kanji_kana(
    id SMALLINT PRIMARY KEY,
    text VARCHAR(10)
);

-- idの数値を自分がソートの結果出てくるであろう順番に付け替えてみると面白いかもしれません。
INSERT INTO kanji_kana(id,text)
VALUES
    (1, 'アメリカ'),
    (2, 'あめりか'),
    (3, '亜米利加'),
    (4, 'ふらんす'),
    (5, 'フランス'),
    (6, '仏蘭西'),
    (7, '伊太利'),
    (8, 'イタリア'),
    (9, 'いたりあ'),
    (10, '独逸'),
    (11, 'ドイツ'),
    (12, 'どいつ');
```

### 整列
```SQL
SELECT * FROM kanji_kana ORDER BY text;

-- ロケール無効版
SELECT * FROM kanji_kana ORDER BY text USNING ~<~;

--　日本語ロケール強制版
SELECT * from kanji_kana ORDER BY text COLLATE "ja-x-icu";
```

## 整列演算（選択演算との組み合わせ）

```SQL
SELECT * FROM wine
    WHERE price < 3000 AND price >= 2200
    ORDER BY price DESC;
```

## 集約演算(全行)  ～ 例１

```SQL
-- 全ワインの平均価格
SELECT avg(price) FROM wine;

-- 全ワインの平均価格(四捨五入)
SELECT round(avg(price))  FROM wine;
```

## 集約演算(全行) ～ 例２
```SQL
SELECT string_agg(name, ’,’)  FROM wine;
```

## 集約演算 ～ 産地別平均価格

```SQL
SELECT did, round(avg(price)) FROM wine 
   GROUP BY did;
```

## 集約＆整列演算 ～ 産地別平均価格(降順)
```SQL
SELECT did, round(avg(price)) FROM wine 
   GROUP BY did
   ORDER BY price DESC;
```
* その２
```SQL
SELECT did, round(avg(price)) FROM wine 
   GROUP BY did
   ORDER BY round DESC;
```

## 集約&整列&リネーム演算
```SQL
SELECT did, round(avg(price)) AS price 
   FROM wine 
   GROUP BY did ORDER BY price DESC;
```

## 集約&整列&リネーム演算 ～ 例2

* 安価なワインの産地別平均価格(降順)を得たい

### 安価＝ワインの価格が4000円未満=安価なワイン
 
 ```SQL
SELECT did, round(avg(price)) FROM wine 
    WHERE price < 4000 GROUP BY did 
    ORDER BY round DESC;
```
 
### 安価＝産地平均価格が4000円未満=安価な産地

```SQL
SELECT did, round(avg(price)) FROM wine 
   GROUP BY did HAVING avg(price) < 4000
   ORDER BY round DESC;
```
