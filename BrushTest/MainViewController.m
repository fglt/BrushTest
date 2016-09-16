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
#import "Brush.h"
#import "BrushSlider.h"
#import "DrawingLayer.h"
#import "LayerControl.h"
#import "Canvas.h"
#import "LayerEditView.h"
#import "UIView+FGTDrawing.h"
#import "CanvasDao.h"
#import "BlendModeTableViewController.h"
#import "UIKit/UIGestureRecognizerSubclass.h"
#import "FigureView.h"


@interface MainViewController ()<PaletteViewControllerDelegate,BlendModeTableViewControllerDelegate,CanvasBackgroundControlDelegate>
@property (weak, nonatomic) IBOutlet UIView *brushViewBoard;
@property (weak, nonatomic) IBOutlet UIView *paletteViewBoard;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet BrushSlider *brushSlider;
@property (weak, nonatomic) IBOutlet UIView *layerBoard;
@property (weak, nonatomic) IBOutlet LayerEditView *layerEditView;
@property (weak, nonatomic) IBOutlet UIButton *colorView;
@property (weak, nonatomic) IBOutlet CanvasBackgroundControl *backgroundColorControl;
@property (weak, nonatomic) IBOutlet UIView *blendModeBoard;
@property (weak, nonatomic) IBOutlet UIView *backColorViewBoard;
@property (weak, nonatomic) IBOutlet UIView *figureToolsBar;
@end

@interface MainViewController ()<LayerControlDelegate>
@property (strong, nonatomic) CanvasView *canvasView;
@property (nonatomic, strong) FigureView *figureView;
@property (nonatomic, strong) PaletteViewController *paletteViewController;
@property (nonatomic, strong) BlendModeTableViewController *blendModeController;
@property (nonatomic, strong) PaletteViewController *backGroundColorSetController;
@property (nonatomic, strong) LayerControl *currentControl;
@end

@interface MainViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, copy) UIColor *color;
@property (nonatomic, strong) Brush *brush;
@property (nonatomic) BrushType type;
@property (nonatomic) CGFloat width;
@property (nonatomic, strong) Canvas *canvas;
@property (nonatomic, strong) NSMutableArray *layerControlArray;
@property (nonatomic, strong) CanvasDao *canvasDao;
@property (nonatomic, strong) DrawingLayer *drawingLayerForPaste;
@property (nonatomic, strong) BlendMode * blendMode;
@property (nonatomic) FigureType figureType;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) BOOL figuring;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) CGFloat rotation;
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint translation;

@end

@implementation MainViewController

- (void)start
{
    _scale = 1;
    _rotation = 0;
    _translation = CGPointZero;
    self.view.backgroundColor = [UIColor clearColor];

    _layerControlArray = [NSMutableArray array];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 44, 44);
    layer.contents = (id)[UIImage imageNamed:@"palette_indicator_mask"].CGImage;
    _colorView.layer.mask = layer;
    self.brushSlider.hidden = YES;
    _canvasDao = [CanvasDao sharedManager];
}

- (void)addBlendModeView
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _blendModeController = [storyBoard instantiateViewControllerWithIdentifier:@"blendModeController"];
    [self addChildViewController:_blendModeController];
    _blendModeController.controllerDelegate = self;
    
    _blendModeController.view.frame = _blendModeBoard.bounds;
    [_blendModeBoard addSubview:_blendModeController.view];
    [_blendModeController didMoveToParentViewController:self];
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

