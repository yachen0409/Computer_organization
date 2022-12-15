`timescale 1ns / 1ps

module Full_Subtractor(
    In_A, In_B, Borrow_in, Difference, Borrow_out
    );
    input In_A, In_B, Borrow_in;
    output Difference, Borrow_out;
    
    // implement full subtractor circuit, your code starts from here.
    // use half subtractor in this module, fulfill I/O ports connection.
    
    
//    Half_Subtractor HSUB (
//        .In_A(), 
//        .In_B(), 
//        .Difference(), 
//        .Borrow_out()
//    );
    
    wire diff1, borrow1, borrow2;
    
    Half_Subtractor H1 (In_A, In_B, diff1, borrow1);
    Half_Subtractor H2 (diff1, Borrow_in, Difference, borrow2);
    or(Borrow_out, borrow2, borrow1);
    
endmodule
