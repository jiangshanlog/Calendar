//
//  TTViewController.h
//  Calendar
//
//  Created by Tony on 16-7-14.
//  Copyright (c) 2014年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarDayModel.h"
#import "NSDate+WQCalendarLogic.h"

@interface CalendarLogic : NSObject

- (NSMutableArray *)reloadCalendarView:(NSDate *)date  selectDate:(NSDate *)date1 needDays:(int)days_number;
- (void)selectLogic:(CalendarDayModel *)day;

- (CalendarDayModel *)changeStyle:(CalendarDayModel *)calendarDay;
@end
