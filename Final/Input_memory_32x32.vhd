library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.pooling_2d_package.all;
use std.textio.all;
use ieee.std_logic_unsigned.all;


entity input_memory_32x32 is -- Input Memory
port (
	clk : in std_logic; -- clock
	reset : in std_logic; -- Reset input
	addr : in std_logic_vector (INPUT_ADDR_WIDTH-1 downto 0); -- Address

	ren : in std_logic; -- Read Enable
	data_out : out std_logic_vector (DATA_WIDTH-1 downto 0)  -- Output data
	);
end input_memory_32x32;

architecture input_memory_arch of input_memory_32x32 is

	--type data_array is array (integer range <>) of std_logic_vector (DATA_WIDTH-1 downto 0); -- Memory Type
	signal input_mem : data_array(0 to (2**INPUT_ADDR_WIDTH)-1) := (others => (others => '0'));  -- Memory model

	--test input data
	constant test_data : data_array(0 to (2**10)-1) := (
	x"ff",	x"ff",	x"ff",	x"ff",	x"ff",	x"ff",	x"ff",	x"c4",	x"c4",	x"c4",	x"c4",	x"85",	x"85",	x"85",	x"85",	x"85",	x"53",	x"53",	x"5d",	x"2b",	x"2b",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",
	x"ff",	x"ff",	x"ff",	x"c4",	x"c4",	x"c4",	x"c4",	x"c4",	x"85",	x"a4",	x"85",	x"85",	x"85",	x"85",	x"85",	x"53",	x"53",	x"5d",	x"ff",	x"5d",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"43",	x"13",	x"13",
	x"ff",	x"ff",	x"c4",	x"c4",	x"c4",	x"85",	x"85",	x"85",	x"a4",	x"ff",	x"a4",	x"85",	x"53",	x"53",	x"53",	x"53",	x"53",	x"2b",	x"5d",	x"2b",	x"13",	x"13",	x"13",	x"13",	x"13",	x"43",	x"13",	x"13",	x"43",	x"ff",	x"43",	x"13",
	x"ff",	x"ff",	x"c4",	x"85",	x"85",	x"85",	x"85",	x"85",	x"53",	x"83",	x"53",	x"53",	x"83",	x"53",	x"53",	x"53",	x"2b",	x"2b",	x"2b",	x"13",	x"13",	x"13",	x"13",	x"13",	x"43",	x"ff",	x"43",	x"13",	x"13",	x"43",	x"13",	x"13",
	x"ff",	x"c4",	x"c4",	x"85",	x"85",	x"53",	x"83",	x"53",	x"53",	x"53",	x"53",	x"83",	x"ff",	x"83",	x"53",	x"2b",	x"2b",	x"2b",	x"2b",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"43",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",
	x"ff",	x"c4",	x"85",	x"85",	x"a4",	x"83",	x"ff",	x"83",	x"53",	x"53",	x"53",	x"53",	x"83",	x"2b",	x"2b",	x"2b",	x"2b",	x"5d",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",
	x"ff",	x"c4",	x"85",	x"a4",	x"ff",	x"83",	x"83",	x"53",	x"53",	x"53",	x"2b",	x"2b",	x"2b",	x"2b",	x"2b",	x"2b",	x"5d",	x"ff",	x"43",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"43",	x"13",	x"13",
	x"c4",	x"c4",	x"85",	x"85",	x"83",	x"53",	x"53",	x"53",	x"2b",	x"2b",	x"2b",	x"2b",	x"2b",	x"2b",	x"2b",	x"2b",	x"13",	x"43",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"43",	x"ff",	x"43",	x"13",
	x"c4",	x"85",	x"85",	x"53",	x"53",	x"53",	x"53",	x"2b",	x"2b",	x"2b",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"2b",	x"2b",	x"2b",	x"2b",	x"5d",	x"13",	x"13",	x"43",	x"13",	x"13",
	x"c4",	x"85",	x"a4",	x"53",	x"53",	x"53",	x"2b",	x"2b",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"2b",	x"2b",	x"2b",	x"2b",	x"2b",	x"2b",	x"5d",	x"ff",	x"5d",	x"2b",	x"13",	x"13",	x"13",
	x"c4",	x"a4",	x"ff",	x"83",	x"53",	x"53",	x"5d",	x"2b",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"2b",	x"2b",	x"2b",	x"5d",	x"2b",	x"53",	x"53",	x"53",	x"53",	x"83",	x"2b",	x"2b",	x"5d",	x"2b",	x"13",
	x"c4",	x"c4",	x"a4",	x"53",	x"53",	x"53",	x"ff",	x"5d",	x"13",	x"13",	x"13",	x"13",	x"43",	x"13",	x"13",	x"13",	x"13",	x"2b",	x"2b",	x"5d",	x"ff",	x"83",	x"53",	x"53",	x"53",	x"53",	x"53",	x"53",	x"5d",	x"ff",	x"5d",	x"2b",
	x"ff",	x"c4",	x"85",	x"53",	x"83",	x"53",	x"5d",	x"2b",	x"13",	x"13",	x"13",	x"43",	x"ff",	x"43",	x"13",	x"13",	x"2b",	x"2b",	x"2b",	x"2b",	x"83",	x"53",	x"53",	x"85",	x"85",	x"85",	x"85",	x"53",	x"53",	x"5d",	x"2b",	x"2b",
	x"ff",	x"c4",	x"85",	x"83",	x"ff",	x"83",	x"2b",	x"2b",	x"13",	x"13",	x"13",	x"13",	x"43",	x"13",	x"13",	x"13",	x"2b",	x"2b",	x"2b",	x"53",	x"53",	x"53",	x"85",	x"85",	x"c4",	x"c4",	x"85",	x"85",	x"53",	x"53",	x"53",	x"2b",
	x"ff",	x"c4",	x"85",	x"53",	x"83",	x"53",	x"2b",	x"2b",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"2b",	x"2b",	x"53",	x"83",	x"53",	x"85",	x"85",	x"c4",	x"ff",	x"ff",	x"c4",	x"85",	x"85",	x"53",	x"53",	x"53",
	x"ff",	x"c4",	x"85",	x"85",	x"53",	x"53",	x"53",	x"2b",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"43",	x"13",	x"2b",	x"2b",	x"5d",	x"ff",	x"83",	x"85",	x"85",	x"c4",	x"c4",	x"c4",	x"c4",	x"c4",	x"85",	x"85",	x"53",	x"53",
	x"ff",	x"ff",	x"c4",	x"85",	x"85",	x"53",	x"53",	x"2b",	x"2b",	x"13",	x"13",	x"13",	x"13",	x"43",	x"ff",	x"43",	x"2b",	x"2b",	x"2b",	x"5d",	x"53",	x"53",	x"85",	x"85",	x"85",	x"85",	x"85",	x"c4",	x"85",	x"85",	x"85",	x"53",
	x"c4",	x"ff",	x"ff",	x"c4",	x"85",	x"53",	x"53",	x"53",	x"2b",	x"2b",	x"13",	x"13",	x"13",	x"13",	x"43",	x"13",	x"2b",	x"2b",	x"2b",	x"2b",	x"2b",	x"53",	x"53",	x"53",	x"53",	x"a4",	x"85",	x"85",	x"85",	x"ff",	x"85",	x"85",
	x"85",	x"c4",	x"ff",	x"c4",	x"85",	x"85",	x"83",	x"53",	x"2b",	x"2b",	x"2b",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"2b",	x"2b",	x"2b",	x"2b",	x"2b",	x"2b",	x"53",	x"83",	x"ff",	x"a4",	x"85",	x"85",	x"c4",	x"c4",	x"85",
	x"85",	x"85",	x"c4",	x"a4",	x"85",	x"85",	x"ff",	x"83",	x"2b",	x"2b",	x"2b",	x"2b",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"2b",	x"5d",	x"2b",	x"2b",	x"2b",	x"2b",	x"83",	x"53",	x"53",	x"85",	x"85",	x"c4",	x"c4",
	x"83",	x"85",	x"a4",	x"ff",	x"a4",	x"85",	x"85",	x"53",	x"83",	x"2b",	x"2b",	x"2b",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"ff",	x"13",	x"2b",	x"2b",	x"2b",	x"2b",	x"53",	x"53",	x"53",	x"85",	x"c4",	x"ff",
	x"ff",	x"83",	x"85",	x"a4",	x"85",	x"85",	x"85",	x"83",	x"ff",	x"5d",	x"2b",	x"2b",	x"2b",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"2b",	x"2b",	x"2b",	x"53",	x"83",	x"85",	x"85",	x"c4",
	x"5d",	x"53",	x"53",	x"53",	x"85",	x"85",	x"53",	x"53",	x"83",	x"53",	x"2b",	x"2b",	x"2b",	x"13",	x"32",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"2b",	x"2b",	x"5d",	x"83",	x"ff",	x"a4",	x"85",	x"c4",
	x"2b",	x"2b",	x"2b",	x"53",	x"53",	x"53",	x"53",	x"53",	x"53",	x"2b",	x"2b",	x"2b",	x"2b",	x"32",	x"ff",	x"32",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"5d",	x"ff",	x"53",	x"83",	x"85",	x"85",	x"c4",
	x"2b",	x"2b",	x"43",	x"2b",	x"2b",	x"53",	x"53",	x"53",	x"2b",	x"2b",	x"2b",	x"2b",	x"13",	x"32",	x"ff",	x"32",	x"13",	x"13",	x"13",	x"13",	x"13",	x"43",	x"13",	x"13",	x"43",	x"2b",	x"5d",	x"2b",	x"53",	x"85",	x"85",	x"c4",
	x"13",	x"43",	x"ff",	x"43",	x"2b",	x"2b",	x"2b",	x"2b",	x"2b",	x"2b",	x"2b",	x"13",	x"32",	x"ff",	x"ff",	x"ff",	x"32",	x"13",	x"13",	x"13",	x"43",	x"ff",	x"43",	x"43",	x"ff",	x"2b",	x"2b",	x"2b",	x"53",	x"85",	x"a4",	x"c4",
	x"13",	x"13",	x"43",	x"13",	x"13",	x"13",	x"2b",	x"2b",	x"2b",	x"2b",	x"2b",	x"13",	x"13",	x"32",	x"ff",	x"32",	x"13",	x"13",	x"13",	x"13",	x"13",	x"43",	x"13",	x"13",	x"43",	x"2b",	x"2b",	x"2b",	x"53",	x"a4",	x"ff",	x"c4",
	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"32",	x"ff",	x"32",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"43",	x"13",	x"13",	x"2b",	x"2b",	x"83",	x"53",	x"85",	x"a4",	x"c4",
	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"32",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"43",	x"ff",	x"43",	x"2b",	x"2b",	x"83",	x"ff",	x"a4",	x"85",	x"85",	x"c4",
	x"13",	x"13",	x"43",	x"13",	x"13",	x"13",	x"13",	x"13",	x"43",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"43",	x"2b",	x"2b",	x"53",	x"53",	x"a4",	x"85",	x"85",	x"c4",	x"ff",
	x"13",	x"43",	x"ff",	x"43",	x"13",	x"13",	x"13",	x"43",	x"ff",	x"43",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"ff",	x"13",	x"13",	x"13",	x"2b",	x"2b",	x"53",	x"83",	x"85",	x"85",	x"85",	x"c4",	x"ff",	x"ff",
	x"13",	x"13",	x"43",	x"13",	x"13",	x"13",	x"13",	x"13",	x"43",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"13",	x"2b",	x"2b",	x"2b",	x"53",	x"83",	x"ff",	x"a4",	x"85",	x"c4",	x"c4",	x"ff",	x"ff"
);

begin

--  Read data process
Read_Proc : process (reset, clk)
	begin 
	if reset = '1' then
		data_out <= (others => '0');
		input_mem <= test_data; -- initialize program memory
	elsif (clk'event and clk = '1') then
		if ren = '1' then
			data_out <= input_mem(conv_integer(addr));
		else
			data_out <= (others => 'Z');
		end if;
	end if;
	end process Read_Proc;
    
end input_memory_arch;
