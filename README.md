## SQL Analytics with HIVE
> Aim of this project is to explore advanced features in Hive that allows us to run SQL based analytical queries 
over large datasets 

<hr>

## Table of Contents
* About dataset
* Environment
* Extract the Data
* Create Sqoop Job

<hr>

## About dataset
MovieLens data sets were collected by the GroupLens Research Project at the University of Minnesota.
This data set consists of
100,000 ratings (1-5) from 943 users upon 1682 movies.
Each user has rated at least 20 movies.
Simple demographic info for the users (age, gender, occupation, zip)

Dataset Link: https://grouplens.org/datasets/movielens/1m/
<hr>

## Environment
Cloudera Quickstart VM, Winscp, Putty, 

<hr>

## Extract and Transform the Data
* Import the ml-1m file to clouderavm through winscp

* File is delimited by :: . Change the delimiters to comma formatted, (csv) </br>

![image](https://user-images.githubusercontent.com/69738890/95400797-2fea3f80-08d1-11eb-94e9-f73a742cfd17.png)

</br>
<code>
sed -i 's/::/,/g' ml-1m/movies.dat</br>
sed -i 's/::/,/g' ml-1m/users.dat</br>
sed -i 's/::/,/g' ml-1m/ratings.dat </br>
</code>
</br>

![image](https://user-images.githubusercontent.com/69738890/95400931-8c4d5f00-08d1-11eb-8425-fcbecbb55146.png)

</br>

* Rename file format from .dat to .csv </br>

<code>
mv ml-1m/movies.dat /ml-1m/movies.csv </br>
mv ml-1m/ratings.dat /ml-1m/ratings.csv </br>
mv ml-1m/users.dat /ml-1m/users.csv </br>
</code>
</br>

* Move the data into HDFS folder Movie_Lens,folder structure Movie_Lens/ml-1m </br>

![image](https://user-images.githubusercontent.com/69738890/95402279-e7348580-08d4-11eb-9eb4-401619535409.png)

</br>

* Create movies.sql,ratings.sql,users.sql</br>
<code>
nano movies.sql </br>
nano ratings.sql </br>
nano users.sql </br> 
</code>

Copy SQL code from the repo files movies.sql,ratings.sql,users.sql </br>
<code></br>
hive -f users.sql</br>
</code></br>

![image](https://user-images.githubusercontent.com/69738890/95402545-a1c48800-08d5-11eb-9b59-3a7051eaea5c.png)

</br>

OR manually execute the commands in the hive shell as shown below

![image](https://user-images.githubusercontent.com/69738890/95404381-7bedb200-08da-11eb-8aee-cb0f2d432d13.png)

# EXPLORED QUESTIONS
Top 10 viewed movies
<CODE>
SELECT movies.MovieID,movies.Title,COUNT(DISTINCT ratings.UserID) as views
FROM movies JOIN ratings ON (movies.MovieID = ratings.MovieID)
GROUP BY movies.MovieID, movies.Title
ORDER BY views DESC
LIMIT 10;
</CODE>
</BR>

![image](https://user-images.githubusercontent.com/69738890/95404826-bb68ce00-08db-11eb-94c1-bbf7bca70d1c.png)

</BR>
Top 20 rated movies having at least 40 views
<CODE>
SELECT movies.MovieID,movies.Title,AVG(ratings.Rating) as rtg,COUNT(DISTINCT ratings.UserID) as views
FROM movies JOIN ratings ON (movies.MovieID = ratings.MovieID)
GROUP BY movies.MovieID,movies.Title
HAVING views >= 40
ORDER BY rtg DESC
LIMIT 20;
</CODE>
</br>

![image](https://user-images.githubusercontent.com/69738890/95405157-a3457e80-08dc-11eb-8b6b-b07bdaba0533.png)

</br>

Create exploded view of movie id and genre</br>
<CODE>
create view movie_by_genre as select movieid, genre from (select movieid, split(genres, '\\|') genres from movies) t lateral view explode(genres) t as genre;
<CODE>
</br>

![image](https://user-images.githubusercontent.com/69738890/95405324-18b14f00-08dd-11eb-971d-3ac31f693342.png)

 
Find top 3 genres for each user</br>
<CODE>
create temporary table movie_by_user_genre as select t1.*, t2.rating,t2.userid from movie_by_genre t1 left join ratings t2 on t1.movieid = t2.movieid where t2.rating >= 4;</br>
create temporary table user_by_genre_totalrating as select userid, genre, sum(rating) total_rating from movie_by_user_genre group by userid, genre; </br>
select * from 
(select userid, genre, row_number() over (partition by userid order by total_rating desc) row_num from user_by_genre_totalrating) t where t.row_num <= 3
</CODE>
</br>












