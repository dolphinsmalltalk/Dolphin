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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 0 0 8 #(13565952 65536) 416 0 721158 ##(Smalltalk.SystemColor) 31 328198 ##(Smalltalk.Point) 1261 601 519 0 0 0 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.ScintillaView) 34 50 0 416 34 2 8 1174475012 1025 592 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 196934 1 ##(Smalltalk.RGB) 30277631 0 7 0 0 0 592 0 8 4294906539 852486 ##(Smalltalk.NullConverter) 0 0 11 0 170 192 34 8 #indentGuide 1182790 1 ##(Smalltalk.ScintillaTextStyle) 75 0 0 1 0 0 0 0 #indentGuide 0 0 0 #callTip 834 77 786694 ##(Smalltalk.IndexedColor) 33554457 882 33554471 1 0 0 0 0 #callTip 0 0 0 #lineNumber 834 67 0 0 1 0 0 0 0 #lineNumber 0 0 0 #normal 834 1 0 0 1 0 0 0 0 #normal 0 0 0 34 40 944 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 928 0 0 0 848 0 0 1377542 ##(Smalltalk.SmalltalkMethodStyler) 1 0 0 false 138 144 8 #() 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 0 0 0 0 592 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 1024 0 170 176 1024 9215 0 0 0 0 882 33554447 0 0 65 0 0 170 192 34 6 #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' #literalArray 8 '()' 8 '' 1 170 192 1024 0 0 0 0 3 0 170 192 34 4 8 'indicator1' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 3 592 33423361 5 0 0 0 0 0 0 0 0 8 'indicator0' 1314 1 592 65025 3 0 0 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 834 1027 0 722 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 834 1029 722 60239 722 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 834 1031 722 335 722 31317503 1 0 0 0 0 #Error 0 0 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 4 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 1 73 498 1229 411 592 1602 #modificationEventMask: 8 #(4607) 592 1602 #caretPeriod: 8 #(530) 592 1602 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 592 1 3 0 0 0 0 1794 3 592 1 0 0 67108863 0 0 1794 5 592 1 0 0 0 0 0 592 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 36 0 0 0 102 2 0 0 241 0 0 0] 8 #() 498 193 193 0 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1970 #fixedParentRight 1 1970 #fixedPreviousBottom 1 1970 #fixedParentBottom 1 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 2048 0 0 0 7 0 0 0 2048 530 170 176 34 6 410 ##(Smalltalk.ContainerView) 34 15 0 2048 34 2 8 1140850688 131073 2160 0 0 0 7 0 0 0 2160 530 170 176 34 10 410 ##(Smalltalk.PushButton) 34 20 0 2160 34 2 8 1140924416 1 2272 0 0 0 7 0 0 0 2272 0 8 4294903891 1180998 4 ##(Smalltalk.CommandDescription) #moveToFirst 8 '|<' 1 1 0 0 false 0 0 0 1538 138 144 34 3 1602 #createAt:extent: 34 2 498 9 9 498 49 57 2272 1602 #isEnabled: 8 #(false) 2272 1602 #text: 34 1 8 '|<' 2272 1858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 28 0 0 0 32 0 0 0] 8 #() 1920 0 29 1938 1984 9 1970 #fixedViewLeft 49 1970 #fixedParentTop 9 2032 -7 410 ##(Smalltalk.PushButton) 34 20 0 2160 34 2 8 1140924416 1 2688 0 0 0 7 0 0 0 2688 0 8 4294903891 2354 #moveToPrevious 8 '<' 1 1 0 0 false 0 0 0 1538 138 144 34 3 1602 #createAt:extent: 34 2 498 65 9 498 49 57 2688 1602 #isEnabled: 8 #(false) 2688 1602 #text: 34 1 8 '<' 2688 1858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 32 0 0 0 4 0 0 0 56 0 0 0 32 0 0 0] 8 #() 1920 0 29 1938 1970 #fixedPreviousRight 9 2656 49 2672 9 2032 -7 410 ##(Smalltalk.Slider) 34 18 0 2160 34 2 8 1140916485 1 3072 658 0 false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 3186 #hash 8 #() 3 0 0 7 0 0 0 3072 0 8 4294902029 770 0 0 3 0 0 1538 138 144 34 3 1602 #createAt:extent: 34 2 498 121 1 498 361 71 3072 1602 #pageSize: 8 #(1) 3072 1602 #range: 34 1 525062 ##(Smalltalk.Interval) 1 3 3 3072 1858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 0 0 0 0 240 0 0 0 35 0 0 0] 8 #() 1920 0 27 1938 1984 121 2000 -119 2672 1 1970 #fixedViewTop 71 410 ##(Smalltalk.PushButton) 34 20 0 2160 34 2 8 1140924416 1 3584 0 0 0 7 0 0 0 3584 0 8 4294903891 2354 #moveToNext 8 '>' 1 1 0 0 false 0 0 0 1538 138 144 34 3 1602 #createAt:extent: 34 2 498 489 9 498 49 57 3584 1602 #isEnabled: 8 #(false) 3584 1602 #text: 34 1 8 '>' 3584 1858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 244 0 0 0 4 0 0 0 12 1 0 0 32 0 0 0] 8 #() 1920 0 29 1938 1970 #fixedViewRight -47 1970 #fixedPreviousLeft -7 2672 9 2032 -7 410 ##(Smalltalk.PushButton) 34 20 0 2160 34 2 8 1140924416 1 3984 0 0 0 7 0 0 0 3984 0 8 4294903891 2354 #moveToLast 8 '>|' 1 1 0 0 false 0 0 0 1538 138 144 34 3 1602 #createAt:extent: 34 2 498 545 9 498 49 57 3984 1602 #isEnabled: 8 #(false) 3984 1602 #text: 34 1 8 '>|' 3984 1858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 4 0 0 0 40 1 0 0 32 0 0 0] 8 #() 1920 0 29 1938 3952 -47 2000 -7 2672 9 2032 -7 170 192 34 2 3072 8 'slider' 0 1538 138 144 34 1 1602 #createAt:extent: 34 2 498 323 1 498 601 73 2160 1858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 161 0 0 0 0 0 0 0 205 1 0 0 36 0 0 0] 34 5 2272 2688 3984 3584 3072 1920 0 27 1938 3056 51 2656 601 2672 1 2032 1 410 ##(Smalltalk.PushButton) 34 20 0 2048 34 2 8 1140924416 1 4576 0 0 0 7 0 0 0 4576 0 8 4294903891 2354 #diff 8 'Diff' 1 1 0 0 false 0 0 0 1538 138 144 34 3 1602 #createAt:extent: 34 2 498 153 9 498 121 57 4576 1602 #isEnabled: 8 #(false) 4576 1602 #text: 34 1 8 'Diff' 4576 1858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 0 0 0 4 0 0 0 136 0 0 0 32 0 0 0] 8 #() 1920 0 29 1938 3056 17 2656 121 2672 9 2032 -7 410 ##(Smalltalk.PushButton) 34 20 0 2048 34 2 8 1140924416 1 4944 0 0 0 7 0 0 0 4944 0 8 4294903891 2354 #restoreMethod 8 'Restore' 1 1 0 0 false 0 0 0 1538 138 144 34 3 1602 #createAt:extent: 34 2 498 17 9 498 121 57 4944 1602 #isEnabled: 8 #(false) 4944 1602 #text: 34 1 8 'Restore' 4944 1858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 4 0 0 0 68 0 0 0 32 0 0 0] 8 #() 1920 0 29 1938 1984 17 2656 121 2672 9 2032 -7 170 192 1024 0 1538 138 144 34 1 1602 #createAt:extent: 34 2 498 1 1 498 1229 73 2048 1858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 2 0 0 36 0 0 0] 34 3 4944 4576 2160 1920 0 27 1938 1984 1 2000 1 2672 1 3568 73 170 192 34 2 592 8 'source' 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 461638 4 ##(Smalltalk.MenuBar) 0 true 34 4 265030 4 ##(Smalltalk.Menu) 0 true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 2354 #pageSetup 8 'Page &setup...' 1 1 0 0 0 5714 1 2354 #printPreview 8 'Print p&review...' 1 1 0 0 0 5714 1 2354 #print 8 '&Print...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5714 1 2354 #exit 8 '&Close' 16615 1 0 0 0 8 '&File' 0 1 0 0 39587 0 0 5666 0 true 34 3 5714 1 2354 #copySelection 8 '&Copy' 1 1 0 0 0 5714 1 2354 #restoreMethod 8 '&Restore' 9381 1 0 0 0 5714 1 2354 #diff 8 '&Diff' 9353 1 0 0 0 8 '&Edit' 0 1 0 0 39595 0 0 5666 0 true 34 4 5714 1 2354 #moveToFirst 8 '&First' 1605 1 0 0 0 5714 1 2354 #moveToPrevious 8 '&Previous' 1611 1 0 0 0 5714 1 2354 #moveToNext 8 '&Next' 1615 1 0 0 0 5714 1 2354 #moveToLast 8 '&Last' 1603 1 0 0 0 8 '&Position' 0 134217729 0 0 39605 0 0 5714 1 2354 #about 8 '&About!!' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1538 138 144 34 3 1602 #createAt:extent: 34 2 498 3839 21 498 1261 601 416 1602 #text: 34 1 8 'Method History' 416 1602 #updateMenuBar 1024 416 1858 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 245 9 0 0 54 1 0 0] 34 2 2048 592 1920 0 27 )!

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

