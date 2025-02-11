`include "addr32bit.v"
`include "ALU_Control.v"
`include "ALU_Module.v"
`include "controlUnit_MIPS.v"
`include "EX_MEM_register.v"
`include "ID_EX_register.v"
`include "IF_ID_register.v"
`include "InstMem.v"
`include "JumpAddressGeneration.v"
`include "leftShift2Bit.v"
`include "Mem_WB_register.v"
`include "Memory_MIPS.v"
`include "mux2.v"
`include "progCounter.v"
`include "regFile.v"
`include "stallControlUnit.v"
`include "stallModule.v"
`include "valueExtender.v"

module Processor_MIPS(
    input clk,
    input reset
);

////////////////////////////////////////////////////////////
// Wires for pipeline stages
wire [31:0] instrWireID, nextPCID;
wire [31:0] instrWireEX, nextPCEX, readData1EX, readData2EX, NPC1EX, outSignEXTEX;
wire [4:0] writeRegWireEX;
wire [31:0] instrWireMEM, readData2MEM, ALUResultMEM, nextPCBranchMEM, NPC1MEM, nextPCMEM;
wire [4:0] writeRegWireMEM;
wire ZeroOutMEM;
wire [31:0] instrWireWB, ALUResultWB, outputDataWB;
wire [4:0] writeRegWireWB;

////////////////////////////////////////////////////////////
// Control signals for pipeline stages
wire RegDestEX, RegWriteEX, ALUSrcEX, MemReadEX, MemWriteEX, MemToRegEX, BranchEX, JumpEX;
wire [3:0] ALUCtrlEX;
wire RegDestMEM, RegWriteMEM, ALUSrcMEM, MemReadMEM, MemWriteMEM, MemToRegMEM, BranchMEM, JumpMEM;
wire [3:0] ALUCtrlMEM;
wire RegDestWB, RegWriteWB, ALUSrcWB, MemReadWB, MemWriteWB, MemToRegWB, BranchWB, JumpWB;
wire [3:0] ALUCtrlWB;

////////////////////////////////////////////////////////////
// Hazard and stall control signals
wire dataStall;
wire controlStall;

////////////////////////////////////////////////////////////
// Instruction Fetch (IF) stage
wire [31:0] PC;
wire [31:0] nextPC;
wire [31:0] instrWire;
wire [31:0] instrWireHazard;
wire [31:0] instrWireIDhazard; ;

