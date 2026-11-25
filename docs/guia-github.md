# Guía de GitHub (anexo E)

## Flujo de trabajo
`main` contiene solo versiones revisadas. Todo cambio se hace en una rama temporal y se integra por Pull Request.

```bash
git switch -c feature/lab-08
git add laboratorios/lab-08-deteccion/
git commit -m "feat(lab-08): agrega ficha y procedimiento"
git push -u origin feature/lab-08
```

## Protección de main
En *Settings → Branches → Add rule* para `main`: exigir Pull Request con una revisión aprobada, impedir force-push y
exigir que la rama esté actualizada. Activar *Secret scanning* y *Push protection* en *Settings → Code security*.

## Convención de commits
`feat` nuevo laboratorio o funcionalidad · `fix` corrección · `docs` documentación · `refactor` reorganización ·
`chore` mantenimiento.

## Versionado
```bash
git tag -a v0.3.0 -m "FORTIS v0.3.0: caso piloto Juice Shop"
git push origin v0.3.0
```
