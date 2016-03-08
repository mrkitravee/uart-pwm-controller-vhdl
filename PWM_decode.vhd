library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity PWM_decode is
generic(pwm_periode : integer :=100000);
port(
		CLK : in std_logic ;
		reset : in std_logic ;
		PWM_set  : in std_logic_vector(7 downto 0) ;
		duty : out integer );
end PWM_decode;

architecture Behave of PWM_decode is
signal n : integer;
begin
	process(reset, CLK, PWM_set)
	begin 
	if reset = '0' then
		duty<=0;
	elsif rising_edge(CLK) then
			n <= to_integer(unsigned(PWM_set));
			duty <= (pwm_periode*n)/255;
			
			
			
		end if;
	end process;
end Behave;