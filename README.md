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
sed -i 's/::/,/g' ml-1m/movies.dat </br>
sed -i 's/::/,/g' ml-1m/users.dat </br>
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

* Move the data into HDFS folder MovieLens</br>

![image](https://user-images.githubusercontent.com/69738890/95402279-e7348580-08d4-11eb-9eb4-401619535409.png)

</br>










