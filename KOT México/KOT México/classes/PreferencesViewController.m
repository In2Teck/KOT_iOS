//
//  PreferencesViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 01/02/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "PreferencesViewController.h"
#import "../AppDelegate.h"
#import "AboutViewController.h"
#import "Flurry.h"

@implementation PreferencesViewController

@synthesize isHiddenNavigationBar;

@synthesize loginCell;
@synthesize registroCell;
@synthesize myTableView;
//@synthesize myNavigationBar;

@synthesize generoButton;
@synthesize codigo,password, repitPassword;
@synthesize correo,email;
@synthesize nombre;
@synthesize apellido;
@synthesize edad;
@synthesize altura;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    /*UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoButton.backgroundColor = [UIColor clearColor];
    [infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *info = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = info;*/
//    self.myNavigationBar.topItem.rightBarButtonItem = info;
    
//    [self.myNavigationBar setHidden:isHiddenNavigationBar];
    
    //self.title = @"Perfil No Registrado";
//    if(isHiddenNavigationBar)
//        self.myTableView.frame = self.view.frame;
    
    // Do any additional setup after loading the view from its nib.
    arrayNo = [[NSMutableArray alloc] init];
    [arrayNo addObject:@"Sexo"];
	[arrayNo addObject:@"Femenino"];
	[arrayNo addObject:@"Masculino"];
    [generoButton.titleLabel setTextAlignment:UITextAlignmentLeft];
    [generoButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancela" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelCodigo)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Ok" style:UIBarButtonItemStyleDone target:self action:@selector(doneCodigo)],
                           nil];
    [numberToolbar sizeToFit];
    codigo.inputAccessoryView = numberToolbar;
    
    UIToolbar* numberToolbar2 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar2.barStyle = UIBarStyleDefault;
    numberToolbar2.items = [NSArray arrayWithObjects:
                            [[UIBarButtonItem alloc]initWithTitle:@"Cancela" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelCorreo)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Ok" style:UIBarButtonItemStyleDone target:self action:@selector(doneCorreo)],
                            nil];
    [numberToolbar2 sizeToFit];
    correo.inputAccessoryView = numberToolbar2;
    
    if(!sqlite)
        sqlite = [[CommonDAO alloc] init];
    
    user = [sqlite select:@"SELECT id_usuario, nombre, apellidos, correo, genero, edad, altura, nutriologo FROM usuario;" keys:[NSArray arrayWithObjects:@"id_usuario",@"nombre",@"apellidos",@"correo",@"genero",@"edad",@"altura",@"nutriologo", nil]];
    
    if([user count]){
        isLoged = YES;
        [self setTitle:@"Perfil Registrado"];
    }else{
        isLoged = NO;
        [self setTitle:@"Perfil No Registrado"];
    }
    
    [sqlite release];
    [super viewDidLoad];
}

-(void)cancelCodigo{
    [codigo resignFirstResponder];
    codigo.text = @"";
}

-(void)doneCodigo{
    [codigo resignFirstResponder];
}

-(void)cancelCorreo{
    [correo resignFirstResponder];
    correo.text = @"";
}

-(void)doneCorreo{
    [correo resignFirstResponder];
}

/*-(IBAction)infoButtonPressed:(id)sender{
    AboutViewController *aboutInfo = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:[NSBundle mainBundle]];
    aboutInfo.navigationItem.title = @"Acerca de";
    [self.navigationController pushViewController:aboutInfo animated:YES];
}*/
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [sqlite release];
    sqlite = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/************************************************************************/
