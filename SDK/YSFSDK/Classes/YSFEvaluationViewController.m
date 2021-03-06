#import "YSFEvaluationViewController.h"
#import "YSFKeyboardManager.h"
#import "YSFEvaluationRequest.h"


@interface YSFEvaluationViewController() <YSFKeyboardObserver, UIAlertViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSDictionary *evaluationDict;
@property (nonatomic, copy) EvaluationCallback evaluationCallback;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic,strong) UILabel* placeholderLabel;
@property (nonatomic,strong) UIButton *selectedButton;
@property (nonatomic,strong) UIButton *submit;
@property (nonatomic,strong) UIImageView *imagePanel;
@property (nonatomic,assign) long long sessionId;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UIButton *satisfaction1;
@property (nonatomic,strong) UIButton *satisfaction2;
@property (nonatomic,strong) UIButton *satisfaction3;
@property (nonatomic,strong) UIButton *satisfaction4;
@property (nonatomic,strong) UIButton *satisfaction5;
@property (nonatomic,strong) UIButton *evaluationClose;
@property (nonatomic,copy) NSString *shopId;

@end


@implementation YSFEvaluationViewController

- (instancetype)initWithEvaluationDict:(NSDictionary *)evaluationDict shopId:(NSString *)shopId sessionId:(long long)sessionId evaluationCallback:(EvaluationCallback)evaluationCallback
{
//    assert(evaluationDict && evaluationDict.count > 0);
    
    self  = [super init];
    if (self) {
        _evaluationDict = evaluationDict;
        if (!_evaluationDict || _evaluationDict.count == 0) {
            _evaluationDict = @{ @"满意":@(100), @"不满意":@(1) };
        }
        
        _shopId = shopId;
        _sessionId = sessionId;
        _evaluationCallback = evaluationCallback;
    }
    
    return self;
}

