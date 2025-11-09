### **README.md**

````markdown
# AI-Dev: Full AI Development Environment (CUDA + PyTorch + R + MySQL + Hugging Face)

This repository provides a complete AI development environment built on NVIDIA PyTorch 25.10 with CUDA support.  
It includes tools for data science, machine learning, and large language model (LLM) integration using Hugging Face and Ollama.

---

## Features

- Base: NVIDIA PyTorch 25.10 (CUDA-enabled)
- Languages: Python and R
- Database: MySQL
- Visualization: Matplotlib, Seaborn, Plotly, Bokeh
- Machine Learning: Scikit-learn, XGBoost, LightGBM, Polars
- LLM/AI Tools: Transformers, Hugging Face Hub, Accelerate, Safetensors
- JupyterLab pre-configured for interactive development

---

## Build the Docker Image

```bash
docker build -t ai-dev:ollama .
````

---

## Run the Container

```bash
bash run_ai_dev.sh
```

This script mounts:

* Hugging Face cache and token
* Ollama model directory
* Current workspace

**Note:**
The port `11434` for Ollama is commented out in the run script.
Uncomment it if you want the container to host its own Ollama server.

---

## Configuration

To authenticate with Hugging Face:

```bash
huggingface-cli login
```

Alternatively, set the token via environment variable:

```bash
export HUGGINGFACE_TOKEN=hf_xxxxxxxxxxxxxxxxxxxxx
```

---

## Directory Structure

| File               | Description                                            |
| ------------------ | ------------------------------------------------------ |
| `Dockerfile`       | Defines the AI-Dev environment                         |
| `requirements.txt` | Python dependencies                                    |
| `run_ai_dev.sh`    | Launch script for the Docker container                 |
| `.gitignore`       | Prevents secrets and local caches from being committed |

---

## GPU Validation

Inside the container, verify CUDA support:

```bash
python -c "import torch; print(torch.cuda.is_available())"
```

Expected output:

```
True
```

