#  Animation Part 2

Aqui vamos a agregarle animacion al monito del onboarding para que se pueda arrastrar hasta cierto punto hacia la izquierda y derecha  y que al haer eso los circulos del fondo se muevan en sentido opuesto con un efecto de desvanecimiento:
- Crear una variable en el archivo onboarding:

        @State private var imageOffset: CGSize = .zero
    Esta variable contiene dos valores, width y height, en este caso las dos estan inicializadas con cero.

- Ahora codificamos el "Drag Gesture":
    - NOs vamos a los modificadores del monito, ahi agregamos un offset y un gesture:
                        .offset(x: imageOffset.width * 1.2, y: 0)
                        .gesture(
                        DragGesture()
                            .onChanged{ gesture in
                                imageOffset = gesture.translation
                            }
                        )
            Con este código vamos a poder arrastrar al monito pero lo podemos arrastrar nfinitamente y se queda donde lo dejemos, necesitamos darle un ñímite hasta donde se puede arrastrar y que al soltarlo se regrese a su posición inicial
            
    - Para agregarle un limite envolvemos el "imageOffset = gesture.translation" en in condicionante de la siguiente forma:
                        .gesture(
                        DragGesture()
                            .onChanged{ gesture in
                                if abs(imageOffset.width) <= 150 {
                                    imageOffset = gesture.translation
                                }
                            }
                        )
                Con esto le damos un limite para que no se pueda arrastrar el monito hasta afuera de la pantalla
    - Ahora hay que agregarle un onEnded para que se regrese el monito a su valor original:
                        .gesture(
                        DragGesture()
                            .onChanged{ gesture in
                                if abs(imageOffset.width) <= 150 {
                                    imageOffset = gesture.translation
                                }
                            }
                            .onEnded{ _ in
                                imageOffset = .zero
                            }
                        )
                Con esto ya se regresa el monito al centro de la pantalla
    
    - Ahora le daremos una animación al gesture para que cuando el monito se regrese a su posición inicial, no se regrese de putazo si no que se regrese lento, para ello agregamos un modificador al .gesture:
                        .gesture(
                        DragGesture()
                            .onChanged{ gesture in
                                if abs(imageOffset.width) <= 150 {
                                    imageOffset = gesture.translation
                                }
                            }
                            .onEnded{ _ in
                                imageOffset = .zero
                            }
                        )//: GESTURE
                        .animation(.easeOut(duration: 1), value: imageOffset)
                
    - Ahora le vamos a agregar una rotación para que el mmonito no solo se mueva en el eje de la x si no que al arrastrarlo se mueva con un angulo hacia abajo. Este modificador lo ponemos debajo del modificador .offset:
                        .rotationEffect(.degrees(Double(imageOffset.width / 20)))
                    Este parametro tiene dos valores, los degrees (o sea el angulo) en este le especificamos cuanto se va a rotar y la anchor (ancla) que no tenemos que especificarla por que su valor por default es el centro lo cual es lo que buscamos.
    
    - Ahora lo que haremos es que al arrastrarlo, se muevan los circulos del fondo en dirección opuesta. Para ello le agregaremos los siguientes modificadores al CircleGroupView, dentro de la pantalla onBoarding:
                        CircleGroupView(shapeColor: .white, shapeOpacity: 0.2)
                        .offset(x: imageOffset.width * -1)
                        .blur(radius: abs(imageOffset.width / 5))
                        .animation(.easeOut(duration: 1), value: imageOffset)
                Con esto le damos que se mueva a la direccion opuesta al multiplicarlo por -1 y que se vaya desvanieciendo.
                
    - Despues agregaremos una imagen encima del monito, solo para indicar al usuario que la imagen se puede mover hacia ambos lados, es una buena practica ya que algunas ocasiones no es tan obvio lo que la app pueda hacer. Para ello solo overley una imagen del sistema terminando el ZSTACK del "CENTER":
                .overlay(
                    Image(systemName: "arrow.left.and.right.circle")
                        .font(.system(size: 44, weight: .ultraLight))
                        .foregroundColor(.white)
                        .offset(y: 20)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 1).delay(2), value: isAnimating)
                    , alignment: .bottom
                )
            Con esto hacemos que la imagen esté posicionada abajo y con el offset aun mas abajo para que se vea mejor, tambien la imagen aparecerá despues de dos segundos pero no se golpe si no que se irá apareciendo con una duración de dos segundos
            
    - Ahora lo que haremos es desvanecer la imagen al momento de arrastrar al monito. Para ello tenemos que primero agregar una variable que almacene el valor de la opacidad. Y despues agregamos otro modificador de opaccidad a la misma imagen de la flecha con el valor de la variable. Y por ultimo le vamos a dar el valor correspondiente a la variable de la opacidad en el metodo onChange y del onEnded:
    
                @State private var indicatorOpacity: Double = 1.0
            
                .opacity(indicatorOpacity)
                
                        withAnimation(.linear(duration: 0.25)) {
                            indicatorOpacity = 0
                        }
                        withAnimation(.linear(duration: 0.25)) {
                            indicatorOpacity = 1
                        }
                        
## Ahora vamos a cambiar el texto del titulo.

- Primero agregamos otra variable que almacene el titulo:

            @State private var textTitle: String = "Share."
            
- Despues reemplazamos el valor del texto por la variable que acabamos de crear:

            Text(textTitle)
            
- Ahora le agregamos un modificador al texto:

            .transition(.opacity)

        Este modificador va a darle una animación de transcicion de transparente a opaca. Ahora solo tenemos que buscar un lugar donde podamos activar esta transición.
        
- Ahora vamos a activar la transición en el metodo onChange y dentro del withAnimation agregamos lo siguiente:

                textTitle = "Give."
            Con esto cambia el titulo al arrastrar el monito
            
- Ahora le cambiaremos el titulo al soltar el monito agregando codigo al metodo onEnded, dentro del withAnimation:
                    textTitle = "Share."
                Con este codigo al soltar el monito se regresa el texto a "Share."
                
Con haber implemetado el codgio de los ultimos 3 puntos vemos que al correrlo en el simulador, el titulo cambio de golpe en vez de hacer una transicion de opacidad suave.
Cuando cambiamos el valor de cualquier textView, resulta que SwiftUI trabaja diferente, swiftUI no considera el cambio de texto en una vista de Texto, el programa considera el mismo texto y no un cambio de texto. es por eso que no hace la animacion de cambiarlo lentamente. El framework no lo reconoce y por eso no podemos activar (trigger) la transición de opacidad 

## Arrgelar el problema del cambio de texto, lo podemos solucionar de la siguiente manera:

- Le agregamos un metodo ID al texto el cual nos va a indicar que el texto está cambiando. 
                        .id(textTitle)
                Con esto le agregamos un identificador unico y cuando el usuario empieza a arrastrar al monito se cambia el id.
                Con esto ahora las letras ya cambian con un movimiento lento y agradable.


            
            
    
    
    


