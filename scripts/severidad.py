#!/usr/bin/env python3
"""Calcula la severidad de un hallazgo con la rúbrica 13.1 de FORTIS (S = P x I).

Uso:
  python scripts/severidad.py P I        # p. ej. python scripts/severidad.py 3 4
  python scripts/severidad.py --matriz   # imprime la matriz completa
"""
import sys

PROB = {1: 'Rara', 2: 'Posible', 3: 'Probable', 4: 'Casi segura'}
IMP = {1: 'Menor', 2: 'Moderado', 3: 'Mayor', 4: 'Severo'}


def nivel(s):
    if s >= 12:
        return 'Crítico'
    if s >= 8:
        return 'Alto'
    if s >= 4:
        return 'Medio'
    return 'Bajo'


def main(argv):
    if argv[:1] == ['--matriz']:
        print('P \\ I  ' + '  '.join(f'{i:>3}' for i in IMP))
        for p in sorted(PROB, reverse=True):
            print(f'{p:>5}  ' + '  '.join(f'{p * i:>3}' for i in IMP))
        return
    if len(argv) != 2 or not all(x.isdigit() and 1 <= int(x) <= 4 for x in argv):
        sys.exit(__doc__)
    p, i = map(int, argv)
    s = p * i
    print(f'P {p} ({PROB[p]}) x I {i} ({IMP[i]}) = {s} -> {nivel(s)}')
    if s >= 8:
        print('Requiere acción en el plan de mitigación (anexo D).')


if __name__ == '__main__':
    main(sys.argv[1:])
