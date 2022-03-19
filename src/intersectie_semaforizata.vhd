LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
ENTITY SEMAFOR IS
	PORT (
		CLOCK : IN std_logic;
		RESET : IN std_logic;
		TEST_MODE : IN std_logic; 
		--frecventa maxima 
		FV_MAX_DEPASITA : IN std_logic;
		--semafoare masini
		red1 : OUT std_logic;
		yellow1 : OUT std_logic;
		green1 : OUT std_logic;

		red2 : OUT std_logic;
		yellow2 : OUT std_logic;
		green2 : OUT std_logic;

		red3 : OUT std_logic;
		yellow3 : OUT std_logic;
		green3 : OUT std_logic;

		red4 : OUT std_logic;
		yellow4 : OUT std_logic;
		green4 : OUT std_logic;

		red5 : OUT std_logic;
		yellow5 : OUT std_logic;
		green5 : OUT std_logic;

		red6 : OUT std_logic;
		yellow6 : OUT std_logic;
		green6 : OUT std_logic;

		red7 : OUT std_logic;
		yellow7 : OUT std_logic;
		green7 : OUT std_logic;

		red8 : OUT std_logic;
		yellow8 : OUT std_logic;
		green8 : OUT std_logic;

		red9 : OUT std_logic;
		yellow9 : OUT std_logic;
		green9 : OUT std_logic;

		red10 : OUT std_logic;
		yellow10 : OUT std_logic;
		green10 : OUT std_logic;
		--semafoare pietoni
		red_1 : OUT std_logic;
		green_1 : OUT std_logic;

		red_2 : OUT std_logic;
		green_2 : OUT std_logic;

		red_3 : OUT std_logic;
		green_3 : OUT std_logic
	);
END ENTITY SEMAFOR;

ARCHITECTURE SEMAFOR OF SEMAFOR IS

	TYPE state_type IS (ST1, ST2, ST3, ST4, ST5, ST6, ST7, ST8);
	SIGNAL state : state_type := ST1;
	SIGNAL count : INTEGER := 0;
	SIGNAL lights : std_logic_vector(35 DOWNTO 0);
	SIGNAL check1 : INTEGER := 0;
	SIGNAL check2 : INTEGER := 0;
	SIGNAL SENZOR3,SENZOR4,SENZOR5,SENZOR6,SENZOR7: INTEGER ;
 
