//
//  LayerEditView.h
//  BrushTest
//
//  Created by Coding on 8/26/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayerEditView : UIView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *merge;
@property (weak, nonatomic) IBOutlet UIButton *del;
@property (weak, nonatomic) IBOutlet UIButton *mergeAll;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
@property (weak, nonatomic) IBOutlet UILabel *alphaLabel;
@end
