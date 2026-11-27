# Base portátil de MAJIX OS Developer

MAJIX OS · Portable Technology OS

**Programa. Diseña. Investiga. Construye.**

## Arquitectura

Debian 13 AMD64, ISO híbrida, Syslinux para BIOS, GRUB para UEFI y KDE Plasma. La raíz de la imagen sigue en SquashFS y Debian Live monta la capa escribible con OverlayFS. El medio existente con `MAJIX_DATA` en ext4 y `/ union` en `persistence.conf` sigue siendo el punto de partida. El menú incluye un arranque de gráficos seguros que conserva los parámetros de persistencia.

| Arquitectura | Ventajas | Trabajo requerido |
| --- | --- | --- |
| Live con OverlayFS (actual) | Arranque desde una imagen de solo lectura, compatibilidad con los USB de la alfa y sesión temporal para diagnóstico. | Mantener juntos el kernel, el initramfs y SquashFS. El contenido acumulado en la capa superior dificulta sustituir limpiamente la imagen base. |
| Instalación completa externa | Actualización del kernel y del initramfs con los mecanismos Debian. LUKS2 y gestión de paquetes sobre una raíz convencional. | Johnny tendría que aislar el disco externo, preparar ambos modos de arranque y validar el traslado entre equipos. Migración y rollback todavía por diseñar. |
| Imagen por ranuras A/B | Selección explícita de la versión anterior cuando falla la nueva. | Exige espacio adicional, bootloader con control de intentos y un modelo de datos que conserve también aplicaciones y configuraciones. |

Se conserva OverlayFS durante esta fase. Antes de cambiar de arquitectura se necesita una migración ensayada sobre copias desechables y dos versiones arrancables. Actualizar el kernel con APT dentro de OverlayFS deja los archivos de arranque de la ISO en su versión anterior.

## Compilar y preparar el medio

1. Compila en Debian 13 AMD64 con `live-build`, `ca-certificates`, `rsync` y privilegios para el chroot y sus montajes. Ejecuta `sudo bash build-live.sh dist` desde la raíz del repositorio.
2. Ejecuta `(cd dist && sha256sum -c SHA256SUMS)`. Para reproducir CI, ejecuta el flujo `MAJIX OS Live AMD64` sobre la rama de desarrollo.
3. Prueba primero la ISO en una VM AMD64 y usa una copia del USB durante la validación. Para un medio que ya arranca con la alfa, consulta [la guía de persistencia](persistencia.md) y conserva una copia externa de `MAJIX_DATA` antes de cambiar sus archivos de arranque.
4. En Plasma, abre MAJIX Control Center o ejecuta `majix-storage --require-full`. El código de salida 0 confirma que se encontró una capa completa escribible. Para validar el medio real, guarda un archivo, apaga normalmente, arranca otra vez y comprueba que reaparece.

La creación de un USB cifrado desde cero y la instalación en microSD con Johnny siguen pendientes. Los lectores internos dependen del firmware del ordenador y de cómo Debian Live clasifique el medio.

## Actualizar las aplicaciones MAJIX

El paquete `majix-desktop` contiene Studio, Control Center, los comandos `majix-storage`, `majix-tools` y `majix-update`, el inicio de sesión de Studio y los recursos del escritorio. Se instala durante la compilación de la ISO. La alfa anterior instala binarios en `/usr/local/bin` que pueden ocultar los del paquete. El nuevo flujo se debe validar en una imagen compilada con el paquete de origen y un medio de prueba antes de migrar una instalación antigua.

### Preparar la firma y el canal

