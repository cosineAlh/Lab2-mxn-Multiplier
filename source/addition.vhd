library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity addition is
generic(n:integer;
        m:integer);
port (
 A : in std_logic_vector (n-1 downto 0);
 Multiplicand : in std_logic_vector (n-1 downto 0);
 LOAD: in std_logic;
 CLK: in std_logic;
 Cout : out std_logic ;
 Aout : out std_logic_vector (n-1 downto 0):=(others=>'0'));
end;

architecture struc of addition is
signal c_temp : std_logic_vector(n-1 downto 0) := (others => '0');
signal mul_temp:std_logic_vector(n-1 downto 0) := (others => '0');

begin
    process(LOAD)
    begin
            if LOAD='1'then
                mul_temp(n-1 downto 0) <= multiplicand; -- load multiplicand into register
            end if;
    end process;

    c_temp(0) <= '0';
    ADD:for i in n-1 downto 0 generate
         Low:if i/=(n-1) generate
         Aout(i) <= A(i) xor Mul_temp(i) xor c_temp(i);
         c_temp(i+1) <= (A(i) and Mul_temp(i)) or (A(i) and c_temp(i)) or (Mul_temp(i) and c_temp(i));
         end generate;
        -- assemble last adder
         High:if i=n-1 generate
         Aout(n-1) <= A(n-1) xor Mul_temp(n-1) xor c_temp(i);
         Cout <= (A(n-1) and Mul_temp(n-1)) or (A(n-1) and c_temp(i)) or (Mul_temp(n-1) and c_temp(i));
         end generate;
    end generate;
end struc;