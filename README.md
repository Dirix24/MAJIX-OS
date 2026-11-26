# MAJIX OS

![Logotipo de MAJIX OS](branding/logo.png)

**MAJIX OS 0.1 Alpha** es una distribución Live para equipos AMD64, basada en Debian 13. Es una edición portátil para desarrollo con identidad propia, construida sobre Debian para conservar el ecosistema de paquetes APT. Puedes probarla desde una ISO en una máquina virtual o arrancarla desde un medio externo.

La alfa incluye KDE Plasma en español con Wayland y XWayland, red con NetworkManager, sonido con PipeWire y aplicaciones como Firefox ESR, Konsole y Kate. La animación de arranque lo gestiona Plymouth, que muestra el logotipo de MAJIX OS con un indicador animado.

## MAJIX Studio

La edición Developer incorpora Git, Python con entornos virtuales, Node.js, herramientas de compilación C/C++ y ripgrep. Desde MAJIX Studio puedes abrir Konsole, Kate y Dolphin, crear un proyecto con plantilla Python, JavaScript o C, y copiar varios archivos de una vez.

Elige **USB de MAJIX** para guardar en la partición de trabajo `MAJIXWORK` del medio de arranque, cuando esté disponible, o **Dispositivo conectado** para usar una unidad extraíble distinta. Quitar el USB de trabajo después de guardar o apagar correctamente conserva los archivos de esa unidad. La partición de trabajo es independiente de la persistencia LUKS2 y guarda archivos sin cifrado.

## Descargar y probar

1. Abre [GitHub Actions](https://github.com/Dirix24/MAJIX-OS/actions/workflows/live.yml), entra en la ejecución exitosa más reciente y descarga el artefacto **majix-os-0.1-alpha-amd64**.
2. Extrae el ZIP. Si tienes `sha256sum`, ejecuta `sha256sum -c SHA256SUMS` en la carpeta extraída para verificar la ISO.
3. Monta la ISO como unidad óptica de una máquina virtual AMD64. Para arrancar en UEFI, desactiva Secure Boot en la máquina virtual.
4. En el menú, selecciona **Live system** para usar el modo predeterminado o **MAJIX OS - Sesion temporal (sin guardar)** para una sesión desechable.

## Qué se guarda al reiniciar

**La persistencia está activada por defecto en Live system.** Para guardar cambios necesitas una memoria USB con un volumen cifrado LUKS2 preparado. La ISO contiene el sistema base y el USB recibe los cambios que hayas decidido conservar.

| Modo | Qué conserva |
| --- | --- |
| **Guardar el sistema y mis archivos** | Documentos, configuraciones y paquetes que instales durante la sesión Live. |
| **Reiniciar limpio y guardar mis archivos** | Todo lo que guardes en tu carpeta personal. El resto de los cambios de la sesión Live se descarta. |
| **Sesión temporal** | Los cambios de la sesión se guardan en memoria y se pierden al reiniciar. |

Seleccionas uno de los dos perfiles persistentes al preparar el USB. Si arrancas solo con la ISO, los cambios quedan en memoria temporal. Reiniciar no formatea ningún disco. [Guía para preparar el USB y comprobar el guardado](docs/persistencia.md).

## Comprobar dónde se guardan los cambios

Abre Konsole y ejecuta `majix-storage`. El comando consulta el almacenamiento montado en esa sesión y muestra si está activa la persistencia completa, la persistencia de la carpeta personal o la sesión temporal. Si falla el desbloqueo del USB, comprueba aquí el estado antes de guardar trabajo importante.

## Estado del proyecto

- **Disponible en la alfa:** arranque Live AMD64, KDE Plasma, animación con el logotipo y configuración de persistencia cifrada por USB.
- **Verificación:** GitHub Actions comprueba la suma de la ISO, las entradas BIOS y UEFI y el arranque Live en QEMU. La prueba de escritura y lectura en un USB cifrado después de reiniciar sigue pendiente.
- **Instalación:** Johnny, el instalador del proyecto, está previsto en la hoja de ruta. La selección entre conservar todos los cambios y conservar solo la carpeta personal se configura hoy en el USB Live.

### Criterios para una versión estable

- Arrancar desde sistemas BIOS y UEFI y llegar al escritorio en una máquina virtual y en equipos físicos AMD64.
- Verificar los perfiles completo y personal con un USB LUKS2 a través de dos arranques. Comprobar también el caso de una contraseña incorrecta y el arranque sin USB.
- Validar red, sonido, apagado y reinicio en los equipos de prueba.
- Verificar el instalador Johnny con discos virtuales y probar la recuperación antes de recomendar la instalación en equipos reales.

Consulta la [especificación y la hoja de ruta](docs/especificacion.md#24-hoja-de-ruta).

## Compilar la ISO

En Debian 13 AMD64, ejecuta desde la raíz del repositorio:

```bash
sudo apt-get update
sudo apt-get install live-build ca-certificates rsync
sudo bash build-live.sh dist
```

La compilación guarda la ISO y su suma SHA-256 en `dist/`.

## Autoría y licencia

La idea y la dirección del proyecto son de **Dirix24**. La implementación, el logotipo y la documentación de esta alfa se generaron principalmente con **IA generativa (Codex)**, a partir de sus indicaciones. Debian, KDE Plasma y los demás componentes de terceros proceden de sus respectivos proyectos.

Los archivos propios de MAJIX OS se distribuyen bajo la [GNU GPL v3 (GPL-3.0-only)](LICENSE). Los componentes de terceros incluidos en la ISO conservan sus respectivas licencias.
