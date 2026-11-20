# Blender 5.2.1 headless render image for RunPod GPU pods (EEVEE/Cycles), with ffmpeg and runpodctl.
FROM nvidia/cuda:12.8.1-base-ubuntu24.04
ENV DEBIAN_FRONTEND=noninteractive \
    NVIDIA_DRIVER_CAPABILITIES=all \
    NVIDIA_VISIBLE_DEVICES=all
RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends \
      ca-certificates wget xz-utils libxi6 libxkbcommon0 libsm6 libxrender1 libxxf86vm1 libxfixes3 \
      libgl1 libegl1 libglvnd0 libvulkan1 libx11-6 libxext6 ffmpeg python3 \
    && rm -rf /var/lib/apt/lists/*
# the NVIDIA runtime mounts the driver's GL/EGL/Vulkan libraries; these ICD files point the loaders at them
RUN mkdir -p /usr/share/glvnd/egl_vendor.d /etc/vulkan/icd.d \
    && printf '{"file_format_version":"1.0.0","ICD":{"library_path":"libEGL_nvidia.so.0"}}\n' > /usr/share/glvnd/egl_vendor.d/10_nvidia.json \
    && printf '{"file_format_version":"1.0.0","ICD":{"library_path":"libGLX_nvidia.so.0","api_version":"1.3"}}\n' > /etc/vulkan/icd.d/nvidia_icd.json
RUN cd /opt && wget -q https://download.blender.org/release/Blender5.2/blender-5.2.1-linux-x64.tar.xz -O b.tar.xz \
    && tar xf b.tar.xz && mv blender-5.2.1-linux-x64 blender && rm b.tar.xz \
    && ln -s /opt/blender/blender /usr/local/bin/blender
RUN wget -q https://github.com/runpod/runpodctl/releases/download/v3.1.1/runpodctl-linux-amd64 -O /usr/local/bin/runpodctl3 \
    && chmod +x /usr/local/bin/runpodctl3
WORKDIR /work
CMD ["sleep", "infinity"]
