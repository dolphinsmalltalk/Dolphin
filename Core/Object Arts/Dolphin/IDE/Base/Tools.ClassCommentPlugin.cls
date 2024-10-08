﻿"Filed out from Dolphin Smalltalk"!

Tools.ClassAspectPlugin
	subclass: #'Tools.ClassCommentPlugin'
	instanceVariableNames: ''
	classVariableNames: 'TextStyles WordWrap'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.ClassCommentPlugin guid: (Core.GUID fromString: '{9bbb729c-f516-492e-b991-7ad0c238a37f}')!

Tools.ClassCommentPlugin comment: '`ClassCommentPlugin` is a `<classBrowserPlugin>` for displaying/editing class comments.

The default view uses Scintilla with its built in markdown lexer. This provides some limited assistance for editing comments in markdown, but there is no renderer currently.

'!

!Tools.ClassCommentPlugin categoriesForClass!Browser-Plugins! !

!Tools.ClassCommentPlugin methodsFor!

applyOptions
	super applyOptions.
	self setWordWrap.
	self setTextStyles.
!

aspect
	"Answer the symbolic name of the aspect of the textual Class aspect that the receiver
	displays/edits."

	^#comment!

backgroundUpdate
	super backgroundUpdate.
	self refreshIcon!

caption
	^'Class comment'!

currentClassUpdated
	super currentClassUpdated.
	self refreshIcon!

defaultHelpId
	^10747!

icon
	| class |
	class := self browser selectedClass.
	^(class isNil or: [class sourceDescriptor isNil or: [class comment isEmpty]]) 
		ifTrue: [self class grayedIcon]
		ifFalse: [self class icon]!

setTextStyles
	textPresenter textStyles: self class textStyles!

setWordWrap
	textPresenter view wordWrap: self class wordWrap!

systemUpdateEvent
	^#classCommented:! !

!Tools.ClassCommentPlugin categoriesForMethods!
applyOptions!options!private! !
aspect!constants!private! !
backgroundUpdate!private!updating! !
caption!constants!private! !
currentClassUpdated!event handling!private! !
defaultHelpId!constants!public! !
icon!accessing!public! !
setTextStyles!helpers!private! !
setWordWrap!helpers!private! !
systemUpdateEvent!constants!private! !
!

!Tools.ClassCommentPlugin class methodsFor!

