`timescale 1ns / 1ps

module top(
    input clk,          // 100MHz on Basys 3
    input reset,        // btnC on Basys 3
    input btnU,         // btnU on Basys 3 and send data from switch to another
    input PS2Data,
    input PS2Clk,
    output wire RsTx,   // UART
    input wire RsRx,    // UART
    input [7:0] sw,     // switch
    input JB0,          // Receive from another board
    output JC0,         // Transmit to another board
    output hsync,       // to VGA connector
    output vsync,       // to VGA connector
    output [11:0] rgb,  // to DAC, to VGA connector
    output [6:0] seg,   // 7-Segment Display
    output dp,
    output [3:0] an     // 7-Segment an control
    );
    
    // signals
    wire [9:0] w_x, w_y;
    wire w_video_on, w_p_tick;
    wire sent1, sent2 ;
    wire received1, received2; // FROM Keyboard and FROM another board
    reg [11:0] rgb_reg;
    wire [7:0] data_in, data_out; //WRITE DATA FROM UART, DATA THAT SHOWN ON SCREEN
    wire [11:0] rgb_next;
    reg [6:0] idx;
    wire [3:0] char_row; // 4-bit row of ASCII character
    wire [2:0] bit_addr; // column number of ROM data
    wire gnd; // Ground
    wire [7:0] gnd_b; // GROUND_BUS
    wire received_echo;
    wire received_keyboard;
    wire flag ;
    reg CLK50MHZ = 0 ;
    wire [15:0] keycode ;
    wire baud ;
    wire pressed, released ;
    wire [8:0] data_transmit ;
    wire dte ;
    wire isShift, isCaps, isEng ;
    wire singlePulseReset, singlePulseBtnU;
    
    // VGA ASSIGN VARIABLE
    assign char_row = w_y[3:0];// row number of ascii character rom
    assign bit_addr = w_x[2:0];// column number of ascii character rom
    assign data_transmit = (pressed) ? data_out : sw[7:0] ;
    
    reg [15:0] timer;
    reg long_flag;
    always @(posedge clk) begin
        if (flag == 1) begin
           timer <= 650;
           long_flag <= 1;
        end else if (timer > 0) begin
            timer <= timer - 1;
        end else begin
            long_flag = 0;
        end
    end
    
    // VGA Controller
    vga_controller vga(.clk_100MHz(clk), .reset(singlePulseReset), .hsync(hsync), .vsync(vsync), .video_on(w_video_on), .p_tick(w_p_tick), .x(w_x), .y(w_y));
    // Text Generation Circuit
    ascii_test at(.clk(clk), .video_on(w_video_on), .x(w_x), .y(w_y), .rgb(rgb_next), .data(data_in), .we(received1), .reset(singlePulseReset));
    // gen baud
    baudrate_gen baudrate_gen(clk, baud);
    // single pulser    
    singlePulser sp_keyboard(.clk(baud), .pushed(pressed), .d(received_keyboard)) ;
    singlePulser sp_btnU(.clk(baud), .pushed(btnU), .d(singlePulseBtnU)) ;
    singlePulser sp_reset(.clk(clk), .pushed(reset), .d(singlePulseReset)) ;
    
    // UART1 Receive from another and transmit to monitor
    uart uart1(.tx(RsTx), .data_transmit(gnd_b),
               .rx(JB0), .data_received(data_in), .received(received1),
               .dte(1'b0), .clk(clk), .baud(baud));
                
    // UART2 Receive from keyboard or switch and transmit to another
    uart uart2(.rx(RsRx), .data_transmit(data_transmit), 
               .tx(JC0), .data_received(gnd_b), .received(received2),
               .dte(singlePulseBtnU | received_keyboard), .clk(clk), .baud(baud));
               
    // UART Echo to PuTTy
//    uart echo(.tx(RsTx), .data_transmit(data_transmit),
//              .rx(RsRx), .data_received(data_in), .received(received1),
//              .dte(received_keyboard), .clk(clk), .baud(baud));
              
    PS2Controller ps2controller(.keycode(keycode), .flag(long_flag),
                                .data(data_out), .pressed(pressed), 
                                .isShift(isShift), .isCaps(isCaps), .isEng(isEng)) ;
    
    PS2Receiver uut (
        .clk(CLK50MHZ),
        .kclk(PS2Clk),
        .kdata(PS2Data),
        .keycode(keycode),
        .oflag(flag)
    );

// ######################### use 7-segment to show data_out ############### //

    wire [3:0] num3, num2, num1, num0;
    assign num3 = data_out[7:4] ;
    assign num2 = data_out[3:0] ;
    assign num1 = {3'b000, isShift ^ isCaps} ;
    assign num0 = {3'b000, isEng} ;
//    assign num3 = keycode[7:4] ;
//    assign num2 = keycode[7:4] ;
//    assign num1 = keycode[7:4] ;
//    assign num0 = keycode[3:0] ;
    wire an0, an1, an2, an3;
    assign an = {an3, an2, an1, an0};
     
    wire targetClk;
    wire [18:0] tclk;
    assign tclk[0]=clk;
    genvar c;
    generate for(c=0;c<18;c=c+1) begin
        clockDiv fDiv(tclk[c+1],tclk[c]);
    end endgenerate
    
    clockDiv fdivTarget(targetClk,tclk[18]);
    
    quadSevenSeg q7seg(seg,dp,an0,an1,an2,an3,num0,num1,num2,num3,targetClk);
   
    // rgb buffer
    always @(posedge clk)begin
        CLK50MHZ<=~CLK50MHZ;
        if(w_p_tick)
            rgb_reg <= rgb_next;
    end
    // output
    assign rgb = rgb_reg;
      
endmodule