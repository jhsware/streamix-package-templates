# Graphics Package Development

Streamix Panel is a graphics overlay software for the ATEM Mini series of video mixers. Graphics are created using packages that can be imported to your project.

This documentation explains what you can do and how to create these graphics packages.

Development requirements:
- Node.js 16 or later
- Web browser (Safari recommended, but Chrome or Edge will work in most cases)

Runtime requirements:
- ATEM Mini video mixer
- macOS 10.12 or greater on Intel or ARM (with Rosetta)
- Virtual second screen with HDMI output (connects to video mixer)
- Installed ATEM Switcher software (free download from Blackmagic Design)

Mixer setup:
- Main camera input to channel 1
- Virtual screen input to channel 4
- Streamix Panel stage in fullscreen mode on the virtual screen

You need to place the stage window on the virtual screen manually.

## Graphics Package Overview
A graphics package contains your visual components. You can composite multiple graphics packages using the Streamix Panel application. The package is implemented using web technologies and run inside a WKWebKit view. This is the same technology that powers Safari. There can be subtle differences between how Safari behaves during rendering compared to Chrome or Edge, especially when it comes to video.

A graphics package allows you to display dynamic, animated content overlaying your video feed. You can:
- Animate your components using CSS
- Pass data to your components using a form displayed in the application
- Fetch external data using Javascript fetch APIs

The main technologies used to build graphics packages are:
- Typescript -- code your components
- SASS (CSS) -- style your components
- Inferno.js -- generate your HTML

**Typescript** is a superset of Javascript. You can basically write your code in Javascript and it will work. You can also use Javascript code packages from NPM to add features to your components.

**SASS** is a convenient CSS-generating language that saves you a lot of typing. If you know CSS you basically know SASS.

**Inferno.js** is an insanely fast and lightweight React-like library that allows you to generate HTML in the browser. The library supports the original React-style with stateless function components and stateful class components. Inferno was chosen for speed and size.

There are three types of packages. They are all coded in the same way but differ in configuration:
- **graphics overlay:** used for graphics placed over the camera feed
- **fullscreen graphics overlay:** used for video playback or fullscreen graphics
- **stinger:** used for stinger transitions

## Developing a Graphics Overlay Package
1. Open a terminal and clone the template repos replacing `[name-of-your-package]`

```sh
git clone git:github.com/jhsware/bla.git [name-of-your-package]
```

2. Enter the newly created folder and install the development environment

```sh
cd [name-of-your-package]; npm i
```

3. Start the development preview page

```sh
npm run dev
```

You can now open a webpage at the address shown in the terminal to see the progress of your development. It is recomended to use Safari for preview, but both Chrome and Edge will work if nothing else is available.

### Debugging
To debug your code, use the browser debugger. You might find that using Chrome gives you a nicer debugging experience, but it is recommended that you do most of the development using Safari for preview. This way you won't get any surprising flickers that might take some time to figure out how to solve.

### Debugging in Streamix Panel
Unfortunately you can't debug the running code once imported to the Streamix Panel application. If something fails you need to figure it out in the development environment and then re-import the package to overwrite the old code.

