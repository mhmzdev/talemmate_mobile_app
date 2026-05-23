const inputs = require('../../js/inputs');

module.exports = {
  // Non-interactive: hygen screen _widget my_screen --widgets "Header,Footer,Card"
  prompt: ({ prompter, args }) => {
    if (args.widgets !== undefined) {
      return Promise.resolve({
        widgets: args.widgets
          ? args.widgets.split(',').map((w) => w.trim())
          : [],
      });
    }
    return prompter.prompt([inputs.widgetNames]);
  },
};
