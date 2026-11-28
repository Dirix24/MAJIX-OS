// Initial layout for a new MAJIX desktop.
const previousPanels = panels().slice();
const top = new Panel;
top.location = "top";
top.height = 28;
top.floating = false;
top.opacity = "translucent";

const launcher = top.addWidget("org.kde.plasma.kickoff");
launcher.writeConfig("icon", "majix-os");
for (const plugin of ["org.kde.plasma.panelspacer", "org.kde.plasma.digitalclock",
                      "org.kde.plasma.panelspacer", "org.kde.plasma.systemtray"]) {
    top.addWidget(plugin);
}

const dock = new Panel;
dock.location = "bottom";
dock.alignment = "center";
dock.lengthMode = "fit";
dock.floating = true;
dock.opacity = "translucent";
dock.height = 42;
const tasks = dock.addWidget("org.kde.plasma.icontasks");
tasks.currentConfigGroup = ["General"];
tasks.writeConfig("launchers", [
    "applications:firefox-esr.desktop",
    "applications:org.kde.dolphin.desktop",
    "applications:org.kde.konsole.desktop",
    "applications:majix-studio.desktop",
    "applications:majix-control.desktop"
]);

for (const panel of previousPanels) {
    panel.remove();
}