### Developing Your Package
Take a look at the [sample packages](https://github.com/jhsware/...) for coding by example.

The most basic implementation consists of three files found in the `src/` directory:
- component.scss
- Component.tsx
- streamix_package.json

#### component.scss
This is the CSS source file using the preprocessor [SASS](https://sass-lang.com/documentation/).

We recommend that you use your package name as a base CSS-class to avoid conflicts with styling in other packages. Your file could look like this:

```scss
.name-of-your-package {
  .MyNameTag {
    /* Some styling */
  }

  .MyNameTagText {
    /* Some styling */
  }
}
```
**You need to add all of these classes to your code.**

#### Component.tsx
This is the Typescript source file. The .tsx extension allows you to write [JSX for Typescript](https://www.typescriptlang.org/docs/handbook/jsx.html). The code is written using the [library Inferno.js](https://www.infernojs.org/). Inferno.js is API-compatible with original React using stateless function components and stateful class components.

Animations can be implemented any way you want, but you get the best performance if you use CSS-animations with [inferno-animation](https://www.infernojs.org/docs/api/inferno-animation).

This file should have a single default export which is the outer most container of your code. You should also make sure you only render the content of this when this component is passed `{ isStaged: true }`. Everything else is optional, check this code example:

```jsx
export default function Container({id, name, isStaged, data}) {
  return <div className="name-of-your-package">
    {isStaged && <MyNameTag value={data} />}
  </div>
}
```

Note that you are passed four properties:
- **id:** a unique id for each instance of the package in Streamix Panel
- **name:** the package name (equivalent to [name-of-your-package] set in the configuration)
- **isStaged:** true when the component should be visible
- **data:** the form data set in Stremix Panel if you have any

#### streamix.json
You need to configure your package for Streamix Panel. Description of fields below example:

```json
{
  "__type__": "GraphicsPackage",
  "__version__": "1",
  "name": "[name-of-your-package]",
  "displayName": "[Name]",
  "description": "[Description]",
  "form": {}
}
```

- **\__type\__:** fixed field
- **\__version\__:** fixed field
- **name:** this is the unique identifier of your package, probably the same as your folder
- **displayName:** this is the name that is displayed in Streamix Panel
- **description:** a short explanation of what the package does
- **form:** optional form to be displayed for each instance in the application

#### More About Forms
Forms allow you to pass data from Streamix Panel to your graphics instance. You might want to customise the name in a name tag or add a URL for an API call. Avoid lots of form fields, this only clutters the interface.

We currently support the folowing form fields:
- **string:** allow typing text
- **video:** allow selecting the path to a video file
- **button:** add buttons that can trigger events in your component

The key of the field matches the key of the data sent to your component as the property `data`. It would be the quivalen of:

```jsx
export default function Container({id, isStaged, data}) {
  const { name } = data;

  return <div className="[name-of-your-package]">
    {isStaged && <NameTag name={name} />}
  </div>
}
```

Example of form fields (added to the form property object in streamix_package.json):

```json
{
  "name": {
    "label": "Name",
    "type": "string",
    "min": 0,
    "max": 40,
    "default": "Mr. Jones"
  },
  "videoFileName": {
    "label": "Video Name",
    "type": "video",
    "default": "video.mp4"
  },
  "singleShot": {
    "label": "Single Shot",
    "type": "button"
  }
}
```
Buttons send a pulse to your component by changing state `false -> true -> false`. To act on the leading edge of this pulse you create a class component and implement the `componentDidUpdate` method like this:

```jsx
  componentDidUpdate(lastProps) {
    const prevData = lastProps.data;
    const { data } = this.props;

    if (data.singleShot && !prevData.singleShot) {
      this._singleShotButtonWasPressed();
    }
  }
```

### Build Package for Distribution
Once you have configured your graphics package you are ready for distribution. Run the following command:

```sh
npm run build
```

The package is written to `build/[name-of-your-package]`. When you import your graphics package you select the folder `[name-of-your-package]` and this is also the folder you would compress and distribute to share it with others. A package needs to be uncompressed to be imported by Streamix Panel.

## Developing a Fullscreen Graphics Overlay
A fullscreen graphics overlay takes over the entire screen. This allows you to use any colour you want without worrying about the camera feed bleeding through.

Typical use cases are video playback, an embedded online presentation or a fullscreen sports scoreboard.

It is up to you to make sure the graphics covers the entire viewing area. Then att he following property to your `streamix_package.json` configuration:

```json
{
  "fullScreen": true
}
```

## Developing a Stinger
A stringer allows to switch between scenes using a stinger transition. When you create a stinger transition you need to animate both the entry and exit of the transition.

In the middle of the transition the entire screen needs to be covered in order to hide the cut transition that is performed in the background.

The stinger transition is built in the same way as an ordinary graphics overlay, but the `streamix_pacakge.json` configuration is slightly different:

```json
{
  "__type__": "StingerTransitionPackage",
  "__version__": "1",
  "name": "[name-of-your-package]",
  "displayName": "Name",
  "description": "Description.",
  "transitionIn": 1500,
  "transitionOut": 1500,
  "form": {}
}
```

- **\__type\__:** fixed field "StingerTransitionPackage"
- **transitionIn:** the duration of the animation until the entire screen is filled
- **transitionOut:** the duration of the animation until stinger is completely gone

The `transitionIn` sets the timining of the cut between scenes so you probably want keep the screen covered 3-500ms before and after this to avoid visual glitches if the timing is slightly off.