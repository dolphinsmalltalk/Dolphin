"Filed out from Dolphin Smalltalk 7"!

ClassAspectPlugin subclass: #ClassCommentPlugin
	instanceVariableNames: ''
	classVariableNames: 'TextStyles WordWrap'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassCommentPlugin guid: (GUID fromString: '{9bbb729c-f516-492e-b991-7ad0c238a37f}')!
ClassCommentPlugin comment: '`ClassCommentPlugin` is a `<classBrowserPlugin>` for displaying/editing class comments.

The default view uses Scintilla with its built in markdown lexer. This provides some limited assistance for editing comments in markdown, but there is no renderer currently.'!
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
!ClassCommentPlugin categoriesFor: #defaultHelpId!constants!public! !
!ClassCommentPlugin categoriesFor: #icon!accessing!public! !
!ClassCommentPlugin categoriesFor: #setTextStyles!helpers!private! !
!ClassCommentPlugin categoriesFor: #setWordWrap!helpers!private! !
!ClassCommentPlugin categoriesFor: #systemUpdateEvent!constants!private! !

!ClassCommentPlugin class methodsFor!

defaultTextStyles
	^ScintillaView markdownTextStyles!

grayedIcon
	"Answer the <Icon> to be used on the class comment tab when there is no class comment."

	^Icon fromFile: 'GrayedClassComment.ico'!

icon
	"Answer an <Icon> that can be used to represent this class."

	^Icon fromFile: 'ClassComment.ico'!

