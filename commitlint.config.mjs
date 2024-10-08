export default {
  extends: ["@commitlint/config-conventional"],
  rules: {
    "scope-enum": [
      2,
      "always",
      ["readme", "user", "host", "tasks", "templates", "ags", "commitlint"],
    ],
    "body-max-line-length": [2, "always", 240],
  },
};