defaultBackcolor
	^(Color named: #commentWorkspace) basicActualColor!

defaultBackcolor: aColor
	(Color named: #commentWorkspace) actualColor: aColor!

defaultTextStyles
	^UI.Scintilla.ScintillaView markdownTextStyles!

grayedIcon
	"Answer the <Icon> to be used on the class comment tab when there is no class comment."

	^Icon fromId: 'GrayedClassComment.ico'!

icon
	"Answer an <Icon> that can be used to represent this class."

	^Icon fromId: 'ClassComment.ico'!

initialize
	WordWrap := true.
	ThemeColor addNamed: #commentWorkspace color: Color tooltip!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: (Aspect boolean: #wordWrap);
		add: SmalltalkWorkspace textStylesAspect;
		add: (Aspect color: #defaultBackcolor);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.Scintilla.ScintillaView} 50 56 nil 32 50 2 8 1176572228 1 144 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 518 #{Graphics.ThemeColor} #commentWorkspace nil 5 2886 4 #{UI.Menu} nil true 50 13 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #accept 8 '&Accept' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 306 nil true 50 8 354 1 386 #undo 8 '&Undo' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'EditUndo.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 434 4097 354 1 386 #cutSelection 8 'Cu&t' 1 1 546 nil true 578 8 'EditCut.ico' 640 65541 nil nil nil 354 1 386 #copySelection 8 '&Copy' 1 1 546 nil true 578 8 'EditCopy.ico' 640 65541 nil nil nil 354 1 386 #pasteClipboard 8 '&Paste' 1 1 546 nil true 578 8 'EditPaste.ico' 640 65541 nil nil nil 354 1 386 #clearSelection 8 'De&lete' 1 1 546 nil true 578 8 'EditClear.ico' 640 65541 nil nil nil 434 4097 354 1 386 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil 306 nil true 50 10 354 1 386 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 354 1 386 #cloneNew 8 '&Clone' 1 1 546 nil true 578 8 'SmalltalkWorkspace.ico' 640 65541 nil nil nil 434 4097 354 1 386 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 354 1 386 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 354 1 386 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 354 1 386 #toggleLineEndings 8 'Line &Endings' 1 1 2374 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 354 1 386 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 354 1 386 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 354 1 386 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 434 4097 354 1 386 #browseIt 8 'Bro&wse It' 1 1 546 nil true 578 8 'ClassBrowserShell.ico' 640 65541 nil nil nil 354 1 386 #displayIt 8 '&Display It' 1 1 546 nil true 578 8 'DisplayIt.ico' 640 65541 nil nil nil 354 1 386 #printIt 8 '&Print It' 1 1 546 nil true 578 8 'PrintIt.ico' 640 65541 nil nil nil 354 1 386 #evaluateIt 8 'E&valuate It' 1 1 546 nil true 578 8 'EvaluateIt.ico' 640 65541 nil nil nil 354 1 386 #inspectIt 8 '&Inspect It' 1 1 546 nil true 578 8 'BasicInspector.ico' 640 65541 nil nil nil 354 1 386 #debugIt 8 'Deb&ug It' 1 1 546 nil true 578 8 'Debugger.ico' 640 65541 nil nil nil 434 4097 306 nil true 50 2 354 2097153 386 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 354 1 386 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 144 nil nil 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil nil 550 #{Core.IdentityDictionary} 25 #blockQuote 3142 1 #{UI.Scintilla.TextStyle} 31 326 1 #{Graphics.RGB} 17825793 nil 1 nil nil nil nil #blockQuote nil nil nil #callTip 2578 77 6 #{Graphics.Color} #gray 2658 #white 1 nil nil nil nil #callTip nil nil nil #code 2578 39 2610 17825793 2610 31317469 1 nil nil nil nil #code nil nil nil #code2 2578 41 2610 17825793 2610 31317469 1 nil nil nil nil #code2 nil nil nil #codeBlock 2578 43 2610 17825793 2610 31317469 1 nil nil nil nil #codeBlock nil nil nil #em1 2578 9 2610 26317 nil 9 nil nil nil nil #em1 nil nil nil #em2 2578 11 2610 26317 nil 9 nil nil nil nil #em2 nil nil nil #header1 2578 13 2610 6887587 nil 1 nil nil nil nil #header1 nil 1401 nil #header2 2578 15 2610 6887587 nil 1 nil nil nil nil #header2 nil 1401 nil #header3 2578 17 2610 6887587 nil 1 nil nil nil nil #header3 nil 1401 nil #header4 2578 19 2610 6887587 nil 1 nil nil nil nil #header4 nil 1401 nil #header5 2578 21 2610 6887587 nil 1 nil nil nil nil #header5 nil 1401 nil #header6 2578 23 2610 6887587 nil 1 nil nil nil nil #header6 nil 1401 nil #horizontalRule 2578 35 2610 11184811 nil 1 nil nil nil nil #horizontalRule nil 1401 nil #indentGuide 2578 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineBegin 2578 3 nil nil 1 nil nil nil nil #lineBegin nil nil nil #lineNumber 2578 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #link 2578 37 2610 22282241 nil 33 nil nil nil nil #link nil nil nil #normal 2578 1 nil 2658 #window 1 nil nil nil nil #normal nil nil nil #olistItem 2578 29 2610 11184811 nil 1 nil nil nil nil #olistItem nil nil nil #preChar 2578 25 2658 #black 2610 22404573 1 nil nil nil nil #preChar nil 1401 nil #strikeOut 2578 33 2610 7768625 2610 20673875 1 nil nil nil nil #strikeOut nil nil nil #strong1 2578 5 2610 13404229 nil 1 nil nil nil nil #strong1 nil 1401 nil #strong2 2578 7 2610 13404229 nil 1 nil nil nil nil #strong2 nil 1401 nil #ulistItem 2578 27 2610 11184811 nil 1 nil nil nil nil #ulistItem nil nil nil nil 326 1 #{UI.Scintilla.NullStyler} #normal 2546 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 144 #circle nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 nil nil nil 3586 1 81 2658 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil nil 3 2546 1 #container 2546 2 #callTip 2578 77 2672 2688 1 nil nil nil nil #callTip nil nil nil #normal 2578 1 nil nil 1 nil nil nil nil #normal nil nil nil nil nil nil nil #{Core.Utf8String} nil 2546 2 #Error 3142 5 #{UI.Scintilla.IndicatorDefinition} 19 144 2658 #red 3 3 #Error nil nil nil nil nil nil #Warning 3762 17 144 2658 #blue 3 3 #Warning nil nil nil nil nil nil nil nil 2546 3 #Error 2578 1031 2658 #firebrick 2658 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 2578 1029 nil 2658 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 2578 1027 2658 #darkGoldenrod 2658 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 10 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 99 1 0 0 250 0 0 0] 193 176 nil 144 4034 #contextMenu: 50 1 320 144 4034 #wordWrap: 8 #(true) 144 4034 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 144 nil 3 nil nil nil nil 4274 3 144 nil nil nil 67108863 nil nil 4274 5 144 nil nil nil nil nil nil 144 4034 #maxCompletionListHeight: 8 #(9) 144 4034 #setLexerLanguage: 8 #(#markdown) 144 4034 #sciSetTechnology: 8 #(1) 144 4034 #sciSetFontQuality: 8 #(3) 144 4034 #hasAdditionalSelectionTyping: 8 #(true) 144 4034 #sciSetSelectionLayer: 8 #(1) 144 3 8 #() 518 #{Graphics.Point} 193 193 nil 45 518 #{Kernel.STBIdentityDictionaryProxy} 2544 50 2 144 8 'text' nil 3986 50 1 4034 #createWindow: 50 1 4082 4114 8 #[255 14 0 0 10 0 0 0 98 16 0 0 4 1 0 0] 193 80 8 '' 32 1 50 1 144 4546 193 193 nil 27)!

textStyles
	^TextStyles ifNil: [TextStyles := self defaultTextStyles]!

textStyles: anIdentityDictionary
	TextStyles := anIdentityDictionary!

uninitialize
	ThemeColor removeNamed: #commentWorkspace!

wordWrap
	"Answer whether word wrap should be enabled in new instances of the receiver."

	^WordWrap!

wordWrap: aBoolean 
	"Sets the comment word wrapping state for instances of the receiver to aBoolean."

	WordWrap == aBoolean ifTrue: [^self].
	WordWrap := aBoolean.
	self primAllSubinstances do: [:each | each setWordWrap]! !

!Tools.ClassCommentPlugin class categoriesForMethods!
defaultBackcolor!accessing!public! !
defaultBackcolor:!accessing!public! !
defaultTextStyles!constants!public! !
grayedIcon!constants!public! !
icon!constants!public! !
initialize!initializing!public! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
textStyles!accessing!options!public! !
textStyles:!accessing!options!public! !
uninitialize!class hierarchy-removing!private! !
wordWrap!accessing!options!public! !
wordWrap:!accessing!options!public! !
!

