library ieee;
use ieee.std_logic_1164.all;
use work.pooling_2d_package.all;

entity demux1to2 is
port (
	data : in std_logic_vector (INPUT_ADDR_WIDTH-1 downto 0);
	sel : in std_logic;
	output0 : out std_logic_vector (INPUT_ADDR_WIDTH-1 downto 0);
	output1 : out std_logic_vector (INPUT_ADDR_WIDTH-1 downto 0)
);
end entity;

architecture demux_behavior of demux1to2 is
begin
	output0 <= data when sel = '0' else (others => 'Z');
	output1 <= data when sel = '1' else (others => 'Z');
end demux_behavior;
