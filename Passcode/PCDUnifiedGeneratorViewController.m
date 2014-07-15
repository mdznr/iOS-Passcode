//
//  PCDUnifiedGeneratorViewController.m
//  Passcode
//
//  Created by Matt Zanchelli on 7/15/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "PCDUnifiedGeneratorViewController.h"

@import LocalAuthentication;

#import "MTZAppearWindow.h"
#import "MTZButton.h"
#import "MTZSlideToReveal.h"
#import "MTZTextField.h"
#import "PCDField.h"
#import "PCDPasscodeGenerator.h"
#import "UITextField+Selections.h"

NSString *const kPCDServiceName = @"Passcode";
NSString *const kPCDAccountName = @"me";

#define STATUS_BAR_HEIGHT 20
#define NAV_BAR_HEIGHT 44

@interface PCDUnifiedGeneratorViewController () <UITextFieldDelegate>

@property (nonatomic, weak)   IBOutlet PCDField *secretCodeField;
@property (nonatomic, weak)   IBOutlet PCDField *serviceNameField;
@property (nonatomic, strong) IBOutlet MTZButton *generateButton;
@property (nonatomic, strong) IBOutlet MTZSlideToReveal *reveal;
@property (nonatomic, strong) MTZAppearWindow *copiedWindow;

@end

@implementation PCDUnifiedGeneratorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Secret Code
	self.secretCodeField.titleLabel.text = NSLocalizedString(@"Secret Code", nil);
	self.secretCodeField.textField.placeholder = NSLocalizedString(@"your secret code", nil);
	self.secretCodeField.textField.secureTextEntry = YES;
	self.secretCodeField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.secretCodeField.textField.returnKeyType = UIReturnKeyNext;
	self.secretCodeField.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.secretCodeField.textField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.secretCodeField.textField.enablesReturnKeyAutomatically = YES;
	self.secretCodeField.textField.delegate = self;
	[self.secretCodeField.textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
	
	// Service Name
	self.serviceNameField.titleLabel.text = NSLocalizedString(@"Service Name", nil);
	self.serviceNameField.textField.placeholder = NSLocalizedString(@"e.g. apple", nil);
	self.serviceNameField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.serviceNameField.textField.returnKeyType = UIReturnKeyGo;
	self.serviceNameField.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.serviceNameField.textField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.serviceNameField.textField.enablesReturnKeyAutomatically = YES;
	self.serviceNameField.textField.delegate = self;
	[self.serviceNameField.textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
	
	// Find the larger of the two widths (to fully fit text in label) and set it for both.
	CGSize secretCodeFieldTitleSize = [self.secretCodeField.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.secretCodeField.titleLabel.font}];
	CGSize serviceNameFieldTitleSize = [self.serviceNameField.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.serviceNameField.titleLabel.font}];
	CGFloat largerWidth = ceil(MAX(secretCodeFieldTitleSize.width, serviceNameFieldTitleSize.width));
	self.secretCodeField.titleLabelWidth = largerWidth;
	self.serviceNameField.titleLabelWidth = largerWidth;
	
	// Set up the popover.
	self.copiedWindow = [[MTZAppearWindow alloc] init];
	self.copiedWindow.autoresizingMask = UIViewAutoresizingFlexibleMargins;
	self.copiedWindow.image = [UIImage imageNamed:@"Copied"];
	self.copiedWindow.text = NSLocalizedString(@"Copied", nil);
	
	self.serviceNameField.tintColor = [UIColor appColor];
	self.secretCodeField.tintColor = [UIColor appColor];
	
	// Add gesture recognizers on the generate button.
	UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didGestureOnButton:)];
	[self.generateButton addGestureRecognizer:longPressGesture];
	
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didGestureOnButton:)];
	[self.generateButton addGestureRecognizer:panGesture];
	
	// Color the button.
	[self.generateButton setTopColor:[UIColor colorWithRed:52.0f/255.0f green:196.0f/255.0f blue:126.0f/255.0f alpha:1.0f]
							forState:UIControlStateNormal];
	[self.generateButton setBottomColor:[UIColor colorWithRed:12.0f/255.0f green:150.0f/255.0f blue:86.0f/255.0f alpha:1.0f]
							   forState:UIControlStateNormal];
	
	[self.generateButton setTopColor:[UIColor colorWithRed:45.0f/255.0f green:171.0f/255.0f blue:110.0f/255.0f alpha:1.0f]
							forState:UIControlStateHighlighted];
	[self.generateButton setBottomColor:[UIColor colorWithRed:10.0f/255.0f green:125.0f/255.0f blue:71.0f/255.0f alpha:1.0f]
							   forState:UIControlStateHighlighted];
	
	[self.generateButton setTopColor:[UIColor colorWithWhite:1.0f alpha:0.12f]
							forState:UIControlStateDisabled];
	[self.generateButton setBottomColor:[UIColor colorWithWhite:1.0f alpha:0.05f]
							   forState:UIControlStateDisabled];
	
	[self.generateButton setBorderColor:[UIColor colorWithRed:213.0f/255.0f green:217.0f/255.0f blue:223.0f/255.0f alpha:1.0f]
							   forState:UIControlStateDisabled];
	
	self.reveal.hidden = YES;
}


