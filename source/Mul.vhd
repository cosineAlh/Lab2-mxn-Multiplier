library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mul is
generic(nm:integer;
        nq:integer);
 port (
 Multiplicand : in std_logic_vector(nm-1 downto 0 );
 Multiplier : in std_logic_vector(nq-1 downto 0 );
 CLK : in std_logic;
 START : in std_logic;
 Product : out std_logic_vector(nm+nq-1 downto 0 );
 DONE : out std_logic);
end Mul;

architecture rtl of Mul is
 signal Ad : std_logic:='0';
 signal Aout : std_logic_vector(nm-1 downto 0 ):=(others=>'0');
 signal Cout : std_logic:='0';
 signal LOAD : std_logic:='0';
 signal Q0 : std_logic:='0';
 signal A : std_logic_vector(nm-1 downto 0 ):=(others=>'0');
 signal Sh : std_logic:='0';
 signal num: integer:=nq;
 
 component control
     port (
     num: in integer;
     CLK : in std_logic ;
     START : in std_logic ;
     Q0: in std_logic;
     Ad : out std_logic ;
     Sh : out std_logic ;
     LOAD : out std_logic ;
     DONE : out std_logic);
 end component;
 
 component addition
     generic(n:integer;
            m:integer);
     port(
     A : in std_logic_vector (n-1 downto 0);
     Multiplicand : in std_logic_vector (n-1 downto 0);
     LOAD: in std_logic;
     CLK: in std_logic;
     Cout : out std_logic ;
     Aout : out std_logic_vector (n-1 downto 0));
 end component;
 
 component shift
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
     Product : out std_logic_vector (m+n-1 downto 0);
     A : out std_logic_vector (n-1 downto 0));
 end component;
 
begin
 u1: control
 port map (
 num=>num,
 CLK=>CLK,
 START=>START,
 Q0=>Q0,
 Ad=>Ad,
 Sh=>Sh,
 LOAD=>LOAD,
 DONE=>DONE
 );

u2: addition
 generic map(nm,nq)
 port map (
 A => A(nm-1 downto 0),
 Multiplicand=>Multiplicand(nm-1 downto 0),
 LOAD => LOAD,
 CLK=>CLK,
 Cout=>Cout,
 Aout=>Aout(nm-1 downto 0)
 );

 u3: shift
 generic map(nm,nq)
 port map (
 CLK => CLK,
 multiplier=>multiplier(nq-1 downto 0),
 LOAD => LOAD,
 Sh => Sh,
 Ad => Ad,
 Aout => Aout(nm-1 downto 0),
 Cout => Cout,
 Q0=>Q0,
 A=>A(nm-1 downto 0),
 Product=>Product(nq+nm-1 downto 0)
 );
end rtl;