# Arquitectura metodológica

```mermaid
flowchart TB
  C1["Capa 1 · Gobierno, principios y referentes"]
  C2["Capa 2 · Ciclo metodológico iterativo (6 fases)"]
  C3["Capa 3 · Enfoque transversal Purple Team<br/>Red Team ⇄ Blue Team"]
  C4["Capa 4 · Dominios D01–D08"]
  C5["Capa 5 · Instrumentos y artefactos versionados"]
  C1 --> C2 --> C3 --> C4 --> C5
  T["Gestión de evidencias y trazabilidad<br/>fase ↔ dominio ↔ caso ↔ hallazgo ↔ control ↔ verificación"]
  T -.- C1 & C2 & C3 & C4 & C5
```

| Capa | Contenido |
|---|---|
| 1 · Gobierno | Principios rectores y referentes normativos |
| 2 · Ciclo | Preparación → Prevención → Identificación → Análisis → Mitigación → Verificación |
| 3 · Purple Team | Pruebas ↔ detección ↔ mejora de controles |
| 4 · Dominios | D01 a D08 (ver [metodologia.md](metodologia.md#dominios)) |
| 5 · Instrumentos | Laboratorios FC-LAB, ficha estandarizada, matrices, registro de evidencias, plan de mitigación, repositorio |
