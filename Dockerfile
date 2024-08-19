FROM python:3.10.6-slim-bullseye AS basepackages
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update && apt-get install wget git libgl1 libglib2.0-0 curl rustc -y && apt-get clean
FROM basepackages AS app
RUN useradd -m automatic -d /app -s /bin/bash && chown -R automatic:automatic /app
USER automatic
WORKDIR /app
RUN pip install poetry
COPY . /app
RUN python -m poetry install
FROM app AS runtime
ENV HSA_OVERRIDE_GFX_VERSION=11.0.0
EXPOSE 7860
ENTRYPOINT [ "poetry", "run", "python", "launch.py" ]