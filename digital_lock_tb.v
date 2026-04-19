`timescale 1ns/1ps

module digital_lock_tb;

reg clk;
reg reset;
reg enter;
reg password;

wire unlock;
wire locked;
wire [1:0] fail;

// Instantiate DUT
digital_lock uut(
    .clk(clk),
    .reset(reset),
    .enter(enter),
    .password(password),
    .unlock(unlock),
    .locked(locked),
    .fail(fail)
);

// Clock generation (100 ns period)
always #50 clk = ~clk;

initial
begin
    clk = 0;
    reset = 1;
    enter = 0;
    password = 0;

    // Release reset
    #100 reset = 0;

    // -------------------------
    // TEST CASE 1: Correct Password (1001)
    // -------------------------
    #100 password = 1; enter = 1;  // bit 1
    #100 enter = 0;

    #100 password = 0; enter = 1;  // bit 0
    #100 enter = 0;

    #100 password = 0; enter = 1;  // bit 0
    #100 enter = 0;

    #100 password = 1; enter = 1;  // bit 1
    #100 enter = 0;

    // Wait to observe unlock
    #200;

    // -------------------------
    // TEST CASE 2: Wrong Password (1111)
    // -------------------------
    #100 password = 1; enter = 1;
    #100 enter = 0;

    #100 password = 1; enter = 1;
    #100 enter = 0;

    #100 password = 1; enter = 1;
    #100 enter = 0;

    #100 password = 1; enter = 1;
    #100 enter = 0;

    #200;

    // -------------------------
    // TEST CASE 3: Another Wrong (to trigger lock)
    // -------------------------
    #100 password = 0; enter = 1;
    #100 enter = 0;

    #100 password = 0; enter = 1;
    #100 enter = 0;

    #100 password = 0; enter = 1;
    #100 enter = 0;

    #100 password = 0; enter = 1;
    #100 enter = 0;

    #500;

    $finish;
end

endmodule