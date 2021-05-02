LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

library work;
USE work.servo_controller_pkg.ALL;

ENTITY servo_controller_tb IS

END ENTITY;

ARCHITECTURE test OF servo_controller_tb IS
	SIGNAL clk, reset_n, write, address : STD_LOGIC;
	SIGNAL writedata : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL out_wave_export : STD_LOGIC;
	SIGNAL irq : STD_LOGIC;
	
	CONSTANT period : TIME := 20 ns;
	SIGNAL stop : BOOLEAN := FALSE;
	
BEGIN
	clk <= NOT clk AFTER period/2 WHEN(stop = FALSE) ELSE clk;
	
	UUT: servo_controller
	PORT MAP(
		clk => clk,
		reset_n => reset_n,
		write => write,
		address => address,
		writedata => writedata,
		out_wave_export => out_wave_export,
		irq => irq
	);
	
	
	stimlulus: PROCESS
	BEGIN
		reset_n <= '0';
		wait for 40 ns;
		reset_n <= '1';
		
		write <= '1';
		address <= '0';
		writedata <= STD_LOGIC_VECTOR(to_unsigned(5, 32));
		wait for 40 ns;
		
		address <= '1';
		writedata <= STD_LOGIC_VECTOR(to_unsigned(15, 32));
		wait for 40 ns;
		
		wait for 1 ms;
		stop <= true;
		wait;
	END PROCESS;

END ARCHITECTURE;
		
	