#!/usr/bin/env python3
"""Registra una evidencia en el anexo C de FORTIS (SHA-256 + cadena de custodia).

Uso:
  python scripts/registrar_evidencia.py ARCHIVO --caso CP-JS-01 --desc "Descripción" --por "Analista ofensivo"
  python scripts/registrar_evidencia.py ARCHIVO --verificar      # comprueba que el hash no cambió
"""
import argparse
import csv
import hashlib
import os
import sys
from datetime import datetime, timezone

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ANEXO_C = os.path.join(RAIZ, 'framework', 'matrices', 'anexo-C-registro-evidencias.csv')
COL_ID, COL_ARCHIVO, COL_HASH = 0, 4, 5


def sha256(ruta):
    h = hashlib.sha256()
    with open(ruta, 'rb') as f:
        for bloque in iter(lambda: f.read(1 << 20), b''):
            h.update(bloque)
    return h.hexdigest()


def leer():
    with open(ANEXO_C, encoding='utf-8-sig', newline='') as f:
        return list(csv.reader(f, delimiter=';'))


def siguiente_id(filas, caso):
    # CP-JS-01 -> EV-JS-01-NN
    base = 'EV-' + caso.split('-', 1)[1] if caso.startswith('CP-') else 'EV-' + caso
    usados = [r[COL_ID] for r in filas[1:] if r and r[COL_ID].startswith(base + '-')]
    return f'{base}-{len(usados) + 1:02d}'


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('archivo')
    ap.add_argument('--caso', help='ID del caso o hallazgo, p. ej. CP-JS-01')
    ap.add_argument('--desc', default='', help='Descripción y tipo de la evidencia')
    ap.add_argument('--por', default='', help='Quién obtuvo la evidencia')
    ap.add_argument('--custodio', default='Custodio de evidencias')
    ap.add_argument('--verificar', action='store_true', help='Recalcula el hash y lo compara con el registrado')
    a = ap.parse_args()

    if not os.path.isfile(a.archivo):
        sys.exit(f'No existe el archivo: {a.archivo}')
    rel = os.path.relpath(os.path.abspath(a.archivo), RAIZ).replace(os.sep, '/')
    digest = sha256(a.archivo)
    filas = leer()

    if a.verificar:
        reg = [r for r in filas[1:] if r and r[COL_ARCHIVO] == rel]
        if not reg:
            sys.exit(f'{rel} no está registrado en el anexo C')
        ok = reg[-1][COL_HASH] == digest
        print(f'{reg[-1][COL_ID]}: {"ÍNTEGRA" if ok else "COMPROMETIDA (el hash no coincide)"}')
        sys.exit(0 if ok else 2)

    if not a.caso:
        sys.exit('Indica --caso (p. ej. CP-JS-01)')
    ev = siguiente_id(filas, a.caso)
    fecha = datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M')
    fila = [ev, fecha, a.caso, a.desc, rel, digest, a.por, a.custodio, '—']
    with open(ANEXO_C, 'a', encoding='utf-8', newline='') as f:
        csv.writer(f, delimiter=';', lineterminator='\n').writerow(fila)
    print(f'{ev} registrada\n  archivo: {rel}\n  SHA-256: {digest}')


if __name__ == '__main__':
    main()
