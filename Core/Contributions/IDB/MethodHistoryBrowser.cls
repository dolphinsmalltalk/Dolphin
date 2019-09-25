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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d 328198 ##(Smalltalk.Point) 1261 601 549 nil nil nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140916224 131073 592 nil 655878 ##(Smalltalk.ThemeColor) #smalltalkWorkspace nil 7 nil nil nil 592 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 1 73 498 1229 411 592 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 36 0 0 0 102 2 0 0 241 0 0 0] 8 #() 498 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 978 #fixedParentRight 1 978 #fixedPreviousBottom 1 978 #fixedParentBottom 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1056 nil nil nil 7 nil nil nil 1056 530 170 176 34 6 410 ##(Smalltalk.PushButton) 34 20 nil 1056 34 2 8 1140924416 1 1168 nil nil nil 7 nil nil nil 1168 nil 8 1903885040 1180998 4 ##(Smalltalk.CommandDescription) #restoreMethod 8 'Restore' 1 1 nil nil false nil nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 498 17 9 498 121 57 1168 786 #isEnabled: 8 #(false) 1168 786 #text: 34 1 8 'Restore' 1168 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 4 0 0 0 68 0 0 0 32 0 0 0] 8 #() 928 nil 29 946 992 17 978 #fixedViewLeft 121 978 #fixedParentTop 9 1040 -7 410 ##(Smalltalk.PushButton) 34 20 nil 1056 34 2 8 1140924416 1 1584 nil nil nil 7 nil nil nil 1584 nil 8 1903885040 1250 #diff 8 'Diff' 1 1 nil nil false nil nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 498 153 9 498 121 57 1584 786 #isEnabled: 8 #(false) 1584 786 #text: 34 1 8 'Diff' 1584 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 0 0 0 4 0 0 0 136 0 0 0 32 0 0 0] 8 #() 928 nil 29 946 978 #fixedPreviousRight 17 1552 121 1568 9 1040 -7 410 ##(Smalltalk.ContainerView) 34 15 nil 1056 34 2 8 1140850688 131073 1968 nil nil nil 7 nil nil nil 1968 530 170 176 34 10 410 ##(Smalltalk.PushButton) 34 20 nil 1968 34 2 8 1140924416 1 2080 nil nil nil 7 nil nil nil 2080 nil 8 1903885040 1250 #moveToPrevious 8 '<' 1 1 nil nil false nil nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 498 65 9 498 49 57 2080 786 #isEnabled: 8 #(false) 2080 786 #text: 34 1 8 '<' 2080 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 0 0 0 4 0 0 0 56 0 0 0 32 0 0 0] 8 #() 928 nil 29 946 1952 9 1552 49 1568 9 1040 -7 410 ##(Smalltalk.Slider) 34 18 nil 1968 34 2 8 1140916485 1 2448 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 2578 #hash 8 #() 3 nil nil 7 nil nil nil 2448 nil 8 1903799248 852486 ##(Smalltalk.NullConverter) nil nil 3 nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 498 121 1 498 361 71 2448 786 #pageSize: 8 #(1) 2448 786 #range: 34 1 525062 ##(Smalltalk.Interval) 1 3 3 2448 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 0 0 0 0 240 0 0 0 35 0 0 0] 8 #() 928 nil 27 946 992 121 1008 -119 1568 1 978 #fixedViewTop 71 410 ##(Smalltalk.PushButton) 34 20 nil 1968 34 2 8 1140924416 1 2992 nil nil nil 7 nil nil nil 2992 nil 8 1903885040 1250 #moveToNext 8 '>' 1 1 nil nil false nil nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 498 489 9 498 49 57 2992 786 #isEnabled: 8 #(false) 2992 786 #text: 34 1 8 '>' 2992 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 244 0 0 0 4 0 0 0 12 1 0 0 32 0 0 0] 8 #() 928 nil 29 946 978 #fixedViewRight -47 978 #fixedPreviousLeft -7 1568 9 1040 -7 410 ##(Smalltalk.PushButton) 34 20 nil 1968 34 2 8 1140924416 1 3392 nil nil nil 7 nil nil nil 3392 nil 8 1903885040 1250 #moveToLast 8 '>|' 1 1 nil nil false nil nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 498 545 9 498 49 57 3392 786 #isEnabled: 8 #(false) 3392 786 #text: 34 1 8 '>|' 3392 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 4 0 0 0 40 1 0 0 32 0 0 0] 8 #() 928 nil 29 946 3360 -47 1008 -7 1568 9 1040 -7 410 ##(Smalltalk.PushButton) 34 20 nil 1968 34 2 8 1140924416 1 3760 nil nil nil 7 nil nil nil 3760 nil 8 1903885040 1250 #moveToFirst 8 '|<' 1 1 nil nil false nil nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 498 9 9 498 49 57 3760 786 #isEnabled: 8 #(false) 3760 786 #text: 34 1 8 '|<' 3760 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 28 0 0 0 32 0 0 0] 8 #() 928 nil 29 946 992 9 1552 49 1568 9 1040 -7 170 192 34 2 2448 8 'slider' nil 722 138 144 34 1 786 #createAt:extent: 34 2 498 323 1 498 601 73 1968 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 161 0 0 0 0 0 0 0 205 1 0 0 36 0 0 0] 34 5 3760 2080 3392 2992 2448 928 nil 27 946 1952 51 1552 601 1568 1 1040 1 170 192 912 nil 722 138 144 34 1 786 #createAt:extent: 34 2 498 1 1 498 1229 73 1056 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 2 0 0 36 0 0 0] 34 3 1168 1584 1968 928 nil 27 946 992 1 1008 1 1568 1 2976 73 170 192 34 2 592 8 'source' 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1250 #pageSetup 8 'Page &setup...' 1 1 nil nil nil 4754 1 1250 #printPreview 8 'Print p&review...' 1 1 nil nil nil 4754 1 1250 #print 8 '&Print...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4754 1 1250 #exit 8 '&Close' 16615 1 nil nil nil 8 '&File' nil 1 nil nil 60265 nil nil 4706 nil true 34 3 4754 1 1250 #copySelection 8 '&Copy' 1 1 nil nil nil 4754 1 1250 #restoreMethod 8 '&Restore' 9381 1 nil nil nil 4754 1 1250 #diff 8 '&Diff' 9353 1 nil nil nil 8 '&Edit' nil 1 nil nil 60273 nil nil 4706 nil true 34 4 4754 1 1250 #moveToFirst 8 '&First' 1605 1 nil nil nil 4754 1 1250 #moveToPrevious 8 '&Previous' 1611 1 nil nil nil 4754 1 1250 #moveToNext 8 '&Next' 1615 1 nil nil nil 4754 1 1250 #moveToLast 8 '&Last' 1603 1 nil nil nil 8 '&Position' nil 134217729 nil nil 60283 nil nil 4754 1 1250 #about 8 '&About!!' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 498 3839 21 498 1261 601 416 786 #text: 34 1 8 'Method History' 416 786 #updateMenuBar 912 416 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 245 9 0 0 54 1 0 0] 34 2 1056 592 928 nil 27 )!

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

