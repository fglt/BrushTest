//
//  ViewController.m
//  BrushTest
//
//  Created by Coding on 8/12/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "MainViewController.h"
#import "CanvasView.h"
#import "InfHSBSupport.h"
#import "CircleColcorPicker.h"
#import "SquareColorPicker.h"
#import "PaletteViewController.h"
#import "BrushSelectViewController.h"
#import "Brush.h"


@interface MainViewController ()<PaletteViewControllerDelegate, BrushSelectViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *brushViewBoard;
@property (weak, nonatomic) IBOutlet UIView *paletteViewBoard;
@property (weak, nonatomic) IBOutlet CanvasView *canvasView;
@property (nonatomic, strong) PaletteViewController* paletteViewController;
@property (nonatomic, strong) BrushSelectViewController* brushViewController;

@property (nonatomic, copy) UIColor*color;
@property (nonatomic, strong) Brush* brush;
@end

@implementation MainViewController

- (IBAction)clickClear:(UIButton *)sender {
    [self.canvasView clear];
}
- (IBAction)clickUndo:(UIButton *)sender {
    [self.canvasView undo];
}
- (IBAction)clickRedo:(UIButton *)sender {
    [self.canvasView redo];
}

- (void) start
{
    _color =  [UIColor redColor];
    _brush = [Brush BrushWithColor:_color radius:26 type:BrushTypeCircle];
    _canvasView.currentBrush = _brush;
}

-(void) addPaletteView
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _paletteViewController = [storyBoard instantiateViewControllerWithIdentifier:@"PaletteViewController"];
    [self addChildViewController:_paletteViewController];
    _paletteViewController.delegate = self;
    _paletteViewController.view.frame = self.paletteViewBoard.bounds;
    [self.paletteViewBoard addSubview:_paletteViewController.view];
    [_paletteViewController didMoveToParentViewController:self];
}

-(void) addBrushView
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _brushViewController = [storyBoard instantiateViewControllerWithIdentifier:@"BrushSelectViewController"];
    [self addChildViewController:_brushViewController];
    _brushViewController.brushSelectViewControllerDelegate = self;
    _brushViewController.view.frame = self.brushViewBoard.bounds;
    [self.brushViewBoard addSubview:_brushViewController.view];
    [_brushViewController didMoveToParentViewController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self start];
    [self addPaletteView];
    [self addBrushView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) prefersStatusBarHidden
{
    return YES;
}

#pragma mark - PaletteViewControllerDelegate
-(void)colorChanged:(UIColor*)color
{
    self.color = [color copy];
    self.brush.color = self.color;
}

-(UIColor *) currentColor
{
    return _color;
}

#pragma mark - BrushSelectViewControllerDelegate

- (void)brushSelected:(Brush*) brush
{
    _brush = brush;
    _canvasView.currentBrush = brush;
}

- (UIColor*) brushColor
{
    return _color;
}

-(Brush *)currentBrush
{
    return _brush;
}
@end
