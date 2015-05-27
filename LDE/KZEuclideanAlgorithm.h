//
//  KZEuclideanAlgorithm.h
//  LDE
//
//  Created by Kyle Zhao on 5/27/15.
//  Copyright (c) 2015 Kyle Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

int kz_sign(long long x);
void kz_evaluateLDE(int n1,int n2, long long a, long long b, long long c, long long X, long long Y, long long gcd, NSMutableArray *evaluationCalculations);
BOOL kz_calculateLDE(long long a, long long b, long long c, long long *xReturn, long long *yReturn, long long *gcdReturn, NSMutableArray *algorithmCalculations);
