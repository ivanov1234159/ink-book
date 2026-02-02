import { createEditor, loadManifest } from "./load.js";
import { continueStory } from "./story.js";
import buildInCode from "./build-in.js";
import customCode from "../src/custom.js";
import { removeAll } from "./helpers.js";

const manifest = await loadManifest();

const files = {};
for (const {storyPath, downloadPath} of manifest.files) {
  files[storyPath] = await fetch(downloadPath, {
    cache: 'no-cache',
  }).then((response) => response.text());
}

if (typeof files['main.ink'] !== 'string') {
    alert('Abort. Missing "main.ink" file!');
    throw new Error('Abort. Missing "main.ink" file!');
}

if (typeof customCode === 'function') {
  customCode();
}

buildInCode();

const editor = createEditor(
  document.body,
  files["main.ink"],
  { fileHandler: new inkjs.JsonFileHandler(files) },
  {
    withCode: true,
    withPreview: true,
    readonly: false,
    controls: [
      {
        key: "rewind",
        label: "restart",
        title: "Restart story from beginning",
        handler: restart,
      },
      {
        key: "theme-switch",
        label: "theme",
        title: "Switch theme",
        handler: () => {
          document.body.classList.toggle("dark");
          window.localStorage.setItem(
            "theme",
            document.body.classList.contains("dark") ? "dark" : "light"
          );
        },
      },
    ],
  }
);

// Kick off the start of the story!
restart();

function restart() {
  removeAll(editor.$preview, "p");
  editor.$story.ResetState();
  continueStory(editor.$story, editor.$preview, true);
}
