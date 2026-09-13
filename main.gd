extends Node2D

@onready var baraja_boton = $BarajaBoton
@onready var sonido_whoosh = $WhooshAudio
@onready var confeti = $Confeti
@onready var ui_victoria = $UI/Panel
@onready var btn_reiniciar = $UI/Panel/Button

const CartaEscena = preload("res://carta.tscn")

var texturas = []
var mazo = []
var carta1 = null
var carta2 = null
var pares_encontrados = 0

func _ready():
	for i in range(1, 11):
		texturas.append(load("res://imagen" + str(i) + ".jpg"))
	
	for i in range(10):
		mazo.append(i)
		mazo.append(i)
	
	mazo.shuffle()
	
	confeti.emitting = false
	ui_victoria.hide()
	
	btn_reiniciar.pressed.connect(_reiniciar_juego)
	baraja_boton.pressed.connect(_repartir_cartas)

func _repartir_cartas():
	baraja_boton.hide() 
	
	var columnas = 5
	var separacion_x = 150 
	var separacion_y = 140 
	
	var ancho_total = (columnas - 1) * separacion_x
	var alto_total = (4 - 1) * separacion_y
	var inicio_x = -ancho_total / 2.0
	var inicio_y = -alto_total / 2.0
	
	for i in range(20):
		var nueva_carta = CartaEscena.instantiate()
		add_child(nueva_carta)
		
		var id_campeon = mazo[i]
		nueva_carta.configurar_carta(id_campeon, texturas[id_campeon])
		
		nueva_carta.position = Vector2.ZERO 
		
		var col = i % columnas
		var fila = int(i / columnas) 
		
		var pos_final = Vector2(inicio_x + (col * separacion_x), inicio_y + (fila * separacion_y))
		nueva_carta.posicion_original = pos_final
		
		nueva_carta.carta_seleccionada.connect(_on_carta_seleccionada)
		
		var tween = create_tween()
		tween.tween_property(nueva_carta, "position", pos_final, 0.3)
		tween.tween_callback(func(): nueva_carta.interactuable = true)
		
		sonido_whoosh.play()
		await get_tree().create_timer(0.15).timeout

func _on_carta_seleccionada(carta_clickeada):
	var centro_x = 0
	var centro_y = 0
	
	if carta1 == null:
		carta1 = carta_clickeada
		carta1.voltear()
		carta1.z_index = 10 
		carta1.animar_al_centro(Vector2(centro_x, centro_y))
		
	elif carta2 == null and carta_clickeada != carta1:
		carta2 = carta_clickeada
		carta2.voltear()
		carta2.z_index = 10
		
		# Separación ampliada en el centro para las cartas
		var separacion = 250 
		
		carta1.mover_a_izquierda(Vector2(centro_x - separacion, centro_y))
		carta2.animar_al_centro(Vector2(centro_x + separacion, centro_y))
		
		await get_tree().create_timer(1.5).timeout
		
		if carta1.id_campeon == carta2.id_campeon:
			carta1.animar_acierto(Vector2(centro_x - separacion, -600))
			carta2.animar_acierto(Vector2(centro_x + separacion, -600))
			pares_encontrados += 1
			
			if pares_encontrados == 10:
				await get_tree().create_timer(1.0).timeout
				_ganar_juego()
		else:
			carta1.z_index = 0
			carta2.z_index = 0
			carta1.animar_error()
			carta2.animar_error()
			
		carta1 = null
		carta2 = null

func _ganar_juego():
	confeti.emitting = true
	ui_victoria.show()

func _reiniciar_juego():
	get_tree().reload_current_scene()
