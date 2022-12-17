library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.Pooling_2D_package.all;

entity Counter_tb is
end entity;

architecture behavior of Counter_tb is

constant time_period : time := 10 ns;

signal clk : std_logic := '0';

signal enable, reset, overflow : std_logic;
signal count : std_logic_vector (4 downto 0);

begin

	clk <= not clk after time_period/2;

DUT : Counter generic map (5) port map (enable, reset, clk, overflow, count);

DUT_proc : process
	begin
	enable <= '0';
	reset <= '1';
	wait for time_period;
	reset <= '0';
	wait for time_period;
	enable <= '1';
	wait until overflow = '1';
	wait for time_period;
	end process;

end behavior;
