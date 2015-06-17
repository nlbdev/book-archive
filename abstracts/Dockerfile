FROM josteinaj/depify

MAINTAINER Jostein Austvik Jacobsen

ADD src/main/resources /root/make-abstract/

RUN mkdir xproc && cd xproc && depify xproc && chmod +x xproc.sh && cat "`pwd`/xproc.sh" | grep . > /bin/xproc && chmod +x /bin/xproc

CMD ["xproc", "make-abstract/make-abstract.xpl"]