1. En GitHub crea los entornos `majix-developer`, `majix-beta` y `majix-stable`. Restringe las ramas y etiquetas aptas para publicación. Activa aprobación obligatoria en los canales que deban promocionarse tras CI.
2. En cada entorno configura `MAJIX_APT_SIGNING_KEY` con la clave exclusiva de firma exportada para el trabajador de CI y `MAJIX_APT_SIGNING_FINGERPRINT` con su huella completa. Mantén una copia de custodia y el material de revocación fuera de GitHub.
3. Una vez revisada la compilación y validadas sus pruebas, ejecuta `MAJIX desktop packages` en la referencia correspondiente y asigna una versión creciente de paquete. Ejemplos de prepublicación y versión final son `0.1.1~dev1`, `0.1.1~beta1` y `0.1.1`.
4. Descarga el artefacto. Comprueba `InRelease` con una copia de la clave pública distribuida por un canal confiable. Publica juntos `archive/dists/` y `archive/pool/` en el servidor HTTPS, con los DEB primero y los metadatos firmados al final o mediante promoción atómica del directorio. Conserva los DEB previos para recuperación. Los índices caducan a los 14 días y hay que renovarlos incluso si el contenido sigue igual.

### Configurar el sistema Live

Verifica fuera de banda la huella de la clave pública y colócala en `/etc/apt/keyrings/majix-archive.gpg` con permisos de lectura para APT. Crea `/etc/apt/sources.list.d/majix.sources` usando la URL real del repositorio y una suite:

```text
Types: deb
URIs: https://apt.example.invalid/majix/
Suites: developer
Components: main
Architectures: amd64
Signed-By: /etc/apt/keyrings/majix-archive.gpg
```

Ejecuta `majix-update refresh`, `majix-update check` y, después de revisar la versión, `majix-update apply`. APT valida la firma del índice y el hash del paquete. Las actualizaciones ordinarias de Debian conservan su flujo APT independiente. Los tres canales se preparan como artefactos de CI. El alojamiento, las publicaciones GitHub Releases, la detección periódica y la actualización integral del medio quedan pendientes.

## Recuperación

- Si el Centro de control avisa de una sesión temporal, copia los archivos de esa sesión a un destino distinto y escribible antes de apagar. Arranca de nuevo y comprueba los puntos de montaje con `lsblk -f` y `majix-storage`.
- Si el volumen se monta en solo lectura, trabaja con una copia del volumen y examínala desde otro sistema. Evita reparar en línea la partición que respalda la raíz Live. El modo temporal y el de gráficos seguros permiten diagnosticar con el mismo medio.
- Ante una interrupción de APT, comprueba primero la persistencia y ejecuta `sudo dpkg --audit`. Si quedaron paquetes pendientes de configurar, prueba `sudo dpkg --configure -a`. Conserva el paquete firmado anterior y una copia externa de los datos antes de un cambio de versión. Esta fase carece de rollback automático del sistema.

## Verificación

| Comprobación | Alcance |
| --- | --- |
| `sh tests/check-storage.sh` | Casos sintéticos para persistencia completa, parcial, temporal, ausente y en solo lectura. |
| `sh tests/check-apt-archive.sh` | Clave efímera, descarga auténtica por APT y rechazo de un DEB y metadatos alterados. |
| Studio y Control Center | Prueba Qt fuera de pantalla. Creación de proyecto y copia mediante hilo de trabajo con destino simulado. |
| Flujo Live | Genera la ISO, inspecciona entradas BIOS/UEFI, verifica los recursos Plymouth y arranca el kernel en QEMU. Incluye una prueba nueva de dos arranques con un disco USB virtual que comprueba archivo, configuración, paquete, usuario y hash de contraseña. Aún pendiente de ejecución para esta rama. |
| Hardware físico | Pendientes USB y microSD, cifrado, arranque completo UEFI, GPU, autenticación gráfica y mediciones representativas de arranque, memoria y escrituras. |

[Debian Live](https://manpages.debian.org/trixie/live-boot-doc/live-boot.7.en.html) · [APT Secure](https://manpages.debian.org/trixie/apt/apt-secure.8.en.html) · [ZRAM en Debian 13](https://manpages.debian.org/trixie/systemd-zram-generator/zram-generator.conf.5.en.html)
