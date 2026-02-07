export function compileStory(storyString, compilerOptions = undefined) {
  return new inkjs.Compiler(storyString, compilerOptions).Compile();
}

export const TAG_RESULT = Object.freeze({
  OK: 0,
  EXIT: 1,
  // BREAK: 2,
  // CONTINUE: 3,
});

/*
    {Tag}       := `{Arg} {Tag}` | `{Option} {Tag}` | `{Arg}{END}` | `{Option}{END}`
    {Arg}       := `{RawValue},{Arg}` | `{RawValue}{END}`
    {RawValue}  := `{Value}` | `"{Value}"` | `${VarName}`
    {Value}     := Number | Boolean | null | String
    {VarName}   := String that's a name of an existing INK variable
    {Option}    := `--{Name}={Arg}` | `--{Name}[]={Arg}`
    {Name}      := String satisfing /^[\w_][\w\d_-]*$/
    {END}       := `` (marks the end of section/string)

    INFO:
      - Invalid sintax may be skipped;
      - comma (,) separated {Arg} will be cast to Array if has at least 2 items;
      - Option with brackets ([]) will always be arrays and if duplicated, will be merged (instead of replaced);
*/
export function tagParser(story, tagString) {
  const tagArray = tagString.match(/(?:[^\s"]+|"[^"]*")+/g) ?? [];
  const args = [];
  const options = {};
  for (const rawValue of tagArray) {
    let matchesOption =
      typeof rawValue === "string"
        ? /^--(?<name>[\w_][\w\d_-]*)(?<brackets>\[\])?=(?<value>.*)$/g.exec(rawValue)
        : null;
    if (matchesOption == null) {
      matchesOption = { groups: { name: null, value: rawValue } };
    }
    let value = (
      typeof matchesOption.groups?.value === "string"
        ? matchesOption.groups.value
            .match(/(?:[^",]+|"[^"]*")+/g)
            .map(parseValue)
        : [parseValue(matchesOption.groups?.value)]
    ).map((fn) => fn(story));
    if (value.length === 1 && !matchesOption.groups?.brackets) {
      value = value[0];
    }
    if (matchesOption.groups?.name) {
      if (matchesOption.groups?.brackets && Array.isArray(options[matchesOption.groups.name])) {
        value = options[matchesOption.groups.name].concat(value);
      }
      options[matchesOption.groups.name] = value;
    } else {
      args.push(value);
    }
  }
  args.options = options;
  return args;
}

function parseValue(value) {
  if (typeof value === "string") {
    if (value.length >= 2 && value[0] === '"' && value.at(-1) === '"') {
      return (
        (stringVal) => () =>
          stringVal
      )(value.substring(1, value.length - 1));
    } else if (value.length >= 2 && value[0] === "$") {
      return ((varName) => (story) =>
        varName in story.variablesState
          ? story.variablesState[varName]
          : undefined)(value.substring(1));
    } else if (["true", "false"].includes(value.toLowerCase())) {
      return (
        (boolVal) => () =>
          boolVal
      )(value.toLowerCase() === "true");
    } else if (value.toLowerCase() === "null") {
      return () => null;
    }
  }
  const numberValue = Number(value);
  if (
    !isNaN(numberValue) &&
    (typeof value !== "string" || String(numberValue) === value)
  ) {
    return () => numberValue;
  }
  return () => value;
}

const commands = [];

export function registerCommand(command, handler) {
  commands.push({ command, commandAsString: String(command), handler });
}

export function executeCommandFromTag(story, tagString, context = null) {
  const tagArray = tagParser(story, tagString);
  const tagAsString = String(tagArray);
  let any = false;
  for (const { command, commandAsString, handler } of commands) {
    if (
      tagAsString.startsWith(commandAsString) &&
      (tagAsString.length === commandAsString.length ||
        tagAsString[commandAsString.length] === ",")
    ) {
      any = true;
      const codeOrError = handler(
        tagArray.slice(command.length),
        tagArray.options,
        context,
      );
      if (Number.isSafeInteger(codeOrError)) {
        return codeOrError;
      } else if (codeOrError instanceof Error) {
        console.error(codeOrError);
      }
    }
  }

  if (!any && context && context.$element) {
    const tagElement = document.createElement("span");
    tagElement.classList.add("tag");
    tagElement.textContent = `# ${tagString.trim()}`;
    context.$element.appendChild(tagElement);
  }
}
