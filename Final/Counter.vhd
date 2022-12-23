library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Counter is
generic (
	COUNTER_WIDTH : integer
	); 
port (
	enable, reset, clk : in std_logic;
	overflow : out std_logic;
	count : out std_logic_vector (COUNTER_WIDTH-1 downto 0)
	);
end Counter;

architecture counter_behavior of Counter is

signal pre_count : std_logic_vector (COUNTER_WIDTH downto 0);

begin

counter_stimulate : process(reset, clk)
	begin
	if (reset = '1') then
		pre_count <= (others => '0');
	elsif (clk'event and clk = '1' and enable = '1') then
		pre_count <= pre_count + 1;
	end if;

	-- Counter output
	count <= pre_count(COUNTER_WIDTH-1 downto 0);
	-- overflow bit is MSB
	overflow <= pre_count(COUNTER_WIDTH);

end process;

end counter_behavior;