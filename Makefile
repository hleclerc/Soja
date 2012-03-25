# to run a test from the test directory, e.g. tests/test_xx.coffee, type "make test_xx" or "make soda_xx" if soda is necessary
# to launch an example from the tutorial 0, "make tuto_0_coffee" (for the coffee version) or "make tuto_0_js" (for the javascript version)
# xdotool is used to switch to an already existing window (to avoid respawing a browser for each launch)
browser = google-chrome
xdotool = xdotool

all: compilation

# see tests directory to see possible targets
test_%: compilation
	${xdotool} search __gen/${@}__ windowactivate key F5 || ${browser} gen/$@.html

# same s test but launched with Soda
soda_%: compilation Soda
	make -C Soda
	Soda/soda -hd gen --start-page /test_$*.html

Soda:
	git clone git@sc1.ens-cachan.fr:Sodat Soda

.PHONY: compilation
compilation:
	python bin/make.py
