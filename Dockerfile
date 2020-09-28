FROM bebit/python-mecab-builder:release-1.0 as builder

ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NOWARNINGS=yes

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt > /dev/null

FROM bebit/python-mecab:release-1.0 as base
ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NOWARNINGS=yes
COPY --from=builder /usr/local /usr/local

