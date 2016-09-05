//
//  blendModeTableViewController.m
//  BrushTest
//
//  Created by Coding on 9/3/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "BlendModeTableViewController.h"
#import "BlendMode.h"

@interface BlendModeTableViewController ()

@end

@implementation BlendModeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = 1;
    self.tableView.sectionHeaderHeight = 1;
    self.tableView.contentInset = UIEdgeInsetsMake(-30.0f, 0.0f, 0.0f, 0.0);

    BlendMode *blendModeNormal = [[BlendMode alloc]initWithMode:kCGBlendModeNormal description:@"Normal"];
    BlendMode *blendModeDarken = [[BlendMode alloc]initWithMode:kCGBlendModeDarken description:@"Darken"];
    BlendMode *blendModeMultiply = [[BlendMode alloc]initWithMode:kCGBlendModeMultiply description:@"Multiply"];
    BlendMode *blendModeColorBurn = [[BlendMode alloc]initWithMode:kCGBlendModeColorBurn description:@"ColorBurn"];
    BlendMode *blendModePlusDarker = [[BlendMode alloc]initWithMode:kCGBlendModePlusDarker description:@"PlusDarker"];
    BlendMode *blendModeLighten = [[BlendMode alloc]initWithMode:kCGBlendModeLighten description:@"Lighten"];
    BlendMode *blendModeScreen = [[BlendMode alloc]initWithMode:kCGBlendModeScreen description:@"Screen"];
    BlendMode *blendModeColorDodge = [[BlendMode alloc]initWithMode:kCGBlendModeColorDodge description:@"ColorDodge"];
    BlendMode *blendModePlusLighter = [[BlendMode alloc]initWithMode:kCGBlendModePlusLighter description:@"PlusLighter"];
    BlendMode *blendModeSourceIn = [[BlendMode alloc]initWithMode:kCGBlendModeSourceIn description:@"SourceIn"];
    BlendMode *blendModeDifference = [[BlendMode alloc]initWithMode:kCGBlendModeDifference description:@"Difference"];
    BlendMode *blendModeOverlay = [[BlendMode alloc]initWithMode:kCGBlendModeOverlay description:@"Overlay "];
    BlendMode *blendModeSoftLight = [[BlendMode alloc]initWithMode:kCGBlendModeSoftLight description:@"SoftLight"];
    BlendMode *blendModeHardLight = [[BlendMode alloc]initWithMode:kCGBlendModeHardLight description:@"HardLight"];
    BlendMode *blendModeHue = [[BlendMode alloc]initWithMode:kCGBlendModeHue description:@"Hue"];
    BlendMode *blendModeSaturation = [[BlendMode alloc]initWithMode:kCGBlendModeSaturation description:@"Saturation"];
    BlendMode *blendModeColor = [[BlendMode alloc]initWithMode:kCGBlendModeColor description:@"Color"];
    BlendMode *blendModeLuminosity = [[BlendMode alloc]initWithMode:kCGBlendModeLuminosity description:@"Luminosity"];
    NSArray *section1 = @[blendModeNormal];
    NSArray *section2 = @[blendModeDarken, blendModeMultiply, blendModeColorBurn, blendModePlusDarker];
    NSArray *section3 = @[blendModeLighten, blendModeScreen, blendModeColorDodge, blendModePlusLighter, blendModeSourceIn,blendModeDifference];
    NSArray *section4 = @[blendModeOverlay,blendModeSoftLight,blendModeHardLight];
    NSArray *section5 =@[blendModeHue, blendModeSaturation, blendModeColor, blendModeLuminosity];
    _sectionArray = @[section1, section2, section3, section4, section5] ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *se = _sectionArray[section];
    return se.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blendModeCell" forIndexPath:indexPath];
    
    NSArray *sa = _sectionArray[indexPath.section];
    BlendMode *bm = (BlendMode *)sa[indexPath.row];
    cell.textLabel.text = bm.blendModeName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(bm.blendMode == [_controllerDelegate curBlendMode]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
         [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }else {
        //要添加此句， 因为复用的原因，被选中的单元格被复用时
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    NSArray *array = _sectionArray[indexPath.section];
    BlendMode *mode = array[indexPath.row];
    [_controllerDelegate blendModeChanged:mode];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame: CGRectMake(20, 0.0f, tableView.bounds.size.width-40, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;

}

@end
