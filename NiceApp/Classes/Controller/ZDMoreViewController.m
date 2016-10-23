//
//  ZDMoreViewController.m
//  NiceApp
//
//  Created by 边振东 on 8/13/16.
//  Copyright © 2016 边振东. All rights reserved.
//

#import "ZDMoreViewController.h"
#import "ZDMoreTableViewCell.h"

@interface ZDMoreViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *moreTableView;

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation ZDMoreViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"更多";
  [self setupNav];
  [self setupUI];
  [self fetchDataSource];
}

- (void)setupNav {
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  self.navigationController.navigationBar.translucent = YES;
  
  
  UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"more_nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftNavAction)];
  self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)leftNavAction {
  if (self.navigationController.viewControllers.count == 1) {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  } else {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (void)setupUI {
  self.view.backgroundColor = [UIColor whiteColor];
  self.moreTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
  self.moreTableView.tableFooterView = [UIView new];
}

- (void)fetchDataSource {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"more_data" ofType:@"plist"];
  self.dataSource = [NSArray arrayWithContentsOfFile:path];
  [self.moreTableView reloadData];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 55.;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ZDMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell" forIndexPath:indexPath];
  NSDictionary *tmpDic = self.dataSource[indexPath.row];
  cell.iconView.image = [UIImage imageNamed:tmpDic[@"icon"]];
  cell.titleLabel.text = tmpDic[@"text"];
  return cell;
}

@end
