`timescale 1ns/1ns
`default_nettype none


module tbench ();

//==============================================================================
//-- tbench : RESET generator
//==============================================================================
    reg rst;

    initial begin
        rst = 1'b1;
        #1_234_000
        rst = 1'b0;
    end

//==============================================================================
//-- tbench : CLOCK generator
//==============================================================================
    real    FREQ_CLK = 1.0/*MHz*/;
    reg     clk;

    initial begin
        clk = 1'b0;
        forever #(1_000_000_000 / (FREQ_CLK*1_000) / 2) clk = ~clk;
    end


//==============================================================================
//-- tbench : Test Target
//==============================================================================
    reg [63:0] state;

    game_of_life_top game_of_life_top (
        .clk    (clk)       //- in  clock
    ,   .rst    (rst)    //- in  reset negative
    ,   .state  (state)  //- out state
    );


    // シーケンス制御
    initial begin
        $display("run start");
        #(1_000_000_000 / (FREQ_CLK*1_000) * 10)
        $finish;
    end

    // stateをダンプ
    always @(posedge clk) begin
        // 2進数で8bitずつ表示
        $display("%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n", state[63:56], state[55:48], state[47:40], state[39:32], state[31:24], state[23:16], state[15:8], state[7:0]);
    end

endmodule

`default_nettype wire