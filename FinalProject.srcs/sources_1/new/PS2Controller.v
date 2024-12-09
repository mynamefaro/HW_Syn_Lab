module PS2Controller(
    input flag,
    input [15:0] keycode,
    output reg [7:0] data,
    output reg pressed,
    output reg isShift,
    output reg isCaps,
    output reg isEng
    );

    reg [7:0] key_reg ;
//    reg isEng ;
    reg temp ;
    
    // Keycode mapping
    always @(posedge flag) begin
        // Update pressed/released status
        if (keycode[15:8] != 8'hf0 && keycode[7:0] != 8'hf0) begin
            if (keycode[7:0] == 8'h0e) begin
                isEng <= ~isEng ;
            end else if (keycode[7:0] == 8'h12 || keycode[7:0] == 8'h59) begin
                isShift <= 1'b1 ;
            end else if (keycode[7:0] == 8'h58) begin
                isCaps <= ~isCaps ;
            end else begin
                key_reg <= keycode[7:0];
                temp <= 1'b1;
            end
        end else begin
            if (keycode[7:0] == 8'h12 || keycode[7:0] == 8'h59)
                isShift <= 1'b0 ;
            pressed <= 1'b0 ;
        end
        
        if (isEng) begin
            if (isShift ^ isCaps) begin
                case (key_reg)
                    8'h66: data = 8'h08; // backspace
                    8'h5a: data = 8'h0d; // enter
                    8'h29: data = 8'h20; // spacebar
                    8'h70: data = 8'h30; // 0 numpad
                    8'h69: data = 8'h31; // 1 numpad
                    8'h72: data = 8'h32; // 2 numpad
                    8'h7a: data = 8'h33; // 3 numpad
                    8'h6b: data = 8'h34; // 4 numpad
                    8'h73: data = 8'h35; // 5 numpad
                    8'h74: data = 8'h36; // 6 numpad
                    8'h6c: data = 8'h37; // 7 numpad
                    8'h75: data = 8'h38; // 8 numpad
                    8'h7d: data = 8'h39; // 9 numpad
                    8'h45: data = 8'h29; // 0 
                    8'h16: data = 8'h21; // 1 
                    8'h1e: data = 8'h40; // 2 
                    8'h26: data = 8'h23; // 3 
                    8'h25: data = 8'h24; // 4 
                    8'h2e: data = 8'h25; // 5 
                    8'h36: data = 8'h5e; // 6 
                    8'h3d: data = 8'h26; // 7 
                    8'h3e: data = 8'h2a; // 8 
                    8'h46: data = 8'h28; // 9 
                    8'h4e: data = 8'h5f; // _
                    8'h55: data = 8'h2b; // +
                    8'h54: data = 8'h7b; // {
                    8'h4a: data = 8'h3f; // ?
                    8'h5b: data = 8'h7d; // }
                    8'h4c: data = 8'h3a; // :
                    8'h52: data = 8'h22; // "
                    8'h41: data = 8'h3c; // <
                    8'h49: data = 8'h3e; // >
                    8'h5d: data = 8'h7c; // |
                    8'h1c: data = 8'h41; // A
                    8'h32: data = 8'h42; // B
                    8'h21: data = 8'h43; // C
                    8'h23: data = 8'h44; // D
                    8'h24: data = 8'h45; // E
                    8'h2b: data = 8'h46; // F
                    8'h34: data = 8'h47; // G
                    8'h33: data = 8'h48; // H
                    8'h43: data = 8'h49; // I
                    8'h3b: data = 8'h4a; // J
                    8'h42: data = 8'h4b; // K
                    8'h4b: data = 8'h4c; // L
                    8'h3a: data = 8'h4d; // M
                    8'h31: data = 8'h4e; // N
                    8'h44: data = 8'h4f; // O
                    8'h4d: data = 8'h50; // P
                    8'h15: data = 8'h51; // Q
                    8'h2d: data = 8'h52; // R
                    8'h1b: data = 8'h53; // S
                    8'h2c: data = 8'h54; // T
                    8'h3c: data = 8'h55; // U
                    8'h2a: data = 8'h56; // V
                    8'h1d: data = 8'h57; // W
                    8'h22: data = 8'h58; // X
                    8'h35: data = 8'h59; // Y
                    8'h1a: data = 8'h5a; // Z
                    default: data = 8'h2d;
                endcase
            end else begin
                case (key_reg)
                    8'h66: data = 8'h08; // backspace
                    8'h5a: data = 8'h0d; // enter
                    8'h29: data = 8'h20; // spacebar
                    8'h70: data = 8'h30; // 0 numpad
                    8'h69: data = 8'h31; // 1 numpad
                    8'h72: data = 8'h32; // 2 numpad
                    8'h7a: data = 8'h33; // 3 numpad
                    8'h6b: data = 8'h34; // 4 numpad
                    8'h73: data = 8'h35; // 5 numpad
                    8'h74: data = 8'h36; // 6 numpad
                    8'h6c: data = 8'h37; // 7 numpad
                    8'h75: data = 8'h38; // 8 numpad
                    8'h7d: data = 8'h39; // 9 numpad
                    8'h45: data = 8'h30; // 0 
                    8'h16: data = 8'h31; // 1 
                    8'h1e: data = 8'h32; // 2 
                    8'h26: data = 8'h33; // 3 
                    8'h25: data = 8'h34; // 4 
                    8'h2e: data = 8'h35; // 5 
                    8'h36: data = 8'h36; // 6 
                    8'h3d: data = 8'h37; // 7 
                    8'h3e: data = 8'h38; // 8 
                    8'h46: data = 8'h39; // 9 
                    8'h4e: data = 8'h2d; // -
                    8'h55: data = 8'h3d; // =
                    8'h54: data = 8'h5b; // [
                    8'h4a: data = 8'h2f; // /
                    8'h5b: data = 8'h5d; // ]
                    8'h4c: data = 8'h3b; // ;
                    8'h52: data = 8'h27; // '
                    8'h41: data = 8'h2c; // ,
                    8'h49: data = 8'h2e; // .
                    8'h5d: data = 8'h5c; // \
                    8'h1c: data = 8'h61; // a
                    8'h32: data = 8'h62; // b
                    8'h21: data = 8'h63; // c
                    8'h23: data = 8'h64; // d
                    8'h24: data = 8'h65; // e
                    8'h2b: data = 8'h66; // f
                    8'h34: data = 8'h67; // g
                    8'h33: data = 8'h68; // h
                    8'h43: data = 8'h69; // I
                    8'h3b: data = 8'h6a; // i
                    8'h42: data = 8'h6b; // k
                    8'h4b: data = 8'h6c; // l
                    8'h3a: data = 8'h6d; // m
                    8'h31: data = 8'h6e; // n
                    8'h44: data = 8'h6f; // o
                    8'h4d: data = 8'h70; // p
                    8'h15: data = 8'h71; // q
                    8'h2d: data = 8'h72; // r
                    8'h1b: data = 8'h73; // s
                    8'h2c: data = 8'h74; // t
                    8'h3c: data = 8'h75; // u
                    8'h2a: data = 8'h76; // v
                    8'h1d: data = 8'h77; // w
                    8'h22: data = 8'h78; // x
                    8'h35: data = 8'h79; // y
                    8'h1a: data = 8'h7a; // z
                    default: data = 8'h2d;
                endcase
            end
        end else begin
            if (isShift ^ isCaps) begin
                case (key_reg)
                    8'h66: data = 8'h08; // backspace
                    8'h5a: data = 8'h0d; // enter
                    8'h29: data = 8'h20; // spacebar
                    8'h70: data = 8'h30; // 0 numpad
                    8'h69: data = 8'h31; // 1 numpad
                    8'h72: data = 8'h32; // 2 numpad
                    8'h7a: data = 8'h33; // 3 numpad
                    8'h6b: data = 8'h34; // 4 numpad
                    8'h73: data = 8'h35; // 5 numpad
                    8'h74: data = 8'h36; // 6 numpad
                    8'h6c: data = 8'h37; // 7 numpad
                    8'h75: data = 8'h38; // 8 numpad
                    8'h7d: data = 8'h39; // 9 numpad
                    8'h5d: data = 8'h84;
                    8'h1b: data = 8'h85;
                    8'h21: data = 8'h88;
                    8'h4c: data = 8'h8a;
                    8'h34: data = 8'h8b;
                    8'h4d: data = 8'h8c;
                    8'h24: data = 8'h8d;
                    8'h23: data = 8'h8e;
                    8'h54: data = 8'h8f;
                    8'h2d: data = 8'h90;
                    8'h41: data = 8'h91;
                    8'h43: data = 8'h92;
                    8'h2c: data = 8'h97;
                    8'h4b: data = 8'ha5;
                    8'h42: data = 8'ha6;
                    8'h49: data = 8'ha9;
                    8'h2a: data = 8'hab;
                    
                    default: data = 8'h2d;
                endcase
            end else begin
                case (key_reg)
                    8'h66: data = 8'h08; // backspace
                    8'h5a: data = 8'h0d; // enter
                    8'h29: data = 8'h20; // spacebar
                    8'h26: data = 8'h2d;  // -
                    8'h1e: data = 8'h2f;  // /
                    8'h70: data = 8'h30; // 0 numpad
                    8'h69: data = 8'h31; // 1 numpad
                    8'h72: data = 8'h32; // 2 numpad
                    8'h7a: data = 8'h33; // 3 numpad
                    8'h6b: data = 8'h34; // 4 numpad
                    8'h73: data = 8'h35; // 5 numpad
                    8'h74: data = 8'h36; // 6 numpad
                    8'h6c: data = 8'h37; // 7 numpad
                    8'h75: data = 8'h38; // 8 numpad
                    8'h7d: data = 8'h39; // 9 numpad
                    8'h23: data = 8'h80;  // ก
                    8'h4e: data = 8'h81;  // ข
                    8'h5d: data = 8'h82;  // ฃ
                    8'h3e: data = 8'h83;  // ค
                    8'h52: data = 8'h86;  // ง
                    8'h45: data = 8'h87;  // จ
                    8'h55: data = 8'h89;  // ช
                    8'h2b: data = 8'h93;  // ด
                    8'h46: data = 8'h94;  // ต
                    8'h2e: data = 8'h95;  // ถ
                    8'h3a: data = 8'h96;  // ท
                    8'h44: data = 8'h98;  // น
                    8'h54: data = 8'h99;  // บ
                    8'h22: data = 8'h9a;  // ป
                    8'h1a: data = 8'h9b;  // ผ
                    8'h4a: data = 8'h9c;  // ฝ
                    8'h2d: data = 8'h9d;  // พ
                    8'h1c: data = 8'h9e;  // ฟ
                    8'h25: data = 8'h9f;  // ภ
                    8'h41: data = 8'ha0;  // ม
                    8'h4d: data = 8'ha1;  // ย
                    8'h43: data = 8'ha2;  // ร
                    8'h5b: data = 8'ha3;  // ล
                    8'h4c: data = 8'ha4;  // ว
                    8'h4b: data = 8'ha7;  // ส
                    8'h1b: data = 8'ha8;  // ห
                    8'h2a: data = 8'haa;  // อ
                    
//                    8'h2c: data = 8'haf;  // ะ
//                    8'h35: data = 8'hb0;  // า
//                    8'h42: data = 8'hb2;  // ิ
//                    8'h32: data = 8'hb3;  // ี
//                    8'h3c: data = 8'hb4;  // ึ
//                    8'h31: data = 8'hb5;  // ื
//                    8'h15: data = 8'hb6;  // ๆ
//                    8'h34: data = 8'hb9;  // เ
//                    8'h21: data = 8'hba;  // แ
//                    8'h1d: data = 8'hbb;  // ไ
                    default: data = 8'h2d;
                endcase
            end
        end
        
        if (temp) begin
            temp <= 1'b0 ;
            pressed <= 1'b1 ;
        end
    end

endmodule