- (void)addCanvasView
{

    _canvas = [_canvasDao tempCanvs];
    if(!_canvas){
        _canvas = [[Canvas alloc]initWithSize:self.view.bounds.size];
        [_canvasDao create:_canvas];
    }
    CGSize screenSize = self.view.bounds.size;
    _canvasView = [[CanvasView alloc] initWithFrame:CGRectMake((screenSize.width-_canvas.canvasSize.width)/2, (screenSize.height - _canvas.canvasSize.height)/2, _canvas.canvasSize.width, _canvas.canvasSize.height)];
    _figureView = [[FigureView alloc] initWithFrame:self.view.frame];
    _figureView.backgroundColor =[UIColor clearColor];
    _canvasView.backgroundColor = _canvas.backgroundColor;
    _canvas.view = _canvasView;
    [_canvasView.layer insertSublayer:_canvas.layer atIndex:0];
    
    [_canvas updateLayer];

    [self configureLayerBorad];

    [self.view insertSubview:_canvasView atIndex:0];
    [self.view insertSubview:_figureView atIndex:1];
    _brush = _canvas.currentBrush;
    _width = _brush.width;
    _color = _brush.color;
    _colorView.backgroundColor = [_color colorWithAlphaComponent:1];
    _type = _brush.brushType;
    _brushSlider.radiusSlider.value = (_width-1)/30;
    _brushSlider.alphaSlider.value =  CGColorGetAlpha(_color.CGColor);
}
- (void)addBackGroundColorView
{
    UIStoryboard *storyboard = [ UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _backGroundColorSetController = [storyboard instantiateViewControllerWithIdentifier:@"PaletteViewController"];
    [self addChildViewController:_backGroundColorSetController];
    _backGroundColorSetController.delegate = self;
    
    _backGroundColorSetController.view.frame = self.backColorViewBoard.bounds;
    [self.backColorViewBoard addSubview:_backGroundColorSetController.view];
    [_backGroundColorSetController didMoveToParentViewController:self];

}

- (void) configureLayerBorad
{
    for (DrawingLayer *dlayer in _canvas.drawingLayers) {
        //[_canvasView.layer addSublayer:dlayer.layer];

        CGRect rect = CGRectMake(1, 1 , 88, 88);
        
        LayerControl *control = [[LayerControl alloc] initWithFrame:rect];
        [_layerControlArray addObject:control];
        control.drawingLayer = dlayer;
        control.layerControlDelegate =self;
        control.layer.contents = control.drawingLayer.layer.contents;
        [control addTarget:self action:@selector(clickLayerControl:) forControlEvents:UIControlEventTouchUpInside];
        [_layerBoard addSubview:control];
    }
     self.currentControl = _layerControlArray[_layerControlArray.count -1];
    
}

- (void)configLayerEditView
{
    [_layerEditView.blendModeButton setTitle:[self blendModeNameForBlendMode:_currentControl.drawingLayer.blendMode] forState:UIControlStateNormal];
    NSString *text = [NSString stringWithFormat:@"图层 %lu / %ld", [_layerControlArray indexOfObject:_currentControl] + 1, _layerControlArray.count];
    _layerEditView.title.text = text;
    _layerEditView.alphaSlider.value = _currentControl.drawingLayer.alpha;
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
    [self addBlendModeView];
    [self addBackGroundColorView];
    _backgroundColorControl.controlDelegate = self;
    [self addGestureRecognizer];
  
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadLayerBoard];
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
    _canvas.currentDrawingLayer = _currentControl.drawingLayer;
    [self configLayerEditView];
}

- (void)addGestureRecognizer
{
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    _panGestureRecognizer.maximumNumberOfTouches =1;
    [_figureView addGestureRecognizer:_panGestureRecognizer];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_figureView addGestureRecognizer:tapGestureRecognizer];
    
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[ UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleRotation:)];
    rotationGestureRecognizer.delegate  = self;
    [_figureView addGestureRecognizer:rotationGestureRecognizer];
    
    UIPinchGestureRecognizer *pinGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinGestureRecognizer.delegate = self;
    [_figureView addGestureRecognizer:pinGestureRecognizer];
    
    UIPanGestureRecognizer *dragGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragRecognizer:)];
    dragGestureRecognizer.minimumNumberOfTouches = 2;
    dragGestureRecognizer.maximumNumberOfTouches = 2;
    dragGestureRecognizer.delegate = self;
    [_figureView addGestureRecognizer:dragGestureRecognizer];
    
}
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark - Gesture handle

- (void)handlePan:(UIPanGestureRecognizer*) recognizer
{
    _paletteViewBoard.hidden =YES;
    _blendModeBoard.hidden = YES;
    _brushSlider.hidden = YES;
    _layerEditView.hidden = YES;
    _backColorViewBoard.hidden = YES;
    if(_canvas.currentDrawingLayer.locked) return;
    if(_figuring){
        [self handleFigureGesture:recognizer];
    }else{
        [self handleNoFigure:recognizer];
    }
}

- (void)handleNoFigure:(UIPanGestureRecognizer*) recognizer
{
     CGPoint point = [recognizer locationInView:_canvasView];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [_canvas newStrokeWithFigureType:_figureType];
            [_canvas addPoint:point];
            if(!_canvas.currentDrawingLayer.visible){
                [self presentVisibleAlert];
                [recognizer setState:UIGestureRecognizerStateCancelled];
                return;
            }
            break;
        case UIGestureRecognizerStateChanged:
            [_canvas addPointAndDraw:point];
            break;
        case UIGestureRecognizerStateEnded:{
            [_canvas addPointAndDraw:point];
            [_canvas addStroke];
            [_canvasDao modify:_canvas];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_currentControl updateContents];
            });
            [[self.undoManager prepareWithInvocationTarget:self]undo];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        default:
            break;
    }

}

