//
//  TTViewController.h
//  Calendar
//
//  Created by Tony on 16-7-14.
//  Copyright (c) 2014年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarLogic.h"

//回掉代码块
typedef void (^CalendarBlock)(NSArray<CalendarDayModel *> *modelArray);

@interface CalendarViewController : UIViewController

@property(nonatomic ,strong) UICollectionView* collectionView;//网格视图

@property(nonatomic ,strong) NSMutableArray *calendarMonth;//每个月份的中的daymodel容器数组

@property(nonatomic ,strong) CalendarLogic *Logic;

@property (nonatomic, copy) CalendarBlock calendarblock;//回调

@end
