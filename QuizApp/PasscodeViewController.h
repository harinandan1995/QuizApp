//
//  PasscodeViewController.h
//  QuizApp
//
//  Created by Harinandan Teja on 10/02/15.
//  Copyright (c) 2015 Harinandan Teja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasscodeViewController : UIViewController
{
    IBOutlet UIButton *button1;
    IBOutlet UIButton *button2;
    IBOutlet UIButton *button3;
    IBOutlet UIButton *button4;
    IBOutlet UIButton *button5;
    IBOutlet UIButton *button6;
    IBOutlet UIButton *button7;
    IBOutlet UIButton *button8;
    IBOutlet UIButton *button9;
    IBOutlet UIButton *button10;
    IBOutlet UIButton *button11;
    IBOutlet UIButton *button12;
    IBOutlet UIButton *button13;
    IBOutlet UIButton *button14;
    IBOutlet UIButton *button15;
    IBOutlet UIButton *button16;
    IBOutlet UIButton *clearButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *continueButton;
    IBOutlet UIView *navigationView;
    IBOutlet UILabel *passcodeLabel;
    NSMutableArray *unicodeArray;
    NSMutableArray *finalCode;
    NSString *fontId;
}

-(IBAction)continueAction:(id)sender;
@property (nonatomic,strong) NSString *uniqueID;
@property (nonatomic,strong) NSString *quizID;
@property (nonatomic,strong) NSString *stu_name;
@property (nonatomic,strong) NSString *stu_id;

@property (nonatomic,retain) NSMutableArray *symbolArray;

-(IBAction)buttonAction:(id)sender;
-(IBAction)clearAction:(id)sender;
-(IBAction)backAction:(id)sender;
-(void)initButton;
@end
