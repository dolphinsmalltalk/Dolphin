"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #ResourceBrowser
	instanceVariableNames: 'resourceToolboxPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ResourceBrowser guid: (GUID fromString: '{87b4c6c2-026e-11d3-9fd7-00a0cc3e4a32}')!
ResourceBrowser comment: 'ResourceBrowser is a <SmalltalkToolShell> that implements the Resource Browser tool. This provides an interface onto all the <Resource>s held by the current <ResourceManager>.

Instance Variables:
	resourceListPresenter		<ResourceListPresenter> displaying the current list of resources.
	resourceTree			<UndefinedObject> not used.
	packagesPresenter			<ListPresenter> displaying a list of all the current packages.
'!
!ResourceBrowser categoriesForClass!MVP-Presenters! !
!ResourceBrowser methodsFor!

canSaveState
	"Private - Answer true if the receiver can successfully have it's state saved by #saveStateOn:. Some
	tools may not be able to save their state and therefore will not be able to be exported as
	part of a IdeaSpace save operation"

	^true!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	resourceToolboxPresenter := self add: ResourceToolboxPresenter new name: 'resourceToolbox'!

defaultHelpId
	^10847!

newView
	"Open the ViewComposer on an new default view resource for the
	selected class. If there are several possibilities allow the user to select
	the one to edit"

	| selection |
	(selection := self resource) notNil 
		ifTrue: [self model openViewComposerOnNewViewFor: selection owningClass]
		ifFalse: [self model openViewComposer]
 !

onViewOpened
	"Private - Received when the receiver's view is been connected. "

	super onViewOpened.

	"Enable view mode pulldown"
	(self view viewNamed: 'viewTools' ifNone: []) 
		ifNotNil: 
			[:toolbar | 
			toolbar presenterConnectionPoint 
				when: #dropDown:
				send: #onDropDown:
				to: resourceToolboxPresenter categoriesPresenter view]!

resource
	"Answer the selected resource identifier in the receiver or nil if there
	is none"

	^resourceToolboxPresenter selectionOrNil!

resource: aResourceIdentifierOrNil 
	resourceToolboxPresenter selectionOrNil: aResourceIdentifierOrNil!

resourceToolboxPresenter
	^resourceToolboxPresenter!

saveStateOn: aWriteStream 
	"Private - Write the source of a monadic block that will configure an instance of the receiver's class
	to match the state current receiver, to aWriteStream. The block expects a fresh instance of
	the receiver's class as it's parameter"

	aWriteStream nextPutAll: '[ :aResourceBrowser | '.
	self 
		saveStateAspects: #(#resource)
		for: 'aResourceBrowser'
		on: aWriteStream.
	aWriteStream
		nextPut: $.;
		cr.
	super saveStateOn: aWriteStream.
	aWriteStream nextPutAll: ' value: aResourceBrowser.'.
	aWriteStream nextPutAll: ']'!

selectCategory: aString 
	^resourceToolboxPresenter selectCategory: aString!

setInitialFocus
	resourceToolboxPresenter view tabFirst!

shortCaption
	^'Views'!

showResourcesReferencingView: aResourceIdentifier
	resourceToolboxPresenter showResourcesReferencingView: aResourceIdentifier.
	self caption: ('Views referencing <1p>' expandMacrosWith: aResourceIdentifier)! !
!ResourceBrowser categoriesFor: #canSaveState!private!saved state! !
!ResourceBrowser categoriesFor: #createComponents!**auto generated**!initializing!private! !
!ResourceBrowser categoriesFor: #defaultHelpId!public! !
!ResourceBrowser categoriesFor: #newView!commands!public! !
!ResourceBrowser categoriesFor: #onViewOpened!event handling!private! !
!ResourceBrowser categoriesFor: #resource!accessing!public! !
!ResourceBrowser categoriesFor: #resource:!accessing!public! !
!ResourceBrowser categoriesFor: #resourceToolboxPresenter!private! !
!ResourceBrowser categoriesFor: #saveStateOn:!private!saved state! !
!ResourceBrowser categoriesFor: #selectCategory:!public! !
!ResourceBrowser categoriesFor: #setInitialFocus!operations!public! !
!ResourceBrowser categoriesFor: #shortCaption!accessing!public! !
!ResourceBrowser categoriesFor: #showResourcesReferencingView:!public! !

