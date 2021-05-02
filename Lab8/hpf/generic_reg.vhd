--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*****************************************************************************
--
--  DESIGNER NAME:  Quan Nguyen
--
--       LAB NAME:  Lab 8 <8 bit CPU??>
--
--      FILE NAME:  generic_reg.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    A register for n-bit wide signals, enable-signaled
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
-- | 10/29/20 | XXX  | 1.1 | Internet-less, typhoon edition
-- |          |      |     |
--
--*****************************************************************************
--*****************************************************************************

------------------------------------------------------------------------------
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- ||||                                                                   ||||
-- ||||                    COMPONENT PACKAGE                              ||||
-- ||||                                                                   ||||
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE generic_reg_pkg IS
  COMPONENT generic_reg IS
    GENERIC( bit_width : INTEGER := 4);
    PORT (
        clk    : IN  std_logic;
        reset  : IN  std_logic;
        enable : IN STD_LOGIC;
        input : IN STD_LOGIC_VECTOR(bit_width-1 DOWNTO 0);
        output: OUT STD_LOGIC_VECTOR(bit_width-1 DOWNTO 0)
    );
  END COMPONENT;
END PACKAGE;



------------------------------------------------------------------------------
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- |||| 
-- |||| COMPONENT DESCRIPTION 
-- |||| 
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


ENTITY generic_reg  IS
  GENERIC( bit_width : INTEGER := 4);
  PORT (
    clk    : IN  std_logic;
    reset  : IN  std_logic;
    enable : IN STD_LOGIC;
    input : IN STD_LOGIC_VECTOR(bit_width-1 DOWNTO 0);
    output: OUT STD_LOGIC_VECTOR(bit_width-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch OF generic_reg IS
BEGIN
    PROCESS(clk, reset)
    BEGIN
        IF reset = '1' THEN
            output <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF(enable = '1') THEN
                output <= input;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;