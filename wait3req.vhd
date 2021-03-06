library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


entity wait3req is
  port( CLK     : in  std_logic; 
			reset  : in  std_logic;
			PB     :	in  std_logic;
			outputx : out std_logic := '0');
end wait3req;

architecture behave of wait3req is
	type state_type is (S0, S1);
	signal state : state_type := S0;
	signal tmp : integer := 0 ;
	signal tmpMax : integer := 3  ;
	begin
	process(CLK,reset)
			begin
				
				if rising_edge(CLK) then
					if (reset='0') then 
							state <= S0;
							tmp <= 0;
					end if;
					
					case state is
						
						when S0 =>
							if(PB = '1')then
								state <= S1;
								tmp <= tmp ;
									
							else
								state <= S0;
								tmp <= tmp ;
							end if;
						when S1 =>
							if(PB = '0')then
								state <= S0;
								tmp <= tmp + 1;
								
							else
								state <= S1;
								tmp <= tmp ;
								
								
							end if;
						
					end case;
					
					if(tmp=tmpMax)then
						tmp <= 0;
						outputx <= '1' ;
									
					else 
						outputx <= '0';
						
					end if;
				end if;
		end process;
	end behave;