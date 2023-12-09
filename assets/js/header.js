const listElements = [
  [0.3, "[", ", ", "]"], // Python, Haskell, etc.
  [0.1, "[", " ", "]"], // Nix
  [0.05, "", ":", ":[]"], // Haskell
  [0.3, "{", ", ", "}"], // C, etc.
  [0.05, "Cons(", ", Cons(", ", Nil))"], // Koka
  [0.2, "[]link{", ", ", "}"], // Go
];
const elementSelectors = [
  ".header-list-start",
  ".header-list-delim",
  ".header-list-end",
];

window.onload = () => {
  let i = 0;
  let p = Math.random() - listElements[i][0];
  while (p >= 0) {
    i++;
    p -= listElements[i][0];
  }

  listElements[i].slice(1).forEach((text, index) => {
    document.querySelector(elementSelectors[index]).textContent = text;
  });
};
