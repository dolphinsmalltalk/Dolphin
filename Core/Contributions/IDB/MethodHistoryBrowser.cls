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

canPrint
	^[super canPrint] on: MessageNotUnderstood do: [:e | false]!

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
	(DiffBrowser show: 'Vertical view')
		textFont: MethodWorkspace actualFont;
		styler: SmalltalkMethodStyler new;
		textStyles: MethodWorkspace textStyles;
		caption: self methodClass name , '>>#' , selector;
		compare: self selectedMethodVersion getSource
			id: 'Version #' , selection printString
			and: self selectedMethodVersion loadedMethod getSource
			id: 'Current image'!

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
	self moveTo: 1!

moveToLast
	self moveTo: history size!

moveToLoaded

	self loadedMethodVersion
		ifNil: [self moveToLast]
		ifNotNil: [ :loaded | self moveTo: (history indexOf: loaded)]!

moveToNext
	self moveTo: selection + 1!

moveToPrevious
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

onViewClosed
	"Private - This is needed to prevent events trying to access this shell
	after it is closed but before it is garbage collected"

	super onViewClosed.
	SmalltalkSystem current removeEventsTriggeredFor: self!

onViewOpened	
	super onViewOpened.
	source view isReadOnly: true.
	selection := history size!

parseContext
	| methodClass |
	methodClass := self methodClass.
	^(methodClass compiledMethodAt: selector ifAbsent: [])
		ifNil: [ParseContext methodClass: methodClass environment: methodClass environment]!

printableView
	^source view!

