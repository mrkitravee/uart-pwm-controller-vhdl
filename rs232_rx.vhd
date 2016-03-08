library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
entity rs232_rx is
	generic(
		SYSTEM_SPEED : integer := 50e6;
		BAUDDATE : integer := 9600);
		port(clk_i :in std_logic;
		rst_i : in std_logic;
		req_o : out std_logic:='0';
		data_o :out std_logic_vector(7 downto 0);
		data_o24bit : out std_logic_vector(23 downto 0);
		rx : in std_logic);
end rs232_rx;
architecture behave of rs232_rx is
	constant MAX_COUNTER : integer := (SYSTEM_SPEED/BAUDDATE);
	type state_type is(
	WAIT_FOR_RX_START,
	WAIT_HALF_BIT,
	RECEIVE_BITS,
	WAIT_FOR_STOP_BIT);
	
	signal state : state_type := WAIT_FOR_RX_START;
	signal baudrate_counter : integer range 0 to max_counter := 0;
	signal bit_counter : integer range 0 to 7 := 0;
	signal shift_register :std_logic_vector(7 downto 0):=(others => '0');
	signal shift_register_24bit :std_logic_vector(23 downto 0):=(others => '0');
	begin 
		process (clk_i)
		begin
			if rising_edge(clk_i) then
				if rst_i ='0' then
					state <= WAIT_FOR_RX_START;
					data_o <= (others => '0');
					req_o <= '0';
				else
					case state is
						when WAIT_FOR_RX_START =>
							if rx ='0' then
								state <= WAIT_HALF_BIT;
								baudrate_counter <= (MAX_COUNTER/2) -1;
								req_o <= '1';
							end if;
						when WAIT_HALF_BIT =>
							if baudrate_counter = 0 then
								state <=RECEIVE_BITS;
								bit_counter <= 7;
								baudrate_counter <= MAX_COUNTER-1;
							else
								baudrate_counter <= baudrate_counter-1;
							end if;
						when RECEIVE_BITS =>
							if baudrate_counter = 0 then
								shift_register <= rx & shift_register(7 downto 1 );
								shift_register_24bit <= rx & shift_register_24bit(23 downto 1);
								if bit_counter = 0 then
									state <= WAIT_FOR_STOP_BIT;
								else 
									bit_counter <= bit_counter-1;
								end if;
								baudrate_counter <= MAX_COUNTER - 1;
							else
								baudrate_counter<=baudrate_counter-1;
							end if;
						when wait_for_stop_bit =>
							if baudrate_counter = 0 then 
								state <= WAIT_FOR_RX_START;
								if rx ='1' then
									data_o <= shift_register;
									data_o24bit <= shift_register_24bit;
									req_o <='0';
								end if;
							else
								baudrate_counter <= baudrate_counter -1;
							end if;
						end case;
					end if;
				end if;
			end process;
	end behave;			
							
							
							