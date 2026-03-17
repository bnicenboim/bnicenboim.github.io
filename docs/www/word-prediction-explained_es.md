---
title: "Duelo de Palabras"
format:
  html:
    toc: false
    navbar: false
    page-layout: article
    theme:
      - cosmo
      - brand
    css: word-prediction-explained.css
    include-in-header:
      text: |
        <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><defs><linearGradient id='g' x1='0' y1='0' x2='1' y2='1'><stop offset='0' stop-color='%23667eea'/><stop offset='1' stop-color='%23764ba2'/></linearGradient></defs><rect width='100' height='100' rx='20' fill='url(%23g)'/><text x='50' y='68' font-size='62' text-anchor='middle' font-family='system-ui,sans-serif'>💬</text><text x='68' y='52' font-size='28' text-anchor='middle' font-family='system-ui,sans-serif' font-weight='bold' fill='white'>?</text></svg>">
lang: es
---

**[Jugar](word-prediction.html?lang=es)**

## De qué se trata

Se ve el comienzo de una oración y hay que adivinar la siguiente palabra oculta antes que los demás. Nada más. Pero hay algo sorprendente detrás de este juego tan simple: **predecir la siguiente palabra es algo que el cerebro hace automáticamente, todo el tiempo, sin que uno se dé cuenta.**

---

## El cerebro siempre va un paso adelante

¿Cómo sigue esta oración?

> <em>Se puso el abrigo, agarró las llaves y salió por la ___.</em>

Seguramente tu primera intuición fue _puerta_. Sin pensarlo mucho. Algo en el cerebro simplemente... lo sabía.

Ahora esta:

> <em>La investigadora publicó sus resultados en una revista ___.</em>

_Científica_, probablemente. O quizás _académica_.

> <em>Pidió un café y una ___.</em>

_¿Medialuna? ¿Factura? ¿Tostada?_ Es más difícil. Hay varias palabras que van igual de bien.

Esa diferencia importa: **algunas palabras son mucho más fáciles de predecir que otras.** Las predecibles se sienten casi inevitables. Las impredecibles pueden ir para cualquier lado. El juego hace esto visible. Algunas palabras se adivinan al primer intento, otras son muy difíciles.

---

## ¿Cómo sabemos que el cerebro predice?

Uno no puede _sentir_ a su cerebro haciendo predicciones. Es demasiado rápido, demasiado automático. Pero los científicos tienen maneras de detectarlo.

Una forma es seguir los ojos de las personas mientras leen. Los ojos no se deslizan suavemente por la página. Van saltando de palabra en palabra. Y resulta que pasan menos tiempo en las palabras más predecibles, a veces las saltean por completo. Y se demoran más en las sorpresivas. El cerebro ya tenía una buena idea de lo que venía, así que no necesitaba mirar con tanto cuidado.

También hay una forma más directa. El cerebro funciona con electricidad: miles de millones de neuronas se comunican mediante pequeñas descargas de actividad eléctrica. Todas esas señales se suman, y parte de esa actividad llega a la superficie de la cabeza. Colocando pequeños sensores en el cuero cabelludo (una técnica llamada EEG, por electroencefalografía), se pueden captar esas señales mientras una persona lee. Parece una gorra cubierta de cables, y lo que registra es una especie de resumen de lo que millones de neuronas están haciendo en cada momento. Cuando aparece una palabra inesperada, la respuesta eléctrica cambia. Cuanto más sorpresiva la palabra, más grande el cambio. Como si el cerebro dijera: "Un momento, eso no es lo que esperaba."

---

## El contexto es todo

¿Qué pasa cuando se agrega más contexto?

> <em>Pidió un café y una ___.</em>

Es bastante difícil. Pero:

> <em>Era su cumpleaños. Pidió un café y una ___.</em>

Ahora _torta_ es la continuación obvia.

A medida que se avanza en la oración, se vuelve más fácil adivinar. El cerebro usa todo lo que tiene a mano: las palabras que ya se dijeron, lo que tiene sentido en el mundo real, lo que la gente suele decir en ese tipo de situaciones. Más contexto significa menos opciones posibles.

Lo mismo ocurre al escuchar. Uno empieza a procesar lo que alguien dice antes de que termine la oración. En una conversación, muchas veces empezamos a armar nuestra respuesta _mientras la otra persona todavía está hablando_, porque ya anticipamos hacia dónde va.