- (void)dealloc {
    [[YSFKeyboardManager defaultManager] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[YSFKeyboardManager defaultManager] addObserver:self];

    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    [self.view addGestureRecognizer:singleTapRecognizer];
    
    self.view.backgroundColor = YSFColorFromRGBA(0x000000, 0.5);
    _imagePanel = [[UIImageView alloc] init];
    _imagePanel.userInteractionEnabled = YES;
    _imagePanel.backgroundColor = YSFColorFromRGB(0xffffff);
    [self.view addSubview:_imagePanel];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.backgroundColor = YSFColorFromRGB(0xf1f1f1);
    _tipLabel.text = @"请对我们的服务做出评价";
    _tipLabel.font = [UIFont systemFontOfSize:15];
    _tipLabel.textColor = YSFRGB(0x222222);
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [_imagePanel addSubview:_tipLabel];
    
    _satisfaction1 = [[UIButton alloc] initWithFrame:CGRectZero];
    [_satisfaction1 setImage:[UIImage ysf_imageInKit:@"icon_evaluation_satisfied1"] forState:UIControlStateNormal];
    [_satisfaction1 setImage:[UIImage ysf_imageInKit:@"icon_evaluation_satisfied1"] forState:UIControlStateHighlighted];
    [_satisfaction1 setTitle:@"非常满意" forState:UIControlStateNormal];
    _satisfaction1.titleLabel.font = [UIFont systemFontOfSize:12];
    _satisfaction1.titleEdgeInsets = UIEdgeInsetsMake(80, -48, 0, 0);
    _satisfaction1.titleLabel.layer.cornerRadius = 4.0;
    _satisfaction1.titleLabel.layer.masksToBounds = YES;
    [_satisfaction1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_satisfaction1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_satisfaction1 addTarget:self action:@selector(onSelect:) forControlEvents:UIControlEventTouchUpInside];
    _satisfaction1.hidden = YES;
    [_satisfaction1 sizeToFit];
    [_imagePanel addSubview:_satisfaction1];
    
    _satisfaction2 = [[UIButton alloc] initWithFrame:CGRectZero];
    [_satisfaction2 setImage:[UIImage ysf_imageInKit:@"icon_evaluation_satisfied2"] forState:UIControlStateNormal];
    [_satisfaction2 setImage:[UIImage ysf_imageInKit:@"icon_evaluation_satisfied2"] forState:UIControlStateHighlighted];
    [_satisfaction2 setTitle:@"满意" forState:UIControlStateNormal];
    _satisfaction2.titleLabel.font = [UIFont systemFontOfSize:12];
    _satisfaction2.titleEdgeInsets = UIEdgeInsetsMake(80, -38, 0, 0);
    _satisfaction2.titleLabel.layer.cornerRadius = 4.0;
    _satisfaction2.titleLabel.layer.masksToBounds = YES;
    [_satisfaction2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_satisfaction2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_satisfaction2 addTarget:self action:@selector(onSelect:) forControlEvents:UIControlEventTouchUpInside];
    _satisfaction2.hidden = YES;
    [_satisfaction2 sizeToFit];
    [_imagePanel addSubview:_satisfaction2];
    
    _satisfaction3 = [[UIButton alloc] initWithFrame:CGRectZero];
    [_satisfaction3 setImage:[UIImage ysf_imageInKit:@"icon_evaluation_satisfied3"] forState:UIControlStateNormal];
    [_satisfaction3 setImage:[UIImage ysf_imageInKit:@"icon_evaluation_satisfied3"] forState:UIControlStateHighlighted];
    [_satisfaction3 setTitle:@"一般" forState:UIControlStateNormal];
    _satisfaction3.titleLabel.font = [UIFont systemFontOfSize:12];
    _satisfaction3.titleEdgeInsets = UIEdgeInsetsMake(80, -38, 0, 0);
    _satisfaction3.titleLabel.layer.cornerRadius = 4.0;
    _satisfaction3.titleLabel.layer.masksToBounds = YES;
    [_satisfaction3 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_satisfaction3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_satisfaction3 addTarget:self action:@selector(onSelect:) forControlEvents:UIControlEventTouchUpInside];
    _satisfaction3.hidden = YES;
    [_satisfaction3 sizeToFit];
    [_imagePanel addSubview:_satisfaction3];
    
    _satisfaction4 = [[UIButton alloc] initWithFrame:CGRectZero];
    [_satisfaction4 setImage:[UIImage ysf_imageInKit:@"icon_evaluation_satisfied4"] forState:UIControlStateNormal];
    [_satisfaction4 setImage:[UIImage ysf_imageInKit:@"icon_evaluation_satisfied4"] forState:UIControlStateHighlighted];
    [_satisfaction4 setTitle:@"不满意" forState:UIControlStateNormal];
    _satisfaction4.titleLabel.font = [UIFont systemFontOfSize:12];
    _satisfaction4.titleEdgeInsets = UIEdgeInsetsMake(80, -38, 0, 0);
    _satisfaction4.titleLabel.layer.cornerRadius = 4.0;
    _satisfaction4.titleLabel.layer.masksToBounds = YES;
    [_satisfaction4 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_satisfaction4 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_satisfaction4 addTarget:self action:@selector(onSelect:) forControlEvents:UIControlEventTouchUpInside];
    _satisfaction4.hidden = YES;
    [_satisfaction4 sizeToFit];
    [_imagePanel addSubview:_satisfaction4];
    
    _satisfaction5 = [[UIButton alloc] initWithFrame:CGRectZero];
    [_satisfaction5 setImage:[UIImage ysf_imageInKit:@"icon_evaluation_satisfied5"] forState:UIControlStateNormal];
    [_satisfaction5 setImage:[UIImage ysf_imageInKit:@"icon_evaluation_satisfied5"] forState:UIControlStateHighlighted];
    [_satisfaction5 setTitle:@"非常不满意" forState:UIControlStateNormal];
    _satisfaction5.titleLabel.font = [UIFont systemFontOfSize:12];
    _satisfaction5.titleEdgeInsets = UIEdgeInsetsMake(80, -48, 0, 0);
    _satisfaction5.titleLabel.layer.cornerRadius = 4.0;
    _satisfaction5.titleLabel.layer.masksToBounds = YES;
    [_satisfaction5 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_satisfaction5 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_satisfaction5 addTarget:self action:@selector(onSelect:) forControlEvents:UIControlEventTouchUpInside];
    _satisfaction5.hidden = YES;
    [_satisfaction5 sizeToFit];
    [_imagePanel addSubview:_satisfaction5];
    
    _evaluationClose = [[UIButton alloc] initWithFrame:CGRectZero];
    [_evaluationClose setImage:[UIImage ysf_imageInKit:@"icon_evaluation_close"] forState:UIControlStateNormal];
    [_evaluationClose addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
    [_imagePanel addSubview:_evaluationClose];
    
    _textView = [UITextView new];
    _textView.layer.borderColor = YSFColorFromRGB(0xdcdcdc).CGColor;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 3.0;
    _textView.delegate = self;
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont systemFontOfSize:13.0];
    [_imagePanel addSubview:_textView];
    
    _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    _placeholderLabel.text = @"备注（选填）";
    _placeholderLabel.font = [UIFont systemFontOfSize:13.0];
    [self.textView addSubview:_placeholderLabel];
    
    _submit = [[UIButton alloc] initWithFrame:CGRectZero];
    _submit.layer.cornerRadius = 3.0;
    _submit.enabled = NO;
    _submit.backgroundColor = YSFColorFromRGBA(0x5e94e2, 0.6);
    [_submit setTitle:@"提 交" forState:UIControlStateNormal];
    _submit.titleLabel.font = [UIFont systemFontOfSize:16.0];;
    [_submit addTarget:self action:@selector(onSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [_imagePanel addSubview:_submit];
}

- (void)viewDidLayoutSubviews
{
    _imagePanel.ysf_frameWidth = self.view.ysf_frameWidth;
    _imagePanel.ysf_frameHeight = 307;
    _imagePanel.ysf_frameBottom = self.view.ysf_frameBottom;
    _tipLabel.ysf_frameWidth = _imagePanel.ysf_frameWidth;
    _tipLabel.ysf_frameHeight = 40;
    _satisfaction1.ysf_frameWidth = 50;
    _satisfaction1.ysf_frameTop = 60;
    _satisfaction2.ysf_frameTop = 60;
    _satisfaction2.ysf_frameWidth = 38;
    _satisfaction3.ysf_frameTop = 60;
    _satisfaction3.ysf_frameWidth = 38;
    _satisfaction4.ysf_frameTop = 60;
    _satisfaction4.ysf_frameWidth = 38;
    _satisfaction5.ysf_frameTop = 60;
    _satisfaction5.ysf_frameWidth = 60;
    _evaluationClose.ysf_frameWidth = 40;
    _evaluationClose.ysf_frameHeight = 40;
    _evaluationClose.ysf_frameRight = _imagePanel.ysf_frameWidth;
    _textView.ysf_frameWidth = _imagePanel.ysf_frameWidth - 32;
    _textView.ysf_frameCenterX = _imagePanel.ysf_frameCenterX;
    _textView.ysf_frameHeight = 62;
    _textView.ysf_frameTop = 150;
    _submit.ysf_frameWidth = _imagePanel.ysf_frameWidth - 32;
    _submit.ysf_frameCenterX = _imagePanel.ysf_frameCenterX;
    _submit.ysf_frameHeight = 42;
    _submit.ysf_frameTop = 237;
    
    NSUInteger evaluationTypeCount = _evaluationDict.count;
    NSUInteger offset = 0;
    if (evaluationTypeCount > 0 ) {
        offset = (_imagePanel.ysf_frameWidth - _satisfaction4.ysf_frameWidth * evaluationTypeCount) / (evaluationTypeCount+1);
    }
    if (evaluationTypeCount == 2) {
        _satisfaction2.hidden = NO;
        _satisfaction4.hidden = NO;
        _satisfaction2.ysf_frameLeft = offset;
        _satisfaction4.ysf_frameLeft = _satisfaction2.ysf_frameRight + offset;
    }
    else if (evaluationTypeCount == 3) {
        _satisfaction2.hidden = NO;
        _satisfaction3.hidden = NO;
        _satisfaction4.hidden = NO;
        _satisfaction2.ysf_frameLeft = offset;
        _satisfaction3.ysf_frameLeft = _satisfaction2.ysf_frameRight + offset;
        _satisfaction4.ysf_frameLeft = _satisfaction3.ysf_frameRight + offset;
    }
    else if (evaluationTypeCount == 5) {
        _satisfaction1.hidden = NO;
        _satisfaction2.hidden = NO;
        _satisfaction3.hidden = NO;
        _satisfaction4.hidden = NO;
        _satisfaction5.hidden = NO;
        _satisfaction1.ysf_frameLeft = offset + 2;
        _satisfaction2.ysf_frameLeft = _satisfaction1.ysf_frameRight + offset - 11;
        _satisfaction3.ysf_frameLeft = _satisfaction2.ysf_frameRight + offset;
        _satisfaction4.ysf_frameLeft = _satisfaction3.ysf_frameRight + offset;
        _satisfaction5.ysf_frameLeft = _satisfaction4.ysf_frameRight + offset - 6;
    }
}

- (void)onClose:(id)sender
{
    if (_textView.text.length > 0 ) {
        //解决iOS键盘消失动画被打断后闪一下问题
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.53 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"是否放弃评价，放弃后不可恢复"
                                                             message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil,nil];
            [dialog addButtonWithTitle:@"否"];
            [dialog addButtonWithTitle:@"是"];
            [dialog show];
        });
    }
    else {
        [self closeHandle];
    }
    [self.textView resignFirstResponder];   //否则close评价窗口键盘会抖动
}

