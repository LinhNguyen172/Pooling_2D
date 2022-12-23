library ieee;
use ieee.std_logic_1164.all;
use work.pooling_2d_package.all;

entity Controller is
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

	-- output current state for debugging
	current_state : out state_type
);
end entity;

architecture FSM of controller is

	--type state_type is (s_reset, s_start, s_loop_i, s_reset_j, s_loop_j, s_reset_k, 
	--s_loop_k, s_read, s_sum, s_write, s_group, s_line, s_done, s_end);

signal state : state_type;

begin

	next_state_logic : process (reset, clk)
	begin
		if reset = '1' then
			state <= s_reset;
		elsif clk = '1' and clk'event then
			case state is
			when s_reset => state <= s_start;
			when s_start =>
				if start = '1' then state <= s_loop_i;
				else state <= s_start; end if;
			when s_loop_i =>
				if i_overflow = '1' then state <= s_done;
				else state <= s_reset_j; end if;
			when s_reset_j => state <= s_loop_j;
			when s_loop_j =>
				if j_overflow = '1' then state <= s_line;
				else state <= s_reset_k; end if;
			when s_reset_k => state <= s_loop_k;
			when s_loop_k =>
				if k_overflow = '1' then state <= s_write;
				else state <= s_read; end if;
			when s_read => state <= s_sum;
			when s_sum => state <= s_loop_k;
			when s_write => state <= s_group;
			when s_group => state <= s_loop_j;
			when s_line => state <= s_loop_i;
			when s_done => state <= s_end;
			when s_end =>
				if start = '0' then state <= s_reset;
				else state <= s_end; end if;
			when others => state <= s_reset;
			end case;
		end if;
	end process;

current_state <= state;

with state select Done <= '1' when s_done|s_end, '0' when others;

-- controll signal

-- i counter
with state select i_reset <= '1' when s_reset,
			     '0' when others;
with state select i_enable <= '1' when s_line,
			      '0' when others;

-- j counter
with state select j_reset <= '1' when s_reset|s_reset_j,
			     '0' when others;
with state select j_enable <= '1' when s_group,
			      '0' when others;

-- k counter
with state select k_reset <= '1' when s_reset|s_reset_k,
			     '0' when others;
with state select k_enable <= '1' when s_sum,
			      '0' when others;

-- waddr counter
with state select waddr_reset <= '1' when s_reset,
				 '0' when others;
with state select waddr_enable <= '1' when s_group,
				  '0' when others;
WEn <= '1' when state = s_write else '0';

-- dataflow selection
with state select jump_sel <= "00" when s_read,
			      "01" when s_group,
			      "10" when s_line,
			      "11" when others;

-- raddr_root
with state select root_reset <= '1' when s_reset,
				'0' when others;
with state select root_load <= '1' when s_group|s_line,
			       '0' when others;

-- raddr
raddr_output <= '1' when state = s_read else '0';
REn <= '1' when state = s_read else '0';

-- Data in
data_input <= '1' when state = s_sum else '0';

-- Data out
with state select sum_reset <= '1' when s_reset|s_reset_k,
			       '0' when others;
with state select sum_load <= '1' when s_sum,
			      '0' when others;
mean_output <= '1' when state = s_write else '0';

end FSM;
