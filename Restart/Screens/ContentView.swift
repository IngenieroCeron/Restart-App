//
//  ContentView.swift
//  Restart
//
//  Created by Eduardo Ceron on 25/10/21.
//
/*
 En el primer video vimos como hacer la app portrait solamente, meterle color al launchscreen, crear carpetas para hacer una arquitectura mejor, meterle los assets (color, imagenes y sonidos).
 Tambien creamos una nueva propiedad con el property wrapper llamado "@AppStorage" que contenga el estado inicial y posterior de nuestra app.
 Primero, esta nueva propiedad configurará una nueva clave de incorporación y almacenamiento de aplicaciones.
 La primera parte de este almacenamiento de aplicaciones es un contenedor de propiedades especial de SwiftUI que usará los valores predeterminados del usuario bajo el capó.
 Su propósito es almacenar algún valor en el almacenamiento permanente del dispositivo utilizando un método de configuración.
 La segunda parte Este es un identificador único al que podemos referirnos más adelante usando esta clave.
 Podemos editar o recuperar el valor guardado en el almacenamiento del dispositivo.
 La tercera parte, este es el nombre de propiedad real que podemos usar en este archivo SwiftUI.
 La cuarta parte, aquí es donde establecemos el valor inicial de la propiedad.
 En nuestro caso, este valor se inicializará solo una vez con un valor verdadero.
 Esto es algo esencial y revelaré algo crucial al respecto un poco más adelante.
 La lógica detrás de este código es que cuando los usuarios inician la aplicación, la primera pantalla que deben ver es la pantalla de incorporación.
 El siguiente paso es crear una declaración condicional.
 Y en esta nueva condición, podemos mostrar la pantalla adecuada según el estado real de esta nueva propiedad almacenada en el almacenamiento de la aplicación que se está configurando.
 */

import SwiftUI

struct ContentView: View {
    
    @AppStorage("onboarding") var isOnBoardingViewActive: Bool = true
    
    var body: some View {
        ZStack{
            if isOnBoardingViewActive {
                OnBoardingView()
            }else {
                HomeView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
