library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Dff is
generic (
	BUS_WIDTH : integer
	); 
port (
	D : in std_logic_vector (BUS_WIDTH-1 downto 0);
	load, reset, clk: in std_logic;
	Q: out std_logic_vector (BUS_WIDTH-1 downto 0)
	);
end Dff;

architecture dff_behavior of Dff is
begin
dff_stimulate : process(clk, reset, load)
	begin
	if (reset = '1') then
		Q <= (others => '0');
	elsif (clk'event and clk = '1' and load = '1') then
		Q <= D;
	end if;
end process;

end dff_behavior;
