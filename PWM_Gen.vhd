library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all;
entity PWM_Gen is
generic(pwm_periode : integer :=100000);
	port (
			CLK  : in std_logic;
			reset : in std_logic;
			duty : in integer;
			PWM_out : out std_logic);
	end PWM_Gen;
architecture behave of PWM_Gen is
signal cnt : integer ;
begin

	process (reset , CLK )
	begin
		if( reset = '0') then
			cnt <= 0 ;
			PWM_out <= '0';
		elsif rising_edge(CLK) then
			if(cnt >= pwm_periode-1) then
				cnt <= 0 ;
				PWM_out <= '1' ;
			else
				cnt <= cnt + 1 ;
				if(cnt<duty) then
					PWM_out <= '1';
				elsif(cnt = duty) then
					PWM_out <= '0';
				end if;
			end if;
		end if;
	end process;
end behave;