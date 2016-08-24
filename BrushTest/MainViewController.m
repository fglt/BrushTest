//
//  ViewController.m
//  BrushTest
//
//  Created by Coding on 8/12/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "MainViewController.h"
#import "CanvasView.h"
#import "FGTHSBSupport.h"
#import "CircleColcorPicker.h"
#import "SquareColorPicker.h"
#import "PaletteViewController.h"
#import "BrushSelectViewController.h"
#import "Brush.h"
#import "BrushAlphaAndWidthView.h"
#import "DrawingLayer.h"
#import "LayerControl.h"
#import "Canvas.h"

@interface MainViewController ()<PaletteViewControllerDelegate, BrushSelectViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *brushViewBoard;
@property (weak, nonatomic) IBOutlet UIView *paletteViewBoard;
@property (strong, nonatomic) CanvasView *canvasView;
@property (weak, nonatomic) IBOutlet BrushAlphaAndWidthView *brushAlphaAndWidthView;
@property (nonatomic, strong) PaletteViewController *paletteViewController;
@property (nonatomic, strong) BrushSelectViewController *brushViewController;
@property (weak, nonatomic) IBOutlet UIView *layerBoard;
@end
@interface MainViewController ()
@property (nonatomic, copy) UIColor *color;
@property (nonatomic, strong) Brush *brush;
@property (nonatomic) CGFloat radius;
@property (nonatomic, strong) Canvas *canvas;
@end
@implementation MainViewController
- (IBAction)addLayer:(UIButton *)sender {
    if(_canvasView.canvas.layerCount<3){
    [_canvasView  addLayer];
    CGRect rect = CGRectMake(0, _layerBoard.frame.size.height - _canvasView.canvas.layerCount * 90-90 , 88, 88);
    LayerControl *control = [[LayerControl alloc] initWithFrame:rect];
        control.drawingLayer = _canvasView.canvas.foreLayer;
    control.layer.borderWidth = 2;
        [control addTarget:self action:@selector(clickLayerControl:) forControlEvents:UIControlEventTouchUpInside];
    
    [_layerBoard addSubview:control];
    }
}

- (void)clickLayerControl:(LayerControl *)sender
{
    [_canvasView.canvas setForeLayer:sender.drawingLayer];
    NSLog(@"click: %@", sender);
}

- (IBAction)clickClear:(UIButton *)sender {
    [_canvas clear];
    [_canvasView displayContent];
}
- (IBAction)clickUndo:(UIButton *)sender {
    [_canvas undo];
    [_canvasView displayContent];
}
- (IBAction)clickRedo:(UIButton *)sender {
    [_canvas redo];
    [_canvasView displayContent];
}
- (IBAction)clickColor:(UIButton *)sender {
    self.brushAlphaAndWidthView.hidden = YES;
    if(!self.paletteViewBoard.hidden){
        self.paletteViewBoard.hidden = YES;
    }else{
        [self dispalyPaletteView];
    }
}
- (IBAction)brushSlider:(UISlider *)sender {
    _brush.width = _brushAlphaAndWidthView.radiusSlider.value * 30 +1;
    _brush.color = [_brush.color colorWithAlphaComponent:_brushAlphaAndWidthView.alphaSlider.value];
}

- (void) start
{
    _color =  [UIColor redColor];
    _radius = 26;
    _brush = [Brush BrushWithColor:_color radius:_radius type:BrushTypeGradient];
    _brushAlphaAndWidthView.radiusSlider.value = (_radius-1)/30;
    _brushAlphaAndWidthView.alphaSlider.value =  CGColorGetAlpha(_color.CGColor);
    self.brushAlphaAndWidthView.hidden = YES;
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

- (void)addBrushView
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _brushViewController = [storyBoard instantiateViewControllerWithIdentifier:@"BrushSelectViewController"];
    [self addChildViewController:_brushViewController];
    _brushViewController.brushSelectViewControllerDelegate = self;
    CGRect frame = CGRectMake(0,60, self.brushViewBoard.frame.size.width, self.brushViewBoard.frame.size.height - 60);
    _brushViewController.view.frame = frame;
    [self.brushViewBoard addSubview:_brushViewController.view];
    [_brushViewController didMoveToParentViewController:self];
    _brushViewController.type = _brush.brushType;
}

- (void)addCanvasView
{
    _canvas = [[Canvas alloc] initWithSize:self.view.bounds.size];
    _canvasView = [[CanvasView alloc] initWithFrame:self.view.bounds];
    _canvas.backgroundColor = [UIColor whiteColor];
    _canvas.canvasSize = _canvasView.bounds.size;
    _canvas.currentBrush = _brush;
    _canvasView.canvas = _canvas;
    DrawingLayer *layer = [DrawingLayer drawingLayerWithSize:_canvas.canvasSize];
    [_canvasView addLayer:layer];
    CGRect rect = CGRectMake(0, _layerBoard.frame.size.height - _canvasView.canvas.layerCount * 90 - 90, 88, 88);
    LayerControl *control = [[LayerControl alloc] initWithFrame:rect];
    control.drawingLayer = _canvasView.canvas.foreLayer;
    control.layer.borderWidth = 2;
    [control addTarget:self action:@selector(clickLayerControl:) forControlEvents:UIControlEventTouchUpInside];
    
    [_layerBoard addSubview:control];

    [self.view insertSubview:_canvasView atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self start];
    [self addCanvasView];
    [self addPaletteView];
    [self addBrushView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - PaletteViewControllerDelegate
-(void)colorChanged:(UIColor*)color
{
    self.color = [color copy];
    self.brush.color = self.color;
}

- (UIColor *)currentColor
{
    return _color;
}

#pragma mark - BrushSelectViewControllerDelegate

- (void)brushTypeSelected:(BrushType)brushType
{
    if(self.brushAlphaAndWidthView.hidden){
        [self displayBrushAlphaAndWidthView];
    }
    self.paletteViewBoard.hidden = YES;
    _brush = [Brush BrushWithColor:_color radius:_radius type:brushType];
    _canvas.currentBrush = _brush;
}

- (BrushType)currentBrushType
{
    return _brush.brushType;
}

- (void)displayBrushAlphaAndWidthView
{

    CGRect frame = self.brushAlphaAndWidthView.frame;
    self.brushAlphaAndWidthView.center = CGPointMake(-frame.size.width/2,  self.brushAlphaAndWidthView.center.y) ;
    self.brushAlphaAndWidthView.hidden = NO;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.brushAlphaAndWidthView.center = CGPointMake(frame.size.width/2 + _brushViewBoard.frame.size.width,  self.brushAlphaAndWidthView.center.y) ;
                     }
                     completion:^(BOOL finished){}
     ];
    
}

- (void)dispalyPaletteView
{
    CGRect frame = self.paletteViewBoard.frame;
    self.paletteViewBoard.center = CGPointMake(-frame.size.width/2,  self.paletteViewBoard.center.y);
    self.paletteViewBoard.hidden = NO;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.paletteViewBoard.center = CGPointMake(frame.size.width/2 + _brushViewBoard.frame.size.width,  self.paletteViewBoard.center.y) ;
                     }
                     completion:^(BOOL finished){}
     ];
}
@end
