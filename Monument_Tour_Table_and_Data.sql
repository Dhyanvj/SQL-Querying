SET SERVEROUTPUT ON
/
DECLARE
  r_cnt NUMBER := 0 ;
  TYPE t_names IS VARRAY(9) OF VARCHAR2(20);
  table_list t_names;
  
BEGIN

  table_list := t_names('A3_TOUR', 'A3_LOCATION', 'A3_GUIDE', 'A3_CLIENT', 'A3_OUTING', 'A3_PARTICIPANT', 'A3_NEXT_OF_KIN', 'A3_QUALIFICATION', 'A3_ITINERARY_ITEM');
  
  DBMS_OUTPUT.PUT_LINE('Dropping Tables ...');
  
  FOR element IN 1 .. table_list.count LOOP
    SELECT COUNT (*) INTO r_cnt FROM all_tables WHERE TABLE_NAME = table_list(element) AND owner = (SELECT sys_context ('userenv', 'current_schema') from dual);
    IF (r_cnt > 0)
    THEN
      EXECUTE IMMEDIATE 'DROP TABLE ' || table_list(element) || ' CASCADE CONSTRAINTS';
      DBMS_OUTPUT.PUT_LINE(' ... ' || table_list(element));
    END IF;
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('Create Tables ...');
  
  EXECUTE IMMEDIATE 'CREATE TABLE A3_TOUR 
                       (  Tour_ID   VARCHAR(6)      PRIMARY KEY,
                          Tour_Name VARCHAR2(40)	NOT NULL,
                          Duration  NUMBER(3,0)	    NOT NULL CHECK (Duration > 0),
                          Cost	    NUMBER(6,2)	    NOT NULL CHECK (Cost > 0))';
                          
  DBMS_OUTPUT.PUT_LINE(' ... A3_TOUR');
  
  EXECUTE IMMEDIATE 'CREATE TABLE A3_LOCATION 
                       (  Location_ID   VARCHAR(8)      PRIMARY KEY,
                          Name	        VARCHAR2(50)	NOT NULL,
                          Type	        VARCHAR2(20)	CHECK ( Type IN (''Landmark'', ''Cultural'', ''Historic'', ''Leisure'', ''Educational'', ''Other'')),
                          Description	VARCHAR2(1000))';
                          
  DBMS_OUTPUT.PUT_LINE(' ... A3_LOCATION');
  
  EXECUTE IMMEDIATE 'CREATE TABLE A3_GUIDE 
                       (  Guide_No	    VARCHAR2(6)	    PRIMARY KEY,
                          Family_Name	VARCHAR2(40)	NOT NULL,
                          Given_Name	VARCHAR2(40)	NOT NULL,
                          Address	    VARCHAR2(80),
                          DoB	        DATE,
                          Date_Joined	DATE	        NOT NULL,
                          Supervisor	VARCHAR2(6)	    REFERENCES A3_Guide(Guide_No))';
                          
  DBMS_OUTPUT.PUT_LINE(' ... A3_GUIDE');

  EXECUTE IMMEDIATE 'CREATE TABLE A3_CLIENT
                       (  Client_No	  VARCHAR2(8)	    PRIMARY KEY,
                          Name	      VARCHAR2(80)	    NOT NULL,
                          Address	  VARCHAR2(100)	    NOT NULL,
                          Phone_No	  VARCHAR2(11)	    NOT NULL,
                          Discount	  NUMBER(2,2))';
                          
  DBMS_OUTPUT.PUT_LINE(' ... A3_CLIENT');

  EXECUTE IMMEDIATE 'CREATE TABLE A3_Outing
                       (  Outing_ID     VARCHAR2(8)     PRIMARY KEY,
                          Tour_ID	    VARCHAR2(6) 	NOT NULL REFERENCES A3_Tour (Tour_ID),
                          Outing_Start  DATE	        NOT NULL,
                          Guide	        VARCHAR2(6)	    NOT NULL REFERENCES A3_Guide (Guide_No))';
                           
  DBMS_OUTPUT.PUT_LINE(' ... A3_OUTING');

  EXECUTE IMMEDIATE 'CREATE TABLE A3_PARTICIPANT 
                       (  Outing_ID     VARCHAR2(8)     NOT NULL REFERENCES A3_Outing (Outing_ID),
                          Client	    VARCHAR2(8)	    NOT NULL REFERENCES A3_Client (Client_No),
                           PRIMARY KEY (Outing_ID, Client))';
                           
  DBMS_OUTPUT.PUT_LINE(' ... A3_PARTICIPANT');

  EXECUTE IMMEDIATE 'CREATE TABLE A3_NEXT_OF_KIN 
                       (  Guide_No	        VARCHAR2(6)	    NOT NULL REFERENCES A3_Guide (Guide_No),
                          Kin_Number	    VARCHAR2(1)	    NOT NULL CHECK (Kin_Number IN (''1'',''2'')),
                          Name	            VARCHAR2(80)    NOT NULL,
                          Relationship      VARCHAR2(20),
                          Contact_Number    VARCHAR2(11)	NOT NULL,
                           PRIMARY KEY (Guide_No, Kin_Number))';
                           
  DBMS_OUTPUT.PUT_LINE(' ... A3_NEXT_OF_KIN');

  EXECUTE IMMEDIATE 'CREATE TABLE A3_QUALIFICATION 
                       (  Tour	        VARCHAR2(40)	NOT NULL REFERENCES A3_Tour (Tour_ID),
                          Guide	        VARCHAR2(6)	    NOT NULL REFERENCES A3_Guide (Guide_No),
                          Date_Passed	DATE	        NOT NULL,
                           PRIMARY KEY (Tour, Guide))';
                           
  DBMS_OUTPUT.PUT_LINE(' ... A3_QUALIFICATION');

  EXECUTE IMMEDIATE 'CREATE TABLE A3_ITINERARY_ITEM
                       (  Tour	                VARCHAR2(6)	NOT NULL REFERENCES A3_Tour (Tour_ID),
                          Location	            VARCHAR2(8)	NOT NULL REFERENCES A3_Location (Location_ID),
                          Order_Visited_Number	NUMBER(2,0)	NOT NULL CHECK (Order_Visited_Number BETWEEN 1 AND 10),
                           PRIMARY KEY (Tour, Location))';
                           
  DBMS_OUTPUT.PUT_LINE(' ... A3_ITINERARY_ITEM');

  DBMS_OUTPUT.PUT_LINE('Populate Tables ...');

  EXECUTE IMMEDIATE 'INSERT INTO A3_Tour VALUES (''100345'', ''Taste of London'', 5, 75.50)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Tour VALUES (''100348'', ''Shakespeare''''s Home'', 7, 105.00)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Tour VALUES (''100356'', ''London at Night'', 4, 82.00)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Tour VALUES (''100369'', ''Scenes of Edinburgh'', 6, 72.50)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Tour VALUES (''100384'', ''Cambridge Colleges'', 4, 35.00)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Tour VALUES (''100401'', ''Royal Windsor'', 4, 60.00)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Tour VALUES (''100402'', ''The West End'', 4, 75.00)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Tour VALUES (''100411'', ''The Red Bus 1'', 3, 50.00)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Tour VALUES (''100419'', ''The Red Bus 2'', 5, 70.00)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Tour VALUES (''100437'', ''Roman Bath'', 4, 66.00)';

  DBMS_OUTPUT.PUT_LINE(' ... A3_TOUR');

  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11078345'', ''Tower of London'', ''Historic'', ''Home of the Crown Jewels'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11078629'', ''Tower Bridge'', ''Historic'', ''Iconic opening bridge over River Thames'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11079053'', ''O2 Arena'', ''Leisure'', ''Built to celebrate millenium'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11079730'', ''Buckingham Palace'', ''Cultural'', ''Home of the British Monarch in London'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11081659'', ''Cenotaph'', ''Cultural'', ''War memorial in Whitehall'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11082772'', ''Palace of Westminster'', ''Cultural'', ''Houses British Parliament and Big Ben'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11085783'', ''St. Pauls Cathedral'', ''Cultural'', ''Home of the Crown Jewels'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11088693'', ''Piccadilly Circus'', ''Landmark'', ''Busy centre of West End with Eros statue'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11089959'', ''London Eye'', ''Leisure'', ''Large ferris wheel on south bank of Thames'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11090734'', ''Cutty Sark'', ''Historic'', ''World''''s sole surviving tea clipper'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11092247'', ''Royal Botanic Gardens'', ''Leisure'', ''World famous gardens and hothouses'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11093939'', ''Natural History Museum'', ''Educational'', ''Famous for full size whale skeleton in entrance'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11096008'', ''London Zoological Gardens'', ''Leisure'', ''Zoo sited in Regents Park'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11093183'', ''Trafalgar Square'', ''Landmark'', ''Contains Nelson''''s Column'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11095678'', ''Covent Garden'', ''Landmark'', ''Eating and street entertainment'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11098366'', ''Leicester Square'', ''Landmark'', ''Cinema centre'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11101217'', ''Royal Shakespeare Theatre'', ''Cultural'', ''Home of the RSC, stages Shakespeare''''s and other plays'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11103562'', ''Anne Hathaway''''s Cottage'', ''Historic'', ''Wife of Shakespeares'''' home'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11106882'', ''Stratford-upon-Avon Butterfly Farm'', ''Leisure'', ''UK''''s largest tropical butterfly attraction'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11109000'', ''Shakespeare''''s Birthplace'', ''Historic'', ''House in the centre of Stratford-upon-Avon'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11110164'', ''Edinburgh Castle'', ''Historic'', ''Stages One o''''clock salute each day'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11114734'', ''Palace of Holyroodhouse'', ''Historic'', ''Queen''''s official residence in Edinburgh'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11116856'', ''Royal Mile'', ''Landmark'', ''Thoroughfare linking Castle to Holyrood, full of shops'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11118923'', ''Arthur''''s Seat'', ''Landmark'', ''Highpoint and views over the city and Forth river'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11120546'', ''Dynamic Earth'', ''Educational'', ''Presentation of Earth''''s geological history'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11124666'', ''John Knox House'', ''Cultural'', ''Storytelling centre based on scottish cutural heritage'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11129010'', ''Porterhouse College'', ''Historic'', ''Oldest college in Cambridge'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11131437'', ''St. John''''s College'', ''Historic'', ''Includes the Combination Room and Bridge of Sighs'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11136448'', ''Fitzwilliam Museum'', ''Cultural'', ''Premier museum in Cambridge, including art, pottery and antiquities'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11139024'', ''Queen''''s College'', ''Historic'', ''Includes First Court and the Mathematical Bridge'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11139774'', ''Windsor Castle'', ''Historic'', ''Founded by William the Conqueror in 11th Century'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11142324'', ''Eton College'', ''Historic'', ''School founded in 1440 by Henry VI'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11147390'', ''Windsor Great Park'', ''Leisure'', ''Large arkland including Virginia Water and Savill Gardens'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11157313'', ''Bel and the Dragon'', ''Other'', ''Traditional British Restaurant with views of Windsor Castle'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11158909'', ''Roman Baths'', ''Historic'', ''Includes Temple of Sulis Minerva, built in 75BC'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11160231'', ''Royal Crescent'', ''Landmark'', ''Georgian architectural masterpiece'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11167016'', ''Pulteney Bridge'', ''Landmark'', ''Building topped bridge that spans the River Avon'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Location VALUES (''11170444'', ''Herschel Museum of Astronomy'', ''Historic'', ''Museum dedicated to the discoverer of Uranus'')';

  DBMS_OUTPUT.PUT_LINE(' ... A3_LOCATION');
  
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100345'', ''11078345'', 1)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100345'', ''11078629'', 2)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100345'', ''11079730'', 3)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100345'', ''11085783'', 4)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100345'', ''11082772'', 5)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100348'', ''11106882'', 1)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100348'', ''11103562'', 2)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100348'', ''11109000'', 3)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100348'', ''11101217'', 4)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100356'', ''11089959'', 1)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100356'', ''11078629'', 2)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100356'', ''11088693'', 3)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100356'', ''11079053'', 4)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100369'', ''11110164'', 1)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100369'', ''11114734'', 3)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100369'', ''11116856'', 2)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100369'', ''11118923'', 4)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100369'', ''11120546'', 5)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100369'', ''11124666'', 6)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100384'', ''11129010'', 1)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100384'', ''11131437'', 2)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100384'', ''11136448'', 3)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100384'', ''11139024'', 4)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100401'', ''11147390'', 1)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100401'', ''11142324'', 2)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100401'', ''11139774'', 3)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100401'', ''11157313'', 4)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100402'', ''11093183'', 1)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100402'', ''11088693'', 2)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100402'', ''11098366'', 3)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100402'', ''11095678'', 4)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100411'', ''11079730'', 1)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100411'', ''11081659'', 2)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100411'', ''11082772'', 2)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100419'', ''11078629'', 1)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100419'', ''11078345'', 2)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100419'', ''11093183'', 3)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100419'', ''11079730'', 4)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100419'', ''11082772'', 5)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100437'', ''11158909'', 1)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100437'', ''11160231'', 2)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100437'', ''11167016'', 3)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Itinerary_Item VALUES (''100437'', ''11170444'', 4)';

  DBMS_OUTPUT.PUT_LINE(' ... A3_ITINERARY_ITEM');

  EXECUTE IMMEDIATE 'INSERT INTO A3_Guide VALUES (''183476'', ''Simmonds'', ''Michael'', ''15, Lynton Mills, Westerton'', TO_DATE(''24-09-1993'', ''DD-MM-YYYY''), TO_DATE(''10-03-2016'', ''DD-MM-YYYY''), NULL)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Guide VALUES (''197362'', ''D''''Ville'', ''Reuben'', ''The Glebe, Lakeside View, Masterton'', TO_DATE(''13-01-1976'', ''DD-MM-YYYY''), TO_DATE(''16-05-2009'', ''DD-MM-YYYY''), NULL)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Guide VALUES (''208655'', ''Govern'', ''Michelle'', ''67b, Liston Drive, Masterton'', TO_DATE(''31-07-1986'', ''DD-MM-YYYY''), TO_DATE(''21-07-2019'', ''DD-MM-YYYY''), ''197362'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Guide VALUES (''337623'', ''McLinlay'', ''Grace'', ''1, Highland Road, Southerton'', TO_DATE(''21-09-1975'', ''DD-MM-YYYY''), TO_DATE(''28-03-2011'', ''DD-MM-YYYY''), NULL)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Guide VALUES (''108398'', ''Zimmer'', ''Lars'', ''9, Knowles Avenue, Graystown'', TO_DATE(''02-01-1980'', ''DD-MM-YYYY''), TO_DATE(''13-10-2012'', ''DD-MM-YYYY''), NULL)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Guide VALUES (''982354'', ''March'', ''Claire'', ''87, High Street, Westerton'', TO_DATE(''25-09-1965'', ''DD-MM-YYYY''), TO_DATE(''16-05-2009'', ''DD-MM-YYYY''), NULL)';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Guide VALUES (''763401'', ''Dzabo'', ''Clive'', ''2c, Clave Hill, Turville'', TO_DATE(''30-04-1998'', ''DD-MM-YYYY''), TO_DATE(''17-02-2021'', ''DD-MM-YYYY''), ''982354'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Guide VALUES (''302876'', ''Tulane'', ''Grant'', ''73, Highland Road, Southerton'', TO_DATE(''05-03-2000'', ''DD-MM-YYYY''), TO_DATE(''21-03-2021'', ''DD-MM-YYYY''), ''197362'')';

  DBMS_OUTPUT.PUT_LINE(' ... A3_GUIDE');

  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100345'', ''183476'', TO_DATE(''15-12-2016'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100345'', ''982354'', TO_DATE(''17-08-2012'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100348'', ''982354'', TO_DATE(''03-06-2011'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100356'', ''108398'', TO_DATE(''17-02-2014'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100356'', ''763401'', TO_DATE(''18-02-2021'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100356'', ''337623'', TO_DATE(''14-06-2013'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100369'', ''337623'', TO_DATE(''12-05-2012'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100384'', ''183476'', TO_DATE(''30-05-2016'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100384'', ''197362'', TO_DATE(''10-11-2009'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100384'', ''337623'', TO_DATE(''26-02-2013'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100384'', ''108398'', TO_DATE(''01-04-2016'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100401'', ''208655'', TO_DATE(''29-11-2019'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100402'', ''197362'', TO_DATE(''02-12-2010'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100402'', ''208655'', TO_DATE(''07-01-2020'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100402'', ''108398'', TO_DATE(''22-01-2017'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100411'', ''982354'', TO_DATE(''21-07-2015'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100411'', ''108398'', TO_DATE(''21-07-2015'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100411'', ''183476'', TO_DATE(''03-09-2015'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100419'', ''982354'', TO_DATE(''28-07-2015'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100419'', ''108398'', TO_DATE(''15-11-2015'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100419'', ''197362'', TO_DATE(''28-07-2015'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100437'', ''197362'', TO_DATE(''22-02-2013'', ''DD-MM-YYYY''))';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Qualification VALUES (''100437'', ''208655'', TO_DATE(''17-02-2020'', ''DD-MM-YYYY''))';

  DBMS_OUTPUT.PUT_LINE(' ... A3_QUALIFICATION');

  EXECUTE IMMEDIATE 'INSERT INTO A3_Next_of_Kin VALUES (''183476'', ''1'', ''Ruth Simmonds'', ''Mother'', ''05983911182'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Next_of_Kin VALUES (''183476'', ''2'', ''William Simmonds'', ''Father'', ''05739862298'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Next_of_Kin VALUES (''197362'', ''1'', ''Trish Lazlo'', ''Partner'', ''05663927002'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Next_of_Kin VALUES (''208655'', ''1'', ''Luke Govern'', NULL, ''05982002851'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Next_of_Kin VALUES (''208655'', ''2'', ''Matilda Christmas'', ''Mother'', ''05762983023'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Next_of_Kin VALUES (''337623'', ''1'', ''Sarah Winters'', ''Partner'', ''05883542865'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Next_of_Kin VALUES (''337623'', ''2'', ''Leah Masterton'', ''Partner'', ''05101292655'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Next_of_Kin VALUES (''108398'', ''1'', ''Sarah McKensie'', ''Daughter'', ''05662362751'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Next_of_Kin VALUES (''108398'', ''2'', ''Max Zimmer'', ''Uncle'', ''05666285378'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Next_of_Kin VALUES (''982354'', ''1'', ''Angus March'', ''Brother'', ''05672610092'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Next_of_Kin VALUES (''982354'', ''2'', ''Max Zimmer'', ''Partner''''s Uncle'', ''05600836799'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Next_of_Kin VALUES (''763401'', ''1'', ''Greta Dzabo'', ''Wife'', ''05545912037'')';

  DBMS_OUTPUT.PUT_LINE(' ... A3_NEXT_OF_KIN');
  
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000167'', ''100345'', TO_DATE(''30-04-2021 12:00'', ''DD-MM-YYYY HH24:MI''), ''982354'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000168'', ''100345'', TO_DATE(''16-05-2021 11:30'', ''DD-MM-YYYY HH24:MI''), ''982354'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000169'', ''100345'', TO_DATE(''29-05-2021 12:00'', ''DD-MM-YYYY HH24:MI''), ''982354'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000170'', ''100345'', TO_DATE(''01-06-2021 12:30'', ''DD-MM-YYYY HH24:MI''), ''183476'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000171'', ''100345'', TO_DATE(''09-06-2021 11:30'', ''DD-MM-YYYY HH24:MI''), ''982354'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000172'', ''100348'', TO_DATE(''17-06-2021 10:30'', ''DD-MM-YYYY HH24:MI''), ''982354'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000173'', ''100348'', TO_DATE(''29-06-2021 11:00'', ''DD-MM-YYYY HH24:MI''), ''982354'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000174'', ''100356'', TO_DATE(''04-04-2021 17:30'', ''DD-MM-YYYY HH24:MI''), ''763401'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000175'', ''100356'', TO_DATE(''11-04-2021 17:30'', ''DD-MM-YYYY HH24:MI''), ''763401'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000176'', ''100356'', TO_DATE(''17-04-2021 18:00'', ''DD-MM-YYYY HH24:MI''), ''108398'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000177'', ''100356'', TO_DATE(''25-04-2021 18:00'', ''DD-MM-YYYY HH24:MI''), ''108398'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000178'', ''100356'', TO_DATE(''01-05-2021 18:30'', ''DD-MM-YYYY HH24:MI''), ''763401'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000179'', ''100356'', TO_DATE(''10-05-2021 18:30'', ''DD-MM-YYYY HH24:MI''), ''337623'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000180'', ''100356'', TO_DATE(''21-05-2021 18:00'', ''DD-MM-YYYY HH24:MI''), ''337623'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000181'', ''100356'', TO_DATE(''25-05-2021 18:30'', ''DD-MM-YYYY HH24:MI''), ''108398'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000182'', ''100356'', TO_DATE(''11-06-2021 18:00'', ''DD-MM-YYYY HH24:MI''), ''337623'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000183'', ''100356'', TO_DATE(''19-06-2021 17:30'', ''DD-MM-YYYY HH24:MI''), ''763401'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000184'', ''100369'', TO_DATE(''28-05-2021 10:00'', ''DD-MM-YYYY HH24:MI''), ''337623'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000185'', ''100369'', TO_DATE(''17-06-2021 10:00'', ''DD-MM-YYYY HH24:MI''), ''337623'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000186'', ''100369'', TO_DATE(''29-06-2021 10:30'', ''DD-MM-YYYY HH24:MI''), ''302876'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000187'', ''100384'', TO_DATE(''16-04-2021 12:30'', ''DD-MM-YYYY HH24:MI''), ''197362'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000188'', ''100384'', TO_DATE(''16-04-2021 13:30'', ''DD-MM-YYYY HH24:MI''), ''183476'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000189'', ''100384'', TO_DATE(''23-04-2021 12:00'', ''DD-MM-YYYY HH24:MI''), ''337623'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000190'', ''100384'', TO_DATE(''23-04-2021 13:30'', ''DD-MM-YYYY HH24:MI''), ''183476'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000191'', ''100384'', TO_DATE(''16-05-2021 12:30'', ''DD-MM-YYYY HH24:MI''), ''197362'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000192'', ''100384'', TO_DATE(''18-05-2021 12:30'', ''DD-MM-YYYY HH24:MI''), ''108398'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000193'', ''100384'', TO_DATE(''29-05-2021 12:00'', ''DD-MM-YYYY HH24:MI''), ''337623'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000194'', ''100384'', TO_DATE(''18-06-2021 13:30'', ''DD-MM-YYYY HH24:MI''), ''183476'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000195'', ''100402'', TO_DATE(''24-05-2021 13:30'', ''DD-MM-YYYY HH24:MI''), ''108398'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000196'', ''100402'', TO_DATE(''17-06-2021 13:30'', ''DD-MM-YYYY HH24:MI''), ''208655'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000197'', ''100411'', TO_DATE(''29-04-2021 10:30'', ''DD-MM-YYYY HH24:MI''), ''982354'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000198'', ''100411'', TO_DATE(''08-05-2021 14:00'', ''DD-MM-YYYY HH24:MI''), ''183476'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000199'', ''100411'', TO_DATE(''19-05-2021 10:00'', ''DD-MM-YYYY HH24:MI''), ''108398'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000200'', ''100411'', TO_DATE(''21-05-2021 10:00'', ''DD-MM-YYYY HH24:MI''), ''982354'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000201'', ''100411'', TO_DATE(''02-06-2021 14:00'', ''DD-MM-YYYY HH24:MI''), ''108398'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000202'', ''100411'', TO_DATE(''03-06-2021 13:30'', ''DD-MM-YYYY HH24:MI''), ''183476'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000203'', ''100419'', TO_DATE(''30-04-2021 10:30'', ''DD-MM-YYYY HH24:MI''), ''197362'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000204'', ''100419'', TO_DATE(''16-05-2021 11:00'', ''DD-MM-YYYY HH24:MI''), ''183476'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000205'', ''100419'', TO_DATE(''21-05-2021 11:00'', ''DD-MM-YYYY HH24:MI''), ''982354'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000206'', ''100419'', TO_DATE(''07-06-2021 10:00'', ''DD-MM-YYYY HH24:MI''), ''108398'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000207'', ''100437'', TO_DATE(''07-05-2021 11:00'', ''DD-MM-YYYY HH24:MI''), ''208655'')';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Outing VALUES (''21000208'', ''100437'', TO_DATE(''07-06-2021 12:00'', ''DD-MM-YYYY HH24:MI''), ''208655'')';

  DBMS_OUTPUT.PUT_LINE(' ... A3_OUTING');
  
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''03846455'', ''Rebecca Martins'', ''34, Mount Drive, Lindon'', ''07256882974'', NULL )';                                                                                                                                                                                                                         
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''82636780'', ''Thomas Grace'', ''23, High Street, Lindon'', ''06398364024'', NULL )';                                                                                                                                                                                                                             
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''62822277'', ''Craig Legion'', ''8, Mandela Walk, Southlands'', ''06399823840'', 0.20 )';                                                                                                                                                                                                                        
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''08216453'', ''Leon Marvin'', ''The Marches, Teal Avenue, Lindon'', ''02092319845'', NULL )';                                                                                                                                                                                                                 
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''62480190'', ''Satir Kumar'', ''1, Sun Terrace, Tramley'', ''08398659309'', NULL )';                                                                                                                                                                                                                             
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''22672518'', ''Richard Silver'', ''298, Christchurch Lane, Lindon'', ''01433628388'', NULL )';                                                                                                                                                                                                                 
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''93345826'', ''Martha Robbins'', ''74b, Sandley Towers, Sandley'', ''09389863734'', NULL )';                                                                                                                                                                                                                   
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''77673492'', ''Callum Maru'', ''45, Margan Drive, Southlands'', ''04439863925'', 0.10 )';                                                                                                                                                                                                                        
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''19344527'', ''George Strettle'', ''Rose Cottage, Mount Drive, Lindon'', ''03987853853'', NULL )';                                                                                                                                                                                                           
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''63213492'', ''Abe Lance'', ''81, Templemead, Sharpenley'', ''08095680934'', NULL )';                                                                                                                                                                                                                       
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''83838492'', ''Terence Grace'', ''23, High Street, Lindon'', ''02393453590'', 0.15 )';                                                                                                                                                                                                                         
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''61187434'', ''Claire Holmsworthy'', ''11, Brookfield, Tramley'', ''01198345284'', NULL )';                                                                                                                                                                                                                     
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''90023936'', ''Vital Singh'', ''11, Brentway, Sandley'', ''02349856763'', NULL )';                                                                                                                                                                                                                           
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''80234690'', ''Rebecca Neo'', ''2a, Carnfield, Masterton'', ''05283283285'', NULL )';                                                                                                                                                                                                                           
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''52980911'', ''Samuel Leibermann'', ''The Manor, Sandley Lane, Southlands'', ''01198763987'', NULL )';                                                                                                                                                                                                          
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''19091123'', ''John Fellows'', ''18, Whooper Way, Cosset'', ''03434298765'', NULL )';                                                                                                                                                                                                                           
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''48563983'', ''Kevin Kline'', ''43, Sandpit Drive, Lindon'', ''04983984767'',  NULL )';                                                                                                                                                                                                                       
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''83512382'', ''Boris Oslovski'', ''108, High Street, Lindon'', ''0563498458'', NULL )';                                                                                                                                                                                                                         
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''77283918'', ''Ruth Tuttle'', ''7, Clearways, Cosset'', ''04442895661'', NULL )';                                                                                                                                                                                                                                
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''51939202'', ''Able Zimmerman'', ''Flat 4, Helm House, Sharpenley'', ''09820435855'', NULL )';                                                                                                                                                                                                                   
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''20010109'', ''Aaron Fellows'', ''12, Abbey Road, Southlands'', ''07675739566'', 0.10 )';                                                                                                                                                                                                                        
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''31989942'', ''Martin Slater'', ''1, Upper Lane, Lyndham'', ''04390865872'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''10973847'', ''Harry Mannock'', ''79, The Beeches, Masterton'',''06739826198'', 0.10 )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''18055806'', ''Terence Leeman'', ''3, Meadow View, Lindon'',''08234819820'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''29376431'', ''Michael Simmonds'', ''28, Highridge Way, Layburn'',''05238562020'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''59922224'', ''Carrie Genoa'', ''106, Ridgeway, Sharpenley'',''04676287251'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''46352335'', ''Louisa Majors'', ''82c, Crowsfoot Road, Layburn'',''04329185025'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''85923177'', ''Said Amman'', ''29, The Roost, Cosset'',''06726767529'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''34234673'', ''Jill Rivers'', ''4, Coningsby Close, Southlands'',''04781133264'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''54626453'', ''Anthony Gaye'', ''31, Priory Walk, Lyndham'',''045245849'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''21998764'', ''Reece Southern'', ''16, Vicarage Road, Sandlin'',''05672821754'', 0.15 )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''87490252'', ''Claire Wilson'', ''54, The Greenway, Lindon'',''04398271662'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''59149822'', ''Junior Parraman'', ''57, Harper''''s Court, Louthham'',''05423313823'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''25454767'', ''Grace Leeman'', ''96, Nightingale Avenue, Layburn'',''03452865910'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''44093772'', ''Sunil Malik'', ''7, Pickard''''s Rise, Tramley'',''04527867199'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''50098335'', ''John Yang'', ''32, The Vetchfield, Sharpenley'',''04652876194'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''98457453'', ''Mel Dixon'', ''41, Highridge Way, Layburn'',''03562876107'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''74668654'', ''Lia Caron'', ''5, Rooks Road, Southlands'',''04518862843'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''54513755'', ''Una Gilles'', ''17, Swallow Close, Layburn'',''05672534927'', 0.2 )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''28722675'', ''Greta Pearsson'', ''23, The Tryst, Lindon'',''02456817717'', 0.1 )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''78600731'', ''Rex Masters'', ''1, Maynard''''s Drive, Sandley'',''04526611721'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''67600111'', ''Nigel Grey'', ''39, Orchard Way, North Treban'',''05628759824'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''99556287'', ''Leroy Grimes'', ''45, Orchard Way, North Treban'',''04355253951'', 0.1 )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''98778452'', ''Talia Roberts'', ''16, Mount Vernon Heights, Louthham'',''05278182846'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''74665893'', ''Mona Rivers'', ''6, Hexagon Road, South Treban'',''04359892716'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''65639526'', ''Ian Lewis'', ''10b, Simmonds View, Bycester'', ''06458222198'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''34577862'', ''Simona Patel'', ''67, The Sidings, Louthham'',''04632873354'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''22262223'', ''Lily Maynard'', ''White Mansion, Lovers Lane, Makerfield'',''04333873272'', 0.1 )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''16646149'', ''Graham Kennedy'', ''87, Needle Street, Lindon'',''05452374187'', 0.15 )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''77285398'', ''Grace Sunnyside'', ''11, Willow Road, Cornlee'',''0467398217'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''55455816'', ''Larry Maise'', ''99, Balloon Crescent, Southlands'',''05276232971'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''28767076'', ''Monty Cleb'', ''121, Seaview, Lindon'',''04439264756'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''77321838'', ''Gordon Slade'', ''13b, Carnfield, Masterton'',''04545292773'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''67633791'', ''Kelly Reason'', ''78, Heron Road, Layburn'',''03545620302'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''11000023'', ''Sally Merrick'', ''9, Spring Road, Cornlee'',''06295426743'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''65653986'', ''Harry Mann'', ''87, Kilmarnock Road, Makerfield'',''06462347295'', 0.1 )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''06441252'', ''Clive Partman'', ''2, The Guidings, Bycester'',''04447383929'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''03456712'', ''Mary Colleridge'', ''20, Main Street, Louthham'',''05298335718'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''55299358'', ''James Glade'', ''16, Coopers Meadow, South Treban'',''03639827716'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''00461285'', ''Clyde Rusman'', ''10, Brownlee Grange, Sandley'',''05382811759'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''73221802'', ''Jonathon Preece'', ''37, Willow Road, Cornlee'',''05276631836'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''89787960'', ''Mitchell Coogan'', ''45, Whooper Way, Cosset'',''05288163424'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''44388987'', ''Donna Kowalski'', ''11, Legion Crescent, Lyndham'',''04637824474'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''76123223'', ''Liam Grey'', ''71, Field Drive, Sharpenley'',''03342981063'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''99525981'', ''Coren O''''Halloran'', ''3, New Street, Makerfield'',''03648736296'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''34282831'', ''Greg Millward'', ''15, Parsonage Way, North Treban'',''05617638118'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''11083203'', ''Angela Lewis'', ''87, Messenger Street, Lindon'',''05381242253'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''65665656'', ''Jane Lewis'', ''1, Makerfield Road, Lindon'',''04545297182'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''73174562'', ''Claire Grayson'', ''17, The Sidings, Louthham'',''03928871930'', 0.1 )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''04570639'', ''Dillon Cree'', ''21, Upper Lane, Lyndham'',''04637387621'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''77363927'', ''Sally Marr'', ''40, Rippledown, Southlands'',''05738635299'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''01528236'', ''Shay Hernandez'', ''6, St. Giles Road, Layburn'',''04659928274'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''00103108'', ''Chris French'', ''7, Bay Horse Gardens, Cricklade'',''03674628917'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''65634454'', ''Lu Won'', ''5, Deepdown, Cornlee'',''04820381863'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''33901256'', ''Gordon Slade'', ''Old Bakery, The Guidings, Bycester'',''03771927459'', 0.15 )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''67628421'', ''Lec Dombrovski'', ''8, Major Avenue, Makerfield'',''05117311711'', 0.1 )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''11775023'', ''Jurgen Klein'', ''29, Devilliers Terrace, South Treban'',''04873336291'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''59963426'', ''Daniel Caine'', ''104, The Elms, Summeridge'',''02634691962'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''56455662'', ''Patrick t''''Gooi'', ''24, Coopers Meadow, South Treban'',''03528919702'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''39803986'', ''Petr Cillich'', ''3, Coral Way, Layburn'',''04992730026'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''09058443'', ''Mavis Jones'', ''53, Field Drive, Sharpenley'',''04198372098'', 0.2 )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''62211292'', ''Colm Grey'', ''9, Gascony Close, Bycester'',''03638156922'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''11011081'', ''April Summers'', ''5, The Tryst, Lindon'',''06382528562'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''75469393'', ''Gaynor Simmonds'', ''67, Orchard Way, North Treban'',''04837365283'', 0.1 )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''98327435'', ''Stuart Chris'', ''8, Upper Lane, Lyndham'',''04830082911'', 0.1 )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''77987030'', ''Leon Gilbert'', ''82, Nightingale Avenue, Layburn'',''04639211813'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''57443936'', ''Michael Jones'', ''17, Cow Lane, North Treban'',''03852925017'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''22090328'', ''Chip McGrady'', ''41, Western Way, Louthham'',''03726761624'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''10026933'', ''William Port'', ''13, Pickard''''s Rise, Tramley'',''03544583502'', 0.15 )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''50488458'', ''Sadie Blowers'', ''29, Rooks Road, Southlands'',''04989279919'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''65651763'', ''Manesh Kumar'', ''29, Sandpit Drive, Lindon'',''03652846354'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''99243748'', ''Lester Myerscough'', ''Riverview, The Tryst, Lindon'',''04756937117'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''38400031'', ''Percy Walsh'', ''3, Weavers Cottages, North Treban'',''03762876115'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''35656919'', ''Simmien Lagrange'', ''5, Mount Drive, Lindon'',''02867342272'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''33408233'', ''Brian Took'', ''82b, Prestatin Road, Cricklade'',''03672983802'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''80216508'', ''Ludmila Askenaza'', ''27, Devilliers Terrace, South Treban'',''04720183720'', 0.1 )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''77533109'', ''Grant Jaysen'', ''12, The Elms, Summeridge'',''03777293724'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''15439639'', ''Pierre Marsh'', ''14, Upper Lane, Lyndham'',''05639189224'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''06040173'', ''Kate Mayhew'', ''92, Needle Street, Lindon'',''04837283375'', NULL )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Client VALUES ( ''06040172'', ''Garth Mcfadden'', ''17, Windmill Drive, Bycester'',''03773477317'', NULL )';

  DBMS_OUTPUT.PUT_LINE(' ... A3_CLIENT');
  
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000207'', ''77673492'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000207'', ''63213492'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000207'', ''29376431'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000207'', ''59149822'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000207'', ''28722675'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000207'', ''77285398'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000207'', ''44388987'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000207'', ''11775023'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000207'', ''11011081'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000207'', ''22090328'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000207'', ''99243748'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000207'', ''33408233'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000207'', ''15439639'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000208'', ''93345826'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000208'', ''19344527'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000208'', ''48563983'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000208'', ''18055806'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000208'', ''22262223'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000208'', ''00461285'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000208'', ''62211292'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000208'', ''65651763'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000203'', ''83838492'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000203'', ''20010109'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000203'', ''50098335'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000203'', ''16646149'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000203'', ''59963426'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000204'', ''85923177'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000204'', ''87490252'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000204'', ''98457453'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000204'', ''22262223'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000204'', ''34282831'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000204'', ''11011081'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000204'', ''65651763'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000205'', ''08216453'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000205'', ''61187434'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000205'', ''46352335'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000205'', ''54513755'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000205'', ''76123223'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000205'', ''67628421'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000205'', ''35656919'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000205'', ''06040172'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000206'', ''10973847'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000206'', ''59922224'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000206'', ''50098335'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000206'', ''34577862'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000206'', ''74665893'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000197'', ''82636780'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000197'', ''63213492'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000197'', ''46352335'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000197'', ''98457453'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000197'', ''99556287'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000198'', ''59922224'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000198'', ''85923177'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000198'', ''44093772'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000198'', ''28767076'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000198'', ''11083203'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000198'', ''00103108'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000198'', ''11011081'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000199'', ''48563983'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000199'', ''29376431'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000199'', ''78600731'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000199'', ''67600111'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000199'', ''98778452'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000199'', ''73174562'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000199'', ''09058443'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000200'', ''74668654'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000200'', ''16646149'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000200'', ''73221802'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000200'', ''59963426'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000201'', ''03846455'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000201'', ''83512382'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000201'', ''18055806'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000201'', ''44388987'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000201'', ''55455816'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000201'', ''65665656'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000201'', ''62211292'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000201'', ''22090328'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000201'', ''50488458'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000201'', ''99243748'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000201'', ''77533109'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000202'', ''34577862'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000202'', ''00461285'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000195'', ''93345826'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000195'', ''29376431'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000195'', ''21998764'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000195'', ''22262223'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000195'', ''89787960'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000195'', ''99525981'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000195'', ''75469393'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000196'', ''19091123'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000196'', ''20010109'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000196'', ''59922224'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000196'', ''54513755'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000196'', ''06441252'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000196'', ''44388987'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000196'', ''11775023'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000196'', ''80216508'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000187'', ''62822277'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000187'', ''77283918'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000187'', ''21998764'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000187'', ''77285398'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000187'', ''34282831'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000187'', ''99243748'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000188'', ''22672518'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000188'', ''20010109'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000188'', ''29376431'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000188'', ''89787960'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000188'', ''74665893'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000188'', ''76123223'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000189'', ''83512382'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000189'', ''87490252'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000189'', ''99556287'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000189'', ''01528236'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000190'', ''09058443'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000190'', ''34234673'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000190'', ''59963426'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000190'', ''00103108'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000190'', ''35656919'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000191'', ''62480190'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000191'', ''19091123'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000191'', ''51939202'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000191'', ''74668654'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000191'', ''00461285'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000191'', ''50488458'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000192'', ''90023936'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000192'', ''52980911'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000192'', ''16646149'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000192'', ''73174562'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000194'', ''10973847'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000194'', ''44093772'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000194'', ''77321838'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000194'', ''77987030'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000194'', ''80216508'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000184'', ''03846455'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000184'', ''83512382'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000184'', ''29376431'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000184'', ''21998764'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000184'', ''78600731'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000184'', ''55299358'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000184'', ''11083203'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000184'', ''01528236'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000184'', ''59963426'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000184'', ''99243748'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000184'', ''80216508'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000184'', ''77533109'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000185'', ''67633791'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000185'', ''77363927'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000185'', ''33408233'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000186'', ''90023936'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000186'', ''10973847'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000186'', ''28722675'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000186'', ''77321838'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000186'', ''00103108'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000186'', ''11775023'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000186'', ''75469393'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000186'', ''98327435'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000186'', ''57443936'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000186'', ''06040172'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000174'', ''82636780'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000174'', ''08216453'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000174'', ''19344527'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000174'', ''83838492'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000174'', ''54513755'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000174'', ''00461285'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000175'', ''77673492'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000175'', ''51939202'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000175'', ''22262223'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000175'', ''73221802'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000175'', ''11775023'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000175'', ''11011081'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000176'', ''52980911'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000176'', ''59922224'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000176'', ''77321838'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000176'', ''33901256'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000176'', ''77533109'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000177'', ''28722675'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000177'', ''77283918'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000177'', ''44093772'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000177'', ''77285398'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000177'', ''65665656'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000177'', ''98327435'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000177'', ''65651763'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000178'', ''77363927'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000178'', ''55299358'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000179'', ''19091123'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000179'', ''54626453'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000179'', ''50098335'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000179'', ''74665893'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000179'', ''67633791'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000179'', ''59963426'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000180'', ''59149822'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000180'', ''65639526'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000180'', ''99525981'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000181'', ''48563983'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000181'', ''34234673'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000181'', ''98457453'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000181'', ''16646149'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000181'', ''06441252'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000181'', ''89787960'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000181'', ''00103108'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000181'', ''50488458'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000182'', ''62822277'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000182'', ''80234690'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000182'', ''21998764'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000182'', ''99556287'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000182'', ''67628421'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000183'', ''03456712'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000172'', ''61187434'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000172'', ''19091123'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000172'', ''59922224'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000172'', ''48563983'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000172'', ''31989942'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000172'', ''44093772'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000172'', ''67633791'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000172'', ''77987030'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000172'', ''33408233'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000172'', ''06040173'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000173'', ''03846455'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000173'', ''61187434'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000173'', ''46352335'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000173'', ''74668654'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000173'', ''77285398'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000173'', ''89787960'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000173'', ''01528236'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000173'', ''75469393'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000167'', ''83512382'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000167'', ''11083203'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000167'', ''11011081'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000167'', ''80216508'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000167'', ''65639526'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000167'', ''34282831'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000167'', ''62480190'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000168'', ''39803986'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000168'', ''80216508'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000168'', ''73174562'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000168'', ''06040172'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000168'', ''25454767'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000168'', ''00461285'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000168'', ''28767076'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000168'', ''82636780'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000168'', ''99525981'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000169'', ''80216508'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000169'', ''77987030'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000170'', ''11775023'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000170'', ''57443936'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000170'', ''00103108'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000170'', ''65653986'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000170'', ''22262223'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000170'', ''59149822'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000171'', ''83838492'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000171'', ''50098335'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000171'', ''67628421'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000171'', ''54513755'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000171'', ''22090328'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000171'', ''34577862'' )';
  EXECUTE IMMEDIATE 'INSERT INTO A3_Participant VALUES (''21000171'', ''10026933'' )';
  
  DBMS_OUTPUT.PUT_LINE(' ... A3_PARTICIPANT');
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('All tables re-created and populated.');


END;
/
SET SERVEROUTPUT OFF
