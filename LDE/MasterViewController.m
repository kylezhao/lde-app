//
//  MasterViewController.m
//  LDE
//
//  Created by Kyle Zhao on 5/26/15.
//  Copyright (c) 2015 Kyle Zhao. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()
@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) NSArray *reuseIdentifiers;
@property (strong, nonatomic) UITextField *textFieldA;
@property (strong, nonatomic) UITextField *textFieldB;
@property (strong, nonatomic) UITextField *textFieldC;
@property (strong, nonatomic) UITextField *textFieldFrom;
@property (strong, nonatomic) UITextField *textFieldTo;
@property (strong, nonatomic) UILabel *labelX;
@property (strong, nonatomic) UILabel *labelY;
@end

@implementation MasterViewController
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reuseIdentifiers = @[@[@"aCell",@"bCell",@"cCell"],@[@"xCell",@"yCell"],@[@"fromCell",@"toCell"]];
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

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showWork"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = self.objects[indexPath.row];
//        [[segue destinationViewController] setDetailItem:object];
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
                    self.labelX = cell.textLabel;
                    break;
                case 1:
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
    return (section == 2 || section == 3) ? 50 : 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 2) {
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

//    if (textField == textFieldA) {
//
//
//
//    } else if (textField == textFieldB) {
//
//    } else if (textField == textFieldC) {
//
//    } else if (textField == textFieldFrom) {
//
//    } else if (textField == textFieldTo) {
//
//    }

    NSLog(@"%@:%@",textField,string);
    self.labelX.text = textField.text;
    self.labelY.text = [NSString stringWithFormat:@"http://%@",textField.text];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {

    NSLog(@"%@",textField);
    return YES;
}

@end





























