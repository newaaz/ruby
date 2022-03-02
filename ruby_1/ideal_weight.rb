puts "Программа 'Идеальный вес'"

print "Сначала введите ваше имя: "
user_name = gets.chomp.to_i

print "Теперь введите ваш рост в сантиметрах: "
user_weight = gets.chomp

ideal_weight = (user_weight - 110) * 1.15
if ideal_weight > 0
  puts "#{user_name}, ваш идеальный вес: #{ideal_weight}"
else
  puts "#{user_name}, ваш вес уже оптимальный."
end



