browser = google-chrome
xdotool = xdotool

all: html_0

test_%:
	python bin/soja_comp.py -e tests/test_$*.coffee
	
html_%:
	python bin/soja_comp.py tests/test_$*.coffee
	${xdotool} search __gen/test_$*.html__ windowactivate key F5 || ${browser} gen/test_$*.html
