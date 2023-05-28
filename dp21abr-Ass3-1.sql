-- START OF FILE
-- ================================================================================
--
-- ===============================
--
-- MONUMENT TRAVEL -- ASSIGNMENT 3
--
-- ===============================
--
-- TASK ONE - Insertion of data ( 3 parts )
-- TASK TWO - Queries ( 12 in total )
--
-- PLESE READ THIS DOCUMENT CAREFULLY.
-- -----------------------------------
--
-- BEFORE YOU START you must check you have completed the following:
--  
--  0 Download both Monument_Tour_Table_and_Data.sql from Canvas.
--    It is available from the assignment specification description.
--
--  0 Open the file Monument_Tour_Table_and_Data.sql in SQL Developer and
--    use the Run Script icon (icon with page and small green triangle) or
--    accelerator F5 to run the script.
--    Output may show old versions of tables being removed if run multiple
--    times, before creating clean tables and populating with supplied data.
--    First time through the output should be as follows:
--
--     Dropping Tables ...
--     Create Tables ...
--      ... A3_TOUR
--      ... A3_LOCATION
--      ... A3_GUIDE
--      ... A3_CLIENT
--      ... A3_OUTING
--      ... A3_PARTICIPANT
--      ... A3_NEXT_OF_KIN
--      ... A3_QUALIFICATION
--      ... A3_ITINERARY_ITEM
--     Populate Tables ...
--      ... A3_TOUR
--      ... A3_LOCATION
--      ... A3_ITINERARY_ITEM
--      ... A3_GUIDE
--      ... A3_QUALIFICATION
--      ... A3_NEXT_OF_KIN
--      ... A3_OUTING
--      ... A3_CLIENT
--      ... A3_PARTICIPANT
--
--     All tables re-created and populated.
--
--
--     PL/SQL procedure successfully completed.
--
--
--  0 Confirm that 9 new tables exist all ending starting A3_
--	  ( A3_Client, A3_Guide, A3_Itinerary_Item, A3_Location, A3_Next_of_Kin,
--      A3_Outing, A3_Participant, A3_Qualification, A3_Tour )
--
--  0 Check each table contains data records in each as follows:
--		SELECT COUNT(*) FROM <table>;
--
--	A3_Client           100
--  A3_Guide              8
--  A3_Itinerary_Item    43
--  A3_Location          38
--  A3_Next_of_Kin       12
--  A3_Outing            42
--  A3_Participant      256
--  A3_Qualification     23
--  A3_Tour              10
--
--
--  0 Only once you are happy with the tables and data, then progress to the two
--    tasks:
----
-- ======================
-- TASK ONE - ADDING DATA
-- ======================
--
-- You must add the following data to that already inserted into the 9 table
-- schema.
-- Add the INSERT commands used to a SQL script file called aa99aaa-newdata.sql,
-- where aa99aaa is replaced by your username.
--
-- DO NOT remove any existing records
--
-- ADD the following:
--
--  1 - A record in A3_Guide which represents you. [ 2 marks ]
--
--      You should not use your real address or phone number or dob, make these
--      up, but make them realistic, especially dates!!
--
--      However, your name should be correct using the given and family name
--      recorded on the student system.
--      Create a unique number for the Guide_No entry.
--
--  2 - Create a tour. [ 2 marks ]
--
--      This can based around any city/area you are familiar with, name it, a
--      duration in hours, and a price and enter in the A3_Tour table.
--
--  3 - Identify locations for this tour. [ 8 marks ]
--
--      I suggest no more than 5 and add these to the A3_Location table.
--      You may use 1 or 2 existing ones, but create at least 3 new ones.
--
--  4 - Create a record for yourself as qualified to guide your new tour on the
--      A3_Qualification table, sensible date again. [ 2 marks ]
--
--  5 - Create an inaugural outing for your new tour, date and time of your choice
--      with you as the guide obviously. [ 2 marks ]
--
--  Note:
--
--	    Store your final INSERT commands in a script file and name it
--      aa99aaa-newdata.sql, where aa99aaa is replaced by your oracle username.
--
--      If during this process, you corrupt the dataset, go back and use the
--      script downloaded to reset the original tables and data
--      Once you are happy ALL INSERTS are correct, it may be a good idea to run
--      the supplied script and your script again to refresh the dataset before
--      starting ...
--
--      DO NOT include the INSERT commands in this file.
--
-- END OF ASSIGNMENT TASK ONE ----------------------------------------------------
--
-- TASK TWO - QUERYING  [ 8 marks per query ] 84 in total
-- ===================
--
-- For this task use SQL Developer to build queries that provide the correct
-- answer to the question asked. Once the query is correct, copy the script into
-- this file in the spaces provided. Answer as many questions if you can. 
--
-- Submission instructions are given at the end of this file.
--
--
-- QUESTION 1
-- ==========
--
-- Provide a list of all tours, listing their name, the duration of the tour and the 
-- cost of each tour.
-- 
-- Solution Test: The original data provided gives 10 records as you will have
-- added yourself own tour, the output from this query should list 11 records.
-- The provided data set should look as below
--
-- TOUR_NAME                                  DURATION       COST
-- ---------------------------------------- ---------- ----------
-- Taste of London                                   5       75.5
-- Shakespeare's Home                                7        105
-- London at Night                                   4         82
-- Scenes of Edinburgh                               6       72.5
-- Cambridge Colleges                                4         35
-- Royal Windsor                                     4         60
-- The West End                                      4         75
-- The Red Bus 1                                     3         50
-- The Red Bus 2                                     5         70
-- Roman Bath                                        4         66
--
-- Type your query below:
SELECT tour_name, duration, cost FROM a3_tour; 


