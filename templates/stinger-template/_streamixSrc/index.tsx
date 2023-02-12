import { render } from "inferno";
import { Editor } from "streamix-package-editor";
import * as config from "../src/streamix_package.json";
import "../src/Component";

render(<Editor config={config} />, document.getElementById('app'));
