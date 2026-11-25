# Resultados · FC-LAB-002

**Ejecución:** 2026-11-25 18:25:37 UTC · Kali 2026.2 · resolvedor 1.1.1.1 · script `scripts/kali/lab02.sh`.
**Dominio:** `zonetransfer.me`, publicado por DigiNinja (Robin Wood) para practicar reconocimiento DNS. Su configuración
insegura es intencional, así que los hallazgos documentan cómo se ve el problema; los datos de contacto que aparecen en
la zona son ficticios. Integridad de los archivos comprobada con `lab02.sha256` (todos `OK`).

## Resumen

| Caso | Resultado observado | Evidencia (ID) | Hallazgo | Severidad | Estado |
|---|---|---|---|---|---|
| CP-002-01 | Inventario obtenido con `dig` y `nslookup`: 1 registro A, 7 MX (Google), 2 NS, 1 TXT, 1 SOA; sin AAAA ni CAA. Dos ejecuciones idénticas salvo el TTL | EV-002-01-01 a 05 | — | — | Cumplido |
| CP-002-02 | **Transferencia de zona permitida** en los dos servidores autoritativos (`nsztm1` y `nsztm2.digi.ninja`): 53 registros cada uno | EV-002-02-01, 02 | H-002-01 | 12 · Crítico | No cumple el control |
| CP-002-03 | 31 nombres y 17 registros TXT/HINFO/LOC/RP/CNAME que revelan información | EV-002-03-01, 02 | H-002-02 | 6 · Medio | Cumplido (exposición documentada) |

## CP-002-01 · Inventario público

| Tipo | Valor |
|---|---|
| A | 167.172.5.31 (sin registro PTR inverso) |
| MX | ASPMX.L.GOOGLE.COM (0), ALT1/ALT2 (10), ASPMX2–5.GOOGLEMAIL.COM (20) → correo alojado en Google |
| NS | nsztm1.digi.ninja, nsztm2.digi.ninja |
| TXT | google-site-verification=… |
| SOA | nsztm1.digi.ninja · responsable robin.digi.ninja · serial 2019100801 |

**Reproducibilidad.** La primera comparación marcó diferencias, pero solo eran los TTL (7200→7199 y 301→300), que el
resolvedor descuenta en cada consulta. Sin la columna TTL ambas ejecuciones son idénticas. El script se corrigió para
ignorar el TTL al comparar.

## CP-002-02 · Transferencia de zona

```text
== Servidor nsztm1.digi.ninja.
;; SERVER: 81.4.108.41#53(nsztm1.digi.ninja.) (TCP)
;; XFR size: 53 records (messages 1, bytes 3409)
== Servidor nsztm2.digi.ninja.
;; SERVER: 5.196.105.10#53(nsztm2.digi.ninja.) (TCP)
;; XFR size: 53 records (messages 1, bytes 3409)
```

Cualquier equipo de Internet puede descargar la zona completa. El criterio de aceptación («AXFR denegada») **no se
cumple**. Composición de la zona: 26 A, 24 TXT, 14 MX, 8 NS, 4 SOA, 4 NAPTR, 4 CNAME, 4 AFSDB, 4 AAAA, 2 SRV, 2 RP,
2 PTR, 2 LOC, 2 HINFO, 2 DNSKEY y 2 CERT (conteo sobre ambos servidores).

## CP-002-03 · Información expuesta

| Registro | Qué revela | Por qué importa |
|---|---|---|
| `vpn`, `owa`, `office`, `dc-office`, `canberra-office` (A) | Servicios de acceso remoto, correo web y oficinas con sus IP | Mapa de objetivos para un atacante |
| `intns1`, `intns2` (A) | Servidores de nombres «internos» publicados en la zona pública | Revela infraestructura que no debería verse |
| `staging`, `testing` (CNAME) | Entornos de prueba | Suelen tener controles más débiles |
| `contact` (TXT), `rp` (RP) | Nombre, teléfono y correo de un responsable | Insumo para ingeniería social (ver FC-LAB-005) |
| `zonetransfer.me` (HINFO) | «Casio fx-700G» / «Windows XP» | Declara hardware y un sistema operativo sin soporte |
| `dr` (LOC) | Coordenadas geográficas | Ubicación física de un sitio |
| `sqli`, `xss`, `sshock`, `cmdexec` (TXT) | Cadenas de ataque guardadas en DNS | Pueden afectar a aplicaciones que muestren registros DNS sin validar |

## Hallazgos

| ID | Descripción | Referencia | P | I | S | Recomendación |
|---|---|---|---|---|---|---|
| H-002-01 | Transferencia de zona (AXFR) abierta en ambos servidores autoritativos: expone los 53 registros, incluidos hosts internos, VPN y correo web | MITRE ATT&CK T1590.002 · CWE-200 | 4 | 3 | 12 · Crítico | Limitar `allow-transfer` a los secundarios autorizados y autenticar las transferencias con TSIG |
| H-002-02 | Registros TXT, RP, HINFO y LOC publican contactos, sistema operativo, ubicación y nombres de entornos de prueba | ATT&CK T1589 / T1590 · CWE-200 | 3 | 2 | 6 · Medio | Retirar registros informativos innecesarios y separar la vista DNS interna de la externa (split-horizon) |

## Conclusión

El laboratorio cumple su objetivo formativo: muestra un inventario reproducible (CP-002-01) y el caso de una
transferencia de zona abierta (CP-002-02), que en un dominio real sería un hallazgo crítico. Como el dominio pertenece a
un tercero que lo mantiene inseguro a propósito, no hay re-test: las acciones de mitigación quedan como recomendaciones.
Para cerrar el ciclo completo, repetir CP-002-02 contra un dominio propio y comprobar `Transfer failed`.
