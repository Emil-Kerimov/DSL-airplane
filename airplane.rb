require 'json'

class Airplane
  attr_reader :model, :engine_info, :seats, :max_speed, :options, :salon

  def initialize
    @options = [] # масив для зберігання додаткових опцій літака
    @salon = {} # хеш для опису плану салону
  end

  # метод класу для створення літака через DSL
  def self.build(&block)
    airplane = new # створюємо новий об'єкт літака
    airplane.instance_eval(&block) # виконуємо переданий блок у контексті об'єкта
    airplane
  end

  def set_model(name)
    raise ArgumentError, 'Назва моделі повинна бути рядком' unless name.is_a?(String)
    @model = name
  end

  def set_engine(type, power: nil)
    # зберігаємо тип двигуна та потужність у хеш
    @engine_info = { type: type, power: power }
  end

  def set_seats(count)
    raise ArgumentError, 'Кількість сидінь повинна бути цілим числом' unless count.is_a?(Integer) && count > 0
    @seats = count
  end

  def set_max_speed(speed)
    raise ArgumentError, 'Максимальна швидкість повинна бути позитивним числом' unless speed.is_a?(Numeric) && speed > 0
    @max_speed = speed
  end


  def class_layout(class_type, count)
    @salon[class_type] = count
  end

  def options(*options)
    @options.concat(options) # додаємо опції до масиву
  end

  def salon(&block)
    if block_given?
      # виконуємо переданий блок у контексті об'єкта
      instance_eval(&block)
    else
      # якщо блок не переданий, повертаємо поточний салон
      @salon
    end
  end

  def to_json(*_args)
    JSON.generate(
      {
        model: @model,
        engine: @engine_info,
        seats: @seats,
        max_speed: @max_speed,
        options: @options,
        salon: @salon
      }
    )
  end
end

plane = Airplane.build do
  set_model "Boeing 747"
  set_engine :reactive, power: 11111
  set_seats 100
  set_max_speed 1000

  salon do
    class_layout :economy, 90
    class_layout :business, 10
  end

  options "Starlink", "sometging"
end

puts plane.to_json
