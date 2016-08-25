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
@property (weak, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet BrushAlphaAndWidthView *brushAlphaAndWidthView;
@property (weak, nonatomic) IBOutlet UIView *layerBoard;
@property (weak, nonatomic) IBOutlet UIView *layerEditView;
@end

@interface MainViewController ()<CanvasViewDelegate>
@property (strong, nonatomic) CanvasView *canvasView;
@property (nonatomic, strong) PaletteViewController *paletteViewController;
@property (nonatomic, strong) BrushSelectViewController *brushViewController;
@end

@interface MainViewController ()
@property (nonatomic, copy) UIColor *color;
@property (nonatomic, strong) Brush *brush;
@property (nonatomic) CGFloat radius;
@property (nonatomic, strong) Canvas *canvas;

@property (nonatomic, strong) LayerControl *currentControl;
@end
@implementation MainViewController
- (IBAction)addLayer:(UIButton *)sender
{
    if(_canvas.layerCount<3){
    [self addLayer];
    }
}

- (void)clickLayerControl:(LayerControl *)sender
{
    _paletteViewBoard.hidden =true;
    _brushAlphaAndWidthView.hidden = true;
    if(sender == _currentControl){
          _layerEditView.hidden = !_layerEditView.hidden;
    }
    _currentControl.layer.borderColor = [UIColor blackColor].CGColor;
    _currentControl = sender;
    _currentControl.layer.borderColor = [UIColor blueColor].CGColor;
    [_canvas setForeLayer:sender.drawingLayer];
}

- (IBAction)clickClear:(UIButton *)sender
{
    [_canvas clear];
}
- (IBAction)clickUndo:(UIButton *)sender
{
    [_canvas undo];
}
- (IBAction)clickRedo:(UIButton *)sender
{
    [_canvas redo];
}
- (IBAction)clickFullScreen:(UIView *)sender
{
    if(_toolbarView.hidden){
         _toolbarView.hidden = false;
        _layerBoard.hidden = false;
        _brushViewBoard.hidden = false;
        [UIView animateWithDuration:0.3
                         animations:^{
                             _toolbarView.center = CGPointMake(_toolbarView.center.x, _toolbarView.frame.size.height/2);
                             _layerBoard.center = CGPointMake(self.view.bounds.size.width - _layerBoard.frame.size.width/2, _layerBoard.center.y);
                             _brushViewBoard.center = CGPointMake(_brushViewBoard.frame.size.width/2, _brushViewBoard.center.y);
                         }
                         completion:nil
         ];
    }else{
        [UIView animateWithDuration:0.3
                         animations:^{
                            _toolbarView.center = CGPointMake(_toolbarView.center.x, -_toolbarView.frame.size.height/2);
                             _layerBoard.center = CGPointMake(self.view.bounds.size.width + _layerBoard.frame.size.width/2, _layerBoard.center.y);
                             _brushViewBoard.center = CGPointMake(- _brushViewBoard.frame.size.width/2, _brushViewBoard.center.y);
                         }
                         completion:^(BOOL finished){
                             _toolbarView.hidden = true;
                             _layerBoard.hidden = true;
                             _brushViewBoard.hidden = true;
                         }
         ];
    }

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
    _canvasView.delegate = self;
    [self addLayer];

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

- (void)addLayer
{
    [_canvas addLayer];
    [_canvasView.layer addSublayer:_canvas.foreLayer.layer];
    CGRect rect = CGRectMake(0, _layerBoard.frame.size.height - _canvas.layerCount * 90-90 , 88, 88);
    LayerControl *control = [[LayerControl alloc] initWithFrame:rect];
    control.drawingLayer = _canvas.foreLayer;
    control.layer.borderWidth = 2;
    [control addTarget:self action:@selector(clickLayerControl:) forControlEvents:UIControlEventTouchUpInside];
    _currentControl.layer.borderColor = [UIColor blackColor].CGColor;
    _currentControl = control;
    _currentControl.layer.borderColor = [UIColor blueColor].CGColor;
    [_layerBoard addSubview:control];
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

#pragma mark - CanvasViewDelegate

- (void)touchBegan:(CGPoint)point
{
    _paletteViewBoard.hidden =true;
    _brushAlphaAndWidthView.hidden = true;
    _layerEditView.hidden = true;
    [_canvas.foreLayer newStrokeWithBrush:_canvas.currentBrush];
    [_canvas updateWithPoint:point];
}
- (void)touchMoved:(CGPoint)point
{
    [_canvas updateWithPoint:point];
}
- (void)touchEnded:(CGPoint)point
{
    [_canvas updateWithPoint:point];
    [_canvas.foreLayer addStroke];
    
}
@end

