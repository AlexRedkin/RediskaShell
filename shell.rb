

require 'rake'

def help_message
  <<-HEREDOC
	What would you prefer?
	1 or list - Lists all available plugins (.rb files in the root dir)
	2 or lp - List loaded modules
	3 or load - Choose module to load.
	4 or loada - Load all modules from root dir
	5 or lm - Get list of module methods
	6 or rf - Read the content of file
	7 or execute - Run one of imported methods or smth else
	0 or exit  - Exit
	h or help - Help message
	HEREDOC
end

def initial_message
  <<-HEREDOC
		RediskaShell©
		2016-2017. All rights recived.
		Type 'h' for help and '0' to exit
	HEREDOC
end

def load_all_modules
  files = Rake::FileList['./*rb']
  files.exclude('./shell.rb')
  files.each do |file|
    array = File.foreach(file).grep(/module/)
    next if array.empty?
    require file
    puts "file #{file} was required"
    array.each do |match|
      match.slice! 'module '
      match.slice! "\n"
      include Object.const_get(match)
      puts "#{match} was included"
    end
  end
end

def load_modules(filename)
  array = File.foreach(filename).grep(/module/)
  if !array.empty?
    require filename
    puts "file #{filename} was required"
    array.each do |match|
      match.slice! 'module '
      match.slice! "\n"
      include Object.const_get(match)
      puts "#{match} was included"
    end
  else
    puts "There are no modules in #{filename}"
  end
end

def module_methods(name)
  puts Object.const_get(name).instance_methods
end

def file_content(filename)
  puts File.read(filename.to_s)
end

def execure_method(&p)
  p
end

puts initial_message

loop do
  case gets.chomp
  when '1' || 'list'
    puts "List of available plugins in #{Dir.pwd}:"
    files = Rake::FileList['*rb']
    files.exclude('*shell.rb*')
    puts files
  when '2' || 'lp'
    puts 'List loaded modules'
    puts Module.included_modules.to_s
  when '3' || 'load'
    puts 'Enter filepath to the .rb file'
    filepath = gets.chomp
    load_modules(filepath)
  when '4' || 'loada'
    puts 'Load all plugins'
    load_all_modules
  when '5' || 'lm'
    puts 'Enter the name of module'
    name = gets.chomp
    module_methods(name)
  when '6' || 'rf'
    puts 'Enter the name of file'
    filepath = gets.chomp
    file_content(filepath)
  when '7' || 'execute'
    puts 'Enter the method'
    e = eval gets.chomp
    puts 'the result of execution'
    puts e
  when '0' || 'exit'
    exit
  when 'h' || 'help'
    puts help_message
  else
    puts 'Wrong! Choose one of variants!'
  end

  break if 1 != 1
end
