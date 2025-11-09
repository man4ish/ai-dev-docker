# ==========================================================
# Image Name: ai-dev
# Description: Full AI Development Environment
# Base: NVIDIA PyTorch 25.10 (CUDA-enabled)
# Includes: Python (Data Science Stack) + R (Bioconductor) + MySQL + Jupyter + Ollama
# Maintainer: Manish Kumar
# ==========================================================

FROM nvcr.io/nvidia/pytorch:25.10-py3

LABEL maintainer="Manish Kumar"
LABEL description="AI-Dev: PyTorch 25.10 base with R, MySQL, Jupyter, and Ollama for full-stack AI and bioinformatics development."
LABEL version="1.0.0"
LABEL build_date="2025-11-08"

WORKDIR /workspace

# ==========================================================
# 1. System dependencies
# ----------------------------------------------------------
# Installs general utilities, compilers, and libraries
# required for building and running scientific software.
# ==========================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget vim build-essential \
    libssl-dev libffi-dev python3-dev \
    libmysqlclient-dev mysql-server \
    software-properties-common \
    dirmngr gnupg apt-transport-https ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# ==========================================================
# 2. R Installation + Bioconductor packages
# ----------------------------------------------------------
# Installs base R and commonly used CRAN + Bioconductor
# packages for bioinformatics and statistical analysis.
# ==========================================================
RUN apt-get update && apt-get install -y --no-install-recommends r-base && \
    R -e "install.packages(c('tidyverse', 'data.table', 'BiocManager'), repos='https://cloud.r-project.org')" && \
    R -e "BiocManager::install(c('ComplexHeatmap', 'limma', 'edgeR', 'DESeq2'), ask=FALSE)"

# ==========================================================
# 3. Python Data Science Stack
# ----------------------------------------------------------
# Installs modern Python tools for AI, ML, and data science.
# Includes support for Hugging Face transformers and GPU acceleration.
# ==========================================================
RUN pip install --upgrade pip setuptools wheel && \
    pip install \
      jupyterlab notebook \
      pandas numpy scipy scikit-learn matplotlib seaborn \
      sqlalchemy mysqlclient pymysql \
      xgboost lightgbm plotly bokeh polars \
      transformers datasets accelerate huggingface-hub safetensors

# ==========================================================
# 4. MySQL Configuration
# ----------------------------------------------------------
# Prepares directories and permissions for MySQL server
# to allow local database operations inside the container.
# ==========================================================
RUN mkdir -p /var/lib/mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld && \
    service mysql stop

# ==========================================================
# 5. Ollama Installation
# ----------------------------------------------------------
# Adds Ollama for local LLM inference and model management.
# Exposes port 11434 for external model access.
# ==========================================================
RUN curl -fsSL https://ollama.com/install.sh | bash && \
    ollama --version

# ==========================================================
# 6. Port Configuration
# ----------------------------------------------------------
# 3306 -> MySQL
# 8888 -> JupyterLab
# 11434 -> Ollama API
# ==========================================================
EXPOSE 3306
EXPOSE 8888
EXPOSE 11434

# ==========================================================
# 7. Jupyter Configuration
# ----------------------------------------------------------
# Enables remote access, root permissions, and disables browser auto-launch.
# ==========================================================
RUN mkdir -p /root/.jupyter && \
    echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py

# ==========================================================
# 8. Default Command
# ----------------------------------------------------------
# Starts in Bash. Optionally can be replaced with a startup
# script to auto-run Jupyter + Ollama.
# ==========================================================
CMD ["bash"]
