"Filed out from Dolphin Smalltalk X6"!

SmalltalkToolShell subclass: #HistoryBrowser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HistoryBrowser guid: (GUID fromString: '{85DB197D-2437-4A92-801B-9872FB8A2183}')!
HistoryBrowser comment: 'Abstract superclass for the ClassHistoryBrowser and MethodHistoryBrowser

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!HistoryBrowser categoriesForClass!IDB Goodies! !
!HistoryBrowser methodsFor!

about: aString 
	"Display the about view"

	| edit |
	(Shell create view)
		layoutManager: BorderLayout new;
		hasMaximize: false;
		hasMinimize: false;
		isResizable: false;
		position: self view position + self view cursorPosition;
		extent: 200 @ 180;
		caption: 'About';
		addSubView: (edit := MultilineTextEdit new);
		show.
	edit
		arrangement: #center;
		isReadOnly: true;
		canVScroll: false;
		font: (Font name: 'Arial' pointSize: 10);
		alignment: #center;
		text: aString!

scanner
	"Answer the current scanner class"

	^ChunkFileMethodScanner! !
!HistoryBrowser categoriesFor: #about:!commands!public! !
!HistoryBrowser categoriesFor: #scanner!constants!public! !

!HistoryBrowser class methodsFor!

initialize
	#(#ClassBrowserAbstract #MethodBrowserShell #Debugger) 
		do: [:each | (Smalltalk at: each) addCommandQueryHandler: #queryMethodHistoryCommand:]!

uninitialize
	#(#ClassBrowserAbstract #MethodBrowserShell #Debugger) 
		do: [:each | (Smalltalk at: each) removeCommandQueryHandler: #queryMethodHistoryCommand:]! !
!HistoryBrowser class categoriesFor: #initialize!initializing!private! !
!HistoryBrowser class categoriesFor: #uninitialize!initializing!private! !

