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
\copy zipcode from 'c:\zipcode\zipcode_UTF8.csv' with csv header;
\copy zipcode_noindex from 'c:\zipcode\zipcode_UTF8.csv' with csv header;
```

* WSL環境の場合はcドライブは/mnt/c/にマウントされている

```sql
\copy zipcode from '/mnt/c/zipcode/zipcode_UTF8.csv' with csv header;
\copy zipcode_noindex from '/mnt/c/zipcode/zipcode_UTF8.csv' with csv header;
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

### MongoDB

#### [Step1] テーブル定義

* MongoDBはスキーマレスのためテーブルの定義は必要ありません

#### [Step2] データ流し込み

* UTF8を使います。
* 手順
  1. MondoDB Compassでfri5databaseにconnect
  2. **Create collection**をクリックし**zipcode**を作成
  3. **Import data**をクリックして**zipcode_UTF8.csv**を選択
  4. 以下のような読み込み画面が出てくるので**Import**をクリック

![image](https://github.com/user-attachments/assets/bc4c59b7-998d-48cc-98ea-71e002c48607)

#### [Step3] インデクスの付与(zipcodeコレクションのみ)

* MongoDB Compassで**Indexesタブ**で**Create Index**をクリック

![image](https://github.com/user-attachments/assets/90df709a-1550-4d40-952d-c9dcce6f0aae)

* **zip**に対して**1(asc)**を作成し**Create Index**をクリック
* もう一つ**addr3**に対して**text**を作成し**Create Index**をクリック（MobgoDBにはHashが無いので代わりにTextインデクスを利用）


## インデクスの効果測定

### PostgreSQL / MySQL / MongoDB

#### 効果測定1 btree & 等価検索

* インデクスなし

```sql
EXPLAIN SELECT * FROM zipcode_noindex 
WHERE zip = 1910065;
```

```javascript
db.zipcode_noindex.find({zip:1910065}).explain()
```

* インデクスあり

```sql
EXPLAIN SELECT * FROM zipcode 
WHERE zip = 1910065;
```

```javascript
db.zipcode.find({zip:1910065}).explain()
```

#### 効果測定2 btree&範囲検索

* インデクスなし

```sql
EXPLAIN SELECT * FROM zipcode_noindex 
WHERE zip < 1910065 AND zip > 1910000;
```

```javascript
db.zipcode_noindex.find({$and:[
	{zip: { $lt: 1910065 }},
	{zip: { $gt: 1910000 }}]}).explain()
```

* インデクスあり

```sql
EXPLAIN SELECT * FROM zipcode 
WHERE zip < 1910065 AND zip > 1910000;
```

```javascript
db.zipcode.find({$and:[
	{zip: { $lt: 1910065 }},
	{zip: { $gt: 1910000 }}]}).explain()
```

#### 効果測定3 hash &完全一致検索

* インデクスなし

```sql
EXPLAIN SELECT * FROM zipcode_noindex 
WHERE addr3 ='旭が丘';
```

```javascript
db.zipcode_noindex.find({addr3:'旭が丘'}).explain()
```

* インデクスあり

```sql
EXPLAIN SELECT * FROM zipcode
WHERE addr3 ='旭が丘';
```

```javascript
db.zipcode.find({addr3:'旭が丘'}).explain()
```

#### 効果測定4 hash &部分一致検索

* インデクスなし

```sql
EXPLAIN SELECT * FROM zipcode_noindex 
WHERE addr3 LIKE '%が%';
```

```javascript
db.zipcode_noindex.find({addr3 :{$regex:'が'}}).explain()
```
* インデクスあり

```sql
EXPLAIN SELECT * FROM zipcode 
WHERE addr3 LIKE '%が%';
```

```javascript
db.zipcodefind({addr3 :{$regex:'が'}}).explain()
```


#### 効果測定5 整数値のソート

* インデクスなし

```sql
EXPLAIN SELECT * FROM zipcode_noindex 
ORDER BY zip DESC;
```

```javascript
db.zipcode_noindex.find().sort({zip:-1}).explain()
```

* インデクスあり

```sql
EXPLAIN SELECT * FROM zipcode 
ORDER BY zip DESC;
```

```javascript
db.zipcode.find().sort({zip:-1}).explain()
```