InstMem u0(
    .instRead(1'b1),
    .instAddress(PC),
    .InstRead(instrWire)
);

addr32bit u4(
    .inp_1(PC),
    .inp_2(32'b100),
    .out_addr(nextPC)
);

////////////////////////////////////////////////////////////
// Stall and hazard control
stallUnit u90(
    .clk(clk),
    .reset(reset),
    .Rs(instrWireID[25:21]),
    .Rt(instrWireID[20:16]),
    .InstOpCode(instrWireID[31:26]),
    .IR_ID(instrWireID),
    .IR_EX(instrWireEX),
    .IR_MEM(instrWireMEM),
    .regWB(writeRegWireWB),
    .WWB(RegWriteWB),
    .IR_WB(instrWireWB),
    .stallFlag(dataStall)
);

stallControlUnit u92(
    .clk(clk),
    .reset(reset),
    .Operand1(instrWireID[31:26]),
    .Operand2(instrWireEX[31:26]),
    .Operand3(instrWireMEM[31:26]),
    .stallFlag(controlStall)
);

nopSet u91(
    .clk(clk),
    .reset(reset),
    .S1(dataStall),
    .S2(controlStall),
    .OldF(instrWire),
    .OldD(instrWireID),
    .NewF(instrWireHazard),
    .NewD(instrWireIDhazard)
);

////////////////////////////////////////////////////////////
// Instruction Decode (ID) stage
controlUnit u1(
    .clk(clk),
    .reset(reset),
    .InstOpCode(instrWireIDhazard[31:26]),
    .ALUOperation(instrWireIDhazard[5:0]),
    .IR(instrWireIDhazard),
    .ALUOpCode(ALUCtrlEX),
    .regDestFlag(RegDest),
    .regWriteFlag(RegWrite),
    .ALUSrcFlag(ALUSrc),
    .MemReadFlag(MemRead),
    .MemWriteFlag(MemWrite),
    .MemToRegFlag(MemToReg),
    .BranchFlag(Branch),
    .JumpFlag(Jump)
);

wire [4:0] writeRegWire;

mux2 u10A(RegDest, instrWireID[16], instrWireID[11], writeRegWire[0]);
mux2 u10B(RegDest, instrWireID[17], instrWireID[12], writeRegWire[1]);
mux2 u10C(RegDest, instrWireID[18], instrWireID[13], writeRegWire[2]);
mux2 u10D(RegDest, instrWireID[19], instrWireID[14], writeRegWire[3]);
mux2 u10E(RegDest, instrWireID[20], instrWireID[15], writeRegWire[4]);

wire [31:0] readData1, readData2;
wire [31:0] WBData;

regFile u11(
    .clk(clk),
    .regWriteControl(RegWriteWB),
    .readRegAddress1(instrWireID[25:21]),
    .readRegAddress2(instrWireID[20:16]),
    .writeRegAddress(writeRegWireWB),
    .writeRegData(WBData),
    .readData1(readData1),
    .readData2(readData2)
);

////////////////////////////////////////////////////////////
// Program Counter Update
progCounterRegWrite u9(
    .clk(clk),
    .reset(reset),
    .instAddress_in(nextPC),
    .instAddress_out(PC)
);

////////////////////////////////////////////////////////////
// Pipeline Registers
IF_ID_register p1(
    .clk(clk),
    .reset(reset),
    .instrOutInput(instrWireHazard),
    .nextPCInput(nextPC),
    .instrOutOutput(instrWireID),
    .nextPCOutput(nextPCID),
    .IFIDControl(dataStall)
);

ID_EX_register p2(
    .clk(clk),
    .reset(reset),
    .regDestsFlagInput(RegDest),
    .regWriteFlagInput(RegWrite),
    .ALUSrcInput(ALUSrc),
    .MemReadFlagInput(MemRead),
    .MemWriteFlagInput(MemWrite),
    .MemToRegInput(MemToReg),
    .BranchFlagInput(Branch),
    .JumpFlagInput(Jump),
    .ALUControlInput(ALUOp),
    .IRInput(instrWireID),
    .PCInput(nextPCID),
    .ARegisterInput(readData1),
    .BRegisterInput(readData2),
    .regDestAddressInput(writeRegWire),
    .BranchInput(outSignEXT),
    .JumpInput(NPC1),
    .regDestsFlagOutput(RegDestEX),
    .regWriteFlagOutput(RegWriteEX),
    .ALUSrcOutput(ALUSrcEX),
    .MemReadFlagOutput(MemReadEX),
    .MemWriteFlagOutput(MemWriteEX),
    .MemToRegOutput(MemToRegEX),
    .BranchFlagOutput(BranchEX),
    .JumpFlagOutput(JumpEX),
    .ALUControlOutput(ALUCtrlEX),
    .IROutput(instrWireEX),
    .PCOutput(nextPCEX),
    .ARegisterOutput(readData1EX),
    .BRegisterOutput(readData2EX),
    .regDestAddressOutput(writeRegWireEX),
    .BranchOutput(outSignEXTEX),
    .JumpOutput(NPC1EX),
    .controlSignal(1'b1)
);

EX_MEM_register p3(
    .clk(clk),
    .reset(reset),
    .regDestsFlagInput(RegDestEX),
    .regWriteFlagInput(RegWriteEX),
    .ALUSrcInput(ALUSrcEX),
    .memReadFlagInput(MemReadEX),
    .memWriteFlagInput(MemWriteEX),
    .MemToRegInput(MemToRegEX),
    .BranchsFlagInput(BranchEX),
    .JumpsFlagInput(JumpEX),
    .ALUControlInput(ALUCtrlEX),
    .IRInput(instrWireEX),
    .PCInput(nextPCEX),
    .BInput(readData2EX),
    .ResultInput(ALUResult),
    .regDestAddressInput(writeRegWireEX),
    .BranchAddressInput(nextPCBranch),
    .JumpAddressInput(NPC1EX),
    .ZeroFlagInput(ZeroOut),
    .regDestsFlagOutput(RegDestMEM),
    .regWriteFlagOutput(RegWriteMEM),
    .ALUSrcOutput(ALUSrcMEM),
    .memReadFlagOutput(MemReadMEM),
    .memWriteFlagOutput(MemWriteMEM),
    .MemToRegOutput(MemToRegMEM),
    .BranchsFlagOutput(BranchMEM),
    .JumpsFlagOutput(JumpMEM),
    .ALUControlOutput(ALUCtrlMEM),
    .IROutput(instrWireMEM),
    .PCOutput(nextPCMEM),
    .BOutput(readData2MEM),
    .ResultOutput(ALUResultMEM),
    .regDestAddressOutput(writeRegWireMEM),
    .BranchAddressOutput(nextPCBranchMEM),
    .JumpAddressOutput(NPC1MEM),
    .ZeroFlagOutput(ZeroOutMEM),
    .controlSignal(1'b1)
);

MEM_WB_register p4(
    .clk(clk),
    .reset(reset),
    .regDestsFlagInput(RegDestMEM),
    .regWriteFlagInput(RegWriteMEM),
    .ALUSrcInput(ALUSrcMEM),
    .MemToRegInput(MemToRegMEM),
    .BranchsFlagInput(BranchMEM),
    .JumpsFlagInput(JumpMEM),
    .ALUControlInput(ALUCtrlMEM),
    .IRInput(instrWireMEM),
    .BInput(outputData),
    .ResultInput(ALUResultMEM),
    .regDestAddressInput(writeRegWireMEM),
    .regDestsFlagOutput(RegDestWB),
    .regWriteFlagOutput(RegWriteWB),
    .ALUSrcOutput(ALUSrcWB),
    .MemToRegOutput(MemToRegWB),
    .BranchsFlagOutput(BranchWB),
    .JumpsFlagOutput(JumpWB),
    .ALUControlOutput(ALUCtrlWB),
    .IROutput(instrWireWB),
    .BOutput(outputDataWB),
    .ResultOutput(ALUResultWB),
    .regDestAddressOutput(writeRegWireWB),
    .controlSignal(1'b1)
);

endmodule