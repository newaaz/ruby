# 1. Хеш, содержащий месяцы и количество дней. В цикле выводить те месяцы, у которых количество дней ровно 30
months = {
  january:    31,
  february:   28,
  march:      31,
  april:      30,
  may:        31,
  june:       30,
  july:       31,
  august:     31,
  september:  30,
  october:    31,
  november:   30,
  december:   31
}
# с помощью метода select
my_months = months.select { |month, days| days == 30 }
puts my_months

# с помощью цикла
months.each do |month, days|
  puts "In #{month} 30 days" if days == 30
end

# 2. Заполнить массив числами от 10 до 100 с шагом 5
my_array = []
(10..100).step(5).each { |num| my_array.push num }
puts my_array

# 3. Заполнить массив числами фибоначчи до 100
fib_array = [0, 1]
loop do
  num = fib_array[-1] + fib_array[-2]
  break if num > 100
  fib_array << num  
end
puts fib_array

# 4. Заполнить хеш гласными буквами (a: 1, e: 5)
my_hash = Hash.new
vowels = ["a", "e", "i", "o", "u"]
letters = ("a".."z").to_a.zip((1..26).to_a)

letters.each do |letter|
  my_hash[letter[0]] = letter[1] if vowels.include?(letter[0])
end

puts my_hash