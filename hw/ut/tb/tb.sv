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
`define NOISA

`timescale 1ns/1ps
`define CLK_PERIOD          1
`define TCLK_PERIOD         4
`define CHK_RETIRE_CYC      50000
`define MAX_RUN_TIME        100000000000

`define SOC_TOP             tb.x_soc
`define CPU_TOP             tb.x_soc.x_c906_wrap.x_cpu_top
`define RTL_MEM             tb.x_soc.x_axi_slave_warp.x_axi_slave128.x_f_spsram_16384x128
`define MEM_DEP             16384
`define MEM_WID             128   

`define tb_retire0          `CPU_TOP.core0_pad_retire
`define retire0_pc          `CPU_TOP.core0_pad_retire_pc[39:0]
`define CPU_CLK             `CPU_TOP.pll_core_cpuclk
`define CPU_RST             `CPU_TOP.pad_cpu_rst_b

module tb();
    // ----------
    // variable declaration
    // ----------
    integer         i;
    static integer  FILE;
    reg             clk;
    reg             jclk;
    reg             rst_b;
    
    reg             jrst_b;
    wire            jtg_tms;
    wire            jtg_tdi;
    wire            jtg_tdo;

    wire            uart0_sin;
    wire            uart0_sout;

    bit [`MEM_WID/4 -1:0] mem_inst_tmp [`MEM_DEP*4]; // inst and data is in 32b
    bit [`MEM_WID/4 -1:0] mem_data_tmp [`MEM_DEP*4];

    reg [32         -1:0] num_retire_instr;
    reg [32         -1:0] sim_cyc_cnt;

    reg [40         -1:0] cpu_awaddr;
    reg [4          -1:0] cpu_awlen;
    reg [16         -1:0] cpu_wstrb;
    reg                   cpu_wvalid;
    reg [64         -1:0] value0;
    reg [64         -1:0] value1;

    // ----------
    // generate clock, reset and JTAG clock
    // ----------
    initial begin
        clk =0;
        forever begin
            #(`CLK_PERIOD/2) clk = ~clk;
        end
    end
    
    initial begin
        jclk = 0;
        forever begin
            #(`TCLK_PERIOD/2) jclk = ~jclk;
        end
    end

    initial begin
        rst_b = 1;
        #100;
        rst_b = 0;
        #100;
        rst_b = 1;
    end

    initial begin
        jrst_b = 1;
        #400;
        jrst_b = 0;
        #400;
        jrst_b = 1;
    end

    // ----------
    // load the program into memory
    // ----------
    initial begin
        // initialize the memory
        $display("\t********* Init Program and Wipe Memory to 0 *********");
        for(i = 0; i < `MEM_DEP; i = i + 1) begin
            `RTL_MEM.mem[i] = `MEM_WID'd0;
        end
        // load instruction and data into temporary memory
        $display("\t********* Read program                      *********");
        $readmemh("inst.pat", mem_inst_tmp);
        $readmemh("data.pat", mem_data_tmp);
        $display("\t********* Load instr. to the unified memory *********");
        load_memory_data(mem_inst_tmp, 0);
        $display("\t********* Load data to the unified memory   *********");
        load_memory_data(mem_data_tmp, `MEM_DEP/4);
    end

    // ----------
    // simulation timeout control
    // ----------
    initial begin
        #`MAX_RUN_TIME;
        $display("**********************************************");
        $display("*   meeting max simulation time, stop!       *");
        $display("**********************************************");
        FILE = $fopen("run_case.report","a");
        $fwrite(FILE,"TEST FAIL");
        $finish;
    end

    // ----------
    // early termination: periodicalaly check if there are instructions retired
    // ----------
    always @(posedge clk or negedge rst_b) begin
        if(!rst_b)
            sim_cyc_cnt[31:0] <= 32'b0;
        else // counter stores the simulation total cycles
            sim_cyc_cnt[31:0] <= sim_cyc_cnt[31:0] + 32'd1;
    end
    
    always @(posedge clk or negedge rst_b) begin
        if(!rst_b) begin // reset to zero
            num_retire_instr[31:0] <= 32'b0;
        end else if((sim_cyc_cnt[31:0] % `CHK_RETIRE_CYC) == 0) begin // check and reset retire_inst_in_period every 50000 cycles
            // check if 0 number of instructions are retired.
            if(num_retire_instr[31:0] == 0)begin
                $display("*************************************************************");
                $display("* Error: There is no instructions retired in the last %d cycles! *", `CHK_RETIRE_CYC);
                $display("*              Simulation Fail and Finished!                *");
                $display("*************************************************************");
                #10;
                FILE = $fopen("run_case.report","a");
                $fwrite(FILE,"TEST FAIL");
                $fclose(FILE);
                $finish;
            end
            // reset the number of retired instructions
            num_retire_instr[31:0] <= 32'b0;
        end else if(`tb_retire0) begin
            num_retire_instr[31:0] <= num_retire_instr[31:0] + 32'd1;
        end
    end
    
    // ----------
    // get the running status from the DUT
    // ----------
    always @(posedge clk) begin
        cpu_awlen[3:0]   <= `CPU_TOP.biu_pad_awlen[3:0];
        cpu_awaddr[31:0] <= `CPU_TOP.biu_pad_awaddr[31:0];
        cpu_wvalid       <= `CPU_TOP.biu_pad_wvalid;
        cpu_wstrb        <= `CPU_TOP.biu_pad_wstrb;
        value0           <= `CPU_TOP.x_aq_top_0.x_aq_core.x_aq_rtu_top.x_aq_rtu_wb.wb_wb0_data[63:0];
        value1           <= `CPU_TOP.x_aq_top_0.x_aq_core.x_aq_rtu_top.x_aq_rtu_wb.wb_wb1_data[63:0];
    end
    
    always @(posedge clk) begin
        if((value0 == 64'h444333222) || (value1 == 64'h444333222)) begin
            $display("\n**********************************************");
            $display("*    simulation finished successfully        *");
            $display("**********************************************");
            #10;
            FILE = $fopen("run_case.report","a");
            $fwrite(FILE,"TEST PASS");
            $fclose(FILE);
            $finish;
        end else if ((value0 == 64'h2382348720) || (value1 == 64'h2382348720)) begin
            $display("**********************************************");
            $display("*    simulation finished with error          *");
            $display("**********************************************");
            #10;
            FILE = $fopen("run_case.report","a");
            $fwrite(FILE,"TEST FAIL");
            $fclose(FILE);
            $finish;
        end else if((cpu_awlen[3:0] == 4'b0) && (cpu_awaddr[31:0] == 32'h90000000) && cpu_wvalid) begin
            FILE = $fopen("run_case.report","a");
            if(cpu_wstrb[15:0] == 16'hf) begin
                $write("%c", `CPU_TOP.biu_pad_wdata[7:0]);
                $fwrite(FILE,"%c",`CPU_TOP.biu_pad_wdata[7:0]);
                $fclose(FILE);
            end else if(cpu_wstrb[15:0] == 16'hf0) begin
                $write("%c", `CPU_TOP.biu_pad_wdata[39:32]);
                $fwrite(FILE,"%c",`CPU_TOP.biu_pad_wdata[39:32]);
                $fclose(FILE);
            end else if(cpu_wstrb[15:0] == 16'hf00) begin
                $write("%c", `CPU_TOP.biu_pad_wdata[71:64]);
                $fwrite(FILE,"%c",`CPU_TOP.biu_pad_wdata[71:64]);
                $fclose(FILE);
            end else if(cpu_wstrb[15:0] == 16'hf000) begin
                $write("%c", `CPU_TOP.biu_pad_wdata[103:96]);
                $fwrite(FILE,"%c",`CPU_TOP.biu_pad_wdata[103:96]);
                $fclose(FILE);
            end
        end
        
    end

    initial begin
        $display("######time:%d, Dump start######",$time);
        $fsdbDumpvars();
    end
    
    // ----------
    // instantiate the DUT
    // ----------
    assign jtg_tdi      = 1'b0;
    assign jtg_tms      = 1'b0;
    assign uart0_sin    = 1'b1;
    
    uart_mnt x_uart_mnt();
    soc x_soc(
    .i_pad_clk        (clk),
    .i_pad_rst_b      (rst_b),
    .i_pad_jtg_nrst_b (rst_b),
    .i_pad_jtg_tclk   (jclk),
    .i_pad_jtg_tdi    (jtg_tdi),
    .i_pad_jtg_tms    (jtg_tms),
    .i_pad_jtg_trst_b (jrst_b),
    .o_pad_jtg_tdo    (jtg_tdo),
    .i_pad_uart_rx    (uart0_sin),
    .o_pad_uart_tx    (uart0_sout)
    );
    
    // -----------------------------------------
    // Function to load memory data with endianness conversion
    // -----------------------------------------
    function void load_memory_data(
        input bit [`MEM_WID/4 -1:0] mem_tmp [`MEM_DEP*4],
        input integer base_offset
        );
        bit [`MEM_WID-1:0] mem_data;
        integer i, j;
        
        for (i = 0; i < `MEM_DEP/4; i = i + 1) begin
            // convert each inst/data width (32b) to little endian
            mem_data = {mem_tmp[i*4+0], mem_tmp[i*4+1], mem_tmp[i*4+2], mem_tmp[i*4+3]};
            // convert each word (8b) to little endian
            for (j = 0; j < `MEM_WID/8; j = j + 1) begin
                `RTL_MEM.mem[i+base_offset][j*8 +: 8] = mem_data[(`MEM_WID/8-1-j)*8 +: 8];
            end
        end
    endfunction
    
endmodule
