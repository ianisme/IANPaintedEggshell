//
//  PaintEggshellDetailLogViewController.m
//  ZiroomerProject
//  网络日志response页面
//  Created by ian on 16/3/8.
//  Copyright © 2016年 Chris. All rights reserved.
//

#import "PaintEggshellDetailLogViewController.h"
#import "PaintEggshellDetailLogTableViewCell.h"
#import "IANNetworkLogModel.h"
#import <Masonry.h>
#import "PaintedEggNetworkService.h"
#import "UIButton+IANActivityView.h"
#import "IANUtil.h"

static NSString *const kCellReuseIdentifier = @"NetWorkDetailLogCell";

@interface PaintEggshellDetailLogViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *rightItemBtn;

@end

@implementation PaintEggshellDetailLogViewController


#pragma mark - life style

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"response日志列表";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addTableView];
    [self addNavigationBarRightButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table delegate && datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaintEggshellDetailLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    IANNetworkLogModel *model = (IANNetworkLogModel *)self.dataArray[indexPath.row];
    [cell configCellWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IANNetworkLogModel *model = (IANNetworkLogModel *)self.dataArray[indexPath.row];
    return [PaintEggshellDetailLogTableViewCell heightWithModel:model];
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
    [tableView registerClass:[PaintEggshellDetailLogTableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.tableHeaderView = [[UIView alloc] init];
    tableView.separatorColor = [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1.0];
    tableView.backgroundColor = [UIColor colorWithRed:0xf0/255.0f green:0xf0/255.0f blue:0xf0/255.0f alpha:1];
    _tableView = tableView;
}

- (void)addNavigationBarRightButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"paintegg_nav_rightbtn"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    spaceItem.width = -12;
    
    self.navigationItem.rightBarButtonItems = @[spaceItem, rightItem];
    _rightItemBtn = btn;
}


#pragma mark - action method

- (void)rightBtnClick:(id)sender
{
    self.tableView.scrollEnabled = NO;
    [_rightItemBtn startButtonActivityIndicatorView];
    
    IANNetworkLogModel *model = (IANNetworkLogModel *)self.dataArray[0];
    if (![model.urlString containsString:@"http"]) {
        return;
    }
    if ([model.httpMethodString isEqualToString:@"POST"]) {
        [[PaintedEggNetworkService shareInstance] appPost:model.urlString parametersString:model.httpBodyString handler:^(BOOL successful, id response) {
            [_rightItemBtn endButtonActivityIndicatorView];
            self.tableView.scrollEnabled = YES;
        }];
    } else {

        [[PaintedEggNetworkService shareInstance] appGet:model.urlString handler:^(BOOL successful, id response) {
            NSString *eggResponse = [IANUtil replaceUnicode:response];
            self.dataArray = nil;
            IANNetworkLogModel *newModel = model;
            newModel.responseString = [NSString stringWithFormat:@"%@",eggResponse];
            self.dataArray = [@[newModel] mutableCopy];
            [self.tableView reloadData];
            [_rightItemBtn endButtonActivityIndicatorView];
            self.tableView.scrollEnabled = YES;
        }];
    }
}

@end
