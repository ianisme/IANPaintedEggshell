//
//  PaintedEggshellController.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/28.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "PaintedEggshellController.h"
#import <Masonry/Masonry.h>
//#import "WebServiceConfigMG.h"
#import "PaintEggshellLogController.h"
#import "IANLocalNotiManager.h"
#import "IANAppMacros.h"

static NSString *const kCellReuseIdentifier = @"ChangeNetWorkCell";

@interface PaintedEggshellController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation PaintedEggshellController

#pragma mark - life style

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addNavigationBar];
    [self addTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - table delegate && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    NSArray *dataRowArray = (NSArray *)self.dataArray[indexPath.section];
    cell.textLabel.text = dataRowArray[indexPath.row][@"name"];
    if (indexPath.section == 0) {
        if (_selectedIndex == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if(indexPath.section == 1){
        if (_isOpenShake) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if(indexPath.section == 2){
        if (_isOpenLog) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_selectedIndex inSection:indexPath.section];
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndex];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        _selectedIndex = indexPath.row;
    } else if(indexPath.section == 1){
        _isOpenShake = !_isOpenShake;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (_isOpenShake) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if(indexPath.section == 2){
        _isOpenLog = !_isOpenLog;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (_isOpenLog) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        PaintEggshellLogController *controller = [[PaintEggshellLogController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 2 ? 40 : 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2.5, self.view.frame.size.width - 10 , 35)];
        label.numberOfLines = 2;
        label.text = @"日志收集的功能为每10秒新建一条记录(需要有请求)";
        label.font = [UIFont systemFontOfSize:12.5f];
        label.textColor = [UIColor grayColor];
        [view addSubview:label];
        return view;
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}


#pragma mark - private method

- (void)loadData
{
    self.dataArray = @[
                       @[
                           @{@"name":@"正式环境"},
                           @{@"name":@"准生产环境"},
                           @{@"name":@"测试环境"}
                           ],
                       @[
                           @{@"name":@"开启摇一摇"}
                           ],
                       @[
                           @{@"name":@"开启收集日志功能"}
                           ],
                       @[
                           @{@"name":@"查看日志"}
                           ]
                       
                       ];
    [_tableView reloadData];
}

- (void)addNavigationBar
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *closeBtn = [self creatBtn:@"取消" action:@selector(CloseBtnAction:)];
    closeBtn.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -16;
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftItem];
    
    UIButton *saveBtn = [self creatBtn:@"保存" action:@selector(SaveBtnAction:)];
    saveBtn.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItems = @[spaceItem,rightItem];
    
    UILabel *titleLabel = [self creatLabel:@"接口环境切换"];
    titleLabel.frame = CGRectMake(0, 0, 88, 44);
    self.navigationItem.titleView = titleLabel;
}

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    tableView.sectionHeaderHeight = 0;
    tableView.sectionFooterHeight = 0;
    tableView.separatorColor = [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0];
    tableView.backgroundColor = [UIColor colorWithRed:0xf0/255.0f green:0xf0/255.0f blue:0xf0/255.0f alpha:1];
    _tableView = tableView;
}

- (UIButton *)creatBtn:(NSString *)title action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UILabel *)creatLabel:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}


#pragma mark - btn action

- (void)CloseBtnAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
//        ((AppDelegate *)[UIApplication sharedApplication].delegate).isPaintedEggshellControllerpresent = NO;
    }];
}

- (void)SaveBtnAction:(UIButton *)btn
{
    if (_selectedIndex == 0) {
    //    [[WebServiceConfigMG sharedInstance] loadWebUrlConfig:ZR_WEB_UAT];
    } else if (_selectedIndex == 1) {
    //    [[WebServiceConfigMG sharedInstance] loadWebUrlConfig:ZR_WEB_PRO];
    } else if (_selectedIndex == 2) {
    //    [[WebServiceConfigMG sharedInstance] loadWebUrlConfig:ZR_WEB_SIT];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",_selectedIndex] forKey:PAINTED_EGGSHELL_INDEX];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",_isOpenShake] forKey:PAINTED_EGGSHELL_SHAKE_ISOPEN];
    
    
    if (_isOpenLog) {
        NSLog(@"日志收集功能打开");
        // 设置保存日志文件的时间为10秒一次
        NSDate *currentDate = [NSDate date];
        NSDate *date = [currentDate dateByAddingTimeInterval:PAINTED_EGGSHELL_LOG_TIME];
        [[IANLocalNotiManager shareInstance] setLocalNotiManager:@{} andTaskId:PAINTED_EGGSHELL_LOCALNOTI andLocalTime:date];
//        if ([WebServiceConfigMG sharedInstance].networkLogArray == nil) {
//            [WebServiceConfigMG sharedInstance].networkLogArray = [@[] mutableCopy];
//        }
    } else {
        NSLog(@"日志收集功能关闭");
        [[IANLocalNotiManager shareInstance] cancelLocalNotiManager:PAINTED_EGGSHELL_LOCALNOTI];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",_isOpenLog] forKey:PAINTED_EGGSHELL_LOG_ISOPEN];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^{
//        ((AppDelegate *)[UIApplication sharedApplication].delegate).isPaintedEggshellControllerpresent = NO;
    }];
}


@end
