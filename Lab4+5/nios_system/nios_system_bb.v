
module nios_system (
	clk_clk,
	hex0_export,
	hex1_export,
	hex2_export,
	hex3_export,
	hex4_export,
	hex5_export,
	keys_export,
	out_wave_out_wave,
	reset_reset_n,
	switches_export);	

	input		clk_clk;
	output	[6:0]	hex0_export;
	output	[6:0]	hex1_export;
	output	[6:0]	hex2_export;
	output	[6:0]	hex3_export;
	output	[6:0]	hex4_export;
	output	[6:0]	hex5_export;
	input	[3:0]	keys_export;
	output		out_wave_out_wave;
	input		reset_reset_n;
	input	[7:0]	switches_export;
endmodule