!ResourceBrowser class methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'View Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Register the receiver with SmalltalkSystem.
		self initialize
	"

	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self reuseIfOpen: true.
	self canUseIdeaSpace: true!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: (Aspect boolean: #canUseIdeaSpace);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 5 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 528 327686 ##(Smalltalk.Color) #default 8 1877912960 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 784 nil nil nil 7 nil nil nil 784 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 63 1 674 553 51 784 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1120 nil nil nil 7 nil nil nil 1120 850 ##(Smalltalk.Toolbar) #resource_Resource_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1051 1 674 109 51 1120 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 67 2 0 0 25 0 0 0] 1072 1088 nil 27 8 'resourceTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1360 nil nil nil 7 nil nil nil 1360 850 ##(Smalltalk.Toolbar) #resource_Search_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 615 1 674 437 51 1360 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 1072 1088 nil 27 8 'searchTools' 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1140853612 131137 1600 nil nil nil 519 nil nil nil 1600 720 8 1877912960 170 192 1072 170 192 34 2 57885 1115206 1 ##(Smalltalk.ToolbarIconButton) 1600 17 1180998 4 ##(Smalltalk.CommandDescription) #viewModeSelect 8 'Views' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ViewMode.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 57885 34 1 1744 nil nil 1 nil nil nil nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1159 1 674 77 51 1600 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 67 2 0 0 0 0 0 0 105 2 0 0 25 0 0 0] 8 #() 1088 nil 27 8 'viewTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 2128 nil nil nil 7 nil nil nil 2128 850 ##(Smalltalk.Toolbar) #resource_Image_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 63 51 2128 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1072 1088 nil 27 8 'imageTools' 170 192 1072 8 #() nil nil 1 nil 674 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 1399 51 528 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 187 2 0 0 25 0 0 0] 34 5 2128 784 1360 1120 1600 1088 nil 27 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2608 nil nil nil 15 nil nil nil 2608 850 ##(Smalltalk.ResourceToolboxPresenter) #resource_Default_view nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 51 674 1399 1053 2608 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 187 2 0 0 39 2 0 0] 1072 1088 nil 27 170 192 34 4 528 8 'toolbar' 2608 8 'resourceToolbox' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 265030 4 ##(Smalltalk.Menu) nil true 34 9 984134 2 ##(Smalltalk.CommandMenuItem) 1 1762 #browseHierarchy 8 '&Browse <1s>' 1 1 1810 nil true 1856 8 'ClassBrowserShell.ico' 1904 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2994 1 1762 #newView 8 '&New' 1 1 nil nil nil 2994 1 1762 #deleteResource 8 '&Delete...' 1 1 1810 nil true 1856 8 'EditClear.ico' 1904 nil nil 3090 4097 2994 1 1762 #editResource 8 '&Open' 9349 1 1810 nil true 1856 8 'ViewComposer.ico' 1904 nil nil 3090 4097 2994 1 1762 #resourcePackage 8 '&Package...' 1 1 1810 nil true 1856 8 'Package.ico' 1904 nil nil 2994 1 1762 #categorizeResource 8 'Category...' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil 57899 nil nil 2946 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 57901 nil nil 2946 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 57903 nil nil 2946 nil true 34 15 2994 1 1762 #helpContents 8 '&Contents' 1025 1 1810 nil true 1856 8 'Help.ico' 1904 nil nil 2994 1 1762 #help 8 'On this &Tool' 1249 1 nil nil nil 2994 1 1762 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3090 4097 2994 1 1762 #learnSmalltalk 8 'Learn Smalltalk' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $\x1F393 nil 706 #orchid 706 #white nil nil 1 nil nil nil nil 3090 4097 2994 1 1762 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2994 1 1762 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2994 1 1762 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3090 4097 2994 1 1762 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 1810 nil true 1856 8 '!!APPLICATION' 1904 nil nil 2994 1 1762 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2994 1 1762 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3090 4097 2994 1 1762 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3874 $\x1F42C nil nil 706 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 6143 21 674 1431 1221 416 946 #text: 34 1 8 'View Browser' 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 202 14 0 0 108 2 0 0] 34 2 528 2608 1088 nil 27 )!

showAsToolboxFor: aView at: aPoint
	"Creates an instance of the receiver in a toolbox view attached to aView
	and displayed at aPoint relative to the origin of this view"

	| toolbox toolboxView position |
	toolboxView := (self loadViewResource: 'Toolbox' inContext: View desktop) bePopupFor: aView.
	position := aView mapPointToScreen: aPoint.
	toolboxView position: position.

	toolbox := self new.
	toolbox view: toolboxView.

	^toolbox show!

toolsFolderHelpId
	^10594! !
!ResourceBrowser class categoriesFor: #displayOn:!displaying!public! !
!ResourceBrowser class categoriesFor: #icon!constants!public! !
!ResourceBrowser class categoriesFor: #initialize!initializing!private! !
!ResourceBrowser class categoriesFor: #publishedAspects!public! !
!ResourceBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!ResourceBrowser class categoriesFor: #showAsToolboxFor:at:!instance creation!public! !
!ResourceBrowser class categoriesFor: #toolsFolderHelpId!public! !

