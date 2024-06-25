export default {
  extends: ["@commitlint/config-conventional"],
  rules: {
    "scope-enum": [
      2,
      "always",
      ["readme", "user", "host", "just", "justfile", "alejandra"],
    ],
  },
};
