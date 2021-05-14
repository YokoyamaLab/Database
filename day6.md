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

## 
