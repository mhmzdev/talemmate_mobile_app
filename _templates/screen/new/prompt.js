// see types of prompts:
// https://github.com/enquirer/enquirer/tree/master/examples
//

module.exports = {
  prompt: ({ prompter, args }) => {
    // Non-interactive: hygen screen new my_screen --formData false
    //                  hygen screen new my_screen --formData true --formKeys "email,name" --widgets "header"
    if (args.formData !== undefined) {
      return Promise.resolve({
        formData: args.formData === 'true',
        formKeys: args.formKeys ? args.formKeys.split(',') : [],
        widgets: args.widgets ? args.widgets.split(',') : [],
      });
    }
    return prompter.prompt([
      {
        type: 'confirm',
        name: 'formData',
        default: false,
        message: 'Does this screen have forms?',
      },
      {
        type: 'input',
        name: 'formKeys',
        message: 'Write the name of form keys in comma separated values.',
        result: (data) => {
          if (!data) return [];
          return data.split(',');
        },
      },
      {
        type: 'input',
        name: 'widgets',
        message: 'Write the name of widgets in comma separated values.',
        result: (data) => {
          if (!data) return [];
          return data.split(',');
        },
      },
    ]);
  },
};


