//
//  ProgresoViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 13/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "ProgresoViewController.h"
#import "../../DemoData.h"
#import "../../PowerPlot.h"
#import "AddMedidaPesoView.h"
#import "PreferencesViewController.h"
#import "Flurry.h"

@implementation ProgresoViewController
@synthesize peso_inicio, medida_inicio;
@synthesize updateViews;
@synthesize actual;
@synthesize meta;
@synthesize segmented;
@synthesize chart;
@synthesize chartMedida;
@synthesize banderaImageView;
@synthesize llevasLabel;
@synthesize metaLabel;
@synthesize faltanteLabel;
@synthesize add;

@synthesize pesoList;
@synthesize medidaList;
/// FACEBOOK ///
//@synthesize session = _session;
//@synthesize loginDialog = _loginDialog;
//@synthesize facebookName = _facebookName;
//@synthesize posting = _posting;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Mi Progreso";
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
//    medidaMeta = @"0.0";
//    medidaActual = @"0.0";
//    pesoMeta   = @"0.0";
//    pesoActual = @"0.0";
    
    updateViews = YES;
    
    
    
    [actual setHidden:YES];
    [meta setHidden:YES];
    
    isPeso = YES;

    if(isPeso){
        [self.chart setHidden:NO];
        [self.chartMedida setHidden:YES];
        [Flurry logEvent:@"Mi Progreso Grafica Peso" timed:YES];
    }else{
        [self.chart setHidden:YES];
        [self.chartMedida setHidden:NO];
        [Flurry logEvent:@"Mi Progreso Grafica Medida" timed:YES];
    }
    
//    float dif = 0.0;
//    if(isPeso){
//        [self.chart setHidden:NO];
//        [self.chartMedida setHidden:YES];
//        [actual setPlaceholder:@"Ingresa tu peso actual"];
//        [meta setPlaceholder:@"Ingresa tu peso meta"];
//        
//        [metaLabel setText:[NSString stringWithFormat:@"Meta: %@ Kg", pesoMeta]];
//        //        if(![pesoMeta isEqualToString:@"0"]&&![pesoActual isEqualToString:@"0"])
//        dif = ([pesoMeta floatValue] - [pesoActual floatValue]);
//        [llevasLabel setText:[NSString stringWithFormat:@"Llevas: %.1f Kg", pesoActual]];
//        
//        [faltanteLabel setText:[NSString stringWithFormat:@"¡Te Faltan %.0f Kilos para tu meta!", dif]];
//        [add.titleLabel setText:@"Nuevo Peso"];
//    }else{
//        [self.chart setHidden:YES];
//        [self.chartMedida setHidden:NO];
//        [actual setPlaceholder:@"Ingresa tu medida actual"];
//        [meta setPlaceholder:@"Ingresa tu medida meta"];
//        
//        [metaLabel setText:[NSString stringWithFormat:@"Meta: %@ cm", medidaMeta]];
//        //        if(![medidaMeta isEqualToString:@"0"]&&![medidaActual isEqualToString:@"0"])
//        dif = ([medidaMeta floatValue] - [medidaActual floatValue]);
//        [llevasLabel setText:[NSString stringWithFormat:@"Llevas: %.1f cm", medidaActual]];
//        
//        [faltanteLabel setText:[NSString stringWithFormat:@"¡Te Faltan %.0f Centimetros para tu meta!", dif]];
//        [add.titleLabel setText:@"Nueva Medida"];
//    }
    
    if(updateViews)
        [self loadJSONDataService];
    
    updateViews = FALSE;
    float dif;
    if(isPeso){  
        
        [metaLabel setText:[NSString stringWithFormat:@"Meta: %@ Kg", pesoMeta]];
        dif = ([pesoMeta floatValue] - [pesoActual floatValue]);
        dif = (dif>=0?dif:-dif);
        [llevasLabel setText:[NSString stringWithFormat:@"Peso Actual: %.1f Kg", [pesoActual floatValue]]];
        [faltanteLabel setText:[NSString stringWithFormat:@"¡Te Faltan %.0f Kilos para tu meta!", dif]];
        [add.titleLabel setText:@"Nuevo Peso"];
        [add reloadInputViews];
    }else{
        dif = ([medidaMeta floatValue] - [medidaActual floatValue]);
        dif = (dif>=0?dif:-dif);
        [metaLabel setText:[NSString stringWithFormat:@"Meta: %.1f cm", [medidaMeta floatValue]]];
        [llevasLabel setText:[NSString stringWithFormat:@"Peso Actual: %.1f cm", medidaActual]];
        [faltanteLabel setText:[NSString stringWithFormat:@"¡Te Faltan %.0f Centimetros para tu meta!", dif]];
        [add.titleLabel setText:@"Nueva Medida"];
        [add reloadInputViews];
    }
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////// UITwxtField Methods ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	[theTextField resignFirstResponder];
	return YES;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////// UISegmentedControll Methods ////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
