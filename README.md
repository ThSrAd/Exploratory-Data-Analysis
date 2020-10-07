# SQL Analytics with HIVE
> Aim of this project is to explore advanced features in Hive that allows us to run SQL based analytical queries 
over large datasets  

The source is a sample MySQL database 'Adventure works'. We will ingest and transform the data before we proceed to analytics</br> 
Download the sample db script here - https://github.com/microsoft/sql-server-samples/tree/master/samples/databases

<hr>

## Table of Contents
* About dataset
* Environment
* Extract the Data
* Create Sqoop Job

<hr>

## About dataset
Adventure Works Cycles, a fictitious multinational manufacturing company that produces and distributes metal and composite bicycles to commercial markets in 
North America, Europe, and Asia. Headquartered in Bothell, WA, employs 500 or more additionally with several regional sales teams throughout its market base.

<hr>

## Environment
Cloudera Quickstart VM, Winscp, Putty, 

<hr>

## Extract and Transform the Data
Login to your Cloudera VM</br>
Import the .sql script file AWBackup.sql into vm using winscp</br>
Connect to the default mySQL provided as shown below</br>

![image](https://user-images.githubusercontent.com/69738890/95378397-775cd580-08a9-11eb-992d-92e093c2e9df.png)

Quit and return back to your vm .Now import the sql script into mysql db,this automatically creates database and tables for you</br>

![image](https://user-images.githubusercontent.com/69738890/95378599-c440ac00-08a9-11eb-9731-f1bc7418a169.png)

Connect to mySql DB,the Adventure works database would have been created</br>

![image](https://user-images.githubusercontent.com/69738890/95382976-0f5dbd80-08b0-11eb-8018-caf1494f1929.png)

Create views v_customer,v_salesorderdetails,v_salesorderheader. Views draw data from several tables all aggregations are performed in the views to create denormalized data</br>

![image](https://user-images.githubusercontent.com/69738890/95385021-05898980-08b3-11eb-82c6-191c96959d41.png)

<hr>

## Ingest Data via Sqoop Job

Use sqoop to transfer the data from mysql DB to HDFS. This gets incremental data updates from sql to the HDFS.</br>
Find complete scripts sqoop-job-commands </br>

<code>
sqoop-job --create loadcustomers -- import  --connect jdbc:mysql://quickstart:3306/adventureworks --username root \
--table v_customer  --as-parquetfile --target-dir /user/cloudera/bigretail/output/stores/sqoop/customers  --append \
--split-by CustomerID --num-mappers 1 --check-column ModifiedDate --incremental lastmodified \
--password-file /user/cloudera/passwordfile 
</code>
</br> </br>

![image](https://user-images.githubusercontent.com/69738890/95385662-e93a1c80-08b3-11eb-9f5f-d54cd14516a2.png)

<hr>

## Create Hive Table to load data
<code>
  create database store;</br>

use store;</br>

create external table product (
	productId int,
	name string,
	productnumber string,
	makeflag boolean,
	finishedgoodsflag boolean,
	color string,
	safetystocklevel int,
	reorderpoint int,
	standardcost double,
	listprice double,
	size string,
	sizeunitmeasurecode string,
	weightunitmeasurecode string,
	weight string,
	daystomanufacture int,
	productline string,
	class string,
	style string,
	sellstartdate bigint,
	sellenddate bigint
	discontinueddate bigint,
	productsubcategory string,
	productcategory string,
	producemodel string,
	catalogdescription string,
	instructions string,
	modifieddate bigint
)
stored as parquet
location '/user/cloudera/bigretail/output/stores/sqoop/products';
</code>

