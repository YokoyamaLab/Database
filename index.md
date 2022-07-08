# 講義「データベース」サポートページ

## 講義例題データベース作成

大学のPCで演習を行う場合は毎回これでテーブルを作成してください。

### vineyardテーブル作成
```SQL
CREATE TABLE vineyard(
    dID VARCHAR(4) PRIMARY KEY, 
    district VARCHAR(30)
);
```

### vineyardデータ流し込み

```SQL
INSERT INTO vineyard(dID,district)
VALUES
    ('A','ブルゴーニュ'),
    ('B','ボルドー'),
    ('C','ロワール'),
    ('D','シャンバーニュ'),
    ('E','チリ');
```

### wineテーブル作成
```SQL
CREATE TABLE wine(
    wID INTEGER PRIMARY KEY, 
    name VARCHAR(30), 
    dID VARCHAR(4) REFERENCES vineyard(dID), 
    price INTEGER
);
```

### wineテーブルデータ流し込み
```SQL
INSERT INTO wine(wID,name,dID,price)
VALUES
    (1,'シャブリ','A',2400), 
    (2,'ジュヴレシャンベルタン','A',3000), 
    (3,'サンテミリオン','B',5800), 
    (4,'オーメドック','B',2200), 
    (5,'サンセール','C',2800), 
    (6,'シャンパン','D',4000);
```

## 講義サポートページ

* [Day06サポートページ](day6.md)
* [Day08サポートページ](day8.md)
* [Day11サポートページ](day11.md)
* [Day12サポートページ](day12.md)
* [Day13サポートページ](day13.md)
