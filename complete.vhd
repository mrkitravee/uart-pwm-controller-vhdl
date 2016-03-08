library ieee;
use ieee.std_logic_1164.all;
entity complete is
	port(
		 reset, CLK ,rx_in : in std_logic;
		 PWM_out : out std_logic_vector(2 downto 0);  
		 output_ok : out std_logic;
		 ack_o : out std_logic);
end complete;

architecture Structural of complete is



signal data: std_logic_vector(7 downto 0);
signal data24: std_logic_vector(23 downto 0);
signal duty0,duty1,duty2 : integer ;
signal OK : std_logic;
signal req : std_logic;



	begin
		U1: work.rs232_rx
			port map(CLK, reset, req, data, data24, rx_in);
		
		Z1: work.wait3req
			port map(CLK ,reset, req, OK);
		
		Z2: work.rs232_tx
			port map(CLK,reset,OK,ack_o,output_ok);
		
		T1: work.PWM_decode
			port map(CLK, reset, data24(23 downto 16), duty0);
		
		T2: work.PWM_decode
			port map(CLK, reset, data24(15 downto 8), duty1);
			
		T3: work.PWM_decode
			port map(CLK, reset, data24(7 downto 0), duty2);
			
		G1: work.PWM_Gen
			port map(CLK, reset, duty0, PWM_out(0));
		
		G2: work.PWM_Gen
			port map(CLK, reset, duty1, PWM_out(1));
		
		G3: work.PWM_Gen
			port map(CLK, reset, duty2, PWM_out(2));
			
		
			
		
		
			
end Structural;