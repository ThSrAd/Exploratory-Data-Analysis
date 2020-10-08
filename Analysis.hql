SELECT movies.MovieID,movies.Title,COUNT(DISTINCT ratings.UserID) as views
FROM movies JOIN ratings ON (movies.MovieID = ratings.MovieID)
GROUP BY movies.MovieID, movies.Title
ORDER BY views DESC
LIMIT 10;

SELECT movies.MovieID,movies.Title,AVG(ratings.Rating) as rtg,COUNT(DISTINCT ratings.UserID) as views
FROM movies JOIN ratings ON (movies.MovieID = ratings.MovieID)
GROUP BY movies.MovieID,movies.Title
HAVING views >= 40
ORDER BY rtg DESC
LIMIT 20;

create temporary table movie_by_user_genre as 
select t1.*, t2.rating,t2.userid 
from movie_by_genre t1 left join ratings t2 
on t1.movieid = t2.movieid where t2.rating >= 4;

create temporary table user_by_genre_totalrating as 
select userid, genre, sum(rating) total_rating 
from movie_by_user_genre group by userid, genre;

select * from 
(select userid, genre, row_number() over (partition by userid order by total_rating desc) row_num 
from user_by_genre_totalrating) t where t.row_num <= 3;
