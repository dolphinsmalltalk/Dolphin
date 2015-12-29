"Filed out from Dolphin Smalltalk X6.1"!

HistoryBrowserAbstract subclass: #ClassHistoryBrowser
	instanceVariableNames: 'list'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassHistoryBrowser guid: (GUID fromString: '{30A97C72-065A-4C23-9F8E-DC13497F6EDA}')!
ClassHistoryBrowser comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006-2008 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ClassHistoryBrowser categoriesForClass!IDB Goodies! !
!ClassHistoryBrowser methodsFor!

browseHistory
	"Private - Open up a MethodHistoryBrowser on the selected method to allow
	a previous version to be located and, optionally restored"

	MethodHistoryBrowser showOnClass: class selector: list selection first!

browseMethod
	"Private - Open up a ClassBrowser on the selected method"

	(class includesSelector: list selection first)
		ifTrue: [(class compiledMethodAt: list selection first) browse]!

createComponents
	super createComponents.
	list := self add: ListPresenter new name: 'list'!

createSchematicWiring
	super createSchematicWiring.
	list
		when: #actionPerformed
		send: #browseHistory
		to: self.
	(SmalltalkSystem current)
		when: #methodAdded:
			send: #onMethodAdded:
			to: self;
		when: #methodUpdated:
			send: #onMethodUpdated:
			to: self;
		when: #methodRemoved:
			send: #onMethodRemoved:
			to: self!

