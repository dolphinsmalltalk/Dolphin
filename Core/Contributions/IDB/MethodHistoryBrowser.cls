"Filed out from Dolphin Smalltalk"!

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

canMoveToFirst
	^selection ~= 1!

canMoveToLast
	^selection ~= history size!

canMoveToNext
	^history size ~= 1 and: [selection < history size]!

canMoveToPrevious
	^history size ~= 1 and: [selection > 1]!

createComponents
	super createComponents.
	slider := self add: NumberPresenter new name: 'slider'.
	source := self add: MethodWorkspace new name: 'source'!

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
	<commandQuery: #hasUnloadedVersionSelected>
	(DiffBrowser show: 'Vertical view')
		textFont: MethodWorkspace actualFont;
		styler: SmalltalkMethodStyler new;
		textStyles: MethodWorkspace textStyles;
		caption: self methodClass name , '>>#' , selector;
		compare: self selectedMethodVersion getSource
			id: 'Version #' , selection printString
			and: self selectedMethodVersion loadedMethod getSource
			id: 'Current image'!

hasUnloadedVersionSelected
	| methodVersion |
	methodVersion := self selectedMethodVersion.
	^methodVersion notNil and: [methodVersion isLoaded not]!

history
	^history!

loadedMethodVersion

	^history detect: [ :each | each isLoaded] ifNone: [nil]!

methodClass
	^class!

moveTo: anInteger 
	selection := anInteger.
	self updateSelection!

moveToFirst
	<commandQuery: #canMoveToFirst>
	self moveTo: 1!

moveToLast
	<commandQuery: #canMoveToLast>
	self moveTo: history size!

moveToLoaded
	<commandQuery: #hasUnloadedVersionSelected>
	self loadedMethodVersion
		ifNil: [self moveToLast]
		ifNotNil: [:loaded | self moveTo: (history indexOf: loaded)]!

moveToNext
	<commandQuery: #canMoveToNext>
	self moveTo: selection + 1!

moveToPrevious
	<commandQuery: #canMoveToPrevious>
	self moveTo: selection - 1!

onImageChanged: aCompiledMethod

	| loadedVersion |

	(aCompiledMethod methodClass == self methodClass and: [aCompiledMethod selector == selector]) ifTrue: 
		[loadedVersion := aCompiledMethod loadedVersion.
		(history includes: loadedVersion) ifFalse: 
			[(history last hasSameSourceAs: aCompiledMethod) ifTrue: [history removeLast].
			history addLast: loadedVersion].
		self moveToLoaded]!

onMethodAdded: aCompilationResult
	self onImageChanged: aCompilationResult method!

onMethodRemoved: aCompiledMethod 
	self onImageChanged: aCompiledMethod!

onMethodUpdated: aCompilationResult 
	self onImageChanged: aCompilationResult method!

onSliderValueChanged
	self moveTo: slider model value!

onTipTextRequired: tool

	tool command = #restoreMethod ifTrue: [^'Restore the selected method version'].
	tool command = #diff ifTrue: [^'Compare the selected version with the loaded method'].

	^tool toolTipText!

onViewOpened	
	super onViewOpened.
	source view isReadOnly: true.
	selection := history size!

parseContext
	| methodClass |
	methodClass := self methodClass.
	^(methodClass compiledMethodAt: selector ifAbsent: [methodClass]) parseContext!

printableView
	^source view!

restoreMethod
	"Restore the selected method. Check for a compilation failure - although it 
	should be obvious, the displayed  method will be in red , we don't want to 
	let this go without a warning. The history browser will be updated by the 
	normal event mechanism"

	<commandQuery: #hasUnloadedVersionSelected>
	self selectedMethodVersion load ifNil: [^MessageBox warning: 'Restore failed'].
	debugger ifNotNil: [debugger restartMethod]!

selectedMethod
	^nil!

selectedMethodVersion

	^history ifNotNil: [history at: selection]!

selectedMethodVersion: aMethodVersion

	self moveTo: (history indexOf: aMethodVersion)!

