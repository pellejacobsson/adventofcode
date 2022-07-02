class IntCode:
    def __init__(self, filename):
        self.i = 0
        self.rel = 0
        self.stopped_on_input = False
        self.input = 0
        self.output = None
        self.instruction = self.read_code(filename)

    def read_code(self, filename):
        with open(filename, 'r') as f:
            instruction = [int(x) for x in f.read().split(',')]
        return instruction + [0]*1000

    def set_input(self, input_val):
        self.input = input_val
    
    def get_output(self):
        return self.output

    def run_until_input_or_done(self):
        return self.run(stop_on_output=False, stop_on_input=True)

    def run_until_io_or_done(self):
        return self.run(stop_on_output=True, stop_on_input=True)

    def run(self, stop_on_output=True, stop_on_input=False):
        self.stopped_on_input = False
        i = self.i
        rel = self.rel
        instruction = self.instruction
        while True:
            opcode = instruction[i]
            if opcode == 99:
                self.i = i
                self.rel = rel
                return None
            opcode_list = [int(x) for x in str(opcode)]
            opcode_list = [0]*(5 - len(opcode_list)) + opcode_list
            a, b, c, d, e = opcode_list
            if e == 1 or e == 2:
                if c == 0:
                    p1 = instruction[instruction[i + 1]]
                elif c == 1:
                    p1 = instruction[i + 1]
                elif c == 2:
                    p1 = instruction[instruction[i + 1] + rel]
                else:
                    raise ValueError('Parameter error')
                if b == 0:
                    p2 = instruction[instruction[i + 2]]
                elif b == 1:
                    p2 = instruction[i + 2]
                elif b == 2:
                    p2 = instruction[instruction[i + 2] + rel]
                else:
                    raise ValueError('Parameter error')
                if a == 0:
                    p3 = instruction[i + 3]
                elif a == 2:
                    p3 = instruction[i + 3] + rel
                else:
                    raise ValueError('Parameter error')
                instruction[p3] = p1 + p2 if e == 1 else p1 * p2
                i += 4
            elif e == 3:
                if c == 0:
                    p1 = instruction[i + 1]
                elif c == 2:
                    p1 = instruction[i + 1] + rel
                else:
                    raise ValueError('Parameter error')
                instruction[p1] = self.input
                i += 2
                self.stopped_on_input = True
                if stop_on_input:
                    break
            elif e == 4:
                if c == 0:
                    p1 = instruction[instruction[i + 1]]
                elif c == 1:
                    p1 = instruction[i + 1]
                elif c == 2:
                    p1 = instruction[instruction[i + 1] + rel]
                else:
                    raise ValueError('Parameter error')
                i += 2
                self.output = p1
                if stop_on_output:
                    break
            elif e == 5 or e == 6:
                if c == 0:
                    p1 = instruction[instruction[i + 1]]
                elif c == 1:
                    p1 = instruction[i + 1]
                elif c == 2:
                    p1 = instruction[instruction[i + 1] + rel]
                else:
                    raise ValueError('Parameter error')
                if b == 0:
                    p2 = instruction[instruction[i + 2]]
                elif b == 1:
                    p2 = instruction[i + 2]
                elif b == 2:
                    p2 = instruction[instruction[i + 2] + rel]
                else:
                    raise ValueError('Parameter error')
                if e == 5 and p1 != 0:
                    i = p2
                elif e == 6 and p1 == 0:
                    i = p2
                else:
                    i += 3
            elif e == 7 or e == 8:
                if c == 0:
                    p1 = instruction[instruction[i + 1]]
                elif c == 1:
                    p1 = instruction[i + 1]
                elif c == 2:
                    p1 = instruction[instruction[i + 1] + rel]
                else:
                    raise ValueError('Parameter error')
                if b == 0:
                    p2 = instruction[instruction[i + 2]]
                elif b == 1:
                    p2 = instruction[i + 2]
                elif b == 2:
                    p2 = instruction[instruction[i + 2] + rel]
                else:
                    raise ValueError('Parameter error')
                if a == 0:
                    p3 = instruction[i + 3]
                elif a == 2:
                    p3 = instruction[i + 3] + rel
                else:
                    raise ValueError('Parameter error')
                if e == 7:
                    instruction[p3] = 1 if p1 < p2 else 0
                else:
                    instruction[p3] = 1 if p1 == p2 else 0
                i += 4
            elif e == 9:
                if c == 0:
                    p1 = instruction[instruction[i + 1]]
                elif c == 1:
                    p1 = instruction[i + 1]
                elif c == 2:
                    p1 = instruction[instruction[i + 1] + rel]
                else:
                    raise ValueError('Parameter error')
                rel += p1
                i += 2
            else:
                print(opcode)
                raise ValueError('Opcode error')
        self.i = i
        self.rel = rel
        return self.output

class NetIntcode:
    def __init__(self, filename, address, target_address, network):
        self.queue = []
        self.vm = IntCode(filename)
        self.vm.input = address
        self.target_address = target_address
        self.network = network
        self.vm.run_until_input_or_done()
        self.vm.input = -1
        self.idle = False

    def run_until_io(self):
        if not self.queue:
            self.vm.input = -1
        else:
            self.vm.input = self.queue[0][0]
        output = self.vm.run_until_io_or_done()
        if self.vm.stopped_on_input:
            if self.queue:
                x, y = self.queue.pop(0)
                self.vm.input = y
                self.vm.run_until_input_or_done()
            else:
                self.idle = True
        else:
            self.idle = False
            dest_address = output
            x = self.vm.run_until_io_or_done()
            y = self.vm.run_until_io_or_done()
            if dest_address == self.target_address:
                return dest_address, x, y
            self.network[dest_address].queue.append((x, y))

class NAT:
    def __init__(self, network):
        self.network = network
        self.packet = None
        self.last_y_delivered = None

    def is_network_idle(self):
        for c in self.network:
            if not c.idle:
                return False
        return True

    def has_packet(self):
        return self.packet is not None

    def is_repeated_y(self):
        return self.packet[1] == self.last_y_delivered

    def send_packet(self):
        self.last_y_delivered = self.packet[1]
        self.network[0].queue.append(self.packet)
        self.packet = None
