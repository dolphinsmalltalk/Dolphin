"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #UserPreferencesShell
	instanceVariableNames: 'preferencesPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UserPreferencesShell guid: (GUID fromString: '{952571b1-f954-4626-bf12-bdd570b30a14}')!
UserPreferencesShell comment: ''!
!UserPreferencesShell categoriesForClass!Development! !
!UserPreferencesShell methodsFor!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	preferencesPresenter := self add: TwinLevelInspector new name: 'preferences'!

model: aListModelOfObjects 
	super model: aListModelOfObjects.
	preferencesPresenter model: aListModelOfObjects!

selectionOrNil: aClass 
	^preferencesPresenter selectionOrNil: aClass! !
!UserPreferencesShell categoriesFor: #createComponents!private! !
!UserPreferencesShell categoriesFor: #model:!public! !
!UserPreferencesShell categoriesFor: #selectionOrNil:!public! !

!UserPreferencesShell class methodsFor!

defaultModel
	^ListModel on: SmalltalkSystem current systemOptions !

displayOn: aStream 
	aStream nextPutAll: 'User Preferences'!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon fromId: 'SMALLTALKOPTIONSFOLDER.ICO'!

initialize
	"Private - Register the receiver with SmalltalkSystem.

		self initialize.
	"

	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self reuseIfOpen: true.
	self canUseIdeaSpace: true.
	!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	aspects add: (Aspect boolean: #reuseIfOpen).
	aspects add: (Aspect boolean: #canUseIdeaSpace).
	^aspects!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 26738689 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 0 39 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 544 0 0 0 7 0 0 0 544 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 0 32 234 256 672 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  21 21 834 1409 815 544 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 202 2 0 0 161 1 0 0] 98 3 410 560 98 15 0 544 98 2 8 1140850688 131073 944 0 0 0 7 0 0 0 944 514 1 1 410 8 ##(Smalltalk.StaticText)  98 16 0 944 98 2 8 1140850945 1 1024 0 786694 ##(Smalltalk.IndexedColor)  33554447 0 7 0 0 0 1024 0 8 4294902799 852486 ##(Smalltalk.NullConverter)  0 0 0 706 202 208 98 2 770 800 98 2 834 1 1 834 699 39 1024 770 8 #text: 98 1 8 'System Options
' 1024 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 19 0 0 0] 98 0 834 193 193 0 27 0 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 944 98 2 8 1409372236 1 1424 590662 2 ##(Smalltalk.ListModel)  202 208 672 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  0 0 7 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 78 97 114 114 111 119 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 834 193 193 0 1424 0 8 4294905539 459270 ##(Smalltalk.Message)  8 #displayString 98 0 8 ##(Smalltalk.IconicListAbstract)  1049926 1 ##(Smalltalk.IconImageManager)  0 0 0 834 129 129 787526 1 ##(Smalltalk.ImageManager)  234 240 672 234 240 672 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 'Column 1' 201 8 #left 1698 1728 1744 8 ##(Smalltalk.SortedCollection)  0 0 1424 0 1 0 0 8 #thumbnails 672 834 193 193 131169 834 65 65 0 706 202 208 98 2 770 800 98 2 834 1 39 834 699 777 1424 770 1312 98 1 8 'Column 1' 1424 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 93 1 0 0 151 1 0 0] 98 0 1408 0 27 234 256 98 2 1424 8 'contents' 0 706 202 208 98 1 770 800 98 2 834 1 1 834 699 815 944 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 151 1 0 0] 98 2 1024 1424 1408 0 27 410 8 ##(Smalltalk.Splitter)  98 12 0 544 98 2 8 1140850688 1 2528 0 1890 8 4278190080 0 519 0 0 0 2528 706 202 208 98 1 770 800 98 2 834 699 1 834 11 815 2528 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 93 1 0 0 0 0 0 0 98 1 0 0 151 1 0 0] 98 0 1408 0 27 410 560 98 15 0 544 98 2 8 1140850688 131073 2800 0 0 0 7 0 0 0 2800 514 1 1 410 1040 98 16 0 2800 98 2 8 1140850945 1 2880 0 1120 0 7 0 0 0 2880 0 8 4294902799 1154 0 0 0 706 202 208 98 2 770 800 98 2 834 1 1 834 701 39 2880 770 1312 98 1 8 'Properties' 2880 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 19 0 0 0] 98 0 1408 0 27 0 0 0 410 8 ##(Smalltalk.ReferenceView)  98 14 0 2800 98 2 8 1140850688 131073 3184 0 1890 8 4278190080 0 7 0 0 0 3184 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.PropertyInspector)  8 #resource_Default_view 0 706 202 208 98 1 770 800 98 2 834 1 39 834 701 777 3184 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 94 1 0 0 151 1 0 0] 672 1408 0 27 234 256 98 2 3184 8 'inspector' 0 706 202 208 98 1 770 800 98 2 834 709 1 834 701 815 2800 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 1 0 0 0 0 0 0 192 2 0 0 151 1 0 0] 98 2 2880 3184 1408 0 27 1408 0 27 234 256 98 2 544 8 'preferences' 590342 ##(Smalltalk.Rectangle)  834 21 21 834 21 21 0 0 0 0 1 0 0 0 0 1 0 0 706 202 208 98 3 770 800 98 2 834 3359 21 834 1481 931 416 770 1312 98 1 8 'User Preferences' 416 770 8 #updateMenuBar 672 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 115 9 0 0 219 1 0 0] 98 1 544 1408 0 27 )!

toolsFolderHelpId
	^10580!

uninitialize
	"Private - Uninitialize the receiver prior to remove from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self! !
!UserPreferencesShell class categoriesFor: #defaultModel!public! !
!UserPreferencesShell class categoriesFor: #displayOn:!public! !
!UserPreferencesShell class categoriesFor: #icon!constants!public! !
!UserPreferencesShell class categoriesFor: #initialize!initializing!private! !
!UserPreferencesShell class categoriesFor: #publishedAspects!development!public! !
!UserPreferencesShell class categoriesFor: #resource_Default_view!public!resources-views! !
!UserPreferencesShell class categoriesFor: #toolsFolderHelpId!private! !
!UserPreferencesShell class categoriesFor: #uninitialize!class hierarchy-removing!private! !

