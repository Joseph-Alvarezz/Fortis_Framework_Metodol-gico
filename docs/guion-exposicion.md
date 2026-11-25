# Guion de exposición · FORTIS

**Duración:** 12 minutos más preguntas · **Apoyo visual:** figuras de las secciones 6 y 8, tablas 12.3 y 12.4 del
documento v0.4 y las figuras C.1 a C.3.

> Las indicaciones entre corchetes son para quien expone; no se leen.

---

## 1. Apertura · 1 min

[Mirar al público, sin leer.]

Buenos días. Les quiero hacer una pregunta: si alguien copiara completo el sitio web de su empresa en dos minutos,
¿se enterarían?

En nuestro laboratorio la respuesta fue no. Hicimos exactamente eso: descargamos 148 archivos de una aplicación y el
servidor no registró ni una sola solicitud. Cero.

Ese resultado resume el problema que aborda este trabajo. Muchas organizaciones hacen pruebas de seguridad, pero las
hacen sueltas: un escaneo aquí, una práctica allá, sin un método que conecte lo que se prueba con lo que se detecta y
con lo que se corrige. Hoy les presento **FORTIS**, un framework metodológico que propone ese hilo conductor, y les
muestro qué pasó cuando lo aplicamos.

## 2. El problema · 1 min

Tres problemas concretos:

1. **Pruebas aisladas.** El equipo que ataca y el que defiende trabajan por separado; el ataque termina en un informe
   y la defensa nunca sabe si lo habría visto.
2. **Sin trazabilidad.** Un hallazgo se reporta, pero nadie verifica después que la corrección funcionó.
3. **Evidencia frágil.** Capturas sin hash ni cadena de custodia, que no resisten una revisión.

Los referentes existen: NIST CSF 2.0, SP 800-115, MITRE ATT&CK, OWASP, ISO 27001 y 27005. Lo que falta es una forma
práctica de articularlos en un procedimiento que un equipo pequeño pueda repetir.

## 3. Qué es FORTIS · 2 min

[Mostrar la figura de la arquitectura, sección 6.]

FORTIS, del latín «fuerte», organiza la evaluación en **cinco capas**:

- Arriba, el **gobierno**: los principios, empezando por el que no se negocia, la autorización expresa, y los referentes
  normativos.
- En el centro, el **ciclo de seis fases**: Preparación, Prevención, Identificación, Análisis, Mitigación y Verificación.
  Cada fase entrega un producto concreto: un plan, una línea base, hallazgos, una matriz de riesgos, un plan de
  tratamiento y un informe de efectividad.
- Luego, el enfoque **Purple Team**: el ataque y la detección ocurren al mismo tiempo, coordinados.
- Después, **ocho dominios**, desde sistemas y DNS hasta factor humano, forense y seguridad de IA.
- Y en la base, los **instrumentos**: laboratorios, matrices y un repositorio versionado.

A la derecha está la idea central: **trazabilidad**. Todo se conecta: fase, dominio, caso, hallazgo, control y verificación.

## 4. Quién hace qué · 1 min

[Mostrar el diagrama UML de la sección 8.]

Definimos siete actores con una matriz RACI. Dos detalles del diagrama:

- El **fork**: el analista ofensivo ejecuta y el defensivo monitorea **en paralelo**. Eso es Purple Team.
- La **decisión** al final: «¿la corrección fue efectiva?». Si no, se vuelve a corregir. El ciclo no se cierra con un
  informe; se cierra con una verificación.

## 5. Cómo lo aplicamos · 1 min

Lo llevamos a la práctica en una máquina virtual con Kali Linux. Construimos un repositorio en GitHub con fichas,
procedimientos y scripts. Los objetivos fueron entornos propios o de entrenamiento: OWASP Juice Shop corriendo solo en
la interfaz local, y zonetransfer.me, un dominio público creado para practicar.

Cada evidencia se registró con su hash SHA-256 en el momento de obtenerla. Al cerrar el ciclo las reverificamos: 42 de
42 estaban íntegras.

## 6. Resultados · 3 min

[Mostrar la tabla 12.3.]

Ejecutamos seis laboratorios: 17 de 24 casos, una cobertura del 71 %. Encontramos **10 hallazgos**: uno crítico, uno
alto, cinco medios y tres bajos. Tres ejemplos:

**DNS.** [Figura C.1.] El servidor DNS entregó su zona completa a cualquiera: 53 registros, incluidos la VPN, el correo
web y servidores internos. Es crítico, 12 sobre 16, porque le da a un atacante el mapa de la organización sin tocar
nada.

