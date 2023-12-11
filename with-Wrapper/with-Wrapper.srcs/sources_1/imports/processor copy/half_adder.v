module half_adder(a,b,s,carry);
    input a,b;
    output s,carry;

    xor xor1(s,a,b);
    and and1(carry,a,b);

endmodule