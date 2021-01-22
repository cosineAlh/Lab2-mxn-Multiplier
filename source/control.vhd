LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control is
port (
 num: in integer;
 CLK : in std_logic ;
 START : in std_logic ;
 Q0: in std_logic;
 Ad : out std_logic ;
 Sh : out std_logic ;
 LOAD : out std_logic ;
 DONE : out std_logic);
end;

architecture rtl of control is
--signal CNT : std_logic_vector(1 downto 0):="00";
signal CNT:integer:=0;
-- declare states
type state_type is (HALT,INIT,TEST, ADD, SHIFT);
signal state : state_type;
begin
process (CLK)
 begin
     if (rising_edge(CLK)) then
     case state is
         when HALT=>
            if START='1' then
                state<=INIT;
            else
                state<=HALT;
            end if;
         when INIT =>
            state<=TEST;
         when TEST=>
             if Q0 = '1' then
             state <= ADD;
             else
             state <= SHIFT;
             end if;
         when ADD =>
             state <= SHIFT;
         when SHIFT =>
            if CNT = num-1 then -- verify if finished
                CNT <= 0; -- re-initialize counter
                state <= HALT; -- ready for next multiply
            else
                CNT <= CNT + 1; -- increment counter
                state <= TEST;
            end if;
         when others=>
            state<=HALT;
     end case;
     end if;
 end process;
 
 LOAD <= '1' when state =INIT else '0';
 Ad <= '1' when state = ADD else '0';
 Sh <= '1' when state = SHIFT else '0';
 DONE <= '1' when state = HALT else '0';
end rtl;