FROM public.ecr.aws/docker/library/python:3.8-slim

RUN mkdir -p /app
COPY requirements.txt run-server.sh /app/
COPY src/index.py /app/src/

WORKDIR /app
RUN pip install -r requirements.txt --target=/app/libs

ENTRYPOINT ["bash", "/app/run-server.sh"]