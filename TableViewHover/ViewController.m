//
//  ViewController.m
//  TableViewHover
//
//  Created by Stan on 2021/5/2.
//

#define w ([UIScreen mainScreen].bounds.size.width)
#define h ([UIScreen mainScreen].bounds.size.height)
#define hover 100
#define header 200

#import "ViewController.h"
#import "ChildTableView.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic)UIScrollView *scroll;
@property (nonatomic)ChildTableView *tableView;
@property(nonatomic,assign)BOOL isSuper;//super
@property (nonatomic, assign) BOOL isChild;//child
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    self.scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    scroll.delegate = self;
    [self.view addSubview:scroll];
    scroll.backgroundColor = UIColor.orangeColor;
    scroll.contentSize = CGSizeMake(w, h+header);
    _scroll = scroll;
    
  
    ChildTableView *tableView = [[ChildTableView alloc] initWithFrame:CGRectMake(0, header, w, h-header+hover)];
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    [scroll addSubview:self.tableView];
    
    
    self.isChild = NO;
    self.isSuper = YES;
}
#pragma mar-UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [NSString stringWithFormat:@"%lu",indexPath.row];
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, 44)];
    lab.text = @"title";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = UIColor.blueColor;
    lab.textColor = UIColor.whiteColor;
    return lab;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    
    if (scrollView == self.tableView) {
        CGFloat offset_y = self.tableView.contentOffset.y;
        
        if (offset_y <= 0) {//逻辑入口
            self.isSuper = YES;
            self.isChild = NO;
        }
    }
    
    
    if (scrollView == self.scroll) {
        CGFloat offset_y = self.scroll.contentOffset.y;
        
        if (offset_y >= hover) {
            self.isSuper = NO;
            self.isChild = YES;
        }
        
    }
    
    //一个滚动另一个就不滚动 互为互斥事件
    if (!self.isChild && self.isSuper) {
        self.tableView.contentOffset = CGPointZero;
    }else{
        self.scroll.contentOffset = CGPointMake(0, hover);
    }
    
    
    
}

@end