initialize
	WordWrap := true!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		add: (Aspect boolean: #wordWrap);
		add: SmalltalkWorkspace textStylesAspect;
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 5 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 416 34 2 8 1176572228 1 560 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 482 512 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 15 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #accept 8 '&Accept' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 706 nil true 34 8 754 1 786 #undo 8 '&Undo' 1 1 nil nil nil 834 4097 754 1 786 #cutSelection 8 'Cu&t' 1 1 nil nil nil 754 1 786 #copySelection 8 '&Copy' 1 1 nil nil nil 754 1 786 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 754 1 786 #clearSelection 8 'De&lete' 1 1 nil nil nil 834 4097 754 1 786 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil 754 1 786 #clear 8 'Clea&r' 1 1 nil nil nil 834 4097 754 1 786 #browseIt 8 'Bro&wse It' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ClassBrowserShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 754 1 786 #displayIt 8 '&Display It' 1 1 nil nil nil 754 1 786 #evaluateIt 8 'E&valuate It' 1 1 nil nil nil 754 1 786 #inspectIt 8 '&Inspect It' 1 1 1346 nil true 1392 8 'BasicInspector.ico' 1440 nil nil 754 1 786 #debugIt 8 'Deb&ug It' 1 1 1346 nil true 1392 8 'Debugger.ico' 1440 nil nil 834 4097 754 1 786 #inspectWorkspacePool 8 'Variab&les' 1 1 nil nil nil 754 1 786 #cloneNew 8 'Clo&ne' 1 1 nil nil nil 834 4097 706 nil true 34 2 754 2097153 786 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 754 1 786 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 560 nil 8 1892470377 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 50 #lineBegin 1182790 1 ##(Smalltalk.ScintillaTextStyle) 3 nil nil 1 nil nil nil nil #lineBegin nil nil nil #code2 2098 41 196934 1 ##(Smalltalk.RGB) 17825793 2146 31317469 1 nil nil nil nil #code2 nil nil nil #preChar 2098 25 786694 ##(Smalltalk.IndexedColor) 33554433 2146 22404573 1 nil nil nil nil #preChar nil 1401 nil #em1 2098 9 2146 26317 nil 9 nil nil nil nil #em1 nil nil nil #blockQuote 2098 31 2146 17825793 nil 1 nil nil nil nil #blockQuote nil nil nil #header6 2098 23 2146 6887587 nil 1 nil nil nil nil #header6 nil 1401 nil #ulistItem 2098 27 2146 11184811 nil 1 nil nil nil nil #ulistItem nil nil nil #header3 2098 17 2146 6887587 nil 1 nil nil nil nil #header3 nil 1401 nil #strong2 2098 7 2146 13404229 nil 1 nil nil nil nil #strong2 nil 1401 nil #header5 2098 21 2146 6887587 nil 1 nil nil nil nil #header5 nil 1401 nil #horizontalRule 2098 35 2146 11184811 nil 1 nil nil nil nil #horizontalRule nil 1401 nil #em2 2098 11 2146 26317 nil 9 nil nil nil nil #em2 nil nil nil #normal 2098 1 nil 721158 ##(Smalltalk.SystemColor) 11 1 nil nil nil nil #normal nil nil nil #lineNumber 2098 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #header1 2098 13 2146 6887587 nil 1 nil nil nil nil #header1 nil 1401 nil #header2 2098 15 2146 6887587 nil 1 nil nil nil nil #header2 nil 1401 nil #strong1 2098 5 2146 13404229 nil 1 nil nil nil nil #strong1 nil 1401 nil #indentGuide 2098 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #callTip 2098 77 2210 33554457 2210 33554471 1 nil nil nil nil #callTip nil nil nil #header4 2098 19 2146 6887587 nil 1 nil nil nil nil #header4 nil 1401 nil #code 2098 39 2146 17825793 2146 31317469 1 nil nil nil nil #code nil nil nil #codeBlock 2098 43 2146 17825793 2146 31317469 1 nil nil nil nil #codeBlock nil nil nil #olistItem 2098 29 2146 11184811 nil 1 nil nil nil nil #olistItem nil nil nil #strikeOut 2098 33 2146 7768625 2146 20673875 1 nil nil nil nil #strikeOut nil nil nil #link 2098 37 2146 22282241 nil 33 nil nil nil nil #link nil nil nil 34 256 2544 2112 2672 2416 2256 2512 2608 2640 2384 2768 2448 2320 2192 2352 2896 2288 2928 2480 2976 2800 2128 2848 nil nil nil nil nil nil nil nil nil nil nil 2592 nil nil nil 2704 2720 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 560 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 8 #() nil 170 176 3136 9215 nil nil nil nil 2210 33554447 nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 170 192 34 4 #normal 2098 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 2098 77 2736 2752 1 nil nil nil nil #callTip nil nil nil nil nil nil nil 130003 nil 170 192 34 4 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 560 33554465 3 false #Warning nil nil nil nil nil nil #Error 3330 19 560 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 2098 1027 2146 60239 2146 31326207 1 nil nil nil nil #Warning nil nil nil #Error 2098 1031 2146 335 2146 31317503 1 nil nil nil nil #Error nil nil nil #Notification 2098 1029 nil 2146 31185883 1 nil nil nil nil #Notification nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 9 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 3650 701 501 560 3602 #contextMenu: 34 1 720 560 3602 #textLimit: 8 #(1073741823) 560 3602 #modificationEventMask: 8 #(4607) 560 3602 #caretPeriod: 8 #(530) 560 3602 #wordWrap: 8 #(true) 560 3602 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 560 1 3 nil nil nil nil 3906 3 560 1 nil nil 67108863 nil nil 3906 5 560 1 nil nil nil nil nil 560 3602 #maxCompletionListHeight: 8 #(9) 560 3602 #setLexerLanguage: 8 #(#markdown) 560 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 3650 193 193 nil 29 170 192 34 2 560 8 'text' nil 3538 138 144 34 1 3602 #createAt:extent: 34 2 3650 3839 21 3650 701 501 416 4034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 34 1 560 4096 nil 27 )!

textStyles
	TextStyles isNil ifTrue: [TextStyles := self defaultTextStyles].
	^TextStyles!

wordWrap
	"Answer whether word wrap should be enabled in new instances of the receiver."

	^WordWrap!

wordWrap: aBoolean 
	"Sets the comment word wrapping state for instances of the receiver to aBoolean."

	WordWrap == aBoolean ifTrue: [^self].
	WordWrap := aBoolean.
	self allSubinstances do: [:each | each setWordWrap]! !
!ClassCommentPlugin class categoriesFor: #defaultTextStyles!constants!public! !
!ClassCommentPlugin class categoriesFor: #grayedIcon!constants!public! !
!ClassCommentPlugin class categoriesFor: #icon!constants!public! !
!ClassCommentPlugin class categoriesFor: #initialize!initializing!public! !
!ClassCommentPlugin class categoriesFor: #publishedAspects!development!public! !
!ClassCommentPlugin class categoriesFor: #resource_Default_view!public!resources-views! !
!ClassCommentPlugin class categoriesFor: #textStyles!accessing!options!public! !
!ClassCommentPlugin class categoriesFor: #wordWrap!accessing!options!public! !
!ClassCommentPlugin class categoriesFor: #wordWrap:!accessing!options!public! !