queryCommand: aCommandQuery 

	| command |

	command := aCommandQuery command.

	(#(#print #printPreview) identityIncludes: command) 
		ifTrue: 
			[aCommandQuery isEnabled: self canPrint.
			^true].
	command == #moveToFirst 
		ifTrue: 
			[aCommandQuery isEnabled: selection ~= 1.
			^true].
	command == #moveToLast
		ifTrue: 
			[aCommandQuery isEnabled: selection ~= history size.
			^true].
	(#(#restoreMethod #diff #moveToLoaded) includes: command)
		ifTrue: 
			[aCommandQuery isEnabled: (self selectedMethodVersion ifNil: [false] ifNotNil: [ :mv | mv isLoaded not]).
			^true].
	command == #moveToPrevious 
		ifTrue: 
			[aCommandQuery isEnabled: history size ~= 1 & (selection > 1).
			^true].
	command == #moveToNext 
		ifTrue: 
			[aCommandQuery isEnabled: history size ~= 1 & (selection < history size).
			^true].
	^super queryCommand: aCommandQuery!

restoreMethod
	"Restore the selected method. Check for a compilation failure - although it 
	should be obvious, the displayed  method will be in red , we don't want to 
	let this go without a warning. The history browser will be updated by the 
	normal event mechanism"

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
about!commands!public! !
canPrint!printing!public!testing! !
createComponents!initializing!operations!public! !
createSchematicWiring!initializing!operations!public! !
diff!commands!public! !
history!accessing!public! !
loadedMethodVersion!accessing!public! !
methodClass!accessing!public! !
moveTo:!operations!public! !
moveToFirst!commands!public! !
moveToLast!commands!public! !
moveToLoaded!commands!public! !
moveToNext!commands!public! !
moveToPrevious!commands!public! !
onImageChanged:!event handling!public! !
onMethodAdded:!event handling!public! !
onMethodRemoved:!event handling!public! !
onMethodUpdated:!event handling!public! !
onSliderValueChanged!initializing!operations!public! !
onTipTextRequired:!event handling!public! !
onViewClosed!event handling!public! !
onViewOpened!event handling!public! !
parseContext!public! !
printableView!accessing!printing!public! !
queryCommand:!commands!public! !
restoreMethod!commands!public! !
selectedMethod!public! !
selectedMethodVersion!accessing!public! !
selectedMethodVersion:!accessing!public! !
setCaption!operations!public! !
setClass:selector:debugger:!accessing!public! !
setLoadedMarker!operations!private! !
source!commands!public! !
updateHistory!operations!public! !
updateSelection!event handling!public! !
!

!MethodHistoryBrowser class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d 328198 ##(Smalltalk.Point) 1501 801 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 560 nil nil nil 7 nil nil nil 560 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.Toolbar) 34 25 nil 560 34 2 8 1140853580 131073 688 nil 466 #default nil 7 nil nil nil 688 752 8 1965374256 170 192 8 #() 170 192 34 10 37567 1115206 1 ##(Smalltalk.ToolbarIconButton) 688 1 1180998 4 ##(Smalltalk.CommandDescription) #moveToLast nil 1 1 788806 1 ##(Smalltalk.TextTileIcon) 8 '⏭' nil nil nil nil nil 1 nil nil 37567 37563 850 688 1 882 #moveToLoaded 8 'Move to the loaded version of the method' 1 1 914 8 '🔽' nil nil nil nil nil 1 nil nil 37563 37559 850 688 1 882 #moveToFirst nil 1 1 914 8 '⏮' nil nil nil nil nil 1 nil nil 37559 37565 850 688 1 882 #moveToNext nil 1 1 914 8 '⏩' nil nil nil nil nil 1 nil nil 37565 37561 850 688 1 882 #moveToPrevious nil 1 1 914 8 '⏪' nil nil nil nil nil 1 nil nil 37561 34 6 1040 1168 960 1104 864 1049158 1 ##(Smalltalk.ToolbarSeparator) 688 1 nil nil 1 nil 498 49 49 nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 315 1 498 341 59 688 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 157 0 0 0 0 0 0 0 71 1 0 0 29 0 0 0] 8 #() 498 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 1 1554 #fixedViewLeft 341 1554 #fixedParentTop 1 1554 #fixedViewTop 59 410 ##(Smalltalk.Toolbar) 34 25 nil 560 34 2 8 1140857676 131073 1632 nil 752 nil 7 nil nil nil 1632 752 8 1965374256 170 192 800 170 192 34 4 37555 850 1632 33 882 #restoreMethod 8 'Restore' 1 5 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'MethodHistory.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 37555 37557 850 1632 33 882 #diff 8 'Diff' 1 1 1810 nil true 1856 33603 786694 ##(Smalltalk.ShellLibrary) 37557 34 3 1760 1936 1250 1632 1 nil nil 3 nil 498 49 49 498 161 61 nil nil 1298 138 144 34 1 1362 #createAt:extent: 34 2 498 15 1 498 301 59 1632 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 0 0 0 0 157 0 0 0 29 0 0 0] 8 #() 1504 nil 27 1522 1554 #fixedParentLeft 15 1584 301 1600 1 1616 59 410 ##(Smalltalk.Slider) 34 18 nil 560 34 2 8 1140916485 1 2288 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 2418 #hash 8 #() 3 nil nil 7 nil nil nil 2288 nil 8 1965274064 852486 ##(Smalltalk.NullConverter) nil nil 3 nil nil 1298 138 144 34 3 1362 #createAt:extent: 34 2 498 655 1 498 601 69 2288 1362 #pageSize: 8 #(1) 2288 1362 #range: 34 1 525062 ##(Smalltalk.Interval) 1 3 3 2288 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 71 1 0 0 0 0 0 0 115 2 0 0 34 0 0 0] 8 #() 1504 nil 27 1522 1568 1 1584 601 1600 1 1616 69 170 192 34 6 688 8 'navToolbar' 1632 8 'commandsToolbar' 2288 8 'slider' nil 1298 138 144 34 1 1362 #createAt:extent: 34 2 498 1 1 498 1469 71 560 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 222 2 0 0 35 0 0 0] 34 3 1632 688 2288 1504 nil 27 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140916224 131073 3056 nil 655878 ##(Smalltalk.ThemeColor) #smalltalkWorkspace nil 7 nil nil nil 3056 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 1298 138 144 34 1 1362 #createAt:extent: 34 2 498 1 71 498 1469 613 3056 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 35 0 0 0 222 2 0 0 85 1 0 0] 800 1504 nil 27 170 192 34 2 3056 8 'source' 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 882 #pageSetup 8 'Page &setup...' 1 1 nil nil nil 3538 1 882 #printPreview 8 'Print p&review...' 1 1 nil nil nil 3538 1 882 #print 8 '&Print...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3538 1 882 #exit 8 '&Close' 16615 1 nil nil nil 8 '&File' nil 1 nil nil 37577 nil nil 3490 nil true 34 3 3538 1 882 #copySelection 8 '&Copy' 1 1 nil nil nil 3538 1 882 #restoreMethod 8 '&Restore' 9381 1 nil nil nil 3538 1 882 #diff 8 '&Diff' 9353 1 nil nil nil 8 '&Edit' nil 1 nil nil 37585 nil nil 3490 nil true 34 4 3538 1 882 #moveToFirst 8 '&First' 1605 1 nil nil nil 3538 1 882 #moveToPrevious 8 '&Previous' 1611 1 nil nil nil 3538 1 882 #moveToNext 8 '&Next' 1615 1 nil nil nil 3538 1 882 #moveToLast 8 '&Last' 1603 1 nil nil nil 8 '&Position' nil 134217729 nil nil 37595 nil nil 3538 1 882 #about 8 '&About!!' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1298 138 144 34 2 1362 #createAt:extent: 34 2 498 5119 21 498 1501 801 416 1362 #text: 34 1 8 'Method History' 416 1442 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 10 0 0 0 237 12 0 0 154 1 0 0] 34 2 3056 560 1504 nil 27 )!

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

