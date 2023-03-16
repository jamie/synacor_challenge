# Codes:
# [x] Read the spec
# [x] Opcodes 0, 19, 21
# [x] Self-test complete (all opcodes except 20)
# [x] use tablet
# [ ] ?
# [ ] ?
# [ ] ?
# [ ] ?

class VM
  attr_accessor :prog
  attr_accessor :ip

  def initialize
    @prog = File.read("challenge.bin").unpack("S*")

    @ip = 0
    @reg = [0, 0, 0, 0, 0, 0, 0, 0]
    @stack = []
    @input = []
  end

  def op = prog[ip]

  def a = value(1)

  def b = value(2)

  def c = value(3)

  def push(data) = @stack.push(data)

  def pop = @stack.pop

  def value(i)
    num = prog[ip + i]
    return num if num <= 32767
    return @reg[num - 32768] if num < 32776
    raise "Invalid number #{num}"
  end

  def write_a(val)
    num = prog[ip + 1]
    raise "expected register reference, got literal `a` #{num}" if num < 32768
    @reg[num - 32768] = val % 32768
  end

  def run
    loop do
      case op
      when 0 # halt
        break
      when 1 # set a b
        write_a(b)
        @ip += 3
      when 2 # push a
        push(a)
        @ip += 2
      when 3 # pop a
        write_a(pop)
        @ip += 2
      when 4 # eq a b c
        if b == c
          write_a(1)
        else
          write_a(0)
        end
        @ip += 4
      when 5 # gt a b c
        if b > c
          write_a(1)
        else
          write_a(0)
        end
        @ip += 4
      when 6 # jmp a
        @ip = a
      when 7 # jt a b
        if a > 0
          @ip = b
        else
          @ip += 3
        end
      when 8 # jf a b
        if a == 0
          @ip = b
        else
          @ip += 3
        end
      when 9 # add a b c
        write_a(b + c)
        @ip += 4
      when 10 # mult a b c
        write_a(b * c)
        @ip += 4
      when 11 # mod a b c
        write_a(b % c)
        @ip += 4
      when 12 # and a b c
        write_a(b & c)
        @ip += 4
      when 13 # or a b c
        write_a(b | c)
        @ip += 4
      when 14 # not a b
        write_a(~b)
        @ip += 3
      when 15 # rmem a b
        write_a(prog[b])
        @ip += 3
      when 16 # wmem a b
        prog[a] = b
        @ip += 3
      when 17 # call a
        push(ip + 2)
        @ip = a
      when 18 # ret
        break if @stack.empty?
        @ip = pop
      when 19 # out a
        print a.chr
        @ip += 2
      when 20 # in a
        @input = gets.bytes if @input.empty?
        write_a(@input.shift)
        @ip += 2
      when 21 # noop
        @ip += 1
      else
        puts
        puts "!! Unknown opcode: #{op}"
        break
      end
    end

    puts
  end
end

VM.new.run
