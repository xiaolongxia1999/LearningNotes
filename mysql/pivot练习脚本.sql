USE hive;
SELECT * FROM hive.test;


testtblsmysql

INSERT INTO hive.test (NAME,age)VALUES('mike',10);
INSERT INTO hive.test (NAME,age)VALUES('hive',10);
INSERT INTO hive.test (NAME,age)VALUES('hvase',10);
INSERT INTO hive.test (NAME,age)VALUES('test',10);
INSERT INTO hive.test (NAME,age)VALUES('spark',10);
INSERT INTO hive.test (NAME,age)VALUES('soak',10);
INSERT INTO hive.test (NAME,age)VALUES('sparktets',10);



SELECT NAME,SUM(CASE NAME WHEN 'mike' THEN age ELSE 0 END) AS 'mike',SUM(CASE NAME WHEN 'hive' THEN age ELSE 0 END),SUM(CASE NAME WHEN 'hvase' THEN age ELSE 0 END),SUM(CASE NAME WHEN 'test' THEN age ELSE 0 END),SUM(CASE NAME WHEN 'spark' THEN age ELSE 0 END),SUM(CASE NAME WHEN 'soak' THEN age ELSE 0 END),SUM(CASE NAME WHEN 'sparktets' THEN age ELSE 0 END) GROUP 






SELECT [NAME], SUM(CASE  book WHEN 'java从入门到精通' THEN saledNumber ELSE 0 END) AS [java从入门到精通],SUM(CASE  book WHEN 'C#高级编程' THEN saledNumber ELSE 0 END) AS [C#高级编程], sum(saledNumber) as [sum] from s group by [name]



CREATE TABLE s(
	NAME NVARCHAR(50),
	book NVARCHAR(50),
	saledNumber INT
)




SELECT * FROM s;


INSERT INTO s (NAME,book,saledNumber) VALUES('小王','java从入门到精通',10);

INSERT INTO s (NAME,book,saledNumber)VALUES('小李','java从入门到精通',15);
INSERT INTO s (NAME,book,saledNumber)VALUES('小王','C#高级编程',8);
INSERT INTO s (NAME,book,saledNumber)VALUES('小李','java从入门到精通',7);
INSERT INTO s (NAME,book,saledNumber)VALUES('小王','java从入门到精通',9);
INSERT INTO s (NAME,book,saledNumber)VALUES('小李','java从入门到精通',2);
INSERT INTO s (NAME,book,saledNumber)VALUES('小王','C#高级编程',3);
INSERT INTO s (NAME,book,saledNumber)VALUES('小李','java从入门到精通',5);
INSERT INTO s (NAME,book,saledNumber)VALUES('小李','C#高级编程',5);


SELECT NAME ,SUM(CASE book WHEN 'java从入门到精通' THEN saledNumber ELSE 0 END)/COUNT('java从入门到精通') AS java,SUM(CASE book WHEN 'C#高级编程' THEN saledNumber ELSE 0 END) AS C FROM s GROUP BY NAME 


SELECT sa.name,sa.java从入门到精通,sa.C#高级编程 ,sa.java从入门到精通+sa.C#高级编程 as 合计 from s pivot(sum(saledNumber) for book in (java从入门到精通,C#高级编程)) s





#以下为pivot求平均

SELECT * FROM s;

SELECT * FROM s ORDER BY NAME;

#亲测有效，对name和book先分组求平均——————将book列展成多个字段名：
SELECT sa.name,SUM(CASE sa.book WHEN 'C#高级编程' THEN sa.avg_s ELSE 0 END) AS c ,SUM(CASE sa.book WHEN 'java从入门到精通' THEN sa.avg_s ELSE 0 END) AS java FROM  (SELECT NAME,book,AVG(saledNumber) AS avg_s FROM s GROUP BY NAME,book) sa GROUP BY sa.name;


#求最大值也可以，不足之处，第一步分组统计——要修改统计的表
SELECT sa.name,SUM(CASE sa.book WHEN 'C#高级编程' THEN sa.max_s ELSE 0 END) AS c ,SUM(CASE sa.book WHEN 'java从入门到精通' THEN sa.max_s ELSE 0 END) AS java FROM  (SELECT NAME,book,MAX(saledNumber) AS max_s FROM s GROUP BY NAME,book) sa GROUP BY sa.name;