- (void)handleFigureGesture:(UIPanGestureRecognizer*) recognizer
{
    CGPoint point = [recognizer locationInView:_canvasView];
    CGPoint locationInFigureView = [recognizer locationInView:_figureView];
    CGRect rect = _canvasView.bounds;
    rect = CGRectApplyAffineTransform(rect, _canvasView.transform);
    NSLog(@"%@", NSStringFromCGRect( rect));
       switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            _startPoint = locationInFigureView;
            [_canvas newStrokeWithFigureType:_figureType];
            [_canvas addPoint:point];
            break;
        case UIGestureRecognizerStateChanged:{
            if(_figureType==FigureTypeNone){
                [_canvas newStrokeIfNullWithFigureType:_figureType];
                [_canvas addPointAndDraw:point];
            }else{
                _figureView.bezierPath = [self bezierPathWithPoint:_startPoint secondPoint:locationInFigureView withFigureType:_figureType];;
                [_figureView setNeedsDisplay];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            [_canvas addPointAndDraw:point];
            [_canvas addStroke];
            [_canvasDao modify:_canvas];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_currentControl updateContents];
            });
            [[self.undoManager prepareWithInvocationTarget:self]undo];
            
            if(_figureType != FigureTypeNone){
                
                _figureView.bezierPath = nil;
                [_figureView setNeedsDisplay];
                
            }
        }
        default:
            break;
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    _paletteViewBoard.hidden =YES;
    _blendModeBoard.hidden = YES;
    _brushSlider.hidden = YES;
    _layerEditView.hidden = YES;
    _backColorViewBoard.hidden = YES;
    if(_canvas.currentDrawingLayer.locked) return;
    if(_figuring) return;
     CGPoint point = [recognizer locationInView:_canvasView];
    [_canvas newStrokeWithFigureType:_figureType];
    [_canvas addPointAndDraw:point];
    [_canvas addStroke];
    [_canvasDao modify:_canvas];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_currentControl updateContents];
    });
    [[self.undoManager prepareWithInvocationTarget:self]undo];
}

- (void)handleRotation:(UIRotationGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    
    CGFloat rotation = recognizer.rotation - _rotation;
    CGPoint translation = CGPointMake(location.x-_canvasView.center.x, location.y - _canvasView.center.y);
    CGAffineTransform  trans = CGAffineTransformMakeTranslation(translation.x, translation.y);
    trans = CGAffineTransformRotate(trans,rotation);
    trans = CGAffineTransformTranslate(trans,-translation.x, -translation.y);
    _canvasView.transform =CGAffineTransformConcat(_canvasView.transform, trans);
    _rotation = recognizer.rotation;
    if(recognizer.state == UIGestureRecognizerStateEnded){
        _rotation = 0;
    }
    
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    CGFloat scaling = recognizer.scale/_scale;
    CGPoint translation = CGPointMake(location.x-_canvasView.center.x, location.y - _canvasView.center.y);
    CGAffineTransform  trans = CGAffineTransformMakeTranslation(translation.x, translation.y);
    trans = CGAffineTransformScale(trans, scaling, scaling);
    trans = CGAffineTransformTranslate(trans,-translation.x, -translation.y);
     _canvasView.transform = CGAffineTransformConcat(_canvasView.transform, trans);
    _scale = recognizer.scale;
    if(recognizer.state == UIGestureRecognizerStateEnded){
         _scale = 1;
    }
}

- (void)handleDragRecognizer:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateChanged:{
            CGPoint tran = [recognizer translationInView:_figureView];
            CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(tran.x - _translation.x, tran.y -_translation.y);
            
            _canvasView.transform =CGAffineTransformConcat(_canvasView.transform, translationTransform);
            _translation = tran;
            break;
            
        }
        case UIGestureRecognizerStateEnded:{
             _translation = CGPointZero;
            break;
        }
        default:
            break;
    }

}

