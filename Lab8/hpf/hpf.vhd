LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE hpf_pkg IS
	COMPONENT hpf IS
		PORT(
			clk: IN STD_LOGIC;
			reset_n: IN STD_LOGIC;
			data_in: IN SIGNED(15 DOWNTO 0);
			filter_en: IN STD_LOGIC;
			data_out: OUT SIGNED(15 DOWNTO 0)
		);
	END COMPONENT;
END PACKAGE;

---------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.generic_reg_pkg.ALL;
USE work.rising_edge_synchronizer_pkg.ALL;

ENTITY hpf IS
	PORT(
		clk: IN STD_LOGIC;
		reset_n: IN STD_LOGIC;
		data_in: IN SIGNED(15 DOWNTO 0);
		filter_en: IN STD_LOGIC;
		data_out: OUT SIGNED(15 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE arch OF hpf IS

----------------------------------------------------------------------------
	TYPE STD_ARRAY_17 IS ARRAY(16 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	CONSTANT coefs : STD_ARRAY_17 := 
	(
		x"003E",
		x"FF9A",
		x"FE9E",
		x"0000",
		x"0536",
		x"05B2",
		x"F5AC",
		x"DAB7",
		x"4C92",
		x"DAB7",
		x"F5AC",
		x"05B2",
		x"0536",
		x"0000",
		x"FE9E",
		x"FF9A",
		x"003E"
	);
	
----------------------------------------------------------------------------	
	
	TYPE STD_ARRAY IS ARRAY(15 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL reg_data : STD_ARRAY := (OTHERS => (OTHERS => '0'));
----------------------------------------------------------------------------
	TYPE SIGNED_ARRAY_17 IS ARRAY(16 DOWNTO 0) OF SIGNED(15 DOWNTO 0);
	
	SIGNAL after_mul : SIGNED_ARRAY_17 := (OTHERS => (OTHERS => '0'));
	
----------------------------------------------------------------------------
	
	TYPE STD_ARRAY_FULL IS ARRAY(16 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	SIGNAL after_mul_32 : STD_ARRAY_FULL := (OTHERS => (OTHERS => '0'));
	
	
----------------------------------------------------------------------------

	COMPONENT multiply IS
		PORT
		(
			dataa		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			datab		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT;
	
----------------------------------------------------------------------------	
	
	
	SIGNAL reset_edge, filter_edge : STD_LOGIC := '0';
	
	SIGNAL temp_sum : SIGNED(15 DOWNTO 0) := (OTHERS => '0');
BEGIN
	reset_sync: rising_edge_synchronizer
	PORT MAP(
		clk => clk,
		reset => '0',
		input => reset_n,
		edge => reset_edge
	);
	
	filter_sync: rising_edge_synchronizer
	PORT MAP(
		clk => clk,
		reset => reset_edge,
		input => filter_en,
		edge => filter_edge
	);
	
	filt_GEN:
	for i in 0 to 15 GENERATE
		lsb: if i = 0 GENERATE
			reg0: generic_reg
			GENERIC MAP( bit_width => 16)
			PORT MAP(
				clk => clk,
				reset => reset_edge,
				enable => filter_edge,
				input => STD_LOGIC_VECTOR(data_in),
				output => reg_data(0)
			);
			
			
			mul0: multiply
			PORT MAP(
				dataa => STD_LOGIC_VECTOR(data_in),
				datab => coefs(0),
				result => after_mul_32(0)
			);
			
			
			after_mul(0) <= SIGNED(after_mul_32(0)(30 DOWNTO 15));
		END GENERATE lsb;
		
		upper: if i > 0 GENERATE
			regx: generic_reg
			GENERIC MAP( bit_width => 16)
			PORT MAP(
				clk => clk,
				reset => reset_edge,
				enable => filter_edge,
				input => reg_data(i-1),
				output => reg_data(i)
			);
			
			mulx: multiply
			PORT MAP(
				dataa => reg_data(i-1),
				datab => coefs(i),
				result => after_mul_32(i)
			);
			
			
			after_mul(i) <= after_mul(i-1) + SIGNED(after_mul_32(i)(30 DOWNTO 15));
		
		END GENERATE upper;
	END GENERATE;
	
	mul16: multiply
	PORT MAP(
		dataa => reg_data(15),
		datab => coefs(16),
		result => after_mul_32(16)
	);
	
	after_mul(16) <= after_mul(15) + SIGNED(after_mul_32(16)(30 DOWNTO 15));
	
--	mul_gen:
--	for i IN 0 TO 16 GENERATE	
--		lsb: if i = 0 GENERATE
--			U0: multiply
--			PORT MAP(
--				dataa => STD_LOGIC_VECTOR(data_in),
--				datab => coefs(0),
--				result => after_mul_32(0)
--		   );
--		after_mul(0) <= SIGNED(after_mul_32(0)(30 DOWNTO 15));
--		END GENERATE lsb;
--		
--		upper: if i > 0 GENERATE
--			ux: multiply
--			PORT MAP(
--				dataa => reg_data(i-1),
--				datab => coefs(i),
--				result => after_mul_32(i)
--			);
--		after_mul(i) <= after_mul(i-1) + SIGNED(after_mul_32(i)(30 DOWNTO 15));
--		--temp_sum <= temp_sum + SIGNED(after_mul_32(i)(30 DOWNTO 15));
--		END GENERATE upper;
--		
--		--temp_sum <= temp_sum + SIGNED(after_mul_32(i)(30 DOWNTO 15));
--		--after_mul(i) <= after_mul_32(i)(30 DOWNTO 15);
--	END GENERATE;
	
	
	data_out <= after_mul(16);
--	add: PROCESS(clk)
--		VARIABLE temp_sum : SIGNED(15 DOWNTO 0) := (OTHERS => '0');
--	BEGIN
--		IF rising_edge(clk) THEN
--			temp_sum := SIGNED(after_mul(0));
--			
--			for i in 1 to 16 LOOP
--				temp_sum := temp_sum + SIGNED(after_mul(i));
--			end loop;
--		END IF;
--		
--		data_out <= temp_sum;
--	END PROCESS;
	
END ARCHITECTURE;
	