historyStatusFor: aSymbol in: aCollection
	| inSources inChanges |
	(class includesSelector: aSymbol) ifFalse: [^'deleted'].
	inSources := aCollection anySatisfy: [:each | each first = #sources].
	inChanges := aCollection anySatisfy: [:each | each first = #changes].
	inSources & inChanges ifTrue: [^'modified'].
	inSources not & inChanges ifTrue: [^'added'].
	^'original'!

idbAbout
	"Display the about view"

	self 
		idbAbout: '<n>Class History Browser<n>for<n>Dolphin Smalltalk 6.x<n><n>Version 6c<n>© 2005-2008 Ian Bartholomew<n>http://www.idb.me.uk' 
				expandMacros!

onImageChanged: aCompiledMethod
	"Private - The image has changed. If it is a method in the class we are displaying
	then reinitialize to catch the changes"

	| currentSelection |
	aCompiledMethod methodClass == class ifFalse: [^self].
	currentSelection := list hasSelection ifTrue: [list selection first].
	self setClass: class.
	currentSelection ifNil: [^self].
	list selection: (list list detect: [:each | each first == currentSelection])!

onViewClosed
	"Private - This is needed to prevent events trying to access this shell
	after it is closed but before it is garbage collected"

	super onViewClosed.
	SmalltalkSystem current removeEventsTriggeredFor: self!

queryCommand: aCommandQuery
	aCommandQuery command = #browseHistory
		ifTrue:
			[aCommandQuery isEnabled: list hasSelection.
			^true].
	aCommandQuery command = #browseMethod
		ifTrue:
			[aCommandQuery isEnabled: (list hasSelection and: [class includesSelector: list selection first]).
			^true].
	^super queryCommand: aCommandQuery!

setClass: aClass
	"Private - Initialize the list. This is used the first time the browser is opened and
	also whenever a method in the selected class is edivted/deleted"

	class := aClass.
	self caption: ('Method History for <1s>' expandMacrosWith: class printString).
	self updateHistory!

updateHistory
	| chunks selectors methodHistory |
	chunks := Cursor wait showWhile: [self scanner forMethodsInClass: class].
	selectors := (chunks collect: [:each | each second]) asSet asSortedCollection asOrderedCollection.
	methodHistory := selectors
		collect:
			[:eachSelector | 
			| selectorChunks |
			selectorChunks := chunks select: [:each | each second = eachSelector].
			(Array new: 4)
				at: 1 put: eachSelector;
				at: 2 put: (self historyStatusFor: eachSelector in: selectorChunks);
				at: 3 put: (selectorChunks select: [:each | each first = #sources]) size;
				at: 4 put: (selectorChunks select: [:each | each first = #changes]) size;
				yourself].
	list list: methodHistory! !
!ClassHistoryBrowser categoriesFor: #browseHistory!commands!public! !
!ClassHistoryBrowser categoriesFor: #browseMethod!commands!public! !
!ClassHistoryBrowser categoriesFor: #createComponents!initializing!public! !
!ClassHistoryBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!ClassHistoryBrowser categoriesFor: #historyStatusFor:in:!helpers!public! !
!ClassHistoryBrowser categoriesFor: #idbAbout!commands!public! !
!ClassHistoryBrowser categoriesFor: #onImageChanged:!event handling!public! !
!ClassHistoryBrowser categoriesFor: #onViewClosed!event handling!public! !
!ClassHistoryBrowser categoriesFor: #queryCommand:!commands!public! !
!ClassHistoryBrowser categoriesFor: #setClass:!initializing!public! !
!ClassHistoryBrowser categoriesFor: #updateHistory!initializing!public! !

!ClassHistoryBrowser class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 328198 ##(Smalltalk.Point)  1001 701 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140920397 1025 576 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 2 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #browseHistory 8 'Method history' 1 1 0 0 0 850 1 882 8 #browseMethod 8 'Method browser' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 576 0 8 4294903419 8 ##(Smalltalk.BasicListAbstract)  0 1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 4 920646 5 ##(Smalltalk.ListViewColumn)  8 'Selector' 497 8 #left 1040 8 ##(Smalltalk.SortedCollection)  787814 3 ##(Smalltalk.BlockClosure)  0 459302 ##(Smalltalk.Context)  1 1 0 0 1180966 ##(Smalltalk.CompiledExpression)  0 9 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 98 2 8 '[:o | o at: 1]' 98 1 202 8 ##(Smalltalk.PoolDictionary)  704 8 #[252 1 0 1 1 8 0 17 230 32 228 32 63 148 106 100 105] 17 257 0 0 576 0 3 0 0 1122 8 'Status' 161 8 #center 1040 1184 1202 0 1234 1 1 0 0 1266 0 9 1296 8 'doIt' 98 2 8 '[:o | o at: 2]' 98 1 202 1392 704 8 #[252 1 0 1 1 8 0 17 230 32 228 32 64 148 106 100 105] 17 257 0 0 576 0 1 0 0 1122 8 'Sources' 161 1456 1040 1184 1202 0 1234 1 1 0 0 1266 0 9 1296 8 'doIt' 98 2 8 '[:o | o at: 3]' 98 1 202 1392 704 8 #[252 1 0 1 1 9 0 17 230 32 228 32 214 3 148 106 100 105] 17 257 0 0 576 0 1 0 0 1122 8 'Changes' 161 1456 1040 1184 1202 0 1234 1 1 0 0 1266 0 9 1296 8 'doIt' 98 2 8 '[:o | o at: 4]' 98 1 202 1392 704 8 #[252 1 0 1 1 9 0 17 230 32 228 32 214 4 148 106 100 105] 17 257 0 0 576 0 1 0 0 8 #report 704 0 131169 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 514 1 1 514 985 593 576 2050 8 #contextMenu: 98 1 816 576 2050 8 #text: 98 1 8 'Selector' 576 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 236 1 0 0 40 1 0 0] 98 0 514 193 193 0 27 234 256 98 2 576 8 'list' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 2 802 0 16 98 1 850 1 882 8 #exit 8 '&Close' 16615 1 0 0 0 8 '&File' 0 134217729 0 0 9693 0 0 802 0 16 98 2 850 1 882 8 #idbHelp 8 '&Help' 1 1 0 0 0 850 1 882 8 #idbAbout 8 '&About' 1 1 0 0 0 8 '&Help' 0 134217729 0 0 9699 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1986 202 208 98 3 2050 2080 98 2 514 2047 21 514 1001 701 416 2050 2208 98 1 8 'Class History' 416 2050 8 #updateMenuBar 704 416 2258 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 10 0 0 0 243 5 0 0 104 1 0 0] 98 1 576 2320 0 27 )!

showOnClass: aClass
	^self show setClass: aClass! !
!ClassHistoryBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!ClassHistoryBrowser class categoriesFor: #showOnClass:!instance creation!public! !

