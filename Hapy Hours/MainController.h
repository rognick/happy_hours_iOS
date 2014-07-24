//
//  MainController.h
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/23/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *dayTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthTotalLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonStartStop;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *labelStartStop;

@end
