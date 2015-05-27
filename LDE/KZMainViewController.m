//
//  KZMainViewController.m
//  LDE
//
//  Created by Kyle Zhao on 5/26/15.
//  Copyright (c) 2015 Kyle Zhao. All rights reserved.
//

#import "KZMainViewController.h"
#import "KZCalculationsViewController.h"
#import "KZEuclideanAlgorithm.h"

@interface KZMainViewController ()
@property (strong, nonatomic) NSArray *reuseIdentifiers;
@property (strong, nonatomic) NSMutableArray *algorithmCalculations;
@property (strong, nonatomic) NSMutableArray *evaluationCalculations;
@property (strong, nonatomic) UITextField *textFieldA;
@property (strong, nonatomic) UITextField *textFieldB;
@property (strong, nonatomic) UITextField *textFieldC;
@property (strong, nonatomic) UITextField *textFieldFrom;
@property (strong, nonatomic) UITextField *textFieldTo;
@property (strong, nonatomic) UILabel *labelGCD;
@property (strong, nonatomic) UILabel *labelX;
@property (strong, nonatomic) UILabel *labelY;
@property (assign, nonatomic) long long aParam;
@property (assign, nonatomic) long long bParam;
@property (assign, nonatomic) long long cParam;
@property (assign, nonatomic) long long xParam;
@property (assign, nonatomic) long long yParam;
@property (assign, nonatomic) long long gcdParam;
@end

@implementation KZMainViewController
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reuseIdentifiers = @[@[@"aCell",@"bCell",@"cCell"],@[@"gcdCell",@"xCell",@"yCell"],@[@"fromCell",@"toCell"]];
    self.algorithmCalculations = [[NSMutableArray alloc] init];
    self.evaluationCalculations = [[NSMutableArray alloc] init];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissKeyboard:)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) dissmissKeyboard:(id)sender{
    [self.tableView endEditing:YES];
}

#pragma mark - Segues

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return self.algorithmCalculations.count > 0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showWork"]) {
        [[segue destinationViewController] setAlgorithmCalculations:self.algorithmCalculations];
    }
}

