//
//  summaryViewController.h
//  QuizApp
//
//  Created by Harinandan Teja on 21/03/15.
//  Copyright (c) 2015 Harinandan Teja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface summaryViewController : UIViewController{
    IBOutlet UITextView *summaryView;
    IBOutlet UIView *navigationView;
}
@property (nonatomic,weak) NSString *uniqueID;
@property (nonatomic,weak) NSString *quizID;
@property (nonatomic,strong) NSString *stu_name;
@property (nonatomic,strong) NSString *stu_id;
@property (nonatomic,strong) NSString *msg;

@end
