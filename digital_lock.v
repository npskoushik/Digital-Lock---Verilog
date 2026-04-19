`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2026 15:20:33
// Design Name: 
// Module Name: digital_lock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module digital_lock(
    input clk,
    input reset,
    input enter,
    input password,          // 1-bit input entered each time
    output reg unlock,
    output reg locked,
    output reg [1:0] fail
);

reg [3:0] entered_pass;
reg [2:0] count;

parameter correct_pass = 4'b1001;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        entered_pass <= 4'b0000;
        count <= 0;
        unlock <= 0;
        fail <= 0;
        locked <= 0;
    end
    else
    begin
        if(enter && !locked)
        begin
            entered_pass[count] <= password;
            count <= count + 1;

            if(count == 3)
            begin
                // FIXED COMPARISON (includes latest bit)
                if({password, entered_pass[2:0]} == correct_pass)
                begin
                    unlock <= 1;
                    fail <= 0;
                end
                else
                begin
                    unlock <= 0;
                    fail <= fail + 1;

                    // Improved condition
                    if(fail >= 2)
                        locked <= 1;
                end

                count <= 0;
                entered_pass <= 0;
            end
        end
    end
end

endmodule