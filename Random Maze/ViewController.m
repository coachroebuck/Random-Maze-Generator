//
//  ViewController.m
//  Random Maze
//
//  Created by Coach Roebuck on 4/18/17.
//  Copyright © 2017 Coach Roebuck. All rights reserved.
//

#import "ViewController.h"
#import "RandomMaze.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) RandomMaze * randomMaze;
@property (nonatomic, assign) NSInteger columns;
@property (nonatomic, assign) NSInteger rows;
@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.columns = 3;
    self.rows = 3;
    self.randomMaze = [RandomMaze new];
    [self onReset:nil];
}

- (IBAction)onRun:(id)sender {
    UIImage * img = [self.randomMaze run];
    self.imageView.image = img;
}

- (IBAction)onSize:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter Size" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Columns";
        textField.text = [NSString stringWithFormat:@"%ld", self.columns];
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Rows";
        textField.text = [NSString stringWithFormat:@"%ld", self.rows];
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.columns = [[alertController textFields][0] text].integerValue;
        self.rows = [[alertController textFields][1] text].integerValue;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self onReset:nil];
        });
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

- (IBAction)onReset:(id)sender {
    UIImage * img = [self.randomMaze mazeWithRect:self.imageView.frame
                                          columns:self.columns
                                             rows:self.rows];
    self.imageView.image = img;
}

- (IBAction)onStep:(id)sender {
    UIImage * img = [self.randomMaze step];
    self.imageView.image = img;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
