import { compileStory, executeCommandFromTag } from "./story.js";

const pathJoin = (...parts) =>
  parts
    .join("/")
    .replace(/\/+/g, "/")
    .replace(/\/[^/]+\/\.\.\//g, "/");

export async function loadManifest() {
  const manifest = JSON.parse(
    await fetch("src/manifest.json", {
      cache: "no-cache",
    }).then((response) => response.text())
  );

  return {
    ...manifest,
    files:
      manifest.files?.map((path) => ({
        storyPath: path,
        downloadPath: pathJoin("src/", path),
      })) ?? [],
  };
}

async function scanDirDeep(path) {
  const paths = [];
  try {
    const srcDoc = new DOMParser().parseFromString(
      await (await fetch(path)).text(),
      "text/html"
    );
    for (const item of srcDoc.querySelectorAll("ul > li > a[href]")) {
      const itemPath = item.getAttribute("href");
      if (itemPath.endsWith(".ink")) {
        paths.push(pathJoin(path, itemPath));
      } else {
        paths.push(...(await scanDirDeep(pathJoin(path, itemPath))));
      }
    }
  } catch (e) {
    console.error(e);
  }
  return paths;
}
//await scanDirDeep(pathJoin(location.pathname, "src/"));

function escapeHtml(html) {
  const p = document.createElement("p");
  p.appendChild(document.createTextNode(html));
  return p.innerHTML;
}

function unescapeHtml(html) {
  const textarea = document.createElement("textarea");
  textarea.innerHTML = html;
  return textarea.value;
}

export function createEditor(
  rootElement,
  storyString,
  inkCompilerOptions = undefined,
  editorOptions = undefined
) {
  return new InkEditor(editorOptions)
    .mountEditor(rootElement)
    .setStory(storyString, inkCompilerOptions)
    .startStory();
}

class InkEditor {
  $editor;
  $story;
  $code;
  $preview;
  $controls;
  _controls = [];
  _lastInkCompilerOptions = undefined;

  constructor(editorOptions = undefined) {
    this.$editor = document.createElement("div");
    this.$editor.classList.add("editor");
    this.$editor.innerHTML = `
<div class="controls"></div>
${
  editorOptions?.withCode
    ? `<ol class="editor-code" ${
        editorOptions?.readonly ? "" : "contenteditable"
      }><li spellcheck="false"><br></li></ol>`
    : ""
}
${editorOptions?.withPreview ? `<div class="editor-preview"></div>` : ""}`;

    this.$controls = this.$editor.querySelector(".controls");
    this.$code = this.$editor.querySelector(".editor-code");
    this.$preview = this.$editor.querySelector(".editor-preview");

    // this.$controls.innerHTML = '';
    if (Array.isArray(editorOptions?.controls)) {
      for (const { key, label, title, handler } of editorOptions.controls) {
        const controlElement = document.createElement(typeof handler === "function" ? "a" : "span");
        controlElement.classList.add(key);
        controlElement.innerHTML = label ?? key;
        if (typeof title === "string" && title.length > 0) {
          controlElement.setAttribute("title", title);
        }

        if (typeof handler === "function") {
          controlElement.addEventListener("click", handler);
        } else {
          controlElement.classList.add("unclickable");
        }
        this.$controls.appendChild(controlElement);
      }

      this._controls = editorOptions.controls;
    }
  }

  mountEditor(rootElement) {
    if (!this.$editor.parentNode) {
      rootElement.appendChild(this.$editor);
    }

    return this;
  }

  setStory(storyString, inkCompilerOptions = undefined) {
    if (this.$code) {
      this.$code.innerHTML = storyString
        .split("\n")
        .map((item) =>
          item === ""
            ? '<li spellcheck="false"><br></li>'
            : `<li spellcheck="false">${escapeHtml(item)}</li>`
        )
        .join("\n");
    }

    this.$story = compileStory(storyString, inkCompilerOptions);
    this._lastInkCompilerOptions = inkCompilerOptions;
    return this;
  }

  startStory() {
    if (!this.$story) {
      return this;
    }

    executeCommandFromTag(this.$story, "theme set auto", { ...this });
    // Global tags - those at the top of the ink file
    if (this.$story.globalTags != null) {
      for (const tagString of this.$story.globalTags) {
        executeCommandFromTag(this.$story, tagString, { ...this });
      }
    }

    return this;
  }

  restartStory() {
    if (this.$code) {
      const storyString = Array.from(this.$code.children)
        .map((item) =>
          item.innerHTML === "<br>" ? "" : unescapeHtml(item.innerHTML)
        )
        .join("\n");
      this.setStory(storyString, this._lastInkCompilerOptions);
    }

    this.startStory();
  }
}
