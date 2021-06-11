# データベース[Day10]サポートページ

## 郵便番号テーブルを二つ作ろう
* 実際はPrimary Keyが必要になりますが、zipを共有する異なる住所があるのでzipはPrimary keyになりません。今回はあくまでインデクスの検証ですので、Primary kye無しでOKです。
```sql
CREATE TABLE zipcode(
  zip int,
  addr1 varchar(20),
  addr2 varchar(20),
  addr3 varchar(100)
);
CREATE TABLE zipcode2(
  zip int,
  addr1 varchar(20),
  addr2 varchar(20),
  addr3 varchar(100)
);
```
##　インデクス作成

### zipにbtreeインデクス
```sql
CREATE INDEX idx_zipcode2_zip
   ON zipcode2　
   USING btree (zip);
```

### addr3にhashインデクス
```sq;
CREATE INDEX idx_zipcode2_addr3
   ON zipcode2　
   USING hash (addr3);
```
