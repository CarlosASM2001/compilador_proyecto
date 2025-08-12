#!/usr/bin/env python3
"""
Simulador simple de la Tiny Machine (TM)
"""

import sys
import re

class TMSimulator:
    def __init__(self):
        self.memory = [0] * 1024  # Memoria de datos
        self.code = []            # Memoria de código
        self.registers = [0] * 8  # 8 registros (0-7)
        self.pc = 0               # Program counter (registro 7)
        self.step_count = 0
        self.max_steps = 10000
        
    def load_program(self, filename):
        """Carga un programa TM desde un archivo"""
        with open(filename, 'r') as f:
            for line in f:
                # Buscar líneas con formato: número: instrucción
                match = re.match(r'^(\d+):\s+(\w+)\s+(\d+),(\d+)\((\d+)\)', line.strip())
                if match:
                    addr = int(match.group(1))
                    op = match.group(2)
                    r = int(match.group(3))
                    d = int(match.group(4))
                    s = int(match.group(5))
                    
                    # Asegurar que la lista de código sea lo suficientemente grande
                    while len(self.code) <= addr:
                        self.code.append(None)
                    
                    self.code[addr] = (op, r, d, s)
                    
    def execute(self):
        """Ejecuta el programa cargado"""
        print("=== Iniciando ejecución ===")
        print(f"PC  Instrucción            AC   AC1  Salida")
        print("-" * 50)
        
        self.registers[5] = 0      # GP = 0
        self.registers[6] = 1023   # MP = 1023
        self.pc = 0
        
        while self.pc < len(self.code) and self.step_count < self.max_steps:
            if self.code[self.pc] is None:
                print(f"Error: No hay instrucción en PC={self.pc}")
                break
                
            op, r, d, s = self.code[self.pc]
            self.step_count += 1
            
            # Imprimir estado antes de ejecutar
            inst_str = f"{op} {r},{d}({s})"
            
            # Ejecutar instrucción
            if op == "HALT":
                print(f"{self.pc:3} {inst_str:20} {self.registers[0]:4} {self.registers[1]:4}")
                print("\n=== Programa terminado ===")
                print(f"Pasos ejecutados: {self.step_count}")
                break
            elif op == "LDC":
                self.registers[r] = d
            elif op == "LDA":
                if s == 7:  # PC relativo
                    self.registers[r] = self.pc + d + 1
                else:
                    self.registers[r] = d + self.registers[s]
            elif op == "LD":
                addr = d + self.registers[s]
                if 0 <= addr < len(self.memory):
                    self.registers[r] = self.memory[addr]
            elif op == "ST":
                addr = d + self.registers[s]
                if 0 <= addr < len(self.memory):
                    self.memory[addr] = self.registers[r]
            elif op == "ADD":
                self.registers[r] = self.registers[d] + self.registers[s]
            elif op == "SUB":
                self.registers[r] = self.registers[d] - self.registers[s]
            elif op == "MUL":
                self.registers[r] = self.registers[d] * self.registers[s]
            elif op == "DIV":
                if self.registers[s] != 0:
                    self.registers[r] = self.registers[d] // self.registers[s]
            elif op == "OUT":
                print(f"{self.pc:3} {inst_str:20} {self.registers[0]:4} {self.registers[1]:4}  --> {self.registers[r]}")
                continue
                
            # Actualizar PC
            if op == "LDA" and r == 7:
                # Salto absoluto
                self.pc = self.registers[7]
            else:
                self.pc += 1
                
            # Imprimir estado si no es OUT
            if op != "OUT":
                print(f"{self.pc-1:3} {inst_str:20} {self.registers[0]:4} {self.registers[1]:4}")
                
        if self.step_count >= self.max_steps:
            print(f"\nError: Límite de pasos alcanzado ({self.max_steps})")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Uso: {sys.argv[0]} archivo.tm")
        sys.exit(1)
        
    sim = TMSimulator()
    sim.load_program(sys.argv[1])
    sim.execute()