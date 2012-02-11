load ALUm.hdl,
output-file ALUm.out,
compare-to ALUm.cmp,
output-list in%B1.16.1 zero%B1.1.1 negate%B1.1.1 out%B1.16.1;

set in %B0000000000000000,

set zero 0,
set negate 0,
eval,
output;

set zero 1,
set negate 0,
eval,
output;

set zero 0,
set negate 1,
eval,
output;

set zero 1,
set negate 1,
eval,
output;

set in %B1111111111111111,

set zero 0,
set negate 0,
eval,
output;

set zero 1,
set negate 0,
eval,
output;

set zero 0,
set negate 1,
eval,
output;

set zero 1,
set negate 1,
eval,
output;

set in %B0011000000001100,

set zero 0,
set negate 0,
eval,
output;

set zero 1,
set negate 0,
eval,
output;

set zero 0,
set negate 1,
eval,
output;

set zero 1,
set negate 1,
eval,
output;