- (UIBezierPath *)bezierPathWithPoint:(CGPoint)p1 secondPoint:(CGPoint)point withFigureType:(FigureType)type
{
    UIBezierPath *bezierPath;
    switch (_figureType) {
        case FigureTypeLine:
            bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint:p1];
            [bezierPath addLineToPoint:point];
            break;
        case FigureTypeOval:{
            CGFloat w = ABS(point.x-p1.x);
            CGFloat h = ABS(point.y-p1.y);
            CGRect rect = CGRectMake(p1.x -w, p1.y-h, w*2, h*2);
            bezierPath = [UIBezierPath bezierPathWithOvalInRect:rect];
            break;
        }
        case FigureTypeRectangle:{
            CGFloat w = ABS(point.x-p1.x);
            CGFloat h = ABS(point.y-p1.y);
            CGRect rect = CGRectMake(MIN(p1.x, point.x), MIN(p1.y, point.y), w, h);
            bezierPath = [UIBezierPath bezierPathWithRect:rect];
        }
        default:
            break;
    }
    return bezierPath;
}
#pragma mark - toolbarView events

- (IBAction)clickMenu:(UIButton *)sender
{
    [_canvasDao saveToFile:_canvas];
}
- (IBAction)clickFigure:(UIButton *)sender {
    _figureToolsBar.hidden = !_figureToolsBar.hidden;
    self.figuring =  !_figureToolsBar.hidden;
    if(self.figuring){
        _figureType = FigureTypeLine;
    }else{
        _figureType = FigureTypeNone;
    }
}

- (IBAction)clickClear:(UIButton *)sender
{
    [_canvas clear];
    [_currentControl updateContents];
}

- (IBAction)clickUndo:(UIButton *)sender
{
    [self.undoManager undo];
}

- (void)undo
{
    [_canvas undo];
    [_currentControl updateContents];
    [[self.undoManager prepareWithInvocationTarget:self]redo];
}
- (void)redo
{
    [_canvas redo];
    [_currentControl updateContents];
    [[self.undoManager prepareWithInvocationTarget:self]undo];
}
- (IBAction)clickRedo:(UIButton *)sender
{
    [self.undoManager redo];
}
- (IBAction)clickRestButton:(UIButton *)sender {
    _canvasView.transform = CGAffineTransformIdentity;
}

- (IBAction)clickFullScreen:(UIView *)sender
{
    if(_toolbarView.hidden){
         _toolbarView.hidden = NO;
        _layerBoard.hidden = NO;
        _brushViewBoard.hidden = NO;
        [UIView animateWithDuration:0.3
                         animations:^{
                             _toolbarView.center = CGPointMake(_toolbarView.center.x, _toolbarView.frame.size.height/2);
                             _layerBoard.center = CGPointMake(self.view.bounds.size.width - _layerBoard.frame.size.width/2, _layerBoard.center.y);
                             _brushViewBoard.center = CGPointMake(_brushViewBoard.frame.size.width/2, _brushViewBoard.center.y);
                         }
                         completion:nil
         ];
    }else{
        _paletteViewBoard.hidden = YES;
        _brushSlider.hidden = YES;
        _layerEditView.hidden = YES;
        _blendModeBoard.hidden = YES;
        _backColorViewBoard.hidden = YES;
        [UIView animateWithDuration:0.3
                         animations:^{
                            _toolbarView.center = CGPointMake(_toolbarView.center.x, -_toolbarView.frame.size.height/2);
                             _layerBoard.center = CGPointMake(self.view.bounds.size.width + _layerBoard.frame.size.width/2, _layerBoard.center.y);
                             _brushViewBoard.center = CGPointMake(- _brushViewBoard.frame.size.width/2, _brushViewBoard.center.y);
                         }
                         completion:^(BOOL finished){
                             _toolbarView.hidden = YES;
                             _layerBoard.hidden = YES;
                             _brushViewBoard.hidden = YES;
                         }
         ];
    }

}

- (IBAction)clickFigureToolsButton:(UIButton *)sender {
    switch (sender.tag) {
        case 40:
            self.figuring = NO;
            _figureType = FigureTypeNone;
            _figureToolsBar.hidden = YES;
            break;
        case 41:
            _figuring = TRUE;
            _figureType = FigureTypeLine;
            break;
        case 42:
            _figureType = FigureTypeOval;
            _figuring = TRUE;
            break;
        case 43:
            _figureType = FigureTypeRectangle;
            _figuring = TRUE;
            break;
        case 44:
            _figureToolsBar.hidden = YES;
            break;
        default:
            break;
    }
}