-(IBAction)changeView:(id)sender{
    isPeso = (isPeso?NO:YES);
    LoadingView *splashLoading = [LoadingView loadingViewInView:self.navigationController.view];
    float dif = 0.0;
    
    if(isPeso){
        [self.chart setHidden:NO];
        [self.chartMedida setHidden:YES];
        [actual setPlaceholder:@"Ingresa tu peso actual"];
        [meta setPlaceholder:@"Ingresa tu peso meta"];
        
        [metaLabel setText:[NSString stringWithFormat:@"Meta: %@ Kg", pesoMeta]];
//        if(![pesoMeta isEqualToString:@"0"]&&![pesoActual isEqualToString:@"0"])
            dif = ([pesoMeta floatValue] - [pesoActual floatValue]);
        dif = (dif>=0?dif:-dif);
        [llevasLabel setText:[NSString stringWithFormat:@"Peso Actual: %.1f Kg", [pesoActual floatValue]]];

        [faltanteLabel setText:[NSString stringWithFormat:@"¡Te Faltan %.0f Kilos para tu meta!", dif]];
        [add.titleLabel setText:@"Nuevo Peso"];
        [Flurry logEvent:@"Mi Progreso Grafica Peso" timed:YES];
    }else{
        [self.chart setHidden:YES];
        [self.chartMedida setHidden:NO];
        [actual setPlaceholder:@"Ingresa tu medida actual"];
        [meta setPlaceholder:@"Ingresa tu medida meta"];
        
        dif = ([medidaMeta floatValue] - [medidaActual floatValue]);
        dif = (dif>=0?dif:-dif);
        [metaLabel setText:[NSString stringWithFormat:@"Meta: %.1f cm", [medidaMeta floatValue]]];
//        if(![medidaMeta isEqualToString:@"0"]&&![medidaActual isEqualToString:@"0"])
            
        [llevasLabel setText:[NSString stringWithFormat:@"Peso Actual: %.1f cm", [medidaActual floatValue]]];
        
        [faltanteLabel setText:[NSString stringWithFormat:@"¡Te Faltan %.0f Centimetros para tu meta!", dif]];
        [add.titleLabel setText:@"Nueva Medida"];
        [Flurry logEvent:@"Mi Progreso Grafica Medida" timed:YES];
    }
    [splashLoading performSelector:@selector(removeView) withObject:nil afterDelay:1.0];
}