---

## ¿Qué hacen los jugadores de IA?

En el juego, la IA hace lo mismo que uno: mira las palabras reveladas hasta el momento e intenta adivinar qué sigue.

Los jugadores de IA son **grandes modelos de lenguaje**: programas entrenados con cantidades enormes de texto, libros, artículos, sitios web, conversaciones.

El entrenamiento funciona así: el modelo ve una secuencia de palabras e intenta adivinar cuál viene después. Cuando se equivoca, se ajusta un poco. Después de miles de millones de rondas, desarrolla algo parecido a una intuición sobre cómo fluye el lenguaje, qué palabras tienden a seguir a cuáles, en qué contextos. Esta tarea de predecir la palabra siguiente es, de hecho, la base de chatbots como ChatGPT. Antes de que un chatbot pueda mantener una conversación o responder preguntas, tiene que aprender los patrones del lenguaje practicando exactamente esto: predecir la palabra siguiente, una y otra vez, con cantidades enormes de texto.

¿Qué hace que un modelo sea más grande o más pequeño? Todo depende de los **parámetros**: números internos que se van ajustando durante el entrenamiento. Se pueden pensar como perillas. Cada una controla una pequeña parte de cómo el modelo responde a una palabra o un patrón. Más perillas permiten distinciones más finas y patrones más sutiles. Menos perillas dan una imagen más borrosa del lenguaje.

Los modelos de este juego son pequeños y viejos para los estándares actuales. El modelo en inglés (Pythia, de 2023) tiene unos 410 millones de parámetros. Los de holandés y español están basados en GPT-2 (de 2019) y tienen unos 125 millones cada uno. Suena como mucho, hasta que uno se entera de que los modelos más potentes de ChatGPT tienen alrededor de 1,8 _billones_ de parámetros (1,8 millones de millones), unas 4.000 veces más que Pythia. Es como comparar una bicicleta con un avión.

¿Por qué no usar los grandes? Porque los modelos de este juego tienen que funcionar _localmente_, aquí mismo en el navegador, en la computadora de cada jugador. ChatGPT funciona en servidores enormes, centros de datos llenos de hardware especializado operados por empresas como OpenAI. Los modelos de este juego son lo suficientemente pequeños para descargarse y funcionar en una computadora común o incluso en un celular.

El modelo en inglés, al ser más grande, tiende a predecir un poco mejor. Pero los modelos de holandés y español fueron entrenados con textos en sus propios idiomas, así que funcionan mucho mejor cuando la oración coincide con su lengua.

---

## Pájaros y aviones

¿Son lo mismo las mentes humanas y los modelos de lenguaje? No. Pensemos en los pájaros y los aviones. Obviamente diferentes: uno vivo, resultado de millones de años de evolución; el otro, metal diseñado por ingenieros. Pero los dos vuelan, y los dos lo logran porque aprovechan la misma física: la aerodinámica, la forma en que el aire fluye alrededor de un ala.

Estudiar aviones nos puede enseñar sobre el _medio_ en el que vuelan los pájaros. No sobre plumas o músculos, sino sobre el aire en sí, sobre lo que hace posible el vuelo.

Algo parecido pasa con los modelos de lenguaje y las mentes humanas. Están construidos de maneras completamente diferentes, pero ambos operan sobre lo mismo: **el lenguaje**. Estudiando qué encuentra predecible o sorprendente un modelo, se aprende sobre las regularidades del idioma: qué tiende a aparecer dónde, qué es común, qué es inusual. Esas mismas regularidades son las que determinan cómo nuestro cerebro procesa las palabras. De alguna manera, el puntaje del juego mide esto: quién coincide mejor con los patrones estadísticos del idioma.

Hasta dónde llega esta analogía es materia de debate. Algunos investigadores sostienen que los modelos de lenguaje son tan diferentes de los cerebros que compararlos no tiene sentido. Otros piensan que las similitudes son más profundas de lo que parece. Nadie lo resolvió todavía, y es una de las preguntas abiertas más interesantes del campo.

---

La próxima vez que completes la oración de otra persona sin pensarlo, recordá: tu cerebro viene jugando a este juego desde siempre.

---

_[Bruno Nicenboim](https://bruno.nicenboim.me/) — Ciencia Cognitiva Computacional, Universidad de Tilburg_
