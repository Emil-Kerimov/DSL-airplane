require_relative './airplane.rb'
require 'json'
require 'rspec'

RSpec.describe Airplane do
  let(:plane) do
    Airplane.build do
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
  end

  describe "#to_json" do
    it "серіалізує літак у JSON" do
      json_output = plane.to_json
      parsed = JSON.parse(json_output)

      expect(parsed["model"]).to eq("Boeing 747")
      expect(parsed["engine"]["type"]).to eq("reactive")
      expect(parsed["engine"]["power"]).to eq(11111)
      expect(parsed["seats"]).to eq(100)
      expect(parsed["max_speed"]).to eq(1000)
      expect(parsed["options"]).to include("Starlink", "sometging")
      expect(parsed["salon"]["economy"]).to eq(90)
      expect(parsed["salon"]["business"]).to eq(10)
    end
  end

  describe ".build" do
    it "правильно створює літак" do
      expect(plane.model).to eq("Boeing 747")
      expect(plane.engine_info[:type]).to eq(:reactive)
      expect(plane.engine_info[:power]).to eq(11111)
      expect(plane.seats).to eq(100)
      expect(plane.max_speed).to eq(1000)
      expect(plane.options).to contain_exactly("Starlink", "sometging")
      expect(plane.salon).to eq({ economy: 90, business: 10 })
    end
  end

  describe "#set_model" do
    it "повертає помилку, якщо недопустимі значення" do
      expect { plane.set_model(123) }.to raise_error(ArgumentError, 'Назва моделі повинна бути рядком')
      expect { plane.set_seats("gdfs") }.to raise_error(ArgumentError, 'Кількість сидінь повинна бути цілим числом')
      expect { plane.set_max_speed("hsd") }.to raise_error(ArgumentError, 'Максимальна швидкість повинна бути позитивним числом')
    end
  end
end

