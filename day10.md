# データベース[Day1]サポートページ

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

## インデクス作成

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

## 郵便番号データ流し込み

### まずクライアントエンコーディングの確認

```SQL
show client_encoding;
 ```
 * SJISと出るか、UTF8と出るか確認しておく。

### データのダウンロード
以下のデータを適当なディレクトリにダウンロードしましょう。ただしパス(C:\hogehoge\hogehoge)が分かる場所にね。

* SJISの場合
    * https://github.com/YokoyamaLab/Database/raw/main/zipcode_SJIS.csv
* UTF8の場合
    *  https://github.com/YokoyamaLab/Database/raw/main/zipcode_UTF8.csv

### CSVデータのテーブルへの流し込み

* 仮に**c:\zipcode\zipcode_SJIS.csv**だとします。


```sql
\copy zipcode from 'c:\zipcode\zipcode_SJIS.csv' with csv;
```

```sql
\copy zipcode2 from 'c:\zipcode\zipcode_SJIS.csv' with csv;
```

* ***COPY 124523***と出てきたら成功!
* 試しに見てみよう

```sql
postgres=# SELECT * FROM zipcode;
   zip   |  addr1   |        addr2         |                                    addr3                                   
---------+----------+----------------------+------------------------------------------------------------------------------
  600000 | 北海道   | 札幌市中央区         | 以下に掲載がない場合
  640941 | 北海道   | 札幌市中央区         | 旭ケ丘
  600041 | 北海道   | 札幌市中央区         | 大通東
  600042 | 北海道   | 札幌市中央区         | 大通西（１～１９丁目）
  640820 | 北海道   | 札幌市中央区         | 大通西（２０～２８丁目）
  600031 | 北海道   | 札幌市中央区         | 北一条東
  600001 | 北海道   | 札幌市中央区         | 北一条西（１～１９丁目）
  640821 | 北海道   | 札幌市中央区         | 北一条西（２０～２８丁目）
```

* 試しに日野キャンパスの住所を検索してみよう

```sql
postgres=# select * from zipcode where addr3 = '旭が丘';
   zip   |  addr1   |    addr2     | addr3
---------+----------+--------------+--------
 9862251 | 宮城県   | 牡鹿郡女川町 | 旭が丘
 9902434 | 山形県   | 山形市       | 旭が丘
 3220345 | 栃木県   | 鹿沼市       | 旭が丘
 1910065 | 東京都   | 日野市       | 旭が丘
 2040002 | 東京都   | 清瀬市       | 旭が丘
 2530026 | 神奈川県 | 茅ヶ崎市     | 旭が丘
 4260081 | 静岡県   | 藤枝市       | 旭が丘
 6200947 | 京都府   | 福知山市     | 旭が丘
 6550033 | 兵庫県   | 神戸市垂水区 | 旭が丘
 6730002 | 兵庫県   | 明石市       | 旭が丘
 7140056 | 岡山県   | 笠岡市       | 旭が丘
 8470823 | 佐賀県   | 唐津市       | 旭が丘
(12 行)
```

## インデクスの性能調査

### 効果測定1 btree & 等価検索

* インデクス無し
```SQL
EXPLAIN SELECT * FROM zipcode 
WHERE zip = 1910065;
```

* インデクス有り
```SQL
EXPLAIN SELECT * FROM zipcode2 
WHERE zip = 1910065;
```

### 効果測定2 btree&範囲検索

* インデクス無し
```SQL
EXPLAIN SELECT * FROM zipcode 
WHERE zip < 1910065 AND zip > 1910000;
```

* インデクス有り
```SQL
EXPLAIN SELECT * FROM zipcode2 
WHERE zip < 1910065 AND zip > 1910000;
```

### 効果測定3 hash &完全一致検索

* インデクス無し
```SQL
EXPLAIN SELECT * FROM zipcode 
WHERE addr3 = '旭が丘';
```

* インデクス有り
```SQL
EXPLAIN SELECT * FROM zipcode2
WHERE addr3 = '旭が丘';
```

### 効果測定4 hash &部分一致検索

* インデクス無し
```SQL
EXPLAIN SELECT * FROM zipcode 
WHERE addr3 LIKE '%が%';
```

* インデクス有り
```SQL
EXPLAIN SELECT * FROM zipcode2 
WHERE addr3 LIKE '%が%';
```

### 効果測定5 整数値のソート

* インデクス無し
```SQL
EXPLAIN SELECT * FROM zipcode 
ORDER BY zip DESC;
```

* インデクス有り
```SQL
EXPLAIN SELECT * FROM zipcode2 
ORDER BY zip DESC;
```
