# データベース[Day7]サポートページ


## ワインの産地を表示したい

```SQL
SELECT * 
   FROM wine JOIN vineyard 
   ON wine.did = vineyard.did;
```

## 射影演算にてカラムを整理する

```SQL
SELECT wid, name, district, price
   FROM wine JOIN vineyard 
   ON wine.did = vineyard.did;
```

## didも出してみよう
```SQL
SELECT wid, name, did, district, price
   FROM wine JOIN vineyard 
   ON wine.did = vineyard.did;
```

## 自然結合
```SQL
SELECT * FROM wine NATURAL JOIN vineyard;
```

## 外部結合 - 例２
* 持っていないもののみを出そう！

```SQL
SELECT wid, name, district, price
  FROM wine RIGHT JOIN vineyard 
  ON wine.did = vineyard.did
  WHERE wid IS NULL;
```


## アンチ結合

```SQL
SELECT *
   FROM vineyard
   WHERE NOT EXISTS (
      SELECT NULL
         FROM wine
         WHERE vineyard.did = wine.did);
```

## スカラー服問い合わせ

* 価格の一番安いワイン

```SQL
SELECT * FROM wine 
   WHERE price= (
      SELECT min(price) FROM wine);
```

## 相関副問い合わせ

```SQL
SELECT * FROM wine AS x
   WHERE price = (
      SELECT min(price) 
         FROM wine AS y 
	 GROUP BY did
	 HAVING x.did = y.did);
```

## IN句、NOT IN句

* wineテーブルで使われていないvineyard

```SQL
SELECT *  FROM vineyard
   WHERE did  NOT IN 
      (SELECT DISTINCT did FROM wine);
```

* アンチ結合　NOT IN句バージョン

```SQL
SELECT *
   FROM vineyard
   WHERE did NOT IN(
      SELECT DISTINCT did
         FROM wine);
```

## 和演算

* 違いは何？

```SQL
SELECT * FROM wine
UNION SELECT * FROM wine;
```

```SQL
SELECT * FROM wine
UNION ALL SELECT * FROM wine;
```

## 結果の一部表示

```SQL
SELECT * FROM wine
   ORDER BY price desc
   LIMIT 2 OFFSET 3;
```
 
