CC=valac
CFLAGS= --pkg gtk+-3.0 --pkg glib-2.0 --pkg gstreamer-1.0 --pkg gstreamer-video-1.0 --pkg gdk-x11-3.0
SOURCES=$(wildcard *.vala) $(wildcard ./xmlbird/*.vala)
EXECUTABLE=main

all:
	$(CC) $(CFLAGS) $(SOURCES)

clean:
	rm $(EXECUTABLE)
