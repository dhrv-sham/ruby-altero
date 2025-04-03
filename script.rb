# This is a simple Ruby program

puts "What is your name?"
name = gets.chomp



puts "How old are you?"
age = gets.chomp.to_i

year_of_birth = Time.now.year - age

puts "Hello, #{name}! You were born in #{year_of_birth}."
