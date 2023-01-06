//
//  OnBoardingView.swift
//  Restart
//
//  Created by Eduardo Ceron on 25/10/21.
/*
 Para hacer que el botón se pueda deslizar y se vaya agrandando la parte rojo, se necesita lo siquiente:
 1. Crear una variable state para el ancho del botón: @State var buttonWidth: Double = UIScreen.main.bounds.width - 80
 2. despues se crea otra variable llamada buttonOffset
 3. Despues en la parte donde termina el footer, donde habiamos definido el alto de todo el zstack (del boton completo), ahi le agregamos el width y le damos el valor de la variable buttonWidth
 4. despues buscamos la seccion del boton rojo Druggable y agregar un nuevo modifier al ZStack .offset(x: buttonOffset)
 5. Despues reemplazamos al onTapGesture que teniamos por:
 .gesture(
     DragGesture()
 )//: GEsture
    Con el codigo anterior acabamos de agregar un nuevo arrastre al botón rojo, pero no hará nada hasta que le digamos que hacer
    Cada gesto de arrastre tiene dos estados particulares. El primer estado es cuando ocurre la actividad del usuario de arrastre. La segunda es cuando esta actividad de arrastre ha terminado. Podemos decirle al programa lo que queremos hacer con el botón rojo conociendo esta información.
 6. Comencemos agregando un nuevo modificador sin cambios a este gesto de arrastrar:
    .onChanged { gesture in
        if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 {
            buttonOffset = gesture.translation.width
        }
    }
 7. Despues agregamos este codigo al cierre del onChange para que cuando el boton este en la mitad de la izquierda se regrese el boton a cero o s está en la mitad de la derecha pase a la siguiente pantalla:
    .onEnded{ _ in
        if buttonOffset > buttonWidth / 2 {
            buttonOffset = buttonWidth - 80
            isOnBoardingViewActive = false
        } else {
            buttonOffset = 0
        }
    }
 8. Por ultimo hay que darle al fondo rojo que se llene mientras el foton se arrastra. Nos vamos a la seccion Capsule y ahi sustituimos el frame (el width) con el siguiente valor: buttonOffset + 80
 */

import SwiftUI

struct OnBoardingView: View {
    
    @AppStorage("onboarding") var isOnBoardingViewActive: Bool = true
    
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80
    @State private var buttonOffset: CGFloat = 0
    @State private var isAnimating: Bool = false
    @State private var imageOffset: CGSize = .zero
    @State private var indicatorOpacity: Double = 1.0
    @State private var textTitle: String = "Share."
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            Color("ColorBlue")
                .ignoresSafeArea(.all, edges: .all)
            VStack(spacing: 20) {
                
                //MARK: - HEADER
                
                Spacer()
                
                VStack(spacing: 0){
                    Text(textTitle)
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .id(textTitle)
                    
                    Text("""
                    It's not how much we give but
                    how much love we put into giving.
                    """)
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                }//: HEADER
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : -40)
                .animation(.easeOut(duration: 1), value: isAnimating)
                
                //MARK: - CENTER
                
                ZStack {
                    
                    CircleGroupView(shapeColor: .white, shapeOpacity: 0.2)
                        .offset(x: imageOffset.width * -1)
                        .blur(radius: abs(imageOffset.width / 5))
                        .animation(.easeOut(duration: 1), value: imageOffset)
                    
                    Image("character-1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 0.5), value: isAnimating)
                        .offset(x: imageOffset.width * 1.2, y: 0)
                        .rotationEffect(.degrees(Double(imageOffset.width / 20)))
                        .gesture(
                        DragGesture()
                            .onChanged{ gesture in
                                if abs(imageOffset.width) <= 150 {
                                    imageOffset = gesture.translation
                                    withAnimation(.linear(duration: 0.25)) {
                                        indicatorOpacity = 0
                                        textTitle = "Give."
                                    }
                                }
                            }
                            .onEnded{ _ in
                                imageOffset = .zero
                                withAnimation(.linear(duration: 0.25)) {
                                    indicatorOpacity = 1
                                    textTitle = "Share."
                                }
                            }
                        )//: GESTURE
                        .animation(.easeOut(duration: 1), value: imageOffset)
                }//: ZSTACK - CENTER
                .overlay(
                    Image(systemName: "arrow.left.and.right.circle")
                        .font(.system(size: 44, weight: .ultraLight))
                        .foregroundColor(.white)
                        .offset(y: 20)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 1).delay(2), value: isAnimating)
                        .opacity(indicatorOpacity)
                    , alignment: .bottom
                )
                
                Spacer()
                
                //MARK: - FOOTER
                
                ZStack{ //: Boton completo
                    // PARTS OF THE CUSTOM BUTTON
                    
                    // 1. BACKGROUND (STATIC)
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                    
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .padding(8)
                    
                    // 2. CALL-TO-ACTION (STATIC)
                    
                    Text("Empezar")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20)
                    
                    // 3. CAPSULE (DYNAMIC WIDTH)
                    
                    HStack {
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset + 80)
                        
                        Spacer()
                        
                    }
                    
                    
                    // 4. CIRCLE (DRAGGABLE)
                    
                    HStack {
                        ZStack{
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8)
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80, alignment: .center)
                        .offset(x: buttonOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 {
                                        buttonOffset = gesture.translation.width
                                    }
                                }
                                .onEnded{ _ in
                                    withAnimation(Animation.easeOut(duration: 0.4)){
                                        if buttonOffset > buttonWidth / 2 {
                                            hapticFeedback.notificationOccurred(.success)
                                            playSound(sound: "chimeup", type: "mp3")
                                            buttonOffset = buttonWidth - 80
                                            isOnBoardingViewActive = false
                                        } else {
                                            hapticFeedback.notificationOccurred(.warning)
                                            buttonOffset = 0
                                        }//: IF/ELSE
                                    }
                                }//: onEnded
                        )//: GEsture
                        
                        
                        // con este onTapGesture le estamos dando funcionalidad al ZStack, se lo quitamos por que implementamos un DragGesture:
//                        .onTapGesture {
//                            isOnBoardingViewActive = false
//                        }
                        
                        Spacer()
                        
                    }//: HSTACK
                    
                    
                }//: FOOTER
                .frame(width: buttonWidth ,height: 80, alignment: .center)
                .padding()
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 40)
                .animation(.easeOut(duration: 1), value: isAnimating)
                
            }//: VStack
        }//: ZSTACK
        .onAppear(perform: {
            isAnimating = true
        })
        .preferredColorScheme(.dark)
        
    }//: BODY
}//: STRUCT

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
