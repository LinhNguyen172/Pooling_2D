library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.pooling_2d_package.all;
use std.textio.all;
use ieee.std_logic_unsigned.all;


entity output_memory_16x16 is -- Output Memory
port (
	clk : in std_logic; -- clock
	addr : in std_logic_vector (OUTPUT_ADDR_WIDTH-1 downto 0); -- Address to write

	wen : in std_logic; -- Read Enable
	data_in : in std_logic_vector (DATA_WIDTH-1 downto 0)  -- data to write
	);
end output_memory_16x16;

architecture output_memory_arch of output_memory_16x16 is

	--type data_array is array (integer range <>) of std_logic_vector (DATA_WIDTH-1 downto 0); -- Memory Type
	signal output_mem : data_array(0 to (2**OUTPUT_ADDR_WIDTH)-1) := (others => (others => '0'));  -- Memory model

begin

--  Write data process
Write_Proc : process (clk)

	begin 
	if (clk'event and clk = '1') then
		if wen = '1' then
			output_mem(conv_integer(addr)) <= data_in;
		end if;
	end if;
	end process Write_Proc;
    
end output_memory_arch;
