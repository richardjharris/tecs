// mult.asm: takes R0 and R1, multiplies,
// stores result in R2.

// Pseudo-code:
// R2 = 0
// while (R1--) {
//   R2 += R0
// }

  @R2
  M=0
(LOOP)
  @R1
  D=M   // D=R1
  @ENDLOOP
  D;JLE // goto ENDLOOP if R1 <= 0
  @R1
  M=D-1 // R1--
  @R2
  D=M   // fetch R2
  @R0
  D=D+M // add R0
  @R2
  M=D   // store R2
  @LOOP
  0;JMP // go back to LOOP

(ENDLOOP)  // infinite loop
  @ENDLOOP
  0;JMP