import { InkEditor } from "../js/load.js";
import { registerCommand } from "../js/story.js";

function extractWrapped(html) {
  return html.match(/^<[^>]+>([^\0]*)<\/[^>]+>$/m)[1] ?? html;
}

function editorCommandBuilder({
  withCode = true,
  withPreview = true,
  readonly = true,
} = {}) {
  return (
    _,
    { start, id, "class-list": classList, "show-errors": showCompileErrors = true, lines: maxLines = 10 },
    { $text, $element, $choice },
  ) => {
    let story = extractWrapped($text);

    const controls = [];
    if (withPreview) {
      controls.push({
        key: "rewind",
        label: "restart",
        title: "Restart story from beginning",
        handler: () => editor.restartStory(true),
      });
    }

    if (withCode && !readonly) {
      controls.push({
        key: "compile",
        label: "play",
        title: "Recompile the story from the code",
        handler: () => editor.restartStory(),
      });
    }

    const editor = new InkEditor({
      withCode,
      withPreview,
      readonly,
      id,
      classList,
      maxLines,
      maxFill: true,
      start,
      showRuntimeErrors: showCompileErrors && !readonly,
      showCompileErrors,
      controls,
    })
      .mountEditor($choice ? $element.querySelector("a, span") : $element, true)
      .setStory(story)
      .startStory();
  };
}

export default function () {
  registerCommand(["editor", "read-preview"], editorCommandBuilder());
  registerCommand(
    ["editor", "only-preview"],
    editorCommandBuilder({ withCode: false }),
  );
  registerCommand(
    ["editor", "read-only"],
    editorCommandBuilder({ withPreview: false }),
  );
  registerCommand(
    ["editor", "write-preview"],
    editorCommandBuilder({ readonly: false }),
  );

  registerCommand(["note"], (_, { style }, { $element }) => {
    if ($element.children.length !== 1 || $element.firstChild.tagName.toLowerCase() !== "blockquote") {
      return new Error(`Unsupported HTML element. Please use only single "blockquote" element with the "note" tag.`);
    }
    $element.firstChild.classList.add("note");
    $element.firstChild.dataset.type = "note";
    $element.firstChild.classList.add(`note-${style}`);
    switch (style) {
      case "error":
      case "warning":
        $element.firstChild.dataset.type = style;
        break;
    }
  });
}
