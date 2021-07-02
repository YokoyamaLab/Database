# データベース[Day12]サポートページ

## ROLLBACKの動作

```sql
--端末A:トランザクションの開始
START TRANSACTION;

--端末A:wineテーブル全行削除
DELETE FROM wine;

--端末A:消えたのを確認
SELECT * FROM wine;

--端末A:トランザクションをアボート
ROLLBACK;

--端末A:トランザクション中の処理が「なかった事」になっているのを確認
SELECT * FROM wine;
```

## コミットの動作

```sql
--端末A:トランザクションの開始
START TRANSACTION;

--端末A：wineテーブル一行追加
INSERT INTO wine VALUES(8,’ミュスカデ’,’C’,2100);

--端末A：1行加わっているか確認する
SELECT * FROM wine;

--端末B：別の端末でwineテーブルを見てみる
SELECT * FROM wine;

--端末A：トランザクションをコミット
COMMIT;

--端末A：1行加わっているか確認する
SELECT * FROM wine;

--端末B：別の端末でwineテーブルを見てみる
SELECT * FROM wine;

```

## テーブルのロック

```sql
--端末A：ワインテーブルをロック
START TRANSACTION;
LOCK wine IN ACCESS EXCLUSIVE MODE;

--端末B：別端末でSELECT
SELECT * FROM wine;

--端末A：A端末でも確認
SELECT * FROM wine;

--端末A：トランザクションをコミット(端末Bも見えるようにして実行すると良い)
COMMIT;
```

## 行のロック

```sql
--端末A：ワインテーブルのとある行(wid=1)をロックし確認
START TRANSACTION;
SELECT * FROM wine WHERE wid = 1 FOR UPDATE;

--端末B：ワインテーブルのとある行(wid=2, 1)をロックし確認
START TRANSACTION;
SELECT * FROM wine WHERE wid = 2 FOR UPDATE; 
SELECT * FROM wine WHERE wid = 1 FOR UPDATE;

--端末A：wid=1の価格を更新しコミット
UPDATE wine SET price = 100000 WHERE wid = 1;
COMMIT;

--コミットした時点で止まっていた端末Bが動きだす
--端末Bに表示された価格は更新前？更新後？
```

## デッドロック

```sql
--wineとvineyardを使ってデッドロックを起こす

--端末A
START TRANSACTION;
LOCK wine IN ACCESS EXCLUSIVE MODE;

--端末B
START TRANSACTION;
LOCK vineyard IN ACCESS EXCLUSIVE MODE;

--端末A
LOCK vineyard IN ACCESS EXCLUSIVE MODE;

--端末B
LOCK wine IN ACCESS EXCLUSIVE MODE;
```






```
