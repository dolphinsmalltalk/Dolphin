"Filed out from Dolphin Smalltalk X6.1"!

SmalltalkToolShell subclass: #HistoryBrowserAbstract
	instanceVariableNames: 'class'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HistoryBrowserAbstract guid: (GUID fromString: '{85DB197D-2437-4A92-801B-9872FB8A2183}')!
HistoryBrowserAbstract comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006-2008 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!HistoryBrowserAbstract categoriesForClass!Unclassified! !
!HistoryBrowserAbstract methodsFor!

idbAbout
	self subclassResponsibility!

idbAbout: aString
	(self class environment includesKey: 'IdbShell')
		ifTrue: [(self class environment at: 'IdbShell') idbAbout: aString]
		ifFalse:
			[| edit |
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
				text: aString]!

idbHelp
	self idbHelp: 'idbmethodhistory'!

idbHelp: aFileNameStem
	(self class environment includesKey: 'IdbShell')
		ifTrue: [(self class environment at: 'IdbShell') idbHelp: aFileNameStem]
		ifFalse: [MessageBox notify: 'No help available for this tool']!

onImageChanged: aCompiledMethod
	self subclassResponsibility!

onMethodAdded: aCompilationResult
	self onImageChanged: aCompilationResult method!

onMethodRemoved: aCompiledMethod
	self onImageChanged: aCompiledMethod!

onMethodUpdated: aCompilationResult
	self onImageChanged: aCompilationResult method!

scanner
	"Answer the current scanner class"

	^ChunkFileMethodScanner!

updateHistory
	self subclassResponsibility! !
!HistoryBrowserAbstract categoriesFor: #idbAbout!commands!public! !
!HistoryBrowserAbstract categoriesFor: #idbAbout:!idb goodies!operations!public! !
!HistoryBrowserAbstract categoriesFor: #idbHelp!commands!public! !
!HistoryBrowserAbstract categoriesFor: #idbHelp:!idb goodies!operations!public! !
!HistoryBrowserAbstract categoriesFor: #onImageChanged:!event handling!public! !
!HistoryBrowserAbstract categoriesFor: #onMethodAdded:!event handling!public! !
!HistoryBrowserAbstract categoriesFor: #onMethodRemoved:!event handling!public! !
!HistoryBrowserAbstract categoriesFor: #onMethodUpdated:!event handling!public! !
!HistoryBrowserAbstract categoriesFor: #scanner!constants!public! !
!HistoryBrowserAbstract categoriesFor: #updateHistory!initializing!public! !

!HistoryBrowserAbstract class methodsFor!

initialize
	#(#ClassBrowserAbstract #MethodBrowserShell #Debugger)
		do: [:each | (Smalltalk at: each) addCommandQueryHandler: #queryMethodHistoryCommand:]!

uninitialize
	#(#ClassBrowserAbstract #MethodBrowserShell #Debugger)
		do: [:each | (Smalltalk at: each) removeCommandQueryHandler: #queryMethodHistoryCommand:]! !
!HistoryBrowserAbstract class categoriesFor: #initialize!initializing!public! !
!HistoryBrowserAbstract class categoriesFor: #uninitialize!initializing!public! !

