# day12

## Nested Loop Joinを無効に

```sql
set ENABLE_NESTLOOP to off;
```

## Hash Joinを無効に

```sql
set ENABLE_HASHJOIN to off;
```

## MERGE JOINを無効に

```sql
set ENABLE_MERGEJOIN to off;
```

## すべて有効に戻す

```sql
set ENABLE_NESTLOOP to on;
set ENABLE_HASHJOIN to on;
set ENABLE_MERGEJOIN to on;
```
