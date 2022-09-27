# Streamix Graphics Package Templates

Streamix Panel is a graphics overlay software for the ATEM Mini series of video mixers. Graphics are created using packages that can be imported to your project.

## Requirements

- macOS
- Safari
- Node.js >=16
- Git (optional)

You might choose Chrome during debugging, but Safari uses the same rendering engine as Streamix Panel.

Git is recommended for version control. Any development without version control quickly becomes painful.

## Get started

There are three types of packages. They are all coded in the same way but differ in configuration:
- **graphics overlay:** used for graphics placed over the camera feed
- **fullscreen graphics overlay:** used for video playback or fullscreen graphics
- **stinger:** used for stinger transitions

Details about development is provided in the README.md of the created package.

1. Run the package creation script

```sh
source <(curl -s https://raw.githubusercontent.com/jhsware/streamix-package-templates/master/bin/install.sh) && ./create.sh
```

2. Follow the instructions

3. Start coding!


## Examples
You can view and download example code from: https://github.com/jhsware/streamix-package-examples