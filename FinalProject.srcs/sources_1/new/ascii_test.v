`timescale 1ns / 1ps

module ascii_test(
    input clk,                 // Clock signal
    input reset,               // Reset signal
    input we,                  // Write enable signal from UART
    input [7:0] data,          // 8-bit data from UART
    input video_on,            // Video on/off signal
    input [9:0] x, y,          // Current pixel coordinates
    output reg [11:0] rgb      // RGB output
);

    // Parameters and declarations
    parameter MEMSIZE = 1024;      // Memory size (128 locations)
    reg [7:0] mem[MEMSIZE - 1:0]; // 7-bit memory array
    reg [9:0] itr;                // Memory index for writing
    reg isShift, isEng ;

    // Signals for ASCII ROM
    wire [11:0] rom_addr;         // 11-bit text ROM address
    wire [7:0] ascii_char;        // 7-bit ASCII character code
    wire [3:0] char_row;          // 4-bit row of ASCII character
    wire [2:0] bit_addr;          // Column number of ROM data
    wire [7:0] rom_data;          // 8-bit row data from text ROM
    wire ascii_bit, plot;         // ASCII ROM bit and plot signal
    
    wire [5:0] xpos ;             // X position in grid after shift
    wire [3:0] ypos ;             // Y position in grid after shift
    
    // ASCII ROM instance
    ascii_rom rom(.clk(clk), .addr(rom_addr), .data(rom_data));
    
    // ASCII ROM address and data interface
    assign rom_addr = {ascii_char, char_row};   // ROM address
    assign ascii_bit = rom_data[~bit_addr];     // Reverse bit order for ASCII character
    assign char_row = y[3:0];                   // Row number of ASCII character
    assign bit_addr = x[2:0];                   // Column number of ASCII character
    assign xpos = ((x[8:3] + 56) & 6'b111111) ;
    assign ypos = ((y[7:4] + 8)  & 4'b1111) ;
    assign ascii_char = mem[xpos + 64*ypos];
    
    assign plot  = ((x >= 64 && x < 576) && (y >= 128 && y < 384)) ? ascii_bit : 1'b0;
    
    // frame
    integer i, j ;
    initial begin
        itr = 10'b0001000001 ;
        for (i = 0 ; i < 16 ; i = i + 1) begin 
            for (j = 0 ; j < 64 ; j = j + 1) begin
                if ((~|i || &i[3:0]) && (~|j || &j[5:0]))
                    mem[64*i + j] = 7'h2b ; // +
                else if (~|i || &i[3:0])
                    mem[64*i + j] = 7'h2d ; // -
                else if (~|j || &j[5:0])
                    mem[64*i + j] = 7'h7c ; // |
            end
        end
    end
    

    // Memory write logic
    always @(posedge we or posedge reset) begin
        if (reset) begin
            itr = 10'b0001000001 ;
            for (i = 0 ; i < MEMSIZE ; i = i + 1)
                mem[i] = 7'b0 ;
                
            for (i = 0 ; i < 16 ; i = i + 1) begin 
                for (j = 0 ; j < 64 ; j = j + 1) begin
                    if ((~|i || &i[3:0]) && (~|j || &j[5:0]))
                        mem[64*i + j] = 7'h2b ; // +
                    else if (~|i || &i[3:0])
                        mem[64*i + j] = 7'h2d ; // -
                    else if (~|j || &j[5:0])
                        mem[64*i + j] = 7'h7c ; // |
                end
            end
        end else if (we) begin
            if (data == 8) begin
                if (itr != 65) begin
                    itr = (itr + MEMSIZE - 1)%MEMSIZE ; // decrement memory location by 1
                    itr = (itr + (MEMSIZE - 2)*(itr%64 ? 0 : 1))%MEMSIZE ; // decrement line
                end
                mem[itr] = 0 ; // write null on deleted memory location
            end
            else if (data == 13) begin 
                itr = 1 + ((1 + (itr >> 6)) << 6) ;
            end 
            else begin
                mem[itr] = data ;
                itr = ((itr + 1) + 2*((itr + 2)%64 ? 0 : 1) + 128*((itr + 66)%MEMSIZE ? 0 : 1))%MEMSIZE ;
            end
        end
    end
    
    // RGB multiplexing logic
    always @* begin
        if (~video_on)
            rgb = 12'h000;
        else if (plot) begin
            rgb[11:8] <= 4'hf ;
            rgb[7:4]  <= {xpos[2], xpos[3], xpos[4], xpos[5]} ;
            rgb[3:0]  <= {ypos[0], ypos[1], ypos[2], ypos[3]} ;
        end
        else
            rgb = 12'h444 ;
    end

endmodule
