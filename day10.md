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
```

 * SJISと出るか、UTF8と出るか確認し、以下のファイルをダウンロード。
 * わかりやすいディレクトリを作成してそこに保存する事。例えば**c:\zipcode\**として説明する。
   * 日本誤の含まれたバスにあるとうまく動作しない可能性がある

* SJISの場合
  * https://github.com/YokoyamaLab/Database/raw/main/zipcode_SJIS.csv
* UTF8の場合
  *  https://github.com/YokoyamaLab/Database/raw/main/zipcode_UTF8.csv

```sql
\copy zipcode from 'c:\zipcode\zipcode_UTF8.csv' with csv;
\copy zipcode_noindex from 'c:\zipcode\zipcode_UTF8.csv' with csv;
```

* WSL環境の場合はcドライブは/mnt/c/にマウントされている

```sql
\copy zipcode from '/mnt/c/zipcode/zipcode_UTF8.csv' with csv;
\copy zipcode_noindex from '/mnt/c/zipcode/zipcode_UTF8.csv' with csv;
```
* 

#### [Step3] インデクスの付与(zipcodeテーブルのみ)

* zipにbtreeインデクス

```sql
CREATE INDEX idx_zipcode_zip
   ON zipcode
   USING btree (zip);
```

* addr3にhashインデクス

```sql
CREATE INDEX idx_zipcode_addr3
   ON zipcode
   USING hash (addr3);
```


### MySQL

* PostgreSQLと殆ど同じですが、一部のコマンドが異なっているので注意。

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

* MySQLからファイルアクセスが可能なディレクトリの確認
```SQL
SHOW VARIABLES LIKE "secure_file_priv";
```
```
+------------------+------------------------------------------------+
| Variable_name    | Value                                          |
+------------------+------------------------------------------------+
| secure_file_priv | C:\ProgramData\MySQL\MySQL Server 9.2\Uploads\ |
+------------------+------------------------------------------------+
```

* このディレクトリに**zipcode_SJIS.csv**と**zipcode_UTF8.csv**を格納

* SJISの場合
  * https://github.com/YokoyamaLab/Database/raw/main/zipcode_SJIS.csv
* UTF8の場合
  *  https://github.com/YokoyamaLab/Database/raw/main/zipcode_UTF8.csv

* UTF8のデータを読み込み、エラーがでるようならSJISを使う
  * パス中のバックスラッシュがスラッシュになっている事を確認。
   
```sql
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.2/Uploads/zipcode_UTF8.csv' INTO TABLE zipcode
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.2/Uploads/zipcode_UTF8.csv' INTO TABLE zipcode_noindex
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
```

#### [Step3] インデクスの付与(zipcodeテーブルのみ)

* zipにbtreeインデクス

```sql
CREATE INDEX idx_zipcode_zip
   ON zipcode (zip)
   USING BTREE ;
```

* addr3にhashインデクス

```sql
CREATE INDEX idx_zipcode_addr3
   ON zipcode (addr3)
   USING HASH;
```

