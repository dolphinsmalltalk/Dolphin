"Filed out from Dolphin Smalltalk X6.1"!

IdbShell subclass: #IdbToolShell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdbToolShell guid: (GUID fromString: '{D5A39E13-1A86-4F66-B67F-C7875188C304}')!
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

uninitializeBeforeRemove
	self == ##(self)
		ifFalse:
			[(Smalltalk developmentSystem)
				removeSystemFolderIcon: self toolsFolderIcon;
				unregisterTool: self].
	super uninitializeBeforeRemove! !
!IdbToolShell class categoriesFor: #initializeAfterLoad!initializing!public! !
!IdbToolShell class categoriesFor: #uninitializeBeforeRemove!initializing!public! !

