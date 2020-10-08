DROP DATABASE IF EXISTS movielens CASCADE;
CREATE DATABASE movielens;
USE movielens;
CREATE EXTERNAL TABLE movies (MovieID INT, 
Title varchar(60), 
Genres varchar(60))
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
LINES TERMINATED BY "\n"
STORED AS TEXTFILE
LOCATION '/movielens/ml-1m/mvs.txt';
LOAD DATA INPATH '/movielens/ml-1m/movies.csv' INTO TABLE movies;
SELECT * FROM movies LIMIT 10;