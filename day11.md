# Day11

## VIEWの作成と確認

```sql
CREATE VIEW v_beans AS
   SELECT id_beans,beans,price,origin,acidity, 
	         bitterness, sweetness, richness, aroma
      FROM beans JOIN origin ON beans.id_origin = origin.id_origin;
```

```sql
SELECT * FROM v_beans ;
```
スキーマを見たい場合は以下
```sql
\d v_beans;
```

```
fri5database=> \d v_beans;
                        View "public.v_beans"
   Column   |         Type          | Collation | Nullable | Default
------------+-----------------------+-----------+----------+---------
 id_beans   | integer               |           |          |
 beans      | character varying(50) |           |          |
 price      | integer               |           |          |
 origin     | character varying(50) |           |          |
 acidity    | smallint              |           |          |
 bitterness | smallint              |           |          |
 sweetness  | smallint              |           |          |
 richness   | smallint              |           |          |
 aroma      | smallint              |           |          |
```

## MATERIALIZED VIEW の作成と確認

```sql
CREATE MATERIALIZED VIEW m_beans AS
   SELECT id_beans,beans,price,origin,acidity, 
	         bitterness, sweetness, richness, aroma
      FROM beans JOIN origin ON beans.id_origin = origin.id_origin;
```

```sql
SELECT * FROM m_beans ;
```

## VIEWへの挿入

まず新しい産地を入れておく
```sql
INSERT INTO origin VALUES('CH', '中国');
```

VIEWへの挿入
```sql
INSERT INTO v_beans
VALUES(   
	(select max(id_beans)+1 from beans),
	'雲南アラビカ',
	700,
	'中国', 
	4,3,3,5,4
);
```
エラーがでます。

## ビューにinsertトリガを作る
(ただし関数を先に定義してから実行)

```sql
CREATE TRIGGER trigger_insert_v_beans
   INSTEAD OF INSERT
   ON v_beans 
   FOR EACH ROW
   EXECUTE PROCEDURE function_insert_v_beans();
```

```sql
CREATE FUNCTION function_insert_v_beans()
   RETURNS TRIGGER
   AS $$ 
      BEGIN
         INSERT INTO beans 
            VALUES(
               NEW.id_beans,
               NEW.beans, NEW.price, 
               --  副問い合わせでid_originをもってくるコードは自分で考える
               NEW.acidity, NEW.bitterness, NEW.sweetness, NEW.richness, NEW.aroma
	);
      RETURN NULL;
      END;
   $$ LANGUAGE plpgsql;
``

## 権限

SQLは簡単なので例示はしません。
