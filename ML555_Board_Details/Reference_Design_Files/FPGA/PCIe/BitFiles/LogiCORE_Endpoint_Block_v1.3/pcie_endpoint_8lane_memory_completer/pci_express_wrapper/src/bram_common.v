//------------------------------------------------------------------------------
//
// Copyright (C) 2006, Xilinx, Inc. All Rights Reserved.
//
// This file is owned and controlled by Xilinx and must be used solely
// for design, simulation, implementation and creation of design files
// limited to Xilinx devices or technologies. Use with non-Xilinx
// devices or technologies is expressly prohibited and immediately
// terminates your license.
//
// Xilinx products are not intended for use in life support
// appliances, devices, or systems. Use in such applications is
// expressly prohibited.
//
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor      : Xilinx
// \   \   \/     Version     : 1.3
//  \   \         Application : Generated by Xilinx PCI Express Wizard
//  /   /         Filename    : bram_common.v
// /___/   /\     Module      : bram_common 
// \   \  /  \
//  \___\/\___\
//
//------------------------------------------------------------------------------
`timescale 1 ns / 10 ps

module bram_common #
(
    parameter NUM_BRAMS      = 16,
    parameter ADDR_WIDTH     = 13,
    parameter READ_LATENCY   = 3,
    parameter WRITE_LATENCY  = 1,
    parameter WRITE_PIPE     = 0,
    parameter READ_ADDR_PIPE = 0,
    parameter READ_DATA_PIPE = 0, 
    parameter BRAM_OREG      = 1 //parameter to enable use of output register on BRAM
) 

(
    input                         clka, // Port A Clk,  
    input                         ena,  // Port A enable
    input                         wena, // read/write enable
    input    [63:0]               dina, // Port A Write data 
    output   [63:0]               douta,// Port A Write data 
    input    [ADDR_WIDTH - 1:0]   addra,// Write Address for TL RX Buffers,
    input                         clkb, // Port B Clk,  
    input                         enb,  // Port B enable
    input                         wenb, // read/write enable
    input    [63:0]               dinb, // Port B Write data 
    output   [63:0]               doutb,// Port B Write data 
    input    [ADDR_WIDTH - 1:0]   addrb // Write Address for TL RX Buffers,
);

  
 
    // width of the BRAM: used bits
    localparam BRAM_WIDTH = 64/NUM_BRAMS; 
    // unused bits of the databus
    localparam UNUSED_DATA = 32 - BRAM_WIDTH;
    // unused bits of address at lower end. will be tied to 0
    // the width of the BRAM determines how many address bits to skip
    // on the lower order of the address:
    // BRAM WIDTH     SKIP BITS
    // 64             6
    // 32             5
    // 16             4
    // 8              3
    // 4              2
    // 2              1
    // 1              0

    parameter UNUSED_ADDR = (BRAM_WIDTH == 64) ? 6: (BRAM_WIDTH == 32)
                                               ? 5: (BRAM_WIDTH == 16)
                                               ? 4: (BRAM_WIDTH == 8) 
                                               ? 3: (BRAM_WIDTH == 4) 
                                               ? 2: (BRAM_WIDTH == 2)
                                               ? 1:0;
 
     parameter BRAM_WIDTH_PARITY = (BRAM_WIDTH == 32) ? 36: (BRAM_WIDTH == 16)? 18: (BRAM_WIDTH == 8)? 9: BRAM_WIDTH; 
                           
    //used address bits. This will be used to determine the slice of the 
    //address bits from the upper level
    localparam USED_ADDR = 15 - UNUSED_ADDR;
    
    wire [31:0]ex_dat_a = 32'b0;
    wire [31:0]ex_dat_b = 32'b0;
   
    generate
    genvar i;
    if (NUM_BRAMS == 1)
        begin: generate_sdp
        // single BRAM implies Simple Dual Port and width of 64
        RAMB36SDP
        #(
            .DO_REG (BRAM_OREG)
        )  
        ram_sdp_inst 
        (
            .DI (dina),
            .WRADDR (addra[8:0]),
            .WE ({8{wena}}),
            .WREN (ena),
            .WRCLK (clka),
            .DO (doutb),
            .RDADDR (addrb[8:0]),
            .RDEN (enb),
            .REGCE (1'b1),
            .SSR (1'b0),
            .RDCLK (clkb),

            .DIP (8'h00),
            .DBITERR(),
            .SBITERR(),
            .DOP(),
            .ECCPARITY()   
        );
        end
    else  if (NUM_BRAMS ==2)
    for (i=0; i < NUM_BRAMS; i = i+1) 
            begin:generate_tdp2
            RAMB36
            #(
                .READ_WIDTH_A (BRAM_WIDTH_PARITY),
                .WRITE_WIDTH_A (BRAM_WIDTH_PARITY),
                .READ_WIDTH_B (BRAM_WIDTH_PARITY),
                .WRITE_WIDTH_B (BRAM_WIDTH_PARITY),
                .WRITE_MODE_A("READ_FIRST"),
                .WRITE_MODE_B("READ_FIRST"),
                .DOB_REG (BRAM_OREG)
            )  
            ram_tdp2_inst
            (
                .DOA       (douta[(i+1)*BRAM_WIDTH-1: i*BRAM_WIDTH]),
                .DIA       (dina[(i+1)*BRAM_WIDTH-1: i*BRAM_WIDTH]),
                .ADDRA     ({ 1'b0, addra[USED_ADDR - 1:0], {UNUSED_ADDR{1'b0}} }),
                .WEA       ({4{wena}}),
                .ENA       (ena),
                .CLKA      (clka),
                .DOB       (doutb[(i+1)*BRAM_WIDTH-1: i*BRAM_WIDTH]),
                .DIB       (dinb [(i+1)*BRAM_WIDTH-1: i*BRAM_WIDTH]),
                .ADDRB     ({ 1'b0, addrb[USED_ADDR - 1:0], {UNUSED_ADDR{1'b0}} }),
                .WEB       (4'b0),
                .ENB       (enb),
                .REGCEB    (1'b1),
                .REGCEA    (1'b1),
                .SSRA      (1'b0),
                .SSRB      (1'b0),
                .CLKB      (clkb)
            ); 
            end
    else    
    for (i=0; i < NUM_BRAMS; i = i+1) 
        begin:generate_tdp
        RAMB36
        #(
            .READ_WIDTH_A (BRAM_WIDTH_PARITY),
            .WRITE_WIDTH_A (BRAM_WIDTH_PARITY),
            .READ_WIDTH_B (BRAM_WIDTH_PARITY),
            .WRITE_WIDTH_B (BRAM_WIDTH_PARITY),
            .WRITE_MODE_A("READ_FIRST"),
            .WRITE_MODE_B("READ_FIRST"),
            .DOB_REG (BRAM_OREG)
        )  
        ram_tdp_inst
        (
            .DOA       ({ ex_dat_a[UNUSED_DATA-1:0], douta[(i+1)*BRAM_WIDTH-1: i*BRAM_WIDTH] }),
            .DIA       ({ {UNUSED_DATA{1'b0}} ,dina[(i+1)*BRAM_WIDTH-1: i*BRAM_WIDTH] }),
            .ADDRA     ({ 1'b0, addra[USED_ADDR - 1:0], {UNUSED_ADDR{1'b0}} }),
            .WEA       ({4{wena}}),
            .ENA       (ena),
            .CLKA      (clka),
            .DOB       ({ ex_dat_b[UNUSED_DATA-1:0], doutb[(i+1)*BRAM_WIDTH-1: i*BRAM_WIDTH] }),
            .DIB       ({ {UNUSED_DATA{1'b0}}, dinb [(i+1)*BRAM_WIDTH-1: i*BRAM_WIDTH] }),
            .ADDRB     ({ 1'b0, addrb[USED_ADDR - 1:0], {UNUSED_ADDR{1'b0}} }),
            .WEB       (4'b0),
            .ENB       (enb),
            .REGCEB    (1'b1),
            .REGCEA    (1'b1),
            .SSRA      (1'b0),
            .SSRB      (1'b0),
            .CLKB      (clkb)
        ); 
        end
   endgenerate

  //NUM_BRAMS =  2;  BRAM_WIDTH = 32; UNUSED_DATA = 0;   USED_ADDR = 10; UNUSED_ADDR = 5
  //NUM_BRAMS =  4;  BRAM_WIDTH = 16; UNUSED_DATA = 16;  USED_ADDR = 11; UNUSED_ADDR = 4
  //NUM_BRAMS =  8;  BRAM_WIDTH = 8 ; UNUSED_DATA = 24;  USED_ADDR = 12; UNUSED_ADDR = 3
  //NUM_BRAMS = 16;  BRAM_WIDTH = 4 ; UNUSED_DATA = 28;  USED_ADDR = 13; UNUSED_ADDR = 2
  
  // NUM_BRAMS = 2  =>  2 BRAMS of config  1024 x 32,  depth of  1k, addr_width [14:5]
  // NUM_BRAMS = 4  =>  4 BRAMS of config  2048 x 16,  depth of  2k, addr_width [14:4]
  // NUM_BRAMS = 8  =>  8 BRAMS of config  4096 x 8 ,  depth of  4k, addr_width [14:3]
  // NUM_BRAMS = 16 => 16 BRAMS of config  8192 x 4 ,  depth of  8k, addr_width [14:2]
  
endmodule