![image](https://github.com/user-attachments/assets/915ed975-5c72-4011-923d-94a0b19c149c)![image](https://github.com/user-attachments/assets/29d20ea7-1da1-47bf-b6ee-bfd764ad7ddc)# Day13

## ROLLBACKの動作

```sql
START TRANSACTION;
DELETE FROM cart;
SELECT * FROM cart;
ROLLBACK; -- START TRANSACTIONかここまでの命令が無かったことになる
SELECT * FROM cart;
```

## COMMITの動作

- 端末A

```sql
START TRANSACTION;
INSERT INTO beans VALUES(14,'スラウェシママサ',900, 'ID',3,4,3,5,5);

-- 確認してみようINSERTした行は見えますか？
SELECT * FROM beans;
```

- 端末B

```sql
-- 端末Bでも確認してみようINSERTした行は見えますか？
SELECT * FROM beans;
```

- 端末A

```sql
-- トランザクションをコミットする。
COMMIT;

-- 確認してみよう。(当然INSERTは反映されているはず)
SELECT * FROM beans;
```

- 端末B

```sql
-- さっきINSERT内容が見えなかった端末Bでも確認してみよう。
SELECT * FROM beans;
```

## テーブルのロック 

- 端末A 
```sql
-- PostgreSQLの場合
START TRANSACTION;
LOCK beans IN ACCESS EXCLUSIVE MODE;
```

```sql
-- MySQLの場合
START TRANSACTION;
LOCK TABLES beans WRITE;
```

- 端末B

```sql
SELECT * FROM beans;
```

- 端末A

```sql
SELECT * FROM beans;
```

- ロックが効いている？

- 端末A

```sql
COMMIT;
```

## 行のロック

- 端末A

```sql
START TRANSACTION;
SELECT * FROM beans WHERE id_beans = 1 FOR UPDATE;
```

- 端末B

```sql
START TRANSACTION;
SELECT * FROM beans WHERE id_beans = 2 FOR UPDATE; 
SELECT * FROM beans WHERE id_beans = 1 FOR UPDATE;
```

- 端末A

```sql
UPDATE beans SET price = 100000 WHERE id_beans = 1;
COMMIT;
```

## デッドロック (PostgreSQLのみ)

- 端末A (beansテーブルの占有ロックを取得)

``` sql
START TRANSACTION;
LOCK beans IN ACCESS EXCLUSIVE MODE;
```

- 端末B　(originテーブルの占有ロックを取得)

```sql
START TRANSACTION;
LOCK origin IN ACCESS EXCLUSIVE MODE;
```

- 端末A　(originテーブルの占有ロックを取得)→ただし端末Bがロック中なので待たされる

```sql
LOCK origin IN ACCESS EXCLUSIVE MODE;
```

- 端末B (beansテーブルの占有ロックを取得)→ただし端末Aがロック中なので待たされ・・・たら、永遠にデッドロック状態

```sql
LOCK beans IN ACCESS EXCLUSIVE MODE;
```




