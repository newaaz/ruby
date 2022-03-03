puts "Программа 'Корзина'"
puts "Считает стоимость каждой покупки и итоговую сумму всех покупок"
puts "Для выхода из программы вместо названия товара введите 'stop'"

cart = {}

loop do
  puts "Введите название товара: "
  title = gets.chomp

  break if title == "stop"  

  puts "Введите кол-во товара: "
  quantity = gets.chomp.to_f
  puts "Введите стоимость товара за одну единицу: "
  price = gets.chomp.to_f
  
  cart[title.to_sym] = { quantity: quantity, price: price }

  puts "Ваши покупки:"
  total_price = 0
  cart.each do |title, product|
    puts "#{title}:  #{product[:quantity]} единиц, по #{product[:price]}, на сумму:  #{product[:quantity] * product[:price]}"
    total_price += product[:quantity] * product[:price]
  end

  puts "Общая сумма покупки:  #{total_price}"
  puts "-----------------------------------------"
  puts "Если ещё есть позиции - вводите"
  puts "Для выхода из программы вместо названия товара введите 'stop'"

end