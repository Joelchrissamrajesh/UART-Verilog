# UART Verilog Design

## Overview
This project implements a UART (Universal Asynchronous Receiver Transmitter) using Verilog. It includes transmitter and receiver modules for serial communication.

## Features
- UART Transmitter (TX)
- UART Receiver (RX)
- Configurable baud rate
- Serial data communication

## Design
- uart_tx.v → Transmitter
- uart_rx.v → Receiver
- uart_top.v → Top module

## Verification
- Loopback test performed (TX connected to RX)
- Data transmitted from TX is successfully received at RX

## How to Run
cd sim  
make run
