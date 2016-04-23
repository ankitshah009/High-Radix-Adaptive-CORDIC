# High-Radix-Adaptive-CORDIC
High Radix Adaptive CORDIC Algorithm - Improvement over Traditional CORDIC


Pipelined implementation of high radix adaptive CORDIC as a coprocessor

http://ieeexplore.ieee.org/xpl/articleDetails.jsp?arnumber=7411207 

Abstract: The Coordinate Rotational Digital Computer (CORDIC) algorithm allows computation of trigonometric, hyperbolic, natural log and square root functions. This iterative algorithm uses only shift and add operations to converge. Multiple fixed radix variants of the algorithm have been implemented on hardware. These have demonstrated faster convergence at the expense of reduced accuracy. High radix adaptive variants of CORDIC also exist in literature. These allow for faster convergence at the expense of hardware multipliers in the datapath without compromising on the accuracy of the results. This paper proposes a 12 stage deep pipeline architecture to implement a high radix adaptive CORDIC algorithm. It employs floating point multipliers in place of the conventional shift and add architecture of fixed radix CORDIC. This design has been synthesised on a FPGA board to act as a coprocessor. The paper also studies the power, latency and accuracy of this implementation.

Citation : Cite the following paper. Official Citation available on IEEE page
S. S. Oza, A. P. Shah, T. Thokala and S. David, "Pipelined implementation of high radix adaptive CORDIC as a coprocessor," 2015 International Conference on Computing and Network Communications (CoCoNet), Trivandrum, 2015, pp. 333-342.
