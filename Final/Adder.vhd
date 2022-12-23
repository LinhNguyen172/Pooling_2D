library ieee;
use ieee.std_logic_1164.all;
use work.pooling_2d_package.all;

entity Adder is
port (
	data_in : in std_logic_vector(DATA_WIDTH-1 downto 0); -- data from memory
	acc : in std_logic_vector(SUM_WIDTH-1 downto 0); -- accellerator
	sum : out std_logic_vector(SUM_WIDTH-1 downto 0)
	);
end Adder;

architecture adder_architecture of Adder is

signal c : std_logic_vector(SUM_WIDTH downto 0) := (OTHERS => '0');
signal data : std_logic_vector(SUM_WIDTH-1 downto 0);

begin
	-- Data complement
	data <= b"00" & data_in;

G: for i in 0 TO SUM_WIDTH-1 generate
	FAi : Full_adder port map (data(i),acc(i),c(i),c(i+1),sum(i));
	end generate;

end adder_architecture;