/************************************************************************/
/************************** TABLE DELEGATE ******************************/
/************************************************************************/
/************************************************************************/

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    if (isLoged) {
        footerView.frame = CGRectMake(0.0, 0.0, tableView.frame.size.width, 60.0);
        UIButton *logout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        logout.frame = CGRectMake(10.0, 10.0, (footerView.frame.size.width*0.9), 40.0);
        [logout setTitle:@"Desconectar Cuenta" forState:UIControlStateNormal];
        [logout.titleLabel setTextColor:[UIColor redColor]];
        [logout addTarget:self action:@selector(logoutUserAction) forControlEvents:UIControlEventTouchUpInside];
        
        [footerView addSubview:logout];
    }
    return footerView;
}
-(float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section||isLoged)
        return 90.0;
    else
        return 0.0;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (!isLoged) {
        if(section)
            return @"Si no has acudido con tu especialista KOT registra tus datos.";
        else
            return @"Si ya acudiste con tu especialista KOT enlaza tu información.";
    }else{
        return @"Información Personal";
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!isLoged) {
        if(indexPath.section==0)
            return 130.0;
        else
            return 335.0;
    }else{
        return 44.0;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    if(!isLoged)
        return 1;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if(!isLoged)
        return 1;
    else
        return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (!isLoged) {
        if (indexPath.section == 0)
            return loginCell;
        if(indexPath.section == 1)
            return registroCell;
    }
    [cell.textLabel setNumberOfLines:2];
    if(indexPath.row == 0)
        [cell.textLabel setText:[NSString stringWithFormat:@"Número para tu especialista KOT: %@",[[user objectAtIndex:0] objectAtIndex:0]]];
    
    if(indexPath.row == 1)
        [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@",[[user objectAtIndex:0] objectAtIndex:1],[[user objectAtIndex:0] objectAtIndex:2]]];
    
    if(indexPath.row == 2)
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[[user objectAtIndex:0] objectAtIndex:3]]];
    
    if(indexPath.row == 3)
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[[user objectAtIndex:0] objectAtIndex:5]]];
    
    if(indexPath.row == 4)
        [cell.textLabel setText:[NSString stringWithFormat:@"%.2f Mts",[[[user objectAtIndex:0] objectAtIndex:6]floatValue]]];
    
    if(indexPath.row == 5)
        [cell.textLabel setText:[NSString stringWithFormat:@"Especialista: %@",[[user objectAtIndex:0] objectAtIndex:7]]];
    
    [cell.textLabel setTextColor:[UIColor grayColor]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor lightTextColor]];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tax   bleView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



