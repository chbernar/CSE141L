transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Christhoper\ Bernard/Desktop/CSE141L/Lab2 {C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab2/top_module.sv}
vlog -sv -work work +incdir+C:/Users/Christhoper\ Bernard/Desktop/CSE141L/Lab2 {C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab2/InstructionROM.sv}
vlog -sv -work work +incdir+C:/Users/Christhoper\ Bernard/Desktop/CSE141L/Lab2 {C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab2/Register.sv}
vlog -sv -work work +incdir+C:/Users/Christhoper\ Bernard/Desktop/CSE141L/Lab2 {C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab2/definitions.sv}
vlog -sv -work work +incdir+C:/Users/Christhoper\ Bernard/Desktop/CSE141L/Lab2 {C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab2/InstructionFetch.sv}
vlog -sv -work work +incdir+C:/Users/Christhoper\ Bernard/Desktop/CSE141L/Lab2 {C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab2/DataMemory.sv}
vlog -sv -work work +incdir+C:/Users/Christhoper\ Bernard/Desktop/CSE141L/Lab2 {C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab2/lut.sv}
vlog -sv -work work +incdir+C:/Users/Christhoper\ Bernard/Desktop/CSE141L/Lab2 {C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab2/LUT_Reg.sv}
vlog -sv -work work +incdir+C:/Users/Christhoper\ Bernard/Desktop/CSE141L/Lab2 {C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab2/MuxALUSrcA.sv}
vlog -sv -work work +incdir+C:/Users/Christhoper\ Bernard/Desktop/CSE141L/Lab2 {C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab2/MuxALUSrcB.sv}
vlog -sv -work work +incdir+C:/Users/Christhoper\ Bernard/Desktop/CSE141L/Lab2 {C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab2/MuxMemAddress.sv}
vlog -sv -work work +incdir+C:/Users/Christhoper\ Bernard/Desktop/CSE141L/Lab2 {C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab2/MuxMemDataIn.sv}
vlog -sv -work work +incdir+C:/Users/Christhoper\ Bernard/Desktop/CSE141L/Lab2 {C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab2/MuxRegWriteInput.sv}
vlog -sv -work work +incdir+C:/Users/Christhoper\ Bernard/Desktop/CSE141L/Lab2 {C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab2/ALU.sv}
vlog -sv -work work +incdir+C:/Users/Christhoper\ Bernard/Desktop/CSE141L/Lab2 {C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab2/ControlDecoder.sv}

