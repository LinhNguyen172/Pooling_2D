library ieee;
use ieee.std_logic_1164.all;

entity tri_state_buffer is
generic (
	BUS_WIDTH : integer
);
port (
	input : in std_logic_vector (BUS_WIDTH-1 downto 0);
	enable : in std_logic;
	output : out std_logic_vector (BUS_WIDTH-1 downto 0)
);
end entity;

architecture tri_state_buffer_behavior of tri_state_buffer is
begin
	output <= input when enable = '1' else (others => 'Z');
	
end tri_state_buffer_behavior;
