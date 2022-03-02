puts "Программа 'Прямоугольный треугольник'"
puts "Определяет свойства треугольника по его сторонам"

print "Сначала введите размер первой стороны в сантиметрах: "
side_1 = gets.chomp.to_i

print "Теперь -  размер второй стороны в сантиметрах: "
side_2 = gets.chomp.to_i

print "И наконец - размер третьей стороны в сантиметрах: "
side_3 = gets.chomp.to_i

# сначала проверим существование треугольника с заданными длинами сторон
# 1. Это значит что сумма любых пар сторон должна быть больше оставшейся третьей
# 2. Также если неправильно введены данные (одна или больше из сторон равна 0) то вернёт false
if (side_1 + side_2) > side_3 && (side_1 + side_3) > side_2 && (side_2 + side_3) > side_1
  triangle_present = true
else
  triangle_present = false
end

# Если треугольник существует - изучаем его св-ва
if triangle_present
  
  side_1, side_2, hyps  = [side_1, side_2, side_3].sort
  # является ли прямоугольным
  right_triangle = hyps**2 == side_1**2 + side_2**2
  # является ли равнобедренным
  isosceles = side_1 == side_2 || hyps == side_1 || hyps == side_2

  if side_1 == side_2 && side_1 == side_3
    puts "Треугольник является равносторонним и равнобедренным, но не прямоугольным"
  elsif right_triangle && isosceles
    puts "Треугольник прямоугольный и равнобедренный"
  elsif right_triangle
    puts "Треугольник только прямоугольный"
  elsif isosceles
    puts "Треугольник только равнобедренный"
  else
    puts "Треугольник не является ни прямоугольным ни равнобедренным ни равносторонним"
  end
else
  puts "Треугольника с такими длинами сторон не существует или вы неправильно ввели данные"
end
