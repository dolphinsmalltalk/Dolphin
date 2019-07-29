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
	ThemeColor addNamed: #commentWorkspace
		color: (RGB
				r: 255
				g: 255
				b: 235)!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 416 34 2 8 1176572228 1 512 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 655878 ##(Smalltalk.ThemeColor) #commentWorkspace nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 15 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #accept 8 '&Accept' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 674 nil true 34 8 722 1 754 #undo 8 '&Undo' 1 1 nil nil nil 802 4097 722 1 754 #cutSelection 8 'Cu&t' 1 1 nil nil nil 722 1 754 #copySelection 8 '&Copy' 1 1 nil nil nil 722 1 754 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 722 1 754 #clearSelection 8 'De&lete' 1 1 nil nil nil 802 4097 722 1 754 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil 722 1 754 #clear 8 'Clea&r' 1 1 nil nil nil 802 4097 722 1 754 #browseIt 8 'Bro&wse It' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ClassBrowserShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 722 1 754 #displayIt 8 '&Display It' 1 1 nil nil nil 722 1 754 #evaluateIt 8 'E&valuate It' 1 1 nil nil nil 722 1 754 #inspectIt 8 '&Inspect It' 1 1 1314 nil true 1360 8 'BasicInspector.ico' 1408 nil nil 722 1 754 #debugIt 8 'Deb&ug It' 1 1 1314 nil true 1360 8 'Debugger.ico' 1408 nil nil 802 4097 722 1 754 #inspectWorkspacePool 8 'Variab&les' 1 1 nil nil nil 722 1 754 #cloneNew 8 'Clo&ne' 1 1 nil nil nil 802 4097 674 nil true 34 2 722 2097153 754 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 722 1 754 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 512 nil 8 1763950116 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 50 #header1 1182790 1 ##(Smalltalk.ScintillaTextStyle) 13 196934 1 ##(Smalltalk.RGB) 6887587 nil 1 nil nil nil nil #header1 nil 1401 nil #olistItem 2066 29 2098 11184811 nil 1 nil nil nil nil #olistItem nil nil nil #header3 2066 17 2098 6887587 nil 1 nil nil nil nil #header3 nil 1401 nil #header5 2066 21 2098 6887587 nil 1 nil nil nil nil #header5 nil 1401 nil #strong2 2066 7 2098 13404229 nil 1 nil nil nil nil #strong2 nil 1401 nil #strong1 2066 5 2098 13404229 nil 1 nil nil nil nil #strong1 nil 1401 nil #lineBegin 2066 3 nil nil 1 nil nil nil nil #lineBegin nil nil nil #em2 2066 11 2098 26317 nil 9 nil nil nil nil #em2 nil nil nil #preChar 2066 25 786694 ##(Smalltalk.IndexedColor) 33554433 2098 22404573 1 nil nil nil nil #preChar nil 1401 nil #link 2066 37 2098 22282241 nil 33 nil nil nil nil #link nil nil nil #ulistItem 2066 27 2098 11184811 nil 1 nil nil nil nil #ulistItem nil nil nil #code2 2066 41 2098 17825793 2098 31317469 1 nil nil nil nil #code2 nil nil nil #header4 2066 19 2098 6887587 nil 1 nil nil nil nil #header4 nil 1401 nil #indentGuide 2066 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #codeBlock 2066 43 2098 17825793 2098 31317469 1 nil nil nil nil #codeBlock nil nil nil #normal 2066 1 nil 721158 ##(Smalltalk.SystemColor) 11 1 nil nil nil nil #normal nil nil nil #lineNumber 2066 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #blockQuote 2066 31 2098 17825793 nil 1 nil nil nil nil #blockQuote nil nil nil #callTip 2066 77 2354 33554457 2354 33554471 1 nil nil nil nil #callTip nil nil nil #strikeOut 2066 33 2098 7768625 2098 20673875 1 nil nil nil nil #strikeOut nil nil nil #header2 2066 15 2098 6887587 nil 1 nil nil nil nil #header2 nil 1401 nil #em1 2066 9 2098 26317 nil 9 nil nil nil nil #em1 nil nil nil #header6 2066 23 2098 6887587 nil 1 nil nil nil nil #header6 nil 1401 nil #horizontalRule 2066 35 2098 11184811 nil 1 nil nil nil nil #horizontalRule nil 1401 nil #code 2066 39 2098 17825793 2098 31317469 1 nil nil nil nil #code nil nil nil 34 256 2608 2288 2256 2224 2832 2304 2080 2800 2160 2512 2192 2864 2336 2432 2128 2672 2752 2896 2400 2928 2464 2560 nil nil nil nil nil nil nil nil nil nil nil 2656 nil nil nil 2544 2704 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 512 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 8 #() nil 170 176 3104 nil nil nil nil nil 2354 33554447 nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 170 192 34 4 #callTip 2066 77 2720 2736 1 nil nil nil nil #callTip nil nil nil #normal 2066 1 nil nil 1 nil nil nil nil #normal nil nil nil nil nil nil nil 130003 nil 170 192 34 4 #Error 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 19 512 2354 33554459 3 false #Error nil nil nil nil nil nil #Warning 3298 17 512 2354 33554465 3 false #Warning nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 2066 1029 nil 2098 31185883 1 nil nil nil nil #Notification nil nil nil #Error 2066 1031 2098 335 2098 31317503 1 nil nil nil nil #Error nil nil nil #Warning 2066 1027 2098 60239 2098 31326207 1 nil nil nil nil #Warning nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 12 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 3650 711 501 512 3602 #contextMenu: 34 1 688 512 3602 #textLimit: 8 #(1073741823) 512 3602 #isDrawingBuffered: 8 #(false) 512 3602 #caretPeriod: 8 #(530) 512 3602 #wordWrap: 8 #(true) 512 3602 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 512 1 3 nil nil nil nil 3906 3 512 1 nil nil 67108863 nil nil 3906 5 512 1 nil nil nil nil nil 512 3602 #maxCompletionListHeight: 8 #(9) 512 3602 #setLexerLanguage: 8 #(#markdown) 512 3602 #sciSetTechnology: 8 #(1) 512 3602 #sciSetFontQuality: 8 #(3) 512 3602 #hasAdditionalSelectionTyping: 8 #(true) 512 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 99 1 0 0 250 0 0 0] 8 #() 3650 193 193 nil 29 170 192 34 2 512 8 'text' nil 3538 138 144 34 1 3602 #createAt:extent: 34 2 3650 3839 21 3650 711 501 416 4130 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 226 8 0 0 4 1 0 0] 34 1 512 4192 nil 27 )!

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

