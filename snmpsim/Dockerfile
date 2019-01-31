FROM python:3.4-slim

RUN pip install snmpsim

RUN adduser --system snmpsim

ADD files /usr/local/snmpsim/data

CMD snmpsimd.py --agent-udpv4-endpoint=0.0.0.0:1024 --process-user=snmpsim --process-group=nogroup $EXTRA_FLAGS
