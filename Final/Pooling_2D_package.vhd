library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

package Pooling_2D_package is

	-- constant declarations

	constant DATA_WIDTH : integer := 8; -- Data Width
	constant INPUT_ADDR_WIDTH : integer := 10;  -- Address Width (2^10 = 32*32)
	constant OUTPUT_ADDR_WIDTH : integer := 8;  -- Address Width (2^8 = 16*16)
	constant SUM_WIDTH : integer := 10; -- Accelerator Width

	-- type declarations

	-- memory type
	type data_array is array (integer range <>) of std_logic_vector (DATA_WIDTH-1 downto 0);

	-- state type
	type state_type is (s_reset, s_start, s_loop_i, s_reset_j, s_loop_j, s_reset_k, 
			s_loop_k, s_read, s_sum, s_write, s_group, s_line, s_done, s_end);

-----------------------------------
	-- components

-- Input memory
component Input_memory_32x32
port (
	clk : in std_logic; -- clock
	reset : in std_logic; -- Reset input
	addr : in std_logic_vector (INPUT_ADDR_WIDTH-1 downto 0); -- Address

	ren : in std_logic; -- Read Enable
	data_out : out std_logic_vector (DATA_WIDTH-1 downto 0)  -- Output data
	);
end component;

-- Output memory
component Output_memory_16x16
port (
	clk : in std_logic; -- clock
	addr : in std_logic_vector (OUTPUT_ADDR_WIDTH-1 downto 0); -- Address

	wen : in std_logic; -- Read Enable
	data_in : in std_logic_vector (DATA_WIDTH-1 downto 0)  -- input data
	);
end component;

component Pooling_2D_unit
port (
	clk ,start, reset : in std_logic;
	done ,WEn ,REn : out std_logic;
	WAddr : out std_logic_vector (OUTPUT_ADDR_WIDTH-1 downto 0);
	RAddr : out std_logic_vector (INPUT_ADDR_WIDTH-1 downto 0);
	Data_in : in std_logic_vector (DATA_WIDTH-1 downto 0);
	Data_out : out std_logic_vector (DATA_WIDTH-1 downto 0);
	current_state : out state_type
);
end component;

--Controller
component Controller
port (
	clk ,start, reset : in std_logic;
	done : out std_logic;

	-- i counter
	i_reset, i_enable : out std_logic;
	i_overflow : in std_logic;

	-- j counter
	j_reset, j_enable : out std_logic;
	j_overflow : in std_logic;

	-- k counter
	k_reset, k_enable : out std_logic;
	k_overflow : in std_logic;

	-- waddr counter
	waddr_reset, waddr_enable : out std_logic;
	WEn : out std_logic;

	-- dataflow selection
	addr_sel : out std_logic;
	jump_sel : out std_logic_vector (1 downto 0);

	-- raddr_root
	root_reset, root_load : out std_logic;

	-- raddr
	raddr_output : out std_logic;
	REn : out std_logic;
	
	-- Data in
	data_input : out std_logic;

	-- Data out
	sum_reset, sum_load, mean_output : out std_logic;

	current_state : out state_type
);
end component;

-- Datapath
component Datapath
port (
	clk : in std_logic;

	-- i counter
	i_reset, i_enable : in std_logic;
	i_overflow : out std_logic;

	-- j counter
	j_reset, j_enable : in std_logic;
	j_overflow : out std_logic;

	-- k counter
	k_reset, k_enable : in std_logic;
	k_overflow : out std_logic;

	-- waddr counter
	waddr_reset, waddr_enable : in std_logic;
	WAddr : out std_logic_vector (OUTPUT_ADDR_WIDTH-1 downto 0);

	-- dataflow selection
	addr_sel : in std_logic;
	jump_sel : in std_logic_vector (1 downto 0);

	-- raddr_root
	root_reset, root_load : in std_logic;

	-- raddr
	raddr_output : in std_logic;
	RAddr : out std_logic_vector (INPUT_ADDR_WIDTH-1 downto 0);
	
	-- Data in
	data_input : in std_logic;
	Data_in : in std_logic_vector (DATA_WIDTH-1 downto 0);

	-- Data out
	sum_reset, sum_load, mean_output : in std_logic;
	Data_out : out std_logic_vector (DATA_WIDTH-1 downto 0)
);
end component;

-- dff for data
component Dff
generic (
	BUS_WIDTH : integer
	); 
port (
	D : in std_logic_vector (BUS_WIDTH-1 downto 0);
	load, reset, clk: in std_logic;
	Q: out std_logic_vector (BUS_WIDTH-1 downto 0)
	);
end component;

-- full adder
component Full_adder
port (
	a, b: in std_logic;
	cin: in std_logic;
	cout: out std_logic;
	sum: out std_logic
	);
end component;

-- Adder for data
component Adder
port (
	data_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
	acc : in std_logic_vector(SUM_WIDTH-1 downto 0);
	sum : out std_logic_vector(SUM_WIDTH-1 downto 0)
	);
end component;

-- Tri-state
component tri_state_buffer
generic (
	BUS_WIDTH : integer
);
port (
	input : in std_logic_vector (BUS_WIDTH-1 downto 0);
	enable : in std_logic;
	output : out std_logic_vector (BUS_WIDTH-1 downto 0)
);
end component;

-- Counter
component Counter
generic (
	COUNTER_WIDTH : integer
	); 
port (
	enable, reset, clk : in std_logic;
	overflow : out std_logic;
	count : out std_logic_vector (COUNTER_WIDTH-1 downto 0)
	);
end component;

-- Mux
component Mux4to1
port (
	a, b, c, d : in std_logic_vector (DATA_WIDTH-1 downto 0);
	sel : in std_logic_vector (1 downto 0);
	output : out std_logic_vector (DATA_WIDTH-1 downto 0)
);
end component;

-- Demux
component DeMux1to2
port (
	data : in std_logic_vector (INPUT_ADDR_WIDTH-1 downto 0);
	sel : in std_logic;
	output0 : out std_logic_vector (INPUT_ADDR_WIDTH-1 downto 0);
	output1 : out std_logic_vector (INPUT_ADDR_WIDTH-1 downto 0)
);
end component;

end Pooling_2D_package;


package body Pooling_2D_package is

end package body Pooling_2D_package;
