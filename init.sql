CREATE TABLE vineyard(
    dID VARCHAR(4) PRIMARY KEY,
    district VARCHAR(30)
);

INSERT INTO vineyard(dID,district)
VALUES
    ('A','ブルゴーニュ'),
    ('B','ボルドー'),
    ('C','ロワール'),
    ('D','シャンバーニュ'),
    ('E','チリ');

CREATE TABLE wine(
    wID INTEGER PRIMARY KEY,
    name VARCHAR(30),
    dID VARCHAR(4) REFERENCES vineyard(dID),
    price INTEGER
);

INSERT INTO wine(wID,name,dID,price)
VALUES
    (1,'シャブリ','A',2400),
    (2,'ジュヴレシャンベルタン','A',3000),
    (3,'サンテミリオン','B',5800),
    (4,'オーメドック','B',2200),
    (5,'サンセール','C',2800),
    (6,'シャンパン','D',4000);
