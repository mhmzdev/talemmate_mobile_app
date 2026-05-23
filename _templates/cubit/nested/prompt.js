const inputs = require('../../js/inputs');

module.exports = {
  // Non-interactive: hygen cubit nested myCubit --args "fetch:FlightModel,delete:FlightModel"
  prompt: ({ prompter, args }) => {
    if (args.args !== undefined) {
      const parsed = args.args.split(',').map((v) => {
        const split = v.split(':');
        return { module: split[0], model: split[1], state: split[2] };
      });
      return Promise.resolve({ args: parsed });
    }
    return prompter.prompt([inputs.nestedModule]);
  },
};
