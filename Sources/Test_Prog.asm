.text
	addi s0, zero, 35
	addi s1, zero, 15
	xori s2, s1, 0xAA
	ori s3, s0, 0xC
	andi s4, s2, 0xF0
	slli s5, s3, 0x1F
	srli s6, s5, 2
	srai s7, s5, 2
	slti s8, s7, 0xA1
	sltiu s9, s7, 0xA1
main:
	mul t6, s2, s4
	add s10, s6, s4
	sub s11, s8, s9
	xor s0, s10, s11
	or s1, s0, s11
	and s2, s1, s0
	sll s3, s2, s3
	srl s4, s3, s2
	sra s5, s4, s3
	slt s6, s5, s4
	sltu s7, s6, s5
	srli s0, s0, 1
	div t5, s5, t6
	addi s0, s0, -80
	sw t6, 0(s0)
	sw s1, 4(s0)
	lw t0, 0(s0)
	bne s2, s3, main
