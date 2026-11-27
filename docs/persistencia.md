# Guardar en MAJIX OS Portable

El USB preparado tiene una partición UEFI `MAJIXUSB` y una partición de datos ext4 `MAJIX_DATA`. **Live system** arranca con inicio automático de sesión. Debian Live usa `MAJIX_DATA` como capa escribible cuando el archivo `persistence.conf` contiene `/ union`. Así se conservan documentos, ajustes y los paquetes instalados en la sesión. No se pide contraseña para desbloquear el volumen. Los datos quedan sin cifrar.

## Elegir dónde guarda MAJIX Studio

- **USB de MAJIX** usa `MAJIXProjects` en `MAJIX_DATA`, fuera de la capa de cambios del sistema.
- **Dispositivo conectado** guarda en la unidad extraíble que selecciones. Si no aparece, conéctala y pulsa **Actualizar unidades**.

La carpeta de proyectos y las carpetas que creas para copiar archivos son independientes de la carpeta personal. El modo **Sesión temporal** descarta los cambios del sistema al reiniciar. En ese modo solo se conservan las copias guardadas explícitamente en una unidad escribible. Si arrancas la ISO sin un USB preparado, la sesión tiene almacenamiento temporal.

## Preparar otro USB

En una partición ext4 vacía y dedicada al almacenamiento, usa la etiqueta `MAJIX_DATA`. Crea `persistence.conf` en la raíz con la línea `/ union` y crea la carpeta `MAJIXProjects` con permisos de escritura para el usuario Live `majix` (UID 1000). Para comprobar el perfil, ejecuta `majix-storage` en Konsole. Guarda un archivo, apaga el sistema y comprueba que reaparece al arrancar.

[Opciones de Debian Live](https://manpages.debian.org/trixie/live-boot-doc/live-boot.7.en.html)

En la rama de desarrollo, **Gráficos seguros** conserva las opciones de persistencia y arranca con `nomodeset` y Plymouth desactivado. El diagnóstico `majix-storage --require-full` devuelve un error si no confirma una raíz persistente escribible. Para pasos de diagnóstico y copias, consulta la [guía de recuperación](portable-foundation.md#recuperación).