setCaption
	self caption: (String writeStream
				nextPutAll: 'MethodHistory - ';
				nextPutAll: self methodClass name;
				nextPutAll: '>>';
				print: selector;
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

setLoadedMarker

	(history detect: [ :each | each isLoaded] ifNone: [nil]) ifNotNil: 
		[ :loaded || index |
		index := history indexOf: loaded.
		slider view selectionRange: (index to: index)]!

source
	^self selectedMethodVersion getSource!

updateHistory
	"Get the historic information for the method. Purge consecutive duplicates from the list"

	| versions |
	versions := Cursor wait showWhile: [self scanner scanForMethodVersions: selector inClass: self methodClass].
	history := OrderedCollection with: versions first.
	versions do: 
			[:each |
			((history last hasSameSourceAs: each) and: [history last sourceFileIndex = each sourceFileIndex])
				ifFalse: [history add: each]].
	self moveToLoaded!

updateSelection
	source text: self source.
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
	self 
		setCaption;
		setLoadedMarker! !

!MethodHistoryBrowser categoriesForMethods!
about!commands-actions!public! !
canMoveToFirst!commands-queries!private! !
canMoveToLast!commands-queries!private! !
canMoveToNext!commands-queries!private! !
canMoveToPrevious!commands-queries!private! !
createComponents!initializing!operations!public! !
createSchematicWiring!initializing!operations!public! !
diff!commands-actions!public! !
hasUnloadedVersionSelected!commands-queries!private! !
history!accessing!public! !
loadedMethodVersion!accessing!public! !
methodClass!accessing!public! !
moveTo:!operations!public! !
moveToFirst!commands-actions!public! !
moveToLast!commands-actions!public! !
moveToLoaded!commands-actions!public! !
moveToNext!commands-actions!public! !
moveToPrevious!commands-actions!public! !
onImageChanged:!event handling!public! !
onMethodAdded:!event handling!public! !
onMethodRemoved:!event handling!public! !
onMethodUpdated:!event handling!public! !
onSliderValueChanged!initializing!operations!public! !
onTipTextRequired:!event handling!public! !
onViewOpened!event handling!public! !
parseContext!public! !
printableView!accessing!printing!public! !
restoreMethod!commands-actions!public! !
selectedMethod!public! !
selectedMethodVersion!accessing!public! !
selectedMethodVersion:!accessing!public! !
setCaption!operations!public! !
setClass:selector:debugger:!accessing!public! !
setLoadedMarker!operations!private! !
source!commands-actions!public! !
updateHistory!operations!public! !
updateSelection!event handling!public! !
!

!MethodHistoryBrowser class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d 328198 ##(Smalltalk.Point) 1501 801 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 560 nil nil nil 5 nil nil nil 560 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.Toolbar) 34 28 nil 560 34 2 8 1140857676 131073 688 nil 466 #default nil 5 nil nil nil 688 752 nil 170 192 8 #() nil nil nil nil 34 3 1115206 1 ##(Smalltalk.ToolbarIconButton) 688 33 1180998 4 ##(Smalltalk.CommandDescription) #restoreMethod 8 'Restore' 1 5 262982 4 ##(Smalltalk.Icon) nil true 2229254 ##(Smalltalk.ImageFromStringResourceInitializer) 8 'MethodHistory.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil 65541 nil nil 818 688 33 850 #diff 8 'Diff' 1 1 898 nil true 1836038 ##(Smalltalk.ImageFromResourceInitializer) 33603 786694 ##(Smalltalk.ShellLibrary) 65541 nil nil 1049158 1 ##(Smalltalk.ToolbarSeparator) 688 1 nil nil 11 1 #mediumIcons 498 161 61 nil nil 983302 ##(Smalltalk.MessageSequence) 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[7 0 0 0 0 0 0 0 157 0 0 0 29 0 0 0] 193 720 8 '' 688 3 8 #() 498 193 193 nil 31 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 15 1458 #fixedViewLeft 301 1458 #fixedParentTop 1 1458 #fixedViewTop 59 410 ##(Smalltalk.Toolbar) 34 28 nil 560 34 2 8 1140853580 131073 1536 nil 752 nil 5 nil nil nil 1536 752 nil 170 192 784 nil nil nil nil 34 6 818 1536 1 850 #moveToFirst nil 1 1 788806 2 ##(Smalltalk.TextTileIcon) 8 '⏮' nil nil nil nil nil 1 nil nil nil 818 1536 1 850 #moveToPrevious nil 1 1 1666 8 '⏪' nil nil nil nil nil 1 nil nil nil 818 1536 1 850 #moveToLoaded 8 'Move to the loaded version of the method' 1 1 1666 8 '🔽' nil nil nil nil nil 1 nil nil nil 818 1536 1 850 #moveToNext nil 1 1 1666 8 '⏩' nil nil nil nil nil 1 nil nil nil 818 1536 1 850 #moveToLast nil 1 1 1666 8 '⏭' nil nil nil nil nil 1 nil nil nil 1154 1536 1 nil nil 9 1 #mediumIcons nil nil nil 1202 34 1 1250 #createWindow: 34 1 1298 1330 8 #[157 0 0 0 0 0 0 0 71 1 0 0 29 0 0 0] 193 1568 8 '' 1536 3 8 #() 498 193 193 nil 31 1426 1458 #fixedPreviousRight 1 1488 341 1504 1 1520 59 410 ##(Smalltalk.Slider) 34 18 nil 560 34 2 8 1140916485 1 2192 721990 2 ##(Smalltalk.ValueHolder) 0 false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 2322 #hash 8 #() 3 nil nil 5 nil nil nil 2192 nil nil 852486 ##(Smalltalk.NullConverter) nil nil 3 nil nil 1202 34 3 1250 #createWindow: 34 1 1298 1330 8 #[71 1 0 0 0 0 0 0 115 2 0 0 34 0 0 0] 193 2224 8 '' 2192 1250 #pageSize: 8 #(1) 2192 1250 #range: 34 1 525062 ##(Smalltalk.Interval) 1 3 3 2192 3 8 #() 498 193 193 nil 27 1426 2176 1 1488 601 1504 1 1520 69 170 192 34 6 688 8 'commandsToolbar' 1536 8 'navToolbar' 2192 8 'slider' nil 1202 34 1 1250 #createWindow: 34 1 1298 1330 8 #[0 0 0 0 0 0 0 0 222 2 0 0 35 0 0 0] 193 592 8 '' 560 3 34 3 688 1536 2192 498 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140916224 131073 2944 nil 655878 ##(Smalltalk.ThemeColor) #smalltalkWorkspace nil 5 nil nil nil 2944 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 1202 34 1 1250 #createWindow: 34 1 1298 1330 8 #[0 0 0 0 35 0 0 0 222 2 0 0 85 1 0 0] 193 2976 8 '' 2944 3 784 498 193 193 nil 27 170 192 34 2 2944 8 'source' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 850 #pageSetup 8 'Page &setup...' 1 1 nil nil nil 3362 1 850 #printPreview 8 'Print p&review...' 1 1 nil nil nil 3362 1 850 #print 8 '&Print...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3362 1 850 #exit 8 '&Close' 16615 1 nil nil nil 8 '&File' nil 1 nil nil nil nil nil 3314 nil true 34 3 3362 1 850 #copySelection 8 '&Copy' 1 1 nil nil nil 3362 1 850 #restoreMethod 8 '&Restore' 9381 1 nil nil nil 3362 1 850 #diff 8 '&Diff' 9353 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil 3314 nil true 34 4 3362 1 850 #moveToFirst 8 '&First' 1605 1 nil nil nil 3362 1 850 #moveToPrevious 8 '&Previous' 1611 1 nil nil nil 3362 1 850 #moveToNext 8 '&Next' 1615 1 nil nil nil 3362 1 850 #moveToLast 8 '&Last' 1603 1 nil nil nil 8 '&Position' nil 134217729 nil nil nil nil nil 3362 1 850 #about 8 '&About!!' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil nil nil 193 1202 34 1 1250 #createWindow: 34 1 1298 590342 ##(Smalltalk.Rectangle) 498 7679 21 498 9179 821 193 448 8 'Method History' 416 1 34 2 2944 560 498 193 193 nil 27 )!

showOnClass: aClass selector: aSymbol
	^self
		showOnClass: aClass
		selector: aSymbol
		debugger: nil!

showOnClass: aClass selector: aSymbol debugger: aDebuggerOrNil
	^self create
		setClass: aClass selector: aSymbol debugger: aDebuggerOrNil;
		show! !

!MethodHistoryBrowser class categoriesForMethods!
resource_Default_view!public!resources-views! !
showOnClass:selector:!instance creation!public! !
showOnClass:selector:debugger:!instance creation!private! !
!

