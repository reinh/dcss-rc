all: reinh.rc

dep:
	brew bundle

reinh.rc:	reinh.rc.gpp rc/*.rc lua/*.lua
	gpp --includemarker '' -o reinh.rc reinh.rc.gpp

clean:
	rm reinh.rc
