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

currentMethod
	^class ifNotNil: [class compiledMethodAt: selector ifAbsent: []]!

diff
	(DiffBrowser show)
		textFont: SmalltalkWorkspace actualFont;
		styler: SmalltalkMethodStyler new;
		textStyles: SmalltalkWorkspace textStyles;
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
	(aCompiledMethod methodClass == class and: [aCompiledMethod selector == selector])
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
	source view isReadOnly: true.
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
	(#(#diff #moveToLast) identityIncludes: aCommandQuery command) 
		ifTrue: 
			[aCommandQuery isEnabled: selection ~= history size.
			^true].
	#restoreMethod == aCommandQuery command 
		ifTrue: 
			[ | method |
			method := self currentMethod.
			aCommandQuery isEnabled: (method isNil or: [method getSource ~= self source]).
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

	(class compile: self source) isNil ifTrue: [^MessageBox warning: 'Restore failed'].
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

source
	^(history at: selection) at: 3!

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
!MethodHistoryBrowser categoriesFor: #currentMethod!accessing!private! !
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
!MethodHistoryBrowser categoriesFor: #source!commands!public! !
!MethodHistoryBrowser categoriesFor: #updateHistory!operations!public! !
!MethodHistoryBrowser categoriesFor: #updateSelection!event handling!public! !

!MethodHistoryBrowser class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 721158 ##(Smalltalk.SystemColor) 31 328198 ##(Smalltalk.Point) 1261 601 549 nil nil nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 592 nil nil nil 7 nil nil nil 592 530 170 176 34 6 410 ##(Smalltalk.PushButton) 34 20 nil 592 34 2 8 1140924416 1 704 nil nil nil 7 nil nil nil 704 nil 8 1905130144 1180998 4 ##(Smalltalk.CommandDescription) #restoreMethod 8 'Restore' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 17 9 498 121 57 704 898 #isEnabled: 8 #(false) 704 898 #text: 34 1 8 'Restore' 704 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 4 0 0 0 68 0 0 0 32 0 0 0] 8 #() 498 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 17 1170 #fixedViewLeft 121 1170 #fixedParentTop 9 1170 #fixedParentBottom -7 410 ##(Smalltalk.PushButton) 34 20 nil 592 34 2 8 1140924416 1 1248 nil nil nil 7 nil nil nil 1248 nil 8 1905130144 786 #diff 8 'Diff' 1 1 nil nil false nil nil nil 834 138 144 34 3 898 #createAt:extent: 34 2 498 153 9 498 121 57 1248 898 #isEnabled: 8 #(false) 1248 898 #text: 34 1 8 'Diff' 1248 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 0 0 0 4 0 0 0 136 0 0 0 32 0 0 0] 8 #() 1120 nil 29 1138 1170 #fixedPreviousRight 17 1200 121 1216 9 1232 -7 410 ##(Smalltalk.ContainerView) 34 15 nil 592 34 2 8 1140850688 131073 1632 nil nil nil 7 nil nil nil 1632 530 170 176 34 10 410 ##(Smalltalk.PushButton) 34 20 nil 1632 34 2 8 1140924416 1 1744 nil nil nil 7 nil nil nil 1744 nil 8 1905130144 786 #moveToPrevious 8 '<' 1 1 nil nil false nil nil nil 834 138 144 34 3 898 #createAt:extent: 34 2 498 65 9 498 49 57 1744 898 #isEnabled: 8 #(false) 1744 898 #text: 34 1 8 '<' 1744 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 0 0 0 4 0 0 0 56 0 0 0 32 0 0 0] 8 #() 1120 nil 29 1138 1616 9 1200 49 1216 9 1232 -7 410 ##(Smalltalk.Slider) 34 18 nil 1632 34 2 8 1140916485 1 2112 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 2242 #hash 8 #() 3 nil nil 7 nil nil nil 2112 nil 8 1905044304 852486 ##(Smalltalk.NullConverter) nil nil 3 nil nil 834 138 144 34 3 898 #createAt:extent: 34 2 498 121 1 498 361 71 2112 898 #pageSize: 8 #(1) 2112 898 #range: 34 1 525062 ##(Smalltalk.Interval) 1 3 3 2112 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 0 0 0 0 240 0 0 0 35 0 0 0] 8 #() 1120 nil 27 1138 1184 121 1170 #fixedParentRight -119 1216 1 1170 #fixedViewTop 71 410 ##(Smalltalk.PushButton) 34 20 nil 1632 34 2 8 1140924416 1 2672 nil nil nil 7 nil nil nil 2672 nil 8 1905130144 786 #moveToNext 8 '>' 1 1 nil nil false nil nil nil 834 138 144 34 3 898 #createAt:extent: 34 2 498 489 9 498 49 57 2672 898 #isEnabled: 8 #(false) 2672 898 #text: 34 1 8 '>' 2672 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 244 0 0 0 4 0 0 0 12 1 0 0 32 0 0 0] 8 #() 1120 nil 29 1138 1170 #fixedViewRight -47 1170 #fixedPreviousLeft -7 1216 9 1232 -7 410 ##(Smalltalk.PushButton) 34 20 nil 1632 34 2 8 1140924416 1 3072 nil nil nil 7 nil nil nil 3072 nil 8 1905130144 786 #moveToLast 8 '>|' 1 1 nil nil false nil nil nil 834 138 144 34 3 898 #createAt:extent: 34 2 498 545 9 498 49 57 3072 898 #isEnabled: 8 #(false) 3072 898 #text: 34 1 8 '>|' 3072 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 4 0 0 0 40 1 0 0 32 0 0 0] 8 #() 1120 nil 29 1138 3040 -47 2640 -7 1216 9 1232 -7 410 ##(Smalltalk.PushButton) 34 20 nil 1632 34 2 8 1140924416 1 3440 nil nil nil 7 nil nil nil 3440 nil 8 1905130144 786 #moveToFirst 8 '|<' 1 1 nil nil false nil nil nil 834 138 144 34 3 898 #createAt:extent: 34 2 498 9 9 498 49 57 3440 898 #isEnabled: 8 #(false) 3440 898 #text: 34 1 8 '|<' 3440 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 28 0 0 0 32 0 0 0] 8 #() 1120 nil 29 1138 1184 9 1200 49 1216 9 1232 -7 170 192 34 2 2112 8 'slider' nil 834 138 144 34 1 898 #createAt:extent: 34 2 498 323 1 498 601 73 1632 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 161 0 0 0 0 0 0 0 205 1 0 0 36 0 0 0] 34 5 3440 1744 3072 2672 2112 1120 nil 27 1138 1616 51 1200 601 1216 1 1232 1 170 192 8 #() nil 834 138 144 34 1 898 #createAt:extent: 34 2 498 1 1 498 1229 73 592 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 2 0 0 36 0 0 0] 34 3 704 1248 1632 1120 nil 27 1138 1184 1 2640 1 1216 1 2656 73 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140916224 131073 4240 nil 655878 ##(Smalltalk.ThemeColor) #smalltalkWorkspace nil 7 nil nil nil 4240 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 834 138 144 34 1 898 #createAt:extent: 34 2 498 1 73 498 1229 411 4240 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 36 0 0 0 102 2 0 0 241 0 0 0] 4048 1120 nil 27 1138 1184 1 2640 1 1170 #fixedPreviousBottom 1 1232 1 170 192 34 2 4240 8 'source' 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 786 #pageSetup 8 'Page &setup...' 1 1 nil nil nil 4754 1 786 #printPreview 8 'Print p&review...' 1 1 nil nil nil 4754 1 786 #print 8 '&Print...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4754 1 786 #exit 8 '&Close' 16615 1 nil nil nil 8 '&File' nil 1 nil nil 36493 nil nil 4706 nil true 34 3 4754 1 786 #copySelection 8 '&Copy' 1 1 nil nil nil 4754 1 786 #restoreMethod 8 '&Restore' 9381 1 nil nil nil 4754 1 786 #diff 8 '&Diff' 9353 1 nil nil nil 8 '&Edit' nil 1 nil nil 36501 nil nil 4706 nil true 34 4 4754 1 786 #moveToFirst 8 '&First' 1605 1 nil nil nil 4754 1 786 #moveToPrevious 8 '&Previous' 1611 1 nil nil nil 4754 1 786 #moveToNext 8 '&Next' 1615 1 nil nil nil 4754 1 786 #moveToLast 8 '&Last' 1603 1 nil nil nil 8 '&Position' nil 134217729 nil nil 36511 nil nil 4754 1 786 #about 8 '&About!!' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 834 138 144 34 3 898 #createAt:extent: 34 2 498 3839 21 498 1261 601 416 898 #text: 34 1 8 'Method History' 416 898 #updateMenuBar 4048 416 1058 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 245 9 0 0 54 1 0 0] 34 2 592 4240 1120 nil 27 )!

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

