FROM ubuntu:22.04 as stage1
WORKDIR /app
COPY koboldcpp-rocm ./
RUN mkdir tmp
RUN apt update
RUN apt install -yq wget tree radeontop vim curl bzip2
RUN apt install -yq "libstdc++-12-dev"
#RUN wget -O tmp/rocm.deb https://repo.radeon.com/amdgpu-install/5.7.1/ubuntu/jammy/amdgpu-install_5.7.50701-1_all.deb
#RUN wget -O tmp/rocm.deb https://repo.radeon.com/amdgpu-install/6.0/ubuntu/jammy/amdgpu-install_6.0.60000-1_all.deb
#RUN wget -O tmp/rocm.deb https://repo.radeon.com/amdgpu-install/6.0.2/ubuntu/jammy/amdgpu-install_6.0.60002-1_all.deb
RUN wget -O tmp/rocm.deb https://repo.radeon.com/amdgpu-install/latest/ubuntu/jammy/amdgpu-install_6.2.60204-1_all.deb

RUN apt install -yq "./tmp/rocm.deb"


FROM stage1 as stage2
RUN amdgpu-install --usecase=hip,rocm --no-dkms -yq
EXPOSE 5001
CMD ["/bin/bash"]

FROM stage2 as stage3
# RDNA3 TODO write a script that automatically configures this
ENV HSA_OVERRIDE_GFX_VERSION=11.0.0
# workaround for high idle power on the 7900xtx
ENV GPU_MAX_HW_QUEUES=1
# following command requires $DISPLAY to be set
# we just ignore this error for now
RUN "./koboldcpp.sh; exit 0"

FROM stage3 as stage4
# RDNA3 TODO write a script that automatically configures this
ENV HSA_OVERRIDE_GFX_VERSION=11.0.0
# workaround for high idle power on the 7900xtx
ENV GPU_MAX_HW_QUEUES=1
RUN make clean
RUN make LLAMA_HIPBLAS=1 -j $(nproc)
RUN chmod 755 koboldcpp.py
