//
//  PaintedEggshellCrashDetailViewController.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 2017/3/10.
//  Copyright © 2017年 ian. All rights reserved.
//

#import "PaintedEggshellCrashDetailViewController.h"
#import "PaintEggshellCrashDetailTableViewCell.h"
#import <Masonry.h>

static NSString *const kCellReuseIdentifier = @"CrashDetailLogCell";

@interface PaintedEggshellCrashDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PaintedEggshellCrashDetailViewController

#pragma mark - life style

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"崩溃详细日志";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table delegate && datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaintEggshellCrashDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *crashString = (NSString *)self.dataArray[indexPath.row];
    [cell configCellWithString:crashString];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *crashString = (NSString *)self.dataArray[indexPath.row];
    return [PaintEggshellCrashDetailTableViewCell heightWithString:crashString];
}


#pragma mark - private method

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[PaintEggshellCrashDetailTableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.tableHeaderView = [[UIView alloc] init];
    tableView.separatorColor = [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0];
    tableView.backgroundColor = [UIColor colorWithRed:0xf0/255.0f green:0xf0/255.0f blue:0xf0/255.0f alpha:1];
    _tableView = tableView;
}

@end
