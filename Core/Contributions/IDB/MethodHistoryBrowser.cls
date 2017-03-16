"Filed out from Dolphin Smalltalk 7"!

HistoryBrowser subclass: #MethodHistoryBrowser
	instanceVariableNames: 'history class selector debugger selection slider source'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodHistoryBrowser guid: (GUID fromString: '{58d8a262-ac1f-455c-ad71-5ebab63f34e3}')!
MethodHistoryBrowser comment: 'Searches the sources and changes files to provide a change history for a method and opens a browser on the results.

Usage:
ClassHistoryBrowser showOnClass: aClass selector: aSelectorSymbol

Versions of the method can be selected by using the controls at the top of the browser.

Versions are in the correct order but sequential duplicates have been removed.  If an method appears in the sources file 
and the changes file then the version from the sources file will be the first in the list.

The current version of the method can be
- copied.  To the clipboard
- restored.  The newly restored method will be added to the end of the list
- diffed.  A DifferencesPresenter will be opend comparing the current selection with the last version

If the IDB IDE Printer package is installed then the current version can be printed.


(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!MethodHistoryBrowser categoriesForClass!IDB Goodies! !
!MethodHistoryBrowser methodsFor!

about
	"Display the about view"

	self 
		about: '
Method History Browser
for
Dolphin Smalltalk 6.x

Version 6b
© 2005 Ian Bartholomew
http://www.idb.me.uk'!

canPrint
	^[super canPrint] on: MessageNotUnderstood do: [:e | false]!

createComponents
	super createComponents.
	slider := self add: NumberPresenter new name: 'slider'.
	source := self add: SmalltalkWorkspace new name: 'source'!

createSchematicWiring
	super createSchematicWiring.
	slider 
		when: #valueChanged
		send: #onSliderValueChanged
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

diff
	(DiffBrowser show)
		caption: class name , '>>' , selector;
		compare: ((history at: selection) at: 3)
			id: 'Version #' , selection printString
			and: ((history at: history size) at: 3)
			id: 'Current image'!

moveTo: anInteger 
	selection := anInteger.
	self updateSelection!

moveToFirst
	self moveTo: 1!

moveToLast
	self moveTo: history size!

moveToNext
	self moveTo: selection + 1!

moveToPrevious
	self moveTo: selection - 1!

onImageChanged: aCompiledMethod
	aCompiledMethod methodClass == class & (aCompiledMethod selector == selector)
		ifTrue: [self updateHistory]!

onMethodAdded: aCompilationResult
	self onImageChanged: aCompilationResult method!

onMethodRemoved: aCompiledMethod 
	self onImageChanged: aCompiledMethod!

onMethodUpdated: aCompilationResult 
	self onImageChanged: aCompilationResult method!

onSliderValueChanged
	self moveTo: slider model value!

onViewClosed
	"Private - This is needed to prevent events trying to access this shell
	after it is closed but before it is garbage collected"

	super onViewClosed.
	SmalltalkSystem current removeEventsTriggeredFor: self!

onViewOpened	
	super onViewOpened.
	selection := history size!

printableView
	^source view!

queryCommand: aCommandQuery 
	(#(#print #printPreview) identityIncludes: aCommandQuery command) 
		ifTrue: 
			[aCommandQuery isEnabled: self canPrint.
			^true].
	aCommandQuery command == #moveToFirst 
		ifTrue: 
			[aCommandQuery isEnabled: selection ~= 1.
			^true].
	(#(#diff #restoreMethod #moveToLast) identityIncludes: aCommandQuery command) 
		ifTrue: 
			[aCommandQuery isEnabled: selection ~= history size.
			^true].
	aCommandQuery command == #moveToPrevious 
		ifTrue: 
			[aCommandQuery isEnabled: history size ~= 1 & (selection > 1).
			^true].
	aCommandQuery command == #moveToNext 
		ifTrue: 
			[aCommandQuery isEnabled: history size ~= 1 & (selection < history size).
			^true].
	^super queryCommand: aCommandQuery!

restoreMethod
	"Restore the selected method. Check for a compilation failure - although it 
	should be obvious, the displayed  method will be in red , we don't want to 
	let this go without a warning. The history browser will be updated by the 
	normal event mechanism"

	(class compile: ((history at: selection) at: 3)) isNil
		ifTrue: [^MessageBox warning: 'Restore failed'].
	debugger ifNotNil: [debugger restartMethod]!

setCaption
	self caption: ((String writeStream)
				nextPutAll: 'MethodHistory - ';
				nextPutAll: class name;
				nextPutAll: '>>';
				nextPutAll: selector asString;
				nextPutAll: '  (';
				print: selection;
				nextPutAll: ' of ';
				print: history size;
				nextPut: $);
				contents)!

setClass: aClass selector: aSymbol debugger: aDebuggerOrNil
	"Initialze the list by locating the source for all the historical methods for the selected
	class/selector. Rememer if it was opened from a Debugger so that we can perform an additioal
	step if historical source is restored"

	class := aClass.
	selector := aSymbol.
	debugger := aDebuggerOrNil.
	self updateHistory!

updateHistory
	"Get the historic information for the method. Purge consecutive duplicates from the list"

	| temp |
	Cursor wait showWhile: [temp := self scanner forMethod: selector inClass: class].
	history := OrderedCollection with: temp first.
	temp do: 
			[:each | 
			(history last at: 1) = (each at: 1) & ((history last at: 3) = (each at: 3)) 
				ifFalse: [history add: each]].
	self setCaption.
	self moveToLast!

updateSelection
	source text: ((history at: selection) at: 3).
	history size = 1
		ifTrue:
			[(slider view)
				range: (0 to: 1);
				isEnabled: false.
			slider value: 1]
		ifFalse:
			[(slider view)
				range: (1 to: history size);
				isEnabled: true.
			slider value: selection].
	self setCaption! !
!MethodHistoryBrowser categoriesFor: #about!commands!public! !
!MethodHistoryBrowser categoriesFor: #canPrint!printing!public!testing! !
!MethodHistoryBrowser categoriesFor: #createComponents!initializing!public! !
!MethodHistoryBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!MethodHistoryBrowser categoriesFor: #diff!commands!public! !
!MethodHistoryBrowser categoriesFor: #moveTo:!operations!public! !
!MethodHistoryBrowser categoriesFor: #moveToFirst!commands!public! !
!MethodHistoryBrowser categoriesFor: #moveToLast!commands!public! !
!MethodHistoryBrowser categoriesFor: #moveToNext!commands!public! !
!MethodHistoryBrowser categoriesFor: #moveToPrevious!commands!public! !
!MethodHistoryBrowser categoriesFor: #onImageChanged:!event handling!public! !
!MethodHistoryBrowser categoriesFor: #onMethodAdded:!event handling!public! !
!MethodHistoryBrowser categoriesFor: #onMethodRemoved:!event handling!public! !
!MethodHistoryBrowser categoriesFor: #onMethodUpdated:!event handling!public! !
!MethodHistoryBrowser categoriesFor: #onSliderValueChanged!initializing!public! !
!MethodHistoryBrowser categoriesFor: #onViewClosed!event handling!public! !
!MethodHistoryBrowser categoriesFor: #onViewOpened!event handling!public! !
!MethodHistoryBrowser categoriesFor: #printableView!accessing!printing!public! !
!MethodHistoryBrowser categoriesFor: #queryCommand:!commands!public! !
!MethodHistoryBrowser categoriesFor: #restoreMethod!commands!public! !
!MethodHistoryBrowser categoriesFor: #setCaption!operations!public! !
!MethodHistoryBrowser categoriesFor: #setClass:selector:debugger:!accessing!public! !
!MethodHistoryBrowser categoriesFor: #updateHistory!operations!public! !
!MethodHistoryBrowser categoriesFor: #updateSelection!event handling!public! !

!MethodHistoryBrowser class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 328198 ##(Smalltalk.Point)  1261 601 551 0 0 0 416 852230 ##(Smalltalk.FramingLayout)  234 240 98 4 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 608 0 0 0 7 0 0 0 608 546 234 240 98 6 410 624 98 15 0 608 98 2 8 1140850688 131073 736 0 0 0 7 0 0 0 736 546 234 240 98 10 410 8 ##(Smalltalk.PushButton)  98 17 0 736 98 2 8 1140924416 1 848 0 0 0 7 0 0 0 848 0 8 4294902643 1180998 4 ##(Smalltalk.CommandDescription)  8 #moveToPrevious 8 '<' 1 1 0 0 32 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 514 65 9 514 49 57 848 1074 8 #isEnabled: 98 1 32 848 1074 8 #text: 98 1 8 '<' 848 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 0 0 0 4 0 0 0 56 0 0 0 32 0 0 0] 98 0 514 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.FramingCalculation)  8 #fixedPreviousRight 9 1402 1424 8 #fixedViewLeft 49 1402 1424 8 #fixedParentTop 9 1402 1424 8 #fixedParentBottom -7 410 8 ##(Smalltalk.Slider)  98 18 0 736 98 2 8 1140916485 1 1552 721990 2 ##(Smalltalk.ValueHolder)  0 32 1376774 ##(Smalltalk.PluggableSearchPolicy)  459270 ##(Smalltalk.Message)  8 #= 98 0 1698 8 #hash 98 0 3 0 0 7 0 0 0 1552 0 8 4294905329 852486 ##(Smalltalk.NullConverter)  0 0 3 0 0 1010 202 208 98 3 1074 1104 98 2 514 121 1 514 361 71 1552 1074 8 #pageSize: 98 1 3 1552 1074 8 #range: 98 1 525062 ##(Smalltalk.Interval)  1 3 3 1552 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 0 0 0 0 240 0 0 0 35 0 0 0] 98 0 1344 0 27 1362 1402 1424 8 #fixedParentLeft 121 1402 1424 8 #fixedParentRight -119 1488 1 1402 1424 8 #fixedViewTop 71 410 864 98 17 0 736 98 2 8 1140924416 1 2256 0 0 0 7 0 0 0 2256 0 8 4294902643 946 8 #moveToFirst 8 '|<' 1 1 0 0 32 1010 202 208 98 3 1074 1104 98 2 514 9 9 514 49 57 2256 1074 1184 98 1 32 2256 1074 1232 98 1 8 '|<' 2256 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 28 0 0 0 32 0 0 0] 98 0 1344 0 27 1362 2160 9 1456 49 1488 9 1520 -7 410 864 98 17 0 736 98 2 8 1140924416 1 2640 0 0 0 7 0 0 0 2640 0 8 4294902643 946 8 #moveToLast 8 '>|' 1 1 0 0 32 1010 202 208 98 3 1074 1104 98 2 514 545 9 514 49 57 2640 1074 1184 98 1 32 2640 1074 1232 98 1 8 '>|' 2640 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 4 0 0 0 40 1 0 0 32 0 0 0] 98 0 1344 0 27 1362 1402 1424 8 #fixedViewRight -47 2192 -7 1488 9 1520 -7 410 864 98 17 0 736 98 2 8 1140924416 1 3056 0 0 0 7 0 0 0 3056 0 8 4294902643 946 8 #moveToNext 8 '>' 1 1 0 0 32 1010 202 208 98 3 1074 1104 98 2 514 489 9 514 49 57 3056 1074 1184 98 1 32 3056 1074 1232 98 1 8 '>' 3056 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 244 0 0 0 4 0 0 0 12 1 0 0 32 0 0 0] 98 0 1344 0 27 1362 3024 -47 1402 1424 8 #fixedPreviousLeft -7 1488 9 1520 -7 234 256 98 2 1552 8 'slider' 0 1010 202 208 98 1 1074 1104 98 2 514 323 1 514 601 73 736 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 161 0 0 0 0 0 0 0 205 1 0 0 36 0 0 0] 98 5 2256 848 2640 3056 1552 1344 0 27 1362 1408 51 1456 601 1488 1 1520 1 410 864 98 17 0 608 98 2 8 1140924416 1 3696 0 0 0 7 0 0 0 3696 0 8 4294902643 946 8 #restoreMethod 8 'Restore' 1 1 0 0 32 1010 202 208 98 3 1074 1104 98 2 514 17 9 514 121 57 3696 1074 1184 98 1 32 3696 1074 1232 98 1 8 'Restore' 3696 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 4 0 0 0 68 0 0 0 32 0 0 0] 98 0 1344 0 27 1362 2160 17 1456 121 1488 9 1520 -7 410 864 98 17 0 608 98 2 8 1140924416 1 4080 0 0 0 7 0 0 0 4080 0 8 4294902643 946 8 #diff 8 'Diff' 1 1 0 0 32 1010 202 208 98 3 1074 1104 98 2 514 153 9 514 121 57 4080 1074 1184 98 1 32 4080 1074 1232 98 1 8 'Diff' 4080 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 0 0 0 4 0 0 0 136 0 0 0 32 0 0 0] 98 0 1344 0 27 1362 1408 17 1456 121 1488 9 1520 -7 234 256 98 0 0 1010 202 208 98 1 1074 1104 98 2 514 1 1 514 1245 73 608 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 110 2 0 0 36 0 0 0] 98 3 3696 4080 736 1344 0 27 1362 2160 1 2192 1 1488 1 2224 73 410 8 ##(Smalltalk.ScintillaView)  98 46 0 416 98 2 8 1174475012 1025 4672 1634 0 32 1402 8 ##(Smalltalk.SearchPolicy)  8 #equality 0 196934 1 ##(Smalltalk.RGB)  30277631 0 7 0 0 0 4672 0 72569627 1826 0 0 11 0 234 256 98 6 8 #indentGuide 1182726 ##(Smalltalk.ScintillaTextStyle)  75 0 0 1 0 0 0 0 4896 0 0 0 8 #lineNumber 4914 67 0 0 1 0 0 0 0 4944 0 0 0 8 #normal 4914 1 0 0 1 0 0 0 0 4976 0 0 0 98 40 4992 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4960 0 0 0 4928 0 0 1377542 ##(Smalltalk.SmalltalkMethodStyler)  1 0 0 32 202 208 4480 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  0 1 786694 ##(Smalltalk.IndexedColor)  33554433 5154 33554471 4672 8 #circle 202 208 4480 0 63 0 0 0 0 0 5154 33554447 0 0 0 0 0 234 256 98 6 8 #literalBytes 8 '[]' 8 #literalArray 8 '()' 8 #specialCharacter 8 '()[]<>' 8 '' 1 234 256 4480 0 0 0 0 3 0 0 1010 202 208 98 8 1074 1104 98 2 514 1 73 514 1245 421 4672 1074 8 #selectionRange: 98 1 2066 3 1 3 4672 1074 8 #isTextModified: 98 1 32 4672 1074 8 #modificationEventMask: 98 1 9215 4672 1074 8 #indicatorDefinitions: 98 1 98 2 1836038 ##(Smalltalk.ScintillaIndicatorDefinition)  1 4672 65025 3 5746 3 4672 33423361 5 4672 1074 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin)  1 4672 1 3 32 1 5858 3 4672 1 1 32 67108863 5858 5 4672 1 1 32 1 4672 1074 8 #markers: 98 1 5216 4672 1074 8 #tabIndents: 98 1 16 4672 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 36 0 0 0 110 2 0 0 246 0 0 0] 98 0 1344 0 27 1362 2160 1 2192 1 1402 1424 8 #fixedPreviousBottom 1 1520 1 234 256 98 2 4672 8 'source' 590342 ##(Smalltalk.Rectangle)  514 1 1 514 1 1 461638 4 ##(Smalltalk.MenuBar)  0 16 98 4 265030 4 ##(Smalltalk.Menu)  0 16 98 5 984134 2 ##(Smalltalk.CommandMenuItem)  1 946 8 #pageSetup 8 'Page &setup...' 1 1 0 0 0 6322 1 946 8 #printPreview 8 'Print p&review...' 1 1 0 0 0 6322 1 946 8 #print 8 '&Print...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 6322 1 946 8 #exit 8 '&Close' 16615 1 0 0 0 8 '&File' 0 1 0 0 49303 0 0 6274 0 16 98 3 6322 1 946 8 #copySelection 8 '&Copy' 1 1 0 0 0 6322 1 946 3792 8 '&Restore' 9381 1 0 0 0 6322 1 946 4176 8 '&Diff' 9353 1 0 0 0 8 '&Edit' 0 1 0 0 49311 0 0 6274 0 16 98 4 6322 1 946 2352 8 '&First' 1605 1 0 0 0 6322 1 946 976 8 '&Previous' 1611 1 0 0 0 6322 1 946 3152 8 '&Next' 1615 1 0 0 0 6322 1 946 2736 8 '&Last' 1603 1 0 0 0 8 '&Position' 0 134217729 0 0 49321 0 0 6322 1 946 8 #about 8 '&About!!' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 1049414 1 ##(Smalltalk.AcceleratorTable)  0 16 234 256 98 14 9353 6800 16615 6576 1611 6944 9381 6752 1615 6992 1603 7040 1605 6896 0 1 0 0 0 0 1 0 0 1010 202 208 98 3 1074 1104 98 2 514 2799 21 514 1261 601 416 1074 1232 98 1 8 'Method History' 416 1074 8 #menuBar: 98 1 6240 416 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 237 7 0 0 54 1 0 0] 98 2 608 4672 1344 0 27 )!

showOnClass: aClass selector: aSymbol
	^self
		showOnClass: aClass
		selector: aSymbol
		debugger: nil!

showOnClass: aClass selector: aSymbol debugger: aDebuggerOrNil
	^self show
		setClass: aClass
		selector: aSymbol
		debugger: aDebuggerOrNil! !
!MethodHistoryBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!MethodHistoryBrowser class categoriesFor: #showOnClass:selector:!instance creation!public! !
!MethodHistoryBrowser class categoriesFor: #showOnClass:selector:debugger:!instance creation!private! !

