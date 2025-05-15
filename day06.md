# データベースday6
[戻る](index.md)

## 選択演算：全行全列を返す [例1]

```SQL
SELECT * FROM roast ;
```

## 選択演算：全行全列を返す [例2]

```SQL
SELECT * FROM roAst ;
```

## 射影演算 [例]

```SQL
SELECT beans, price FROM beans;
```

## リネーム演算 [例]

```SQL
SELECT beans AS お豆, price FROM beans;
```

## 選択演算 [例1]

```SQL
SELECT beans, price FROM beans
  WHERE price < 1000 AND price >= 600;
```

## 選択演算 [例2]

```SQL
SELECT beans, acidity, bitterness FROM beans
  WHERE acidity = 5 OR bitterness = 5;
```

## 整列演算 [例1]

```SQL
SELECT beans, price FROM beans 
  ORDER BY price DESC;
```

## 整列演算 [例2]

```SQL
SELECT beans, id_origin FROM beans 
  ORDER BY id_origin;
```

## 整列演算 [例3]

```SQL
SELECT beans, price FROM beans 
  ORDER BY beans;
```

## 日付とロケール

*PostgreSQLのみ
```SQL
SELECT 
   to_char(NOW(),'TMMonth'),to_char(NOW(), 'Month');  
```

## 選択演算＆整列演算の複合クエリ [例]

```SQL
SELECT beans, price, sweetness FROM beans
  WHERE sweetness >= 4
  ORDER BY price;
```

## (全行)集約演算 [例1]

```SQL
SELECT avg(price)  FROM beans;
```

```SQL
SELECT round(avg(price))  FROM beans;
```

## (グループ毎)集約演算 [例]

```SQL
SELECT aroma, round(avg(price)) AS price
  FROM beans 
  GROUP BY aroma ORDER BY aroma;
```

## (グループ毎)集約演算＆選択演算 [例]

* WHERE句バージョン
```SQL
SELECT aroma, round(avg(price)) AS price
  FROM beans WHERE price < 1500 
  GROUP BY aroma ORDER BY aroma;
```

# HAVING句バージョン
```SQL
SELECT aroma, round(avg(price)) AS price
  FROM beans 
  GROUP BY aroma HAVING price < 1500 
  ORDER BY aroma;
```