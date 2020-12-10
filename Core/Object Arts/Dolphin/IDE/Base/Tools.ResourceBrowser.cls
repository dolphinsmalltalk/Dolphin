"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkToolShell subclass: #'Tools.ResourceBrowser'
	instanceVariableNames: 'resourceToolboxPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ResourceBrowser guid: (Core.GUID fromString: '{87b4c6c2-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.ResourceBrowser comment: 'ResourceBrowser is a <SmalltalkToolShell> that implements the Resource Browser tool. This provides an interface onto all the <Resource>s held by the current <ResourceManager>.

Instance Variables:
	resourceListPresenter		<ResourceListPresenter> displaying the current list of resources.
	resourceTree			<UndefinedObject> not used.
	packagesPresenter			<ListPresenter> displaying a list of all the current packages.
'!
!Tools.ResourceBrowser categoriesForClass!MVP-Presenters! !
!Tools.ResourceBrowser methodsFor!

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
!Tools.ResourceBrowser categoriesFor: #canSaveState!private!saved state! !
!Tools.ResourceBrowser categoriesFor: #createComponents!**auto generated**!initializing!private! !
!Tools.ResourceBrowser categoriesFor: #defaultHelpId!public! !
!Tools.ResourceBrowser categoriesFor: #newView!commands!public! !
!Tools.ResourceBrowser categoriesFor: #onViewOpened!event handling!private! !
!Tools.ResourceBrowser categoriesFor: #resource!accessing!public! !
!Tools.ResourceBrowser categoriesFor: #resource:!accessing!public! !
!Tools.ResourceBrowser categoriesFor: #resourceToolboxPresenter!private! !
!Tools.ResourceBrowser categoriesFor: #saveStateOn:!private!saved state! !
!Tools.ResourceBrowser categoriesFor: #selectCategory:!public! !
!Tools.ResourceBrowser categoriesFor: #setInitialFocus!operations!public! !
!Tools.ResourceBrowser categoriesFor: #shortCaption!accessing!public! !
!Tools.ResourceBrowser categoriesFor: #showResourcesReferencingView:!public! !

!Tools.ResourceBrowser class methodsFor!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 5 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 528 917510 ##(Graphics.Color) #default 8 1801306032 170 192 34 10 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 784 nil nil nil 7 nil nil nil 784 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Toolbar) #resource_Image_tools nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 674 1 1 674 63 51 784 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'imageTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1120 nil nil nil 7 nil nil nil 1120 850 ##(UI.Toolbar) #resource_Smalltalk_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 63 1 674 553 51 1120 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 1072 1088 nil 27 8 'smalltalkTools' 410 ##(UI.Toolbar) 34 25 nil 528 34 2 8 1140853612 131137 1360 nil nil nil 519 nil nil nil 1360 720 8 1801306032 170 192 1072 170 192 34 2 47871 1311814 1 ##(UI.ToolbarIconButton) 1360 17 1377606 4 ##(UI.CommandDescription) #viewModeSelect 8 'Views' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'ViewMode.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 47871 34 1 1504 nil nil 1 nil nil nil nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1159 1 674 77 51 1360 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 67 2 0 0 0 0 0 0 105 2 0 0 25 0 0 0] 8 #() 1088 nil 27 8 'viewTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1888 nil nil nil 7 nil nil nil 1888 850 ##(UI.Toolbar) #resource_Search_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 615 1 674 437 51 1888 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 1072 1088 nil 27 8 'searchTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 2128 nil nil nil 7 nil nil nil 2128 850 ##(UI.Toolbar) #resource_Resource_tools nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1051 1 674 109 51 2128 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 67 2 0 0 25 0 0 0] 1072 1088 nil 27 8 'resourceTools' 170 192 1072 8 #() nil nil 1 nil 674 33 33 nil nil 852806 1 ##(UI.FlowLayout) 1 1 1 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 1 674 1399 51 528 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 187 2 0 0 25 0 0 0] 34 5 784 1120 1888 2128 1360 1088 nil 27 nil nil nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2608 nil nil nil 15 nil nil nil 2608 850 ##(Tools.ResourceToolboxPresenter) #resource_Default_view nil 882 138 144 34 1 946 #createAt:extent: 34 2 674 1 51 674 1399 1053 2608 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 187 2 0 0 39 2 0 0] 1072 1088 nil 27 170 192 34 4 2608 8 'resourceToolbox' 528 8 'toolbar' nil 658246 4 ##(UI.MenuBar) nil true 34 4 461638 4 ##(UI.Menu) nil true 34 9 1180742 2 ##(UI.CommandMenuItem) 1 1522 #browseHierarchy 8 '&Browse <1s>' 1 1 1570 nil true 1616 8 'ClassBrowserShell.ico' 1664 nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 2994 1 1522 #newView 8 '&New' 1 1 nil nil nil 2994 1 1522 #deleteResource 8 '&Delete...' 1 1 1570 nil true 1616 8 'EditClear.ico' 1664 nil nil 3090 4097 2994 1 1522 #editResource 8 '&Open' 9349 1 1570 nil true 1616 8 'ViewComposer.ico' 1664 nil nil 3090 4097 2994 1 1522 #resourcePackage 8 '&Package...' 1 1 1570 nil true 1616 8 'Package.ico' 1664 nil nil 2994 1 1522 #categorizeResource 8 'Category...' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil 47885 nil nil 2946 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 47887 nil nil 2946 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 47889 nil nil 2946 nil true 34 15 2994 1 1522 #helpContents 8 '&Contents' 1025 1 1570 nil true 1616 8 'Help.ico' 1664 nil nil 2994 1 1522 #help 8 'On this &Tool' 1249 1 nil nil nil 2994 1 1522 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3090 4097 2994 1 1522 #learnSmalltalk 8 'Learn Smalltalk' 1 1 1378630 1 ##(Graphics.TextTileIcon) $\x1F393 nil 706 #orchid 706 #white nil nil 1 nil nil nil nil 3090 4097 2994 1 1522 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2994 1 1522 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2994 1 1522 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3090 4097 2994 1 1522 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 1570 nil true 1616 8 '!!APPLICATION' 1664 nil nil 2994 1 1522 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2994 1 1522 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3090 4097 2994 1 1522 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3874 $\x1F42C nil nil 706 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 47913 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 674 19999 19999 674 1431 1221 416 946 #text: 34 1 8 'View Browser' 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 39 0 0 15 39 0 0 218 41 0 0 113 41 0 0] 34 2 528 2608 1088 nil 27 )!

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
!Tools.ResourceBrowser class categoriesFor: #displayOn:!displaying!public! !
!Tools.ResourceBrowser class categoriesFor: #icon!constants!public! !
!Tools.ResourceBrowser class categoriesFor: #initialize!initializing!private! !
!Tools.ResourceBrowser class categoriesFor: #publishedAspects!public! !
!Tools.ResourceBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.ResourceBrowser class categoriesFor: #showAsToolboxFor:at:!instance creation!public! !
!Tools.ResourceBrowser class categoriesFor: #toolsFolderHelpId!public! !

