//
//  MoreTableViewController.m
//  HCWeibo
//
//  Created by gj on 15/12/10.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "MoreTableViewController.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"
#import "ThemeManager.h"


@interface MoreTableViewController (){

    __weak IBOutlet ThemeImageView *imgViewRow1;
    __weak IBOutlet ThemeLabel *labelRow1;
    __weak IBOutlet ThemeLabel *detailLabelRow1;
    
    
    __weak IBOutlet ThemeImageView *imgViewRow2;
    __weak IBOutlet ThemeLabel *labelRow2;
    
    __weak IBOutlet ThemeImageView *imgViewRow3;
    __weak IBOutlet ThemeLabel *labelRow3;
    __weak IBOutlet ThemeLabel *detailLabelRow3;
    
    
    __weak IBOutlet ThemeLabel *labelRow4;
    __weak IBOutlet ThemeImageView *imgViewRow4;
    
    
    __weak IBOutlet ThemeLabel *labelRow5;
}

@end

@implementation MoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//
//    self.tableView.backgroundColor = [[ThemeManager shareInstance] getThemeColor:@"More_Item_color"];
//    self.tableView.separatorColor = [[ThemeManager shareInstance] getThemeColor:@"More_Item_Line_color"];
    
    
    
    labelRow1.colorName = @"More_Item_Text_color";
    labelRow2.colorName = @"More_Item_Text_color";
    labelRow3.colorName = @"More_Item_Text_color";
    labelRow4.colorName = @"More_Item_Text_color";
    labelRow5.colorName = @"More_Item_Text_color";
    
    detailLabelRow1.colorName = @"More_Item_Text_color";
    
    detailLabelRow3.colorName = @"More_Item_Text_color";
    
    imgViewRow1.imageName = @"more_icon_theme.png";
    imgViewRow2.imageName = @"more_icon_feedback.png";
    imgViewRow3.imageName = @"more_icon_draft.png";
    imgViewRow4.imageName = @"more_icon_account.png";

}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    //设置tableview背景颜色及分割线颜色。
    
    self.tableView.backgroundColor = [[ThemeManager shareInstance] getThemeColor:@"More_Item_color"];
    self.tableView.separatorColor = [[ThemeManager shareInstance] getThemeColor:@"More_Item_Line_color"];
    
    detailLabelRow1.text = [ThemeManager shareInstance].themeName;
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