/////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////// Facebook Delegate ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)facebookShare:(id)sender{
    facebook = [[Facebook alloc] initWithAppId:@"251706724889890"];
	// Otherwise, we don't have a name yet, just wait for that to come through.
    NSString *messageFacebook;
    
    if([pesoList count]<=2)
        messageFacebook = [NSString stringWithString:@"Inicio mi método personalizado con ayuda de los productos Franceses KOT. A través de mi KOT México iPhone App."];
    else
        messageFacebook = [NSString stringWithString:@"En camino a completar mi meta!. A través de mi KOT México iPhone App."];
    
    if([pesoActual isEqualToString:pesoMeta]|| [medidaActual isEqualToString:medidaMeta])
        messageFacebook = [NSString stringWithString:@"Completé mi meta con los productos Franceses KOT!. A través de mi KOT México iPhone App."];
    
    NSMutableDictionary *params = 
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"KOT México.", @"name",
     @"Método KOT", @"caption",
     messageFacebook, @"description",
     @"https://www.facebook.com/KOTMexico", @"link",
     @"https://fbcdn-sphotos-a.akamaihd.net/hphotos-ak-ash4/317387_218343991561656_517906239_n.jpg", @"picture",
     nil];  
    [facebook dialog:@"feed"
           andParams:params
         andDelegate:nil];
    
    [Flurry logEvent:@"Mi Progreso comparte en Facebook" timed:YES];
}