-- QUESTION 2
-- ==========
--
-- List all outings scheduled that have less than 3 participants booked on them.
-- Simply list the Outing ID, the date it is due to start and the number of
-- participants booked on it. Label the columns as shown below.
--
-- Solution Test: The output from this query should list 4 records.
--
-- Outing   Date                 Number of Participants
-- -------- -------------------- ----------------------
-- 21000183 19-Jun-2021                               1
-- 21000202 03-Jun-2021                               2
-- 21000169 29-May-2021                               2
-- 21000178 01-May-2021                               2                                     
--
-- Type your query below:
SELECT p.outing_id AS "Outing",o.outing_start AS "Date",COUNT(*) AS "Number of participant"
FROM a3_participant p JOIN a3_outing o ON (p.outing_id = o.outing_id)
GROUP BY p.outing_id,o.outing_start
HAVING COUNT(*) < 3
ORDER BY o.outing_start DESC;


-- QUESTION 3
-- ==========
--
-- Include three layers of nested select statement to answer
-- the following:
-- List all tours that visit at lease one location of type
-- "Educational".
--
-- Solution Test: Only one tour visits an Educational location.
--
-- Tours with Educational Content          
----------------------------------------
-- Scenes of Edinburgh

--
-- Type your query below:
SELECT tour_name AS "Tours with Educational Content"
FROM a3_tour JOIN a3_itinerary_item ON ( a3_tour.tour_id = a3_itinerary_item.tour )
JOIN a3_location ON ( a3_itinerary_item.location = a3_location.location_id )
WHERE a3_location.type = 'Educational';



