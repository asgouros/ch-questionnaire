# Challenge Questionnaire

This is an SQL project that provides a solution to the challenge as described in [Project-L3-Questionnaire](Project%20-%20L3%20-%20Questionnaire.docx) 

## Overview

* Database structure is presented in [structure.sql](structure.sql)
* SQL Queries for each one of the required functionalities are presented in [queries.sql](queries.sql)
* A DB diagram is presented in [ch-questionnaire.png](ch-questionnaire.png)
* A full test DB dump is provided in [sql-dump](sql-dump)  

## Design notes

* Questionnaire-metadata are persisted in `questionnaire_metadata` table in a key-value fashion. This is an approach 
    that could potentially cover many use-cases, but this schema could be adapted.
* It has been assumed that each Question should have a **predefined set of possible answers**. These are persisted 
    in `questionnaire_asnwer_options`. The actual answers given by the responders are persisted in `responders_answers`.
* All dates will be stored in UTC
   

## Built With

* Solution was implemented and tested on MySQL (5.7.33-0ubuntu0.16.04.1)

## Authors

* **Andreas Sgouros** - [asgouros](https://www.linkedin.com/in/andreas-sgouros-46903a31/)




