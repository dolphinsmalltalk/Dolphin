"Filed out from Dolphin Smalltalk"!

SmalltalkToolShell subclass: #IdbShell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdbShell guid: (GUID fromString: '{d143e0f5-fb16-48b9-999e-c66f61c6fd3e}')!
IdbShell comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!IdbShell categoriesForClass!IDB Goodies! !
!IdbShell methodsFor!

idbAbout
	self subclassResponsibility!

idbAbout: aString
	self class idbAbout: aString!

idbHelp
	self subclassResponsibility!

idbHelp: aFileNameStem
	self class idbHelp: aFileNameStem! !
!IdbShell categoriesForMethods!
idbAbout!public! !
idbAbout:!operations!public! !
idbHelp!public! !
idbHelp:!operations!public! !
!

!IdbShell class methodsFor!

defaultIconName
	^self idbDefaultIconName!

idbAbout: aString
	(Splash
		bitmap:
			(Bitmap fromFile: (File composePath: SessionManager current idbResourcesFolder subPath: 'about.bmp'))
		overlayWith:
			[:canvas | 
			Processor sleep: 1 seconds.
			canvas
				backgroundMode: TRANSPARENT;
				forecolor: Color blue;
				font: (Font name: 'Arial' pointSize: 11) beBold;
				formatText: aString
					in: ((0 @ 0 extent: 250 @ 180) insetBy: 8 @ 8)
					flags: DT_CENTER]) show!

idbHelp: aFileNameStem
	ShellLibrary default
		shellOpen:
			(File
				composePath: SessionManager current idbDocumentationFolder
				stem: aFileNameStem
				extension: 'html')! !
!IdbShell class categoriesForMethods!
defaultIconName!constants!public! !
idbAbout:!operations!public! !
idbHelp:!operations!public! !
!

