/*------------------------------------------------------------------------
 *
 *  Copyright (c) 2021 by Bo Young Kang, All rights reserved.
 *
 *  File name  : conv2_layer.v
 *  Written by : Kang, Bo Young
 *  Written on : Oct 11, 2021
 *  Version    : 21.2
 *  Design     : 2nd Convolution Layer for CNN MNIST dataset
 *
 *------------------------------------------------------------------------*/

/*-------------------------------------------------------------------
 *  Module: conv2_layer
 *------------------------------------------------------------------*/
 
 module conv2_layer (
   input clk,
   input rst_n,
   input valid_in,
   input [11:0] max_value_1, max_value_2, max_value_3,
   output [11:0] conv2_out_1, conv2_out_2, conv2_out_3,
   output wire valid_out_conv2
 );

 localparam CHANNEL_LEN = 3;
 ///////////////////////////////////////////
  /*wire [11:0] out_data1_0, out_data1_1, out_data1_2, out_data1_3, out_data1_4,
			out_data1_5, out_data1_6, out_data1_7, out_data1_8, out_data1_9,
			out_data1_10, out_data1_11, out_data1_12, out_data1_13, out_data1_14,
			out_data1_15, out_data1_16, out_data1_17, out_data1_18, out_data1_19,
			out_data1_20, out_data1_21, out_data1_22, out_data1_23, out_data1_24,
			
			out_data2_0, out_data2_1, out_data2_2, out_data2_3, out_data2_4,
			out_data2_5, out_data2_6, out_data2_7, out_data2_8, out_data2_9,
			out_data2_10, out_data2_11, out_data2_12, out_data2_13, out_data2_14,
			out_data2_15, out_data2_16, out_data2_17, out_data2_18, out_data2_19,
			out_data2_20, out_data2_21, out_data2_22, out_data2_23, out_data2_24,
			
			out_data3_0, out_data3_1, out_data3_2, out_data3_3, out_data3_4,
			out_data3_5, out_data3_6, out_data3_7, out_data3_8, out_data3_9,
			out_data3_10, out_data3_11, out_data3_12, out_data3_13, out_data3_14,
			out_data3_15, out_data3_16, out_data3_17, out_data3_18, out_data3_19,
			out_data3_20, out_data3_21, out_data3_22, out_data3_23, out_data3_24;*/
      /////////////////////////////////
 // Channel 1
 wire [11:0] data_out1_0, data_out1_1, data_out1_2, data_out1_3, data_out1_4,
  data_out1_5, data_out1_6, data_out1_7, data_out1_8;
 wire valid_out1_buf;

 // Channel 2
 wire [11:0] data_out2_0, data_out2_1, data_out2_2, data_out2_3, data_out2_4,
  data_out2_5, data_out2_6, data_out2_7, data_out2_8;
 wire valid_out2_buf;

 // Channel 3 
 wire [11:0] data_out3_0, data_out3_1, data_out3_2, data_out3_3, data_out3_4,
  data_out3_5, data_out3_6, data_out3_7, data_out3_8;
 wire valid_out3_buf;

 wire signed [13:0] conv_out_1, conv_out_2, conv_out_3;
 wire valid_out_buf, valid_out_calc_1, valid_out_calc_2, valid_out_calc_3;
 assign valid_out_buf = valid_out1_buf & valid_out2_buf & valid_out3_buf;
 assign valid_out_conv2 = valid_out_calc_1 & valid_out_calc_2 & valid_out_calc_3;

 reg signed [7:0] bias [0:CHANNEL_LEN - 1];
 wire signed [11:0] exp_bias [0:CHANNEL_LEN - 1];

conv2_buf #(.WIDTH(12), .HEIGHT(12), .DATA_BITS(12)) conv2_buf_1(
   .clk(clk),
   .rst_n(rst_n),
   .valid_in(valid_in),
   .data_in(max_value_1),
   .data_out_0(data_out1_0),
   .data_out_1(data_out1_1),
   .data_out_2(data_out1_2),
   .data_out_3(data_out1_3),
   .data_out_4(data_out1_4),
   .data_out_5(data_out1_5),
   .data_out_6(data_out1_6),
   .data_out_7(data_out1_7),
   .data_out_8(data_out1_8),
   .valid_out_buf(valid_out1_buf)
 );

 conv2_buf #(.WIDTH(12), .HEIGHT(12), .DATA_BITS  (12)) conv2_buf_2(
   .clk(clk),
   .rst_n(rst_n),
   .valid_in(valid_in),
   .data_in(max_value_2),
   .data_out_0(data_out2_0),
   .data_out_1(data_out2_1),
   .data_out_2(data_out2_2),
   .data_out_3(data_out2_3),
   .data_out_4(data_out2_4),
   .data_out_5(data_out2_5),
   .data_out_6(data_out2_6),
   .data_out_7(data_out2_7),
   .data_out_8(data_out2_8),
   .valid_out_buf(valid_out2_buf)
 );

 conv2_buf #(.WIDTH(12), .HEIGHT(12), .DATA_BITS(12)) conv2_buf_3(
   .clk(clk),
   .rst_n(rst_n),
   .valid_in(valid_in),
   .data_in(max_value_3),
   .data_out_0(data_out3_0),
   .data_out_1(data_out3_1),
   .data_out_2(data_out3_2),
   .data_out_3(data_out3_3),
   .data_out_4(data_out3_4),
   .data_out_5(data_out3_5),
   .data_out_6(data_out3_6),
   .data_out_7(data_out3_7),
   .data_out_8(data_out3_8),
   .valid_out_buf(valid_out3_buf)
 );

