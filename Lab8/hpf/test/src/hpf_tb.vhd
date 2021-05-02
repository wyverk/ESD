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
USE std.textio.ALL;

-- include your packages here
LIBRARY work;
USE work.hpf_pkg.ALL;


ENTITY hpf_tb IS

END ENTITY hpf_tb;

-------------------------------------------------------------------------------

ARCHITECTURE test OF hpf_tb IS
    SIGNAL clk, reset_n, filter_en : STD_LOGIC := '0';
    SIGNAL data_in, data_out : SIGNED(15 DOWNTO 0) := (OTHERS => '0');
    CONSTANT period : TIME := 20 ns;
    SIGNAL stop : BOOLEAN := false;
    
    TYPE SIGNED_ARRAY_40 IS ARRAY(39 DOWNTO 0) OF SIGNED(15 DOWNTO 0);
    SIGNAL audioSampleArray : SIGNED_ARRAY_40 := (OTHERS => (OTHERS => '0'));
BEGIN  -- test


    ---------------------------------------------------------------------------
    -- instantiate the unit under test (UUT)
    ---------------------------------------------------------------------------
    UUT : hpf
    PORT MAP (
        clk => clk,
        reset_n => reset_n,
        data_in => data_in,
        filter_en => filter_en,
        data_out => data_out
    );

    clk <= NOT clk AFTER period/2 WHEN (NOT stop) ElSE clk;
    ---------------------------------------------------------------------------
    -- the process will apply the test vectors to the UUT
    ---------------------------------------------------------------------------
    stimulus : process is
        --file read_file : text open read_mode is "./src/verification_src/one_cycle_integer.csv";
        file read_file : text open read_mode is "one_cycle_200_8k.csv";
        file results_file : text open write_mode is "output_waveform.csv";
        variable lineIn : line;
        variable lineOut : line;
        variable readValue : integer;
        variable writeValue : integer;
    begin
        reset_n <= '0';
        wait for 100 ns;
        reset_n <= '1';
        
        -- Read data from file into an array
        for i in 0 to 39 loop
            readline(read_file, lineIn);
            read(lineIn, readValue);
            audioSampleArray(i) <= to_signed(readValue, 16);
            wait for 2*period;
        end loop;
        file_close(read_file);
    
        -- Apply the test data and put the result into an output file
        for i in 1 to 10 loop
            for j in 0 to 39 loop
                
                -- Your code here...
                -- Read the data from the array and apply it to Data_In
                -- Remember to provide an enable pulse with each new sample
                data_in <= audioSampleArray(j);
                filter_en <= '1';
                wait for period;
                filter_en <= '0';
            
                -- Write filter output to file
                writeValue := to_integer(data_out);
                write(lineOut, writeValue);
                writeline(results_file, lineOut);
            
                wait for period;
                -- Your code here...
    
            end loop;
        end loop;
        file_close(results_file);
	stop <= true;
        -- end simulation
        wait for 100 ns;
        -- last wait statement needs to be here to prevent the process
        -- sequence from restarting at the beginning
        
        wait;
    end process stimulus;

END ARCHITECTURE test;

-------------------------------------------------------------------------------
