## SQL Analytics with HIVE
> Aim of this project is to explore advanced features in Hive that allows us to run SQL based analytical queries 
over large datasets 

<hr>

## Table of Contents
* About dataset
* Environment
* Extract the Data
* Hive Querying

<hr>

## About dataset
MovieLens data sets were collected by the GroupLens Research Project at the University of Minnesota.</br>
This data set consists of</br>
100,000 ratings (1-5) from 943 users upon 1682 movies</br>
Each user has rated at least 20 movies</br>
Simple demographic info for the users (age, gender, occupation, zip)</br>

Dataset Link: https://grouplens.org/datasets/movielens/1m/
<hr>

## Environment
Cloudera Quickstart VM, Winscp, Putty, 

<hr>

## Extract and Transform the Data
* Import the ml-1m file to clouderavm through winscp

* File is delimited by :: . Change the delimiters to comma formatted, (csv)
```
sed -i 's/::/,/g' ml-1m/movies.dat
sed -i 's/::/,/g' ml-1m/users.dat
sed -i 's/::/,/g' ml-1m/ratings.dat
```
![image](https://user-images.githubusercontent.com/69738890/95400797-2fea3f80-08d1-11eb-94e9-f73a742cfd17.png)

* Rename file format from .dat to .csv

```
mv ml-1m/movies.dat /ml-1m/movies.csv
mv ml-1m/ratings.dat /ml-1m/ratings.csv
mv ml-1m/users.dat /ml-1m/users.csv
````

* Move the data into HDFS folder Movie_Lens,folder structure Movie_Lens/ml-1m

![image](https://user-images.githubusercontent.com/69738890/95402279-e7348580-08d4-11eb-9eb4-401619535409.png)

* Create movies.sql,ratings.sql,users.sql
```
nano movies.sql
nano ratings.sql
nano users.sql
```

Copy SQL code from the repo files movies.sql,ratings.sql,users.sql
```
hive -f users.sql
```

![image](https://user-images.githubusercontent.com/69738890/95402545-a1c48800-08d5-11eb-9b59-3a7051eaea5c.png)

OR manually execute the commands in the hive shell as shown below

![image](https://user-images.githubusercontent.com/69738890/95404381-7bedb200-08da-11eb-8aee-cb0f2d432d13.png)

# EXPLORED QUESTIONS
##### Top 10 viewed movies
```
SELECT movies.MovieID,movies.Title,COUNT(DISTINCT ratings.UserID) as views
FROM movies JOIN ratings ON (movies.MovieID = ratings.MovieID)
GROUP BY movies.MovieID, movies.Title
ORDER BY views DESC
LIMIT 10;
```
![image](https://user-images.githubusercontent.com/69738890/95404826-bb68ce00-08db-11eb-94c1-bbf7bca70d1c.png)

#### Top 20 rated movies having at least 40 views
```
SELECT movies.MovieID,movies.Title,AVG(ratings.Rating) as rtg,COUNT(DISTINCT ratings.UserID) as views
FROM movies JOIN ratings ON (movies.MovieID = ratings.MovieID)
GROUP BY movies.MovieID,movies.Title
HAVING views >= 40
ORDER BY rtg DESC
LIMIT 20;
</CODE>
```
![image](https://user-images.githubusercontent.com/69738890/95405157-a3457e80-08dc-11eb-8b6b-b07bdaba0533.png)

#### Create exploded view of movie id and genre
```
CREATE view movie_by_genre as SELECT movieid, genre FROM 
(
    SELECT movieid, split(genres, '\\|') genres FROM movies
) t LATERAL VIEW EXPLODE(genres) t as genre;
```

![image](https://user-images.githubusercontent.com/69738890/95405324-18b14f00-08dd-11eb-971d-3ac31f693342.png)

#### Find top 3 genres for each user
```
CREATE TEMPORARY TABLE movie_by_user_genre as 
SELECT t1.*, t2.rating,t2.userid 
FROM movie_by_genre t1 LEFT JOIN ratings t2 
ON t1.movieid = t2.movieid WHERE t2.rating >= 4;
```
 
```
CREATE TEMPORARY TABLE user_by_genre_totalrating as 
SELECT userid, genre, sum(rating) total_rating 
FROM movie_by_user_genre GROUP BY userid, genre;
```

```
SELECT * FROM 
(SELECT userid, genre, ROW_NUMBER() OVER (PARTITION by userid ORDER BY total_rating desc) row_num 
FROM user_by_genre_totalrating) t 
WHERE t.row_num <= 3;
```
![image](https://user-images.githubusercontent.com/69738890/95407159-dfc7a900-08e1-11eb-91b5-92f0d76c4dc2.png)