conv2_calc_1 conv2_calc_1(
   .clk(clk),
   .rst_n(rst_n),
   .valid_out_buf(valid_out_buf),
   .data_out1_0(data_out1_0),
   .data_out1_1(data_out1_1),
   .data_out1_2(data_out1_2),
   .data_out1_3(data_out1_3),
   .data_out1_4(data_out1_4),
   .data_out1_5(data_out1_5),
   .data_out1_6(data_out1_6),
   .data_out1_7(data_out1_7),
   .data_out1_8(data_out1_8),
   .data_out2_0(data_out2_0),
   .data_out2_1(data_out2_1),
   .data_out2_2(data_out2_2),
   .data_out2_3(data_out2_3),
   .data_out2_4(data_out2_4),
   .data_out2_5(data_out2_5),
   .data_out2_6(data_out2_6),
   .data_out2_7(data_out2_7),
   .data_out2_8(data_out2_8),
   .data_out3_0(data_out3_0),
   .data_out3_1(data_out3_1),
   .data_out3_2(data_out3_2),
   .data_out3_3(data_out3_3),
   .data_out3_4(data_out3_4),
   .data_out3_5(data_out3_5),
   .data_out3_6(data_out3_6),
   .data_out3_7(data_out3_7),
   .data_out3_8(data_out3_8),
   .conv_out_calc(conv_out_1),
   .valid_out_calc(valid_out_calc_1)   
);

conv2_calc_2 conv2_calc_2(
   .clk(clk),
   .rst_n(rst_n),
   .valid_out_buf(valid_out_buf),
   .data_out1_0(data_out1_0),
   .data_out1_1(data_out1_1),
   .data_out1_2(data_out1_2),
   .data_out1_3(data_out1_3),
   .data_out1_4(data_out1_4),
   .data_out1_5(data_out1_5),
   .data_out1_6(data_out1_6),
   .data_out1_7(data_out1_7),
   .data_out1_8(data_out1_8),
   .data_out2_0(data_out2_0),
   .data_out2_1(data_out2_1),
   .data_out2_2(data_out2_2),
   .data_out2_3(data_out2_3),
   .data_out2_4(data_out2_4),
   .data_out2_5(data_out2_5),
   .data_out2_6(data_out2_6),
   .data_out2_7(data_out2_7),
   .data_out2_8(data_out2_8),
   .data_out3_0(data_out3_0),
   .data_out3_1(data_out3_1),
   .data_out3_2(data_out3_2),
   .data_out3_3(data_out3_3),
   .data_out3_4(data_out3_4),
   .data_out3_5(data_out3_5),
   .data_out3_6(data_out3_6),
   .data_out3_7(data_out3_7),
   .data_out3_8(data_out3_8),
   .conv_out_calc(conv_out_2),
   .valid_out_calc(valid_out_calc_2)   
);

conv2_calc_3 conv2_calc_3(
   .clk(clk),
   .rst_n(rst_n),
   .valid_out_buf(valid_out_buf),
   .data_out1_0(data_out1_0),
   .data_out1_1(data_out1_1),
   .data_out1_2(data_out1_2),
   .data_out1_3(data_out1_3),
   .data_out1_4(data_out1_4),
   .data_out1_5(data_out1_5),
   .data_out1_6(data_out1_6),
   .data_out1_7(data_out1_7),
   .data_out1_8(data_out1_8),
   .data_out2_0(data_out2_0),
   .data_out2_1(data_out2_1),
   .data_out2_2(data_out2_2),
   .data_out2_3(data_out2_3),
   .data_out2_4(data_out2_4),
   .data_out2_5(data_out2_5),
   .data_out2_6(data_out2_6),
   .data_out2_7(data_out2_7),
   .data_out2_8(data_out2_8),
   .data_out3_0(data_out3_0),
   .data_out3_1(data_out3_1),
   .data_out3_2(data_out3_2),
   .data_out3_3(data_out3_3),
   .data_out3_4(data_out3_4),
   .data_out3_5(data_out3_5),
   .data_out3_6(data_out3_6),
   .data_out3_7(data_out3_7),
   .data_out3_8(data_out3_8),
   .conv_out_calc(conv_out_3),
   .valid_out_calc(valid_out_calc_3)   
);

 initial begin
   $readmemh("F:/desktop/CNN_1/rtl/conv2_bias.txt", bias);
 end

 assign exp_bias[0] = (bias[0][7] == 1) ? {4'b1111, bias[0]} : {4'b0000, bias[0]};
 assign exp_bias[1] = (bias[1][7] == 1) ? {4'b1111, bias[1]} : {4'b0000, bias[1]};
 assign exp_bias[2] = (bias[2][7] == 1) ? {4'b1111, bias[2]} : {4'b0000, bias[2]};

 assign conv2_out_1 = conv_out_1[13:1] + exp_bias[0];
 assign conv2_out_2 = conv_out_2[13:1] + exp_bias[1];
 assign conv2_out_3 = conv_out_3[13:1] + exp_bias[2];
 
 endmodule