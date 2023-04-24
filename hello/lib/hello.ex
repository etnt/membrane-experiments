defmodule Hello do
  @moduledoc """

  https://membrane.stream/learn/get_started_with_membrane

  """

  # Using this behaviour means we are treating our module
  # as a Membrane Pipeline, so we will have access to
  # functions defined in the Membrane.Pipeline module,
  # and we can implement some of it's callbacks.
  use Membrane.Pipeline

  # The main purpose of the handle_init callback is to
  # prepare our pipeline. Preparing means that we need
  # to specify all its elements as children and set up
  # links between those children to describe the order
  # in which data will flow through the pipeline.
  @impl true
  def handle_init(path_to_mp3) do
	  children = %{

      # the Source module file plugin that will read a file.
	    file: %Membrane.File.Source{location: path_to_mp3},

      # an mp3 decoder based on MAD.
	    decoder: Membrane.MP3.MAD.Decoder,

      # a converter based on FFmpeg SWResample.
      # We'll be needing it to resample our raw
      # audio stream from 24 to 16 bits.
	    converter: %Membrane.FFmpeg.SWResample.Converter{
	      output_caps: %Membrane.Caps.Audio.Raw{
		      format: :s16le,
		      sample_rate: 48000,
		      channels: 2
        }
	    },

      # a Sink module that will be playing our
      # music with Portaudio.
	    portaudio: Membrane.PortAudio.Sink
    }

    # link the children in the proper order.
    # Each Membrane Element can be one of three types:
    # Source, Sink or Filter.
    # The main difference is that Source provides only
    # output pads, Sink only input and Filter both
    # input and output pads.
	  links = [
	    link(:file)
	    |> to(:decoder)
	    |> to(:converter)
	    |> to(:portaudio)
	  ]

    # In our pipeline ParentSpec will contain only
    # children elements and links between them:
	  spec = %ParentSpec{children: children, links: links}

    # We are returning an empty map for state,
    # as we don't need anything to be stored as state.
	  { {:ok, spec: spec}, %{} }
  end

end