-(IBAction)shareTwitter:(id)sender{
    NSString *messageFacebook;
    
    if([pesoList count]<=2)
        messageFacebook = [NSString stringWithString:@"Inicio mi método personalizado con ayuda de los productos Franceses KOT. A través de mi KOT México iPhone App."];
    else
        messageFacebook = [NSString stringWithString:@"En camino a completar mi meta!. A través de mi KOT México iPhone App."];
    
    if([pesoActual isEqualToString:pesoMeta]|| [medidaActual isEqualToString:medidaMeta])
        messageFacebook = [NSString stringWithString:@"Completé mi meta con los productos Franceses KOT!. A través de mi KOT México iPhone App."];
    
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    [twitter setInitialText:messageFacebook];//optional
    [twitter addImage:[UIImage imageWithData:[NSData dataWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://fbcdn-sphotos-a.akamaihd.net/hphotos-ak-ash4/317387_218343991561656_517906239_n.jpg"]]]]];
    [twitter addURL:[NSURL URLWithString:[NSString stringWithString:@"http://twitter.com/Kot_Mexico"]]];
    
    if([TWTweetComposeViewController canSendTweet]){
        [self presentViewController:twitter animated:YES completion:nil];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Unable to tweet"
                                                            message:@"You might be in Airplane Mode or not have service. Try again later."
                                                           delegate:self cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
        if (TWTweetComposeViewControllerResultDone) {
//            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Tweeted"
//                                                                message:@"You successfully tweeted"
//                                                               delegate:self cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//            [alertView show];
        } else if (TWTweetComposeViewControllerResultCancelled) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ooops..."
                                                                message:@"Something went wrong, try again later"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        [self dismissModalViewControllerAnimated:YES];
    };
    [Flurry logEvent:@"Mi Progreso comparte en Twitter" timed:YES];
}
-(IBAction)sendEmail:(id)sender{
    NSString *messageFacebook;
    if([pesoList count]<=2)
        messageFacebook = [NSString stringWithString:@"Inicio mi método personalizado con ayuda de los productos Franceses KOT. A través de mi KOT México iPhone App."];
    else
        messageFacebook = [NSString stringWithString:@"En camino a completar mi meta!. A través de mi KOT México iPhone App."];
    
    if([pesoActual isEqualToString:pesoMeta]|| [medidaActual isEqualToString:medidaMeta])
        messageFacebook = [NSString stringWithString:@"Completé mi meta con los productos Franceses KOT!. A través de mi KOT México iPhone App."];
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:messageFacebook];
    [controller setMessageBody:messageFacebook isHTML:NO]; 
    [self presentModalViewController:controller animated:YES];
    [controller release];
    [Flurry logEvent:@"Mi Progreso comparte por correo" timed:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)initChartPeso{
    // Do any additional setup after loading the view from its nib
    
    // Create a few line plots with their controllers.
    WSPlotAxis *axis = [[WSPlotAxis alloc] initWithFrame:self.chart.frame];
    WSPlotData *line1 = [[WSPlotData alloc] initWithFrame:self.chart.frame];
    WSPlotData *line2 = [[WSPlotData alloc] initWithFrame:self.chart.frame];
    WSPlotData *line3 = [[WSPlotData alloc] initWithFrame:self.chart.frame];
    WSPlotController *ctrlA = [WSPlotController new];
    WSPlotController *ctrl1 = [WSPlotController new];
    WSPlotController *ctrl2 = [WSPlotController new];
    WSPlotController *ctrl3 = [WSPlotController new];
    ctrlA.view = axis;
    ctrl1.view = line1;
    ctrl2.view = line2;
    ctrl3.view = line3;
    // DATA CHAR AT
    NSMutableArray *tempSemanas = [[NSMutableArray alloc] init];
    NSMutableArray *tempPoints = [[NSMutableArray alloc] init];
    NSMutableArray *tempPoints2 = [[NSMutableArray alloc] init];
//    if([pesoList count]==1){
        [tempPoints2 addObject:[NSNumber numberWithFloat:0.0]];//[peso_inicio floatValue]]];
//        [tempSemanas addObject:@""];
//    }
    for (NSString *json in pesoList) {
        NSDictionary *itemJSon = [[json JSONRepresentation] JSONValue];
        [tempSemanas addObject:[NSString stringWithFormat:@"%@ sem",[itemJSon objectForKey:@"Semana"]]];
        [tempPoints addObject:[NSNumber numberWithFloat:[[itemJSon objectForKey:@"kilos"] floatValue]]];
        [tempPoints2 addObject:[NSNumber numberWithFloat:[[itemJSon objectForKey:@"kilos"] floatValue]]];
        pesoActual = [[NSString stringWithFormat:@"%.2f",[[itemJSon objectForKey:@"kilos"]floatValue]]retain];
    }
//    if([tempPoints count]>1){
//        [tempPoints removeObjectAtIndex:0];
//        [tempSemanas removeObjectAtIndex:0];
//    }
    float rates[2] = {90.0, 0.0}; 
    //24.8, 40.3, 36.7, 48.6, 48.3,
    //               41.8, 47.4, 44.6, 56.2, 44.4, 66.8};
    ctrl1.dataD = [WSData dataWithValues:[WSData arrayWithFloat:rates withLen:2]];
    ctrl2.dataD = [[WSData dataWithValues:tempPoints2] indexedData];
    ctrl3.dataD = [[WSData dataWithValues:tempPoints] indexedData];
    
    // Configure the appearance of the plots.
    
    axis.axisStyleX = kAxisPlain;//kAxisPlain
    axis.gridStyleX = kGridDotted;//Delete line
    axis.axisStyleY = kAxisPlain;//kAxisNone
    axis.gridStyleY = kGridDotted;//kGridDotted
    [axis.ticksX setTickLabelsWithStrings:tempSemanas];
    axis.ticksX.ticksStyle = kTicksLabelsSlanted;
    
    
    axis.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    axis.axisStrokeWidth = 0.5;
    [axis.ticksY autoTicksWithRange:NARangeMake(0.0, 200.0) withNumber:10];

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [axis.ticksY setTickLabelsWithFormatter:formatter];
    axis.ticksY.ticksStyle = kTicksLabels;
    
    axis.gridStrokeWidth = 1.0;
    line1.lineColor = [UIColor clearColor];
    line2.lineColor = [UIColor clearColor];
    line3.lineColor = [UIColor blueColor];
    line1.symbolStyle = kSymbolDisk;
    line2.symbolStyle = kSymbolDisk;
    line3.symbolStyle = kSymbolDisk;
    line1.symbolColor = line1.lineColor;
    line2.symbolColor = line1.lineColor;
    line3.symbolColor = line3.lineColor;
    line3.symbolSize = 8.0;
    line3.hasShadow = YES;
    line1.intStyle = kInterpolationSpline;
    line2.intStyle = kInterpolationSpline;
    line3.intStyle = kInterpolationSpline;
    
    // Finally, add them to the chart.
    [self.chart addPlot:ctrlA];
    [self.chart addPlot:ctrl1];
    [self.chart addPlot:ctrl2];
    [self.chart addPlot:ctrl3];
    [self.chart autoscaleAllAxisX];
    [self.chart autoscaleAllAxisY];
    [self.chart setAllAxisLocationXD:0.0];
    [self.chart setAllAxisLocationYD:0.0];
    
    [axis release];
    [line1 release];
    [line2 release];
    [line3 release];
    [ctrlA release];
    [ctrl2 release];
    [ctrl3 release];
}
-(void)initChartMedida{
    // Do any additional setup after loading the view from its nib
    // Create a few line plots with their controllers.
    WSPlotAxis *axis = [[WSPlotAxis alloc] initWithFrame:self.chartMedida.frame];
    WSPlotData *line1 = [[WSPlotData alloc] initWithFrame:self.chartMedida.frame];
    WSPlotData *line2 = [[WSPlotData alloc] initWithFrame:self.chartMedida.frame];
    WSPlotData *line3 = [[WSPlotData alloc] initWithFrame:self.chartMedida.frame];
    WSPlotController *ctrlA = [WSPlotController new];
    WSPlotController *ctrl1 = [WSPlotController new];
    WSPlotController *ctrl2 = [WSPlotController new];
    WSPlotController *ctrl3 = [WSPlotController new];
    ctrlA.view = axis;
    ctrl1.view = line1;
    ctrl2.view = line2;
    ctrl3.view = line3;
    
    // DATA CHAR AT
    NSMutableArray *tempSemanas = [[NSMutableArray alloc] init];
    NSMutableArray *tempPoints = [[NSMutableArray alloc] init];
    NSMutableArray *tempPoints2 = [[NSMutableArray alloc] init];
//    if([pesoList count]==1){
    [tempPoints2 addObject:[NSNumber numberWithFloat:0.0]];//[medida_inicio floatValue]]];
//        [tempSemanas addObject:@""];
//    }
    for (NSString *json in medidaList) {
        NSDictionary *itemJSon = [[json JSONRepresentation] JSONValue];
        [tempSemanas addObject:[NSString stringWithFormat:@"%@ sem",[itemJSon objectForKey:@"Semana"]]];
        [tempPoints addObject:[NSNumber numberWithFloat:[[itemJSon objectForKey:@"medida"] floatValue]]];
        [tempPoints2 addObject:[NSNumber numberWithFloat:[[itemJSon objectForKey:@"medida"] floatValue]]];
        medidaActual = [[NSString stringWithFormat:@"%.2f",[[itemJSon objectForKey:@"medida"]floatValue]]retain];
    }
//    if([tempPoints count]>1){
//        [tempPoints removeObjectAtIndex:0];
//        [tempSemanas removeObjectAtIndex:0];
//    }
    
    float rates[2] = {(90.0), 40.0};
    
    ctrl1.dataD = [WSData dataWithValues:[WSData arrayWithFloat:rates withLen:2]];
    ctrl2.dataD = [[WSData dataWithValues:tempPoints2] indexedData];
    ctrl3.dataD = [[WSData dataWithValues:tempPoints] indexedData];
    
    // Configure the appearance of the plots.
    
    axis.axisStyleX = kAxisPlain;//kAxisPlain
    axis.gridStyleX = kGridDotted;//Delete line
    axis.axisStyleY = kAxisPlain;//kAxisNone
    axis.gridStyleY = kGridDotted;//kGridDotte
    
    [axis.ticksX setTickLabelsWithStrings:tempSemanas];
    axis.ticksX.ticksStyle = kTicksLabelsSlanted;
    
    
    axis.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    axis.axisStrokeWidth = 0.5;
    [axis.ticksY autoTicksWithRange:NARangeMake(0.0, 200.0) withNumber:10];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [axis.ticksY setTickLabelsWithFormatter:formatter];
    axis.ticksY.ticksStyle = kTicksLabels;
    
    axis.gridStrokeWidth = 1.0;
    line1.lineColor = [UIColor clearColor];
    line2.lineColor = [UIColor clearColor];
    line3.lineColor = [UIColor redColor];
    line1.symbolStyle = kSymbolEmptySquare;
    line2.symbolStyle = kSymbolEmptySquare;
    line3.symbolStyle = kSymbolDisk;
    line1.symbolColor = line1.lineColor;
    line2.symbolColor = line1.lineColor;
    line3.symbolColor = line3.lineColor;
    line3.symbolSize = 8.0;
    line3.hasShadow = YES;
    line1.intStyle = kInterpolationSpline;
    line2.intStyle = kInterpolationSpline;
    line3.intStyle = kInterpolationSpline;
    
    // Finally, add them to the chart.
    [self.chartMedida addPlot:ctrlA];
    [self.chartMedida addPlot:ctrl1];
    [self.chartMedida addPlot:ctrl2];
    [self.chartMedida addPlot:ctrl3];
    [self.chartMedida autoscaleAllAxisX];
    [self.chartMedida autoscaleAllAxisY];
    [self.chartMedida setAllAxisLocationXD:0.0];
    [self.chartMedida setAllAxisLocationYD:0.0];
    
    [axis release];
    [line1 release];
    [line3 release];
    [ctrlA release];
    [ctrl1 release];
    [ctrl2 release];
    [ctrl3 release];

}

-(void)loadJSONDataService{
    LoadingView *splashLoading = [LoadingView loadingViewInView:self.navigationController.view];
    
    sqlite = [[CommonDAO alloc] init];
    NSArray *user = [sqlite select:@"SELECT id_usuario, nombre, apellidos, correo, genero, edad, altura, nutriologo FROM usuario;" keys:[NSArray arrayWithObjects:@"id_usuario",@"nombre",@"apellidos",@"correo",@"genero",@"edad",@"altura",@"nutriologo", nil]];
    
    if([user count]){
        
        
        [Flurry logEvent:@"Mi Progreso" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:[user objectAtIndex:0],@"Usuario", nil] timed:YES];
        
        
        NSString *urlConnection = [[[NSString alloc] initWithFormat:@"http://kot.mx/nuevo/WS/kotMiProgreso.php?idUserKot=%@",[[user objectAtIndex:0]objectAtIndex:0]] autorelease];
        
        NSURL *url = [[[NSURL alloc] initWithString:urlConnection] autorelease];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:180.0];
        // Fetch the JSON response
        NSData *urlData;
        NSURLResponse *response;
        NSError *error;
        
        // Make synchronous request
        urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        NSString *jsonData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        
        NSError *jsonError;
        SBJSON *json = [[SBJSON new] autorelease];
        NSDictionary *contentJSON = [json objectWithString:jsonData error:&jsonError];
        if (contentJSON==nil) {
            NSString *text = [[NSString alloc] initWithFormat:@"%@", [error localizedDescription]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:text delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }else{
            NSString *messageError = [contentJSON objectForKey:@"mensaje_error"];
            NSDictionary *usuarioLogin;
            if([messageError length]==0){
                // create a filtered list that will contain products for the search results table.
                
                peso_inicio = [contentJSON objectForKey:@"peso_inicio"];
                medida_inicio = [contentJSON objectForKey:@"medida_inicio"];
                
                usuarioLogin = [[[[contentJSON objectForKey:@"usuario"] JSONRepresentation] JSONValue]retain];
                pesoList= [[contentJSON mutableArrayValueForKey:@"kilos"]retain];
                medidaList= [[contentJSON mutableArrayValueForKey:@"medidas"]retain];

                
                medidaMeta = [[NSString stringWithFormat:@"%.1f", [[contentJSON objectForKey:@"meta_medida"]floatValue]]retain];
                pesoMeta   = [[NSString stringWithFormat:@"%.1f", [[contentJSON objectForKey:@"meta_peso"]floatValue]]retain];
                
                [banderaImageView setHidden:NO];
                [llevasLabel setHidden:NO];
                [metaLabel setHidden:NO];
                [faltanteLabel setHidden:NO];
                
                [self initChartPeso];
                [self initChartMedida];
                
            }else{
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:messageError delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [message show];
                [message release];
                message = nil;
            }
        }

    }else{
        [banderaImageView setHidden:YES];
        [llevasLabel setHidden:YES];
        [metaLabel setHidden:YES];
        [faltanteLabel setHidden:YES];
        
        UIAlertView *message = [[UIAlertView alloc]initWithTitle:@"KOT México" message:@"Aún no te has registrado en KOT, ¿Registrar ahora?" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Registrar", nil];
        [message show];
        [message release];
        message = nil;
    }
    [splashLoading performSelector:@selector(removeView) withObject:nil afterDelay:1.0];
}
-(IBAction)nuevPesoMedida:(id)sender{
    NSString *semanaSiguiente =[NSString stringWithString: @"0"];
    NSString *typeMedida;
    AddMedidaPesoView *apm = [[AddMedidaPesoView alloc] initWithNibName:@"AddMedidaPesoView" bundle:nil];

    if(isPeso){
        for (NSString *json in pesoList) {
            NSDictionary *itemJSon = [[json JSONRepresentation] JSONValue];
            semanaSiguiente = [itemJSon objectForKey:@"Semana"];
        }
        semanaSiguiente =  [NSString stringWithFormat:@"%i",([semanaSiguiente intValue]+1)];
        typeMedida = [NSString stringWithString:@"peso"];
    }else{
        for (NSString *json in medidaList) {
            NSDictionary *itemJSon = [[json JSONRepresentation] JSONValue];
            semanaSiguiente = [itemJSon objectForKey:@"Semana"];
        }
        semanaSiguiente =  [NSString stringWithFormat:@"%i",([semanaSiguiente intValue]+1)];
        typeMedida = [NSString stringWithString:@"medida"];
    }
    
    sqlite = [[[CommonDAO alloc] init]autorelease];
    NSArray *user = [sqlite select:@"SELECT id_usuario, nombre, apellidos, correo, genero, edad, altura, nutriologo FROM usuario;" keys:[NSArray arrayWithObjects:@"id_usuario",@"nombre",@"apellidos",@"correo",@"genero",@"edad",@"altura",@"nutriologo", nil]];
    [apm setIsPeso:isPeso];
    apm.semana = semanaSiguiente;
    apm.type = typeMedida;
    apm.idUsuario = [[user objectAtIndex:0]objectAtIndex:0];
    apm.myProgresoSelf = self;
    [self.navigationController pushViewController:apm animated:YES];
    updateViews = YES;
}

- (void)dealloc {
    [super dealloc];
}
- (void) viewWillDisappear:(BOOL)animated{
    //updateViews = (updateViews ? NO:YES);
}

- (void) viewDidAppear:(BOOL)animated{
    if(isPeso){
        [add.titleLabel setText:@"Nuevo Peso"];
        [add.titleLabel setTextAlignment:UITextAlignmentCenter];
    }
    else{
        [add.titleLabel setText:@"Nueva Medida"];
        [add.titleLabel setTextAlignment:UITextAlignmentCenter];
    }
    
    if(updateViews)
        [self loadJSONDataService];
}
//-(void)reloadDataView{
//    [self loadJSONDataService];
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Registrar"]){
        PreferencesViewController *pvc = [[PreferencesViewController alloc] initWithNibName:@"PreferencesViewController" bundle:nil];
        pvc.isHiddenNavigationBar = YES;
        [self.navigationController pushViewController:pvc animated:YES];
        [pvc release];
        pvc = nil;
    }
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancelar"])
        [self.navigationController popViewControllerAnimated:YES];
}

@end
