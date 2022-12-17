library ieee;
use ieee.std_logic_1164.all;
use work.pooling_2d_package.all;

entity test is
end entity;

architecture behavior of test is

constant time_period : time := 10 ns;

signal clk : std_logic := '0';
signal reset, start, done, WEn, REn : std_logic;
signal RAddr : std_logic_vector (INPUT_ADDR_WIDTH-1 downto 0);
signal WAddr : std_logic_vector (OUTPUT_ADDR_WIDTH-1 downto 0);
signal Data_in, Data_out : std_logic_vector (DATA_WIDTH-1 downto 0);
signal current_state : state_type;


begin

	clk <= not clk after time_period/2;

Pool2D_u : Pooling_2D_unit port map (clk, start, reset, done, WEn, REn, WAddr, RAddr, Data_in, Data_out, current_state);

Mem_out_u : Output_memory_16x16 port map (clk, WAddr, WEn, Data_out);

Mem_in_u : Input_memory_32x32 port map (clk, reset, RAddr, REn, Data_in);

DUT_proc : process
	begin
	start <= '1';
	reset <= '1';
	wait for time_period;
	reset <= '0';
	wait for time_period;
	wait until done = '1';
	wait for time_period*10;
	start <= '0';
	wait for time_period*4;
	end process;

end behavior;
