# Getting started with Membrane

This is the [getting started with Membrane example](https://membrane.stream/learn/get_started_with_membrane).

## Installation

Linux:

    apt install clang-format portaudio19-dev ffmpeg \
                libavutil-dev libswresample-dev libmad0-dev

Mac:

    brew install clang-format portaudio ffmpeg libmad pkg-config

Then from the shell:

    mix deps.get
    mix deps.compile

## To run it

    
    iex -S mix
    iex(1)> {:ok, pid}  =  Hello.start_link("../_assets/basta-hitills.mp3")
    iex(2)> Hello.play(pid)




