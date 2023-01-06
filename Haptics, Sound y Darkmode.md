#  DarkMode, Sound Effect and Haptics

## Darkmode

Para entender primero lo que vaos a hacer, al correr la app, el status bar donde viene la hora, la pila y la señal, aparecen en color negro. Pero si cambiamos el simulador a modo obscuro (SHIFT + COMMAND + A) las letras se vuelven de color blanco.

- Primero cambiamos el modo de presentación con un modificado antes de cerrar el bloque Body:
 
         .preferredColorScheme(.dark)
         
    Con este modificador le estamos diciendo al programa que tenga siempre modo obscuro esta vista/ventana. Ahora al correr nuestro programa en el simulador ya aparecerán las letras de la barra en blanco.
    
## Efecto de Sonido

- Primero crea un archivo nuevo de tipo swift, en el repositorio utilities (o puede ser donde sea) con el nombre AudioPlayer

- Despues importa la libreria "import AVFoundation"
    AVFoundation is a full-featured framework for working with time based audiovisual media on iOS, macOS, watchOS and TVOS. We can easily play, create and edit movies, sound files and build powerful media functionality into any apps using this framework.
    
- DEspues de importar ingresas el siguiente codigo:
    import Foundation
    import AVFoundation

    var audioPlayer: AVAudioPlayer?

    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type){
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            }catch {
                print("No se pudo reproducir sonido")
            }
        }
    }
    Con esto podemos mandar a llamar la funcion para reproducir cualquier sonido
    
- Despues regresamos a la pantalla onBoarding y nos posicionamos en el DragGesture en el metodo onEnded que es donde se va a activar el sonido:
                                playSound(sound: "chimeup", type: "mp3")
                                
- Despues abrimos la vista Home, ahi agrgamos otro sonido al pulsar el boton "Restart", entonces ahi en la acción del boton activamos que reproduzca el sonido:
                    playSound(sound: "success", type: "m4a")
                    
## Haptic Feddback (Vibración)

La háptica involucra el sentido del tacto de las personas para mejorar la experiencia de interacción con interfaz en pantalla. Podemos reproducir varios tipos de hápticos además de la retroalimentación visual y auditiva, para mejorar el tacto, gestos o alternar un interruptor. Además de eso, podemos usarlo para resaltar, negar o confirmar cualquier otra interacción del usuario.
###La haptica se refiere a la vibración del sistema.

- Regresa a la vista onBoarding y ahi creamos una nueva propiedad que se ajustará al prototipo del generador de retroalimentación háptica.
                let hapticFeedback = UINotificationFeedbackGenerator()
                
- Despues nos vamos al metodo onEnded y agregamos el siguiente código dentro del if:
                        hapticFeedback.notificationOccurred(.success)
                        
- Despues en el else agregamos el siguiente codigo:
                        hapticFeedback.notificationOccurred(.warning)

La unica forma de probar los haptics son en un dispoditivo físico, y debe estar prendida en los ajustes la opcion systme haptics
