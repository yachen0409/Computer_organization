`timescale 1ns / 1ps

module Half_Subtractor(
    In_A, In_B, Difference, Borrow_out
    );
    input In_A, In_B;
    output Difference, Borrow_out;
    wire minus_A;
    
    // implement half subtractor circuit, your code starts from here.
    // gate(output, input1, input2)
    xor(Difference, In_B, In_A);
    not(minus_A, In_A);
    and(Borrow_out, In_B, minus_A);
    
    
    
endmodule
