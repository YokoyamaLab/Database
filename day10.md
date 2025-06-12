# Day10 インデクス

## CSV読み込み

### PostgreSQL

#### [Step1] テーブル定義

```sql
CREATE TABLE zipcode(
  zip int,
  addr1 varchar(20),
  addr2 varchar(20),
  addr3 varchar(100)
);
CREATE TABLE zipcode_noindex(
  zip int,
  addr1 varchar(20),
  addr2 varchar(20),
  addr3 varchar(100)
);
```

#### [Step2] データ流し込み

* クライアントエンコーディングの確認

```SQL
show client_encoding;
```ｄｄｄｄｄｄｄｄｄｄｄｄｄｄｄｄｄｄｄcc

 * SJISと出るか、UTF8と出るか確認し、以下のファイルをダウンロード。
 * わかりやすいディレクトリを作成してそこに保存する事。例えば**c:\zipcode\**として説明する。
   * 日本誤の含まれたバスにあるとうまく動作しない可能性がある

* SJISの場合
  * https://github.com/YokoyamaLab/Database/raw/main/zipcode_SJIS.csv
* UTF8の場合
  *  https://github.com/YokoyamaLab/Database/raw/main/zipcode_UTF8.csv


```sql
\copy zipcode from 'c:\zipcode\zipcode_UTF8.csv' with csv;
```

```sql
\copy zipcode_noindex from 'c:\zipcode\zipcode_UTF8.csv' with csv;
```

#### [Step3] インデクスの付与(zipcodeテーブルのみ)

### zipにbtreeインデクス

```sql
CREATE INDEX idx_zipcode_zip
   ON zipcode
   USING btree (zip);
```

### addr3にhashインデクス
```sql
CREATE INDEX idx_zipcode_addr3
   ON zipcode
   USING hash (addr3);
```
