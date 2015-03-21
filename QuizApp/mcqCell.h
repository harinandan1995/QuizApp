//
//  mcqCell.h
//  QuizApp
//
//  Created by Harinandan Teja on 10/03/15.
//  Copyright (c) 2015 Harinandan Teja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mcqCell : UITableViewCell
@property(nonatomic,strong) IBOutlet UIButton *selectButton;
@property(nonatomic,strong) UILabel *optionLabel;
@property(nonatomic,strong) IBOutlet UIImageView *optionImage;

@end
