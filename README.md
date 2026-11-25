# MAJIX OS
Plataforma universal de desarrollo, investigación y creación tecnológica

Este documento recoge la especificación y la hoja de ruta del proyecto.

## MAJIX OS 0.1 Alpha

La primera imagen es una sesión Live para AMD64 basada en Debian 13. Incluye KDE Plasma, Wayland, XWayland, NetworkManager, PipeWire, Firefox ESR, Konsole y Kate. La sesión arranca en español y los cambios se pierden al reiniciar. El instalador Johnny y la persistencia cifrada corresponden a hitos posteriores. Para arrancar en UEFI, desactiva Secure Boot en la máquina de pruebas.

Descarga el artefacto `majix-os-0.1-alpha-amd64` de una [ejecución exitosa de GitHub Actions](https://github.com/Dirix24/MAJIX-OS/actions/workflows/live.yml). Extrae el ZIP y comprueba la imagen con `sha256sum -c SHA256SUMS`. Para probarla, monta la ISO como unidad óptica en una máquina virtual AMD64.

Para compilar en Debian 13 AMD64, ejecuta desde la raíz del repositorio:

```bash
sudo apt-get update
sudo apt-get install live-build ca-certificates rsync
sudo bash build-live.sh dist
```

La compilación genera la ISO y su archivo `SHA256SUMS` en `dist/`. Usa los paquetes disponibles en los repositorios de Debian en el momento de compilar.

## 1. Misión del proyecto

Diseñar y desarrollar una distribución GNU/Linux independiente, moderna, modular, portátil, personalizable, eficiente, segura y de código abierto denominada MAJIX OS.

MAJIX OS estará inspirado conceptualmente en Debian, Raspberry Pi OS, Tails, Arch Linux, NixOS, Fedora, Ubuntu Studio y otros sistemas tecnológicos modernos, pero contará con identidad, herramientas, arquitectura de integración y experiencia de usuario propias.

Su finalidad será proporcionar un laboratorio tecnológico completo para:

- Programadores.
- Investigadores.
- Ingenieros informáticos.
- Ingenieros electrónicos.
- Científicos.
- Profesionales de inteligencia artificial.
- Especialistas en redes y telecomunicaciones.
- Administradores de sistemas.
- Profesionales de ciberseguridad.
- Desarrolladores de videojuegos.
- Inventores y aficionados a la tecnología.
- Estudiantes.
- Creadores de hardware.
- Profesionales de robótica y automatización.
- Usuarios principiantes y avanzados.

El sistema deberá permitir utilizar, comprender, investigar, modificar y crear tecnología desde una plataforma unificada.

Lema del proyecto:

**Your system. Your technology. Your freedom.**

## 2. Principios fundamentales

MAJIX OS deberá respetar los siguientes principios:

- Código abierto.
- Libertad de elección.
- Personalización profunda.
- Privacidad desde el diseño.
- Seguridad por defecto.
- Ausencia de publicidad integrada.
- Ausencia de cuentas obligatorias.
- Telemetría desactivada por defecto.
- Inteligencia artificial completamente opcional.
- Funcionamiento sin conexión a Internet.
- Compatibilidad multiplataforma.
- Accesibilidad.
- Eficiencia energética.
- Modularidad.
- Transparencia.
- Facilidad de uso.
- Configuraciones reproducibles.
- Actualizaciones verificables.
- Control del usuario sobre sus datos.
- Independencia de proveedores comerciales.
- Posibilidad de eliminar componentes opcionales.

No obligar al usuario a utilizar un escritorio, navegador, editor, proveedor de inteligencia artificial o metodología de trabajo determinados.

## 3. Base tecnológica

Utilizar Debian GNU/Linux Stable como distribución base inicial.

Priorizar:

- Debian 13 o una versión estable posterior compatible.
- Linux Kernel mantenido y actualizado.
- Arquitecturas AMD64 y ARM64.
- APT y paquetes DEB.
- Flatpak.
- Compatibilidad con AppImage.
- systemd.
- PipeWire.
- WirePlumber.
- NetworkManager.
- BlueZ.
- Mesa.
- Vulkan.
- OpenGL.
- Wayland.
- XWayland.
- X11 opcional.
- LUKS2.
- Btrfs.
- ext4.
- Podman.
- KVM y QEMU.
- UEFI y Secure Boot cuando estén correctamente implementados.

Mantener una separación clara entre los paquetes oficiales de Debian y los componentes desarrollados específicamente para MAJIX OS.

No mezclar indiscriminadamente repositorios de otras distribuciones.

Utilizar repositorios propios firmados criptográficamente para distribuir componentes exclusivos y actualizaciones verificadas.

## 4. Arquitecturas y dispositivos

Desarrollar compatibilidad progresiva con:

- Ordenadores de sobremesa.
- Ordenadores portátiles.
- Mini PC.
- Estaciones de trabajo.
- Servidores.
- Raspberry Pi.
- Orange Pi.
- Rock Pi.
- NVIDIA Jetson.
- Otras placas SBC compatibles.
- Máquinas virtuales.
- Sistemas integrados.

Considerar arquitecturas adicionales, como RISC-V, cuando exista soporte suficientemente maduro.

Generar imágenes específicas para cada dispositivo cuando sean necesarias.

No asumir que una imagen ARM64 universal puede arrancar en todas las placas.

Implementar detección de hardware, controladores, firmware y configuraciones específicas.

Permitir programar microcontroladores como Arduino, ESP32, STM32 y RP2040 desde MAJIX OS, sin confundir estos dispositivos con placas capaces de ejecutar una distribución Linux completa.

## 5. Modos de funcionamiento

Implementar los siguientes modos:

### Live Mode

Ejecutar MAJIX OS desde USB, SSD externo u otro medio compatible sin instalarlo en el ordenador.

No modificar los discos internos automáticamente.

Los cambios de la sesión deberán ser temporales por defecto.

### Persistent Mode

Permitir guardar proyectos, configuraciones, aplicaciones y documentos entre reinicios mediante almacenamiento persistente.

Ofrecer cifrado LUKS2.

### Installed Mode

Instalar MAJIX OS como sistema operativo permanente en el equipo.

Permitir instalación exclusiva o arranque dual cuando sea compatible.

### Portable Workstation Mode

Convertir un SSD externo o memoria USB compatible en una estación de trabajo portátil completa.

### Embedded Mode

Ejecutar MAJIX OS en placas electrónicas compatibles con Linux.

### Headless Mode

Funcionamiento sin escritorio gráfico, orientado a servidores, automatización y dispositivos remotos.

### Recovery Mode

Proporcionar herramientas de diagnóstico, reparación, recuperación y restauración.

### Private Session Mode

Ofrecer sesiones temporales con medidas adicionales de privacidad y aislamiento.

No prometer anonimato absoluto ni equivalencia con Tails sin una implementación específica y auditorías independientes.

## 6. Instalador inteligente: Johnny

Desarrollar un instalador gráfico moderno denominado Johnny Installer.

Utilizar Calamares adaptado o desarrollar una solución propia cuando esté justificado.

El instalador deberá guiar al usuario durante todo el proceso.

### Etapa 1. Bienvenida

- Selección de idioma.
- Región.
- Zona horaria.
- Distribución de teclado.
- Accesibilidad.
- Tema visual.
- Modo principiante o avanzado.

### Etapa 2. Análisis del dispositivo

Detectar:

- Procesador.
- Arquitectura.
- Memoria RAM.
- GPU.
- Almacenamiento.
- Interfaces de red.
- Bluetooth.
- Pantallas.
- Dispositivos externos.
- Firmware.
- Compatibilidad gráfica.
- Capacidad de virtualización.

Mostrar recomendaciones basadas en el hardware detectado.

### Etapa 3. Modalidad de instalación

Permitir elegir:

- Probar sin instalar.
- Sesión Live.
- USB persistente.
- Instalación en disco interno.
- Instalación en SSD externo.
- Arranque dual.
- Instalación avanzada.
- Sistema sin interfaz gráfica.

### Etapa 4. Selección del entorno de escritorio

Ofrecer, según disponibilidad y compatibilidad:

- KDE Plasma.
- COSMIC.
- GNOME.
- XFCE.
- LXQt.
- Cinnamon.
- MATE.
- Hyprland.
- Niri.
- Sway.
- Otros escritorios compatibles.
- Instalación sin escritorio.

Recomendar KDE Plasma como opción inicial por su equilibrio entre facilidad de uso y personalización.

Permitir seleccionar Wayland o X11 cuando el escritorio elegido admita ambas tecnologías.

Utilizar Wayland como opción moderna preferente.

Mantener XWayland para aplicaciones antiguas.

No ofrecer combinaciones técnicamente incompatibles.

Permitir instalar escritorios adicionales posteriormente.

### Etapa 5. Perfil de trabajo

Permitir seleccionar uno o varios perfiles:

- Usuario general.
- Programador.
- Investigador.
- Científico.
- Electrónica.
- Robótica.
- Inteligencia artificial.
- Ciberseguridad.
- Redes.
- Telecomunicaciones.
- Desarrollo web.
- Desarrollo móvil.
- Desarrollo de videojuegos.
- Administración de sistemas.
- Ingeniería.
- Diseño e impresión 3D.
- Automatización.
- Educación.
- Maker.
- Perfil personalizado.
- Instalación mínima.

### Etapa 6. Selección de herramientas

Mostrar las aplicaciones correspondientes a los perfiles elegidos.

Permitir marcar y desmarcar individualmente cada aplicación.

Mostrar:

- Tamaño de descarga.
- Espacio necesario.
- Dependencias.
- Compatibilidad.
- Licencia.
- Requisitos de hardware.
- Consumo aproximado de recursos cuando existan datos fiables.

No instalar aplicaciones innecesarias sin autorización.

### Etapa 7. Almacenamiento y privacidad

Permitir elegir dónde se guardarán:

- Proyectos.
- Documentos.
- Configuraciones.
- Aplicaciones.
- Modelos de IA.
- Contenedores.
- Máquinas virtuales.
- Datos científicos.
- Copias de seguridad.

Ofrecer cifrado y particionado avanzado.

Solicitar confirmación explícita antes de formatear, sobrescribir o modificar discos.

### Etapa 8. Instalación

Mostrar progreso real, registros, errores y estado de los componentes.

Permitir exportar la configuración seleccionada para reproducirla posteriormente.

### Etapa 9. Primer inicio

Mostrar un asistente de bienvenida que permita modificar todas las decisiones anteriores.

## 7. Sistema de almacenamiento inteligente: Silvestre

Desarrollar Silvestre Storage Manager.

El usuario deberá tener control absoluto sobre dónde guarda cada proyecto.

Ofrecer los siguientes destinos:

### Almacenamiento temporal

Guardar archivos únicamente durante la sesión actual.

Advertir claramente que se perderán al reiniciar o apagar el sistema.

### Memoria persistente

Guardar proyectos en la partición persistente del USB o SSD desde el que se ejecuta MAJIX OS.

Permitir cifrado y desbloqueo mediante contraseña.

### Almacenamiento local

Guardar proyectos en el disco interno del ordenador cuando el usuario lo autorice.

No montar discos internos automáticamente en el modo privado.

### Almacenamiento externo

Guardar proyectos en memorias USB, discos externos, tarjetas SD y otros dispositivos compatibles.

### Almacenamiento remoto

Permitir conexiones opcionales a:

- NAS.
- SFTP.
- WebDAV.
- Servidores propios.
- Servicios de almacenamiento en la nube.
- Repositorios Git.

No exigir servicios externos.

### Gestor de proyectos

Cada proyecto podrá tener:

- Nombre.
- Descripción.
- Ubicación.
- Perfil tecnológico.
- Entorno de desarrollo.
- Dependencias.
- Repositorio Git.
- Configuración.
- Copias de seguridad.
- Política de persistencia.
- Estado de cifrado.

Permitir mover, copiar, importar y exportar proyectos entre dispositivos.

Permitir configurar destinos diferentes para cada proyecto.

Ofrecer almacenamiento persistente selectivo para:

- Configuraciones del escritorio.
- Documentos.
- Código fuente.
- Aplicaciones.
- Claves SSH.
- Entornos virtuales.
- Contenedores.
- Modelos de inteligencia artificial.
- Datos científicos.
- Configuraciones de red.
- Marcadores.
- Temas.

Proteger credenciales y claves mediante mecanismos adecuados de almacenamiento seguro.

No guardar automáticamente datos sensibles en ubicaciones sin cifrar.

## 8. Gestor de aplicaciones y módulos: Michi

Desarrollar Michi Software Center.

Crear una tienda y gestor de paquetes unificado, moderno y accesible.

Integrar:

- APT.
- Paquetes DEB.
- Flatpak.
- AppImage.
- Repositorios oficiales.
- Repositorios propios.
- Módulos comunitarios verificados.

Permitir:

- Buscar aplicaciones.
- Instalar.
- Desinstalar.
- Actualizar.
- Consultar dependencias.
- Consultar licencias.
- Administrar permisos.
- Verificar firmas.
- Administrar repositorios.
- Crear perfiles de aplicaciones.
- Exportar listas de paquetes.
- Instalar módulos completos.
- Seleccionar herramientas individuales.
- Descargar paquetes para instalación sin conexión.

No instalar software de fuentes desconocidas automáticamente.

Distinguir claramente software oficial, comunitario y de terceros.

## 9. Módulos tecnológicos

### Desarrollo de software

Ofrecer opcionalmente:

- Python.
- C.
- C++.
- Rust.
- Go.
- Java.
- Kotlin.
- JavaScript.
- TypeScript.
- PHP.
- Ruby.
- Lua.
- Swift cuando sea compatible.
- GCC.
- Clang.
- LLVM.
- CMake.
- Make.
- Ninja.
- Git.
- GDB.
- LLDB.
- Neovim.
- Emacs.
- Kate.
- VSCodium.
- Visual Studio Code opcional.
- Herramientas de pruebas.
- Gestores de dependencias.

### Investigación científica

- JupyterLab.
- NumPy.
- SciPy.
- Pandas.
- Matplotlib.
- R.
- Julia.
- GNU Octave.
- SymPy.
- LaTeX.
- Zotero.
- Herramientas de simulación.
- Visualización científica.
- Gestión de conjuntos de datos.
- Entornos reproducibles.

### Electrónica

- KiCad.
- Arduino IDE.
- PlatformIO.
- ESP-IDF.
- Herramientas STM32.
- OpenOCD.
- Avrdude.
- Minicom.
- PulseView.
- Sigrok.
- Ngspice.
- Herramientas GPIO.
- Comunicación serie.
- I2C.
- SPI.
- UART.
- Depuración de microcontroladores.

### Robótica y automatización

- ROS 2 cuando sea compatible.
- Gazebo.
- OpenCV.
- MQTT.
- Node-RED.
- Herramientas de sensores.
- Simuladores.
- Control de motores.
- Automatización industrial.
- Integración con dispositivos IoT.

### Inteligencia artificial

Módulo completamente opcional.

- Ollama.
- llama.cpp.
- PyTorch.
- TensorFlow.
- ONNX Runtime.
- Hugging Face.
- Jupyter.
- Herramientas de evaluación.
- Modelos locales.
- Procesamiento de lenguaje natural.
- Visión artificial.
- Aprendizaje automático.
- Reconocimiento de voz.
- Generación de imágenes mediante herramientas compatibles.
- Conexiones voluntarias a proveedores externos.

No descargar modelos grandes sin autorización.

No enviar código, archivos ni conversaciones a servicios externos sin consentimiento.

### Redes y telecomunicaciones

- Wireshark.
- Tcpdump.
- OpenSSH.
- WireGuard.
- OpenVPN.
- Nmap para auditorías autorizadas.
- Herramientas DNS.
- Diagnóstico de redes.
- GNU Radio.
- SDR.
- Simulación de redes.
- Monitorización.

### Ciberseguridad

Orientar las herramientas a investigación legítima, auditoría autorizada, análisis defensivo y educación.

- Análisis de vulnerabilidades.
- Análisis forense.
- Monitorización.
- Laboratorios aislados.
- Análisis de registros.
- Verificación de integridad.
- Gestión de certificados.
- Cifrado.
- Herramientas de recuperación.

No ejecutar pruebas intrusivas automáticamente contra sistemas externos.

### Infraestructura

- Podman.
- Docker opcional.
- KVM.
- QEMU.
- Libvirt.
- Ansible.
- Kubernetes opcional.
- PostgreSQL.
- MariaDB.
- SQLite.
- Redis.
- Nginx.
- Apache.
- Servidores de desarrollo.
- Herramientas de integración continua.

### Diseño y fabricación

- FreeCAD.
- Blender.
- Inkscape.
- GIMP.
- Krita.
- OpenSCAD.
- PrusaSlicer.
- Cura.
- Herramientas CAD.
- Diseño de prototipos.
- Impresión 3D.

### Videojuegos

- Godot.
- SDL.
- Vulkan SDK.
- OpenGL.
- Blender.
- Herramientas de audio.
- Motores y editores adicionales compatibles.

Todas las aplicaciones deberán comprobarse individualmente para cada arquitectura y versión de Debian.

## 10. MAJIX Desktop

Crear una experiencia visual propia sobre los escritorios compatibles, evitando mantener bifurcaciones innecesarias.

Características:

- Diseño moderno.
- Interfaz limpia.
- Animaciones configurables.
- Temas claros y oscuros.
- Colores de acento.
- Transparencias opcionales.
- Widgets.
- Paneles personalizables.
- Escritorios virtuales.
- Gestión de ventanas.
- Modo mosaico.
- Modo tradicional.
- Compatibilidad con múltiples monitores.
- Escalado HiDPI.
- Accesibilidad.
- Atajos configurables.
- Navegación mediante teclado.
- Compatibilidad táctil cuando sea posible.

Crear perfiles visuales:

- MAJIX Dark.
- MAJIX Light.
- MAJIX Developer.
- MAJIX Research.
- MAJIX Minimal.
- MAJIX Retro.
- MAJIX Custom.

Permitir importar y exportar temas.

No obligar a utilizar efectos gráficos que reduzcan el rendimiento.

## 11. MAJIX Control Center

Desarrollar un centro de control unificado.

Utilizar preferentemente Rust para componentes internos y Qt 6/QML para la interfaz gráfica, evaluando alternativas cuando aporten ventajas justificadas.

Incluir:

- Información del sistema.
- Monitorización de CPU.
- Monitorización de RAM.
- Temperaturas.
- GPU.
- Almacenamiento.
- Batería.
- Red.
- Bluetooth.
- Aplicaciones.
- Escritorios.
- Temas.
- Seguridad.
- Privacidad.
- Persistencia.
- Proyectos.
- Contenedores.
- Máquinas virtuales.
- Dispositivos electrónicos.
- Actualizaciones.
- Copias de seguridad.
- Perfiles de rendimiento.

El centro de control deberá integrarse con los servicios existentes de Linux sin duplicar innecesariamente sus funciones.

Aplicar privilegios mínimos y autorización mediante Polkit cuando corresponda.

## 12. MAJIX Lab

Desarrollar un entorno de laboratorios tecnológicos.

Permitir crear:

- Laboratorios de programación.
- Laboratorios científicos.
- Laboratorios de redes.
- Laboratorios de electrónica.
- Laboratorios de inteligencia artificial.
- Entornos de pruebas.
- Máquinas virtuales.
- Contenedores.
- Sandboxes.

Cada laboratorio podrá tener dependencias, configuraciones, recursos y almacenamiento independientes.

Utilizar contenedores sin privilegios cuando sea posible.

Utilizar máquinas virtuales para escenarios que requieran un aislamiento más fuerte.

No presentar los contenedores como una frontera de seguridad equivalente a una máquina virtual.

Permitir exportar e importar laboratorios reproducibles.

## 13. MAJIX AI

Crear un asistente de inteligencia artificial opcional.

Deberá poder:

- Ayudar a programar.
- Explicar código.
- Analizar errores.
- Consultar documentación.
- Organizar proyectos.
- Analizar datos.
- Ayudar en investigaciones.
- Sugerir configuraciones.
- Explicar comandos.
- Crear automatizaciones.
- Trabajar con modelos locales.

El usuario podrá elegir:

- No utilizar inteligencia artificial.
- Utilizar únicamente modelos locales.
- Utilizar proveedores externos.
- Combinar modelos locales y externos.

La IA no deberá ejecutar comandos privilegiados, instalar aplicaciones, modificar archivos importantes ni enviar información externa sin autorización adecuada.

Mostrar las acciones propuestas antes de ejecutarlas cuando impliquen riesgos.

## 14. Seguridad y recuperación: Rex

Desarrollar Rex Security & Recovery.

Incluir:

- Cifrado de almacenamiento.
- Firewall configurable.
- AppArmor.
- Gestión de permisos.
- Verificación de paquetes.
- Firmas criptográficas.
- Actualizaciones de seguridad.
- Gestión de claves.
- Diagnóstico.
- Copias de seguridad.
- Recuperación del arranque.
- Restauración de configuraciones.
- Instantáneas Btrfs cuando sean compatibles.
- Verificación de integridad.
- Registro de errores.
- Modo de emergencia.

Incorporar perfiles de seguridad:

- Estándar.
- Privacidad reforzada.
- Desarrollo.
- Laboratorio aislado.
- Personalizado.

Permitir configurar Tor como componente opcional, explicando sus limitaciones y evitando promesas de anonimato absoluto.

## 15. Rendimiento y eficiencia

Optimizar el sistema para funcionar en hardware diverso.

Ofrecer perfiles:

- Ahorro energético.
- Ligero.
- Equilibrado.
- Alto rendimiento.
- Estación de trabajo.
- Servidor.
- Personalizado.

Adaptar:

- Servicios de inicio.
- Animaciones.
- Composición gráfica.
- Gestión energética.
- Uso de memoria.
- Procesos en segundo plano.
- Recursos de contenedores.
- Recursos de máquinas virtuales.

No aplicar modificaciones agresivas del kernel sin pruebas.

Establecer objetivos medibles de arranque, consumo de RAM, uso de almacenamiento y estabilidad.

## 16. MAJIX Builder

Desarrollar un constructor de imágenes personalizadas.

Permitir seleccionar:

- Arquitectura.
- Dispositivo.
- Escritorio.
- Protocolo gráfico compatible.
- Aplicaciones.
- Módulos.
- Idioma.
- Temas.
- Configuraciones.
- Seguridad.
- Persistencia.
- Controladores.
- Tipo de imagen.

Generar según corresponda:

- ISO Live.
- Imágenes IMG.
- Imágenes comprimidas.
- Imágenes para máquinas virtuales.
- Imágenes para placas compatibles.

Utilizar Debian Live Build para las imágenes Live iniciales de PC y herramientas específicas para las imágenes de placas ARM.

Permitir exportar configuraciones reproducibles en YAML o TOML.

## 17. Actualizaciones

Desarrollar MAJIX Update.

Mantener canales diferenciados:

- Stable.
- Testing.
- Experimental.
- Development.

Ofrecer:

- Actualizaciones verificadas.
- Actualizaciones de seguridad.
- Historial de cambios.
- Comprobación de dependencias.
- Recuperación ante fallos.
- Instantáneas previas cuando sean compatibles.
- Actualizaciones sin conexión mediante paquetes verificados.

No forzar actualizaciones experimentales.

No afirmar que existe recuperación atómica hasta que se haya implementado y probado.

## 18. Herramientas de línea de comandos

Crear una CLI denominada maxctl.

Ejemplos de interfaz futura:

```bash
maxctl system info
maxctl hardware detect
maxctl modules list
maxctl modules install development
maxctl modules install electronics
maxctl desktop list
maxctl project create
maxctl storage status
maxctl persistence configure
maxctl lab create
maxctl security status
maxctl backup create
maxctl update check
maxctl image build
```

Estos comandos deberán implementarse realmente, documentarse y probarse antes de presentarlos como funcionales.

## 19. Ediciones

Mantener una base común y ofrecer configuraciones predefinidas:

- MAJIX OS Minimal.
- MAJIX OS Desktop.
- MAJIX OS Portable.
- MAJIX OS Developer.
- MAJIX OS Research.
- MAJIX OS Embedded.
- MAJIX OS Server.
- MAJIX OS Custom.

Todas las ediciones deberán poder ampliarse mediante módulos compatibles.

## 20. Identidad del ecosistema

MAJIX OS será la marca principal, en homenaje a Max.

Utilizar los nombres Johnny, Michi, Silvestre y Rex como homenaje a los demás animales.

- Johnny: instalación y bienvenida.
- Michi: aplicaciones y módulos.
- Silvestre: almacenamiento y persistencia.
- Rex: seguridad y recuperación.

Diseñar una identidad visual profesional, tecnológica, reconocible y amigable.

Evitar copiar logotipos, marcas o identidades visuales de otras distribuciones.

## 21. Organización del código fuente

Crear una estructura modular:

```text
MAJIX-OS/
├── core/
├── build/
├── packages/
├── repositories/
├── installer-johnny/
├── software-michi/
├── storage-silvestre/
├── security-rex/
├── control-center/
├── desktop/
├── max-ai/
├── max-lab/
├── max-builder/
├── max-update/
├── maxctl/
├── modules/
├── profiles/
├── hardware/
├── themes/
├── translations/
├── tests/
├── security/
├── documentation/
├── website/
├── ci/
├── LICENSE
└── README.md
```

Separar claramente código propio, dependencias externas, configuraciones, recursos gráficos y herramientas de construcción.

## 22. Calidad del desarrollo

Exigir:

- Código mantenible.
- Documentación.
- Pruebas unitarias.
- Pruebas de integración.
- Pruebas de arranque.
- Pruebas en máquinas virtuales.
- Pruebas en hardware real.
- Pruebas de persistencia.
- Pruebas de cifrado.
- Pruebas de actualización.
- Pruebas de recuperación.
- Análisis de seguridad.
- Verificación de licencias.
- Integración continua.
- Compilaciones reproducibles cuando sea viable.
- Inventario de componentes de software.
- Registro de cambios.
- Gestión de vulnerabilidades.

No generar componentes ficticios ni interfaces que simulen funcionalidades inexistentes.

Identificar claramente las funciones experimentales, incompletas o no implementadas.

## 23. Página web oficial

Crear una plataforma web para:

- Presentar MAJIX OS.
- Descargar imágenes.
- Consultar requisitos.
- Verificar firmas y sumas SHA-256.
- Consultar documentación.
- Acceder a tutoriales.
- Consultar compatibilidad.
- Descargar módulos.
- Consultar versiones.
- Comunicar errores.
- Participar en la comunidad.
- Acceder al código fuente.
- Crear configuraciones personalizadas.

No exigir registro para descargar el sistema.

## 24. Hoja de ruta

### Fase 0: planificación

Definir arquitectura, requisitos, licencias, modelo de seguridad y estructura del repositorio.

### Fase 1: MAJIX OS 0.1 Alpha

Crear una ISO Live AMD64 funcional basada en Debian.

Integrar:

- KDE Plasma.
- Wayland.
- XWayland.
- Identidad visual inicial.
- Aplicaciones esenciales.
- Configuración de red.
- Terminal.
- Gestor de paquetes.
- Primer sistema de construcción reproducible.

### Fase 2: portabilidad

Implementar persistencia cifrada, selección de destinos de almacenamiento y protección de discos internos.

### Fase 3: instalación

Desarrollar Johnny Installer y el asistente de perfiles de trabajo.

### Fase 4: modularidad

Desarrollar Michi y los primeros módulos tecnológicos.

### Fase 5: personalización

Integrar escritorios adicionales y MAJIX Control Center.

### Fase 6: seguridad

Desarrollar Rex y validar los mecanismos de privacidad y recuperación.

### Fase 7: laboratorios

Desarrollar MAJIX Lab y gestión de proyectos.

### Fase 8: inteligencia artificial

Desarrollar MAJIX AI como módulo independiente y opcional.

### Fase 9: ARM64

Crear imágenes para Raspberry Pi y ampliar progresivamente la compatibilidad con otras placas.

### Fase 10: distribución pública

Publicar imágenes firmadas, repositorios, documentación y página web.

### Fase 11: MAJIX OS 1.0

Publicar una versión estable después de superar pruebas funcionales, de compatibilidad, rendimiento y seguridad.

## 25. Instrucciones para el agente de desarrollo

Actúa como un equipo multidisciplinar formado por arquitectos de sistemas operativos, ingenieros Linux, desarrolladores Rust, especialistas Qt/QML, ingenieros de seguridad, diseñadores UX/UI, especialistas DevOps e ingenieros de hardware.

Desarrolla el proyecto de manera incremental.

Antes de implementar cada componente:

1. Analiza los requisitos.
2. Comprueba la documentación oficial.
3. Identifica dependencias y riesgos.
4. Define la arquitectura.
5. Establece criterios de aceptación.
6. Implementa código real.
7. Ejecuta pruebas.
8. Documenta los resultados.
9. Registra limitaciones.
10. Integra el componente con el resto del sistema.

No inventes resultados de pruebas.

No afirmes haber generado una ISO si no existe un archivo verificable.

No afirmes que el sistema es seguro sin evidencias.

No realices operaciones destructivas sobre discos reales sin autorización.

Prioriza una primera versión funcional antes de desarrollar características secundarias.

Utiliza componentes existentes cuando sean adecuados y desarrolla herramientas propias cuando aporten valor real.

El resultado final deberá ser una distribución GNU/Linux funcional, moderna, modular, portátil, personalizable, mantenible y preparada para evolucionar con la comunidad.

**MAJIX OS debe ser un sistema operativo para quienes aman la tecnología y desean tener la libertad de explorarla, comprenderla y crearla.**
