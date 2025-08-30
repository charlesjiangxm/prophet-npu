/*Copyright 2020-2021 T-Head Semiconductor Co., Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// &ModuleBeg; @22
module aq_spsram_2048x32xn #(
  parameter N = 4
)(
  input   [N*11   -1:0]  A,
  input   [N      -1:0]  CEN,
  input   [N      -1:0]  CLK,
  input   [N*32   -1:0]  D,
  input   [N      -1:0]  GWEN,
  input   [N*32   -1:0]  WEN,
  output  [N*32   -1:0]  Q
);

genvar i;

wire [10:0] A_2d    [N-1:0];
wire        CEN_2d  [N-1:0];
wire        CLK_2d  [N-1:0];
wire [31:0] D_2d    [N-1:0];
wire        GWEN_2d [N-1:0];
wire [31:0] WEN_2d  [N-1:0];
wire [31:0] Q_2d    [N-1:0];

generate
for (i = 0; i < N; i = i + 1) begin : TWO_DIM_GEN
  // wires
  assign A_2d[i]        = A[i*11 +: 11];
  assign CEN_2d[i]      = CEN[i];
  assign CLK_2d[i]      = CLK[i];
  assign D_2d[i]        = D[i*32 +: 32];
  assign GWEN_2d[i]     = GWEN[i];
  assign WEN_2d[i]      = WEN[i*32 +: 32];
  assign Q[i*32 +: 32]  = Q_2d[i];

  // instantiates memory
  aq_spsram_2048x32 x_aq_spsram_2048x32 (
    .A      (A_2d[i]),
    .CEN    (CEN_2d[i]),
    .CLK    (CLK_2d[i]),
    .D      (D_2d[i]),
    .GWEN   (GWEN_2d[i]),
    .Q      (Q_2d[i]),
    .WEN    (WEN_2d[i])
  );
end
endgenerate

endmodule
