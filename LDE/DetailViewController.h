//
//  DetailViewController.h
//  LDE
//
//  Created by Kyle Zhao on 5/26/15.
//  Copyright (c) 2015 Kyle Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

