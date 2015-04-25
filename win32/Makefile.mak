TOPDIR = ..

!INCLUDE $(TOPDIR)\win32\Make.rules.mak

all: config.h

config.h: winconfig.h
	copy /y winconfig.h config.h
	dir /s $(WIX_PATH)

customactions.dll: customactions.obj
	echo LIBRARY $* > $*.def
	echo EXPORTS >> $*.def
	type customactions.exports >> $*.def
        link /dll $(LINKFLAGS) /def:$*.def /out:customactions.dll customactions.obj msi.lib $(WIX_LIB)\dutil.lib $(WIX_LIB)\wcautil.lib


OpenSC.msi: OpenSC.wixobj
        $(WIX_PATH)\bin\light.exe -sh -ext WixUIExtension -ext WiXUtilExtension $?

OpenSC.wixobj: OpenSC.wxs customactions.dll
        $(WIX_PATH)\bin\candle.exe -ext WiXUtilExtension -dSOURCE_DIR=$(TOPDIR) $(CANDLEFLAGS) $?

clean::
	del /Q config.h *.msi *.wixobj *.wixpdb
