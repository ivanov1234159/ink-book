import { registerCommand, TAG_RESULT } from "./story.js";
import { removeAll } from "./helpers.js";

export default function buildIn() {
  registerCommand(["theme", "set"], ([theme = "auto"], { save = false }) => {
    if (theme === "auto") {
      const savedTheme = window.localStorage.getItem("theme");
      theme = savedTheme || "system";
    } else if (theme === "toggle") {
      theme = document.body.classList.contains("dark")
        ? "light"
        : document.body.classList.contains("light")
          ? "dark"
          : "toggle";
    }

    if (theme === "system" || theme === "toggle") {
      const browserDark = window.matchMedia(
        "(prefers-color-scheme: dark)",
      ).matches;
      theme = browserDark === (theme === "system") ? "dark" : "light";
    } else if (theme === "saved") {
      const savedTheme = window.localStorage.getItem("theme");
      theme = savedTheme || "light";
    }

    if (theme === "dark") {
      document.body.classList.remove("light");
      document.body.classList.add("dark");
    } else if (theme === "light") {
      document.body.classList.remove("dark");
      document.body.classList.add("light");
    } else {
      return new Error(
        `Unknown theme "${theme}". Use one of "auto", "system", "saved", "toggle", "light", "dark"`,
      );
    }

    if (save) {
      window.localStorage.setItem("theme", theme);
    }
  });

  registerCommand(["class", "add"], (classes, _, { $element }) => {
    $element.classList.add(...classes);
    return TAG_RESULT.OK;
  });

  registerCommand(
    ["choice", "mark", "unclickable"],
    (_, __, { $element, $text, $choice }) => {
      if ($choice) {
        $element.innerHTML = `<span class="unclickable">${$text}</span>`;
        return TAG_RESULT.OK;
      }
      return new Error('Using "choice" tag in a non-choice context!');
    },
  );

  registerCommand(["clear"], (_, __, { $preview }) => {
    removeAll($preview, "p");
  });

  registerCommand(["restart"], (_, __, { restartStory }) => {
    restartStory(true);
    return TAG_RESULT.EXIT;
  });
}
