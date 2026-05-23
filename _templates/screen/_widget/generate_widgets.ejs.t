---
sh: |
  mkdir -p "lib/ui/screens/<%= h.changeCase.snake(name) %>/widgets"
  <% widgets.forEach(function(widget) { %>
  cat > "lib/ui/screens/<%= h.changeCase.snake(name) %>/widgets/_<%= h.changeCase.snake(widget) %>.dart" << 'EOF' 2>/dev/null
  part of '../<%= h.changeCase.snake(name) %>.dart';

  class _<%= h.changeCase.pascal(widget) %> extends StatelessWidget {
    const _<%= h.changeCase.pascal(widget) %>();

    @override
    Widget build(BuildContext context) {
      return Container();
    }
  }
  EOF
  <% }); %>
---
