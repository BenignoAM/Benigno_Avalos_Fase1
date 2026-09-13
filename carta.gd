extends Area2D

signal carta_seleccionada(carta)

var id_campeon = 0
var posicion_original = Vector2.ZERO
var cara_arriba = false
var interactuable = false
var escala_original = Vector2.ONE

@onready var sprite_frente = $Frente
@onready var sprite_dorso = $Dorso

func _ready():
	# Memoriza la escala configurada en el Inspector
	escala_original = scale

func configurar_carta(id: int, textura_frente: Texture2D):
	id_campeon = id
	sprite_frente.texture = textura_frente
	
	# Obligar a la imagen del frente a tomar el tamaño exacto del dorso
	if sprite_dorso.texture and sprite_frente.texture:
		var tamaño_dorso = sprite_dorso.texture.get_size()
		var tamaño_frente = sprite_frente.texture.get_size()
		
		# Calcula y aplica la escala perfecta
		sprite_frente.scale = tamaño_dorso / tamaño_frente

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if interactuable and not cara_arriba:
			emit_signal("carta_seleccionada", self)

func voltear():
	cara_arriba = true
	sprite_dorso.hide()
	sprite_frente.show()

func ocultar():
	cara_arriba = false
	sprite_frente.hide()
	sprite_dorso.show()

func animar_al_centro(centro_pantalla: Vector2):
	interactuable = false
	var tween = create_tween()
	tween.tween_property(self, "position", centro_pantalla, 0.4).set_trans(Tween.TRANS_CUBIC)
	# Zoom basado en su escala original
	tween.parallel().tween_property(self, "scale", escala_original * 2.0, 0.4)

func mover_a_izquierda(pos_izquierda: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", pos_izquierda, 0.3)

func animar_acierto(direccion_salida: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 30, 0.15)
	tween.tween_property(self, "position:y", position.y + 30, 0.15)
	tween.tween_property(self, "position:y", position.y, 0.1)
	tween.tween_property(self, "position", direccion_salida, 0.5).set_delay(0.2)
	tween.tween_callback(queue_free)

func animar_error():
	var tween = create_tween()
	for i in range(3):
		tween.tween_property(self, "position:x", position.x - 10, 0.05)
		tween.tween_property(self, "position:x", position.x + 10, 0.05)
	
	tween.tween_property(self, "position", posicion_original, 0.4).set_delay(0.2)
	# Regresa exactamente a su escala original
	tween.parallel().tween_property(self, "scale", escala_original, 0.4)
	tween.tween_callback(ocultar)
	tween.tween_callback(func(): interactuable = true)