-- QUESTION 4
-- ==========
--
-- List all locations that starting points for a tour.
-- List the name of these locations and name of the tour that satarts there
-- 
-- Solution Test: The following 10 records should be output, plus the starting
--  point of your tour.
--
-- First Location                                     Tour                                    
-- -------------------------------------------------- ----------------------
-- Tower of London                                    Taste of London                         
-- Stratford-upon-Avon Butterfly Farm                 Shakespeare's Home                      
-- London Eye                                         London at Night                         
-- Edinburgh Castle                                   Scenes of Edinburgh                     
-- Porterhouse College                                Cambridge Colleges                      
-- Windsor Great Park                                 Royal Windsor                           
-- Trafalgar Square                                   The West End                            
-- Buckingham Palace                                  The Red Bus 1                           
-- Tower Bridge                                       The Red Bus 2                           
-- Roman Baths                                        Roman Bath                              
--
-- Type your query below:
SELECT name AS "First Location",tour_name AS "Tour"
FROM a3_tour JOIN a3_itinerary_item ON ( a3_tour.tour_id = a3_itinerary_item.tour )
JOIN a3_location ON ( a3_itinerary_item.location = a3_location.location_id )
WHERE a3_itinerary_item.order_visited_number = 1
ORDER BY a3_tour.tour_id;


-- QUESTION 5
-- ==========
--
-- Create a schedule for client Ludmila Askenaza, listing all the outings she is
-- due to participate in. Her schedule needs to detail, in chronological order,
-- the date and time of the tour, its name, its length and the first location it visits.
-- It is useful if the date includes the day of the week (in abbrieviated form)
-- the tour runs, but not the year, the time is also important. Also ensure the
-- column headings are contextually meaningful.
--
-- Solution Test: Ludmila has 6 tours planned into her schedule, three of which
--                are the same tour, she plans to show various friends London.
--
-- When                                 Tour Name                                Hours
--------------------------------------- ---------------------------------------- ----------
-- Friday April 30 - 12:00                 Taste of London                                   5
-- Sunday May 16 - 11:30                   Taste of London                                   5
-- Friday May 28 - 10:00                   Scenes of Edinburgh                               6
-- Saturday May 29 - 12:00                 Taste of London                                   5
-- Thursday June 17 - 13:30                The West End                                      4
-- Friday June 18 - 13:30                  Cambridge Colleges                                4
--
-- Type your query below:
SELECT TO_CHAR ( outing_start, 'fmDay Month DD - HH24:MI' ) AS "When",tour_name AS "Tour Name",duration AS "Hours"    
FROM a3_outing,a3_tour,a3_client,a3_participant
WHERE a3_client.client_no = a3_participant.client
AND a3_participant.outing_id = a3_outing.outing_id
AND a3_outing.tour_id = a3_tour.tour_id
AND a3_client.client_no = 80216508
ORDER BY TO_CHAR ( outing_start, 'Month' ) ASC;


-- QUESTION 6
-- ==========
--  
-- The company needs to know if any guides passed their qualification more than
-- 8 years in order that they can be encouraged to refresh their knowledge.
-- List all the Qualifications passed for longer than 8 and who the guide is who
-- passed and on which tour it was.
-- Indicate in the list, the guides name (combining both parts of their name in
-- a single formatted column of your choice), their current age, the tour they
-- are qualified on and the length of time they have been qualified for over
-- 8 years.
-- Please provide headings to the columns that are meaningful as below.
--
-- Hint: Use some of the maths functions provided in the SQL Manual.
--       Documentation on other Math functions can be found here:
--          https://docs.oracle.com/middleware/12212/biee/BIVUG/GUID-DE2A646A-2DAB-4D9E-BDDB-3AA4923BF1CE.htm#BILUG684
--       Documentation on other Date datatype function examples can be found here:
--          http://www.dba-oracle.com/t_oracle_date_functions.htm
--
-- Solution Set: Run on Dec 07 2021
--
-- Guide                      Qualified on                 Years Passed
-- -------------------------- ---------------------------- ------------
-- March, Claire              Taste of London                         9
-- March, Claire              Shakespeare's Home                     10
-- McLinlay, Grace            Scenes of Edinburgh                     9
-- D'Ville, Reuben            Cambridge Colleges                     12
-- D'Ville, Reuben            The West End                           11
--
-- Type your query below:
SELECT family_name || ', ' || given_name AS "Guide", tour_name AS "Qualified on", TRUNC(MONTHS_BETWEEN(SYSDATE,a3_qualification.date_passed)/12) AS "Years Passed"
FROM a3_guide,a3_tour,a3_qualification
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE,a3_qualification.date_passed)/12) > 8 AND a3_guide.guide_no = a3_qualification.guide AND a3_qualification.tour = a3_tour.tour_id;


