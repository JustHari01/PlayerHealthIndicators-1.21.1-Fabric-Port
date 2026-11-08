# Player Health Indicators (Unofficial 1.21.1 Fabric Port)

An unofficial Fabric compatibility port of [Player Health Indicators](https://www.curseforge.com/minecraft/mc-mods/player-health-indicators) by Gaider10 for Minecraft 1.21.1.

## What it does

- Displays other players' health as floating hearts above their characters.
- Displays absorption health with the vanilla yellow heart style.
- Provides keybinds to toggle the indicators, toggle heart stacking, and adjust the vertical offset.
- Uses the vanilla HUD heart sprites, so compatible resource packs can change their appearance.

## Requirements

- Minecraft 1.21.1
- Fabric Loader 0.16.14 or newer
- Fabric API 0.116.17 or newer for Minecraft 1.21.1
- Java 21 or newer

This is a client-only mod. Configure its keybinds in Minecraft's Controls menu. Settings are stored in `config/healthindicators.json`.

## Build

Run `gradlew remapJar` with Java 21. The distributable JAR is written to `build/libs/`.

## Verification status

The Java 21 `remapJar` build succeeds, and the packaged metadata, icon, license, and renderer mixin are present in the release JAR. A Minecraft client session has not been run; this release should be treated as an alpha until its in-game rendering is checked.

## Attribution and license

Original project: [Player Health Indicators by Gaider10](https://github.com/Gaider10/PlayerHealthIndicators), based on upstream commit `f1a2c937cd5775fdcd0246a499a8cf29404eb1cd`. This port retains the upstream `healthindicators` mod ID and MIT license. The upstream copyright and license notice are included in this repository and the built JAR.

Port source: <https://github.com/JustHari01/PlayerHealthIndicators-1.21.1-Fabric-Port>

This is an independent compatibility port and is not endorsed by the original author.

The 1.21.1 compatibility changes, build metadata, and release documentation were prepared with AI assistance; the upstream work is by Gaider10.
