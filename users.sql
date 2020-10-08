USE movielens;

CREATE EXTERNAL TABLE users (UserID INT, 
Gender STRING, 
Age INT,
Occupation INT, 
ZIP INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
LINES TERMINATED BY "\n"
STORED AS TEXTFILE
LOCATION '/movielens/ml-1m/usr.txt';

LOAD DATA INPATH '/movielens/ml-1m/users.csv' INTO TABLE users;

SELECT * FROM users LIMIT 10;