-- QUESTION 7
-- ==========
--  
-- List the tour names of all tours which have no outing
-- scheduled. 
--
-- Hint: Review all members of tennis clubs query in slides including the
-- NVL function. 
--
-- TOUR_NAME                               
-- ----------------------------------------
-- Royal Windsor
--
-- Type your query below:
SELECT t.tour_name 
FROM a3_tour t FULL JOIN a3_outing o ON ( t.tour_id = o.tour_id )
WHERE outing_id IS NULL;


-- QUESTION 8
-- ==========
--
-- The company needs to identify any client that has accidentally or purposely
-- registered to participate on two or more outings of the same tour.
-- Note: Due to the physical model of the database a client cannot participate in
-- the same outing twice.
--
-- List all clients who have registered their participation on many outings of the
-- SAME tour. The output should show the tour name, the clients name and number
-- and the number of outings of that tour they have registered on, and have
-- sensible column headings.
--
-- Tour                   Client                                    Outings
-- ---------------------- ----------------------------------------- ----------
-- Taste of London        Ludmila Askenaza (80216508)                        3
-- The Red Bus 2          John Yang (50098335)                               2
-- Shakespeare's Home     Claire Holmsworthy (61187434)                      2

-- Type your query below:
SELECT t.tour_name AS "Tour", c.name || ' (' || c.client_no || ')' AS "Client",COUNT(*) AS "Outings"
FROM a3_client c JOIN a3_participant p ON (c.client_no = p.client)
JOIN a3_outing o ON (p.outing_id = o.outing_id)
JOIN a3_tour t ON (o.tour_id = t.tour_id)
GROUP BY t.tour_name,c.name || ' (' || c.client_no || ')'
HAVING COUNT(*) > 1
ORDER BY 3 DESC;


-- QUESTION 9
-- ==========
--
-- The company needs a query to identify which guides birthday is next. The report
-- should list the guides name, the month and day of the month of their birthday
-- and their age on their next birthday. Layout as shown in the solution set below.
--
-- Hint: GUse some of the maths functions provided in the SQL Manual.
--       Documentation on other Math functions can be found here:
--          https://docs.oracle.com/middleware/12212/biee/BIVUG/GUID-DE2A646A-2DAB-4D9E-BDDB-3AA4923BF1CE.htm#BILUG684
--       Documentation on other Date datatype function examples can be found here:
--          http://www.dba-oracle.com/t_oracle_date_functions.htm
--
-- Solution Set: Run on Dec 07 2021
--
-- Guide             Birth Date        Age Then
-- ----------------- ----------------- ----------
-- Zimmer, Lars      January 2nd       42
--
-- Type your query below:
SELECT family_name || ', ' || given_name AS "Guide",TO_CHAR ( DOB, 'Month ddth' ) AS "Birth Date",TRUNC(months_between(sysdate,DOB)/12) AS "Age Then" 
FROM a3_guide
WHERE TRUNC(months_between(sysdate,DOB)/12) < TRUNC(months_between(sysdate + 10,DOB)/12);

-- QUESTION 10, 11, 12
-- ===================
-- Write three queries to provide the basic information needed about YOUR tour.
-- 
-- 10
-- ==
--
-- The basic information should include the name of the tour and its number, 
-- how long it lasts, when it will happen and the cost, plus the guides name
-- and number (you)
--
-- Solution Set:
--
-- Tour                          Lasts     Date            Cost of Tour Guided by                                                                                  
-- ----------------------------- --------- --------------- ------------ -----------------------
-- Scenes of Edinburgh - 100369  6 hours   June 29th 2021        £72.50 Tulane, Grant [302876]                                                                     

