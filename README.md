Para instalar todos os programas que serão usados nas atividades desse repositório use o seguinte comando:

```bash
sudo apt-get install dfu-programmer gtkterm mcu8051ide pdftk octave liboctave-dev
```

O [mcu8051ide](http://www.moravia-microsystems.com/mcu-8051-ide/) é uma IDE especialmente destinada ao 8051. Ela tem um editor razoável, um emulador do 8051, alguns emuladores de hardware e outras ferramentas úteis.

O [dfu-programmer](https://dfu-programmer.github.io/) é usado para apagar a memória do 8051 e gravar o seu código *hexa*.

```bash
sudo dfu-programmer at89c5131 erase
sudo dfu-programmer at89c5131 flash [code].hex
```

O [gtkterm](http://gtkterm.feige.net/) é o emulador de terminal que será usado para acessar diretamente a interface serial do 8051.

```bash
sudo gtkterm
```

Outra forma de acessar a interface serial é com o [octave](http://octave.sourceforge.net/). Para isso é necessário instalar o pacote [instrument-control](http://wiki.octave.org/Instrument_control_package). Baixe o pacote [aqui](http://octave.sourceforge.net/instrument-control/index.html), e em seguida instale no octave acessando a pasta em que o pacote foi baixado pelo terminal e executando

```bash
$ octave
octave:1> pkg install instrument-control-[version].tar.gz
```
Para instruções mais detalhadas de uso acesse a página do pacote. Em meio as atividades é fornecido um script para o octave que usa a saída em bits da serial e plota um gráfico, semelhante a um osciloscópio. Para usar execute:

```bash
octave read-serial.m
```

Finalmente, para desbloquear um pdf permanentemente use o [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) com:

```bash
pdftk [locked].pdf input_pw [password] output [unlocked].pdf
```

