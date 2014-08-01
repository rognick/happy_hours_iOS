//
//  PieChartViewController.h
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/28/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "BaseViewController.h"

@interface PieChartViewController : BaseViewController <XYPieChartDelegate, XYPieChartDataSource>

@property (weak, nonatomic) IBOutlet XYPieChart *pieChart;
@property (nonatomic, strong) NSMutableArray    *slices;
@property (nonatomic, strong) NSArray           *sliceColors;
@property (nonatomic, strong) NSString          *worketDays;

@end
