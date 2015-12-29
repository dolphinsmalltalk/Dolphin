"Filed out from Dolphin Smalltalk X6"!

SmalltalkToolShell subclass: #IdbShell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdbShell guid: (GUID fromString: '{D143E0F5-FB16-48B9-999E-C66F61C6FD3E}')!
IdbShell comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!IdbShell categoriesForClass!IDB Goodies! !
!IdbShell methodsFor!

idbAbout: aString 
	(Splash bitmap: (Bitmap fromFile: SessionManager current idbResourcesFolder , '\about.bmp')
		overlayWith: 
			[:canvas | 
			Processor sleep: 1000.
			canvas
				setBkMode: TRANSPARENT;
				forecolor: Color blue;
				font: (Font name: 'Arial' pointSize: 11) beBold;
				formatText: aString
					in: ((0 @ 0 extent: 250 @ 180) insetBy: 8 @ 8)
					flags: DT_CENTER]) 
			show!

idbHelp
	"Open up the index page for help on idb tools"

	ShellLibrary default shellOpen: (File composePath: SessionManager current idbDocumentationFolder
				subPath: self class name asLowercase , '.html')! !
!IdbShell categoriesFor: #idbAbout:!commands!public! !
!IdbShell categoriesFor: #idbHelp!commands!public! !

!IdbShell class methodsFor!

defaultIconName
	^self idbDefaultIconName! !
!IdbShell class categoriesFor: #defaultIconName!constants!public! !

