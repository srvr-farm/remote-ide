
.PHONY: install

install:
	mkdir -p /opt/code-server/bin
	cp -R service/opt/code-server/bin/* /opt/code-server/bin
	chmod +x /opt/code-server/bin/*
	cp service/usr/lib/systemd/system/code-server.service /usr/lib/systemd/system/
	systemctl daemon-reload
	systemd-analyze verify /usr/lib/systemd/system/code-server.service && sudo systemctl enable code-server.service && systemctl restart code-server.service

