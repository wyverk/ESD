-------------------------------------------------------------------------
-- Author: Jeanne Christman
-- Aug. 18, 2018
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY lab2 is
  port (
    

    ----- CLOCK -----
    CLOCK_50 : in std_logic;
	 
    ----- SW -----
    SW : in  std_logic_vector(9 downto 0);

    ----- KEY -----
    KEY : in std_logic_vector(3 downto 0); --for reset
	 
	 ----- LED -----
    LEDR : out  std_logic_vector(9 downto 0);  --for heartbeat
	 
	 HEX0: out std_logic_vector(6 DOWNTO 0) --idk, for the display

    
  );
end entity;

architecture rtl of lab2 is
  -- signal declarations
 
  signal reset_n : std_logic;
  signal key0_d1 : std_logic;
  signal key0_d2 : std_logic;
  signal key0_d3 : std_logic;
  signal cntr : std_logic_vector(25 downto 0);
  
  -- nios_system component
	component nios_system is
		port (
			clk_clk            : in  std_logic                    := 'X';             -- clk
			reset_reset_n      : in  std_logic                    := 'X';             -- reset_n
			switches_export    : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			push_button_export : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			hex_export         : out std_logic_vector(6 downto 0)                     -- export
		);
	end component nios_system;
  
  
begin


  
  ----- Syncronize the reset
  synchReset_proc : process (CLOCK_50) begin
    if (rising_edge(CLOCK_50)) then
      key0_d1 <= KEY(0);
      key0_d2 <= key0_d1;
      key0_d3 <= key0_d2;
    end if;
  end process synchReset_proc;
  reset_n <= key0_d3;
  
  --- heartbeat counter --------
  counter_proc : process (CLOCK_50) begin
    if (rising_edge(CLOCK_50)) then
      if (reset_n = '0') then
        cntr <= "00" & x"000000";
      else
        cntr <= cntr + ("00" & x"000001");
      end if;
    end if;
  end process counter_proc;
  
  LEDR(8) <= cntr(24);
  
  --Port map the nios_system
  u0 : component nios_system
		port map (
			clk_clk       => CLOCK_50,       --   clk.clk
			reset_reset_n => reset_n,  -- reset.reset_n
			switches_export => SW(7 DOWNTO 0),
			push_button_export     => "00" & KEY(1) & "0",     --     pbs.export
			hex_export => HEX0(6 downto 0)  -- hex.export
		);
    
end architecture rtl;