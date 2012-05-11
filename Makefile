# to run a test from the test directory, e.g. tests/test_xx.coffee, type "make test_xx" or "make soda_xx" if soda is necessary
# to launch an example from the tutorial 0, "make tuto_0_coffee" (for the coffee version) or "make tuto_0_js" (for the javascript version)
# xdotool is used to switch to an already existing window (to avoid respawning a browser for each launch)
browser = google-chrome
xdotool = xdotool

all: compilation

# see tests directory to see possible targets
test_%: compilation
	${xdotool} search __gen/${@}__ windowactivate key F5 || ${browser} gen/$@.html

# same s test but launched with Soda
soda_%: compilation ext/Soda
	make -C ext/Soda
	ext/Soda/soda --base-dir gen -l --start-page /test_$*.html

# launch the soda server
soda: compilation ext/Soda
	make -C ext/Soda
	ext/Soda/soda --base-dir gen
	
ext/Soda:
	mkdir -p ext; cd ext; test -e Soda || ( test -e ../../Soda && ln -s `pwd`/../../Soda . ) || git clone git@github.com:hleclerc/Soda.git


.PHONY: compilation
compilation:
	python bin/make.py
