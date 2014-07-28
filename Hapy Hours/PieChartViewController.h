//
//  PieChartViewController.h
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/28/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface PieChartViewController : UIViewController <XYPieChartDelegate, XYPieChartDataSource>
@property (weak, nonatomic) IBOutlet XYPieChart *pieChart;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;

@end
