library ieee;
use ieee.std_logic_1164.all;

entity Full_adder is
port (
	a, b: in std_logic;
	cin: in std_logic;
	cout: out std_logic;
	sum: out std_logic
	);
end Full_adder;

architecture adder of Full_adder is
begin
Add_proc : process (a,b,cin)
	begin 
		if a = b then
			cout <= a;
			sum <= cin;
		else
			cout <= cin;
			sum <= not cin;
		end if;
end process;
end adder;
