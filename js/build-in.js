import { registerCommand, TAG_RESULT } from "./story.js";
import { removeAll } from "./helpers.js";

export default function buildIn() {
  registerCommand(["theme", "set"], ([theme = "auto"]) => {
    if (theme === "auto") {
      const savedTheme = window.localStorage.getItem("theme");
      theme = savedTheme || "system";
    }

    if (theme === "system") {
      const browserDark = window.matchMedia(
        "(prefers-color-scheme: dark)"
      ).matches;
      theme = browserDark ? "dark" : "light";
    } else if (theme === "saved") {
      const savedTheme = window.localStorage.getItem("theme");
      theme = savedTheme || "light";
    }

    if (theme === "dark") {
      document.body.classList.add("dark");
      document.body.classList.remove("light");
    } else if (theme === "light") {
      document.body.classList.add("light");
      document.body.classList.remove("dark");
    } else {
      return new Error(
        `Unknown theme "${theme}". Use one of "auto", "system", "saved", "light", "dark"`
      );
    }
  });

  registerCommand(["class", "add"], (classes, _, { $element }) => {
    $element.classList.add(...classes);
    return 0;
  });

  registerCommand(
    ["choice", "mark", "unclickable"],
    (_, __, { $element, $text, $choice }) => {
      if ($choice) {
        $element.innerHTML = `<span class="unclickable">${$text}</span>`;
        return 0;
      }
      return new Error('Using "choice" tag in a non-choice context!');
    }
  );

  registerCommand(["clear"], (_, __, { $preview }) => {
    removeAll($preview, "p");
  });

  registerCommand(["restart"], (_, __, { restartStory }) => {
    restartStory(true);
    return TAG_RESULT.EXIT;
  });
}
