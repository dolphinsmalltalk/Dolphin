"Filed out from Dolphin Smalltalk 7"!

ClassAspectPlugin subclass: #ClassCommentPlugin
	instanceVariableNames: ''
	classVariableNames: 'TextStyles WordWrap'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassCommentPlugin guid: (GUID fromString: '{9BBB729C-F516-492E-B991-7AD0C238A37F}')!
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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ContainerView) 98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 0 0 0 410 8 ##(Smalltalk.ScintillaView) 98 50 0 416 98 2 8 1176572228 262145 576 721990 2 ##(Smalltalk.ValueHolder) 0 32 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 498 528 0 5 265030 4 ##(Smalltalk.Menu) 0 16 98 15 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #accept 8 '&Accept' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 738 0 16 98 8 786 1 818 8 #undo 8 '&Undo' 1 1 0 0 0 882 4097 786 1 818 8 #cutSelection 8 'Cu&t' 1 1 0 0 0 786 1 818 8 #copySelection 8 '&Copy' 1 1 0 0 0 786 1 818 8 #pasteClipboard 8 '&Paste' 1 1 0 0 0 786 1 818 8 #clearSelection 8 'De&lete' 1 1 0 0 0 882 4097 786 1 818 8 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 1 0 0 0 0 0 786 1 818 8 #clear 8 'Clea&r' 1 1 0 0 0 882 4097 786 1 818 8 #browseIt 8 'Bro&wse It' 1 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ClassBrowserShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 786 1 818 8 #displayIt 8 '&Display It' 1 1 0 0 0 786 1 818 8 #evaluateIt 8 'E&valuate It' 1 1 0 0 0 786 1 818 8 #inspectIt 8 '&Inspect It' 1 1 1522 0 16 1568 8 'BasicInspector.ico' 1616 0 0 786 1 818 8 #debugIt 8 'Deb&ug It' 1 1 1522 0 16 1568 8 'Debugger.ico' 1616 0 0 882 4097 786 1 818 8 #inspectWorkspacePool 8 'Variab&les' 1 1 0 0 0 786 1 818 8 #cloneNew 8 'Clo&ne' 1 1 0 0 0 882 4097 738 0 16 98 2 786 2097153 818 8 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 786 1 818 8 #browseReferences 8 '&References...' 1 1 0 0 0 8 '&Browse' 0 1 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 576 0 8 4294913043 852486 ##(Smalltalk.NullConverter) 0 0 9 0 234 256 98 4 8 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 2450 33554471 1 0 0 0 0 2400 0 0 0 8 #normal 2418 1 0 0 1 0 0 0 0 2496 0 0 0 234 256 98 2 1 2512 1245510 1 ##(Smalltalk.NullScintillaStyler) 2496 234 256 98 2 8 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 576 8 #circle 0 0 0 0 0 0 202 208 98 0 0 63 9215 0 0 0 0 2450 33554447 0 0 65 0 0 0 8 '' 3 234 256 98 2 8 #container 2368 0 0 0 0 1 0 234 256 98 4 8 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 576 33554465 3 32 2832 0 0 0 0 0 0 8 #Error 2850 19 576 33554459 3 32 2880 0 0 0 0 0 0 0 0 234 256 98 6 8 #Notification 2418 1029 0 196934 1 ##(Smalltalk.RGB) 31185883 1 0 0 0 0 2944 0 0 0 2880 2418 1031 2978 335 2978 31317503 1 0 0 0 0 2880 0 0 0 2832 2418 1027 2978 60239 2978 31326207 1 0 0 0 0 2832 0 0 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 11 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 1 1 3234 701 501 576 3170 8 #contextMenu: 98 1 752 576 3170 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval) 3 1 3 576 3170 8 #isTextModified: 98 1 32 576 3170 8 #modificationEventMask: 98 1 9215 576 3170 8 #secondaryCaretForecolor: 98 1 2978 16711423 576 3170 8 #caretPeriod: 98 1 1061 576 3170 8 #wordWrap: 98 1 16 576 3170 8 #margins: 98 1 98 3 984902 1 ##(Smalltalk.ScintillaMargin) 1 576 1 3 32 1 15 3730 3 576 1 1 32 67108863 15 3730 5 576 1 1 32 1 15 576 3170 8 #tabIndents: 98 1 16 576 3170 8 #areAdditionalCaretsVisible: 98 1 16 576 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 98 0 3234 193 193 0 29 234 256 98 2 576 8 'text' 0 3106 202 208 98 1 3170 3200 98 2 3234 3839 21 3234 701 501 416 3890 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 98 1 576 3952 0 27 )!

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

