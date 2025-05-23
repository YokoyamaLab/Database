![image](https://github.com/user-attachments/assets/d0083684-6bfb-46e7-8706-22878c515bb1)![image](https://github.com/user-attachments/assets/4d35fd4a-db4a-4e51-afd2-585f3b8a3263)# データベース Day 07

## 前回宿題

```sql
SELECT aroma, round(avg(price)) AS price
  FROM beans WHERE price < 1500 
  GROUP BY aroma ORDER BY aroma;
```

```sql
SELECT aroma, round(avg(price)) AS price
  FROM beans 
  GROUP BY aroma HAVING round(avg(price)) < 1500 
  ORDER BY aroma;
```

## 結合演算 - 豆の産地を表示したい

```sql
SELECT beans, origin.id_origin, origin 
   FROM beans JOIN origin 
   ON beans.id_origin = origin.id_origin;
```

## 結合の種類

* 内部結合（さっきの）

```sql
SELECT beans, origin.id_origin, origin FROM beans JOIN origin ON beans.id_origin = origin.id_origin;
```

* 右外部結合
```sql
SELECT beans, origin.id_origin, origin FROM beans RIGHT JOIN origin ON beans.id_origin = origin.id_origin;
```

* 左外部結合
```sql
SELECT beans, origin.id_origin, origin FROM beans LEFT JOIN origin ON beans.id_origin = origin.id_origin;
```

* 完全外部結合（MySQLではサポートされていません）
```sql
SELECT beans, origin.id_origin, origin FROM beans FULL JOIN origin ON beans.id_origin = origin.id_origin;
```

## 外部結合 - 例２　(MySQLではサポートされていません)

```sql
SELECT beans, origin.id_origin, origin 
  FROM beans FULL JOIN origin 
  ON beans.id_origin = origin.id_origin
  WHERE beans IS NULL OR origin IS NULL ;
```

## 自己結合

```sql
SELECT beans.beans, beans.id_origin
   FROM beans JOIN beans 
   ON beans.beans = beans.beans;
```

 * 上記はエラーが出ます。
 * 同じテーブルを二回指定しているのがダメ
 * リネームで名前をかえてやる必要がある

あまり意味のないクエリ
```sql
SELECT a.beans, b.price
   FROM beans AS a JOIN beans AS b 
   ON a.beans = b.beans;
```

自己結合の適している例：ある豆よりsweetnessが強い豆のリストを作る

```sql
SELECT a.beans, b.beans AS sweeter_beans 
   FROM beans AS a LEFT JOIN beans AS b 
   ON a.sweetness < b.sweetness;
```

## 単純な副問い合わせ
```sql
SELECT beans  AS sweetest_beans FROM (
   SELECT a.beans, b.beans AS sweeter_beans 
      FROM beans AS a LEFT JOIN beans AS b 
      ON a.sweetness < b.sweetness
) AS t  WHERE sweeter_beans IS NULL;
```

## スカラー副問い合わせ

スカラー値による問い合わせ(Sweetnessが5の豆)
```sql
SELECT beans FROM beans
   WHERE sweetness = 5;
```

スカラー副問い合わせ(sweetnessがテーブル中の最大値である豆)
```sql

SELECT beans FROM beans
   WHERE sweetness 
      = (SELECT max(sweetness) FROM beans);
```

## 相関副問い合わせ

* 産地毎の  一番安い豆
```sql
SELECT beans, price, id_origin FROM beans AS x
   WHERE price = (
      SELECT min(price) 
         FROM beans AS y 
	 GROUP BY id_origin
	 HAVING x. id_origin = y. id_origin);
```

## IN句、NOT IN句

```sql
SELECT *  FROM origin
   WHERE id_origin NOT IN 
      (SELECT DISTINCT id_origin FROM beans
          WHERE id_origin IS NOT NULL);
```

## EXISTS句、NOT EXISTS句

```sql
SELECT *
   FROM origin
   WHERE NOT EXISTS (
      SELECT NULL
         FROM beans
         WHERE origin.id_origin = beans.id_origin);
```

##和演算

* memberとbaristaを和演算(列の名前をリネーム演算で揃えてやる)

```sql
SELECT name, address AS affiliation FROM member
UNION 
SELECT name, affiliation FROM barista;
```


* UNIONとUNION ALLの違い

```sql
SELECT name, affiliation FROM barista
UNION ALL 
SELECT name, affiliation FROM barista;
```

```sql
SELECT name, affiliation FROM barista
UNION 
SELECT name, affiliation FROM barista;
```
