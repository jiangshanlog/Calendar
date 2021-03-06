//
//  TTViewController.h
//  Calendar
//
//  Created by Tony on 16-7-14.
//  Copyright (c) 2014年 Tony. All rights reserved.
//

#import "TTViewController.h"
#import "CalendarHomeViewController.h"
#import "CalendarViewController.h"
//#import "CalendarDayModel.h"
#import "Color.h"

@interface TTViewController ()
{

    CalendarHomeViewController *chvc;

}
@end

@implementation TTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.navigationController.navigationBar.backgroundColor = COLOR_THEME;
    self.navigationController.navigationBar.tintColor = COLOR_THEME;
    self.navigationItem.title = @"";
    
    UIButton *but2 = [[UIButton alloc]initWithFrame:CGRectMake(10, 200, 300, 50)];
    but2.backgroundColor = COLOR_THEME;
    but2.titleLabel.textColor = [UIColor whiteColor];
    but2.tag = 2;
    [but2 setTitle:@"Click Calendar!" forState:UIControlStateNormal];
    [but2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:but2];

}


-(void)click:(UIButton *)but
{

    if (!chvc) {
        
        chvc = [[CalendarHomeViewController alloc]init];
        
        chvc.calendartitle = @"飞机";
        
        [chvc setAirPlaneToDay:365 ToDateforString:nil];//飞机初始化方法
        
    }

    
    
   

    chvc.calendarblock = ^(NSArray<CalendarDayModel *> *modelarray){
        for (CalendarDayModel *model in modelarray) {
                    NSLog(@"\n---------------------------");
                    NSLog(@"1星期 %@",[model getWeek]);
                    NSLog(@"2字符串 %@",[model toString]);
                    NSLog(@"3节日  %@",model.holiday);
            
                    if (model.holiday) {
            
                        [but setTitle:[NSString stringWithFormat:@"%@ %@ %@",[model toString],[model getWeek],model.holiday] forState:UIControlStateNormal];
            
                    }else{
            
                        [but setTitle:[NSString stringWithFormat:@"%@ %@",[model toString],[model getWeek]] forState:UIControlStateNormal];
                        
                    }
        }
        

    };
    [self presentViewController:chvc animated:YES completion:^{
        
    }];
//    [self.navigationController pushViewController:chvc animated:YES];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
