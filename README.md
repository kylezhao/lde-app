# lde-app
iPhone app that solves a Linear Diophantine Equation

A Linear Diophantine Equation is expressed in the form Ax + By = C.
Where A, B, C are given integers and x, y are integers to be
derived so that the equation is satisfied.

The characteristic of the Linear Diophantine Equation is that
there are either no solutions or an infinite number of solutions.

A Linear Diophantine Equation has no integer solutions when
C mod GCD(A,B) != 0

Or in other words, the greatest common denominator of A and B does
not divide C.

Otherwise an infinite number of solutions can be generated by
running the Extended Euclidian Algorithm by the following
rules.

x = (X * C - B * n)/GCD(A,B);

y = (Y * C + A * n)/GCD(A,B);

where X and Y is a particular solution to the equation given by
Extended Euclidian Algorithm and n is an integer.

Why do we want to solve Linear Diophantine Equations?

Consider the following example.

Suppose a farmer owns many chickens and rabbits and he tells
you there are 24 legs in his pen of chickens and rabbits.

How many chickens and rabbits does he own?

This problem can be expressed using a Linear Diophantine Equation

2x + 4y = 24

Where there are x two legged chickens and y four legged rabbits
for a total of 24 legs.

This application runs the Extended Euclidian Algorithm and
determines that

x = (12) - 2(n)
y = (0) + 1(n)

The app can also evaluate the solutions for any range of n
say 1 to 6 in this case.

n=1  2(10) + 4(1) = 24 : 10 Chickens, 1 rabbit

n=2  2(8) + 4(2) = 24

n=3  2(6) + 4(3) = 24  : 6 Chickens, 3 rabbits

n=4  2(4) + 4(4) = 24

n=5  2(2) + 4(5) = 24  : 2 Chickens, 5 rabbits

n=6  2(0) + 4(6) = 24

Are all possible solutions to this problem
