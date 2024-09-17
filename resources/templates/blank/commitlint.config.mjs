export default {
  extends: ["@commitlint/config-conventional"],
  rules: {
    "scope-enum": [2, "always", ["readme", "tasks", "commitlint"]],
    "body-max-line-length": [2, "always", 240],
  },
};
