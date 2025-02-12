﻿"Filed out from Dolphin Smalltalk"!

Tools.ClassBrowserPlugin
	subclass: #'Tools.DebugInfoPlugin'
	instanceVariableNames: 'disassemblyPresenter sourcePresenter textMapPresenter toggleDebugPresenter toggleOptimisedPresenter method'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.DebugInfoPlugin guid: (Core.GUID fromString: '{d76ccba1-7398-4191-9068-fb4bcb1afb88}')!

Tools.DebugInfoPlugin comment: '`DebugInfoPlugin` is a `<classBrowserPlugin>` that shows a debug view of the currently selected method. It has 3 panes:
 - The left pane is the text map built by the compiler and used by the debugger to relate instruction pointer positions to the corresponding expression in the source text.
 - The middle pane displays the source of the method. Note that this is not intended for editing.
 - The right pane displays a bytecode disassembly for the method.
	
Selecting a row will make corresponding source and instruction selections in the next two panes using essentially the same code as the Debugger. The Debug and Optimized checkboxes can be toggled to see the effect on the generated bytecodes, although note that Debug methods are never optimized.

Since this facility is probably not of interest to most developers it is not installed as one of the default plugins. If you wish to add this plugin to all browsers please evaluate:
```
	ClassBrowserAbstract allSubclasses do: [:each | each plugins add: self]
```
Alternatively Tools/Options/Inspect Options, then double click plugins, press the * button, and choose DebugInfoPlugin from the list, Ok out. The plugin will appear in any subsequently opened browser.'!

!Tools.DebugInfoPlugin categoriesForClass!Browser-Plugins! !

!Tools.DebugInfoPlugin methodsFor!

clear
	disassemblyPresenter text: ''.
	sourcePresenter text: ''.
	textMapPresenter list: #()!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	disassemblyPresenter := self add: SmalltalkSystem current workspaceClass new name: 'disassembly'.
	sourcePresenter := self add: SmalltalkSystem current methodWorkspaceClass new name: 'source'.
	sourcePresenter
		isAutoParseEnabled: false;
		isSelectionMatched: false.
	textMapPresenter := self add: ListPresenter new name: 'textMap'.
	toggleDebugPresenter := self add: BooleanPresenter new name: 'debugToggle'.
	toggleOptimisedPresenter := self add: BooleanPresenter new name: 'optimisedToggle'.
	toggleOptimisedPresenter value: true!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self model
		when: #methodSelected
			send: #onBrowserMethodSelected
			to: self;
		when: #classSelected
			send: #onBrowserClassSelected
			to: self.
	textMapPresenter
		when: #selectionChanged
		send: #onTextMapEntrySelected
		to: self.
	toggleDebugPresenter
		when: #valueChanged
		send: #toggleDebug
		to: self.
	toggleOptimisedPresenter
		when: #valueChanged
		send: #toggleDebug
		to: self!

displayMethod
	| debugInfo |
	method := self selectedMethod.
	method isNil 
		ifTrue: 
			[self clear.
			^self].
	sourcePresenter text: method getSource.
	debugInfo := self getDebugInfoFor: method.
	method := debugInfo method.
	method isNil 
		ifTrue: 
			[self clear.
			^self].
	method selector: method selector asSymbol.
	disassemblyPresenter text: method disassembly.
	textMapPresenter list: debugInfo textMap!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see.
	This will be used as the label for the tab when the receiver is being displayed as a plugin within the Class Browser."

	aPuttableStream nextPutAll: 'Debug Info.'!

getDebugInfoFor: aCompiledMethod
	| methodClass compiler flags |
	methodClass := aCompiledMethod methodClass.
	compiler := aCompiledMethod compilerClass.
	flags := methodClass defaultCompilationFlags | (compiler debugInfoFlags: toggleDebugPresenter value).
	flags := flags mask: CompilerFlags.NoOptimize set: toggleOptimisedPresenter value not.
	^compiler
		compileForMethod: aCompiledMethod getSource
		in: methodClass
		environment: aCompiledMethod environment
		flags: flags!

onBrowserClassSelected
	self isCurrentCard ifTrue: [self browser ensureDefinitionVisible]!

onBrowserMethodSelected
	self displayMethod!

onTextMapEntrySelected
	"Private - Similar to the logic in Debugger"

	| ip mapEntry |
	mapEntry := textMapPresenter selectionOrNil.
	mapEntry isNil 
		ifTrue: 
			[disassemblyPresenter selectionRange: (1 to: 0).
			sourcePresenter selectionRange: (1 to: 0).
			^self].
	ip := mapEntry key.
	"There are two lines of header text before the bytecode disassembly starts"
	disassemblyPresenter selectLine: (method indexOfIP: ip) + 2.
	disassemblyPresenter view ensureCaretVisible.
	sourcePresenter selectionRange: mapEntry value!

parseContext
	^self browser parseContext!

