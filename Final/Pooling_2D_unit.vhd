library ieee;
use ieee.std_logic_1164.all;
use work.pooling_2d_package.all;

entity Pooling_2D_unit is
port (
	clk, start, reset : in std_logic;
	done, WEn, REn : out std_logic;
	WAddr : out std_logic_vector (OUTPUT_ADDR_WIDTH-1 downto 0);
	RAddr : out std_logic_vector (INPUT_ADDR_WIDTH-1 downto 0);
	Data_in : in std_logic_vector (DATA_WIDTH-1 downto 0);
	Data_out : out std_logic_vector (DATA_WIDTH-1 downto 0);
	current_state : out state_type
);
end entity;

architecture Pool2D_structure of Pooling_2D_unit is

signal i_reset, i_enable, i_overflow, j_reset, j_enable, j_overflow, k_reset, k_enable, k_overflow, waddr_reset,
	waddr_enable, root_reset, root_load, raddr_output, data_input, sum_reset, sum_load , mean_output : std_logic;
signal jump_sel : std_logic_vector (1 downto 0);

begin

	-- Controller unit
Controller_u : Controller port map ( clk ,start, reset, done, i_reset, i_enable, i_overflow, j_reset, j_enable, j_overflow, k_reset,
				k_enable, k_overflow, waddr_reset, waddr_enable, WEn, jump_sel, root_reset, root_load,
				raddr_output, REn, data_input, sum_reset, sum_load , mean_output, current_state
);

	-- Datapath unit
Datapath_u : Datapath port map (clk, i_reset, i_enable,	i_overflow, j_reset, j_enable, j_overflow, k_reset, k_enable, k_overflow,
				waddr_reset, waddr_enable, WAddr, jump_sel, root_reset, root_load, raddr_output,
				RAddr, data_input, Data_in, sum_reset, sum_load , mean_output, Data_out
);

end Pool2D_structure;
