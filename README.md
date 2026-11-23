# ReactionTimer

ReactionTimer is a SystemVerilog project for the Digilent Basys 3 FPGA board. It combines a stopwatch with a reaction-time game: after a randomized delay, an LED turns on and the player presses a button as quickly as possible. The measured time is shown on the board's four-digit seven-segment display.

The project can also serve as a general-purpose stopwatch, since the `stopwatch` module exposes an elapsed-time value in milliseconds and can be reused independently in another FPGA design.

## Hardware

- Digilent Basys 3 (Artix-7)
- 100 MHz board clock
- One push button to start/stop
- One push button to reset
- One LED
- Four-digit seven-segment display

The pin assignments are provided in `ReactionTimerPins.xdc`:

| Function | Basys 3 control |
| --- | --- |
| Clock | W5 |
| Reset | Center button, U18 |
| Start/stop | Up button, T18 |
| LED | LD0, U16 |

## Project contents

- `reactiontimer_top.sv` - top-level reaction-time state machine
- `stopwatch.sv` - millisecond stopwatch
- `clock_divider.sv` - configurable clock divider
- `random_number_generator.sv` - 8-bit LFSR for delay variation
- `binary_to_ssd.sv` - converts elapsed milliseconds to four decimal digits
- `sevenSegDigit.sv` - one-digit seven-segment encoder
- `basys_ssd.sv` - multiplexes the four seven-segment digits
- `ReactionTimerPins.xdc` - Basys 3 clock and I/O constraints

## Setup

1. Install Xilinx Vivado and connect a Basys 3 board by USB.
2. Create a new RTL project and select the appropriate Basys 3/Artix-7 part.
3. Add all `.sv` source files in this repository.
4. Add `ReactionTimerPins.xdc` as the constraints file.
5. Set `reactiontimer_top` as the top-level module.
6. Run synthesis and implementation, then generate and program the bitstream.

No additional software or external libraries are required.

## Using the reaction-time game

1. Press the center button to reset the system.
2. Press the up button to begin one round.
3. Wait while the LED is off. A random delay is added before the LED turns on.
4. As soon as LED0 turns on, press the up button again.
5. The four-digit display holds the elapsed reaction time in milliseconds.
6. Press the center button to reset and prepare for another round.

The reaction timer measures up to 9999 milliseconds. The stopwatch stops after this limit and remains at `9999` until reset.

## Inspiration

This lab project was inspired by the IEEE Bruins lab project at https://projects.ieeebruins.com/DAV/lab-2.
