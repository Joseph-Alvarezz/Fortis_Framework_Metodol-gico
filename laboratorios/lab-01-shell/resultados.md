# Resultados · FC-LAB-001

**Ejecución:** 2026-11-25 18:10:51 UTC · usuario `kali` en máquina virtual VirtualBox · script `scripts/kali/lab01.sh`.
Integridad de los archivos generados comprobada con `lab01.sha256` (todos `OK`).

## Resumen

| Caso | Resultado observado | Evidencia (ID) | Hallazgo | Severidad | Estado |
|---|---|---|---|---|---|
| CP-001-01 | No ejecutado: se usó la imagen preconstruida de VirtualBox y no se conservó el archivo descargado para verificar su SHA-256 | — | — | — | Pendiente |
| CP-001-02 | Entorno documentado: Kali Rolling 2026.2, kernel 6.19.14, 2 CPU, 1.9 GiB RAM, disco 79 GB (23 % usado), red NAT 10.0.2.15/24, DNS 8.8.8.8 | EV-001-02-01, EV-001-02-02 | H-001-01, H-001-02 | 4 · Medio | Cumplido |
| CP-001-03 | 26 comandos ejecutados y registrados en bitácora; la alteración de `app.log` fue detectada por `sha256sum -c` (`FAILED`) | EV-001-03-01 a EV-001-03-05 | — | — | Cumplido |

## Observaciones del entorno (CP-001-02)

| Aspecto | Observado | Valoración |
|---|---|---|
| Sistema | Kali GNU/Linux Rolling 2026.2, kernel 6.19.14+kali-amd64 | Correcto |
| Red | NAT (10.0.2.15/24, puerta de enlace 10.0.2.2); interfaz `docker0` inactiva | Correcto: la VM no se expone a la red local |
| Servicios en escucha | Solo `127.0.0.1:40883` (local) | Correcto: ningún servicio expuesto |
| SSH | `inactive` | Correcto: superficie de ataque reducida |
| Actualizaciones | 1684 paquetes sin actualizar (p. ej. `coreutils` 9.10-1 instalado, 9.12-0.3 disponible) | **Hallazgo H-001-01** |
| Usuario | `kali` pertenece a `sudo`, `docker`, `wireshark` y `vboxsf` | **Hallazgo H-001-02** |
| umask | `0002` (archivos nuevos escribibles por el grupo) | Recomendación: `027` en equipos de evaluación |

## Prueba de integridad (CP-001-03)

```text
$ sha256sum -c demo/lista.sha256
demo/docs/informe.txt: OK
demo/logs/app.log: OK
$ echo 'alterado' >> demo/logs/app.log; sha256sum -c demo/lista.sha256
demo/docs/informe.txt: OK
demo/logs/app.log: FAILED
sha256sum: WARNING: 1 computed checksum did NOT match
```

La verificación por hash detecta la modificación de un solo renglón. Es el mismo control que usa el custodio de
evidencias con `scripts/registrar_evidencia.py --verificar`.

## Hallazgos

| ID | Descripción | P | I | S | Recomendación |
|---|---|---|---|---|---|
| H-001-01 | El sistema de evaluación tiene 1684 paquetes desactualizados; las herramientas pueden tener fallas corregidas en versiones posteriores | 2 | 2 | 4 · Medio | `sudo apt full-upgrade` antes de cada ciclo y registrar la versión en la ficha de entorno |
| H-001-02 | El usuario pertenece al grupo `docker`, que equivale a privilegios de administrador sin pedir contraseña | 1 | 3 | 3 · Bajo | Aceptable en una VM aislada de laboratorio; en equipos compartidos usar `sudo docker` o Docker sin root |

## Conclusión

El entorno es reproducible y cumple el criterio de aceptación de CP-001-02 y CP-001-03. Queda pendiente CP-001-01:
en el próximo ciclo, conservar el archivo `.7z` de la imagen y comparar su SHA-256 con el publicado en kali.org.
