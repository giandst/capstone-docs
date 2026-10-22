---
title: "Protocolo del lote ciego (lote C)"
estado: pendiente de ejecución
creado: 2026-10-08
---

# Protocolo del lote ciego

Este es el tercer contramedida de `evaluation-methodology.md` y **el autor del sistema no puede ejecutarlo**. Requiere una persona que no haya visto las señales. Sin este lote, la evaluación demuestra el mecanismo pero no tiene peso evidencial: la pregunta del panel —*"usted construyó los datos para que calzaran con sus reglas"*— queda sin respuesta.

## Por qué los lotes A y B no bastan

| Lote | Autoría | Qué demuestra |
|---|---|---|
| **A** — `datasets/demo/` | El autor, conociendo las señales | Que el motor ejecuta la definición declarada. Es una verificación de mecanismo, no una medición de detección. |
| **B** — `lote-b-derivacion.csv` | El autor, derivando de la ley | Separación **de fuente**: los casos salen de los elementos típicos del delito, no del catálogo de señales. Pero el autor ya conocía las señales, así que la separación **no es de ignorancia**. |
| **C** — este | Un tercero que no vio las señales | Separación real. Es el único número reportable como capacidad de detección. |

## Qué se le entrega al tercero

1. El esquema de columnas: `lote-c-ciego-PLANTILLA.csv`.
2. La descripción legal del delito, y nada más que eso:

   > **Corrupción entre particulares — CP art. 287 bis / 287 ter (Ley 21.121).**
   > El art. 287 bis castiga al empleado o mandatario que solicitare o aceptare recibir un beneficio económico o de otra naturaleza, para sí o un tercero, para favorecer o por haber favorecido en el ejercicio de sus labores **la contratación con un oferente sobre otro**. El art. 287 ter castiga a quien diere, ofreciere o consintiere en dar ese beneficio con la misma finalidad.
   >
   > En el modelo de la plataforma: el **solicitante** es el empleado que decide la compra (287 bis) y el **proveedor** es el oferente que paga por ser preferido (287 ter).

3. La instrucción: *plante entre 10 y 20 filas de compras. Algunas deben representar esta conducta y otras deben ser compras legítimas. Registre en el ground truth cuáles son cuáles y por qué.*
4. `lote-c-ground-truth-PLANTILLA.json` para que registre sus etiquetas.

## Qué se le retiene

**No se le muestra, por ningún medio:**

- el catálogo de señales (`senales-catalog.md`),
- los pesos y los umbrales del control,
- la definición sembrada (`packages/db/src/seed/mpd.ts`),
- los lotes A y B ni sus ground truths,
- el código de los detectores (`packages/api/src/motor/senales.ts`).

Si el tercero ve cualquiera de estos, el lote deja de ser ciego y hay que repetirlo con otra persona.

## Orden de ejecución, que es parte del método

1. El tercero planta las filas y completa `rol`, `es_conducta_tipica` y `conducta`.
2. El tercero firma la declaración del ground truth.
3. **Solo entonces** el autor ejecuta `bun run datasets/evaluacion/harness.ts lote-c-ground-truth.json`.
4. El autor completa `cubierta_por_diseno` **después** de medir, y deja registrado que lo completó después.

Invertir el orden —mirar las filas, ajustar una señal o un umbral, y medir después— produce exactamente la circularidad que este lote existe para romper. Si ocurre, hay que decirlo en la tesis.

## Qué se reporta

Los tres lotes van **por separado** en el capítulo de evaluación, nunca promediados. El lote C es el que se presenta como medición de capacidad de detección; A y B se presentan como lo que son.

Si el lote C no se alcanza a ejecutar antes del Informe Final, **eso se declara** como limitación del trabajo, con los lotes A y B reportados por su valor real. Una limitación declarada es defendible; un número presentado como más fuerte de lo que es, no.
