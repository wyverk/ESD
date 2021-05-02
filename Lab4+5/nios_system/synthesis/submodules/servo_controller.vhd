--       LAB NAME:  LAB $4$
--
--      FILE NAME:  servo_controller.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--      idk it's supposed to be a file thing for the custom IP that I still
--      don't know why we need. might or might not work. at least there are
--      no errors
--      
--      
--      
--      
--      
--
--
--  REVISION HISTORY
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 02/23/18 | QHN  | 1.0 | 
-- |          |      |     |
--
--*****************************************************************************
--*****************************************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

Package servo_controller_pkg IS
	COMPONENT servo_controller IS
		  PORT(
					clk        : IN std_logic;          -- 50 Mhz system clock
					reset_n    : IN std_logic;          -- active low system reset
					write      : IN std_logic;          -- active high write enable
					address    : IN std_logic;  --address of register to be written to (from CPU)
					writedata : IN std_logic_vector(31 DOWNTO 0);  --data from the CPU to be stored in the component
					--
					out_wave_export : OUT std_logic;
					irq             : OUT std_logic
				);
	END COMPONENT;
END PACKAGE;






LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY servo_controller IS
  PORT(
    clk        : IN std_logic;          -- 50 Mhz system clock
    reset_n    : IN std_logic;          -- active low system reset
    write      : IN std_logic;          -- active high write enable
    address    : IN std_logic;  --address of register to be written to (from CPU)
    writedata : IN std_logic_vector(31 DOWNTO 0);  --data from the CPU to be stored in the component
    --
    out_wave_export : OUT std_logic;
    irq             : OUT std_logic
    );
END ENTITY servo_controller;

ARCHITECTURE rtl OF servo_controller IS
    TYPE state_type IS (SW_RIGHT, INT_RIGHT, SW_LEFT, INT_LEFT);
    SIGNAL current_state : state_type := SW_LEFT;
    SIGNAL next_state : state_type;
    
    
    TYPE ram_type IS ARRAY (1 DOWNTO 0) OF INTEGER;
    SIGNAL reg : ram_type := (49999, 99999);
    
    CONSTANT step : INTEGER := 1000;
    CONSTANT endCount : INTEGER := 999999;
    SIGNAL maxAngleCount : INTEGER := 99999;
    SIGNAL minAngleCount : INTEGER := 49999;
    SIGNAL currCount : INTEGER := 0;
    SIGNAL angleCount: INTEGER := 49999;
    
    SIGNAL out_wave : std_logic;
BEGIN
    out_wave_export <= out_wave;
    
    counter: PROCESS(clk, reset_n)
    BEGIN
        IF (reset_n = '0') THEN
            currCount <= 0;
        ELSIF (rising_edge(clk)) THEN
            currCount <= currCount + 1;
            
            IF (currCount >= endCount) THEN
                currCount <= 0;
            END IF;
        END IF;
    END PROCESS;
    
    
    PROCESS(clk, reset_n)
    BEGIN
        IF (reset_n = '0') THEN
            current_state <= SW_LEFT;
        ELSIF (rising_edge(clk)) THEN
            current_state <= next_state;
        END IF;
    END PROCESS;
    
    fsm: PROCESS(clk, reset_n)
    BEGIN
        IF (reset_n = '0') THEN
            next_state <= SW_LEFT;
        ELSIF(rising_edge(clk)) THEN
            case current_state IS
                WHEN SW_LEFT =>
                    IF angleCount >= maxAngleCount THEN
                        next_state <= INT_LEFT;
                    END IF;
                WHEN INT_LEFT =>
                    next_state <= SW_RIGHT;
                WHEN SW_RIGHT =>
                    IF angleCount <= minAngleCount THEN
                        next_state <= INT_RIGHT;
                    END IF;
                WHEN INT_RIGHT =>
                    next_state <= SW_LEFT;
            END CASE;
        END IF;
    END PROCESS;
    
    
    wave: PROCESS(clk, reset_n)
    BEGIN
        IF (reset_n = '0') THEN
            out_wave <= '0';
        ELSIF(rising_edge(clk)) THEN
            case current_state IS
                WHEN SW_LEFT =>
                    IF currCount >= angleCount THEN
                        out_wave <= '0';
                    ELSE
                        out_wave <= '1';
                    END IF;
                WHEN INT_LEFT =>
                
                WHEN SW_RIGHT =>
                    IF currCount >= angleCount THEN
                        out_wave <= '0';
                    ELSE
                        out_wave <= '1';
                    END IF;
                WHEN INT_RIGHT =>
                
            END CASE;
        END IF;
    END PROCESS;
    
    
    angle: PROCESS(clk, reset_n)
    BEGIN
        IF (reset_n = '0') THEN
            angleCount <= minAngleCount;
        ELSIF(rising_edge(clk)) THEN
            case current_state IS
                WHEN SW_LEFT =>
                    IF currCount >= endCount THEN
                        angleCount <= angleCount + step;
                    END IF;
                WHEN INT_LEFT =>
                    angleCount <= maxAngleCount;
                WHEN SW_RIGHT =>
                    IF currCount >= endCount THEN
                        angleCount <= angleCount - step;
                    END IF;
                WHEN INT_RIGHT =>
                    angleCount <= minAngleCount;
            END CASE;
        END IF;
    END PROCESS;
    
    
    interrupt: PROCESS(clk, reset_n)
    BEGIN
        IF (reset_n = '0') THEN
            irq <= '0';
        ELSIF(rising_edge(clk)) THEN
            case current_state IS
                WHEN SW_LEFT =>
                    irq <= '0';
                WHEN INT_LEFT =>
                    irq <= '1';
                WHEN SW_RIGHT =>
                    irq <= '0';
                WHEN INT_RIGHT =>
                    irq <= '1';
            END CASE;
        END IF;
    END PROCESS;
    
    --reg(to_integer(unsigned'("0"))) <= 49999;
    
    load: PROCESS(clk, reset_n)
    BEGIN
        IF (reset_n = '0') THEN
            reg <= (OTHERS => 0);
        ELSIF (rising_edge(clk)) THEN
            IF (write = '1') THEN
                reg(to_integer(unsigned'('0' & address))) <= to_integer(unsigned(writedata));
            ELSE
                minAngleCount <= reg(0);
                maxAngleCount <= reg(1);
            END IF;
        END IF;
    END PROCESS;
    

END ARCHITECTURE rtl;         
