import { render } from "inferno";
import { Editor } from "streamix-package-editor/dist/main.js";
import * as config from "../src/streamix_package.json";
import "./package";

if (process.env["NODE_ENV"] !== "production") {
  render(<Editor config={config} />, document.getElementById('app'));
}
