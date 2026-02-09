import { compileStory, executeCommandFromTag, TAG_RESULT } from "./story.js";
import {
  contentBottomEdgeY,
  pathJoin,
  removeAll,
  scrollDown,
  shallowClone,
  showAfter,
  createNote,
} from "./helpers.js";

export async function loadManifest() {
  const manifest = JSON.parse(
    await fetch("src/manifest.json", {
      cache: "no-cache",
    }).then((response) => response.text()),
  );

  return {
    ...manifest,
    main: manifest.main ?? "main.ink",
    files:
      manifest.files?.map((path) => ({
        storyPath: path,
        downloadPath: pathJoin("src/", path),
      })) ?? [],
  };
}

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

export class InkEditor {
  $editor;
  $story;
  $code;
  $preview;
  $errors;
  $controls;
  _controls = [];
  _editorOptions = undefined;
  _lastInkCompilerOptions = undefined;

  constructor(editorOptions = undefined) {
    this.$editor = document.createElement("div");
    this.$editor.classList.add(
      "editor",
      ...(Array.isArray(editorOptions.classList)
        ? editorOptions.classList
        : []),
    );
    if (
      Number.isSafeInteger(editorOptions.maxLines) &&
      editorOptions.maxLines > 0
    ) {
      this.$editor.style.setProperty(
        "--editor-lines-count-max",
        editorOptions.maxLines,
      );
    }
    if (typeof editorOptions.id === "string" && editorOptions.id.length > 0) {
      this.$editor.id = editorOptions.id;
    }
    this.$editor.innerHTML = `
<div class="controls"></div>
${
  editorOptions?.withCode
    ? `<div class="editor-code-wrapper"><ol class="editor-code sibling-index${editorOptions.maxFill ? " max-fill" : ""}" ${
        editorOptions?.readonly ? "" : 'contenteditable="true"'
      }><li spellcheck="false"><br></li></ol></div>`
    : ""
}
${editorOptions?.withPreview ? `<div class="editor-preview"></div>` : ""}
<div class="editor-errors"></div>`;

    this.$controls = this.$editor.querySelector(".controls");
    this.$code = this.$editor.querySelector(".editor-code");
    this.$preview = this.$editor.querySelector(".editor-preview");
    this.$errors = this.$editor.querySelector(".editor-errors");

    // this.$controls.innerHTML = '';
    if (Array.isArray(editorOptions?.controls)) {
      for (let i = editorOptions.controls.length - 1; i >= 0; i--) {
        const { key, label, title, handler } = editorOptions.controls[i] ?? {};
        const controlElement = document.createElement(
          typeof handler === "function" ? "a" : "span",
        );
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

    this._editorOptions = editorOptions;
  }

  mountEditor(rootElement, clear = false) {
    if (!this.$editor.parentNode) {
      if (clear) {
        rootElement.innerHTML = "";
      }
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
            : `<li spellcheck="false">${escapeHtml(item)}</li>`,
        )
        .join("\n");
    }

    if (typeof this._editorOptions?.start === "string") {
      storyString = `->${this._editorOptions.start}\n${storyString}`;
    }

    this.$story = null;
    try {
      this.$story = compileStory(storyString, inkCompilerOptions);
      this.$story.onError = (message, errorType) => {
        this.$errors.appendChild(
          createNote(message, errorType === 1 ? "warning" : "error"),
        );
      };
    } catch (e) {
      this.$errors.appendChild(createNote(e.message, "error"));
    }
    this._lastInkCompilerOptions = inkCompilerOptions;
    return this;
  }

  startStory() {
    if (!this.$story) {
      return this;
    }

    executeCommandFromTag(this.$story, "theme set auto", shallowClone(this));
    // Global tags - those at the top of the ink file
    if (this.$story.globalTags != null) {
      for (const tagString of this.$story.globalTags) {
        executeCommandFromTag(this.$story, tagString, shallowClone(this));
      }
    }

    this.restartStory(true);
    return this;
  }

  restartStory(soft = false) {
    if (soft) {
      if (this.$preview) {
        removeAll(this.$preview, "p");
      }

      if (this.$story) {
        this.$story.ResetState();
        this.continueStory(true);
      }
      return;
    }
    this.$errors.innerHTML = '';

    if (this.$code) {
      const storyString = Array.from(this.$code.children)
        .map((item) =>
          item.innerHTML === "<br>" ? "" : unescapeHtml(item.innerHTML),
        )
        .join("\n");
      this.setStory(storyString, this._lastInkCompilerOptions);
    }

    this.startStory();
  }

  triggerControl(key) {
    const control = this._controls.find((control) => control.key === key);
    if (control && typeof control.handler === "function") {
      control.handler();
    }
  }

  triggerTag(tagString, extraContext = {}) {
    return executeCommandFromTag(
      this.$story,
      tagString,
      shallowClone(this, extraContext),
    );
  }

  // Main story processing function. Each time this is called it generates
  // all the next content up as far as the next set of choices.
  continueStory(firstTime = false) {
    let delay = 0.0;

    // Don't over-scroll past new content
    const previousBottomEdge = firstTime
      ? 0
      : contentBottomEdgeY(this.$preview);

    // Generate story text - loop through available content
    while (this.$story.canContinue) {
      // Create paragraph element (initially hidden)
      let paragraphElement = document.createElement("p");
      // Get ink to generate the next paragraph
      let text = this.$story.Continue();
      paragraphElement.innerHTML = text;

      // Any special tags included with this line
      for (const tag of this.$story.currentTags) {
        const tagResult = executeCommandFromTag(
          this.$story,
          tag,
          shallowClone(this, {
            $element: paragraphElement,
            $text: text,
          }),
        );

        if (tagResult === TAG_RESULT.EXIT) {
          return;
        }
      }

      // Check if text is empty
      if (text.trim().length == 0 || !this.$preview) {
        continue; // Skip empty paragraphs
      }
      this.$preview.appendChild(paragraphElement);

      // Fade in paragraph after a short delay
      showAfter(delay, paragraphElement);
      delay += 200.0;
    }

    // Create HTML choices from ink choices
    for (const choice of this.$story.currentChoices) {
      // Create paragraph with anchor element
      const choiceParagraphElement = document.createElement("p");
      choiceParagraphElement.classList.add("choice");
      choiceParagraphElement.innerHTML = `<a href="#">${choice.text}</a>`;
      for (const choiceTag of choice.tags) {
        const tagResult = executeCommandFromTag(
          this.$story,
          choiceTag,
          shallowClone(this, {
            $element: choiceParagraphElement,
            $text: choice.text,
            $choice: shallowClone(choice),
          }),
        );

        if (tagResult === TAG_RESULT.EXIT) {
          return;
        }
      }

      // Check if choice.text is empty
      if (choice.text.trim().length == 0 || !this.$preview) {
        continue; // Skip empty choices
      }

      this.$preview.appendChild(choiceParagraphElement);

      // Fade choice in after a short delay
      showAfter(delay, choiceParagraphElement);
      delay += 200.0;

      // Click on choice
      const choiceAnchorEl = choiceParagraphElement.querySelector("a");
      if (choiceAnchorEl) {
        choiceAnchorEl.addEventListener("click", (event) => {
          // Don't follow <a> link
          event.preventDefault();

          // Extend height to fit
          // We do this manually so that removing elements and creating new ones doesn't
          // cause the height (and therefore scroll) to jump backwards temporarily.
          this.$preview.style.height = contentBottomEdgeY(this.$preview) + "px";

          // Remove all existing choices
          removeAll(this.$preview, ".choice");

          // Tell the story where to go next
          this.$story.ChooseChoiceIndex(choice.index);

          // Aaand loop
          this.continueStory();
        });
      }
    }

    if (this.$preview) {
      // Unset $preview's height, allowing it to resize itself
      this.$preview.style.height = "";

      if (!firstTime) {
        scrollDown(this.$preview, previousBottomEdge);
      } else {
        this.$preview.scrollTo(0, 0);
      }
    }
  }
}
