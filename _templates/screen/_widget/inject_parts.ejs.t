---
inject: true
to: "lib/ui/screens/<%= h.changeCase.snake(name) %>/<%= h.changeCase.snake(name) %>.dart"
skip_if: "part 'widgets/_<%= h.changeCase.snake(widgets[0]) %>.dart';"
after: "part '_state.dart';"
---
<% widgets.forEach(function(widget) { %>part 'widgets/_<%= h.changeCase.snake(widget) %>.dart';
<% }); %>
