# データベース　Day8

## Viewの作成

* wineとvinyardを結合したビューwine_listの作成

```SQL
CREATE VIEW wine_list AS
   SELECT wid, name, district, price
      FROM wine JOIN vineyard 
      ON wine.did = vineyard.did;
```

* 作成したビューはテーブルと同じようにデータを取り出せます

```SQL
SELECT * FROM wine_list;
```

## Viewに試しに挿入してみる。

```SQL
INSERT INTO wine_list 
VALUES(   
	1000
	'コンチャ・イ・トロ',  
	'チリ',  
	980);
```

## Viewを挿入可能にする

* ワインテーブルへ挿入する関数

```SQL
CREATE OR REPLACE FUNCTION function_insert_wine_list() RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO wine 
		VALUES(
    		NEW.wid,
    		NEW.name,
     		(SELECT did FROM vineyard WHERE district = NEW.district),
       		NEW.price);
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;
```

* wine_listビューへのINSERT操作時に発火するトリガ

```SQL
CREATE TRIGGER trigger_insert_wine_list
   INSTEAD OF INSERT
   ON wine_list 
   FOR EACH ROW
   EXECUTE PROCEDURE function_insert_wine_list();
 ```
 
 ## Viweに挿入する
 
 * テーブルへの挿入と同じようにINSERT文を使います
 
```SQL
INSERT INTO wine_list 
VALUES(
   (SELECT MAX(wid)+1 FROM wine),
   'コンチャ・イ・トロ',
   'チリ',
   980
);
```

* 挿入されたか確認してみましょう。

```SQL
SELECT * FROM wine_list;
```

* Wineテーブルはどうですか？

```SQL
SELECT * FROM wine;
```
