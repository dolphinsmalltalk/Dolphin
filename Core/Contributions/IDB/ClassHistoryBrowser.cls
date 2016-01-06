"Filed out from Dolphin Smalltalk X6.1"!

HistoryBrowser subclass: #ClassHistoryBrowser
	instanceVariableNames: 'class list'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassHistoryBrowser guid: (GUID fromString: '{30A97C72-065A-4C23-9F8E-DC13497F6EDA}')!
ClassHistoryBrowser comment: 'Searches the sources and changes files to provide a change history for a class and opens a browser on the results.

Usage:
ClassHistoryBrowser showOnClass: aClass

All methods in the class are displayed in the browser with 4 fields.

- The selector used when the method was saved.
- The status of the method
	- original......The method is in the image and only present in the sources file
	- added......The method is in the image and only present in the changes file
	- modified......The method is in the image and present in both the sources and changes file
	- deleted......The method is not in the image but is present in either the sources or changes file
- The number of times the method appears in the sources file (always 0 or 1)
- The number of times the method appears in the changes file

Double clicking in the list will open a MethodHistoryBrowser on the selection.  Note that although the ClassHistoryBrowser
might show multiple versions of a method the MethodHistoryBrowser may display fewer versions.  This is because the 
MethodHistoryBrowser automatically removes duplicate consecutive entries.

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ClassHistoryBrowser categoriesForClass!IDB Goodies! !
!ClassHistoryBrowser methodsFor!

about
	"Display the about view"

	self 
		about: '
Class History Browser
for
Dolphin Smalltalk 6.x

Version 6b
© 2005 Ian Bartholomew
http://www.idb.me.uk'!

browseHistory
	"Private - Open up a MethodHistoryBrowser on the selected method to allow
	a previous version to be located and, optionally restored"

	MethodHistoryBrowser showOnClass: class selector: (list selection at: 1)!

