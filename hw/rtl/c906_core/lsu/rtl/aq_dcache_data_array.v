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

// &ModuleBeg; @20
module aq_dcache_data_array(
  cp0_lsu_icg_en,
  data_cen,
  data_clk_en,
  data_din,
  data_dout,
  data_gwen,
  data_idx,
  data_wen,
  forever_cpuclk,
  pad_yy_icg_scan_en
);

// &Ports; @21
input           cp0_lsu_icg_en;    
input           data_cen;          
input           data_clk_en;       
input   [63:0]  data_din;          
input           data_gwen;         
input   [13:0]  data_idx;          
input   [63:0]  data_wen;          
input           forever_cpuclk;    
input           pad_yy_icg_scan_en; 
output  [63:0]  data_dout;         

// &Regs; @22

// &Wires; @23
wire            cp0_lsu_icg_en;    
wire            data_cen;          
wire            data_clk;          
wire            data_clk_en;       
wire    [63:0]  data_din;          
wire    [63:0]  data_dout;         
wire            data_gwen;         
wire    [13:0]  data_idx;          
wire    [63:0]  data_wen;          
wire            forever_cpuclk;    
wire            pad_yy_icg_scan_en; 

//==========================================================
//                 Instance of Gated Cell
//==========================================================
gated_clk_cell  x_dcache_data_gated_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (data_clk          ),
  .external_en        (1'b0              ),
  .global_en          (1'b1              ),
  .local_en           (data_clk_en       ),
  .module_en          (cp0_lsu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

//==========================================================
//              Instance dcache array
//==========================================================
aq_spsram_1024x64  x_aq_spsram_1024x64 (
  .A              (data_idx[12:3]),
  .CEN            (data_cen      ),
  .CLK            (data_clk      ),
  .D              (data_din      ),
  .GWEN           (data_gwen     ),
  .Q              (data_dout     ),
  .WEN            (data_wen      )
);

endmodule


