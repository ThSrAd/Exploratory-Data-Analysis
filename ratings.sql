USE movielens;

CREATE EXTERNAL TABLE ratings (UserID INT, 
MovieID INT, 
Rating INT, 
Timestamp2 STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
LINES TERMINATED BY "\n"
STORED AS TEXTFILE
LOCATION '/movielens/ml-1m/rts.txt';
LOAD DATA INPATH '/movielens/ml-1m/ratings.csv' INTO TABLE ratings;

SELECT * FROM ratings LIMIT 10;