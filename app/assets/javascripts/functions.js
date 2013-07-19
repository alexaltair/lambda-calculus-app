function main() {
  "use strict";

  function codeCogsPath(string) {
    // Replace all the '\' with '\lambda'.
    string = string.replace(/\\/g, " \\lambda ");
    // Escape the string for URIs.
    // Return it.
    return string;
  }

  function codeCogsURI(lambdaString) {
    return "http://latex.codecogs.com/gif.latex?" + codeCogsPath(lambdaString);
  }

  console.log(codeCogsURI('\\x.x\\a.bb'));

}

main();