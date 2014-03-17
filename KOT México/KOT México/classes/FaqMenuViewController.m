//
//  FaqMenuViewController.m
//  KOT México
//
//  Created by Benjamín Hernández on 11/03/14.
//  Copyright (c) 2014 Naranya. All rights reserved.
//

#import "FaqMenuViewController.h"
#import "FaqViewController.h"

@interface FaqMenuViewController ()

@end

@implementation FaqMenuViewController

@synthesize categoria_1, categoria_2, categoria_3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    categoria_1 =[[NSMutableArray alloc] init];
    categoria_2 =[[NSMutableArray alloc] init];
    categoria_3 =[[NSMutableArray alloc] init];
    
    [self loadFAQ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadFAQ{
    NSString *urlConnection = @"http://desarrollo.sysop26.com/kot/nuevo/WS/kotPreguntas.php";
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
        if([messageError length]==0){
            NSArray *preguntas  = [[[contentJSON objectForKey:@"preguntas"]JSONRepresentation]JSONValue];
            
            for(NSDictionary *pregunta in preguntas){
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[pregunta objectForKey:@"Pregunta"], @"Pregunta", [pregunta objectForKey:@"Respuesta_Plano"], @"Respuesta_Plano", nil];
                
                if ([[pregunta objectForKey:@"id_categoria"] integerValue] == 1){
                    [categoria_1 addObject:dict];
                }else if ([[pregunta objectForKey:@"id_categoria"] integerValue] == 2){
                    [categoria_2 addObject:dict];
                }else if ([[pregunta objectForKey:@"id_categoria"] integerValue] == 3){
                    [categoria_3 addObject:dict];
                }
            }
        }else{
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:messageError delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [message show];
            [message release];
            message = nil;
        }
    }
}

- (IBAction)sobreMetodo:(id)sender {
    FaqViewController *faq = [[[FaqViewController alloc] initWithNibName:@"FaqViewController" bundle:nil]autorelease];
    faq.dataSource = categoria_1;
    [self.navigationController pushViewController:faq animated:YES];
}

- (IBAction)hacerMetodo:(id)sender {
    FaqViewController *faq = [[[FaqViewController alloc] initWithNibName:@"FaqViewController" bundle:nil]autorelease];
    faq.dataSource = categoria_2;
    [self.navigationController pushViewController:faq animated:YES];
}

- (IBAction)sobreProductos:(id)sender {
    FaqViewController *faq = [[[FaqViewController alloc] initWithNibName:@"FaqViewController" bundle:nil]autorelease];
    faq.dataSource = categoria_3;
    [self.navigationController pushViewController:faq animated:YES];
}

- (void)dealloc {
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
