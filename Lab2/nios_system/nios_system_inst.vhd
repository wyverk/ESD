	component nios_system is
		port (
			clk_clk            : in  std_logic                    := 'X';             -- clk
			reset_reset_n      : in  std_logic                    := 'X';             -- reset_n
			switches_export    : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			push_button_export : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			hex_export         : out std_logic_vector(6 downto 0)                     -- export
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk            => CONNECTED_TO_clk_clk,            --         clk.clk
			reset_reset_n      => CONNECTED_TO_reset_reset_n,      --       reset.reset_n
			switches_export    => CONNECTED_TO_switches_export,    --    switches.export
			push_button_export => CONNECTED_TO_push_button_export, -- push_button.export
			hex_export         => CONNECTED_TO_hex_export          --         hex.export
		);