- (void)closeHandle
{
    [self dismissViewControllerAnimated:YES completion:^{
        _evaluationCallback(NO, @"");
    }];
}

- (void)onSelect:(id)sender
{
    _submit.enabled = YES;
    _submit.backgroundColor = YSFColorFromRGBA(0x5e94e2, 1);

    _selectedButton.selected = NO;
    _selectedButton.titleLabel.backgroundColor = [UIColor clearColor];
    UIButton *button = sender;
    button.selected = true;
    
    _selectedButton = button;
    _selectedButton.titleLabel.backgroundColor = YSFColorFromRGB(0x999999);
    
    CGAffineTransform oldTransForm =  button.imageView.transform;
    CGAffineTransform transform = CGAffineTransformScale(oldTransForm, 1.2, 1.2);
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        button.imageView.transform = transform;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.1 delay:0.05 options:UIViewAnimationOptionCurveLinear animations:^{
            button.imageView.transform = oldTransForm;
        } completion:nil];
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        _placeholderLabel.hidden = YES;
    }
    else{
        _placeholderLabel.hidden = NO;
    }
    
    NSString *nsTextContent = textView.text;
    if (nsTextContent.length > 100)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:100];
        [textView setText:s];
    }
    
    //解决自动上下移动问题
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height- ( textView.contentOffset.y + textView.bounds.size.height- textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [textView setContentOffset:offset];
    }
}

