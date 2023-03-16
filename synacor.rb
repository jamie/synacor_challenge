# Codes:
# [x] Read the spec
# [x] Opcodes 0, 19, 21
# [x] Self-test complete (all opcodes except 20)
# [x] use tablet
# [ ] ?
# [ ] ?
# [ ] ?
# [ ] ?

prog = File.read("challenge.bin").unpack("S*")

ip = 0

@reg = [0, 0, 0, 0, 0, 0, 0, 0]
@stack = []
@input = []

def value(num)
  return num if num <= 32767
  return @reg[num - 32768] if num < 32776
  raise "Invalid number #{num}"
end

def write(num, val)
  raise "expected register reference, got literal `a` #{num}" if num < 32768
  @reg[num - 32768] = val % 32768
end

loop do
  op = prog[ip]
  case op
  when 0 # halt
    ip += 1
    break
  when 1 # set a b
    write(prog[ip + 1], value(prog[ip + 2]))
    ip += 3
  when 2 # push a
    @stack.push(value(prog[ip + 1]))
    ip += 2
  when 3 # pop a
    write(prog[ip + 1], @stack.pop)
    ip += 2
  when 4 # eq a b c
    if value(prog[ip + 2]) == value(prog[ip + 3])
      write(prog[ip + 1], 1)
    else
      write(prog[ip + 1], 0)
    end
    ip += 4
  when 5 # gt a b c
    if value(prog[ip + 2]) > value(prog[ip + 3])
      write(prog[ip + 1], 1)
    else
      write(prog[ip + 1], 0)
    end
    ip += 4
  when 6 # jmp a
    ip = value(prog[ip + 1])
  when 7 # jt a b
    if value(prog[ip + 1]) > 0
      ip = value(prog[ip + 2])
    else
      ip += 3
    end
  when 8 # jf a b
    if value(prog[ip + 1]) == 0
      ip = value(prog[ip + 2])
    else
      ip += 3
    end
  when 9 # add a b c
    write(prog[ip + 1], value(prog[ip + 2]) + value(prog[ip + 3]))
    ip += 4
  when 10 # mult a b c
    write(prog[ip + 1], value(prog[ip + 2]) * value(prog[ip + 3]))
    ip += 4
  when 11 # mod a b c
    write(prog[ip + 1], value(prog[ip + 2]) % value(prog[ip + 3]))
    ip += 4
  when 12 # and a b c
    write(prog[ip + 1], value(prog[ip + 2]) & value(prog[ip + 3]))
    ip += 4
  when 13 # or a b c
    write(prog[ip + 1], value(prog[ip + 2]) | value(prog[ip + 3]))
    ip += 4
  when 14 # not a b
    write(prog[ip + 1], ~value(prog[ip + 2]))
    ip += 3
  when 15 # rmem a b
    write(prog[ip + 1], prog[value(prog[ip + 2])])
    ip += 3
  when 16 # wmem a b
    prog[value(prog[ip + 1])] = value(prog[ip + 2])
    ip += 3
  when 17 # call a
    @stack.push(ip + 2)
    ip = value(prog[ip + 1])
  when 18 # ret
    break if @stack.empty?
    ip = @stack.pop
  when 19 # out a
    print value(prog[ip + 1]).chr
    ip += 2
  when 20 # in a
    @input = gets.bytes if @input.empty?
    write(prog[ip + 1], @input.shift)
    ip += 2
  when 21 # noop
    ip += 1
  else
    puts
    puts "!! Unknown opcode: #{op}"
    break
  end
end

puts
