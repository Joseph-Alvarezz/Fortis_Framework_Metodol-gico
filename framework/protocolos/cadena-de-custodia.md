# Protocolo de cadena de custodia

1. **Obtención:** quien obtiene la evidencia la guarda sin modificar en `evidencias/originales/` (excluida de Git).
2. **Hash:** se calcula el SHA-256 al momento de la captura con `scripts/registrar_evidencia.py`, que agrega la fila al
   anexo C con fecha UTC, caso, descripción, autor y custodio.
3. **Copia de trabajo:** el análisis se hace sobre una copia; el original no se toca.
4. **Anonimización:** solo se versiona en Git una copia sin datos personales ni secretos.
5. **Transferencia:** toda entrega a otra persona se anota en la columna «Transferencias» (fecha, de → a, motivo).
6. **Verificación:** antes de usar una evidencia en el informe se recalcula su hash con `--verificar`; si no coincide,
   la evidencia se marca como comprometida.
