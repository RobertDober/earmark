defmodule Ast.InlineCodeTest do
  use ExUnit.Case

  import Support.Helpers, only: [as_ast: 1]
  
  # describe "Inline Code" do

    test "plain simple" do
      markdown = "`foo`\n"
      # html     = "<p><code class=\"inline\">foo</code></p>\n"
      ast = {"p", [], [{"code", [{"class", "inline"}], ["foo"]}]}
      messages = []

      assert as_ast(markdown) == {:ok, ast, messages}
    end

    test "plain simple, right?" do
      markdown = "`hi`lo`\n"
      # html     = "<p><code class=\"inline\">hi</code>lo`</p>\n"
      ast = {"p", [], [{"code", [{"class", "inline"}], ["hi"]}, "lo`"]}
      messages = [{:warning, 1, "Closing unclosed backquotes ` at end of input"}]

      assert as_ast(markdown) == {:error, ast, messages}
    end

    test "this time you got it right" do
      markdown = "`a\nb`c\n"
      # html     = "<p><code class=\"inline\">a\nb</code>c</p>\n"
      ast = {"p", [], [{"code", [{"class", "inline"}], ["a\nb"]}, "c"]}
      messages = []

      assert as_ast(markdown) == {:ok, ast, messages}
    end

    test "and again!!!" do
      markdown = "+ ``a `\n`\n b``c"
      # html = "<ul>\n<li><code class=\"inline\">a `\n`\n b</code>c\n</li>\n</ul>\n"
      ast = {"ul", [], [{"li", [], [{"code", [{"class", "inline"}], ["a `\n`\n b"]}, "c"]}]}
      messages = []
      assert as_ast(markdown) == {:ok, ast, messages}
    end
  # end
end
