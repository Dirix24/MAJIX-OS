# MAJIX OS

![Logotipo de MAJIX OS](branding/logo.png)

**MAJIX OS 0.1 Alpha** es una distribución Live para equipos AMD64, basada en Debian 13. Arranca con KDE Plasma en español, usa Wayland e incluye Firefox ESR, Konsole y Kate.

## Probar la alfa

1. Descarga el [ZIP con la ISO](https://github.com/Dirix24/MAJIX-OS/actions/runs/45709947410/artifacts/15067627889) y extráelo. Puedes comprobar la imagen con `sha256sum -c SHA256SUMS`.
2. Monta la ISO como unidad óptica en una máquina virtual de 64 bits. Para arrancar en UEFI, desactiva Secure Boot en la máquina virtual.
3. Selecciona **Live system**. La sesión es temporal y los cambios se pierden al reiniciar.

La entrada opcional [Persistencia cifrada (USB)](docs/persistencia.md) está pensada para conservar la carpeta personal en un volumen LUKS2 preparado. Se han verificado el arranque Live y la animación en QEMU. La conservación de archivos tras reiniciar sigue pendiente de una prueba completa. El instalador Johnny está en la [hoja de ruta](docs/especificacion.md#24-hoja-de-ruta).

## Compilar desde el código fuente

En Debian 13 AMD64, ejecuta desde la raíz del repositorio:

```bash
sudo apt-get update
sudo apt-get install live-build ca-certificates rsync
sudo bash build-live.sh dist
```

La ISO y su suma SHA-256 se guardan en `dist/`. Las compilaciones automáticas están en [GitHub Actions](https://github.com/Dirix24/MAJIX-OS/actions/workflows/live.yml).

## Autoría y licencia

La idea y la dirección del proyecto son de **Dirix24**. La implementación, el logotipo y la documentación de esta alfa se generaron principalmente con **IA generativa (Codex)**, a partir de sus indicaciones. Debian, KDE Plasma y los demás componentes de terceros proceden de sus respectivos proyectos.

Los archivos propios de MAJIX OS se distribuyen bajo la [GNU GPL v3 (GPL-3.0-only)](LICENSE). Los componentes de terceros incluidos en la ISO conservan sus respectivas licencias.
