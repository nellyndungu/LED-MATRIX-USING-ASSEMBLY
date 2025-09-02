# CONTROL OF LED SERIES USING ASSEMBLY AND ATMEGA328P
A simple 8-LED bar “ramp up / ramp down” animator on PORTD. It turns the eight PORTD pins (PD0…PD7) into outputs, then:
- builds a bar one LED at a time (bits 0→7 set high),
- then shrinks it one LED at a time (bits 0→7 cleared to low),
and repeats forever with a fixed, software-generated delay between steps.
## Pins & mapping
- DDRD ← 0xFF sets PD0–PD7 as outputs.
- The program manipulates PORTD directly:
    - sbi PORTD, n sets bit n high (LED ON if wired to VCC via resistor).
    - cbi PORTD, n clears bit n (LED OFF).

On an Arduino Uno header, these are digital pins 0–7 (PD0=0/RX, PD1=1/TX, PD2=2, …, PD7=7). If you plan to use serial, avoid PD0/PD1 or expect UART interference.
## Working principle
1. Initialization
- ldi r16, 0xFF / out DDRD, r16 → all PORTD pins become outputs.
2. Main animation loop
- Ramp up (fill):
    - sbi PORTD, 0 → delay → sbi PORTD, 1 → delay → … → sbi PORTD, 7 → delay. Result: LEDs accumulate ON, forming a growing bar from the first LED to the eighth (at the end of this phase, all eight are ON).
- Ramp down (empty):
    - cbi PORTD, 0 → delay → cbi PORTD, 1 → delay → … → cbi PORTD, 7 → delay. Result: LEDs turn OFF one by one from PD0 upwards until all are OFF.
    - rjmp loop → repeats forever.

This is not a single “chaser” light (one LED at a time). It’s a bar graph that grows to full and then shrinks to zero.
## The delay routine
- The subroutine delay_ms uses three nested loops in registers r17, r18, and r19 (40 × 30 × 10 decrements) to waste a deterministic number of CPU cycles, then returns.
- Rough cycle math (for reference):
    - One call to delay_ms consumes about 39,724 CPU cycles inside the routine (+ ~4 cycles for call).
    - Therefore, each delay ≈ 39.7k cycles.
    - Examples:
        - At 16 MHz clock → ~2.48 ms per delay.
        - At 1 MHz clock → ~39.7 ms per delay.
- The main loop uses this delay 16 times per full animation (8 during fill, 8 during empty), so the full up+down cycle is roughly:
- ~40 ms at 16 MHz (very fast; the bar will seem to change almost instantly),
- ~0.64 s at 1 MHz (clearly visible fill and empty).

Real timing also includes a small overhead from sbi/cbi/rjmp, but the numbers above are a good approximation.
