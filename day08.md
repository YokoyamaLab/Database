# データベース Day 08

## 選択演算：全Doc全フィールドを返す

* beansコレクションの全表示

```Cypher
db.beans.find()
```

## ドキュメント更新　[例1]

* ブルマンの価格を2200円に！

```javascript
db.beans.updateOne(
	{beans: "ブルーマウンテンNo.1"},
	{$set: { price: 2200 }})
```

## ドキュメント更新　[例2]

* Aromaが3未満のものにlow_aroma: trueを付与

```javascript
db.beans.updateOne(
	{aroma: {$lt: 3}, {$set: { low_aroma : true }})
```

## ドキュメント削除 [例]

* 産地が無い豆の削除

```javascript
db.beans.deleteMany({id_origin: null})
```

## 注意！！

* DBに変更が加わっていますので、この後の検索のために、もう一度初期化しましょう。
* [再初期化](init.md)

## 射影演算

* Beansのコーヒー豆種(beans)と価格(price)のみ表示

```javascript
db.beans.find({}, {beans:1, price:1})
```

* _idを表示したくなければ

```javascript
db.beans.find({}, {_id:0, beans:1, price:1})
```

## リネーム演算　[例1]

* Beans, price, id_originを日本語のフィールド名に変更

```javascript
db.beans.aggregate([
   {$project:{
      _id:0, 豆名: "$beans", 価格: "$price", id_origin: 1,
   }}
])
```

## 選択演算　[例1]

* 1000円以上のコーヒー豆

```javascript
db.beans.find({price: { $gt: 1000 }})
```

## 選択演算　[例2]

* 1000円以上のコーヒー豆、beansとpriceのみ

```javascript
db.beans.find({price: { $gt: 1000 }}, {beans:1, price:1})
```

## 整列演算　[例]

* 価格の降順

```javascript
db.beans.find({},{beans:1,price:1}).sort({price:-1})
```

## 選択演算＆整列演算の複合クエリ [例]

* aromaが4以上かつ値段が1000以下
* beansとpriceのみ表示
* 値段昇順

```javascript
db.beans.find({
   $and:[
      {aroma:{ $gt: 4 }},
      {aroma:{ $lte : 1000 }}
   ]},{beans:1,price:1,aroma:1}).sort({price:-1})
```

## (全Doc)集約演算　[例]

* 全豆の平均価格

```javascript
db.beans.aggregate([
   {$group: {
      _id: null,
      avgPrice: { $avg: "$price" }
    }}
])
```

## (グループ毎)集約演算　[例1]

* 産地毎の平均価格

```javascript
db.beans.aggregate([
   {$group: {
      _id: "$id_origin", 
      avgPrice: { $avg: "$price" }
    }}
])
```

## (グループ毎)集約演算　[例2]

* HAVINGとWHEREはSQLより直感的
* 1000円以下の豆にのみの産地別平均価格で555円以下の産地

```javascript
db.beans.aggregate([
   {$match: { price: { $lte: 1000 }}},
   {$group: {
      _id: "$id_origin", 
      avgPrice: { $avg: "$price" }
    }},
    {$match: { avgPrice: { $lte: 555 }}} 
])
```

# 結合演算　[例]

* 産地をIDではなくoriginテーブルと結合して産地名を表示

```javascript
db.beans.aggregate([
  {
    $lookup: {
      from: "origin", 
      localField: "id_origin", 
      foreignField: "id_origin",  
      as: "origin_info"
    }
  },
  {
    $unwind: {
      path: "$origin_info",
      preserveNullAndEmptyArrays: true  
    }
  },
  {
    $project: {
      _id: 0,
      beans: 1,
      origin: "$origin_info.origin",
      price: 1
    }
  }
])
```



