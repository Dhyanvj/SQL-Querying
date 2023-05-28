INSERT INTO a3_guide (guide_no, family_name, given_name, address, dob, date_joined, supervisor)
VALUES ( '135790', 'Patel', 'Dhyan Nilesh', '555 Stacy Road, Allen Court, Heerts', TO_DATE('12/12/2000', 'DD/MM/YYYY'), TO_DATE('12/12/2018', 'DD/MM/YYYY'), NULL);



INSERT INTO a3_tour (tour_id, tour_name, duration, cost)
VALUES ( '100300', 'Taste of Asia', '6', '100.00');



INSERT INTO a3_location (location_id, name, type, description)
VALUES ( '11135790', 'Machu Picchu', 'Historic', 'Cultural center for the Inca civilization');
INSERT INTO a3_location (location_id, name, type, description)
VALUES ( '11133550', 'The Pyramids at Giza', 'Historic', '3000 years old Pyramids');
INSERT INTO a3_location (location_id, name, type, description)
VALUES ( '11144660', 'The Parthenon', 'Historic', 'Ancient temple to Athena');
INSERT INTO a3_location (location_id, name, type, description)
VALUES ( '11155770', 'Taj Mahal', 'Cultural', 'Home of Mughal emperor Shah Jahan');
INSERT INTO a3_location (location_id, name, type, description)
VALUES ( '11199880', 'British Museum', 'Historic', 'Public institution dedicated to human history');



INSERT INTO a3_qualification (tour, guide, date_passed)
VALUES ( '100300', '135790', TO_DATE('11/11/2017', 'DD/MM/YYYY'));



INSERT INTO a3_outing (outing_id, tour_id, outing_start, guide)
VALUES ( '21000209', '100300', TO_DATE('11-08-2021 12:00', 'DD-MM-YYYY HH24:MI'), '135790');


