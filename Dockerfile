FROM python:3.9-alpine AS builder

RUN apk add --no-cache \
    build-base \
    gfortran \
    musl-dev \
    lapack-dev \
    linux-headers \
    && python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app

COPY reqs.txt .

RUN pip install --no-cache-dir -r reqs.txt

FROM python:3.9-alpine

RUN apk add --no-cache libstdc++

WORKDIR /app

COPY --from=builder /opt/venv /opt/venv

COPY main.py .
COPY app.py .

ENV key=ENV value=PROD
ENV AUTHOR=STUDENT_NAME
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000
ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 5000

CMD ["flask", "run"]
