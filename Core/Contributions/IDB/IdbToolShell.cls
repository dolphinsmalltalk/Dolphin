"Filed out from Dolphin Smalltalk 7"!

IdbShell subclass: #IdbToolShell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IdbToolShell guid: (GUID fromString: '{d5a39e13-1a86-4f66-b67f-c7875188c304}')!
IdbToolShell comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!IdbToolShell categoriesForClass!IDB Goodies! !
!IdbToolShell methodsFor!

addToCommandRoute: route
	super addToCommandRoute: route.
	route appendTarget: Smalltalk developmentSystem! !
!IdbToolShell categoriesFor: #addToCommandRoute:!commands!public! !

!IdbToolShell class methodsFor!

initializeAfterLoad
	self == ##(self)
		ifFalse:
			[(Smalltalk developmentSystem)
				addAdditionalToolsFolderIcon: self toolsFolderIcon;
				registerTool: self].
	super initializeAfterLoad!

initializeOptionFlags
	"Private - Set the default option flags."

	optionFlags := ReuseIfOpenMask! !
!IdbToolShell class categoriesFor: #initializeAfterLoad!initializing!public! !
!IdbToolShell class categoriesFor: #initializeOptionFlags!initializing!private! !

