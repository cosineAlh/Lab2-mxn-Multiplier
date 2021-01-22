library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift is
generic(n:integer;
        m:integer);
port (
 CLK : in std_logic ;
 multiplier : in std_logic_vector (m-1 downto 0);
 LOAD : in std_logic ;
 Sh : in std_logic ;
 Ad : in std_logic ;
 Aout : in std_logic_vector (n-1 downto 0);
 Cout : in std_logic ;
 Q0: out std_logic;
 Product : out std_logic_vector (m+n-1 downto 0):=(others=>'0');
 A : out std_logic_vector (n-1 downto 0):=(others=>'0'));
end;

architecture rtl of shift is
signal temp_register : std_logic_vector(m+n downto 0):=(others=>'0');
signal temp_Add : std_logic:='0';

begin
process (CLK)
 begin
 if (rising_edge(CLK)) then
     if LOAD = '1' then
     temp_register (m+n downto m) <= (others => '0');
     temp_register(m-1 downto 0) <= multiplier; -- load multiplier into register
     end if;
     
     if Ad= '1' then
     temp_Add <= '1';
     end if;
     
     if Sh = '1' then
         if temp_Add = '1' then
         -- store adder output while shifting register right 1 bit
             temp_Add <= '0';
             temp_register<='0' & Cout & Aout & temp_register (m-1 downto 1);
         else
         -- no add - simply shift right 1 bit
             temp_register <= '0' & temp_register (m+n downto 1);
         end if;
     end if;
 end if;
 end process;
 
 A <= temp_register(m+n-1 downto m);
 Q0 <= temp_register(0);
 Product <= temp_register(m+n-1 downto 0);
end rtl;