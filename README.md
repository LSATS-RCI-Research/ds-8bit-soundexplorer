# ds-8bit-soundexplorer
A graphical interface for the "Sound Explorer" cabinet as part of the
[8-Bit Music Exhibit](https://github.com/LSATS-RCI-Research/ds-8bit-music).

## What is this repository for?
This Godot application is built to support the "Sound Explorer" custom arcade cabinet that was built for the
[8-Bit Music Exhibit](https://github.com/LSATS-RCI-Research/ds-8bit-music). The Sound Explorer cabinet has rows of
buttons and potentiometers which, via USB, send MIDI signals to two separate devices. One device runs an emulation of
[mGB](https://github.com/trash80/mGB), which produces sounds. The other device is a Windows computer running this Godot
application.

The purpose of this application is to provide context to the user on what each button and knob does, as well as offer
a fun and inviting visual experience.

**Department or unit affiliation(s):** DSI, CVGA

## How do I get set up?
1. Install [Godot 4.4](https://godotengine.org/download)
2. Open `project.godot` in Godot
3. Plug in a MIDI device to your computer
4. Run the project to verify it is working

In the project's main scene is the node "MidiLogLabel". This node prints out debug messages on the screen about the
MIDI devices and events that are detected. **This node is invisible by default.** If you need to debug the MIDI devices
that Godot is receiving, toggle "MidiLogLabel" to be visible.

## Exporting a build
Before creating a build, ensure that the project is in a state to be exported...

- Ensure that any debug features (like `MidiLogLabel`) are turned off
- Save all scenes and scripts

Then, to build...

1. Go to Project -> Export
2. Add a new export preset for Windows Desktop
3. Click "Export Project...""
4. Provide a filename and click "Save"

### Versioning
Bump the project version every time you merge changes to the main branch. In Godot, the project version can be set in
`Project -> Project Settings -> Application -> Config`. Try to follow [Semantic Versioning](https://semver.org/) (with
some flexibility since this is a standalone application). Given a version number MAJOR.MINOR.PATCH, increment the:

1. MAJOR version when you make sweeping changes, such as overhauling the interface or refactoring the main logic.
2. MINOR version when you add features or functionality.
3. PATCH version when you make bug fixes.

## Who do I talk to?
For future assistance with this program, please email: lsats-rci-research-programming@umich.edu

**Developers**
- Sean Fagan

**Other Contacts**
- Joe Bauer: Project Manager, and creator of the Sound Explorer hardware.