#pragma mark - UITalbleViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.reuseIdentifiers.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return self.evaluationCalculations.count;
    } else {
        return [self.reuseIdentifiers[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;

    if (indexPath.section == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"workRow"];
        cell.textLabel.text = self.evaluationCalculations[indexPath.row];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifiers[indexPath.section][indexPath.row]];
    }

    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    self.textFieldA = (UITextField *)[cell viewWithTag:1];
                    self.textFieldA.delegate = self;
                    break;
                case 1:
                    self.textFieldB = (UITextField *)[cell viewWithTag:1];
                    self.textFieldB.delegate = self;
                    break;
                case 2:
                    self.textFieldC = (UITextField *)[cell viewWithTag:1];
                    self.textFieldC.delegate = self;
                    break;
                default:
                    break;
            }
            break;

        case 1:
            switch (indexPath.row) {
                case 0:
                    self.labelGCD = cell.textLabel;
                    break;
                case 1:
                    self.labelX = cell.textLabel;
                    break;
                case 2:
                    self.labelY = cell.textLabel;
                    break;
                default:
                    break;
            }
            break;

        case 2:
            switch (indexPath.row) {
                case 0:
                    self.textFieldFrom = (UITextField *)[cell viewWithTag:1];
                    self.textFieldFrom.delegate = self;
                    break;
                case 1:
                    self.textFieldTo = (UITextField *)[cell viewWithTag:1];
                    self.textFieldTo.delegate = self;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 30 : 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"SOLUTION";
    } else if (section == 2) {
        return @"EVALUATE";
    } else if (section == 3) {
        return @"RESULTS";
    } else {
        return nil;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if ([string isEqualToString:@"."]) {
        if (textField.text.length > 0) {
            unichar firstChar = [textField.text characterAtIndex:0];
            if (firstChar == '-') {
                textField.text = [textField.text substringWithRange:NSMakeRange(1, textField.text.length-1)];
            } else {
                textField.text = [NSString stringWithFormat:@"-%@",textField.text];
            }
        }
        [self textFieldValueChanged:textField];
        return NO;
    }

    NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];
    if (![digits isSupersetOfSet:stringSet]) {
        [[[UIAlertView alloc] initWithTitle:@"Numbers Only Please"
                                   message:nil
                                  delegate:nil
                         cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
        return NO;
    }

    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (finalString.length == 0) {
        textField.text = @"";

        if(textField == self.textFieldTo || textField == self.textFieldFrom) {
            [self clearResultCells];
        } else {
            [self clear];
        }

        return NO;
    }

    unichar firstChar = [finalString characterAtIndex:0];

    if (textField == self.textFieldFrom || textField == self.textFieldTo) {
        if (firstChar == '-') {
            if(finalString.length > 3) {
                return NO;
            }
        } else {
            if(finalString.length > 2) {
                return NO;
            }
        }
    } else {
        if (firstChar == '-') {
            if(finalString.length > 11) {
                return NO;
            }
        } else {
            if(finalString.length > 10) {
                return NO;
            }
        }
    }

    textField.text = finalString;
    [self textFieldValueChanged:textField];
    return NO;
}

- (void)textFieldValueChanged:(UITextField *)textField {
    if (textField == self.textFieldFrom || textField == self.textFieldTo) {
        [self performEvaluation];
    } else {
        [self performCalculation];
    }
}

- (void)performCalculation {
    long long a = self.textFieldA.text.longLongValue;
    long long b = self.textFieldB.text.longLongValue;
    long long c = self.textFieldC.text.longLongValue;
    long long x, y, gcd;

    if (a==0 || b==0 || c==0) {
        [self clear];
        [self clearResultCells];
        return;
    }
    assert(self.algorithmCalculations);
    if (kz_calculateLDE(llabs(a), llabs(b), c, &x, &y, &gcd, self.algorithmCalculations)) {

        self.aParam = a;
        self.bParam = b;
        self.cParam = c;
        self.xParam = x;
        self.yParam = y;
        self.gcdParam = gcd;

        if(kz_sign(a) != kz_sign(b)) {
            y = -y;
        }

        if(a<0) {
            c =-c;
        }

        NSLog(@"x:%lld y:%lld gcd:%lld",x,y,gcd);

        self.labelGCD.text = [NSString stringWithFormat:@"GCD(%lld,%lld) = %lld",a,b,gcd];
        self.labelX.text = [NSString stringWithFormat:@"x = (%lld) - (%lld)n",x*(c/gcd),b/gcd];
        self.labelY.text = [NSString stringWithFormat:@"y = (%lld) + (%lld)n",y*(c/gcd),a/gcd];


        NSLog(@"%@", [NSString stringWithFormat:@"x = (%lld) - (%lld)n",x*(c/gcd),b/gcd]);
        NSLog(@"%@", [NSString stringWithFormat:@"y = (%lld) + (%lld)n",y*(c/gcd),a/gcd]);
        NSLog(@"%@", [NSString stringWithFormat:@"GCD(%lld,%lld) = %lld",a,b,gcd]);

        [self performEvaluation];

    } else {
        self.labelGCD.text = [NSString stringWithFormat:@"GCD(%lld,%lld) = %lld",a,b,gcd];
        self.labelX.text = @"No Solutions";
        self.labelY.text = [NSString stringWithFormat:@"%lld mod GCD(%lld,%lld) != 0",c,a,b];
        [self clearResultCells];
    }
}

- (void)performEvaluation {
    if(self.textFieldFrom.text.length > 0 && self.textFieldTo.text.length > 0 && self.aParam != 0) {
        int from = self.textFieldFrom.text.intValue;
        int to = self.textFieldTo.text.intValue;

        if (from != 0 && to != 0 && from <= to) {

            long long y = self.yParam;
            long long c = self.cParam;
            NSInteger oldEvalCalcCount = self.evaluationCalculations.count;

            if(kz_sign(self.aParam) != kz_sign(self.bParam)) {
                y = -y;
            }
            if(self.aParam < 0) {
                c =-c;
            }
            kz_evaluateLDE(from, to, self.aParam, self.bParam, c, self.xParam, y, self.gcdParam, self.evaluationCalculations);

            NSMutableArray *oldIndexPaths = [[NSMutableArray alloc] init];
            NSMutableArray *newIndexPaths = [[NSMutableArray alloc] init];

            for (int i = 0;i<oldEvalCalcCount;i++) {
                [oldIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:3]];
            }
            for (int i = 0;i<self.evaluationCalculations.count;i++) {
                [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:3]];
            }

            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:oldIndexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
    }
}

- (void)clear {
    self.aParam = 0;
    self.bParam = 0;
    self.cParam = 0;
    self.xParam = 0;
    self.yParam = 0;
    self.gcdParam = 0;

    self.labelGCD.text = @"";
    self.labelX.text = @"";
    self.labelY.text = @"";
    [self.algorithmCalculations removeAllObjects];
}

- (void)clearResultCells {
    if(self.evaluationCalculations.count > 0) {
        NSMutableArray *oldIndexPaths = [[NSMutableArray alloc] init];
        for (int i = 0;i<self.evaluationCalculations.count;i++) {
            [oldIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:3]];
        }
        [self.evaluationCalculations removeAllObjects];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:oldIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

#pragma mark - IBAction

- (IBAction)aboutBarButton:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://en.wikipedia.org/wiki/Extended_Euclidean_algorithm"]];
}

@end





























