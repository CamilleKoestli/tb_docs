drop database IF EXISTS dday;

create database dday;

use dday;

create table users(
    ID varchar(50), 
    pass varchar(50) NOT NULL, 
    PRIMARY KEY (ID)
);

create table posts(
    ID int,
    img varchar(50),
    nameLastname varchar(50),
    datepost varchar(50),
    PRIMARY KEY (ID)
);

insert into users value ("admin@admin.ch", "Ws3drftgzh$bjnimkl");
insert into users value ("jean.dupont@truite.ch", "Pass1234.");
insert into users value ("sille.vinpas@sini.ch", "flopPl0pPlipPlop");
insert into users value ("Fort@fili.pnato", "Vive_Sha3");

insert into posts (ID,img,nameLastname,datepost) value (1,"./img/resto.jpg","zortak Nekmi", "29 Octobre 2123");

insert into posts (ID,img,nameLastname,datepost) value (2,"","brehuk cheunh", "25 Octobre 2123");

insert into posts (ID,img,nameLastname,datepost) value (3,"","bobo fatt", "30 Octobre 2123");

insert into posts (ID,img,nameLastname,datepost) value (4,"./img/vaisseau.png","raj raj sknib", "01 Novembre 2123");

insert into posts (ID,img,nameLastname,datepost) value (5,"","zinwhu", "06 Novembre 2123");

insert into posts (ID,img,nameLastname,datepost) value (6,"","zinwhu", "01 Novembre 2123");

insert into posts (ID,img,nameLastname,datepost) value (7,"","zinwhu", "27 Octobre 2123");

insert into posts (ID,img,nameLastname,datepost) value (8,"./img/resto2.jpg","zinwhu", "24 Octobre 2123");



