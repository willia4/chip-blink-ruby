#!/usr/local/bin/ruby

require 'i2c'
require 'i2c/driver/i2c-dev'
require 'daemons'

main = Proc.new do 
  driver = I2CDevice::Driver::I2CDev.new("/dev/i2c-0", true)
  $device = I2CDevice.new(address: 0x34, driver: driver)

  def light_on?
    state = $device.i2cget(0x93, 1)
    return !(state == "\x00")
  end

  def turn_light_on
    $device.i2cset(0x93, 1)
  end

  def turn_light_off
    $device.i2cset(0x93, 0)
  end

  def switch_light(on)
    if on 
      turn_light_on
    else
      turn_light_off
    end
  end

  def toggle_light
    if light_on?() 
      turn_light_on
    else
      turn_light_off
    end
  end

  def fast_pulse
    turn_light_on
    sleep(0.2)
    turn_light_off
    sleep(0.2)
  end

  def slow_pulse
    turn_light_on
    sleep(0.8)
    turn_light_off
    sleep(0.2)
  end

  loop do
    3.times { fast_pulse }

    turn_light_off
    sleep(0.3)

    3.times { slow_pulse }
    sleep(0.3)

    turn_light_off
    sleep(0.3)

    3.times { fast_pulse }

    turn_light_off
    sleep(0.3)
  end
end

Daemons.run_proc('blink.rb') { main.call }


