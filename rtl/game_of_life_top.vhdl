library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity game_of_life_top is
    generic (
        ROWS: integer := 8;
        COLS: integer := 8
    );
    port (
        clk: in std_logic;
        rst: in std_logic;
        state: out std_logic_vector((ROWS*COLS)-1 downto 0)
    );
end game_of_life_top;

architecture RTL of game_of_life_top is
    signal s_cur_state : std_logic_vector((ROWS*COLS)-1 downto 0);


    function calc_next_state( cur_state : std_logic_vector ) return std_logic_vector is
        variable next_state : std_logic_vector(cur_state'range);
        variable count : std_logic_vector(3 downto 0);

    begin
        next_state := (others => '0');
        for i in cur_state'range loop
            if ( i mod (COLS) = 0 ) then
                -- left edge
                next_state(i) := cur_state(i);
            elsif ( i mod (COLS) = COLS - 1 ) then
                -- right edge
                next_state(i) := cur_state(i);
            elsif ( i < COLS ) then
                -- top edge
                next_state(i) := cur_state(i);
            elsif ( i >= (ROWS-1)*COLS ) then
                -- bottom edge
                next_state(i) := cur_state(i);
            else
                -- middle
                count := (others => '0');
                count := count + cur_state(i - COLS - 1);
                count := count + cur_state(i - COLS);
                count := count + cur_state(i - COLS + 1);
                count := count + cur_state(i - 1);
                count := count + cur_state(i + 1);
                count := count + cur_state(i + COLS - 1);
                count := count + cur_state(i + COLS);
                count := count + cur_state(i + COLS + 1);
                if ( cur_state(i) = '0' ) then
                    if ( count = "0011" ) then
                        -- tanjou
                        next_state(i) := '1';
                    else
                        next_state(i) := '0';
                    end if;
                else
                    if ( count = "0010" or count = "0011" ) then
                        -- seizon
                        next_state(i) := '1';
                    else
                        -- kaso, kamitsu
                        next_state(i) := '0';
                    end if;
                end if;
            end if;
        end loop;
        return next_state;
    end function;

begin
    process (clk) begin
        if (clk'event and clk = '1') then
            if ( rst = '1' ) then
                -- s_cur_state((ROWS-1)*(COLS-1) downto 5) <= (others => '0');
                -- s_cur_state(4 downto 0) <= (others => '1');
                s_cur_state <= (others => '1');
            else
                s_cur_state <= calc_next_state(s_cur_state);
            end if;
        end if;
    end process;

    -- output
    state <= s_cur_state;
end RTL;
