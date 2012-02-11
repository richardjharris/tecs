// Infinite loop: listens to the keyboard input
// If key pressed, blacken the screen
// Else, clear the screen

(KEYLOOP)
  @KBD
  D=M
  @GOTKEY
  D;JNE  // jump if != 0
  @FILLWHITE
  0;JMP
(GOTKEY)
  @FILLBLACK
  0;JMP

(FILLBLACK)
  @8192
  D=A
(BLOOP)
  @SCREEN
  A=A+D
  M=-1
  D=D-1
  @BLOOP
  D;JGE
  @KEYLOOP
  0;JMP
  
(FILLWHITE)
  @8192
  D=A
(WLOOP)
  @SCREEN
  A=A+D
  M=0
  D=D-1
  @WLOOP
  D;JGE
  @KEYLOOP
  0;JMP