-(IBAction)loginUser:(id)sender{
    UIAlertView *message;
    if([codigo.text length]<2){
        message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:@"El Codigo/Password es requerido, minimo 2 caracteres." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [message show];
        [message release];
        message = nil;
    }else{
        if([correo.text length]<=5){
            message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:@"El Correo es requerido, minimo 5 caracteres." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [message show];
            [message release];
            message = nil;
        }else{
            [self loginUserAction];
        }
    }      
}
-(IBAction)registroUser:(id)sender{
    UIAlertView *message;
    if([nombre.text length]<3){
        message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:@"El nombre debe contar con mínimo 3 caracteres." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [message show];
        [message release];
        message = nil;
    }else{
        if([apellido.text length]<3){
            message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:@"El apellido debe contar con mínimo 3 caracteres." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [message show];
            [message release];
            message = nil;
        }else{
            if([edad.text length]<2){
                message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:@"La fecha de nacimiento es necesaria." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [message show];
                [message release];
                message = nil;
            }else{
                NSCharacterSet *decimalSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
                
                if([altura.text length]<2 && [[altura.text stringByTrimmingCharactersInSet:decimalSet] length]>0){
                    message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:@"La altura no es Valida." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                    [message show];
                    [message release];
                    message = nil;
                }else{
                    if([password.text length]<3){
                        message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:@"El Password es requerido, minimo 3 caracteres." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                        [message show];
                        [message release];
                        message = nil;
                    }else{
                        if([email.text length]<5){
                            message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:@"El Correo es requerido, minimo 5 caracteres." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                            [message show];
                            [message release];
                            message = nil;
                        }else{
                            
                            if([[generoButton.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"Sexo"]){
                                message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:@"Selecciona tu sexo." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                                [message show];
                                [message release];
                                message = nil;
                            }else
                                if([password.text isEqualToString:repitPassword.text]){
                                    [self registroUserAction];
                                }else{
                                    message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:@"El Password no coincide." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                                    [message show];
                                    [message release];
                                    message = nil;
                                }
                        }
                    }  
                }
            }
        } 
    } 
}

-(void)logoutUserAction{
    LoadingView *splashLoading = [LoadingView loadingViewInView:self.tabBarController.view];
    
    isLoged = NO;
    sqlite = [[CommonDAO alloc] init];
    [sqlite delete:@"DELETE FROM usuario;"];
    
    [sqlite release];
    sqlite = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"miMetodoTimestamp"];
    [defaults removeObjectForKey:@"desayuno_intensivo"];
    [defaults removeObjectForKey:@"comida_intensivo"];
    [defaults removeObjectForKey:@"colacion_1_intensivo"];
    [defaults removeObjectForKey:@"colacion_2_intensivo"];
    [defaults removeObjectForKey:@"cena_intensivo"];
    [defaults removeObjectForKey:@"desayuno_progresivo"];
    [defaults removeObjectForKey:@"comida_progresivo"];
    [defaults removeObjectForKey:@"colacion_1_progresivo"];
    [defaults removeObjectForKey:@"colacion_2_progresivo"];
    [defaults removeObjectForKey:@"cena_progresivo"];
    
    [self.myTableView reloadData];
    [self setTitle:@"Perfil No Registrado"];
    [splashLoading performSelector:@selector(removeView) withObject:nil afterDelay:1.0];
}
-(void)loginUserAction{
    LoadingView *splashLoading = [LoadingView loadingViewInView:self.tabBarController.view];
    
    NSString *urlConnection = [[[NSString alloc] initWithFormat:@"http://kot.mx/nuevo/WS/kotLogin.php?mail=%@&code=%@&password=%@",correo.text,codigo.text,codigo.text ]autorelease];
    
    NSLog(@"url Login: %@",urlConnection);
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
        NSMutableDictionary *usuarioLogin;
        if([messageError length]==0){
            // create a filtered list that will contain products for the search results table.
            usuarioLogin = [[[[contentJSON objectForKey:@"usuario"] JSONRepresentation] JSONValue]retain];

            NSString *query = [NSString stringWithFormat:@"INSERT INTO usuario (id_usuario, nombre, apellidos, correo, genero, edad, altura, nutriologo) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@');",[usuarioLogin objectForKey:@"id"],[usuarioLogin objectForKey:@"nombre"],@"",[usuarioLogin objectForKey:@"correo"],[generoButton.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],[usuarioLogin objectForKey:@"edad"],[usuarioLogin objectForKey:@"altura"],[usuarioLogin objectForKey:@"nutriologo"]];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd-MM-yyyy"];
            
            
            
            NSDate *birthDate = [dateFormat dateFromString:[usuarioLogin objectForKey:@"edad"]];
            NSTimeInterval dateDiff = [birthDate timeIntervalSinceNow];
            int age=trunc(dateDiff/(60*60*24))/365;
            if(age<0)
                age=-(age);

            [Flurry setAge:age];
            [Flurry setUserID:[usuarioLogin objectForKey:@"id"]];

            [Flurry logEvent:@"Login User" withParameters:usuarioLogin timed:YES];
            

            sqlite = [[[CommonDAO alloc] init]autorelease];
            
            [sqlite insert:query];
            
            user = [sqlite select:@"SELECT id_usuario, nombre, apellidos, correo, genero, edad, altura, nutriologo FROM usuario;" keys:[NSArray arrayWithObjects:@"id_usuario",@"nombre",@"apellidos",@"correo",@"genero",@"edad",@"altura",@"nutriologo", nil]];
            
            isLoged = YES;
            [self.myTableView reloadData];
            [self setTitle:@"Perfil Enlazado"];
            
        }else{
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:messageError delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [message show];
            [message release];
            message = nil;
        }
    }
    [splashLoading performSelector:@selector(removeView) withObject:nil afterDelay:1.0];
}
-(void)registroUserAction{

    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *temp = [[[NSString alloc] initWithFormat:@"%@",[[myAppDelegate.dToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]]autorelease];
    temp = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];

    LoadingView *splashLoading = [LoadingView loadingViewInView:self.tabBarController.view];
//http://kot.mx/nuevo/WS/kotRegistro.php?nombre=Alejandro Virues&fecha_nacimiento=07-01-1984&altura=1.90&mail=agomez@sysop.com.mx&code=&password=123456&sexo=M&token=123456789012345678012345
    
    
    NSString *urlConnection = [[[NSString alloc] initWithFormat:@"http://kot.mx/nuevo/WS/kotRegistro.php?nombre=%@ %@&fecha_nacimiento=%@&altura=%@&mail=%@&code=%@&password=%@&sexo=%@&token=%@",nombre.text,apellido.text,edad.text,altura.text,email.text,password.text,password.text,[generoButton.titleLabel.text substringToIndex:1],temp]autorelease];
    
    NSLog(@"URL: %@",urlConnection);
    NSURL *url = [[[NSURL alloc] initWithString:[urlConnection stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] autorelease];
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
            usuarioLogin = [[[[contentJSON objectForKey:@"usuario"] JSONRepresentation] JSONValue]retain];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd-MM-yyyy"];
            NSDate *birthDate = [dateFormat dateFromString:[usuarioLogin objectForKey:@"edad"]];
            NSTimeInterval dateDiff = [birthDate timeIntervalSinceNow];
            int age=trunc(dateDiff/(60*60*24))/365;
            if(age<0)
                age=-(age);
            [Flurry setAge:age];
            [Flurry setGender:[generoButton.titleLabel.text substringToIndex:1]];
            [Flurry setUserID:[usuarioLogin objectForKey:@"id"]];
            
            [Flurry logEvent:@"Registro User" withParameters:usuarioLogin timed:YES];
            
            NSString *query = [NSString stringWithFormat:@"INSERT INTO usuario (id_usuario, nombre, apellidos, correo, genero, edad, altura, nutriologo) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@');",[usuarioLogin objectForKey:@"id"],[usuarioLogin objectForKey:@"nombre"],apellido.text,[usuarioLogin objectForKey:@"correo"],[generoButton.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],[usuarioLogin objectForKey:@"edad"],[usuarioLogin objectForKey:@"altura"],[usuarioLogin objectForKey:@"nutriologo"]];
            
            sqlite = [[[CommonDAO alloc] init]autorelease];
            
            [sqlite insert:query];
            
            user = [sqlite select:@"SELECT id_usuario, nombre, apellidos, correo, genero, edad, altura, nutriologo FROM usuario;" keys:[NSArray arrayWithObjects:@"id_usuario",@"nombre",@"apellidos",@"correo",@"genero",@"edad",@"altura",@"nutriologo", nil]];
            
            isLoged = YES;
            [self.myTableView reloadData];
            [self setTitle:@"Perfil Enlazado"];
            
        }else{
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:messageError delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [message show];
            [message release];
            message = nil;
        }
    }
    
    
    [splashLoading performSelector:@selector(removeView) withObject:nil afterDelay:1.0];
}
-(IBAction)selectSexo:(id)sender{
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"Selecciona tu sexo" 
                                                      delegate:nil
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"OK",nil];    
    // Add the picker
    UIPickerView *pickerView = [[UIPickerView alloc] init];
