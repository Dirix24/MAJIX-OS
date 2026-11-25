# Cómo guarda los cambios MAJIX OS Live

## Elegir el modo

**Live system** activa la persistencia por defecto. Busca un volumen LUKS2 preparado en un USB extraíble y pide la contraseña para desbloquearlo. Si arrancas solo con la ISO, o el sistema no consigue desbloquear un volumen compatible, la sesión usa memoria temporal. Antes de guardar trabajo importante, comprueba que el USB se desbloqueó y que el volumen aparece en `findmnt | grep /live/persistence`.

**MAJIX OS - Sesion temporal (sin guardar)** omite la persistencia incluso con el USB conectado. Al reiniciar se descartan los cambios de esa sesión y la ISO vuelve a su estado original. El arranque no formatea el USB ni el disco interno.

## Preparar una memoria USB cifrada

Usa un USB con espacio suficiente y una partición vacía dedicada a MAJIX OS. La preparación inicial de LUKS y ext4 borra los datos de la partición que elijas. Comprueba el dispositivo y su tamaño con `lsblk -o NAME,TRAN,RM,SIZE,FSTYPE,LABEL,MOUNTPOINTS`.

1. Crea un contenedor **LUKS2** en la partición del USB. Asigna al contenedor la etiqueta de cabecera `persistence`. En un contenedor LUKS2 existente puedes asignarla con `cryptsetup config --label persistence <partición-LUKS2>`.
2. Desbloquea el contenedor y crea en su interior un sistema de archivos **ext4** con la etiqueta **`MAJIX_DATA`**.
3. Monta el sistema de archivos y crea un archivo de texto llamado `persistence.conf` en su raíz. Escribe una sola de las siguientes líneas, según el comportamiento que quieras para ese USB.

| Quiero guardar | Contenido de `persistence.conf` | Qué pasa al reiniciar |
| --- | --- | --- |
| **El sistema y mis archivos** | `/ union` | Conserva cambios en el sistema Live, como archivos, ajustes y paquetes instalados. |
| **Solo mi carpeta personal** | `/home/majix` | Conserva documentos y ajustes personales. Los cambios fuera de esa carpeta se descartan. |

4. Desmonta el sistema de archivos, cierra el contenedor y arranca MAJIX OS con el USB conectado. Selecciona **Live system** e introduce la contraseña.

Un USB preparado con la opción anterior `/home/majix` conserva ese comportamiento. Si quieres pasar a `/ union`, haz una copia de tus archivos y prepara un volumen nuevo para el perfil completo.

## Comprobar que funciona

Crea un archivo en tu carpeta personal, apaga la sesión desde el escritorio y vuelve a arrancar con el mismo USB y contraseña. El archivo debe seguir ahí. Si seleccionaste `/ union`, también puedes comprobar que un paquete instalado durante la primera sesión permanece disponible. En QEMU, presenta el almacenamiento como un USB extraíble (`usb-storage,removable=on`).

Referencias de Debian Live. [Opciones de arranque](https://manpages.debian.org/trixie/live-boot-doc/live-boot.7.en.html) · [Formato de persistence.conf](https://manpages.debian.org/trixie/live-boot-doc/persistence.conf.5.en.html)