**Forense.** [Figura C.2.] Ocultamos un mensaje cifrado dentro de una imagen. El archivo alterado pesaba exactamente lo
mismo que el original, 230 454 bytes, y tenía los mismos metadatos. Lo único que lo delató fue el hash. Esa es la razón
por la que FORTIS exige hashes desde el primer minuto.

**Factor humano.** Clasificamos diez mensajes por cinco canales, correo, SMS, llamada, chat y en persona, con diez
aciertos de diez. Siete eran fraude, y seis de esos siete usaban el mismo truco: la autoridad.

## 7. El ciclo completo · 2 min

[Mostrar la figura C.3 y la tabla 12.4.]

Y ahora la historia del inicio, la que demuestra el framework.

Primero, **atacamos**: clonamos la aplicación. Resultado: **0 % de detección**. Lo registramos como hallazgo alto.

Segundo, **mitigamos**: pusimos un proxy que registra cada solicitud y escribimos dos reglas, una por la herramienta que
se identifica y otra por volumen, más de 60 solicitudes por minuto.

Tercero, **verificamos**: repetimos exactamente el mismo ataque. Resultado: **100 % de detección**, y cero falsas alarmas
con la navegación normal.

Ese recorrido, de hallazgo a control verificado, es lo que FORTIS propone. Y el re-test nos enseñó algo más: el límite
de velocidad que configuramos nunca se activó, porque el rastreo fue más lento que el umbral. Ese nuevo hallazgo
alimenta la siguiente iteración. El ciclo no termina, mejora.

## 8. Limitaciones y cierre · 1 min

Seamos honestos con los límites: lo ejecutó una sola persona en todos los roles, en entornos de entrenamiento, y quedan
pendientes dos laboratorios y los casos del piloto en Juice Shop. Estas cifras muestran que el método es aplicable y
trazable; no son una validación estadística.

Para cerrar, vuelvo a la pregunta del inicio. Si alguien copia su sitio, ¿se enterarían? Con FORTIS la respuesta deja
de ser una suposición: se prueba, se mide, se corrige y se vuelve a probar.

Muchas gracias. Quedo atento a sus preguntas.

---

## Preguntas probables

**¿En qué se diferencia de usar directamente NIST o ISO?**
NIST e ISO dicen *qué* lograr. FORTIS dice *cómo* llevarlo a una evaluación técnica repetible: fases con productos,
roles con RACI, matrices y un repositorio. La matriz 4.1 muestra qué toma de cada referente.

**¿Por qué la severidad es P × I y no CVSS?**
Porque es simple, se calcula en minutos y sirve también para hallazgos humanos o de proceso, donde CVSS no aplica. Para
vulnerabilidades de software, CVSS 4.0 está en las referencias como complemento.

**¿Es legal lo que hicieron?**
Sí. Todo fue sobre entornos propios o de entrenamiento: Juice Shop en la interfaz local de nuestra máquina y
zonetransfer.me, que existe para practicar. La autorización expresa es el primer principio del framework.

**¿Por qué el 71 % y no el 100 %?**
Porque dos laboratorios, Maltego y Burp, quedaron documentados pero sin ejecutar en este ciclo. Preferimos reportar
la cobertura real.

**¿La regla por herramienta no se evade fácil?**
Sí: basta cambiar el agente de usuario. Por eso la combinamos con la regla por volumen, que no depende de ese dato. Lo
dejamos documentado como limitación.

**¿Qué sigue?**
Ejecutar los laboratorios 6 y 7, los casos del piloto en Juice Shop, calibrar el límite de velocidad e integrar un SIEM
como Wazuh.

---

## Datos clave para memorizar

| Dato | Valor |
|---|---|
| Fases | 6: Preparación, Prevención, Identificación, Análisis, Mitigación, Verificación |
| Capas | 5 + barra de trazabilidad |
| Actores | 7 |
| Dominios | 8 (D01 a D08) |
| Laboratorios ejecutados | 6 (001–005 y 008) |
| Cobertura | 17 / 24 = 70,8 % |
| Hallazgos | 10: 1 crítico, 1 alto, 5 medios, 3 bajos |
| Detección de la clonación | 0 % → 100 % |
| Evidencias íntegras | 42 / 42 |
| Severidad | S = P × I · Bajo 1–3 · Medio 4–6 · Alto 8–9 · Crítico 12–16 |
