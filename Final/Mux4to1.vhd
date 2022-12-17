library ieee;
use ieee.std_logic_1164.all;
use work.pooling_2d_package.all;

entity mux4to1 is
port (
	a, b, c, d : in std_logic_vector (DATA_WIDTH-1 downto 0);
	sel : in std_logic_vector (1 downto 0);
	output : out std_logic_vector (DATA_WIDTH-1 downto 0)
);
end entity;

architecture mux_behavior of mux4to1 is
begin
	with sel select output <= a when "00",
				  b when "01",
				  c when "10",
				  d when others;
end mux_behavior;