//    UIDatePicker *pickerView = [[UIDatePicker alloc] init];
//    pickerView.datePickerMode = UIDatePickerModeDate;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [pickerView setShowsSelectionIndicator:YES];
    
    [pickerView selectRow:0 inComponent:0 animated:YES];
    
    [menu addSubview:pickerView];
    [menu showInView:self.view];        
    
    CGRect menuRect = menu.frame;
    menuRect.origin.y -= 214;
    menuRect.size.height = 400;
    menu.frame = menuRect;
    
    
    CGRect pickerRect = pickerView.frame;
    pickerRect.origin.y = 174;
    pickerView.frame = pickerRect;
    
    [pickerView release];
    [menu release]; 
}
-(void)fechaNacimiento{

    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"Selecciona tu fecha de nacimiento" 
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"OK",nil];    
    // Add the picker
    datePickerView = [[UIDatePicker alloc] init];
    datePickerView.datePickerMode = UIDatePickerModeDate;
    
    [menu addSubview:datePickerView];
    [menu showInView:self.view];        
    
    CGRect menuRect = menu.frame;
    menuRect.origin.y -= 214;
    menuRect.size.height = 400;
    menu.frame = menuRect;
    
    
    CGRect pickerRect = datePickerView.frame;
    pickerRect.origin.y = 174;
    datePickerView.frame = pickerRect;
    
    [datePickerView release];
    [menu release]; 
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"]){
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        [edad setText:[NSString stringWithFormat:@"%@",[dateFormat stringFromDate:datePickerView.date]]];
        [dateFormat release];
        dateFormat = nil;
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////// UITwxtField DELEGATE ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	[theTextField resignFirstResponder];
    
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField == edad){
        [self fechaNacimiento];
        return NO;
    }else{
        return YES;
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// UIPICKER DELEGATE ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
	return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [generoButton.titleLabel setTextAlignment:UITextAlignmentLeft];
    [generoButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [generoButton.titleLabel setText:[arrayNo objectAtIndex:row]];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
	return [arrayNo count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
	return [arrayNo objectAtIndex:row];
}

-(void)viewDidDisappear:(BOOL)animated{
    sqlite = [[[CommonDAO alloc] init]autorelease];
    user = [sqlite select:@"SELECT id_usuario, nombre, apellidos, correo, genero, edad, altura, nutriologo FROM usuario;" keys:[NSArray arrayWithObjects:@"id_usuario",@"nombre",@"apellidos",@"correo",@"genero",@"edad",@"altura",@"nutriologo", nil]];
    if([user count])
        isLoged = YES;
    [self.myTableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    sqlite = [[[CommonDAO alloc] init]autorelease];
    user = [sqlite select:@"SELECT id_usuario, nombre, apellidos, correo, genero, edad, altura, nutriologo FROM usuario;" keys:[NSArray arrayWithObjects:@"id_usuario",@"nombre",@"apellidos",@"correo",@"genero",@"edad",@"altura",@"nutriologo", nil]];
    if([user count])
        isLoged = YES;
    [self.myTableView reloadData];
}
@end
