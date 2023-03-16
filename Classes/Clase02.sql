-- Active: 1654168274613@@127.0.0.1@3306
CREATE DATABASE imdb;

use imdb;

create table Film (film_id int NOT NULL AUTO_INCREMENT primary key, 
title varchar(30),
description varchar(30), 
release_year year
);

create table Actor (actor_id int NOT NULL AUTO_INCREMENT primary key, 
first_name VARCHAR(30), 
last_name varchar(30)
); 

create table Film_actor (id_film_actor int NOT NULL AUTO_INCREMENT primary key,
actor_id int, 
film_id int,
constraint FOREIGN key (actor_id) REFERENCES Actor(actor_id),
constraint FOREIGN key (film_id) REFERENCES Film(film_id)
);

ALTER TABLE Film
ADD last_update varchar(30); 

ALTER TABLE Actor
ADD last_update varchar(30); 

insert into Film(film_id, title, description, release_year, last_update) values (0, "Titanic", "Amor", 2009, "a");
insert into Film(film_id, title, description, release_year, last_update) values (2, "WWZ", "Terror", 2017, "b");

insert into Actor(actor_id, first_name, last_name, last_update) values (0, "Leonardo", "DiCaprio", "a");
insert into Actor(actor_id, first_name, last_name, last_update) values (2, "Brad", "Pitt", "a");
