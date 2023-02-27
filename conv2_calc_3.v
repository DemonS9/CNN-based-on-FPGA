/*------------------------------------------------------------------------
 *
 *  Copyright (c) 2021 by Bo Young Kang, All rights reserved.
 *
 *  File name  : conv2_calc_3.v
 *  Written by : Kang, Bo Young
 *  Written on : Oct 14, 2021
 *  Version    : 21.2
 *  Design     : 2nd Convolution Layer for CNN MNIST dataset
 *               Convolution Sum Calculation - 1st Channel
 *
 *------------------------------------------------------------------------*/

/*-------------------------------------------------------------------
 *  Module: conv2_calc_3
 *------------------------------------------------------------------*/

 module conv2_calc_3(
	input clk,
  input rst_n,
  input valid_out_buf,

input signed [11:0] data_out1_0, data_out1_1, data_out1_2, data_out1_3, data_out1_4,
	  data_out1_5, data_out1_6, data_out1_7, data_out1_8,
	
	  data_out2_0, data_out2_1, data_out2_2, data_out2_3, data_out2_4,
	  data_out2_5, data_out2_6, data_out2_7, data_out2_8,
	
	  data_out3_0, data_out3_1, data_out3_2, data_out3_3, data_out3_4,
	  data_out3_5, data_out3_6, data_out3_7, data_out3_8,

	  output wire [13:0] conv_out_calc,
  	output reg valid_out_calc
);

wire signed [19:0] calc_out, calc_out_1, calc_out_2, calc_out_3;

reg signed [7:0] weight_1 [0:8];
reg signed [7:0] weight_2 [0:8];
reg signed [7:0] weight_3 [0:8];

initial begin
	$readmemh("F:/desktop/CNN_1/rtl/conv2_weight_31.txt", weight_1);
	$readmemh("F:/desktop/CNN_1/rtl/conv2_weight_32.txt", weight_2);
	$readmemh("F:/desktop/CNN_1/rtl/conv2_weight_33.txt", weight_3);

end


assign calc_out_1 = data_out1_0*weight_1[0] + data_out1_1*weight_1[1] + data_out1_2*weight_1[2] + data_out1_3*weight_1[3] + data_out1_4*weight_1[4] + 
					data_out1_5*weight_1[5] + data_out1_6*weight_1[6] + data_out1_7*weight_1[7] + data_out1_8*weight_1[8];

assign calc_out_2 = data_out2_0*weight_2[0] + data_out2_1*weight_2[1] + data_out2_2*weight_2[2] + data_out2_3*weight_2[3] + data_out2_4*weight_2[4] + 
					data_out2_5*weight_2[5] + data_out2_6*weight_2[6] + data_out2_7*weight_2[7] + data_out2_8*weight_2[8];

assign calc_out_3 = data_out3_0*weight_3[0] + data_out3_1*weight_3[1] + data_out3_2*weight_3[2] + data_out3_3*weight_3[3] + data_out3_4*weight_3[4] + 
					data_out3_5*weight_3[5] + data_out3_6*weight_3[6] + data_out3_7*weight_3[7] + data_out3_8*weight_3[8];

assign calc_out = calc_out_1 + calc_out_2 + calc_out_3;

assign conv_out_calc = calc_out[19:6]; // 14bit

always @ (posedge clk) begin
	if(~rst_n) begin
		valid_out_calc <= 0;
    //conv_out_calc <= 0;
	end
	else begin
		// Toggling Valid Output Signal
		if(valid_out_buf == 1) begin
			if(valid_out_calc == 1)
				valid_out_calc <= 0;
			else
				valid_out_calc <= 1;
		end
	end
end

endmodule