selectedMethod
	^self browser selectedMethod 
		ifNotNil: [:m | toggleDebugPresenter value ifTrue: [m asDebugMethod] ifFalse: [m]]!

toggleDebug
	| sel |
	sel := textMapPresenter selectionByIndex.
	self displayMethod.
	textMapPresenter selectionByIndex: sel ifAbsent: []! !

!Tools.DebugInfoPlugin categoriesForMethods!
clear!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
displayMethod!private! !
displayOn:!displaying!public! !
getDebugInfoFor:!private! !
onBrowserClassSelected!event handling!public! !
onBrowserMethodSelected!event handling!public! !
onTextMapEntrySelected!private! !
parseContext!public! !
selectedMethod!public! !
toggleDebug!public! !
!

!Tools.DebugInfoPlugin class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.LookupTable} 50 4 518 #{Core.Association} 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 224 nil nil nil 5 nil nil nil 224 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 224 50 2 8 1140850688 131073 320 nil nil nil 517 nil nil nil 320 838 1 #{UI.FlowLayout} 11 1 1 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 18 #{UI.CheckBox} 50 16 nil 320 50 2 8 1409363203 1 464 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 517 nil nil nil 464 nil nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[2 0 0 0 3 0 0 0 60 0 0 0 20 0 0 0] 193 496 8 'Debug?' 464 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 8 'debugToggle' 18 #{UI.CheckBox} 50 16 nil 320 50 2 8 1409363203 1 880 530 nil nil 576 false nil nil 517 nil nil nil 880 nil nil 594 nil nil nil 626 50 1 674 #createWindow: 50 1 722 754 8 #[65 0 0 0 3 0 0 0 143 0 0 0 20 0 0 0] 193 912 8 'Optimised?' 880 3 8 #() 834 193 193 nil 27 8 'optimisedToggle' 518 #{Graphics.Rectangle} 834 5 7 834 1 7 626 50 1 674 #createWindow: 50 1 722 754 8 #[0 0 0 0 0 0 0 0 158 0 0 0 23 0 0 0] 193 352 8 '' 320 3 50 2 464 880 834 193 193 nil 27 nil nil nil 18 #{UI.ListView} 50 45 nil 224 50 2 8 1409388621 1 1376 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 1376 nil nil 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 1474 2 3142 5 #{UI.ListViewColumn} 8 'IP' 87 #left 1570 #displayString 1600 1570 #<= 8 #() 1570 #key 8 #() nil 1376 nil 1 nil nil 1666 8 'Range' 231 #left 1570 #displayString 8 #() 1570 #<= 1840 1570 #value 1776 nil 1376 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 1376 nil nil nil nil nil nil nil nil nil 626 50 1 674 #createWindow: 50 1 722 754 8 #[0 0 0 0 23 0 0 0 158 0 0 0 114 1 0 0] 193 1408 8 'IP' 1376 3 8 #() 834 193 193 nil 35 418 #{Core.IdentityDictionary} 50 2 1376 8 'textMap' 1154 834 1 1 834 5 1 626 50 1 674 #createWindow: 50 1 722 754 8 #[0 0 0 0 0 0 0 0 160 0 0 0 114 1 0 0] 193 256 8 '' 224 3 50 2 320 1376 834 193 193 nil 27 1 194 18 #{UI.StaticRectangle} 50 14 nil 32 50 2 8 1140850952 1 2368 nil 1552 nil 5 nil nil nil 2368 nil nil 626 50 2 674 #createWindow: 50 1 722 754 8 #[160 0 0 0 0 0 0 0 161 0 0 0 114 1 0 0] 193 2400 8 '' 2368 674 #isEnabled: 8 #(false) 2368 3 8 #() 834 193 193 nil 27 1 194 18 #{UI.Scintilla.ScintillaView} 50 56 nil 32 50 2 8 1445007684 1 2640 nil 1552 nil 21 2886 4 #{UI.Menu} nil true 50 9 2706 nil true 50 3 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #copySelection 8 '&Copy' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'EditCopy.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 2786 1 2818 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 2706 nil true 50 6 2786 1 2818 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 2786 1 2818 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 2786 1 2818 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 2786 1 2818 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 2786 1 2818 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 2786 1 2818 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 2994 4097 2786 1 2818 #browseIt 8 'Bro&wse It' 1 1 2866 nil true 2898 8 'ClassBrowserShell.ico' 2960 65541 nil nil nil 2786 1 2818 #evaluateIt 8 'E&valuate It' 1 1 2866 nil true 2898 8 'EvaluateIt.ico' 2960 65541 nil nil nil 2786 1 2818 #inspectIt 8 '&Inspect It' 1 1 2866 nil true 2898 8 'InspectIt.ico' 2960 65541 nil nil nil 2786 1 2818 #debugIt 8 'Deb&ug It' 1 1 2866 nil true 2898 8 'Debugger.ico' 2960 65541 nil nil nil 2994 4097 2706 nil true 50 4 2786 2097153 2818 #browseDefinitions 8 'Defi&nitions of <d:…>' 1 1 nil nil nil 2786 1 2818 #browseReferences 8 '&References to <d:…>' 1 1 nil nil nil 2994 4097 2786 1 2818 #browseMessage 8 '<d:Message>' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 2640 nil nil 594 nil nil 11 #focusLost nil nil nil nil 550 #{Core.IdentityDictionary} 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 1538 #gray 1538 #white 1 nil nil nil nil #callTip nil nil nil #normal 4114 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkMethodStyler} 1 nil nil false 1474 0 4082 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 2640 #circle nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 9215 nil nil 4322 1 81 1538 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 4082 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 4082 1 #container 4096 nil nil nil nil #{Core.Utf8String} nil 4082 2 #Error 3142 5 #{UI.Scintilla.IndicatorDefinition} 19 2640 1538 #red 3 3 #Error nil nil nil nil nil nil #Warning 4514 17 2640 1538 #blue 3 3 #Warning nil nil nil nil nil nil nil nil 4082 3 #Error 4114 1031 1538 #firebrick 1538 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 4114 1029 nil 1538 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 4114 1027 1538 #darkGoldenrod 1538 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 626 50 10 674 #createWindow: 50 1 722 754 8 #[161 0 0 0 0 0 0 0 214 1 0 0 114 1 0 0] 193 2672 nil 2640 674 #contextMenu: 50 1 2720 2640 674 #sciSetMouseDwellTime: 8 #(500) 2640 674 #wordWrap: 8 #(true) 2640 674 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 2640 33 3 nil nil nil nil 4994 3 2640 nil nil nil 67108863 nil nil 4994 5 2640 nil nil nil nil nil nil 2640 674 #backspaceUnindents: 8 #(true) 2640 674 #maxCompletionListHeight: 8 #(9) 2640 674 #sciSetTechnology: 8 #(1) 2640 674 #sciSetFontQuality: 8 #(3) 2640 674 #sciSetSelectionLayer: 8 #(1) 2640 3 8 #() 834 193 193 nil 45 9 194 18 #{UI.Scintilla.ScintillaView} 50 56 nil 32 50 2 8 1174475012 1 5264 530 nil false 6 #{Kernel.EqualitySearchPolicy} nil 1538 #highlight3d nil 1045 nil nil nil 5264 nil nil 594 nil nil 11 #focusLost nil nil nil nil 4082 5 #callTip 4114 77 4144 4160 1 nil nil nil nil #callTip nil nil nil #indentGuide 4114 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 4114 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 4114 1 nil nil 1 nil nil nil nil #normal nil nil nil #whitespace 4114 3 nil nil 1 nil nil nil nil #whitespace nil nil nil nil 326 1 #{UI.Scintilla.NullStyler} #normal 4082 1 #default 4258 1 nil nil nil 5264 #circle nil nil nil nil nil nil 4290 0 nil 4322 0 9215 nil nil 4322 1 81 4368 nil nil 4400 nil 65 nil nil nil nil 1 4082 1 #container 5408 nil nil nil nil #{Core.Utf8String} nil 4082 0 nil nil 4082 3 #Error 4114 1031 4624 4640 1 nil nil nil nil #Error nil nil nil #Notification 4114 1029 nil 4672 1 nil nil nil nil #Notification nil nil nil #Warning 4114 1027 4704 4720 1 nil nil nil nil #Warning nil nil nil nil nil nil 626 50 8 674 #createWindow: 50 1 722 754 8 #[219 1 0 0 0 0 0 0 17 3 0 0 114 1 0 0] 193 5296 nil 5264 674 #wordWrap: 8 #(true) 5264 674 #margins: 50 1 50 3 4994 1 5264 nil 3 nil nil nil nil 4994 3 5264 nil nil nil 67108863 nil nil 4994 5 5264 nil nil nil nil nil nil 5264 674 #sciSetHScrollBar: 8 #(false) 5264 674 #maxCompletionListHeight: 8 #(9) 5264 674 #sciSetTechnology: 8 #(1) 5264 674 #sciSetFontQuality: 8 #(3) 5264 674 #sciSetSelectionLayer: 8 #(1) 5264 3 8 #() 834 193 193 nil 45 9 false 418 4080 50 4 5264 8 'disassembly' 2640 8 'source' nil 626 50 1 674 #createWindow: 50 1 722 754 8 #[255 14 0 0 10 0 0 0 16 18 0 0 124 1 0 0] 193 80 8 '' 32 1 50 5 224 2368 2640 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 6352 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 6352 nil 1 #left nil nil nil 834 1 1 834 9 9 nil 6448 nil 626 50 1 674 #createWindow: 50 1 722 754 8 #[214 1 0 0 0 0 0 0 219 1 0 0 114 1 0 0] 193 6384 8 '' 6352 3 8 #() 834 193 193 nil 27 5264 834 193 193 nil 27)! !

!Tools.DebugInfoPlugin class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

