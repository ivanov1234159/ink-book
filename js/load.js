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
  stroyCompilerOptions = undefined,
  editorOptions = undefined
) {
  const editorElement = document.createElement("div");
  editorElement.classList.add("editor");
  editorElement.innerHTML = `
<div class="controls">
    <a class="rewind" title="Restart story from beginning">restart</a>
    <a class="theme-switch" title="Switch theme">theme</a>
</div>
${editorOptions?.withCode ? `<ol class="editor-code" ${editorOptions?.readonly ? '' : 'contenteditable'}><li spellcheck="false"><br></li></ol>` : ''}
${editorOptions?.withPreview ? `<div class="editor-preview"></div>` : ''}`;
  rootElement.appendChild(editorElement);

  const codeElement = editorElement.querySelector(".editor-code");
  if (codeElement) {
    codeElement.innerHTML = storyString
        .split("\n")
        .map((item) => (item === "" ? "<li spellcheck=\"false\"><br></li>" : `<li spellcheck="false">${escapeHtml(item)}</li>`))
        .join("\n");
  }

  const previewElement = editorElement.querySelector(".editor-preview");

  // Create ink story from the content using inkjs
  const story = compileStory(storyString, stroyCompilerOptions);

  executeCommandFromTag(story, "theme set auto", {$preview: previewElement});
  // Global tags - those at the top of the ink file
  if (story.globalTags != null) {
    for (const tagString of story.globalTags) {
      executeCommandFromTag(story, tagString, {$preview: previewElement});
    }
  }

  return { $editor: editorElement, $story: story, $preview: previewElement };
}
