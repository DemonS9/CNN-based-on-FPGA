/*------------------------------------------------------------------------
 *
 *  Copyright (c) 2021 by Bo Young Kang, All rights reserved.
 *
 *  File name  : conv2_buf.v
 *  Written by : Kang, Bo Young
 *  Written on : Oct 13, 2021
 *  Version    : 21.2
 *  Design     : 2nd Convolution Layer for CNN MNIST dataset
 *               Input Buffer
 *
 *------------------------------------------------------------------------*/

/*-------------------------------------------------------------------
 *  Module: conv2_buf
 *------------------------------------------------------------------*/
 module conv2_buf #(parameter WIDTH = 12, HEIGHT = 12, DATA_BITS = 12) (
   input                      clk,
   input                      rst_n,
   input                      valid_in,
   input [DATA_BITS - 1:0]    data_in,

   output reg [DATA_BITS - 1:0]   data_out_0,   data_out_1,   data_out_2, 
                                  data_out_3,   data_out_4,   data_out_5,
                                  data_out_6,   data_out_7,   data_out_8,
   output reg valid_out_buf
 );

 localparam FILTER_SIZE = 3;
 
 reg [DATA_BITS - 1:0] buffer [0:WIDTH * FILTER_SIZE - 1];
 reg [DATA_BITS - 1:0] buf_idx;
 reg [4:0] w_idx, h_idx;
 reg [1:0] buf_flag;  // 0 ~ 2
 reg state;

 always @(posedge clk) begin
   if(~rst_n) begin
     buf_idx <= 0;
     w_idx <= 0;
     h_idx <= 0;
     buf_flag <= 0;
     state <= 0;
     valid_out_buf <= 0;
     data_out_0 <= 12'bx;
     data_out_1 <= 12'bx;
     data_out_2 <= 12'bx;
     data_out_3 <= 12'bx;
     data_out_4 <= 12'bx;
     data_out_5 <= 12'bx;
     data_out_6 <= 12'bx;
     data_out_7 <= 12'bx;
     data_out_8 <= 12'bx;
   end else begin
   if(valid_in) begin
     buf_idx <= buf_idx + 1'b1;
     if(buf_idx == WIDTH * FILTER_SIZE - 1) begin // buffer size = 84 = 28(w) * 3(h)
       buf_idx <= 0;
     end

     buffer[buf_idx] <= data_in;  // data input

     // Wait until first 84 input data filled in buffer
     if(!state) begin
       if(buf_idx == WIDTH * FILTER_SIZE - 1) 
        begin
         state <= 1;
        end
     end else begin // valid state
       w_idx <= w_idx + 1'b1; // move right

      if(w_idx == WIDTH - FILTER_SIZE + 1) 
        begin
        valid_out_buf <= 1'b0;  // unvalid area
        end 
      else if(w_idx == WIDTH - 1) 
        begin
        buf_flag <= buf_flag + 1;
      if(buf_flag == FILTER_SIZE - 1) begin
          buf_flag <= 0;
        end

        w_idx <= 0;

      if(h_idx == HEIGHT - FILTER_SIZE) begin // done 1 input read -> 28 * 28
          h_idx <= 0;
          state <= 0;
        end
          h_idx <= h_idx + 1;
        end 
      else if(w_idx == 0) 
        begin
          valid_out_buf <= 1'b1;  // start valid area
        end

      // Buffer Selection -> 3*3
     if(buf_flag == 2'd0) begin
       data_out_0 <= buffer[w_idx];
       data_out_1 <= buffer[w_idx + 1];
       data_out_2 <= buffer[w_idx + 2];

       data_out_3 <= buffer[w_idx + WIDTH];
       data_out_4 <= buffer[w_idx + 1 + WIDTH];
       data_out_5 <= buffer[w_idx + 2 + WIDTH];

       data_out_6 <= buffer[w_idx + WIDTH * 2];
       data_out_7 <= buffer[w_idx + 1 + WIDTH*2];
       data_out_8 <= buffer[w_idx + 2 + WIDTH*2];
     end else if(buf_flag == 2'd1) begin
       data_out_0 <= buffer[w_idx + WIDTH];
       data_out_1 <= buffer[w_idx + 1 + WIDTH];
       data_out_2 <= buffer[w_idx + 2 + WIDTH];
       
       data_out_3 <= buffer[w_idx + WIDTH * 2];
       data_out_4 <= buffer[w_idx + 1 + WIDTH * 2];
       data_out_5 <= buffer[w_idx + 2 + WIDTH * 2];

       data_out_6 <= buffer[w_idx ];
       data_out_7 <= buffer[w_idx + 1];
       data_out_8 <= buffer[w_idx + 2];
     end else if(buf_flag == 2'd2) begin
       data_out_0 <= buffer[w_idx + WIDTH * 2];
       data_out_1 <= buffer[w_idx + 1 + WIDTH * 2];
       data_out_2 <= buffer[w_idx + 2 + WIDTH * 2];

       data_out_3 <= buffer[w_idx];
       data_out_4 <= buffer[w_idx + 1];
       data_out_5 <= buffer[w_idx + 2];

       data_out_6 <= buffer[w_idx + WIDTH];
       data_out_7 <= buffer[w_idx + 1 + WIDTH];
       data_out_8 <= buffer[w_idx + 2 + WIDTH];
   end
 end
 end
 end
 end

endmodule