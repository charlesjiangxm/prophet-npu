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
module aq_f_spsram_128x8 # (
  parameter ADDR_WIDTH = 7,
  parameter DATA_WIDTH = 8
)(
  input  [ADDR_WIDTH-1:0]   A,
  input                     CEN,
  input                     CLK,
  input  [DATA_WIDTH-1:0]   D,
  input                     GWEN,
  input  [DATA_WIDTH-1:0]   WEN,
  output [DATA_WIDTH-1:0]   Q
);

TS1N28HPCPLVTB128X8M4SWBASO U_TS1N28HPCPLVTB128X8M4SWBASO (
  // mode control
  .BIST   (1'b0),  
  .AWT    (1'b0),
  // normal mode
  .SLP    (1'b0),  // sleep mode
  .SD     (1'b0),  // deep sleep mode
  .CLK    (CLK),
  .CEB    (CEN),   // chip enable active low
  .WEB    (~GWEN),  // write enable active low
  .A      (A),
  .D      (D),
  .BWEB   (~WEN), // bit write enable active low
  // BIST mode
  .CEBM   (1'b0),
  .WEBM   (1'b0),
  .AM     ({ADDR_WIDTH{1'b0}}),
  .DM     ({DATA_WIDTH{1'b0}}),
  .BWEBM  ({DATA_WIDTH{1'b0}}),
  // data out
  .Q      (Q)
);


endmodule

