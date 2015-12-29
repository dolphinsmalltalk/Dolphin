"Filed out from Dolphin Smalltalk X6.1"!

HistoryBrowserAbstract subclass: #MethodHistoryBrowser
	instanceVariableNames: 'history selector debugger selection slider source'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodHistoryBrowser guid: (GUID fromString: '{58D8A262-AC1F-455C-AD71-5EBAB63F34E3}')!
MethodHistoryBrowser comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006-2008 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!MethodHistoryBrowser categoriesForClass!IDB Goodies! !
!MethodHistoryBrowser methodsFor!

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

idbAbout
	"Display the about view"

	self 
		idbAbout: '<n>Method History Browser<n>for<n>Dolphin Smalltalk 6.x<n><n>Version 6c<n>© 2005-2008 Ian Bartholomew<n>http://www.idb.me.uk' 
				expandMacros!

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
	(#(#showDifferences #restoreMethod #moveToLast) identityIncludes: aCommandQuery command)
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

	(class compile: (history at: selection) third) ifNil: [^MessageBox warning: 'Restore failed'].
	debugger ifNotNil: [debugger restartMethod]!

setCaption
	self
		caption:
			('MethodHistory - <1s>>><2s>  (<3d> of <4d>)'
				expandMacrosWith: class name
				with: selector asString
				with: selection
				with: history size)!

setClass: aClass selector: aSymbol debugger: aDebuggerOrNil
	"Initialze the list by locating the source for all the historical methods for the selected
	class/selector. Rememer if it was opened from a Debugger so that we can perform an additioal
	step if historical source is restored"

	class := aClass.
	selector := aSymbol.
	debugger := aDebuggerOrNil.
	self updateHistory!

showDifferences
	| differencesPresenter |
	differencesPresenter := DifferencesPresenter show.
	differencesPresenter topShell
		caption: ('Differences between version #<1d> and the current image' expandMacrosWith: selection).
	differencesPresenter
		beforeText: (history at: selection) third;
		beforeTitle: ('Version #<1d>' expandMacrosWith: selection);
		afterText: history last third;
		afterTitle: 'Current image';
		refresh!

updateHistory
	"Get the historic information for the method. Purge consecutive duplicates from the list"

	| temp |
	temp := Cursor wait showWhile: [self scanner forMethod: selector inClass: class].
	history := OrderedCollection with: temp first.
	temp
		do:
			[:each | history last first = each first & (history last third = each third) ifFalse: [history add: each]].
	self setCaption.
	self moveToLast!

updateSelection
	source
		text: (history at: selection) third;
		setFocus.
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
!MethodHistoryBrowser categoriesFor: #canPrint!printing!public!testing! !
!MethodHistoryBrowser categoriesFor: #createComponents!initializing!public! !
!MethodHistoryBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!MethodHistoryBrowser categoriesFor: #idbAbout!commands!public! !
!MethodHistoryBrowser categoriesFor: #moveTo:!operations!public! !
!MethodHistoryBrowser categoriesFor: #moveToFirst!commands!public! !
!MethodHistoryBrowser categoriesFor: #moveToLast!commands!public! !
!MethodHistoryBrowser categoriesFor: #moveToNext!commands!public! !
!MethodHistoryBrowser categoriesFor: #moveToPrevious!commands!public! !
!MethodHistoryBrowser categoriesFor: #onImageChanged:!event handling!public! !
!MethodHistoryBrowser categoriesFor: #onSliderValueChanged!initializing!public! !
!MethodHistoryBrowser categoriesFor: #onViewClosed!event handling!public! !
!MethodHistoryBrowser categoriesFor: #onViewOpened!event handling!public! !
!MethodHistoryBrowser categoriesFor: #printableView!accessing!printing!public! !
!MethodHistoryBrowser categoriesFor: #queryCommand:!commands!public! !
!MethodHistoryBrowser categoriesFor: #restoreMethod!commands!public! !
!MethodHistoryBrowser categoriesFor: #setCaption!operations!public! !
!MethodHistoryBrowser categoriesFor: #setClass:selector:debugger:!accessing!public! !
!MethodHistoryBrowser categoriesFor: #showDifferences!commands!public! !
!MethodHistoryBrowser categoriesFor: #updateHistory!operations!public! !
!MethodHistoryBrowser categoriesFor: #updateSelection!event handling!public! !

!MethodHistoryBrowser class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 328198 ##(Smalltalk.Point)  1261 601 551 0 0 0 416 852230 ##(Smalltalk.FramingLayout)  234 240 98 4 410 8 ##(Smalltalk.ScintillaView)  98 46 0 416 98 2 8 1174475012 1025 608 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 196934 1 ##(Smalltalk.RGB)  30277631 0 7 0 0 0 608 0 8 4294903303 852486 ##(Smalltalk.NullConverter)  0 0 11 0 234 256 98 6 8 #lineNumber 1182726 ##(Smalltalk.ScintillaTextStyle)  67 0 0 1 0 0 0 0 864 0 0 0 8 #normal 882 1 0 0 1 0 0 0 0 912 0 0 0 8 #indentGuide 882 75 0 0 1 0 0 0 0 944 0 0 0 98 40 928 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 896 0 0 0 960 0 0 1377542 ##(Smalltalk.SmalltalkMethodStyler)  1 0 0 32 202 208 98 0 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  0 1 786694 ##(Smalltalk.IndexedColor)  33554433 1138 33554471 608 8 #circle 202 208 1040 0 63 9215 0 0 0 0 1138 33554447 0 0 0 0 0 234 256 98 6 8 #literalArray 8 '()' 8 #literalBytes 8 '[]' 8 #specialCharacter 8 '()[]<>' 8 '' 1 234 256 1040 0 0 0 0 3 0 234 256 98 4 8 'indicator1' 1509190 1 ##(Smalltalk.ScintillaIndicatorStyle)  3 608 33423361 5 32 0 0 8 'indicator0' 1442 1 608 65025 3 32 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 7 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 514 1 73 514 1245 421 608 1570 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 608 1570 8 #isTextModified: 98 1 32 608 1570 8 #modificationEventMask: 98 1 9215 608 1570 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin)  1 608 1 3 32 1 1906 3 608 1 1 32 67108863 1906 5 608 1 1 32 1 608 1570 8 #indentationGuides: 98 1 0 608 1570 8 #tabIndents: 98 1 16 608 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 36 0 0 0 110 2 0 0 246 0 0 0] 98 0 514 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedParentLeft 1 2178 8 #fixedParentRight 1 2178 8 #fixedPreviousBottom 1 2178 8 #fixedParentBottom 1 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 2320 0 0 0 7 0 0 0 2320 546 234 240 98 6 410 2336 98 15 0 2320 98 2 8 1140850688 131073 2448 0 0 0 7 0 0 0 2448 546 234 240 98 10 410 8 ##(Smalltalk.PushButton)  98 20 0 2448 98 2 8 1140924416 1 2560 0 0 0 7 0 0 0 2560 0 8 4294903329 1180998 4 ##(Smalltalk.CommandDescription)  8 #moveToPrevious 8 '<' 1 1 0 0 32 0 0 0 1506 202 208 98 3 1570 1600 98 2 514 65 9 514 49 57 2560 1570 8 #isEnabled: 98 1 32 2560 1570 8 #text: 98 1 8 '<' 2560 2066 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 0 0 0 4 0 0 0 56 0 0 0 32 0 0 0] 98 0 2128 0 29 2146 2178 8 #fixedPreviousRight 9 2178 8 #fixedViewLeft 49 2178 8 #fixedParentTop 9 2288 -7 410 2576 98 20 0 2448 98 2 8 1140924416 1 3104 0 0 0 7 0 0 0 3104 0 8 4294903329 2658 8 #moveToFirst 8 '|<' 1 1 0 0 32 0 0 0 1506 202 208 98 3 1570 1600 98 2 514 9 9 514 49 57 3104 1570 2848 98 1 32 3104 1570 2896 98 1 8 '|<' 3104 2066 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 28 0 0 0 32 0 0 0] 98 0 2128 0 29 2146 2192 9 3040 49 3072 9 2288 -7 410 8 ##(Smalltalk.Slider)  98 18 0 2448 98 2 8 1140916485 1 3488 690 0 32 1376774 ##(Smalltalk.PluggableSearchPolicy)  459270 ##(Smalltalk.Message)  8 #= 98 0 3618 8 #hash 98 0 3 0 0 7 0 0 0 3488 0 8 4294903429 802 0 0 3 0 0 1506 202 208 98 3 1570 1600 98 2 514 121 1 514 361 71 3488 1570 8 #pageSize: 98 1 3 3488 1570 8 #range: 98 1 1714 1 3 3 3488 2066 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 0 0 0 0 240 0 0 0 35 0 0 0] 98 0 2128 0 27 2146 2192 121 2224 -119 3072 1 2178 8 #fixedViewTop 71 410 2576 98 20 0 2448 98 2 8 1140924416 1 4080 0 0 0 7 0 0 0 4080 0 8 4294903329 2658 8 #moveToLast 8 '>|' 1 1 0 0 32 0 0 0 1506 202 208 98 3 1570 1600 98 2 514 545 9 514 49 57 4080 1570 2848 98 1 32 4080 1570 2896 98 1 8 '>|' 4080 2066 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 4 0 0 0 40 1 0 0 32 0 0 0] 98 0 2128 0 29 2146 2178 8 #fixedViewRight -47 2224 -7 3072 9 2288 -7 410 2576 98 20 0 2448 98 2 8 1140924416 1 4496 0 0 0 7 0 0 0 4496 0 8 4294903329 2658 8 #moveToNext 8 '>' 1 1 0 0 32 0 0 0 1506 202 208 98 3 1570 1600 98 2 514 489 9 514 49 57 4496 1570 2848 98 1 32 4496 1570 2896 98 1 8 '>' 4496 2066 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 244 0 0 0 4 0 0 0 12 1 0 0 32 0 0 0] 98 0 2128 0 29 2146 4464 -47 2178 8 #fixedPreviousLeft -7 3072 9 2288 -7 234 256 98 2 3488 8 'slider' 0 1506 202 208 98 1 1570 1600 98 2 514 323 1 514 601 73 2448 2066 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 161 0 0 0 0 0 0 0 205 1 0 0 36 0 0 0] 98 5 3104 2560 4080 4496 3488 2128 0 27 2146 3008 51 3040 601 3072 1 2288 1 410 2576 98 20 0 2320 98 2 8 1140924416 1 5136 0 0 0 7 0 0 0 5136 0 8 4294903329 2658 8 #restoreMethod 8 'Restore' 1 1 0 0 32 0 0 0 1506 202 208 98 3 1570 1600 98 2 514 17 9 514 121 57 5136 1570 2848 98 1 32 5136 1570 2896 98 1 8 'Restore' 5136 2066 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 4 0 0 0 68 0 0 0 32 0 0 0] 98 0 2128 0 29 2146 2192 17 3040 121 3072 9 2288 -7 410 2576 98 20 0 2320 98 2 8 1140924416 1 5520 0 0 0 7 0 0 0 5520 0 8 4294903329 2658 8 #showDifferences 8 'Diff' 1 1 0 0 32 0 0 0 1506 202 208 98 3 1570 1600 98 2 514 153 9 514 121 57 5520 1570 2848 98 1 32 5520 1570 2896 98 1 8 'Diff' 5520 2066 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 0 0 0 4 0 0 0 136 0 0 0 32 0 0 0] 98 0 2128 0 29 2146 3008 17 3040 121 3072 9 2288 -7 234 256 1040 0 1506 202 208 98 1 1570 1600 98 2 514 1 1 514 1245 73 2320 2066 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 110 2 0 0 36 0 0 0] 98 3 5136 5520 2448 2128 0 27 2146 2192 1 2224 1 3072 1 4048 73 234 256 98 2 608 8 'source' 590342 ##(Smalltalk.Rectangle)  514 1 1 514 1 1 461638 4 ##(Smalltalk.MenuBar)  0 16 98 4 265030 4 ##(Smalltalk.Menu)  0 16 98 5 984134 2 ##(Smalltalk.CommandMenuItem)  1 2658 8 #pageSetup 8 'Page &setup...' 1 1 0 0 0 6306 1 2658 8 #printPreview 8 'Print p&review...' 1 1 0 0 0 6306 1 2658 8 #print 8 '&Print...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 6306 1 2658 8 #exit 8 '&Close' 16615 1 0 0 0 8 '&File' 0 1 0 0 10069 0 0 6258 0 16 98 3 6306 1 2658 8 #copySelection 8 '&Copy' 1 1 0 0 0 6306 1 2658 5232 8 '&Restore' 9381 1 0 0 0 6306 1 2658 5616 8 '&Differences' 9353 1 0 0 0 8 '&Edit' 0 1 0 0 10077 0 0 6258 0 16 98 4 6306 1 2658 3200 8 '&First' 1605 1 0 0 0 6306 1 2658 2688 8 '&Previous' 1611 1 0 0 0 6306 1 2658 4592 8 '&Next' 1615 1 0 0 0 6306 1 2658 4176 8 '&Last' 1603 1 0 0 0 8 '&Selection' 0 134217729 0 0 10087 0 0 6258 0 16 98 2 6306 1 2658 8 #idbHelp 8 '&Help' 1 1 0 0 0 6306 1 2658 8 #idbAbout 8 '&About' 1 1 0 0 0 8 '&Help' 0 134217729 0 0 10093 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1506 202 208 98 3 1570 1600 98 2 514 2047 21 514 1261 601 416 1570 2896 98 1 8 'Method History' 416 1570 8 #updateMenuBar 1040 416 2066 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 10 0 0 0 117 6 0 0 54 1 0 0] 98 2 2320 608 2128 0 27 )!

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
!MethodHistoryBrowser class categoriesFor: #showOnClass:selector:debugger:!instance creation!public! !

