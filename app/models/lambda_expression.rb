# Finds the matching close parent. Assumes that the opening paren is NOT part of the string; assumes 'blah)' rather than '(blah)'.
def close_paren_index(string)
  array = string.split('')
  depth = 1
  index = 0
  array.each_with_index do |char, index|
    if char == ')'
      depth -= 1
      return index if depth == 0
    elsif char == '('
      depth += 1
    end
  end
  raise "Mismatching parentheses."
end

class LambdaExpression < ActiveRecord::Base

  # Change the setters so that attributes cannot be changed to make a meaningless lambda expression.
  attr_accessor :kind, :value, :bound_var, :body, :function, :argument

  def initialize(*args)

    args.compact!

    if args.length == 1 && args[0].is_a?(String)
      args = LambdaExpression.string_to_lambda_args(args[0])
    end

    if args.length <= 3
      node_value, child1, child2 = args
    else raise ArgumentError, "Number of arguments must be 3 or less."
    end

    if node_value.is_a?(String)
      node_value.to_sym
    end

    if node_value.is_a?(Symbol)
      raise ArgumentError, "Literal variables should be only one character. Passing an entire expression as a string should take no other arguments." unless node_value.length == 1
      if node_value == :*
        raise ArgumentError, "Application needs three arguments." unless args.length == 3
        child1 = LambdaExpression.new(child1) unless child1.is_a?(LambdaExpression)
        child2 = LambdaExpression.new(child2) unless child2.is_a?(LambdaExpression)
      elsif args.length == 2
        child1 = LambdaExpression.new(child1) unless child1.is_a?(LambdaExpression)
      elsif args.length == 3 then raise ArgumentError, "First argument should be :*, or too many arguments."
      end # No else here, because we want the remaining cases of args.length == 1 to drop down into the case statement to become :variable LambdaExpressions!
    else raise ArgumentError, "First argument is not a symbol."
    end

    # At this point the first argument should be a symbol, and the rest LambdaExpressions.

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
    else raise ArgumentError, "Wrong number of arguments. (Should be caught earlier.)"
    end

  end


  def to_s
    case self.kind
    when :variable then self.value.to_s
    when :abstraction then "\\#{self.bound_var}.#{self.body}"
    when :application
      function_string = "#{self.function}"
      argument_string = "#{self.argument}"
      if self.function.kind == :abstraction
        function_string = "(" + function_string + ")"
      end
      unless self.argument.kind == :variable
        argument_string = "(" + argument_string + ")"
      end
      return function_string + argument_string
    end
  end

  # Doesn't take care of double parens '((a))' or empty parens 'a()'
  def self.group_by_parens(string)
    array = []
    while string.length > 0
      if string[0] == '('
        string = string[1..-1]
        paren = close_paren_index(string)
        array << string[0...paren]
        string = string[(paren+1)..-1]
      elsif string[0] == '\\'
        array << string
        string = ''
      else
        array << string[0]
        string = string[1..-1]
        # This implies that varaibles cannot be longer than one character.
      end
    end
    array
  end

  def self.string_to_lambda_args(string)
    array = group_by_parens(string)
    if array.length == 1
      string = array[0]
      if string[0] == '\\'
        return string[1].to_sym, string[3..-1]
      else return string.to_sym # Symbols are required to be only one character; this is enforced later in the initializer.
      end
    else
      last = array.pop
      array.map! { |element| LambdaExpression.new(element) }
      penultimate = array.inject do |function, next_arg|
        LambdaExpression.new(:*, function, next_arg)
      end
      return :*, penultimate, last
    end
  end

  # I stole this from the iternet, but understand how it works and tested it.
  def deep_clone
    return @deep_cloning_obj if @deep_cloning
    @deep_cloning_obj = clone
    @deep_cloning_obj.instance_variables.each do |var|
      val = @deep_cloning_obj.instance_variable_get(var)
      begin
        @deep_cloning = true
        val = val.deep_clone
      rescue TypeError, NoMethodError
        next
      ensure
        @deep_cloning = false
      end
      @deep_cloning_obj.instance_variable_set(var, val)
    end
    deep_cloning_obj = @deep_cloning_obj
    @deep_cloning_obj = nil
    deep_cloning_obj
  end

  def beta_reduce
    copy = self.deep_clone
    unless (copy.kind == :application) && (copy.function.kind == :abstraction)
      return copy
    end
    replacement = copy.argument
    bound_variable = copy.function.bound_var

    def substitute(bound_variable, replacement)
      if self.kind == :variable
        if self.value == bound_variable
          return replacement
        else
          return self
        end
      elsif self.kind == :abstraction
        self.body = self.body.substitute(bound_variable, replacement)
        return self
      elsif self.kind == :application
        self.function = self.function.substitute(bound_variable, replacement)
        self.argument = self.argument.substitute(bound_variable, replacement)
        return self
      else raise ArgumentError, "First argument is not a LambdaExpression or has no .kind."
      end
    end

    copy.function.body.substitute(bound_variable, replacement)
  end

  def evaluate(strategy=:lazy)
    raise "Method not yet written."
  end

  def lambda_tester
    puts   "To string: #{self}"
    puts   "kind:      #{self.kind}"
    case self.kind
    when :variable
      puts "value:     #{self.value}"
    when :abstraction
      puts "bound_var: #{self.bound_var}"
      puts "body:      #{self.body}"
    when :application
      puts "function:  #{self.function}"
      puts "argument:  #{self.argument}"
    end
  end

  def self.lambda_string_tester(string)
    puts "Test string:      #{string}"
    puts "Paren grouping:   #{LambdaExpression.group_by_parens(string)}"
    args = LambdaExpression.string_to_lambda_args(string)
    arg0, arg1, arg2 = args
    puts "Lambda arguments: #{args}"
    thing = LambdaExpression.new(arg0, arg1, arg2)
    thing.lambda_tester
  end

  # Runs a block on every leaf in the tree.
  def each_leaf!
    raise 'Method not yet written.'

    self.each do |leaf|
      yield(leaf)
    end
  end

end

# test = LambdaExpression.new('(\x.x\y.xy)\a.a')
# p test.beta_reduce