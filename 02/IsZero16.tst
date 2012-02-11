load IsZero16.hdl,
output-file IsZero16.out,
compare-to IsZero16.cmp,
output-list in%B1.16.1 out%B1.1.1;

set in %B0000000000000000,
eval,
output;

set in %B1111111111111111,
eval,
output;

set in %B1010101010101010,
eval,
output;

set in %B0011110011000011,
eval,
output;

set in %B0000000000000000,
eval,
output;
