//
//  TTViewController.h
//  Calendar
//
//  Created by Tony on 16-7-14.
//  Copyright (c) 2014年 Tony. All rights reserved.
//

#import "CalendarViewController.h"
//UI
#import "CalendarMonthCollectionViewLayout.h"
#import "CalendarMonthHeaderView.h"
#import "CalendarDayCell.h"
//MODEL
#import "CalendarDayModel.h"


@interface CalendarViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *_daysSelectedArray; //选中的日期数组
     NSTimer* timer;//定时器

}

@property (nonatomic ,strong)UIButton *cancelBtn;
@property (nonatomic ,strong)UIButton *ensureBtn;

@end

@implementation CalendarViewController

static NSString *MonthHeader = @"MonthHeaderView";

static NSString *DayCell = @"DayCell";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initData];
        [self initView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.ensureBtn];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


- (void)initView{
    
    
    [self setTitle:@"选择日期"];
    
    CalendarMonthCollectionViewLayout *layout = [CalendarMonthCollectionViewLayout new];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50) collectionViewLayout:layout]; //初始化网格视图大小
    
    [self.collectionView registerClass:[CalendarDayCell class] forCellWithReuseIdentifier:DayCell];//cell重用设置ID
    
    [self.collectionView registerClass:[CalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    
//    self.collectionView.bounces = NO;//将网格视图的下拉效果关闭
    
    self.collectionView.delegate = self;//实现网格视图的delegate
    
    self.collectionView.dataSource = self;//实现网格视图的dataSource
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.allowsMultipleSelection = YES;
    
    [self.view addSubview:self.collectionView];
    
}



-(void)initData{
    _daysSelectedArray = [NSMutableArray new];
    self.calendarMonth = [[NSMutableArray alloc]init];//每个月份的数组
    
}



#pragma mark - CollectionView代理方法

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.calendarMonth.count;
}


//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:section];
    
    return monthArray.count;
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];
    
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:indexPath.section];
    
    CalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader){
        
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        CalendarDayModel *model = [month_Array objectAtIndex:15];

        CalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%lu年 %lu月",(unsigned long)model.year,(unsigned long)model.month];//@"日期";
        monthHeader.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        reusableview = monthHeader;
    }
    return reusableview;
    
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{


    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    CalendarDayModel *model = [month_Array objectAtIndex:indexPath.row];
    CalendarDayCell *cell = (CalendarDayCell *)[collectionView cellForItemAtIndexPath:indexPath];



    //添加
    [self.Logic selectLogic:model];
    [_daysSelectedArray addObject:model];   //存储选中的model
    [cell setModel:model];
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    CalendarDayModel *model = [month_Array objectAtIndex:indexPath.row];
    CalendarDayCell *cell = (CalendarDayCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //取消
    if ([_daysSelectedArray containsObject:model]) {
        model = [self resetModelStyleWithModel:model];
        [_daysSelectedArray removeObject:model];
        [cell setModel:model];
        return;
    }
}


//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    CalendarDayModel *model = [month_Array objectAtIndex:indexPath.row];
    if (model.style == CellDayTypeEmpty || model.style == CellDayTypePast) {
        return NO;
    }
    else
    return YES;
}



//定时器方法
- (void)onTimer{
    
    [timer invalidate];//定时器无效
    
    timer = nil;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (CalendarDayModel *)resetModelStyleWithModel:(CalendarDayModel *)model {
    return [self.Logic changeStyle:model];
}


- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelBtn.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width / 2, 50);
        _cancelBtn.backgroundColor = [UIColor orangeColor];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)ensureBtn{
    if (!_ensureBtn) {
        _ensureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _ensureBtn.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height - 50, self.view.frame.size.width / 2, 50);
        _ensureBtn.backgroundColor = [UIColor redColor];
        [_ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_ensureBtn addTarget:self action:@selector(ensureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureBtn;
}

- (void)cancelClick{
        timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    for (CalendarDayModel *model in _daysSelectedArray) {
        model.style = CellDayTypeFutur;
    }
    [_daysSelectedArray removeAllObjects];
    [self.collectionView reloadData];

}

- (void)ensureClick{
    if (self.calendarblock) {
        
        self.calendarblock(_daysSelectedArray);//传递数组给上级
        timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        for (CalendarDayModel *model in _daysSelectedArray) {
            model.style = CellDayTypeFutur;
        }
        [_daysSelectedArray removeAllObjects];
        [self.collectionView reloadData];


    }


}


@end
