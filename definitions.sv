package definitions;

parameter bitsRequired = 3;

// ALU instruction map
const logic [bitsRequired-1:0] kADD = 3'd0;
const logic [bitsRequired-1:0] kSUB = 3'd1;
const logic [bitsRequired-1:0] kAND = 3'd2;
const logic [bitsRequired-1:0] kSLL = 3'd3;
const logic [bitsRequired-1:0] kSRL = 3'd4;
const logic [bitsRequired-1:0] kXOR = 3'd5;

// ALU Operation Mnemonics
typedef enum logic[2:0] {
	ADD = 3'd0,
	SUB = 3'd1,
	AND = 3'd2,
	SLL = 3'd3,
	SRL = 3'd4,
	XOR = 3'd5
} ALUOp_mne;

endpackage