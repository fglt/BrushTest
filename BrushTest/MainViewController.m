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
#import "LayerEditView.h"
#import "UIView+FGTDrawing.h"

@interface MainViewController ()<PaletteViewControllerDelegate, BrushSelectViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *brushViewBoard;
@property (weak, nonatomic) IBOutlet UIView *paletteViewBoard;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet BrushAlphaAndWidthView *brushAlphaAndWidthView;
@property (weak, nonatomic) IBOutlet UIView *layerBoard;
@property (weak, nonatomic) IBOutlet LayerEditView *layerEditView;
@property (weak, nonatomic) IBOutlet UIButton *ColorView;
@end

@interface MainViewController ()<CanvasViewDelegate>
@property (strong, nonatomic) CanvasView *canvasView;
@property (nonatomic, strong) PaletteViewController *paletteViewController;
@property (nonatomic, strong) BrushSelectViewController *brushViewController;
@property (nonatomic, strong) LayerControl *currentControl;
@end

@interface MainViewController ()
@property (nonatomic, copy) UIColor *color;
@property (nonatomic, strong) Brush *brush;
@property (nonatomic) CGFloat radius;
@property (nonatomic, strong) Canvas *canvas;
@property (nonatomic, strong) NSMutableArray *layerControlArray;
@end

@implementation MainViewController


- (void)start
{
    _color =  [UIColor redColor];
    _layerControlArray = [NSMutableArray array];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 44, 44);
    layer.contents = (id)[UIImage imageNamed:@"palette_indicator_mask"].CGImage;
    _ColorView.layer.mask = layer;
    _ColorView.backgroundColor = _color;
    _radius = 26;
    _brush = [Brush BrushWithColor:_color radius:_radius type:BrushTypeGradient];
    _brushAlphaAndWidthView.radiusSlider.value = (_radius-1)/30;
    _brushAlphaAndWidthView.alphaSlider.value =  CGColorGetAlpha(_color.CGColor);
    self.brushAlphaAndWidthView.hidden = YES;
}

- (void)addPaletteView
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
    [self addDrawingLayer];
    
    [self.view insertSubview:_canvasView atIndex:0];
}

- (void)configLayerEditView
{
    NSString *text = [NSString stringWithFormat:@"图层 %lu / %ld", [_layerControlArray indexOfObject:_currentControl] + 1, _layerControlArray.count];
    _layerEditView.title.text = text;
    if(_layerControlArray.count==1){
        _layerEditView.merge.activity = false;
        _layerEditView.del.activity = false ;
        _layerEditView.mergeAll.activity = false;
    }else{
        _layerEditView.merge.activity = true;
        _layerEditView.del.activity = true ;
        _layerEditView.mergeAll.activity = true;
    }
    NSUInteger index = [_layerControlArray indexOfObject:_currentControl];
    _layerEditView.merge.activity = index;
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

-(void)setCurrentControl:(LayerControl *)currentControl
{
    _currentControl.layer.borderColor = [UIColor grayColor].CGColor;
    _currentControl = currentControl;
    _currentControl.layer.borderColor = [UIColor blueColor].CGColor;
    [self configLayerEditView];
}

#pragma mark - toolbarView events
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
        _paletteViewBoard.hidden = true;
        _brushAlphaAndWidthView.hidden = true;
        _layerEditView.hidden = true;
        
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


#pragma mark - brushBoardEvents
- (IBAction)clickColor:(UIButton *)sender {
    self.brushAlphaAndWidthView.hidden = true;
    self.layerEditView.hidden = true;
    if(!self.paletteViewBoard.hidden){
        self.paletteViewBoard.hidden = true;
    }else{
        [self dispalyPaletteView];
        [_paletteViewController setLastColor:_color];
    }
}
- (IBAction)brushSlider:(UISlider *)sender {
    _brush.width = _brushAlphaAndWidthView.radiusSlider.value * 30 +1;
    _brush.color = [_brush.color colorWithAlphaComponent:_brushAlphaAndWidthView.alphaSlider.value];
}



#pragma mark - PaletteViewControllerDelegate
- (void)colorChanged:(UIColor*)color
{
    self.color = [color copy];
    _ColorView.layer.backgroundColor = color.CGColor;
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

#pragma mark - layerEditView layerborad
- (IBAction)clickLayerEditButton:(UIButton *)sender {
    /**
     复制30 剪切 粘贴 拷贝
     清除 合并 合并所有 删除37
     **/
    NSUInteger index = [_layerControlArray indexOfObject:_currentControl];
    switch (sender.tag) {
        case 30:
            break;
        case 31:
            break;
        case 32:
            break;
        case 33:
            break;
        case 34:
            break;
        case 35:
            
            break;
        case 36:
            break;
        case 37:{
            if(_layerControlArray.count ==  1)break;
            [_currentControl removeFromSuperview];
            [_currentControl.drawingLayer.layer removeFromSuperlayer];
            [_canvas.drawingLayers removeObject:_currentControl.drawingLayer];
            [_layerControlArray removeObjectAtIndex:index];
            [self reloadLayerBoard];
            if(index>0) index--;
            self.currentControl = [_layerControlArray objectAtIndex:index];
            break;
        }
        default:
            break;
    }
    
    _layerEditView.hidden = true;
}

-(void) reloadLayerBoard
{
    [_layerControlArray enumerateObjectsUsingBlock:^(LayerControl*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.center = CGPointMake(_layerBoard.bounds.size.width/2, _layerBoard.frame.size.height - idx * 90 - 135);
    }];
}

- (void)clickLayerControl:(LayerControl *)sender
{
    _paletteViewBoard.hidden =true;
    _brushAlphaAndWidthView.hidden = true;
    if(sender == _currentControl){
        _layerEditView.hidden = !_layerEditView.hidden;
    }
    self.currentControl = sender;
    [_canvas setForeLayer:sender.drawingLayer];
    [self configLayerEditView];
}

- (IBAction)addLayer:(UIButton *)sender
{
    if(_layerControlArray.count<3){
        [self addDrawingLayer];
    }
}

- (void)addDrawingLayer
{
    [_canvas addLayer];
    [_canvasView.layer addSublayer:_canvas.foreLayer.layer];
    CGRect rect = CGRectMake(1, _layerBoard.frame.size.height - _layerControlArray.count * 90-180 , 88, 88);
    LayerControl *control = [[LayerControl alloc] initWithFrame:rect];
    [_layerControlArray addObject:control];
    control.layerIndex = (int)_canvas.layerCount;
    control.drawingLayer = _canvas.foreLayer;
    [control addTarget:self action:@selector(clickLayerControl:) forControlEvents:UIControlEventTouchUpInside];
    self.currentControl = control;
    [_layerBoard addSubview:control];
}

@end

