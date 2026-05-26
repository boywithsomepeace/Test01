# EV_HMI Architecture

## Visual System

The visual target is the Flutter EV HMI dashboard referenced by the user. Its signature language is a black stage, one angular copper perimeter, mirrored nested chevron tunnels, tiny top status telltales, central speed hierarchy, a large selected gear at the bottom center, and a segmented battery rail. This project recreates those ideas in Qt/QML while keeping the backend suitable for embedded telemetry.

Color roles:

- Background: `#020304`
- Panel glass: `#11171c`
- Dim structure: `#241c19`
- Primary copper: `#7f5a50`
- Bright copper: `#a57968`
- Text primary: `#d7d7d9`
- Text secondary: `#8f9398`
- State green: `#82e335`
- Electric cyan: `#69d8ff`
- Warning amber: `#ffb057`
- Critical red: `#ff4f4f`

Motion rules:

- Numeric telemetry uses `OutCubic` easing at 280-360 ms.
- Warning entry uses short vertical damping, not bounce.
- Indicators fade quickly at 120-160 ms.
- Avoid large glow blooms; the reference relies on precise luminous edges and negative space.
- Chevron tunnel lines are decorative depth cues only; they should stay low opacity and never compete with speed or warnings.

## Runtime Layers

- `VehicleData` is the single QML-facing telemetry model.
- `SerialManager` owns UART lifecycle and buffering.
- `TelemetryParser` converts protocol frames into typed vehicle state.
- `TelemetrySimulator` supplies realistic motion for bench development.
- The simulator intentionally accelerates ODO/range/SOC changes so bench testing clearly shows the battery rail draining and range estimator reacting.
- `WarningManager` evaluates severity and exposes one operator-facing warning.
- Drive modes are modeled as Eco, Sports, and City. Eco maps throttle to a logarithmic low-output curve, Sports uses an exponential-feeling response by raising low pedal inputs, and City remains linear for predictable urban control.
- QML screens consume context properties and do not parse telemetry.

## QML Layout Strategy

The primary target is fixed 800x480 with scalable ratios inside the shell canvas. The central speed readout owns the visual hierarchy. Peripheral telemetry is placed near the lower corners to avoid cluttering the operator's centerline.

## Embedded Practices

- Keep the simulator disabled for production builds or make it runtime-toggleable.
- Prefer one scene graph friendly Canvas for static HUD geometry.
- Avoid repeated expensive blur effects on Raspberry Pi.
- Keep glyph/icon usage small and deterministic.
- Use resource packaging through `resources.qrc` so deployment is a single binary plus Qt runtime.

## Raspberry Pi Notes

- Run with EGLFS or Wayland depending on the target image.
- Enable the VC4/V3D GPU driver.
- Use a 800x480 framebuffer mode to avoid compositor scaling.
- Build in release mode with LTO when available.
- Pin telemetry parsing and serial IO to C++; keep QML as presentation only.
- Preload fonts or ship embedded font assets if the target rootfs does not include Inter/Roboto Mono.
