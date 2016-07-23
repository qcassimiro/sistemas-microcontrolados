```bash
sudo apt-get install dfu-programmer gtkterm mcu8051ide octave pdftk
```

```bash
sudo dfu-programmer at89c5131 erase
sudo dfu-programmer at89c5131 flash code.hex
```

```bash
sudo gtkterm
```

```bash
pdftk [locked].pdf input_pw [password] output [unlocked].pdf
```

```bash
octave read-serial.m
```