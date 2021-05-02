LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

PACKAGE raminfr_be_pkg IS
    COMPONENT raminfr_be IS
         PORT(
            clk : IN std_logic;
            reset_n : IN std_logic;
            write_n : IN std_logic_vector(3 DOWNTO 0);
            address : IN std_logic_vector(11 DOWNTO 0);
            writedata : IN std_logic_vector(31 DOWNTO 0);
            --
            readdata : OUT std_logic_vector(31 DOWNTO 0)
         );
    END COMPONENT;
END PACKAGE;



-----------------------------------------------------------------------
--- your header goes here
-----------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY raminfr_be IS
 PORT(
 clk : IN std_logic;
 reset_n : IN std_logic;
 write_n : IN std_logic_vector(3 DOWNTO 0);
 address : IN std_logic_vector(11 DOWNTO 0);
 writedata : IN std_logic_vector(31 DOWNTO 0);
 --
 readdata : OUT std_logic_vector(31 DOWNTO 0)
 );
END ENTITY raminfr_be;


ARCHITECTURE rtl OF raminfr_be IS

 TYPE ram_type IS ARRAY (4095 DOWNTO 0) OF std_logic_vector (7 DOWNTO 0);
 SIGNAL RAM_3 : ram_type := (OTHERS => (OTHERS => '0'));
 SIGNAL RAM_2 : ram_type := (OTHERS => (OTHERS => '0'));
 SIGNAL RAM_1 : ram_type := (OTHERS => (OTHERS => '0'));
 SIGNAL RAM_0 : ram_type := (OTHERS => (OTHERS => '0'));
 SIGNAL read_addr : std_logic_vector(11 DOWNTO 0);

BEGIN
 RamBlock : PROCESS(clk)
 BEGIN
    IF reset_n = '0' THEN
        read_addr <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN
        IF write_n(3) = '0' THEN
            RAM_3(conv_integer(address)) <= writedata(31 DOWNTO 24);
        END IF;
        
        IF write_n(2) = '0' THEN
            RAM_2(conv_integer(address)) <= writedata(23 DOWNTO 16);
        END IF;
        
        IF write_n(1) = '0' THEN
            RAM_1(conv_integer(address)) <= writedata(15 DOWNTO 8);
        END IF;
        
        IF write_n(0) = '0' THEN
            RAM_0(conv_integer(address)) <= writedata(7 DOWNTO 0);
        END IF;
        
        read_addr <= address;
    END IF;
 END PROCESS RamBlock;

 readdata <= RAM_3(conv_integer(read_addr)) & RAM_2(conv_integer(read_addr)) & RAM_1(conv_integer(read_addr)) & RAM_0(conv_integer(read_addr));

END ARCHITECTURE rtl;