import { InkEditor } from "../js/load.js";
import { registerCommand } from "../js/story.js";

function extractWrapped(html) {
  const temp = document.createElement("div");
  temp.innerHTML = html;
  return temp.firstChild.innerHTML;
}

function editorCommandBuilder({
  withCode = true,
  withPreview = true,
  readonly = true,
} = {}) {
  return (_, { start, id, 'class-list': classList }, { $text, $element, $choice }) => {
    let story = extractWrapped($text);
    if (typeof start === "string" && start.length > 0) {
      story = `->${start}\n${story}`;
    }

    const editor = new InkEditor({
      withCode,
      withPreview,
      readonly,
      id,
      classList,
      maxLines: 10,
      maxFill: true,
      controls: withPreview ? [
        {
          key: "rewind",
          label: "restart",
          title: "Restart story from beginning",
          handler: () => editor.restartStory(true),
        },
      ] : undefined,
    })
      .mountEditor($choice ? $element.querySelector('a, span') : $element, true)
      .setStory(story)
      .startStory();
  };
}

export default function () {
  registerCommand(["editor", "read-preview"], editorCommandBuilder());
  registerCommand(["editor", "only-preview"], editorCommandBuilder({withCode: false}));
  registerCommand(["editor", "read-only"], editorCommandBuilder({withPreview: false}));
  // registerCommand(["editor", "write-preview"], editorCommandBuilder({readonly: false}));

  registerCommand(["note"], (_, {style}, {$element}) => {
    // TODO: Implement
  });
}
