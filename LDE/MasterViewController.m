//
//  MasterViewController.m
//  LDE
//
//  Created by Kyle Zhao on 5/26/15.
//  Copyright (c) 2015 Kyle Zhao. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "KZEuclideanAlgorithm.h"

@interface MasterViewController ()
@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) NSArray *reuseIdentifiers;
@property (strong, nonatomic) NSArray *algorithmCalculations;
@property (strong, nonatomic) UITextField *textFieldA;
@property (strong, nonatomic) UITextField *textFieldB;
@property (strong, nonatomic) UITextField *textFieldC;
@property (strong, nonatomic) UITextField *textFieldFrom;
@property (strong, nonatomic) UITextField *textFieldTo;
@property (strong, nonatomic) UILabel *labelGCD;
@property (strong, nonatomic) UILabel *labelX;
@property (strong, nonatomic) UILabel *labelY;
@end

@implementation MasterViewController
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reuseIdentifiers = @[@[@"aCell",@"bCell",@"cCell"],@[@"gcdCell",@"xCell",@"yCell"],@[@"fromCell",@"toCell"]];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(dissmissKeyboard:)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)insertNewObject:(id)sender {
//    if (!self.objects) {
//        self.objects = [[NSMutableArray alloc] init];
//    }
//    [self.objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

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
    if (section == tableView.numberOfSections -1) {
        return 1;//self.objects.count;
    } else {
        return [self.reuseIdentifiers[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;

    if (indexPath.section == tableView.numberOfSections -1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"workRow"];
        cell.textLabel.text = @"work";
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


    //NSDate *object = self.objects[indexPath.row];
    //cell.textLabel.text = [object description];
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

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

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
        return NO;
    }

    unichar firstChar = [finalString characterAtIndex:0];
    if (firstChar == '-') {
        if(finalString.length > 11) {
            return NO;
        }
    } else {
        if(finalString.length > 10) {
            return NO;
        }
    }

    textField.text = finalString;
    [self textFieldValueChanged:textField];
    return NO;
}


- (void)textFieldValueChanged:(UITextField *)textField {
    if (textField == self.textFieldFrom) {
        NSLog(@"From");
    } else if (textField == self.textFieldTo) {
        NSLog(@"To");
    } else {
        [self performCalculation];
    }
}

- (void)performCalculation {
    long long a = self.textFieldA.text.longLongValue;
    long long b = self.textFieldB.text.longLongValue;
    long long c = self.textFieldC.text.longLongValue;
    long long x, y, gcd;
    NSArray *calculations;

    if (a==0 || b==0 || c==0) {
        self.labelGCD.text = @"";
        self.labelX.text = @"";
        self.labelY.text = @"";
        self.algorithmCalculations = nil;
        return;
    }
    
    if (kz_calculateLDE(llabs(a), llabs(b), c, &x, &y, &gcd, &calculations)) {

        self.algorithmCalculations = calculations;

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

        //kz_evaluateLDE(-4, 4, a, b, c, x, y, gcd);
    } else {
        self.labelGCD.text = [NSString stringWithFormat:@"GCD(%lld,%lld) = %lld",a,b,gcd];
        self.labelX.text = @"No Solutions";
        self.labelY.text = [NSString stringWithFormat:@"%lld mod GCD(%lld,%lld) != 0",c,a,b];
    }
}



//void test() {
//
//    long long a, b, c, x, y, gcd;
//
//    a = 64;
//    b = -139;
//    c = -7;
//
//    NSLog(@"%lldx + %lldy = %lld",a,b,c);
//
//
//}
@end





























