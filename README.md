sudo apt-get install dfu-programmer gtkterm mcu8051ide octave pdftk

sudo dfu-programmer at89c5131 erase
sudo dfu-programmer at89c5131 flash code.hex

sudo gtkterm

pdftk locked.pdf input_pw password output unlocked.pdf

octave read-serial.m 