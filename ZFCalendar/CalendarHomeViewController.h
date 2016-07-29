//
//  CalendarHomeViewController.h
//  Calendar
//
//  Created by Tony on 16-7-14.
//  Copyright (c) 2014年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewController.h"


@interface CalendarHomeViewController : CalendarViewController

@property (nonatomic, strong) NSString *calendartitle;//设置导航栏标题

- (void)setAirPlaneToDay:(int)day ToDateforString:(NSString *)todate;//飞机初始化方法

- (void)setHotelToDay:(int)day ToDateforString:(NSString *)todate;//酒店初始化方法

- (void)setTrainToDay:(int)day ToDateforString:(NSString *)todate;//火车初始化方法

- (NSMutableArray *)getMonthArrayOfDayNumber:(int)day ToDateforString:(NSString *)todate;

@end
