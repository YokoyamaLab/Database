# データベース[Day12]サポートページ

## 準備

今日はwineテーブル、Vinyardテーブル、wine_listビューの他に、Day11で作ったzipcode、zipcode2テーブルを利用します。大学のPCを使っている人は準備をしてください。

* Wineテーブル、Vinyardテーブル
    * [メインページ参照の事](index.md)

* wine_listビュー
```
CREATE VIEW wine_list AS
   SELECT wid, name, district, price
      FROM wine JOIN vineyard 
      ON wine.did = vineyard.did;
```
* zipcode、zipcode2テーブル
    * [Day11サポートページ](day11.md)

## JOINを試してみよう1～3

```SQL
EXPLAIN
SELECT * FROM wine_list WHERE wid = 1;
```

* ネスティドループ結合を無理矢理無効にする設定

```SQL
set ENABLE_NESTLOOP to off;
```

* ハッシュ結合を無理矢理無効にする設定

```SQL
set ENABLE_HASHJOIN to off;
```

* JOINの設定を戻す

```SQL
set ENABLE_NESTLOOP to on;
set ENABLE_HASHJOIN to on;
```

## JOINを試してみよう4

## 4-1

```SQL
EXPLAIN
SELECT zipcode.zip 
FROM zipcode JOIN zipcode2 
ON zipcode.zip = zipcode.zip;
```

## 4-2

```SQL
EXPLAIN
SELECT zipcode.zip 
FROM zipcode JOIN zipcode2 
ON zipcode.addr3 = zipcode.addr3;
```
## 4-3

```SQL
EXPLAIN
SELECT zipcode.zip 
FROM zipcode JOIN zipcode2 
ON zipcode.addr2 = zipcode.addr2;
```

## 4-4

```SQL
EXPLAIN
SELECT zipcode.zip 
FROM zipcode JOIN zipcode2 
ON zipcode.addr1 = zipcode.addr1;
```


## オプティマイズ － 別の例

```SQL
EXPLAIN
SELECT * 
   FROM (SELECT * FROM zipcode) AS a;
```

## 式変換による最適化

* コストを考えたいSQL

```SQL
SELECT * 
   FROM wine_list
   WHERE price > 3000;
```

* WHER句無しでコストを計測する(つまりwine_listのviewで定義されている結合演算)

```SQL
EXPLAIN
SELECT * 
   FROM wine_list;
```

* 結合無しでwineテーブルに対して>3000を適用するコストを計測する

```SQL
EXPLAIN
SELECT * 
   FROM wine WHERE price > 3000;
```

* 両方合わせたコストを計測する

```SQL
EXPLAIN
SELECT * 
   FROM wine_list
   WHERE price > 3000;
```
