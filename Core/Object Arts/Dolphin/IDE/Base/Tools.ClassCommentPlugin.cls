"Filed out from Dolphin Smalltalk"!

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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 nil nil nil nil 410 #{UI.Scintilla.ScintillaView} 34 52 nil 416 34 2 8 1176572228 1 512 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil 1245702 #{Graphics.ThemeColor} #commentWorkspace nil 5 461638 4 #{UI.Menu} nil true 34 13 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #accept 8 '&Accept' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 674 nil true 34 8 722 1 754 #undo 8 '&Undo' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'EditUndo.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 802 4097 722 1 754 #cutSelection 8 'Cu&t' 1 1 914 nil true 946 8 'EditCut.ico' 1008 65541 nil nil nil 722 1 754 #copySelection 8 '&Copy' 1 1 914 nil true 946 8 'EditCopy.ico' 1008 65541 nil nil nil 722 1 754 #pasteClipboard 8 '&Paste' 1 1 914 nil true 946 8 'EditPaste.ico' 1008 65541 nil nil nil 722 1 754 #clearSelection 8 'De&lete' 1 1 914 nil true 946 8 'EditClear.ico' 1008 65541 nil nil nil 802 4097 722 1 754 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil 674 nil true 34 10 722 1 754 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 722 1 754 #cloneNew 8 '&Clone' 1 1 914 nil true 946 8 'SmalltalkWorkspace.ico' 1008 65541 nil nil nil 802 4097 722 1 754 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 722 1 754 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 722 1 754 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 722 1 754 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 722 1 754 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 722 1 754 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 722 1 754 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 802 4097 722 1 754 #browseIt 8 'Bro&wse It' 1 1 914 nil true 946 8 'ClassBrowserShell.ico' 1008 65541 nil nil nil 722 1 754 #displayIt 8 '&Display It' 1 1 914 nil true 946 8 'DisplayIt.ico' 1008 65541 nil nil nil 722 1 754 #printIt 8 '&Print It' 1 1 914 nil true 946 8 'PrintIt.ico' 1008 65541 nil nil nil 722 1 754 #evaluateIt 8 'E&valuate It' 1 1 914 nil true 946 8 'EvaluateIt.ico' 1008 65541 nil nil nil 722 1 754 #inspectIt 8 '&Inspect It' 1 1 914 nil true 946 8 'BasicInspector.ico' 1008 65541 nil nil nil 722 1 754 #debugIt 8 'Deb&ug It' 1 1 914 nil true 946 8 'Debugger.ico' 1008 65541 nil nil nil 802 4097 674 nil true 34 2 722 2097153 754 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 722 1 754 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 512 nil 8 1395533126 1049094 #{UI.NullConverter} nil nil 9 nil 170 192 34 50 #callTip 1444934 1 #{UI.Scintilla.TextStyle} 77 917510 #{Graphics.Color} #gray 2994 #white 1 nil nil nil nil #callTip nil nil nil #olistItem 2962 29 786758 1 #{Graphics.RGB} 11184811 nil 1 nil nil nil nil #olistItem nil nil nil #horizontalRule 2962 35 3058 11184811 nil 1 nil nil nil nil #horizontalRule nil 1401 nil #header6 2962 23 3058 6887587 nil 1 nil nil nil nil #header6 nil 1401 nil #header3 2962 17 3058 6887587 nil 1 nil nil nil nil #header3 nil 1401 nil #link 2962 37 3058 22282241 nil 33 nil nil nil nil #link nil nil nil #strikeOut 2962 33 3058 7768625 3058 20673875 1 nil nil nil nil #strikeOut nil nil nil #strong1 2962 5 3058 13404229 nil 1 nil nil nil nil #strong1 nil 1401 nil #header1 2962 13 3058 6887587 nil 1 nil nil nil nil #header1 nil 1401 nil #preChar 2962 25 2994 #black 3058 22404573 1 nil nil nil nil #preChar nil 1401 nil #em2 2962 11 3058 26317 nil 9 nil nil nil nil #em2 nil nil nil #header2 2962 15 3058 6887587 nil 1 nil nil nil nil #header2 nil 1401 nil #ulistItem 2962 27 3058 11184811 nil 1 nil nil nil nil #ulistItem nil nil nil #header4 2962 19 3058 6887587 nil 1 nil nil nil nil #header4 nil 1401 nil #header5 2962 21 3058 6887587 nil 1 nil nil nil nil #header5 nil 1401 nil #lineBegin 2962 3 nil nil 1 nil nil nil nil #lineBegin nil nil nil #em1 2962 9 3058 26317 nil 9 nil nil nil nil #em1 nil nil nil #code 2962 39 3058 17825793 3058 31317469 1 nil nil nil nil #code nil nil nil #strong2 2962 7 3058 13404229 nil 1 nil nil nil nil #strong2 nil 1401 nil #codeBlock 2962 43 3058 17825793 3058 31317469 1 nil nil nil nil #codeBlock nil nil nil #code2 2962 41 3058 17825793 3058 31317469 1 nil nil nil nil #code2 nil nil nil #blockQuote 2962 31 3058 17825793 nil 1 nil nil nil nil #blockQuote nil nil nil #normal 2962 1 nil 2994 #window 1 nil nil nil nil #normal nil nil nil #indentGuide 2962 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 2962 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil nil 1507654 1 #{UI.Scintilla.NullStyler} #normal 170 192 34 2 #default 1903686 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 512 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 8 #() nil 170 176 3968 nil nil nil 170 176 34 2 81 2994 #windowText nil nil 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 170 192 34 4 #callTip 2962 77 3008 3024 1 nil nil nil nil #callTip nil nil nil #normal 2962 1 nil nil 1 nil nil nil nil #normal nil nil nil nil nil nil nil 208 nil 170 192 34 4 #Error 1772614 4 #{UI.Scintilla.IndicatorDefinition} 19 512 2994 #red 3 3 #Error nil nil nil nil nil nil #Warning 4226 17 512 2994 #blue 3 3 #Warning nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 2962 1029 nil 2994 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 2962 1027 2994 #darkGoldenrod 2994 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 2962 1031 2994 #firebrick 2994 #floralWhite 1 nil nil nil nil #Error nil nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 10 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 1 4562 711 501 512 4514 #contextMenu: 34 1 688 512 4514 #wordWrap: 8 #(true) 512 4514 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 512 1 3 nil nil nil nil 4722 3 512 1 nil nil 67108863 nil nil 4722 5 512 1 nil nil nil nil nil 512 4514 #maxCompletionListHeight: 8 #(9) 512 4514 #setLexerLanguage: 8 #(#markdown) 512 4514 #sciSetTechnology: 8 #(1) 512 4514 #sciSetFontQuality: 8 #(3) 512 4514 #hasAdditionalSelectionTyping: 8 #(true) 512 4514 #sciSetSelectionLayer: 8 #(1) 512 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 99 1 0 0 250 0 0 0] 8 #() 4562 193 193 nil 35 170 192 34 2 512 8 'text' nil 4466 34 1 4514 #createAt:extent: 34 2 4562 12287 21 4562 711 501 416 4978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 98 25 0 0 4 1 0 0] 34 1 512 5040 nil 27)!

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

