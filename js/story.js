import { contentBottomEdgeY, removeAll, scrollDown, showAfter } from "./helpers.js";

export function compileStory(storyString, compilerOptions = undefined) {
    return new inkjs.Compiler(storyString, compilerOptions).Compile();
}

/*
    {Tag}       := `{Arg} {Tag}` | `{Option} {Tag}` | `{Arg}{END}` | `{Option}{END}`
    {Arg}       := `{RawValue},{Arg}` | `{RawValue}{END}`
    {RawValue}  := `{Value}` | `"{Value}"` | `${VarName}`
    {Value}     := Number | Boolean | null | String
    {VarName}   := String that's a name of an existing INK variable
    {Option}    := `{Name}={Arg}`
    {Name}      := String satisfing /^[\w_][\w\d_-]*$/
    {END}       := `` (marks the end of section/string)

    INFO: Invalid sintax may be skipped; comma (,) separated {Arg} will be cast to Array if has at least 2 items
*/
export function tagParser(story, tagString) {
    const tagArray = tagString.match(/(?:[^\s"]+|"[^"]*")+/g) ?? [];
    const args = [];
    const options = {};
    for(const rawValue of tagArray) {
        let matchesOption = typeof rawValue === 'string' ? /^(?<name>[\w_][\w\d_-]*)=(?<value>.*)$/g.exec(rawValue) : null;
        if (matchesOption == null) {
            matchesOption = {groups: {name: null, value: rawValue}};
        }
        let value = (typeof matchesOption.groups?.value === 'string'
            ? matchesOption.groups.value.match(/(?:[^",]+|"[^"]*")+/g).map(parseValue)
            : [parseValue(matchesOption.groups?.value)])
            .map(fn => fn(story));
        if (value.length === 1) {
            value = value[0];
        }
        if (matchesOption.groups?.name) {
            options[matchesOption.groups.name] = value;
        } else {
            args.push(value);
        }
    }
    args.options = options;
    return args;
}

function parseValue(value) {
    if (typeof value === 'string') {
        if (value.length >= 2 && value[0] === '"' && value.at(-1) === '"') {
            return ((stringVal) => (() => stringVal))(value.substring(1, value.length - 1));
        } else if (value.length >= 2 && value[0] === '$') {
            return ((varName) => ((story) => varName in story.variablesState ? story.variablesState[varName] : undefined))(value.substring(1));
        } else if (['true', 'false'].includes(value.toLowerCase())) {
            return ((boolVal) => (() => boolVal))(value.toLowerCase() === 'true');
        } else if (value.toLowerCase() === 'null') {
            return () => null;
        }
    }
    const numberValue = Number(value);
    if (!isNaN(numberValue) && (typeof value !== 'string' || String(numberValue) === value)) {
        return () => numberValue;
    }
    return () => value;
}

const commands = [];

export function registerCommand(command, handler) {
    commands.push({command, commandAsString: String(command), handler});
}

export function executeCommandFromTag(story, tagString, context = null) {
    const tagArray = tagParser(story, tagString);
    const tagAsString = String(tagArray);
    for (const {command, commandAsString, handler} of commands) {
        if (tagAsString.startsWith(commandAsString) && (tagAsString.length === commandAsString.length || tagAsString[commandAsString.length] === ',')) {
            const codeOrError = handler(tagArray.slice(command.length), tagArray.options, context);
            if (Number.isSafeInteger(codeOrError)) {
                return codeOrError;
            } else if (codeOrError instanceof Error) {
                console.error(codeOrError);
            }
        }
    }
}

// Main story processing function. Each time this is called it generates
// all the next content up as far as the next set of choices.
export function continueStory(story, storyContainer, firstTime) {
  let delay = 0.0;

  // Don't over-scroll past new content
  const previousBottomEdge = firstTime ? 0 : contentBottomEdgeY(storyContainer);

  // Generate story text - loop through available content
  while (story.canContinue) {
    // Create paragraph element (initially hidden)
    let paragraphElement = document.createElement("p");
    // Get ink to generate the next paragraph
    let text = story.Continue();
    paragraphElement.innerHTML = text;

    // Any special tags included with this line
    for (const tag of story.currentTags) {
      executeCommandFromTag(story, tag, {$preview: storyContainer, $element: paragraphElement, $text: text});

      // CLEAR - removes all existing content.
      // RESTART - clears everything and restarts the story from the beginning
      if (tag == "CLEAR") {
        removeAll(storyContainer, "p");
      } else if (tag == "RESTART") {
        removeAll(storyContainer, "p");
        story.ResetState();
        continueStory(story, storyContainer, true);
        return;
      }
    }

    // Check if text is empty
    if (text.trim().length == 0) {
      continue; // Skip empty paragraphs
    }
    storyContainer.appendChild(paragraphElement);

    // Fade in paragraph after a short delay
    showAfter(delay, paragraphElement);
    delay += 200.0;
  }

  // Create HTML choices from ink choices
  story.currentChoices.forEach(choice => {
    // Create paragraph with anchor element
    const choiceParagraphElement = document.createElement("p");
    choiceParagraphElement.classList.add("choice");
    choiceParagraphElement.innerHTML = `<a href="#">${choice.text}</a>`;
    for (const choiceTag of choice.tags) {
      executeCommandFromTag(story, choiceTag, {$preview: storyContainer, $element: choiceParagraphElement, $text: choice.text, $choice: choice});
    }

    storyContainer.appendChild(choiceParagraphElement);

    // Fade choice in after a short delay
    showAfter(delay, choiceParagraphElement);
    delay += 200.0;

    // Click on choice
    const choiceAnchorEl = choiceParagraphElement.querySelector('a');
    if (choiceAnchorEl) {
      choiceAnchorEl.addEventListener("click", event => {
        // Don't follow <a> link
        event.preventDefault();

        // Extend height to fit
        // We do this manually so that removing elements and creating new ones doesn't
        // cause the height (and therefore scroll) to jump backwards temporarily.
        storyContainer.style.height = contentBottomEdgeY(storyContainer) + "px";

        // Remove all existing choices
        removeAll(storyContainer, ".choice");

        // Tell the story where to go next
        story.ChooseChoiceIndex(choice.index);

        // Aaand loop
        continueStory(story, storyContainer);
      });
    }
  });

  // Unset storyContainer's height, allowing it to resize itself
  storyContainer.style.height = "";

  if (!firstTime) {
    scrollDown(storyContainer, previousBottomEdge);
  } else {
    storyContainer.scrollTo(0, 0);
  }
}