//
//  QuizIDViewController.h
//  QuizApp
//
//  Created by Harinandan Teja on 02/03/15.
//  Copyright (c) 2015 Harinandan Teja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizIDViewController : UIViewController{
    IBOutlet UITextField *quizIdField;
    IBOutlet UITextField *ipField;
    IBOutlet UIButton *continueButton;
    IBOutlet UIView *navigationView;
    IBOutlet UIActivityIndicatorView *loading;
    NSString *uniqueID;
}

-(IBAction)continueAction:(id)sender;
@property (nonatomic,strong) NSString *stu_name;
@property (nonatomic,strong) NSString *stu_id;

@end
