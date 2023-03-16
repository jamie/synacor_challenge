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

  def incr = @ip += 1

  def op
    prog[ip].tap { incr }
  end

  def a = value

  def b = value

  def c = value

  def push(data) = @stack.push(data)

  def pop = @stack.pop

  def value
    num = prog[ip].tap { incr }
    return num if num <= 32767
    return @reg[num - 32768] if num < 32776
    raise "Invalid number #{num}"
  end

  def write_a
    num = prog[ip].tap { incr }
    val = yield
    raise "expected register reference, got literal `a` #{num}" if num < 32768
    @reg[num - 32768] = val % 32768
  end

  def run
    loop do
      case op
      when 0 # halt
        break
      when 1 # set a b
        write_a { b }
      when 2 # push a
        push(a)
      when 3 # pop a
        write_a { pop }
      when 4 # eq a b c
        write_a { (b == c) ? 1 : 0 }
      when 5 # gt a b c
        write_a { (b > c) ? 1 : 0 }
      when 6 # jmp a
        @ip = a
      when 7 # jt a b
        if a > 0
          @ip = b
        else
          b
        end
      when 8 # jf a b
        if a == 0
          @ip = b
        else
          b
        end
      when 9 # add a b c
        write_a { b + c }
      when 10 # mult a b c
        write_a { b * c }
      when 11 # mod a b c
        write_a { b % c }
      when 12 # and a b c
        write_a { b & c }
      when 13 # or a b c
        write_a { b | c }
      when 14 # not a b
        write_a { ~b }
      when 15 # rmem a b
        write_a { prog[b] }
      when 16 # wmem a b
        prog[a] = b
      when 17 # call a
        push(ip + 1) # after consuming op
        @ip = a
      when 18 # ret
        raise "RET: empty stack" if @stack.empty?
        @ip = pop
      when 19 # out a
        print a.chr
      when 20 # in a
        @input = gets.bytes if @input.empty?
        write_a { @input.shift }
      when 21 # noop
        42
      else
        puts
        puts "!! Unknown opcode: #{prog[ip]}"
        break
      end
    end

    puts
  end
end

VM.new.run
