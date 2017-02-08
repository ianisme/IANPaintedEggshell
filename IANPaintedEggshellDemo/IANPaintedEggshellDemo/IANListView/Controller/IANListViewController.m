//
//  IANListViewController.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/29.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "IANListViewController.h"
#import "IANListView.h"
#import "AFNetworking.h"
#import "IANCustomCell.h"
#import "CustomModel.h"
#import "IANAFHTTPSessionManager.h"

#import "UIView+ManyTapAction.h"
#import "IANAppMacros.h"

@interface IANListViewController ()

@property (nonatomic, strong) IANListView *listView;

@end

@implementation IANListViewController


#pragma mark - life style

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"IANListView";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _listView = [[IANListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    _listView.cellIdentifier = @"cellIdentifier";
    _listView.cellClass = NSStringFromClass([IANCustomCell class]);
    IANPageDataSource *ds = [[IANPageDataSource alloc] init];
    ds.pageSize = 20;
    ds.requestBlock = ^(NSDictionary *params, void(^dataArrayDone)(BOOL, id)){
        
        NSString *str=[NSString stringWithFormat:@"https://m2.qiushibaike.com/article/list/day?count=%ld&page=%ld",[params[@"page_size"] integerValue],[params[@"page"] integerValue]];
//        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        IANAFHTTPSessionManager *manager = [IANAFHTTPSessionManager manager];

        [manager GET:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 NSLog(@"这里打印请求成功要做的事");
     
                 NSMutableArray *tempArray = [NSMutableArray arrayWithArray:responseObject[@"items"]];
                 
                 dataArrayDone(YES,tempArray);
                 
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {  
                 
                 dataArrayDone(NO,error);
                 NSLog(@"%@",error);  //这里打印错误信息
                 
             }];
        
    };
    ds.creatCellBlock = ^(UITableView *tableView, NSIndexPath *indexPath, NSMutableArray *dataArray){
        NSString *cellIdentifier = @"cellIdentifier";
        IANCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        CustomModel *model = [[CustomModel alloc] initWithDictionary:dataArray[indexPath.row] error:nil];
        [cell configCellWithModel:model];
        
        return cell;
    };
    
    ds.calculateHeightofRowBlock = ^(NSIndexPath *indexPath, NSMutableArray *dataArray){
        
        if (indexPath.row < [dataArray count]) {
            CustomModel *model = [[CustomModel alloc] initWithDictionary:dataArray[indexPath.row] error:nil];
           // NSLog(@"测试：%f",[IANCustomCell heightWithModel:model]);
            return [IANCustomCell heightWithModel:model];
            
        }
        return (CGFloat)44.0;
    };
    
    ds.selectBlock = ^(NSIndexPath *indexPath, NSMutableArray *dataArray){
        
        NSLog(@"点击了第%ld行", (long)indexPath.row);
        
    };
    
    
    _listView.dataSource = ds;
    [self.view addSubview:_listView];
    [_listView startLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)textSize:(NSString *)text font:(UIFont *)font bounding:(CGSize)size
{
    if (!(text && font) || [text isEqual:[NSNull null]]) {
        return CGSizeZero;
    }
    CGRect rect = [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil];
    return CGRectIntegral(rect).size;
}

@end
