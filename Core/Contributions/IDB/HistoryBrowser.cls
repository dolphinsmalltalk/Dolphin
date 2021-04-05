"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #HistoryBrowser
	instanceVariableNames: 'scanner'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HistoryBrowser guid: (GUID fromString: '{85db197d-2437-4a92-801b-9872fb8a2183}')!
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

initialize

	super initialize.
	scanner := self scannerClass new!

scanner
	^scanner!

scanner: aChunkFileMethodScanner
	scanner := aChunkFileMethodScanner!

scannerClass
	"Answer the current scanner class"

	^ChunkFileMethodScanner! !
!HistoryBrowser categoriesFor: #about:!commands!public! !
!HistoryBrowser categoriesFor: #initialize!initializing!public! !
!HistoryBrowser categoriesFor: #scanner!accessing!public! !
!HistoryBrowser categoriesFor: #scanner:!public! !
!HistoryBrowser categoriesFor: #scannerClass!constants!public! !

!HistoryBrowser class methodsFor!

icon
	^Icon fromId: 'MethodHistory.ico'!

initialize
	#(#{ClassBrowserAbstract} #{MethodBrowserShell} #{Debugger}) 
		do: [:each | each value addCommandQueryHandler: #queryMethodHistoryCommand:]!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		removeKey: #reuseIfOpen;
		yourself!

uninitialize
	#(#{ClassBrowserAbstract} #{MethodBrowserShell} #{Debugger})
		do: [:each | each value removeCommandQueryHandler: #queryMethodHistoryCommand:]! !
!HistoryBrowser class categoriesFor: #icon!public! !
!HistoryBrowser class categoriesFor: #initialize!initializing!private! !
!HistoryBrowser class categoriesFor: #publishedAspects!operations!public! !
!HistoryBrowser class categoriesFor: #uninitialize!initializing!private! !

