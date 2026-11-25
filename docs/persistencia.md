# Persistencia cifrada en MAJIX OS Live

Elige **MAJIX OS - Persistencia cifrada (USB)** en el menú de arranque. La entrada Live habitual sigue siendo temporal. La opción cifrada busca exclusivamente almacenamiento USB extraíble y solicita una contraseña si detecta un contenedor LUKS con la etiqueta de cabecera `persistence`.

## Preparar el volumen

Usa una partición vacía y dedicada en una memoria USB. La inicialización de LUKS y el formateo borran el contenido previo de la partición elegida. Identifícala antes con `lsblk -o NAME,TRAN,RM,SIZE,FSTYPE,LABEL,MOUNTPOINTS`.

- Crea un contenedor **LUKS2** con etiqueta de cabecera `persistence` mediante una herramienta de preparación de discos que permita seleccionar una partición. Si ya creaste el contenedor, puedes aplicar la etiqueta con `cryptsetup config --label persistence <partición-LUKS2>`.
- Abre el contenedor y crea dentro un sistema de archivos **ext4** con la etiqueta `MAJIX_DATA`.
- Monta el sistema de archivos y crea en su raíz el archivo `persistence.conf`. Para guardar documentos y configuraciones del usuario Live, escribe esta única línea:

  ```text
  /home/majix
  ```

- Desmonta el sistema de archivos y cierra el contenedor antes de conectar el USB a MAJIX OS.

En QEMU, presenta el disco de persistencia como almacenamiento USB extraíble (`usb-storage,removable=on`) y arranca la ISO desde una unidad óptica virtual. Para comprobar la persistencia, crea un archivo en la carpeta personal y reinicia usando la misma entrada y contraseña. Los archivos que guardes fuera de esa carpeta siguen siendo temporales.

Consulta [live-boot(7)](https://manpages.debian.org/trixie/live-boot-doc/live-boot.7.en.html) y [persistence.conf(5)](https://manpages.debian.org/trixie/live-boot-doc/persistence.conf.5.en.html).