#pragma mark - brushBoardEvents
- (IBAction)clickColor:(UIButton *)sender {
    self.brushSlider.hidden = YES;
    self.layerEditView.hidden = YES;
    _blendModeBoard.hidden = YES;
    _backColorViewBoard.hidden = YES;
    _backColorViewBoard.hidden = YES;
    if(!self.paletteViewBoard.hidden){
        self.paletteViewBoard.hidden = YES;
    }else{
        [self dispalyPaletteView];
        [_paletteViewController setLastColor:[_color colorWithAlphaComponent:1]];
    }
}
- (IBAction)brushSlider:(UISlider *)sender {
    _width = _brushSlider.radiusSlider.value * 30 +1;
    _brush.width = _brushSlider.radiusSlider.value * 30 +1;
    _color = [_color colorWithAlphaComponent:_brushSlider.alphaSlider.value];
    _brush.color = _color;
}

- (IBAction)clickBrush:(UIButton *)sender {
    switch (sender.tag) {
        case 11:
            _type = BrushTypeCircle;
            break;
        case 12:
            _type = BrushTypeOval;
            break;
        case 13:
            _type = BrushTypeGradient;
            break;
        case 14:
            _type = BrushTypeChineseBrush;
            break;
        case 15:
            _type = BrushTypeClear;
            break;
        default:
            _type = BrushTypeCircle;
            break;
    }
    
    if(self.brushSlider.hidden){
        [self displaybrushSlider];
    }
    _blendModeBoard.hidden = YES;
    self.paletteViewBoard.hidden = YES;
    if(_type != _brush.brushType){
        _brush = [Brush BrushWithColor:_color width:_width type:_type];
        _brushSlider.radiusSlider.value = (_brush.width-1)/30;
        _canvas.currentBrush = _brush;
    }
}

#pragma mark - PaletteViewControllerDelegate
- (void)colorChanged:(PaletteViewController *)paletteController :(UIColor*)color
{
    if(paletteController == _paletteViewController){
    //self.color = [color copy];错误，alpha总是1
    self.color = [color colorWithAlphaComponent:_brushSlider.alphaSlider.value];
    _colorView.backgroundColor = color;
    self.brush.color = self.color;
    _brush = [Brush BrushWithColor:_color width:_width type:_type];
    _canvas.currentBrush = _brush;
    }else{
        _canvas.backgroundColor = [color copy];
        _backgroundColorControl.colorView.backgroundColor = color;
        [_canvas updateLayer];
    }
}

- (UIColor *)currentColor:(PaletteViewController *)paletteController
{
    if(paletteController == _paletteViewController){
        return _color;
    }else{
        return _canvas.backgroundColor;
    }
}

- (void)displaybrushSlider
{

    CGRect frame = self.brushSlider.frame;
    self.brushSlider.center = CGPointMake(-frame.size.width/2,  self.brushSlider.center.y) ;
    self.brushSlider.hidden = NO;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.brushSlider.center = CGPointMake(frame.size.width/2 + _brushViewBoard.frame.size.width,  self.brushSlider.center.y) ;
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



- (void)presentVisibleAlert
{
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"当前图层已隐藏"
                                        message:@"不能在隐藏图层上绘制。"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    
    UIAlertAction *displayAction = [UIAlertAction actionWithTitle:@"显示图层"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              _currentControl.visible = YES;
                                                          }];
    [alertController addAction:displayAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:TRUE completion:nil];
    
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
            _drawingLayerForPaste = [_canvas.currentDrawingLayer copy];
            break;
        case 31:
            _drawingLayerForPaste = [_canvas.currentDrawingLayer copy];
            [_canvas clear];
            [_currentControl updateContents];
            [_canvas updateLayer];
            break;
        case 32:
            [_canvas.currentDrawingLayer addStrokes:_drawingLayerForPaste.strokes];
            [_currentControl updateContents];
            break;
        case 33:
            _layerEditView.hidden = YES;
            if(_layerControlArray.count<3){
                DrawingLayer *layer = [_canvas.currentDrawingLayer copy];
                [self addDrawingLayer:layer];
            }
             [_canvas updateLayer];
//            _canvas.currentDrawingLayer.
            break;
        case 34:
            [_canvas clear];
            [_currentControl updateContents];
             [_canvas updateLayer];
            break;
        case 35:{
            self.currentControl = _layerControlArray[index-1];

            [_canvas mergeCurrentToDownLayerWithIndex:index];
            [_layerControlArray[index] removeFromSuperview];
            [_layerControlArray removeObjectAtIndex:index];
            [self reloadLayerBoard];
            [_currentControl updateContents];
             [_canvas updateLayer];
            break;
        }
        case 36:
            [_canvas mergeAllLayers];
            for(LayerControl *control in _layerControlArray){
                [control removeFromSuperview];
            }
            [_layerControlArray removeAllObjects];
            [self configureLayerBorad];
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
             [_canvas updateLayer];
            
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
    _blendModeBoard.hidden = YES;
    _paletteViewBoard.hidden = YES;
    _brushSlider.hidden = YES;
    _backColorViewBoard.hidden = YES;
    if(sender == _currentControl){
        _layerEditView.hidden = !_layerEditView.hidden;
    }
    self.currentControl = sender;
    [_canvas setCurrentDrawingLayer:sender.drawingLayer];
    [self configLayerEditView];
}