-- Type your query below:
SELECT (t.tour_name || ' - ' || t.tour_id ) AS "Tour",(t.duration || ' hours') AS "Lasts",to_char(o.outing_start,'Month ddth YYYY') AS "Date",to_char(t.cost, 'L999,999.00') AS "Cost of Tour",(g.given_name || ', ' || g.family_name || ' [' || g.guide_no || ']' ) AS "Guided by"
FROM a3_tour t, a3_outing o, a3_qualification q, a3_guide g
WHERE t.tour_id=o.tour_id
AND t.tour_id=q.tour
AND q.guide=g.guide_no
AND t.tour_id='100300';


--
-- 11
-- ==
--
-- The inventory should include a list of all the locations being visited and
-- their type, and description in the order they will be visited.
--
-- Location                     Type          Description     
-- ---------------------------- ------------- -------------------------------------------------
-- Roman Baths                  Historic      Includes Temple of Sulis Minerva, built in 75BC
-- Royal Crescent               Landmark      Georgian architectural masterpiece
-- Pulteney Bridge              Landmark      Building topped bridge that spans the River Avon
-- Herschel Museum of Astronomy Historic      Museum dedicated to the discoverer of Uranus
--
-- Type your query below:
SELECT l.name AS "Location", l.type AS "Type", l.description AS "Description"
FROM a3_itinerary_item i, a3_location l
WHERE l.location_id = i.location
AND tour = '100437'
ORDER BY i.order_visited_number;

--
-- 12
-- ==
--
-- Your qualification badge data which includes your guide number, name, DoB, the
-- tour name you are qualified on and when that qualification was gained. Format
-- of the report must reflect the output in the solution set below.
--
-- Solution Set:
--
-- GID    Name            DoB                    Qualification  Date Passed                                    
-- ------ --------------- ---------------------- -------------- ---------------
-- 982354 March, Claire   September 25th, 1965   100348         June 3rd, 2011                                 
--
--
-- Type your query below:
SELECT guide_no AS "GID", family_name || ', ' || given_name AS "Name", TO_CHAR ( DOB, 'Month dd"th," YYYY') AS "DoB", tour AS "Qualification", TO_CHAR ( date_passed, 'Month DD"th," YYYY') AS "Date Passed"      
FROM a3_guide,a3_qualification
WHERE a3_guide.guide_no = a3_qualification.guide
AND a3_guide.guide_no = 135790;


-- END OF ASSIGNMENT TASK TWO -----------------------------------------------------------------------------------------------------------

-- SUBMISSION REQUIREMENTS
-- =======================
--
-- Once your queries are tested and the final version placed in the file above in
-- the appropriate place, the following should be done in order to meet the
-- submission requirements:
--
--  1  Rename this file in the following format:
--
--			aa99aaa-Ass3.sql
--
--     where the aa99aaa is replaced by your Oracle username
--
--  2  Open this file in an SQL Worksheet in SQL Developer, clear the Script
--     Output window using the eraser icon, and ensure your 9 table schema is
--     correct and includes your entered data, and you have entered your username
--     where indicated on line 39 of this file.
--
--  3  Use the "Run Script (F5)" icon (sheet of paper with small green triangle)
--     to run your script completely. Ensure all commands are run without errors.
--
--  4  Save the Script Output text by clicking on the "floppy disk" icon, use the
--     popup window to save the file as aa99aaa-Ass3.txt, again, where the
--     aa99aaa is replaced by your Oracle username
--
--  5  Double check the aa99aaa-Ass3.sql and aa99aaa-Ass3.txt files, then upload
--     them onto CANVAS in the Assignment point.
--
--  6  Congratulations, you are done!
--
-- END ===================================================================================================================================



