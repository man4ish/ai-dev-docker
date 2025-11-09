#!/bin/bash
# ==========================================================
# Script Name: run_ai_dev.sh
# Description: Launches the AI-Dev Docker container with
#              GPU support, Hugging Face cache, and optional Ollama integration.
#
# Notes:
# - The 11434 port is used by Ollama. 
#   Uncomment the corresponding line if you want to allow the container 
#   to access or serve models through the host's Ollama instance.
# - The Hugging Face cache is mounted for authentication and model reuse.
# ==========================================================

echo "Starting FULL AI DEV STACK (PyTorch + R + MySQL + Hugging Face + Optional Ollama)"

docker run --gpus all --ipc=host \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  -v ~/.ollama:/root/.ollama \
  -v "$(pwd)":/workspace \
  -p 8888:8888 \
  # -p 11434:11434 \   # Ollama API port — uncomment if Ollama service access is needed
  -e HF_HOME=/root/.cache/huggingface \
  -it ai-dev:ollama bash
