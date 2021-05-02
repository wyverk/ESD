LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE filter_pkg IS
	COMPONENT filter IS
	PORT(
		clk: IN STD_LOGIC;
		reset_n: IN STD_LOGIC;
		address: IN STD_LOGIC;
		writedata: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		write: IN STD_LOGIC;
		readdata: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
END PACKAGE;

---------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

LIBRARY work;
USE work.generic_reg_pkg.ALL;
USE work.rising_edge_synchronizer_pkg.ALL;

ENTITY filter IS
	PORT(
		clk: IN STD_LOGIC;
		reset_n: IN STD_LOGIC;
		address: IN STD_LOGIC;
		writedata: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		write: IN STD_LOGIC;
		readdata: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE arch OF filter IS

----------------------------------------------------------------------------
	TYPE STD_ARRAY_17 IS ARRAY(16 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	CONSTANT low_pass : STD_ARRAY_17 := 
	(
		x"0051",
		x"00BA",
		x"01E1",
		x"0408",
		x"071A",
		x"0AAC",
		x"0E11",
		x"107F",
		x"1161",
		x"107F",
		x"0E11",
		x"0AAC",
		x"071A",
		x"0408",
		x"01E1",
		x"00BA",
		x"0051"
	);
	
	CONSTANT high_pass : STD_ARRAY_17 := 
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
    
    CONSTANT delta : STD_ARRAY_17 := (0 => x"7FFF", OTHERS => x"0000");
	
	SIGNAL coefs : STD_ARRAY_17 := delta;
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
	
	SIGNAL reset_edge : STD_LOGIC := '0';
    
    SIGNAl data_reg_0 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    
    SIGNAl data_reg_1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    
BEGIN
	reset_sync: rising_edge_synchronizer
	PORT MAP(
		clk => clk,
		reset => '0',
		input => reset_n,
		edge => reset_edge
	);

	-- data_read: PROCESS(clk, reset_edge)
	-- BEGIN
		-- IF reset_edge = '1' THEN
			-- ram <= (OTHERS => (OTHERS => '0'));
		-- ELSIF rising_edge(clk) THEN
			-- IF write = '1' THEN
				-- ram(to_integer(UNSIGNED(addr_vector))) <= writedata;
			-- END IF;
		-- END IF;
	-- END PROCESS;
	
     -- addr_vector <= '0' & address;
     -- RamBlock : PROCESS(clk)
     -- BEGIN
        -- IF (clk'event AND clk = '1') THEN
            -- IF (reset_edge = '1') THEN
                -- read_addr <= (OTHERS => '0');
            -- ELSIF (write = '1') THEN
                -- IF address = '1' THEN
                    -- RAM(1) <= writedata;
                -- END IF;
            -- END IF;
            -- read_addr <= addr_vector;
        -- END IF;
     -- END PROCESS RamBlock;
     
    -- switch: PROCESS(RAM(1))
    -- BEGIN
        -- IF RAM(1) = x"0000" THEN
            -- coefs <= (0 => x"7FFF", OTHERS => x"0000");
        -- ELSIF RAM(1) = x"0001" THEN
            -- coefs <= high_pass;
        -- ELSE
            -- coefs <= (0 => x"7FFF", OTHERS => x"0000");
        -- END IF;
    -- END PROCESS;
    
    
--    switch: PROCESS(clk, reset_edge)
--    BEGIN
--        IF reset_edge = '1' THEN
--            coefs <= (OTHERS => (OTHERS => '0'));
--        ELSIF rising_edge(clk) THEN
--            IF address = '1' THEN
--                IF writedata(0) = '0' THEN
--                    coefs <= low_pass;
--                ELSIF writedata(0) = '1' THEN
--                    coefs <= high_pass;
--                ELSE
--                    coefs <= (OTHERS => (OTHERS => '0'));
--                END IF;
--				ELSE
--					 
--            END IF;
--        END IF;
--    END PROCESS;
--	 
--	ram(0) <= writedata WHEN address = '0' ELSE (OTHERS => '0');

    -- switch: PROCESS(RAM(1), reset_edge)
    -- BEGIN
        -- IF reset_edge = '1' THEN
            -- coefs <= (0 => x"7FFF", OTHERS => x"0000");
        -- ELSE
            -- --IF write = '1' THEN
                -- --IF address = '1' THEN
                    -- IF RAM(1) = x"0000" THEN
                        -- coefs <= low_pass;
                    -- ELSIF RAM(1) = x"0001" THEN
                        -- coefs <= high_pass;
                    -- ELSE
                        -- coefs <= (0 => x"7FFF", OTHERS => x"0000");
                    -- END IF;
                -- --END IF;
            -- --END IF;
        -- END IF;
    -- END PROCESS;


    RamBlock : PROCESS(clk, reset_edge)
    BEGIN
        IF (reset_edge = '1') THEN
            data_reg_0 <= (OTHERS => '0');
				data_reg_1 <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
           IF (write = '1') THEN
                IF address = '0' THEN
                    data_reg_0 <= writedata;
                ELSE
                    data_reg_1 <= writedata;
                END IF;
           END IF;
        END IF;
    END PROCESS RamBlock;
    
    switch: PROCESS(reset_edge, data_reg_1)
    BEGIN
        IF reset_edge = '1' THEN
            coefs <= delta;
        ELSE
            IF data_reg_1 = x"0000" THEN
                coefs <= low_pass;
            ELSIF data_reg_1 = x"0101" THEN
                coefs <= high_pass;
            ELSE
                coefs <= delta;
            END IF;
        END IF;
    END PROCESS;
    
    
	Reg_GEN:
	for i in 0 to 15 GENERATE
		lsb: if i = 0 GENERATE
			U0: generic_reg
			GENERIC MAP( bit_width => 16)
			PORT MAP(
				clk => clk,
				reset => reset_edge,
				enable => write,
				input => data_reg_0,
				output => reg_data(0)
			);
		END GENERATE lsb;
		
		upper: if i > 0 GENERATE
			Ux: generic_reg
			GENERIC MAP( bit_width => 16)
			PORT MAP(
				clk => clk,
				reset => reset_edge,
				enable => write,
				input => reg_data(i-1),
				output => reg_data(i)
			);
		END GENERATE upper;
	END GENERATE;
	
	mul_gen:
	for i IN 0 TO 16 GENERATE	
		lsb: if i = 0 GENERATE
			U0: multiply
			PORT MAP(
				dataa => data_reg_0,
				datab => coefs(0),
				result => after_mul_32(0)
		   );
		after_mul(0) <= SIGNED(after_mul_32(0)(30 DOWNTO 15));
		END GENERATE lsb;
		
		upper: if i > 0 GENERATE
			ux: multiply
			PORT MAP(
				dataa => reg_data(i-1),
				datab => coefs(i),
				result => after_mul_32(i)
			);
		after_mul(i) <= after_mul(i-1) + SIGNED(after_mul_32(i)(30 DOWNTO 15));
		END GENERATE upper;
		

	END GENERATE;
	
    readdata <= STD_LOGIC_VECTOR(after_mul(16));

	
END ARCHITECTURE;
	