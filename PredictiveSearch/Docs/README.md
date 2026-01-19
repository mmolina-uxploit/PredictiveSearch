# Documentación Conceptual del Proyecto

Esta carpeta contiene la documentación conceptual y arquitectónica del proyecto `PredictiveSearch`.

El propósito de estos documentos no es describir el código línea por línea, sino **explicar las ideas, decisiones y principios que gobiernan su diseño**, especialmente en torno a **concurrencia, cancelación y flujo determinista de estado**.

---

## Contenido

Los documentos clave que estructuran el proyecto son:

- [**ARCHITECTURE.md**](ARCHITECTURE.md)  
  Describe las decisiones arquitectónicas del sistema, detallando su implementación del patrón **Clean Architecture** adaptado a concurrencia y UX. Explica los principios de diseño de estado y concurrencia, los **trade-offs** asumidos y responde al **por qué** el sistema está construido de esta manera.

- [**TDD-AND-STATE-DRIVEN-DESIGN.md**](TDD-AND-STATE-DRIVEN-DESIGN.md)  
  Explica el rol del **Desarrollo Guiado por Pruebas (TDD)** no solo como herramienta de validación, sino como **mecanismo de diseño** en una arquitectura guiada por estado y concurrencia. Muestra cómo los tests influyeron directamente en la forma del dominio (`SearchQuery`, `SearchResult`) y sus APIs.

