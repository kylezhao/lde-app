//
//  KZEuclideanAlgorithm.m
//  LDE
//
//  Created by Kyle Zhao on 5/27/15.
//  Copyright (c) 2015 Kyle Zhao. All rights reserved.
//

#import "KZEuclideanAlgorithm.h"

int kz_sign(long long x);
void kz_llSwap(long long *a, long long *b);
long long kz_llgcd(long long a, long long b);

int kz_sign(long long x) {
    return (x > 0) - (x < 0);
}

void kz_llSwap(long long * a, long long *b) {
    long long x = *a;
    *a = *b;
    *b = x;
}

long long kz_llgcd(long long a, long long b) {
    long long c = a%b;
    while (a) {
        c = a; a = b%a;  b = c;
    }
    return b < 0 ? -b : b;
}

void kz_evaluateLDE(int n1,int n2, long long a, long long b, long long c, long long X, long long Y, long long gcd,NSMutableArray *evaluationCalculations) {

    if (evaluationCalculations) {
        [evaluationCalculations removeAllObjects];
    } else {
        return;
    }

    int from=n1;
    int to=n2;

    long long x;
    long long y;

    for(int n=from;n<=to;n++){
        x = (X*c-b*n)/gcd;
        y = (Y*c+a*n)/gcd;
        //                                                         a     x       b   y      a*x+b*y
        [evaluationCalculations addObject:[NSString stringWithFormat:@"n=%i  %lld(%lld) + %lld(%lld) = %lld\n",n,a,x,b,y,a*x+b*y]];
    }
}

BOOL kz_calculateLDE(long long a, long long b, long long c, long long *xReturn, long long *yReturn, long long *gcdReturn,  NSMutableArray *algorithmCalculations) {

    if (algorithmCalculations) {
        [algorithmCalculations removeAllObjects];
    }

    BOOL swapped = NO;
    long long x=a;
    long long y=b;
    long long c0=c;

    //x-y checker
    if(llabs(y)>llabs(x)){
        swapped = YES;
        kz_llSwap(&x,&y);
    }

    //call gcd method
    long long gcd = kz_llgcd(x, y);

    //no solutions
    if (c0%gcd!=0){
        *gcdReturn = gcd;
        return NO;
    }

    //save initilal values
    long long x0=x;
    long long y0=y;


    //----------------initializer
    long long r=x%y;
    if(r==0){
        *xReturn = swapped? 1 : 0;
        *yReturn = swapped? 0 : 1;
        *gcdReturn = y;
        return YES;
    }


    long long q=x/y;

    long long a0=1;
    long long a1=0;
    long long a2=1;

    long long b0=0;
    long long b1=1;
    long long b2=(-q)*b1+b0;

    x=y;
    y=r;
    q=x/y;

    //NSLog(@"%lld*(%lld) + %lld*(%lld) =%lld\n",x0,a2,y0,b2,r);
    //printf("%lld*(%lld) + %lld*(%lld) =%lld\n",x0,a2,y0,b2,r);
    [algorithmCalculations addObject:[NSString stringWithFormat:@"%lld*(%lld) + %lld*(%lld) =%lld\n",x0,a2,y0,b2,r]];
    //----------------initializer


    //----------------main loop
    while(1){
        r=x%y;
        if (r==0) {
            break;
        }
        q=x/y;

        a0=a1;
        a1=a2;
        a2=(-q)*a1+a0;

        b0=b1;
        b1=b2;
        b2=(-q)*b1+b0;

        x=y;
        y=r;

        //NSLog(@"%lld*(%lld) + %lld*(%lld) =%lld\n",x0,a2,y0,b2,r);
        //printf("%lld*(%lld) + %lld*(%lld) =%lld\n",x0,a2,y0,b2,r);
        [algorithmCalculations addObject:[NSString stringWithFormat:@"%lld*(%lld) + %lld*(%lld) =%lld\n",x0,a2,y0,b2,r]];
    }
    //----------------main loop

    *xReturn = swapped? b2 : a2;
    *yReturn = swapped? a2 : b2;
    *gcdReturn = gcd;
    
    //printf("S={%lld+%lldn + %lld-%lldn | nez}",x,y0/r,y,x0/r);
    
    return YES;
}