- (void)onSubmit:(id)sender
{
    _submit.enabled = NO;
    _submit.backgroundColor = YSFColorFromRGBA(0x5e94e2, 0.6);
    [_submit setTitle:@"提交中..." forState:UIControlStateNormal];
    NSString *selectString = _selectedButton.titleLabel.text;
    NSNumber *selectScore = [_evaluationDict objectForKey:selectString];
    
    YSFEvaluationRequest *request = [[YSFEvaluationRequest alloc] init];
    request.score = selectScore.unsignedIntegerValue;
    request.remarks = _textView.text;
    request.sessionId = _sessionId;
    __weak typeof(self) weakSelf = self;
    [YSFIMCustomSystemMessageApi sendMessage:request shopId:_shopId completion:^(NSError *error) {
        if (error) {
            weakSelf.submit.enabled = YES;
            [weakSelf.submit setTitle:@"提 交" forState:UIControlStateNormal];
            weakSelf.submit.backgroundColor = YSFColorFromRGBA(0x5e94e2, 1);
            [weakSelf.view ysf_makeToast:@"网络链接失败，请稍后再试" duration:2.0 position:YSFToastPositionCenter];
        }
        else {
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                weakSelf.evaluationCallback(YES, selectString);
            }];
        }
    }];
}

- (void)keyboardChangedWithTransition:(YSFKeyboardTransition)transition {
    [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption animations:^{
        CGRect kbFrame = [[YSFKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
        CGRect imagePanleframe = _imagePanel.frame;
        imagePanleframe.size.width = kbFrame.size.width;
        imagePanleframe.origin.y = kbFrame.origin.y - imagePanleframe.size.height;
        _imagePanel.frame = imagePanleframe;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)onSingleTap:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.textView becomeFirstResponder];
    }else if (buttonIndex == 1) {
        [self closeHandle];
    }
}
@end
