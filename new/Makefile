browser = google-chrome
xdotool = xdotool

all: test_0

test_%:
	python bin/soja_comp.py tests/${@}.coffee
# 	${xdotool} search __gen/${@}__ windowactivate key F5 || ${browser} gen/$@.html
	
