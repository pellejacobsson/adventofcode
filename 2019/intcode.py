class IntCode:
    def __init__(self, inputs, outputs, filename, i = 0, rel = 0):
        self.i = i
        self.rel = rel
        self.finished = False
        self.inputs = inputs
        self.outputs = outputs
        self.instruction = self.read_code(filename)

    def read_code(self, filename):
        with open(filename, 'r') as f:
            instruction = [int(x) for x in f.read().split(',')]
        return instruction + [0]*1000

    def run(self):
        i = self.i
        rel = self.rel
        instruction = self.instruction
        while instruction[i] != 99:
            opcode = instruction[i]
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
                current_input = self.inputs.pop(0)
                if c == 0:
                    p1 = instruction[i + 1]
                elif c == 2:
                    p1 = instruction[i + 1] + rel
                else:
                    raise ValueError('Parameter error')
                instruction[p1] = current_input
                i += 2
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
                self.outputs.append(p1)
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
        return None