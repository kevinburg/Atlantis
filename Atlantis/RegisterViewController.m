//
//  JVFloatLabeledTextFieldViewController.m
//  JVFloatLabeledTextField
//
//  The MIT License (MIT)
//
//  Copyright (c) 2013 Jared Verdi
//  Original Concept by Matt D. Smith
//  http://dribbble.com/shots/1254439--GIF-Mobile-Form-Interaction?list=users
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "RegisterViewController.h"
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"

const static CGFloat kJVFieldHeight = 55.0f; //44
const static CGFloat kJVFieldHMargin = 22.0f; //10

const static CGFloat kJVFieldFontSize = 20.0f; //16

const static CGFloat kJVFieldFloatingLabelFontSize = 15.0f; //11

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Update Personal Info", @"");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self.view setTintColor:[UIColor blueColor]];
    
    CGFloat topOffset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    UIColor *floatingLabelColor = [UIColor grayColor];
    
    CGFloat currentTopMargin = topOffset + 2.0f;
    
    JVFloatLabeledTextField *firstNameField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(kJVFieldHMargin, currentTopMargin, self.view.frame.size.width - 2 * kJVFieldHMargin, kJVFieldHeight)];
    firstNameField.tag = 0;
    firstNameField.placeholder = NSLocalizedString(@"First Name", @"");
    firstNameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    firstNameField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    firstNameField.floatingLabelTextColor = floatingLabelColor;
    firstNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:firstNameField];
    
    // HORIZONTAL SPACER
    currentTopMargin += kJVFieldHeight;
    UIView *div1 = [UIView new];
    div1.frame = CGRectMake(kJVFieldHMargin, currentTopMargin,
                            self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div1];
    
    // LAST NAME FIELD
    currentTopMargin += 4.0f;
    JVFloatLabeledTextField *lastNameField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                               CGRectMake(kJVFieldHMargin, currentTopMargin, self.view.frame.size.width - 2 * kJVFieldHMargin, kJVFieldHeight)];
    lastNameField.tag = 1;
    lastNameField.placeholder = NSLocalizedString(@"Last Name", @"");
    lastNameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    lastNameField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    lastNameField.floatingLabelTextColor = floatingLabelColor;
    lastNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:lastNameField];
    
    // HORIZONTAL SPACER
    currentTopMargin += kJVFieldHeight;
    UIView *div2 = [UIView new];
    div2.frame = CGRectMake(kJVFieldHMargin, currentTopMargin,
                            self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
    div2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div2];
    
    // LAST NAME FIELD
    currentTopMargin += 4.0f;
    JVFloatLabeledTextField *andrewField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                              CGRectMake(kJVFieldHMargin, currentTopMargin, self.view.frame.size.width - 2 * kJVFieldHMargin, kJVFieldHeight)];
    andrewField.tag = 2;
    andrewField.placeholder = NSLocalizedString(@"Andrew ID", @"");
    andrewField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    andrewField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    andrewField.floatingLabelTextColor = floatingLabelColor;
    andrewField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:andrewField];
    
    // HORIZONTAL SPACER
    currentTopMargin += kJVFieldHeight;
    UIView *div3 = [UIView new];
    div3.frame = CGRectMake(kJVFieldHMargin, currentTopMargin,
                            self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
    div3.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div3];
    
    // VERTICAL SPACER
//    UIView *divLN = [UIView new];
//    
//    currentTopMargin += lastNameField.frame.origin.y + lastNameField.frame.size.height;
//    divLN.frame = CGRectMake(kJVFieldHMargin, currentTopMargin,
//                            self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
//    divLN.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3f];
//    [self.view addSubview:divLN];
    
    
    currentTopMargin += 4.0f;
    
    JVFloatLabeledTextField *priceField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                           CGRectMake(kJVFieldHMargin, currentTopMargin, 80.0f, kJVFieldHeight)];
    priceField.tag = 3;
    priceField.placeholder = NSLocalizedString(@"Height", @"");
    priceField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    priceField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    priceField.floatingLabelTextColor = floatingLabelColor;
    [self.view addSubview:priceField];
    
//    UIView *div2 = [UIView new];
//    div2.frame = CGRectMake(kJVFieldHMargin + priceField.frame.size.width,
//                            firstNameField.frame.origin.y + firstNameField.frame.size.height,
//                            1.0f, kJVFieldHeight);
//    div2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
//    [self.view addSubview:div2];
    
    currentTopMargin += 4.0f;
    
    JVFloatLabeledTextField *locationField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                              CGRectMake(kJVFieldHMargin + kJVFieldHMargin + priceField.frame.size.width + 1.0f,
                                                         currentTopMargin,
                                                         self.view.frame.size.width - 3*kJVFieldHMargin - priceField.frame.size.width - 1.0f,
                                                         kJVFieldHeight)];
    locationField.tag = 5;
    locationField.placeholder = NSLocalizedString(@"Hair Color", @"");
    locationField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    locationField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    locationField.floatingLabelTextColor = floatingLabelColor;
    [self.view addSubview:locationField];
    
    UIView *div4 = [UIView new];
    div4.frame = CGRectMake(kJVFieldHMargin, priceField.frame.origin.y + priceField.frame.size.height,
                            self.view.frame.size.width - 2*kJVFieldHMargin, 1.0f);
    div4.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div4];
    
//    JVFloatLabeledTextView *descriptionField = [[JVFloatLabeledTextView alloc] initWithFrame:CGRectZero];
//    descriptionField.frame = CGRectMake(kJVFieldHMargin - descriptionField.textContainer.lineFragmentPadding,
//                                        div3.frame.origin.y + div4.frame.size.height,
//                                        self.view.frame.size.width - 2*kJVFieldHMargin + descriptionField.textContainer.lineFragmentPadding,
//                                        kJVFieldHeight*3);
//    descriptionField.placeholder = NSLocalizedString(@"Description", @"");
//    descriptionField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
//    descriptionField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
//    descriptionField.floatingLabelTextColor = floatingLabelColor;
//    [self.view addSubview:descriptionField];
    
    [firstNameField becomeFirstResponder];
    
}

- (IBAction)buttonClicked:(id)sender {
    UITextField *firstName, *lastName;
    for (int i = 0; i < self.view.subviews.count; i++){
        UIView *subview = self.view.subviews[i];
        if([subview isKindOfClass:[UITextField class]]) {
            if (subview.tag == 0){
                NSLog(@"found first name");
                firstName = (UITextField *)subview;
            } else if(subview.tag == 1){
                NSLog(@"found last name");
                lastName = (UITextField *)subview;
            }
        }
    }
    NSLog([firstName text]);
    NSLog([lastName text]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end