- (IBAction)addLayer:(UIButton *)sender
{
    _layerEditView.hidden = YES;
    _brushSlider.hidden = YES;
    _paletteViewBoard.hidden = YES;
    _blendModeBoard.hidden = YES;
    if(_layerControlArray.count<3){
        [self addDrawingLayer];
    }
}

- (void)addDrawingLayer
{
//    unsigned index = (unsigned)[_canvas indexOfDrawingLayer:_canvas.currentDrawingLayer];
    [_canvas addLayerAboveCurrentDrawingLayer];
//    [_canvasView.layer insertSublayer:_canvas.currentDrawingLayer.layer atIndex:index+1];
    CGRect rect = CGRectMake(1, _layerBoard.frame.size.height - _layerControlArray.count * 90-180 , 88, 88);
    LayerControl *control = [[LayerControl alloc] initWithFrame:rect];
    [_layerControlArray insertObject:control atIndex:[_canvas indexOfDrawingLayer:_canvas.currentDrawingLayer]];
    control.drawingLayer = _canvas.currentDrawingLayer;
    control.layerControlDelegate = self;
    [control updateContents];
    [control addTarget:self action:@selector(clickLayerControl:) forControlEvents:UIControlEventTouchUpInside];
    self.currentControl = control;
    [_layerBoard addSubview:control];
    [self reloadLayerBoard];
}

- (void)addDrawingLayer:(DrawingLayer *)dlayer
{
    [_canvas addLayer:dlayer];
//    [_canvasView.layer addSublayer:_canvas.currentDrawingLayer.layer];
    CGRect rect = CGRectMake(1, _layerBoard.frame.size.height - _layerControlArray.count * 90-180 , 88, 88);
    LayerControl *control = [[LayerControl alloc] initWithFrame:rect];
    [_layerControlArray addObject:control];
    control.drawingLayer = _canvas.currentDrawingLayer;
    [control updateContents];
    [control addTarget:self action:@selector(clickLayerControl:) forControlEvents:UIControlEventTouchUpInside];
    self.currentControl = control;
    [_layerBoard addSubview:control];
}

- (IBAction)changeBackgroundColor:(CanvasBackgroundControl *)sender {
    
}
- (IBAction)changeLayerAlpha:(UISlider *)sender {
    _currentControl.drawingLayer.alpha = sender.value;
    _layerEditView.alphaLabel.text = [NSString stringWithFormat:@"%d %%",(int)(sender.value * 100)];
    [_canvas updateLayer];
}
- (IBAction)changeBlendMode:(UIButton *)sender {
    _blendModeBoard.hidden = !_blendModeBoard.hidden;
    [_blendModeController.tableView reloadData];
}

- (IBAction)clickBackColorControl:(id)sender {
    _backColorViewBoard.hidden = !_backColorViewBoard.hidden;
    [_backGroundColorSetController setLastColor:_canvas.backgroundColor];
}


#pragma mark - BlendModeTableViewControllerDelegate
- (CGBlendMode)curBlendMode
{
    return _currentControl.drawingLayer.blendMode;
}

- (void)blendModeChanged:(BlendMode *)blendMode
{
    _currentControl.drawingLayer.blendMode = blendMode.blendMode;
    [_layerEditView.blendModeButton setTitle:blendMode.blendModeName forState:UIControlStateNormal];
    [_canvas updateLayer];
}

- (NSString *)blendModeNameForBlendMode:(CGBlendMode)blendMode
{
    for( NSArray * array in _blendModeController.sectionArray){
        for(BlendMode * mode in array){
            if(mode.blendMode == blendMode){
                return mode.blendModeName;
            }
        }
    }
    
    return nil;
}


#pragma mark - LayerControlDelegate

- (void)visableChanged
{
    [_canvas updateLayer];
}

#pragma mark - CanvasBackgroundControlDelegate
- (UIColor *)backgroundColor
{
    return _canvas.backgroundColor;
}


@end


