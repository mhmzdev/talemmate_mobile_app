const inputs = require('../../js/inputs');

// Recipe for nested root state
// 1) class WowState extends Equatable {
// 2) const WowState({
// 3) List<Object> get props => [
// 4) WowState copyWith({
// 5) return WowState(
// 6) : super(

module.exports = {
  // Non-interactive: hygen cubit update myCubit --args "fetch:NewModel,update:AnotherModel"
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
