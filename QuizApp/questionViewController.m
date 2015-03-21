//
//  questionViewController.m
//  QuizApp
//
//  Created by Harinandan Teja on 02/03/15.
//  Copyright (c) 2015 Harinandan Teja. All rights reserved.
//

#import "questionViewController.h"
#import "GlobalFn.h"
#import <Toast/UIView+Toast.h>
#import <AFNetworking/AFNetworking.h>
#import "mcqCell.h"

@interface questionViewController ()

@end

@implementation questionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    navigationView.backgroundColor = [GlobalFn getColor:1];
    [navigationView.layer setShadowColor:[UIColor blackColor].CGColor];
    [navigationView.layer setShadowOpacity:0.5];
    [navigationView.layer setShadowRadius:3.0];
    [navigationView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [submitButton setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    [clearButton setTitleColor:[GlobalFn getColor:1] forState:UIControlStateNormal];
    
    //qNoLabel.textColor = [GlobalFn getColor:0];
    quesTable.delegate = self;
    quesTable.dataSource = self;
    quesNo = @"0";
    
    prevButton.hidden = YES;
    prevButton.enabled = NO;
    
    questionArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *help = [[NSMutableDictionary alloc] init];
    [help setObject:@"1" forKey:@"qid"];
    [help setObject:@"1a" forKey:@"ques_no"];
    [help setObject:@"The United Nations was founded on _________." forKey:@"ques"];
    [help setObject:@"mcq" forKey:@"type"];
    [help setObject:@"1" forKey:@"correct_options"];
    arrayHelp = [[NSMutableArray alloc] initWithObjects:@"March 24, 1945",@"October 24, 1945",@"March 24, 1949",@"October 24, 1950", nil];
    [help setObject:arrayHelp forKey:@"options"];
    [help setObject:@"-1" forKey:@"answer"];
    [questionArray addObject:help];
    help = [[NSMutableDictionary alloc] init];
    [help setObject:@"1" forKey:@"qid"];
    [help setObject:@"1b" forKey:@"ques_no"];
    [help setObject:@"A body of mass 100 gram, tied at the end of a string of length 3 m rotates in a vertical circle and is just able to complete the circle. If the tension in the string at its lowest point is 3.7 N, then its angular velocity will be ______ (g = 10 m/s2)" forKey:@"ques"];
    [help setObject:@"mcq" forKey:@"type"];
    [help setObject:@"1" forKey:@"correct_options"];
    arrayHelp = [[NSMutableArray alloc] initWithObjects:@"Has constant velocity.",@"Has no acceleration", @"Has an inward acceleration", @"Has an outward radial acceleration", nil];
    [help setObject:arrayHelp forKey:@"options"];
    [help setObject:@"-1" forKey:@"answer"];
    [questionArray addObject:help];
    
    qNoLabel.text = [NSString stringWithFormat:@"Question %@",questionArray[[quesNo integerValue]][@"ques_no"]];
    questionView.text = [NSString stringWithFormat:@"%@",questionArray[[quesNo integerValue]][@"ques"]];
    questionView.backgroundColor = [GlobalFn getColor:0];
    [questionView setFont:[UIFont systemFontOfSize:17]];
    questionView.textColor = [UIColor whiteColor];
    
    NSDictionary *parameters = @{@"quiz_id":_quizID,@"uniq_id":_uniqueID,@"key":@"123"};
    NSLog(@"Param : %@",parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:@"http://quizapp.prateekchandan.me/api/quiz/get" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *help = (NSDictionary *) responseObject;
        NSString *errormsg = [NSString stringWithFormat:@"%@",help[@"error"]];
        if ([errormsg isEqualToString:@"0"]) {
            
        }
        else {
            [self.view makeToast:help[@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.view makeToast:@"Check your internet connection"];
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"From table %lu",(unsigned long)[questionArray[[quesNo integerValue]][@"options"] count]);
    return [questionArray[[quesNo integerValue]][@"options"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"mcqCell";
    mcqCell *cell = (mcqCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"mcqCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell.optionLabel removeFromSuperview];
    CGRect labelFrame = CGRectMake(60, 16, 210, 350);
    cell.optionLabel = [[UILabel alloc] initWithFrame:labelFrame];
    cell.optionLabel.layer.masksToBounds = YES;
    //cell.optionLabel.backgroundColor = [UIColor orangeColor];
    cell.optionLabel.font=[cell.optionLabel.font fontWithSize:15];
    [cell.optionLabel setNumberOfLines:0];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectButton.tag = indexPath.row;
    if(cell.selectButton.tag == [questionArray[[quesNo integerValue]][@"answer"] integerValue]) {
        cell.optionImage.image = [UIImage imageNamed:@"fullCircleIndigoIcon.png"];
    }
    else {
        cell.optionImage.image = [UIImage imageNamed:@"zeroCircleIndigoIcon.png"];
    }
    [cell.selectButton addTarget:self action:@selector(mcqButAction:) forControlEvents:UIControlEventTouchUpInside];

    NSString *labelText = questionArray[[quesNo integerValue]][@"options"][indexPath.row];
    [cell.optionLabel setText:labelText];
    [cell.optionLabel sizeToFit];
    [cell.contentView addSubview:cell.optionLabel];
    NSString *height = [NSString stringWithFormat:@"%f",cell.optionLabel.frame.size.height];
    [questionArray[[quesNo integerValue]] setObject:height forKey:@"height"];
    return cell;
}

-(IBAction)mcqButAction:(id)sender {
    UIButton* myButton = (UIButton*)sender;
    questionArray[[quesNo integerValue]][@"answer"] = [NSString stringWithFormat:@"%ld", (long)myButton.tag];
    [quesTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [questionArray[[quesNo integerValue]][@"height"] floatValue]+40;
    //return 100;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)nextAction:(id)sender {
    quesNo = [NSString stringWithFormat:@"%ld",[quesNo integerValue]+1];
    if([quesNo integerValue] == [questionArray count]-1){
        nextButton.enabled = NO;
        nextButton.hidden = YES;
    }
    qNoLabel.text = [NSString stringWithFormat:@"Question %@",questionArray[[quesNo integerValue]][@"ques_no"]];
    questionView.text = [NSString stringWithFormat:@"%@",questionArray[[quesNo integerValue]][@"ques"]];
    questionView.backgroundColor = [GlobalFn getColor:0];
    [questionView setFont:[UIFont systemFontOfSize:17]];
    questionView.textColor = [UIColor whiteColor];
    prevButton.enabled = YES;
    prevButton.hidden = NO;
    [quesTable reloadData];
}

-(IBAction)clearAction:(id)sender {
    questionArray[[quesNo integerValue]][@"answer"] = @"-1";
    [quesTable reloadData];
}

-(IBAction)prevAction:(id)sender {
    quesNo = [NSString stringWithFormat:@"%ld",[quesNo integerValue]-1];
    if([quesNo integerValue] == 0){
        prevButton.enabled = NO;
        prevButton.hidden = YES;
    }
    qNoLabel.text = [NSString stringWithFormat:@"Question %@",questionArray[[quesNo integerValue]][@"ques_no"]];
    questionView.text = [NSString stringWithFormat:@"%@",questionArray[[quesNo integerValue]][@"ques"]];
    questionView.backgroundColor = [GlobalFn getColor:0];
    [questionView setFont:[UIFont systemFontOfSize:17]];
    questionView.textColor = [UIColor whiteColor];
    nextButton.enabled = YES;
    nextButton.hidden = NO;
    [quesTable reloadData];
}

-(IBAction)submitAction:(id)sender {
    for(int i=0;i<[questionArray count];i++) {
        NSLog(@"Question : %@",questionArray[i][@"ques"]);
        NSLog(@"Answer : %@",questionArray[i][@"answer"]);
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Are you sure you want to submit the quiz?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes",nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1) {
        // do something here...
        [self.view makeToast:@"Thanks for submitting"];
    }
}

////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end