BEGIN
	STARE_LIGHTS : PROCESS (state, lights)
	BEGIN
		-- 01= verde; 10= rosu; semafoare pietoni
		-- 001 =verde; 010=galben; 100=rosu; semafoare masini

		CASE state IS
			WHEN ST1 => lights <= "100100001100001001001100100100101010";
			WHEN ST2 => lights <= "100100010010010010010100100100101010";
			WHEN ST3 => lights <= "100100100001100001100100100100011001";
			WHEN ST4 => lights <= "100010100010100010100100010010101010";
			WHEN ST5 => lights <= "100100100100100100100100100001100110";
			WHEN ST6 => lights <= "010010100100100100100010010010101010";
			WHEN ST7 => lights <= "100100100100100100100001100100101010";
			WHEN ST8 => lights <= "010100010100010010010010100100101010";
			WHEN OTHERS => lights <= lights;
		END CASE;

	END PROCESS STARE_LIGHTS;

	STARE_TIMP_SENZORI : PROCESS (CLOCK, FV_MAX_DEPASITA, RESET, TEST_MODE) 
 
	BEGIN	 
		--FV_MAX e 1 daca a fost depasita fv pe benzile de pe orizontala ,0 daca nu a fost depasita
		IF(FV_MAX_DEPASITA ='1' AND TEST_MODE = '0') THEN   
			SENZOR3	<= 1;
			SENZOR4 <= 1;
			SENZOR5	<= 1;
			SENZOR6	<= 1;
			SENZOR7	<= 1;  
		ELSIF (FV_MAX_DEPASITA ='0' AND TEST_MODE = '0') THEN    
		    SENZOR3	<= 0;
			SENZOR4 <= 0;
			SENZOR5	<= 0;
			SENZOR6	<= 0;
			SENZOR7	<= 0;	
			--pentru regimul de test am atribuit senzorului 4 valoarea 1
		ELSE 	  
			SENZOR3	<= 0;
			SENZOR4 <= 1;
			SENZOR5	<= 0;
			SENZOR6	<= 0;
			SENZOR7	<= 0;
			
		END IF;
		--functionarea in regimul normal 
		--15 sec pentru verde 
		--3 sec pentru galben 	
			
		IF(RESET='1') THEN 	state <= ST1; count<=0;
		ELSIF (TEST_MODE = '0' AND CLOCK = '1' AND CLOCK'EVENT) THEN
			CASE count IS

				WHEN 0 => 
					state <= ST1;
					count <= count + 1;

				WHEN 15 => 
					IF (SENZOR3 = 1 AND check1 = 0) THEN
						check1 <= 1;
						count <= count - 15;
						state <= ST1;
					ELSIF (SENZOR5 =1  AND check1 = 0) THEN
						check1 <= 1;
						count <= count - 15;
						state <= ST1;
					ELSIF (SENZOR6 = 1 AND check1 = 0) THEN
						check1 <= 1;
						count <= count - 15;
						state <= ST1;
					ELSIF (SENZOR7 = 1 AND check1 = 0) THEN
						check1 <= 1;
						count <= count - 15;
						state <= ST1;
					ELSE
						state <= ST2;
						count <= count + 1;
					END IF;

				WHEN 18 => 
					state <= ST3;
					count <= count + 1;

				WHEN 33 => 
					IF (SENZOR4 = 1 AND check2 = 0) THEN
						check2 <= 1;			 --analog se procedeaza de fiecare data
						count <= count - 15;	 --scad 15 pentru a relua contorul din starea de dinainte ,
						state <= ST3;            --iar check1 ia valoarea 1 ca sa stim ca timpul pentru culoarea verde a fost dublu	
						   
						
					ELSIF (SENZOR6 = 1 AND check2 = 0) THEN
						check2 <= 1;
						count <= count - 15;
						state <= ST3;
					ELSE
						state <= ST4;
						count <= count + 1;
					END IF;

				WHEN 36 => 
					state <= ST5;
					count <= count + 1;

				WHEN 51 => 
					state <= ST6;
					count <= count + 1;

				WHEN 54 => 
					state <= ST7;
					count <= count + 1;

				WHEN 69 => 
					state <= ST8;
					count <= count + 1;

				WHEN 72 => 
					count <= 0;

				WHEN OTHERS => count <= count + 1;
			END CASE; 
 	    --functionarea cu valori predefinite in regimul test
		 ELSIF (TEST_MODE = '1' AND CLOCK = '1' AND CLOCK'EVENT) THEN
		
		 CASE count IS
				WHEN 0 => 
					state <= ST1;
					count <= count + 1;

				WHEN 15 => 
					IF (SENZOR3 = 1 AND check1 = 0) THEN
						check1 <= 1;
						count <= count - 15;
						state <= ST1;
					ELSIF (SENZOR5 = 1 AND check1 = 0) THEN
						check1 <= 1;
						count <= count - 15;
						state <= ST1;
					ELSIF (SENZOR6 = 1 AND check1 = 0) THEN
						check1 <= 1;
						count <= count - 15;
						state <= ST1;
					ELSIF (SENZOR7 = 1 AND check1 = 0) THEN
						check1 <= 1;
						count <= count - 15;
						state <= ST1;
					ELSE   	
						state <= ST2;
						count <= count + 1;
					END IF;

				WHEN 18 => 
					state <= ST3;
					count <= count + 1;

				WHEN 33 => 
					IF (SENZOR4 = 1 AND check2 = 0) THEN
						check2 <= 1;
						count <= count - 15;
						state <= ST3;
					ELSIF (SENZOR6 = 1 AND check2 = 0) THEN
						check2 <= 1;
						count <= count - 15;
						state <= ST3;  
					ELSE  
						 state <= ST4;
						 count <= count + 1	 ;
					END IF;

				WHEN 36 => 
					state <= ST5;
					count <= count + 1;

				WHEN 51 => 
					state <= ST6;
					count <= count + 1;

				WHEN 54 => 
					state <= ST7;
					count <= count + 1;

				WHEN 69 => 
					state <= ST8;
					count <= count + 1;

				WHEN 72 => 
					count <= 0;

				WHEN OTHERS => count <= count + 1;
			END CASE; 
		
		END IF;	
		--atribuirea valoriilor pentru culoriile semafoarelor
		green_3 <= lights(0);
		red_3 <= lights(1);

		green_2 <= lights(2);
		red_2 <= lights(3);

		green_1 <= lights(4);
		red_1 <= lights(5);

		red10 <= lights(8);
		yellow10 <= lights(7);
		green10 <= lights(6);

		red9 <= lights(11);
		yellow9 <= lights(10);
		green9 <= lights(9);

		red8 <= lights(14);
		yellow8 <= lights(13);
		green8 <= lights(12);

		red7 <= lights(17);
		yellow7 <= lights(16);
		green7 <= lights(15);

		red6 <= lights(20);
		yellow6 <= lights(19);
		green6 <= lights(18);

		red5 <= lights(23);
		yellow5 <= lights(22);
		green5 <= lights(21);

		red4 <= lights(26);
		yellow4 <= lights(25);
		green4 <= lights(24);

		red3 <= lights(29);
		yellow3 <= lights(28);
		green3 <= lights(27);

		red2 <= lights(32);
		yellow2 <= lights(31);
		green2 <= lights(30);

		red1 <= lights(35);
		yellow1 <= lights(34);
		green1 <= lights(33);
 
	END PROCESS STARE_TIMP_SENZORI;
	
END ARCHITECTURE SEMAFOR;