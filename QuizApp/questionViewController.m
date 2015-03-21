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
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [questionView addGestureRecognizer:tap1];
    [navigationView addGestureRecognizer:tap2];
    
    ansView.layer.masksToBounds = YES;
    ansView.layer.borderColor = [[GlobalFn getColor:0] CGColor];
    ansView.layer.borderWidth = 1;
    quesNo = @"0";
    
    quesTable.delegate = self;
    quesTable.dataSource = self;
    prevButton.hidden = YES;
    prevButton.enabled = NO;
    questionArray = [[NSMutableArray alloc] init];
    
    NSDictionary *parameters = @{@"quiz_id":_quizID,@"uniq_id":_uniqueID,@"key":@"123"};
    NSLog(@"Param : %@",parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:@"http://quizapp.prateekchandan.me/api/quiz/get" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *help = (NSDictionary *) responseObject;
        NSString *errormsg = [NSString stringWithFormat:@"%@",help[@"error"]];
        if ([errormsg isEqualToString:@"0"]) {
            NSMutableArray *help2 = (NSMutableArray *)help[@"questions"];
            for (NSDictionary *help3 in help2) {
                NSMutableDictionary *help4 = [help3 mutableCopy];
                NSMutableArray *answerArray = [[NSMutableArray alloc] init];
                [help4 setObject:answerArray forKey:@"answer"];
                [questionArray addObject:help4];
            }
            qNoLabel.text = [NSString stringWithFormat:@"Question %@",questionArray[[quesNo integerValue]][@"question_no"]];
            questionView.text = [NSString stringWithFormat:@"%@",questionArray[[quesNo integerValue]][@"question"]];
            questionView.backgroundColor = [GlobalFn getColor:0];
            [questionView setFont:[UIFont systemFontOfSize:17]];
            questionView.textColor = [UIColor whiteColor];
            if ([questionArray[[quesNo integerValue]][@"type"] integerValue] <= 2) {
                quesTable.hidden = NO;
                ansView.hidden = YES;
            }
            else {
                quesTable.hidden = YES;
                ansView.hidden = NO;
                ansView.text = @"";
            }
            [quesTable reloadData];
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

-(void)dismissKeyboard {
    [ansView resignFirstResponder];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"From table %lu",(unsigned long)[questionArray[[quesNo integerValue]][@"options"] count]);
    if ([questionArray count]>0) {
        if ([questionArray[[quesNo integerValue]][@"type"] integerValue] <= 2) {
            return [questionArray[[quesNo integerValue]][@"options"] count];
        }
    }
    return 0;
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
    if ([questionArray[[quesNo integerValue]][@"type"] integerValue] == 1) {
        if([questionArray[[quesNo integerValue]][@"answer"] containsObject:[NSString stringWithFormat:@"%ld",(long)cell.selectButton.tag]]) {
            cell.optionImage.image = [UIImage imageNamed:@"fullCircleIndigoIcon.png"];
        }
        else {
            cell.optionImage.image = [UIImage imageNamed:@"zeroCircleIndigoIcon.png"];
        }
        [cell.selectButton addTarget:self action:@selector(mcqButAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([questionArray[[quesNo integerValue]][@"type"] integerValue] == 2) {
        //if(cell.selectButton.tag == [questionArray[[quesNo integerValue]][@"answer"] integerValue]) {
        if([questionArray[[quesNo integerValue]][@"answer"] containsObject:[NSString stringWithFormat:@"%ld",(long)cell.selectButton.tag]]) {
            cell.optionImage.image = [UIImage imageNamed:@"checkIndigoIcon.png"];
        }
        else {
            cell.optionImage.image = [UIImage imageNamed:@"uncheckIndigoIcon.png"];
        }
        [cell.selectButton addTarget:self action:@selector(mcqButAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    

    NSString *labelText = questionArray[[quesNo integerValue]][@"options"][indexPath.row][@"text"];
    [cell.optionLabel setText:labelText];
    [cell.optionLabel sizeToFit];
    [cell.contentView addSubview:cell.optionLabel];
    NSString *height = [NSString stringWithFormat:@"%f",cell.optionLabel.frame.size.height];
    [questionArray[[quesNo integerValue]] setObject:height forKey:@"height"];
    return cell;
}

-(IBAction)mcqButAction:(id)sender {
    UIButton* myButton = (UIButton*)sender;
    if ([questionArray[[quesNo integerValue]][@"type"] integerValue] == 1) {
        questionArray[[quesNo integerValue]][@"answer"] = [[NSMutableArray alloc] init];
    }
    [questionArray[[quesNo integerValue]][@"answer"] addObject:[NSString stringWithFormat:@"%ld", (long)myButton.tag]];
    [quesTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [questionArray[[quesNo integerValue]][@"height"] floatValue]+40;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)nextAction:(id)sender {
    [ansView resignFirstResponder];
    quesNo = [NSString stringWithFormat:@"%d",[quesNo integerValue]+1];
    if([quesNo integerValue] == [questionArray count]-1){
        nextButton.enabled = NO;
        nextButton.hidden = YES;
    }
    qNoLabel.text = [NSString stringWithFormat:@"Question %@",questionArray[[quesNo integerValue]][@"question_no"]];
    questionView.text = [NSString stringWithFormat:@"%@",questionArray[[quesNo integerValue]][@"question"]];
    questionView.backgroundColor = [GlobalFn getColor:0];
    [questionView setFont:[UIFont systemFontOfSize:17]];
    questionView.textColor = [UIColor whiteColor];
    prevButton.enabled = YES;
    prevButton.hidden = NO;
    if ([questionArray[[quesNo integerValue]][@"type"] integerValue] <= 2) {
        quesTable.hidden = NO;
        ansView.hidden = YES;
    }
    else {
        quesTable.hidden = YES;
        ansView.hidden = NO;
        if ([questionArray[[quesNo integerValue]][@"answer"] count]>0) {
            ansView.text = questionArray[[quesNo integerValue]][@"answer"][0];
        }
        else{
            ansView.text = @"";
        }
    }
    [quesTable reloadData];
}

-(IBAction)clearAction:(id)sender {
    questionArray[[quesNo integerValue]][@"answer"] = [[NSMutableArray alloc] init];
    [quesTable reloadData];
}

-(IBAction)prevAction:(id)sender {
    [ansView resignFirstResponder];
    quesNo = [NSString stringWithFormat:@"%d",[quesNo integerValue]-1];
    if([quesNo integerValue] == 0){
        prevButton.enabled = NO;
        prevButton.hidden = YES;
    }
    qNoLabel.text = [NSString stringWithFormat:@"Question %@",questionArray[[quesNo integerValue]][@"question_no"]];
    questionView.text = [NSString stringWithFormat:@"%@",questionArray[[quesNo integerValue]][@"question"]];
    questionView.backgroundColor = [GlobalFn getColor:0];
    [questionView setFont:[UIFont systemFontOfSize:17]];
    questionView.textColor = [UIColor whiteColor];
    nextButton.enabled = YES;
    nextButton.hidden = NO;
    if ([questionArray[[quesNo integerValue]][@"type"] integerValue] <= 2) {
        quesTable.hidden = NO;
        ansView.hidden = YES;
    }
    else {
        quesTable.hidden = YES;
        ansView.hidden = NO;
        if ([questionArray[[quesNo integerValue]][@"answer"] count]>0) {
            ansView.text = questionArray[[quesNo integerValue]][@"answer"][0];
        }
        else{
            ansView.text = @"";
        }
    }
    [quesTable reloadData];
}

-(IBAction)submitAction:(id)sender {
    for(int i=0;i<[questionArray count];i++) {
        //NSLog(@"Question : %@",questionArray[i][@"question"]);
        //NSLog(@"Answer : %@",questionArray[i][@"answer"]);
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Are you sure you want to submit the quiz?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes",nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //[self.view makeToast:@"Thanks for submitting"];
        NSMutableArray *finalAns = [[NSMutableArray alloc] init];
        for(int i=0;i<[questionArray count];i++) {
            NSMutableDictionary * help = [[NSMutableDictionary alloc] init];
            [help setObject:questionArray[i][@"id"] forKey:@"question_id"];
            NSMutableArray *help2 = (NSMutableArray *)questionArray[i][@"answer"];
            if ([questionArray[i][@"type"] integerValue] <= 2) {
                for (int j=0; j<[help2 count]; j++) {
                    help2[j] = questionArray[i][@"options"][j][@"id"];
                }
            }
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:help2 options:0 error:nil];
            NSString *ansString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [help setObject:ansString forKey:@"response"];
            [finalAns addObject:help];
        }
        NSLog(@"%@",finalAns);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalAns options:0 error:nil];
        NSString *submission = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *parameters = @{@"quiz_id":_quizID,@"uniq_id":_uniqueID,@"key":@"123",@"submit_time":@"500",@"submission":submission};
        NSLog(@"Param : %@",parameters);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager POST:@"http://quizapp.prateekchandan.me/api/quiz/submit" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSLog(@"JSON: %@", responseObject);
            NSDictionary *help = (NSDictionary *) responseObject;
            NSString *errormsg = [NSString stringWithFormat:@"%@",help[@"error"]];
            if ([errormsg isEqualToString:@"1"]) {
                [self.view makeToast:help[@"message"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self.view makeToast:@"Check your internet connection"];
        }];
    }
}

-(IBAction)textEditingAction:(id)sender {
    UITextField * help = (UITextField *) sender;
    NSLog(@"%@",help.text);
    questionArray[[quesNo integerValue]][@"answer"] = [[NSMutableArray alloc] initWithObjects:help.text, nil];
}

////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