#pragma mark - PCDPasscodeGeneratorViewControllerProtocol

- (void)setServiceName:(NSString *)serviceName
{
	_serviceNameField.textField.text = serviceName;
	[self textDidChange:self];
	[_serviceNameField.textField moveCursorToEnd];
}

#pragma mark - Generate Button

- (IBAction)generateAndCopy:(id)sender
{
	// Store the password in keychain.
	[SSKeychain setPassword:_secretCodeField.textField.text forService:@"Passcode" account:@"me"];
	
	NSString *password = [[PCDPasscodeGenerator sharedInstance] passcodeForDomain:_serviceNameField.textField.text
																andMasterPassword:_secretCodeField.textField.text];
	
	// Copy it to pasteboard.
	[UIPasteboard generalPasteboard].string = password;
	
	// Center the appear window to the container.
	_copiedWindow.center = self.view.center;
	
	// Tell the user that the generated passcode has been copied.
	[_copiedWindow display];
}

- (void)generateAndSetReveal:(id)sender
{
	NSString *password = [[PCDPasscodeGenerator sharedInstance] passcodeForDomain:_serviceNameField.textField.text
																andMasterPassword:_secretCodeField.textField.text];
	
	_reveal.hiddenWord = password;
}

- (void)didGestureOnButton:(UIGestureRecognizer *)sender
{
	switch (sender.state) {
		case UIGestureRecognizerStateBegan:
			[self generateAndSetReveal:sender];
			_reveal.hidden = NO;
			_generateButton.hidden = YES;
		case UIGestureRecognizerStateChanged:
			break;
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
			_reveal.hidden = YES;
			_generateButton.hidden = NO;
			break;
		default:
			break;
	}
	[_reveal didGesture:sender];
}


#pragma mark - Text Field Delegate Methods

- (IBAction)textDidChange:(id)sender
{
	if ( _serviceNameField.textField.text.length > 0 && _secretCodeField.textField.text.length > 0 ) {
		_generateButton.enabled = YES;
	} else {
		_generateButton.enabled = NO;
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if ( _serviceNameField.textField.text.length > 0 ) {
		_secretCodeField.textField.returnKeyType = UIReturnKeyGo;
	} else {
		_secretCodeField.textField.returnKeyType = UIReturnKeyNext;
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ( _serviceNameField.textField.text.length > 0 && _secretCodeField.textField.text.length > 0 ) {
		[self generateAndCopy:nil];
		return NO;
	}
	
	[_serviceNameField.textField becomeFirstResponder];
	
	return YES;
}


#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
