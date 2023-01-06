#  Animación

##Animación del encabezado

- Primero creamos en el oBoarding una variable para rastrear el estado de la animación: si la variable es verdadera, la animacion empieza y si es falsa, la animacion se detiene:

    @State var isAnimating: Bool = false

- Despues nos vamos a fuera del ZSTACK principal y ahi agregamos un onAppear para que cambia a true la variable anterior:
        .onAppear(perform: {
            isAnimating = true
        })

- Ahora nos vamos al final del VSTACK del header y agregamos opacidad, desfase y animación, estas 3 las agregamos dependiendo si la variable es true or false:
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : -40)
                .animation(.easeOut(duration: 1), value: isAnimating)
        La sintaxis de la condicionante es: ( Condicionante, ? , True , : , False )
        La sintaxis del .animation es: el primer parametro (.easeout(duration)) aqui le decimos que agregue una animacion de facil salida curva, esta salida se hace mas lenta al final de la animación con una duracion de un segundo; el segundo parametro es obligatorio, aqui le decimos al programa el valor que hace que inicie la animación

## Animación de la imagen de enmedio:

- Primero le damos unos modificadores condicionantes al final de la imagen del monito:
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 0.5), value: isAnimating)
                Con esto le damos una animacion de desvanecimiento
                
## Animación del boton de hasta abajo:

- Aqui le vamos a agregar un movimiento deslizante hacia arriba

- Nos vamos al final del ZSTACK de todo el boton de hasta abajo y ahi agregamos los modificadores
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 40)
                .animation(.easeOut(duration: 1), value: isAnimating)
        Con esto podemos ver como el botón se desliza hacia arriba con un efecto de desvanecimiento
        
## Animación para el cambio de pantalla

- Para hacer esto nos vamos al código donde se hace el Draggesture en el método del .onEnded, ahi envolvemos el if y else , con un metodo withAnimation, quedando de la siguiente forma:

                                .onEnded{ _ in
                                    withAnimation(Animation.easeOut(duration: 0.4)){
                                        if buttonOffset > buttonWidth / 2 {
                                            buttonOffset = buttonWidth - 80
                                            isOnBoardingViewActive = false
                                        } else {
                                            buttonOffset = 0
                                        }//: IF/ELSE
                                    }//: withAnimation
                                }//: onEnded

        Con esta propiedad de animacion le decimos al programa que tipo de animacion debe ejecutar cuando el View's body is computing the screen transaction. 
        Con esto le decimos al programa que ejecute esta animacion al momento de cambiar de pantalla. El tipo de animación es una aparicion de la segunda pantalla un con movimiento de desvanecimiento para que no aparezca de golpe.
        
## Animación de los anillos atras de la imagen

- Para esto nos vamos a la vista CircleGroupView

- Creamos una variable igual de tipo booleano:
    @State var isAnimating: Bool = false
    
- Despues nos vamos al final del ZSTACK y agregamos los siguientes modificadores
        .blur(radius: isAnimating ? 0 : 10)
        .opacity(isAnimating ? 1 : 0)
        .scaleEffect(isAnimating ? 1 : 0.5)
        .animation(.easeOut(duration: 1), value: isAnimating)
        .onAppear(perform: {
            isAnimating = true
        })
    Con este código se va a animar borroso con efecto de escala, digamos que aparece primero borroso y pequeño y al recorrer el 1 segundo se hace del tamaño normal y mas nítido.
    
## Animación constante

- Aqui vamos a hacer una animación a la monita de HomeView y que esté todo el tiempo moviendose

- Para ello creamos una variable dentro de homeview que almacene el estado de la animación
    @State private var isAnimating: Bool = false
    
- Con unas especificas instrucciones le podemos decir al programa que atributos queremos animar y por cuanto timepo; para ello le agregamos unos modificadores a la Image de la monita:
                .offset(y: isAnimating ? 35 : -35)
                .animation(
                    .easeInOut(duration: 4)
                        .repeatForever(),
                    value: isAnimating
                )
            Con esto movemos la imagen arriba 35 puntos y abajo 35 puntos con un ligero movimiento que va a durar 4 segundos y con el .repeatForever() la animacion no se va a detener
            
- Ahora solo nos falta activar esta animacíon, lo podemos hacer con el onAppear pero podemos usar otras herramientas para activar la animación, una de esas opciones es activar el booleano por alguna interacción que el usuario realice. La otra opción es usar algun tipo de tiempo.

- Para ello agregaremos unos modificadores al final del VSTACK principal. Utilizamos otra vez el onAppear pero a esto lepodemos agregar una caracteristica que podría ser una fecha exacta con hora, una notificación, etc. En nuestro caso vamos a retrazar la ejecución de la animación usando el tiempo cuando la vista aparezca:
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                isAnimating = true
            })
        })
    Primeramente, para que ocurra este retraso necesitamos usar el no se que principal de la aplicación.
    El DipatchQueue es responsable de ejecutar cualquier actividad del usuario o del sistema de cualuquier aplicacion en el dispositivo. Y estas actividades pueden ser en tiempo real o en segundo plano.
    Como queremos que se retrase la animación cuando la aplicación esté activa, entonces tenemos que poner el hilo principal con la palabra ".main" y luego en la tercer parte del codigo (.asynAfter) le estamos diciendo al programa que ejecute lo que tenga dentro de los bloques 3 segundos despues.
    
    Y así es como podemos programar cierta tarea en un timpo especifico en el hilo principal de la aplicación
    
- Cuando ejecutamos vemos que se tarda 3 segundos en empezar a moverse como si estuviera levitando la monita, pero es mucho tiempo, entonces le bajamos a 0.5 segundos

## Animación para regresar a la pantalla de onBoarding

- Para esto nos vamos a la accion del botón y ahi envolvemos la accion que ya estaba en un withAnimation como en la animación del cambio de pantalla anterior:
            Button(action: {
                withAnimation {
                    isOnBoardingViewActive = true
                }
            }) 
        Como no especificamos ningun tipo de animación, SwiftUI ejecutará la animación por default



