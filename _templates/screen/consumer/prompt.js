const inputs = require('../../js/inputs');

module.exports = {
  // Non-interactive: hygen screen consumer my_screen --arg "auth:login:login"
  prompt: ({ prompter, args }) => {
    if (args.arg !== undefined) {
      const split = args.arg.split(':');
      return Promise.resolve({
        arg: { cubit: split[0], module: split[1], state: split[2] },
      });
    }
    return prompter.prompt([inputs.screenCrudUI]);
  },
};


