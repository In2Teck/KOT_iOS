//
//  AddMedidaPesoView.h
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 07/02/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../../JSON/JSON.h"
#import "ProgresoViewController.h"
@interface AddMedidaPesoView : UIViewController{
    NSString *type;
    NSString *idUsuario;
    NSString *semana; 
    ProgresoViewController *myProgresoSelf;
}
@property(nonatomic,retain)IBOutlet UILabel     *titulo;
@property(nonatomic,retain)IBOutlet UITextField *medida;
@property(nonatomic,retain) NSString *type;
@property(nonatomic,retain) NSString *idUsuario;
@property(nonatomic,retain) NSString *semana;  
@property(nonatomic,retain) ProgresoViewController *myProgresoSelf;
@property(nonatomic,assign) BOOL isPeso;
-(void)sendPesoMedida;

@end

