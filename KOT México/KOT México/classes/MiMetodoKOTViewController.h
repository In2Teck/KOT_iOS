//
//  MiMetodoKOTViewController.h
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 07/02/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiMetodoKOTViewController : UIViewController{
    NSDictionary *intensivo;
    NSDictionary *progresivo;
    BOOL isIntensivo;
}

@property(nonatomic,retain) NSString *semanasUsuario;

@property(nonatomic,retain) NSDictionary *intensivo, *progresivo;
@property(nonatomic,retain) IBOutlet UITableView *myTableView;
@property(nonatomic,retain) IBOutlet UITableViewCell *desayuno,*comida,*colacion,*cena;

@property(nonatomic,retain) IBOutlet UILabel *cerealD, *proteinasD, *vegetalesD, *frutasD, *lacteosD, *productosKotD, *cerealC, *proteinasC, *v_crudoC, *v_cocidoC, *aceiteC, *frutaCol, *productosKotCol, *cerealesCe, *proteinaCe, *v_crudoCe, *v_cocidoCe, *frutaCe, *lacteosCe, *productosKotCe, *aceiteCe, *titleSemanas;

-(IBAction)changeSection:(id)sender;

-(IBAction)cerealAction:(id)sender;
-(IBAction)proteinaAction:(id)sender;
-(IBAction)vegetalesAction:(id)sender;
-(IBAction)v_crudosAction:(id)sender;
-(IBAction)v_cocidosAction:(id)sender;
-(IBAction)frutasAction:(id)sender;
-(IBAction)lacteosAction:(id)sender;
-(IBAction)aceiteAction:(id)sender;
-(IBAction)productosKotAction:(id)sender;
@end
