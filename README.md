# koboldcpp-rocm-docker
Docker build for running koboldcpp-rocm

# Building the image

- clone the ROCm fork of koboldcpp, inside the local directory of this repo

```bash

git clone https://github.com/YellowRoseCx/koboldcpp-rocm.git
```

- run the Docker build (this will take awhile)

```bash

docker build -t kobold:latest .

```

- start the container (assumes the .gguf LLM models are located in `~/models`, change accordingly)

```bash

docker run --rm -it -p 5001:5001 --device /dev/kfd --device /dev/dri \
--mount type=bind,source="$HOME"/models,target=/models \
kobold:latest
```

- run koboldcpp server (inside the container)

```bash
./koboldcpp.py --config example_config.json
```

# Additional info

This was tested on 7900xtx

For other architectures modify the `ENV HSA_OVERRIDE_GFX_VERSION=11.0.0` line in `Dockerfile` to the appropriate value.

Some examples:

```bash
    gfx900: Vega 64
    gfx906: Radeon VII
    gfx908: Instinct MI100
    gfx90a: Instinct MI200/ MI250
    gfx1030: RX 6800/ 6900/ 6950, also works on many other RDNA2 and RDNA1 cards with the environment variable "HSA_OVERRIDE_GFX_VERSION=10.3.0"
    gfx1100: RX 7900
    gfx1101: Unreleased, probably RX 7700/ 7800?
    gfx1102: RX 7600
```