browseMethod
	"Private - Open up a ClassBrowser on the selected method"

	(class includesSelector: (list selection at: 1)) 
		ifTrue: [(class compiledMethodAt: (list selection at: 1)) browse]!

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
	inSources := aCollection anySatisfy: [:each | (each at: 1) = #sources].
	inChanges := aCollection anySatisfy: [:each | (each at: 1) = #changes].
	inSources & inChanges ifTrue: [^'modified'].
	inSources not & inChanges ifTrue: [^'added'].
	^'original'!

onImageChanged: aCompiledMethod
	"Private - The image has changed. If it is a method in the class we are displaying
	then reinitialize to catch the changes"

	| currentSelection |
	aCompiledMethod methodClass == class ifFalse: [^self].
	list hasSelection ifTrue: [currentSelection := list selection at: 1].
	self setClass: class.
	currentSelection isNil ifTrue: [^self].
	list selection: (list list detect: [:each | (each at: 1) == currentSelection])!

onMethodAdded: aCompilationResult
	self onImageChanged: aCompilationResult method!

onMethodRemoved: aCompiledMethod 
	self onImageChanged: aCompiledMethod!

onMethodUpdated: aCompilationResult 
	self onImageChanged: aCompilationResult method!

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
			[aCommandQuery isEnabled: (list hasSelection and: [class includesSelector: (list selection at: 1)]).
			^true].
	^super queryCommand: aCommandQuery!

setClass: aClass
	"Private - Initialize the list. This is used the first time the browser is opened and
	also whenever a method in the selected class is edivted/deleted"

	class := aClass.
	self caption: 'Method History for ' , class printString.
	self updateHistory!

updateHistory
	| chunks selectors methodHistory |
	Cursor wait showWhile: [chunks := self scanner forMethodsInClass: class].
	selectors := (chunks collect: [:each | each at: 2]) asSet asSortedCollection.
	methodHistory := OrderedCollection new.
	selectors do: 
			[:eachSelector | 
			| selectorChunks |
			selectorChunks := chunks select: [:each | (each at: 2) = eachSelector].
			methodHistory add: ((Array new: 4)
						at: 1 put: eachSelector;
						at: 2 put: (self historyStatusFor: eachSelector in: selectorChunks);
						at: 3 put: (selectorChunks select: [:each | (each at: 1) = #sources]) size;
						at: 4 put: (selectorChunks select: [:each | (each at: 1) = #changes]) size;
						yourself)].
	list list: methodHistory! !
!ClassHistoryBrowser categoriesFor: #about!commands!public! !
!ClassHistoryBrowser categoriesFor: #browseHistory!commands!public! !
!ClassHistoryBrowser categoriesFor: #browseMethod!commands!public! !
!ClassHistoryBrowser categoriesFor: #createComponents!initializing!public! !
!ClassHistoryBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!ClassHistoryBrowser categoriesFor: #historyStatusFor:in:!helpers!public! !
!ClassHistoryBrowser categoriesFor: #onImageChanged:!event handling!public! !
!ClassHistoryBrowser categoriesFor: #onMethodAdded:!event handling!public! !
!ClassHistoryBrowser categoriesFor: #onMethodRemoved:!event handling!public! !
!ClassHistoryBrowser categoriesFor: #onMethodUpdated:!event handling!public! !
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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 328198 ##(Smalltalk.Point)  1001 701 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140920397 1025 576 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.SearchPolicy)  8 #identity 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 2 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #browseHistory 8 'Method history' 1 1 0 0 0 882 1 914 8 #browseMethod 8 'Method browser' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 576 0 8 4294903223 8 ##(Smalltalk.BasicListAbstract)  0 730 8 ##(Smalltalk.IconImageManager)  8 #current 0 0 0 0 0 0 202 208 98 4 920646 5 ##(Smalltalk.ListViewColumn)  8 'Selector' 547 8 #left 1072 8 ##(Smalltalk.SortedCollection)  787814 3 ##(Smalltalk.BlockClosure)  0 459302 ##(Smalltalk.Context)  1 1 0 0 1180966 ##(Smalltalk.CompiledExpression)  0 9 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 98 2 8 '[:o | o at: 1]' 98 1 202 8 ##(Smalltalk.PoolDictionary)  704 8 #[252 1 0 1 1 8 0 17 230 32 228 32 63 148 106 100 105] 17 257 0 0 576 0 3 0 0 1170 8 'Status' 161 8 #center 1072 1232 1250 0 1282 1 1 0 0 1314 0 9 1344 8 'doIt' 98 2 8 '[:o | o at: 2]' 98 1 202 1440 704 8 #[252 1 0 1 1 8 0 17 230 32 228 32 64 148 106 100 105] 17 257 0 0 576 0 1 0 0 1170 8 'Sources' 161 1504 1072 1232 1250 0 1282 1 1 0 0 1314 0 9 1344 8 'doIt' 98 2 8 '[:o | o at: 3]' 98 1 202 1440 704 8 #[252 1 0 1 1 9 0 17 230 32 228 32 214 3 148 106 100 105] 17 257 0 0 576 0 1 0 0 1170 8 'Changes' 161 1504 1072 1232 1250 0 1282 1 1 0 0 1314 0 9 1344 8 'doIt' 98 2 8 '[:o | o at: 4]' 98 1 202 1440 704 8 #[252 1 0 1 1 9 0 17 230 32 228 32 214 4 148 106 100 105] 17 257 0 0 576 0 1 0 0 8 #report 704 0 131169 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 514 1 1 514 1035 593 576 2098 8 #contextMenu: 98 1 848 576 2098 8 #text: 98 1 8 'Selector' 576 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 5 2 0 0 40 1 0 0] 98 0 514 193 193 0 27 234 256 98 2 576 8 'list' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 2 834 0 16 98 1 882 1 914 8 #exit 8 '&Close' 16615 1 0 0 0 8 '&File' 0 134217729 0 0 22147 0 0 882 1 914 8 #about 8 '&About' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 1049350 ##(Smalltalk.AcceleratorTable)  0 16 98 1 721414 ##(Smalltalk.Association)  16615 2528 0 1 0 0 0 0 1 0 0 2034 202 208 98 3 2098 2128 98 2 514 2047 21 514 1051 701 416 2098 2256 98 1 8 'Class History' 416 2098 8 #menuBar: 98 1 2448 416 2306 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 10 0 0 0 12 6 0 0 104 1 0 0] 98 1 576 2368 0 27 )!

showOnClass: aClass
	^self show setClass: aClass! !
!ClassHistoryBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!ClassHistoryBrowser class categoriesFor: #showOnClass:!instance creation!public! !

