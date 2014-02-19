//
//  IMCViewController.m
//  KOT México
//
//  Created by Benjamín Hernández on 21/01/14.
//  Copyright (c) 2014 Naranya. All rights reserved.
//

#import "IMCViewController.h"
#import "CollapsableTableViewViewController.h"

@interface IMCViewController ()

@end

@implementation IMCViewController
@synthesize leyendaInformativa, sexoSelector, arrStatus, estaturaTextInput, pesoTextInput, semanas, IMC, isHombre, sexoLabel, queEsImcButton;

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
    IMC = 0.0;
    semanas = 0;
    isHombre = true;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:leyendaInformativa];
    sexoSelector.delegate = self;
    sexoSelector.showsSelectionIndicator = YES;
    [self.view addSubview:sexoSelector];
    
    arrStatus = [[NSArray alloc] initWithObjects:@"Hombre", @"Mujer", nil];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancela" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Ok" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    estaturaTextInput.inputAccessoryView = numberToolbar;
    
    UIToolbar* numberToolbar2 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar2.barStyle = UIBarStyleDefault;
    numberToolbar2.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancela" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad2)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Ok" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad2)],
                           nil];
    [numberToolbar2 sizeToFit];
    pesoTextInput.inputAccessoryView = numberToolbar2;
    
    [self.view addSubview:queEsImcButton];
    [self.view addSubview:sexoLabel];
}

-(void)cancelNumberPad{
    [estaturaTextInput resignFirstResponder];
    estaturaTextInput.text = @"";
}

-(void)doneWithNumberPad{
    NSString *numberFromTheKeyboard = estaturaTextInput.text;
    [estaturaTextInput resignFirstResponder];
}

-(void)cancelNumberPad2{
    [pesoTextInput resignFirstResponder];
    pesoTextInput.text = @"";
}

-(void)doneWithNumberPad2{
    NSString *numberFromTheKeyboard = pesoTextInput.text;
    [pesoTextInput resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [leyendaInformativa release];
    [sexoSelector release];
    [pesoTextInput release];
    [estaturaTextInput release];
    [queEsImcButton release];
    [sexoLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLeyendaInformativa:nil];
    [self setSexoSelector:nil];
    [self setPesoTextInput:nil];
    [self setEstaturaTextInput:nil];
    [self setQueEsImcButton:nil];
    [self setSexoLabel:nil];
    [super viewDidUnload];
}
- (IBAction)queEsIMC:(id)sender {
    UIAlertView *message = [[UIAlertView alloc]initWithTitle:@"¿Qué es el IMC?" message:@"El índice de masa corporal (IMC) es una medida de asociación entre el peso y la talla de un individuo. En el caso de los adultos se ha utilizado como uno de los recursos para evaluar su estado nutricional, de acuerdo con los valores propuestos por la Organización Mundial de la Salud. Ingresa los valores y descubre tu IMC." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [message show];
    [message release];
    message = nil;
}

//Delegate picker methods
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    if ([[arrStatus objectAtIndex:[pickerView selectedRowInComponent:0]] isEqualToString:@"Hombre"]){
        isHombre = true;
    } else {
        isHombre = false;
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return arrStatus.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
     return [arrStatus objectAtIndex:row];
}
    
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *retval = (id)view;
    if (!retval) {
        retval= [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] autorelease];
    }
    
    retval.text = [arrStatus objectAtIndex:row];
    retval.font = [UIFont systemFontOfSize:16];
    return retval;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 80;
    return sectionWidth;}
- (IBAction)calcularAction:(id)sender {
    UIAlertView *message;
    
    if (([pesoTextInput.text length] > 0) && ([estaturaTextInput.text length] > 0)){
        IMC = [pesoTextInput.text floatValue]/([estaturaTextInput.text floatValue]*[estaturaTextInput.text floatValue]);

        if (isHombre){
            semanas = round((([pesoTextInput.text floatValue]) - ((22.5)*([estaturaTextInput.text floatValue]*[estaturaTextInput.text floatValue])))/1.5);
        } else {
            semanas = round((([pesoTextInput.text floatValue]) - ((21)*([estaturaTextInput.text floatValue]*[estaturaTextInput.text floatValue])))/1.3);
        }
        NSString *mensajeIMC = [[NSString alloc] init];
        if (IMC < 18.5 ) {
            mensajeIMC = @"No necesitas bajar de peso";
        }else if(IMC <=24.9 && IMC >= 18.6){
            mensajeIMC = @"Estás en peso normal";
        }else if(IMC <=29.9 && IMC >=25){
            mensajeIMC = @"Tienes sobrepeso, te recomendamos ir con un Especialista KOT para ayudarte a llegar a tu peso ideal";
        }else{
            mensajeIMC = @"Tienes obesidad, te recomendamos ir con un Especialista KOT para ayudarte a llegar a tu peso ideal";
        }
        semanas = semanas < 0 ? 0 : semanas;
        message = [[UIAlertView alloc]initWithTitle:@"Resultado" message:[NSString stringWithFormat:@"IMC: %.2f\n\n %@ \n\nSemanas en KOT para peso ideal: %d", IMC, mensajeIMC, semanas] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
    } else {
         message = [[UIAlertView alloc]initWithTitle:@"Atención" message:@"Favor de introducir tu peso y tu estatura." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    }
    [message show];
    [message release];
    message = nil;
    
}

- (IBAction)especialistaKOTAction:(id)sender {
    CollapsableTableViewViewController *control = [[[CollapsableTableViewViewController alloc]initWithNibName:@"CollapsableTableViewViewController" bundle:nil]autorelease];
    [self.navigationController pushViewController:control animated:YES];
}

/* SCROLL KEYBOARD ON TEXT FIELD EDIT */

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 96; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *UIdTextFieldPhone = [textField viewWithTag:1];
    if (UIdTextFieldPhone == nil){
        [self animateTextField: textField up: YES];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UIView *UIdTextFieldPhone = [textField viewWithTag:1];
    if (UIdTextFieldPhone == nil){
        [self animateTextField: textField up: NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end