"Filed out from Dolphin Smalltalk 7"!

ClassAspectPlugin subclass: #ClassCommentPlugin
	instanceVariableNames: ''
	classVariableNames: 'TextStyles WordWrap'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassCommentPlugin guid: (GUID fromString: '{9bbb729c-f516-492e-b991-7ad0c238a37f}')!
ClassCommentPlugin comment: '`ClassCommentPlugin` is a `<classBrowserPlugin>` for displaying/editing class comments.

The default view uses Scintilla with its built in markdown lexer. This provides some limited assistance for editing comments in markdown, but there is no renderer currently.

'!
!ClassCommentPlugin categoriesForClass!Browser-Plugins! !
!ClassCommentPlugin methodsFor!

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
	textPresenter view textStyles: self class textStyles!

setWordWrap
	textPresenter view wordWrap: self class wordWrap!

systemUpdateEvent
	^#classCommented:! !
!ClassCommentPlugin categoriesFor: #applyOptions!options!private! !
!ClassCommentPlugin categoriesFor: #aspect!constants!private! !
!ClassCommentPlugin categoriesFor: #backgroundUpdate!private!updating! !
!ClassCommentPlugin categoriesFor: #caption!constants!private! !
!ClassCommentPlugin categoriesFor: #currentClassUpdated!event handling!private! !
!ClassCommentPlugin categoriesFor: #defaultHelpId!constants!public! !
!ClassCommentPlugin categoriesFor: #icon!accessing!public! !
!ClassCommentPlugin categoriesFor: #setTextStyles!helpers!private! !
!ClassCommentPlugin categoriesFor: #setWordWrap!helpers!private! !
!ClassCommentPlugin categoriesFor: #systemUpdateEvent!constants!private! !

!ClassCommentPlugin class methodsFor!

