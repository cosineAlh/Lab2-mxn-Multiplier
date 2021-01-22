library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testbench is
    generic(nm:integer:=4;
            nq:integer:=4);
end testbench;

architecture BEHAVIORAL of testbench is
component Mul
 generic(nm:integer:=4;
        nq:integer:=4);
 port (
 Multiplicand : in std_logic_vector(nm-1 downto 0 );
 Multiplier : in std_logic_vector(nq-1 downto 0 );
 CLK : in std_logic;
 Product : out std_logic_vector(nm+nq-1 downto 0 );
 START : in std_logic;
 DONE : out std_logic
 );
end component;

signal Multiplicand: std_logic_vector(nm-1 downto 0):=(others=>'0');
signal Multiplier : std_logic_vector(nq-1 downto 0 ):=(others=>'0');
signal CLK,START : std_logic:='0';
signal DONE: std_logic:='0';
signal Product: std_logic_vector(nq+nm-1 downto 0):=(others=>'0');
signal product_ref:std_logic_vector(nq+nm-1 downto 0):=(others=>'0');
signal is_right:std_logic:='0';

begin
-- instantiate the Device Under Test
uut : Mul
 generic map(nm,nq)
 port map (
 Multiplicand => Multiplicand,
 Multiplier => Multiplier,
 CLK => CLK,
 Product=>Product,
 START => START,
 DONE => DONE);
 
-- Generate clock stimulus
STIMULUS_CLK : process
begin
 CLK <= '0';
 wait for 5 ns;
 CLK <= '1';
 wait for 5 ns;
end process STIMULUS_CLK;

STIMULUS_START : process
begin
for i in 2**nm-1 downto 0 loop
for j in 2**nq-1 downto 0 loop
    Multiplicand<=std_logic_vector(to_unsigned(i,nm));
    Multiplier<=std_logic_vector(to_unsigned(j,nq));
    product_ref<=std_logic_vector(to_unsigned(i*j,nm+nq));

    START<='1';
    wait until rising_edge(CLK);
    START<='0';
    wait until DONE='1';
    wait for 1 ns;
    if product=product_ref then
        is_right<='1';
    else
        is_right<='0';
    end if;
    wait until rising_edge(CLK);
end loop;
end loop;
end process STIMULUS_START;
end BEHAVIORAL;
