library ieee;
use ieee.std_logic_1164.all;
use work.pooling_2d_package.all;

entity Datapath is
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
	sum_reset, sum_load , mean_output : in std_logic;
	Data_out : out std_logic_vector (DATA_WIDTH-1 downto 0)
);
end entity;

architecture datapath_structure of Datapath is

signal i_count, j_count : std_logic_vector (3 downto 0);
signal k_count : std_logic_vector (1 downto 0);
signal waddr_overflow : std_logic;
signal offset, raddr_operand, data_operand, mean: std_logic_vector (DATA_WIDTH-1 downto 0);
signal root, addr_sum : std_logic_vector (INPUT_ADDR_WIDTH-1 downto 0);
signal data_sum, accelerator_sum : std_logic_vector (SUM_WIDTH-1 downto 0);

begin
	-- i counter
i_counter : Counter generic map (4) port map (i_enable, i_reset, clk, i_overflow, i_count);

	-- j counter
j_counter : Counter generic map (4) port map (j_enable, j_reset, clk, j_overflow, j_count);

	-- k counter
k_counter : Counter generic map (2) port map (k_enable, k_reset, clk, k_overflow, k_count);

	-- waddr counter
waddr_counter : Counter generic map (OUTPUT_ADDR_WIDTH) port map (waddr_enable, waddr_reset, clk, waddr_overflow, WAddr);

	-- group select
group_mux : Mux4to1 port map (x"00", x"01", x"20", x"21", k_count, offset); 

	-- jump select
jump_mux : Mux4to1 port map (offset, x"02", x"20", x"00", jump_sel, raddr_operand);

	-- Read address adder
raddr_adder : Adder port map (raddr_operand, root, addr_sum);

	-- Read address root
raddr_root : Dff generic map (INPUT_ADDR_WIDTH) port map (addr_sum, root_load, root_reset, clk, root);

	-- Read address
raddr_to_read : Tri_state_buffer generic map (INPUT_ADDR_WIDTH) port map (addr_sum, raddr_output, RAddr);

	-- Data in
input_data : Tri_state_buffer generic map (DATA_WIDTH) port map (Data_in, data_input, data_operand);

	-- Sum of data group
data_sum_dff : Dff generic map (SUM_WIDTH) port map (data_sum, sum_load, sum_reset, clk, accelerator_sum);

	-- Data Adder
data_adder : Adder port map (data_operand, accelerator_sum, data_sum); 

	-- output data gate
	mean <= accelerator_sum(SUM_WIDTH-1 downto 2);
mean_to_write : Tri_state_buffer generic map (DATA_WIDTH) port map (mean, mean_output, Data_out);

end datapath_structure;
