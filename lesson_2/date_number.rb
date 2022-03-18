puts "Программа 'Номер даты'"
puts "Определяет порядковый номер даты по введённому числу, месяцу и году"

print "Сначала введите число (от 1 до 31): "
date = gets.chomp.to_i

print "Теперь - номер месяца (от 1 до 12) : "
month = gets.chomp.to_i

print "И наконец - интересующий год: "
year = gets.chomp.to_i
# определяем высокосный ли год
leap_year = true if year % 4 == 0
if year % 100 == 0 && year % 400 != 0
  leap_year = false
end

# месяца и количество дней в них
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
months_array = months.to_a

# считаем сумму дней в прошедших месяцах до текущего и прибавляем к дате
for i in 0..month - 2
  date += months_array[i][1]
end

# Если год высокосный и порядковый номер даты больше 59 (28 февраля) - прибавляем 1 день
date += 1 if leap_year && date > 59

puts "Порядковый номер интересующей вас даты: #{date}"