defaultBackcolor
	^(Color named: #commentWorkspace) actualColor!

defaultBackcolor: aColor
	(Color named: #commentWorkspace) actualColor: aColor!

defaultTextStyles
	^ScintillaView markdownTextStyles!

grayedIcon
	"Answer the <Icon> to be used on the class comment tab when there is no class comment."

	^Icon fromId: 'GrayedClassComment.ico'!

icon
	"Answer an <Icon> that can be used to represent this class."

	^Icon fromId: 'ClassComment.ico'!

initialize
	WordWrap := true.
	ThemeColor addNamed: #commentWorkspace color: Color ivory!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		add: (Aspect boolean: #wordWrap);
		add: SmalltalkWorkspace textStylesAspect;
		add: (Aspect color: #defaultBackcolor);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 416 34 2 8 1176572228 1 512 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 655878 ##(Smalltalk.ThemeColor) #commentWorkspace nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 13 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #accept 8 '&Accept' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 674 nil true 34 8 722 1 754 #undo 8 '&Undo' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'EditUndo.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 802 4097 722 1 754 #cutSelection 8 'Cu&t' 1 1 914 nil true 960 8 'EditCut.ico' 1008 nil nil 722 1 754 #copySelection 8 '&Copy' 1 1 914 nil true 960 8 'EditCopy.ico' 1008 nil nil 722 1 754 #pasteClipboard 8 '&Paste' 1 1 914 nil true 960 8 'EditPaste.ico' 1008 nil nil 722 1 754 #clearSelection 8 'De&lete' 1 1 914 nil true 960 8 'EditClear.ico' 1008 nil nil 802 4097 722 1 754 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil 674 nil true 34 10 722 1 754 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 722 1 754 #cloneNew 8 '&Clone' 1 1 914 nil true 960 8 'SmalltalkWorkspace.ico' 1008 nil nil 802 4097 722 1 754 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 722 1 754 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 722 1 754 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 722 1 754 #toggleLineEndings 8 'Line &Endings' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 722 1 754 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 722 1 754 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 722 1 754 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 802 4097 722 1 754 #browseIt 8 'Bro&wse It' 1 1 914 nil true 960 8 'ClassBrowserShell.ico' 1008 nil nil 722 1 754 #displayIt 8 '&Display It' 1 1 914 nil true 960 8 'DisplayIt.ico' 1008 nil nil 722 1 754 #printIt 8 '&Print It' 1 1 914 nil true 960 8 'PrintIt.ico' 1008 nil nil 722 1 754 #evaluateIt 8 'E&valuate It' 1 1 914 nil true 960 8 'EvaluateIt.ico' 1008 nil nil 722 1 754 #inspectIt 8 '&Inspect It' 1 1 914 nil true 960 8 'BasicInspector.ico' 1008 nil nil 722 1 754 #debugIt 8 'Deb&ug It' 1 1 914 nil true 960 8 'Debugger.ico' 1008 nil nil 802 4097 674 nil true 34 2 722 2097153 754 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 722 1 754 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 512 nil 8 1784336831 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 50 #strong2 1182790 1 ##(Smalltalk.ScintillaTextStyle) 7 196934 1 ##(Smalltalk.RGB) 13404229 nil 1 nil nil nil nil #strong2 nil 1401 nil #ulistItem 2786 27 2818 11184811 nil 1 nil nil nil nil #ulistItem nil nil nil #codeBlock 2786 43 2818 17825793 2818 31317469 1 nil nil nil nil #codeBlock nil nil nil #strikeOut 2786 33 2818 7768625 2818 20673875 1 nil nil nil nil #strikeOut nil nil nil #header2 2786 15 2818 6887587 nil 1 nil nil nil nil #header2 nil 1401 nil #preChar 2786 25 327686 ##(Smalltalk.Color) #black 2818 22404573 1 nil nil nil nil #preChar nil 1401 nil #horizontalRule 2786 35 2818 11184811 nil 1 nil nil nil nil #horizontalRule nil 1401 nil #code 2786 39 2818 17825793 2818 31317469 1 nil nil nil nil #code nil nil nil #header6 2786 23 2818 6887587 nil 1 nil nil nil nil #header6 nil 1401 nil #strong1 2786 5 2818 13404229 nil 1 nil nil nil nil #strong1 nil 1401 nil #link 2786 37 2818 22282241 nil 33 nil nil nil nil #link nil nil nil #indentGuide 2786 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #callTip 2786 77 3026 #gray 3026 #white 1 nil nil nil nil #callTip nil nil nil #header4 2786 19 2818 6887587 nil 1 nil nil nil nil #header4 nil 1401 nil #lineBegin 2786 3 nil nil 1 nil nil nil nil #lineBegin nil nil nil #lineNumber 2786 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 2786 1 nil 3026 #window 1 nil nil nil nil #normal nil nil nil #olistItem 2786 29 2818 11184811 nil 1 nil nil nil nil #olistItem nil nil nil #em2 2786 11 2818 26317 nil 9 nil nil nil nil #em2 nil nil nil #header1 2786 13 2818 6887587 nil 1 nil nil nil nil #header1 nil 1401 nil #header5 2786 21 2818 6887587 nil 1 nil nil nil nil #header5 nil 1401 nil #code2 2786 41 2818 17825793 2818 31317469 1 nil nil nil nil #code2 nil nil nil #em1 2786 9 2818 26317 nil 9 nil nil nil nil #em1 nil nil nil #header3 2786 17 2818 6887587 nil 1 nil nil nil nil #header3 nil 1401 nil #blockQuote 2786 31 2818 17825793 nil 1 nil nil nil nil #blockQuote nil nil nil 34 256 3376 3344 3184 2800 3584 3440 3472 2976 3616 3312 3504 3152 3008 2848 3408 3648 2928 3072 3216 3104 3536 2880 nil nil nil nil nil nil nil nil nil nil nil 3360 nil nil nil 3248 3264 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 512 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 8 #() nil 170 176 3808 nil nil nil nil nil 3026 #silver nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 170 192 34 4 #callTip 2786 77 3280 3296 1 nil nil nil nil #callTip nil nil nil #normal 2786 1 nil nil 1 nil nil nil nil #normal nil nil nil nil nil nil nil 130003 nil 170 192 34 4 #Warning 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 17 512 3026 #blue 3 false #Warning nil nil nil nil nil nil #Error 4002 19 512 3026 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 2786 1027 3026 #darkGoldenrod 3026 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 2786 1031 3026 #firebrick 3026 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 2786 1029 nil 3026 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 13 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 4354 711 501 512 4306 #contextMenu: 34 1 688 512 4306 #textLimit: 8 #(1073741823) 512 4306 #isDrawingBuffered: 8 #(false) 512 4306 #caretPeriod: 8 #(530) 512 4306 #wordWrap: 8 #(true) 512 4306 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 512 1 3 nil nil nil nil 4610 3 512 1 nil nil 67108863 nil nil 4610 5 512 1 nil nil nil nil nil 512 4306 #maxCompletionListHeight: 8 #(9) 512 4306 #edgeColumn: 8 #(1) 512 4306 #setLexerLanguage: 8 #(#markdown) 512 4306 #sciSetTechnology: 8 #(1) 512 4306 #sciSetFontQuality: 8 #(3) 512 4306 #hasAdditionalSelectionTyping: 8 #(true) 512 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 99 1 0 0 250 0 0 0] 8 #() 4354 193 193 nil 29 170 192 34 2 512 8 'text' nil 4242 138 144 34 1 4306 #createAt:extent: 34 2 4354 3839 21 4354 711 501 416 4866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 226 8 0 0 4 1 0 0] 34 1 512 4928 nil 27 )!

textStyles
	^TextStyles ifNil: [TextStyles := self defaultTextStyles]!

uninitialize
	ThemeColor removeNamed: #commentWorkspace!

wordWrap
	"Answer whether word wrap should be enabled in new instances of the receiver."

	^WordWrap!

wordWrap: aBoolean 
	"Sets the comment word wrapping state for instances of the receiver to aBoolean."

	WordWrap == aBoolean ifTrue: [^self].
	WordWrap := aBoolean.
	self allSubinstances do: [:each | each setWordWrap]! !
!ClassCommentPlugin class categoriesFor: #defaultBackcolor!accessing!public! !
!ClassCommentPlugin class categoriesFor: #defaultBackcolor:!accessing!public! !
!ClassCommentPlugin class categoriesFor: #defaultTextStyles!constants!public! !
!ClassCommentPlugin class categoriesFor: #grayedIcon!constants!public! !
!ClassCommentPlugin class categoriesFor: #icon!constants!public! !
!ClassCommentPlugin class categoriesFor: #initialize!initializing!public! !
!ClassCommentPlugin class categoriesFor: #publishedAspects!public! !
!ClassCommentPlugin class categoriesFor: #resource_Default_view!public!resources-views! !
!ClassCommentPlugin class categoriesFor: #textStyles!accessing!options!public! !
!ClassCommentPlugin class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!ClassCommentPlugin class categoriesFor: #wordWrap!accessing!options!public! !
!ClassCommentPlugin class categoriesFor: #wordWrap:!accessing!options!public! !

