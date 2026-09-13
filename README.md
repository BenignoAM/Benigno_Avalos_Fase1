# Benigno_Avalos_Fase1

# Práctica 2: Exploración del Editor y Núcleo de Godot 4
**Alumno:** Benigno Avalos Montoya  
**Materia:** Programación de Videojuegos / Programación 3D  
**Profesor:** José Luis David Bonilla Carranza  

## Respuestas a Preguntas Guía

### 1. ¿Qué diferencia observas entre un nodo y una escena?
Un nodo es el bloque de construcción básico e indivisible dentro de Godot que cumple una función especializada única (por ejemplo, un `Sprite2D` para renderizar imágenes, un `Area2D` para detectar colisiones o un `Camera2D` para enfocar la vista). Por otro lado, una escena es un árbol estructurado de nodos organizados jerárquicamente que resuelven una entidad completa y funcional. La escena puede guardarse como archivo `.tscn` para instanciarse tantas veces como sea necesario.

### 2. ¿Por qué es importante la jerarquía de nodos (qué hijo depende de qué padre)?
La jerarquía determina la herencia de transformaciones espaciales (posición, escala, rotación) y el orden de renderizado. En mi proyecto, los nodos `Frente`, `Dorso` y `CollisionShape2D` son hijos directos del nodo raíz `Carta`. Si muevo o escalo el nodo padre durante las animaciones de zoom, todos los nodos hijos heredan automáticamente esas transformaciones sin romperse ni desalinearse.

### 3. ¿Cómo se relaciona el Inspector con el Viewport?
El Viewport es el lienzo visual interactivo donde organizo y observo espacialmente los elementos 2D en tiempo real, mientras que el Inspector es el panel de control paramétrico donde configuro con precisión matemática las propiedades subyacentes del nodo seleccionado (como coordenadas exactas de `Transform`, texturas asignadas, filtros y variables expuestas).

### 4. ¿Qué ventajas tiene crear escenas reutilizables (como el planeta / la carta)?
Permite modularidad y eficiencia de memoria. En lugar de crear a mano 20 cartas en el árbol principal, diseñé una única escena modular (`carta.tscn`) con sus propias animaciones y lógica encapsulada. Desde el script principal (`main.gd`), simplemente instancio 20 copias dinámicas en un bucle, inyectando diferentes identificadores y texturas en tiempo de ejecución.

## Creatividad Adicional Implementada (+10%)
* Animaciones dinámicas programadas mediante la clase `Tween` (efecto de reparto, zoom central, vibración/shake en fallos y desplazamiento de aciertos).
* Normalización matemática de escala para admitir imágenes con resoluciones y proporciones variadas.
* Efecto visual de confeti con `CPUParticles2D` y diseño de interfaz adaptable mediante anclas (Anchors Presets).
