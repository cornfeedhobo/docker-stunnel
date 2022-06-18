PHONY: dev run

dev:
	docker build -t stunnel:dev .

run: dev
	exec docker run --rm -it stunnel:dev ash
