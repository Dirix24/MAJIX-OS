# MAJIX OS Developer

<img src="developer/wallpaper.jpg" alt="Emblema hexagonal de MAJIX OS con una M neón cian y violeta" width="420">

**MAJIX OS Developer 0.1 Alpha** · **Portable Technology OS**

**Programa. Diseña. Investiga. Construye.**

MAJIX OS es una estación de desarrollo portátil para equipos AMD64. Arranca desde una ISO o una memoria USB y reúne un escritorio en español, herramientas de programación y una aplicación para decidir dónde guardar cada proyecto.

El proyecto toma de **Tails** la idea de llevar el sistema en un USB y de **Fedora Workstation** y **Pop!_OS** la atención al escritorio de trabajo. De **Kali Linux** toma la idea de reunir herramientas para un propósito concreto. Aquí el foco es la programación y el trabajo tecnológico. La base es **Debian 13**, con sus paquetes y el gestor APT.

## Qué incluye

| Área | Disponible en la alfa |
| --- | --- |
| Escritorio | KDE Plasma en español, Wayland y XWayland, fondo con la M neón e identidad propia en **Acerca de este sistema**. |
| Desarrollo | Git, Python con entornos virtuales, Node.js, compilación C/C++ y ripgrep. |
| Aplicaciones | Kate para editar código, Konsole para la terminal, Dolphin para archivos y Firefox ESR para navegar. |
| Sistema | NetworkManager para la red, PipeWire para el sonido y Plymouth para la animación de arranque. |
| Proyectos | **MAJIX Studio** crea proyectos y copia varios archivos al destino que elijas. |

## Qué hay en el código actual

- Centro de control con versión, procesador, memoria, espacio libre, temperaturas y persistencia. Los perfiles tecnológicos abren Konsole para revisar y confirmar la instalación mediante APT.
- Studio abre proyectos existentes y realiza las operaciones de guardado en segundo plano.
- ZRAM dimensionada según la memoria y límites de uso del registro del sistema.
- Paquete DEB de aplicaciones MAJIX, canales APT firmados y un comando de actualización de componentes. La [guía de desarrollo y recuperación](docs/portable-foundation.md) explica la configuración pendiente y las pruebas.

## Descargar y arrancar

1. Abre el [flujo de compilación en GitHub Actions](https://github.com/Dirix24/MAJIX-OS/actions/workflows/live.yml), selecciona una ejecución exitosa de `main` y descarga el artefacto `majix-os-0.1-alpha-amd64`. La página de la ejecución indica el commit exacto de la imagen.
2. Extrae el ZIP y ejecuta `sha256sum -c SHA256SUMS` en la carpeta extraída para verificar la ISO.
3. Para una primera prueba, monta la ISO como unidad óptica en una máquina virtual AMD64 y selecciona **Live system**. Para usar la alfa en UEFI, Secure Boot debe estar desactivado.
4. Grabar la ISO en el disco USB completo sustituye la tabla de particiones y los datos anteriores. Guarda una copia de `MAJIX_DATA` en otro disco si quieres conservar su contenido. Una ISO recién grabada requiere un volumen de persistencia preparado para guardar cambios.
5. Si usas el USB preparado con las particiones `MAJIXUSB` y `MAJIX_DATA`, arranca desde ese medio. El modo predeterminado intenta activar la persistencia. La [guía de persistencia](docs/persistencia.md) explica cómo preparar la partición de datos.

## Guardar proyectos con MAJIX Studio

Abre **MAJIX Studio** desde el lanzador. Escribe un nombre de carpeta, selecciona una plantilla de **Python**, **JavaScript** o **C** y pulsa **Crear proyecto**. Para transferir varios archivos, elige el destino y usa **Copiar varios archivos**. Studio abre la carpeta que acaba de crear. También ofrece accesos a Terminal, Editor y Archivos.

| Destino en Studio | Dónde termina tu trabajo |
| --- | --- |
| **USB de MAJIX** | En `MAJIXProjects`, dentro de la partición `MAJIX_DATA` del propio USB de arranque. |
| **Dispositivo conectado** | En otra memoria o unidad extraíble escribible que selecciones. Pulsa **Actualizar unidades** después de conectarla. |

## Qué ocurre al reiniciar

- **Guardado completo.** Con `MAJIX_DATA` preparada y `/ union` en `persistence.conf`, el modo predeterminado conserva archivos, ajustes y paquetes instalados durante la sesión.
- **Sesión temporal.** Los cambios del sistema se descartan al reiniciar. Los archivos que hayas guardado explícitamente en `MAJIXProjects` o en otra unidad escribible se conservan.
- **ISO sin volumen persistente.** La sesión usa almacenamiento temporal. Plasma muestra una advertencia en cada inicio de sesión sin persistencia completa. Consulta el estado con MAJIX Control Center o `majix-storage`.

El USB portátil preparado inicia sesión automáticamente y su partición ext4 funciona sin contraseña. **Los datos de esa partición quedan sin cifrar.** [Guía de almacenamiento](docs/persistencia.md)

## Resultados históricos de la alfa

| Comprobación | Estado |
| --- | --- |
| ISO y arranque | SHA-256, entradas BIOS y UEFI, inicio Live y animación comprobados en GitHub Actions y QEMU. |
| Persistencia | En QEMU se guardó un archivo en la capa ext4 y se recuperó en el siguiente arranque. También se verificó la escritura en la partición física del USB desde el sistema anfitrión. |
| MAJIX Studio | Creación de proyectos, copia múltiple y botones probados con destinos simulados. |
| Equipos físicos | Queda verificar el reinicio con persistencia en la edición portátil y ampliar las pruebas de hardware, red, sonido y apagado. |
| Instalador Johnny | Previsto en la hoja de ruta. La alfa se distribuye como sistema Live. |

La [especificación completa](docs/especificacion.md) recoge la arquitectura y la [hoja de ruta](docs/especificacion.md#24-hoja-de-ruta) para avanzar hacia una versión estable y ampliar el entorno a electrónica, automatización y otros perfiles tecnológicos.

## Compilar la ISO

Desde la raíz del repositorio, en Debian 13 AMD64:

```bash
sudo apt-get update
sudo apt-get install live-build ca-certificates rsync
sudo bash build-live.sh dist
```

La ISO y su archivo `SHA256SUMS` quedan en `dist/`. El repositorio contiene el [generador de la ISO](build-live.sh), el [código de Studio](developer/majix-studio) y las [pruebas de arranque y almacenamiento](tests/).

## Autoría y licencia

La idea y la dirección del proyecto son de **Dirix24**, que aportó el emblema neón usado en esta página. La implementación y la documentación de la alfa se desarrollaron principalmente con **IA generativa (Codex)** a partir de sus indicaciones.

Los archivos propios de MAJIX OS se distribuyen bajo la [GNU GPL v3 (GPL-3.0-only)](LICENSE). Los componentes de terceros conservan sus respectivas licencias.
