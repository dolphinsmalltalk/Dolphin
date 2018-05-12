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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 5 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 416 34 2 8 1176572228 262145 560 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 482 512 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 15 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #accept 18 7 38 65 99 99 101 112 116 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 706 nil true 34 8 754 1 786 #undo 18 5 38 85 110 100 111 1 1 nil nil nil 834 4097 754 1 786 #cutSelection 18 4 67 117 38 116 1 1 nil nil nil 754 1 786 #copySelection 18 5 38 67 111 112 121 1 1 nil nil nil 754 1 786 #pasteClipboard 18 6 38 80 97 115 116 101 1 1 nil nil nil 754 1 786 #clearSelection 18 7 68 101 38 108 101 116 101 1 1 nil nil nil 834 4097 754 1 786 #selectAll 18 11 38 83 101 108 101 99 116 32 65 108 108 1 1 nil nil nil 18 5 38 69 100 105 116 nil 1 nil nil nil nil nil 754 1 786 #clear 18 6 67 108 101 97 38 114 1 1 nil nil nil 834 4097 754 1 786 #browseIt 18 10 66 114 111 38 119 115 101 32 73 116 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 18 21 67 108 97 115 115 66 114 111 119 115 101 114 83 104 101 108 108 46 105 99 111 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 18 14 100 111 108 112 104 105 110 100 114 55 46 100 108 108 nil nil nil 754 1 786 #displayIt 18 11 38 68 105 115 112 108 97 121 32 73 116 1 1 nil nil nil 754 1 786 #evaluateIt 18 12 69 38 118 97 108 117 97 116 101 32 73 116 1 1 nil nil nil 754 1 786 #inspectIt 18 11 38 73 110 115 112 101 99 116 32 73 116 1 1 1346 nil true 1392 18 18 66 97 115 105 99 73 110 115 112 101 99 116 111 114 46 105 99 111 1440 nil nil 754 1 786 #debugIt 18 9 68 101 98 38 117 103 32 73 116 1 1 1346 nil true 1392 18 12 68 101 98 117 103 103 101 114 46 105 99 111 1440 nil nil 834 4097 754 1 786 #inspectWorkspacePool 18 10 86 97 114 105 97 98 38 108 101 115 1 1 nil nil nil 754 1 786 #cloneNew 18 6 67 108 111 38 110 101 1 1 nil nil nil 834 4097 706 nil true 34 2 754 2097153 786 #browseDefinitions 18 15 68 101 102 105 38 110 105 116 105 111 110 115 46 46 46 1 1 nil nil nil 754 1 786 #browseReferences 18 14 38 82 101 102 101 114 101 110 99 101 115 46 46 46 1 1 nil nil nil 18 7 38 66 114 111 119 115 101 nil 1 nil nil nil nil nil 18 10 38 87 111 114 107 115 112 97 99 101 nil 134217729 nil nil nil nil nil nil nil 560 nil 505641849 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 2082 77 786694 ##(Smalltalk.IndexedColor) 33554457 2130 33554471 1 nil nil nil nil #callTip nil nil nil 170 192 34 2 1 2096 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 560 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 8 #() nil 170 176 2320 9215 nil nil nil nil 2130 33554447 nil nil 65 nil nil nil 18 0 3 170 192 34 2 #container 2048 nil nil nil nil 1 nil 170 192 34 4 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 560 33554465 3 false #Warning nil nil nil nil nil nil #Error 2450 19 560 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 2082 1029 nil 196934 1 ##(Smalltalk.RGB) 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 2082 1027 2546 60239 2546 31326207 1 nil nil nil nil #Warning nil nil nil #Error 2082 1031 2546 335 2546 31317503 1 nil nil nil nil #Error nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 8 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 2786 701 501 560 2738 #contextMenu: 34 1 720 560 2738 #modificationEventMask: 8 #(4607) 560 2738 #caretPeriod: 8 #(530) 560 2738 #wordWrap: 8 #(true) 560 2738 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 560 1 3 nil nil nil nil 3010 3 560 1 nil nil 67108863 nil nil 3010 5 560 1 nil nil nil nil nil 560 2738 #maxCompletionListHeight: 8 #(9) 560 2738 #sciSetCodePage: 8 #(65001) 560 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 2786 193 193 nil 29 170 192 34 2 560 18 4 116 101 120 116 nil 2674 138 144 34 1 2738 #createAt:extent: 34 2 2786 3839 21 2786 701 501 416 3138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 34 1 560 3200 nil 27 )!

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

