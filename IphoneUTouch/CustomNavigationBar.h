//
//  CustomNavigationBar.h
//  CustomBackButton
//

@interface CustomNavigationBar : UINavigationBar
{
  UIImageView *navigationBarBackgroundImage;
  CGFloat backButtonCapWidth;
  UINavigationController* navigationController;
}

@property (nonatomic, retain) UIImageView *navigationBarBackgroundImage;
@property (nonatomic, retain) UINavigationController* navigationController;

-(void) setBackgroundWith:(UIImage*)backgroundImage;
-(void) clearBackground;
-(UIButton*) backButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth;
-(void) setText:(NSString*)text onBackButton:(UIButton*)backButton;
- (void)back:(id)sender;


@end
