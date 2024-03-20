# koboldcpp-rocm-docker
Docker build for running koboldcpp-rocm

# Building the image

- clone the ROCm fork of koboldcpp

```bash

git clone https://github.com/YellowRoseCx/koboldcpp-rocm.git
```

- run the Docker build (this will take awhile)

```bash

docker build -t kobold:latest .

```

- start the container (assumes the .gguf LLM models are located in `~/models`)

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