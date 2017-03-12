"Filed out from Dolphin Smalltalk 7"!

ClassAspectPlugin subclass: #ClassCommentPlugin
	instanceVariableNames: ''
	classVariableNames: 'TextStyles WordWrap'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassCommentPlugin guid: (GUID fromString: '{9bbb729c-f516-492e-b991-7ad0c238a37f}')!
ClassCommentPlugin comment: 'ClassCommentPlugin is a <classBrowserPlugin> for displaying/editing class comments.'!
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
	^(Set new)
		add: ((ScintillaTextStyle new)
					name: #normal;
					forecolor: Color darkGreen;
					yourself);
		add: ((ScintillaTextStyle name: #indentGuide)
					forecolor: Color gray;
					yourself);
		yourself!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 0 0 34 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 0 0 0 410 ##(Smalltalk.ScintillaView) 34 50 0 416 34 2 8 1176572228 262145 560 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 482 512 0 5 265030 4 ##(Smalltalk.Menu) 0 true 34 15 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #accept 8 '&Accept' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 706 0 true 34 8 754 1 786 #undo 8 '&Undo' 1 1 0 0 0 834 4097 754 1 786 #cutSelection 8 'Cu&t' 1 1 0 0 0 754 1 786 #copySelection 8 '&Copy' 1 1 0 0 0 754 1 786 #pasteClipboard 8 '&Paste' 1 1 0 0 0 754 1 786 #clearSelection 8 'De&lete' 1 1 0 0 0 834 4097 754 1 786 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 1 0 0 0 0 0 754 1 786 #clear 8 'Clea&r' 1 1 0 0 0 834 4097 754 1 786 #browseIt 8 'Bro&wse It' 1 1 263494 3 ##(Smalltalk.Icon) 0 true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ClassBrowserShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 754 1 786 #displayIt 8 '&Display It' 1 1 0 0 0 754 1 786 #evaluateIt 8 'E&valuate It' 1 1 0 0 0 754 1 786 #inspectIt 8 '&Inspect It' 1 1 1346 0 true 1392 8 'BasicInspector.ico' 1440 0 0 754 1 786 #debugIt 8 'Deb&ug It' 1 1 1346 0 true 1392 8 'Debugger.ico' 1440 0 0 834 4097 754 1 786 #inspectWorkspacePool 8 'Variab&les' 1 1 0 0 0 754 1 786 #cloneNew 8 'Clo&ne' 1 1 0 0 0 834 4097 706 0 true 34 2 754 2097153 786 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 754 1 786 #browseReferences 8 '&References...' 1 1 0 0 0 8 '&Browse' 0 1 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 560 0 8 4294906539 852486 ##(Smalltalk.NullConverter) 0 0 9 0 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 0 0 1 0 0 0 0 #normal 0 0 0 #callTip 2098 77 786694 ##(Smalltalk.IndexedColor) 33554457 2146 33554471 1 0 0 0 0 #callTip 0 0 0 170 192 34 2 1 2112 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 560 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 8 #() 0 170 176 2336 9215 0 0 0 0 2146 33554447 0 0 65 0 0 0 8 '' 3 170 192 34 2 #container 2064 0 0 0 0 1 0 170 192 34 4 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 560 33554465 3 false #Warning 0 0 0 0 0 0 #Error 2466 19 560 33554459 3 false #Error 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 2098 1029 0 196934 1 ##(Smalltalk.RGB) 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 2098 1027 2562 60239 2562 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 2098 1031 2562 335 2562 31317503 1 0 0 0 0 #Error 0 0 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 6 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 2802 701 501 560 2754 #contextMenu: 34 1 720 560 2754 #modificationEventMask: 8 #(4607) 560 2754 #caretPeriod: 8 #(530) 560 2754 #wordWrap: 8 #(true) 560 2754 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 560 1 3 0 0 0 0 3026 3 560 1 0 0 67108863 0 0 3026 5 560 1 0 0 0 0 0 560 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 2802 193 193 0 29 170 192 34 2 560 8 'text' 0 2690 138 144 34 1 2754 #createAt:extent: 34 2 2802 3839 21 2802 701 501 416 3090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 34 1 560 3152 0 27 )!

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
!ClassCommentPlugin class categoriesFor: #textStyles!options!public! !
!ClassCommentPlugin class categoriesFor: #wordWrap!accessing!options!public! !
!ClassCommentPlugin class categoriesFor: #wordWrap:!accessing!options!public! !

