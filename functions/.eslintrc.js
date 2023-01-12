module.exports = {
    root: true,
    env: {
        es6: true,
        node: true,
    },
    extends: ["eslint:recommended", "google"],
    rules: {
        "quotes": ["error", "double"],
        "require-jsdoc": "off",
        "indent": ["error", 4],
        "object-curly-spacing": ["error", "always"],
    },
    parserOptions: {
        sourceType: "module",
    },
};
