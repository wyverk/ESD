--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*****************************************************************************
--
--  DESIGNER NAME:  Quan Nguyen
--
--       LAB NAME:  Lab 1 CPET 343	
--
--      FILE NAME:  template_tb.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    This design will <insert detailed description of design>. 
--
--
-------------------------------------------------------------------------------
--
--  REVISION HISTORY
--
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 08/23/20 | XXX  | 1.0 | Created
-- |          |      |     |
--
--*****************************************************************************
--*****************************************************************************
-------------------------------------------------------------------------------

-- include ieee packages here
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- include your packages here
LIBRARY work;
USE work.raminfr_be_pkg.ALL;


ENTITY template_tb IS

END ENTITY template_tb;

-------------------------------------------------------------------------------

ARCHITECTURE test OF template_tb IS
	SIGNAL clk : STD_LOGIC  := '0';
    SIGNAL reset_n : STD_LOGIC;
    SIGNAL write_n : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL address : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL writedata : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL readdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --SIGNAL mask : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    CONSTANT period : TIME := 20 ns;
    SIGNAL stop : BOOLEAN := false;
BEGIN  -- test


    ---------------------------------------------------------------------------
    -- instantiate the unit under test (UUT)
    ---------------------------------------------------------------------------
    UUT : raminfr_be
    PORT MAP (
        clk => clk,
        reset_n => reset_n,
        write_n => write_n,
        address => address,
        writedata => writedata,
        --
        readdata => readdata
    );

    clk <= NOT clk AFTER period/2 WHEN(stop = FALSE) ELSE clk;
    ---------------------------------------------------------------------------
    -- the process will apply the test vectors to the UUT
    ---------------------------------------------------------------------------
    stimulus : PROCESS
        VARIABLE mask : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    BEGIN  -- PROCESS stimulus
        reset_n <= '0';
        wait for period*2;
        reset_n <= '1';
        
        -- address <= (OTHERS => '0');
        -- write_n <= "1110";
        -- writedata <= x"00000078";
        -- wait for period*2;
        
        
        -- ASSERT(readdata = x"00000078")
            -- REPORT "byte 0 incorrect"
            -- SEVERITY WARNING;
        
        -- wait for period*2;
        
        -- address <= (OTHERS => '0');
        -- write_n <= "1101";
        -- writedata <= x"00005600";
        -- wait for period*2;
        
        -- ASSERT(readdata = x"00005678")
            -- REPORT "byte 1 incorrect"
            -- SEVERITY WARNING;
        
        -- wait for period*2;
        
        
        -- address <= x"001";
        -- write_n <= "0011";
        -- writedata <= x"12345678";
        -- wait for period*2;
        
        -- ASSERT(readdata = x"12340000")
            -- REPORT "byte 3 & 2 incorrect"
            -- SEVERITY WARNING;
        
        -- wait for period*2;

        -- address <= x"00F";
        -- write_n <= "0000";
        -- writedata <= x"AAAAAAAA";
        -- wait for period*2;
        
        -- ASSERT(readdata = x"AAAAAAAA")
            -- REPORT "they're just fucked mate"
            -- SEVERITY WARNING;
        
        -- wait for period*2;
        
        writedata <= x"12345678";
        for i in 0 to 4095 loop
            
            --wait for period;
            address <= STD_LOGIC_VECTOR(to_unsigned(i,12));
            --wait for period;
            write_n <= STD_LOGIC_VECTOR(to_unsigned(i MOD 16, 4));
            --wait for period; 
            IF write_n(3) = '0' THEN
                mask(31 DOWNTO 24) := x"12";
            END IF;
            
            IF write_n(2) = '0' THEN
                mask(23 DOWNTO 16) := x"34";
            END IF;
            
            IF write_n(1) = '0' THEN
                mask(15 DOWNTO 8) := x"56";
            END IF;
            
            IF write_n(0) = '0' THEN
                mask(7 DOWNTO 0) := x"78";
            END IF;
            
            --wait for 9*period;
            
            
                       
            --wait for period*9;
            --wait for 1 ns;

            ASSERT(readdata = mask)
                REPORT "Data at " & integer'image(to_integer(unsigned(address))) & " is wrong"
                SEVERITY WARNING;
      

            --wait for 18*period;
            mask := (OTHERS => '0');
	    wait for period*2;
        END LOOP;
        -----------------------------------------------------------------------
        -- stop simulation, wait here forever
        -----------------------------------------------------------------------
        stop <= true;
        wait;
    END PROCESS stimulus;

END ARCHITECTURE test;

-------------------------------------------------------------------------------

