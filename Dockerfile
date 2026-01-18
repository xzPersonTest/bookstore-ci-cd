# Dockerfile
# 使用多阶段构建，减小镜像体积

# 阶段1: 构建阶段
FROM python:3.9-slim as builder

WORKDIR /app

# 复制依赖文件
COPY requirements.txt .

# 安装依赖（使用清华镜像加速）
RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 复制应用代码
COPY app/ ./app/
COPY tests/ ./tests/

# 阶段2: 运行时阶段
FROM python:3.9-slim

WORKDIR /app

# 从builder阶段复制已安装的包
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# 复制应用代码
COPY app/ ./app/

# 创建非root用户（安全最佳实践）
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# 暴露端口
EXPOSE 5000

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import requests; requests.get('http://localhost:5000')" || exit 1

# 启动命令
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0", "--port=5000"]