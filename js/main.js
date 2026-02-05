import { InkEditor, loadManifest } from "./load.js";
import buildInCode from "./build-in.js";
import customCode from "../src/custom.js";

const manifest = await loadManifest();

if (typeof manifest.title === 'string') {
  document.title = manifest.title;
}

const files = {};
for (const { storyPath, downloadPath } of manifest.files) {
  files[storyPath] = await fetch(downloadPath, {
    cache: "no-cache",
  }).then((response) => response.text());
}

if (typeof files[manifest.main] !== "string") {
  alert(`Abort. Missing "${manifest.main}" file!`);
  throw new Error(`Abort. Missing "${manifest.main}" file!`);
}

if (typeof customCode === "function") {
  customCode();
}

buildInCode();

const editor = new InkEditor({
  withCode: false,
  withPreview: true,
  readonly: false,
  id: "root",
  maxLines: 60,
  controls: [
    {
      key: "rewind",
      label: "restart",
      title: "Restart story from beginning",
      handler: () => editor.restartStory(true),
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
})
  .mountEditor(document.body)
  .setStory(files[manifest.main], {
    fileHandler: new inkjs.JsonFileHandler(files),
  })
  .startStory();
