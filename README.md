Lambda calculus engine
======================

Lambda expressions are a class. Their attributes depend on which kind they are, as defined by the following code snippet from lambda_expression.rb;

```ruby
case args.length
when 1
  @kind = :variable
  @value = node_value
when 2
  @kind = :abstraction
  @bound_var = node_value
  @body = child1
when 3
  @kind = :application
  @function = child1
  @argument = child2
```
Arguments
---------
`LambdaExpression.new()` has two modes for taking arguments; natively or naturally. I tried to make it as flexible as possible while matching expectations.

Natively it can take one, two or three arguments where one makes it a variable, two makes it an abstraction, and three makes it an application. In each case the first argument must be a symbol or string of the correct form; anything but * for variables and abstractions, and only * for applications. The other arguments can be LambdaExpressions, strings of the natural form, or symbols.

Naturally, one can just give the lambda expression written as a string, the way you might write an expression to someone over text.

Some valid examples are shown below;

This will become a variable;
```ruby
LambdaExpression.new(:x)
LambdaExpression.new('x')
```
These will become abstractions;
```ruby
LambdaExpression.new(:x, :x)
LambdaExpression.new('x', 'x')
LambdaExpression.new(:x, 'xy')
```
These will become applications;
```ruby
LambdaExpression.new(:*, :x, :y)
LambdaExpression.new('*', 'x', 'y')
LambdaExpression.new(:*, :x, '\a.bb')
```
These will be parsed as strings
```ruby
LambdaExpression.new('x')
LambdaExpression.new('xy')
LambdaExpression.new('(\x.xy)\a.bb')
LambdaExpression.new('\x.xy')
```

Being able to accept arbitrary strings means that a string parser is included.
The method `beta_reduce` will perform beta reduction, but only on the top-level application.
Methods for printing facts about lambda expressions are also included; `lambda_string_tester` for strings, and `lambda_tester` for native LambdaExpression objects.