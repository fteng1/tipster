//
//  TipViewController.m
//  Tipster
//
//  Created by Felianne Teng on 6/22/21.
//

#import "TipViewController.h"

@interface TipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billAmountField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipPercentageControl;
@property (weak, nonatomic) IBOutlet UIView *labelsContainerView;
@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSString *)convertToPercent:(double)dec {
    return [NSString stringWithFormat:@"%.1f%%", dec];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (int i = 0; i < 3; i++) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *key = [NSString stringWithFormat:@"default_tip_%d", i];
        double defaultVal = [defaults doubleForKey:key];
        [self.tipPercentageControl setTitle:[self convertToPercent:defaultVal] forSegmentAtIndex:i];
    }
    NSLog(@"View will appear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.billAmountField becomeFirstResponder];
    NSLog(@"View did appear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    NSLog(@"View will disappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    NSLog(@"View did disappear");
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)updateLabels:(id)sender {
    if (self.billAmountField.text.length == 0) {
        [self hideLabels];
    }
    else {
        if (self.labelsContainerView.alpha == 0) {
            [self showLabels];
        }
    }
    double tipPercentages[] = {0.15, 0.2, 0.25};
    for (int i = 0; i < 3; i++) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *key = [NSString stringWithFormat:@"default_tip_%d", i];
        double defaultVal = [defaults doubleForKey:key];
        tipPercentages[i] = defaultVal / 100;
    }
    double tipPercentage = tipPercentages[self.tipPercentageControl.selectedSegmentIndex];
    
    double bill = [self.billAmountField.text doubleValue];
    double tip = bill * tipPercentage;
    double total = bill + tip;
    
    self.tipLabel.text = [NSString stringWithFormat:@"$%.2f", tip];
    self.totalLabel.text = [NSString stringWithFormat:@"$%.2f", total];
}

- (void)hideLabels {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect billFrame = self.billAmountField.frame;
        billFrame.origin.y += 200;
        
        self.billAmountField.frame = billFrame;
        
        CGRect labelsFrame = self.labelsContainerView.frame;
        labelsFrame.origin.y += 200;
        
        self.labelsContainerView.frame = labelsFrame;
        
        self.labelsContainerView.alpha = 0;
    }];
}

- (void)showLabels {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect billFrame = self.billAmountField.frame;
        billFrame.origin.y -= 200;
        
        self.billAmountField.frame = billFrame;
        
        CGRect labelsFrame = self.labelsContainerView.frame;
        labelsFrame.origin.y -= 200;
        
        self.labelsContainerView.frame = labelsFrame;
        
        self.labelsContainerView.alpha = 1;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
