"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #ResourceBrowser
	instanceVariableNames: 'resourceToolboxPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ResourceBrowser guid: (GUID fromString: '{87b4c6c2-026e-11d3-9fd7-00a0cc3e4a32}')!
ResourceBrowser comment: 'ResourceBrowser is a <SmalltalkToolShell> that implements the Resource Browser tool. This provides an interface onto all the <Resource>s held by the current <ResourceManager>.

Instance Variables:
	resourceListPresenter		<ResourceListPresenter> displaying the current list of resources.
	resourceTree			<UndefinedObject> not used.
	packagesPresenter			<ListPresenter> displaying a list of all the current packages.
'!
!ResourceBrowser categoriesForClass!Development!MVP-Presenters! !
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

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'View Browser'
!

icon
	"Answers an Icon that can be used to represent this class"

	^ResourceIdentifier icon!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786950 ##(Smalltalk.DefaultColor) #toolBackground nil 39 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 528 524550 ##(Smalltalk.ColorRef) 8 4278190080 8 1912794480 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 800 nil nil nil 7 nil nil nil 800 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Image_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 1 1 674 63 51 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1136 nil nil nil 7 nil nil nil 1136 866 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 63 1 674 599 51 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 74 1 0 0 25 0 0 0] 1088 1104 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1376 nil nil nil 7 nil nil nil 1376 866 ##(Smalltalk.Toolbar) #resource_Resource_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1093 1 674 109 51 1376 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 34 2 0 0 0 0 0 0 88 2 0 0 25 0 0 0] 1088 1104 nil 27 8 'resourceTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1616 nil nil nil 7 nil nil nil 1616 866 ##(Smalltalk.Toolbar) #resource_Search_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 661 1 674 433 51 1616 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 1 0 0 0 0 0 0 34 2 0 0 25 0 0 0] 1088 1104 nil 27 8 'searchTools' 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1140853612 131137 1856 nil nil nil 519 nil nil nil 1856 706 736 8 1912794480 170 192 1088 170 192 34 2 51777 1246790 1 ##(Smalltalk.ToolbarBitmapButton) 1856 17 1180998 4 ##(Smalltalk.CommandDescription) #viewModeSelect 8 'Views' 1 1 nil 51777 395334 3 ##(Smalltalk.Bitmap) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ViewBar.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil 7 674 129 33 3 34 1 2016 170 176 34 2 2096 1 nil 1 nil 674 33 33 674 45 45 nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 674 1201 1 674 77 51 1856 962 #updateSizePosted 1088 1856 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 88 2 0 0 0 0 0 0 126 2 0 0 25 0 0 0] 8 #() 1104 nil 27 8 'viewTools' 170 192 1088 8 #() 170 176 1088 nil 1 nil 674 33 33 674 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 898 138 144 34 2 962 #createAt:extent: 34 2 674 1 1 674 1339 51 528 962 #updateSizePosted 1088 528 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 157 2 0 0 25 0 0 0] 34 5 800 1136 1616 1376 1856 1104 nil 27 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2784 nil nil nil 15 nil nil nil 2784 866 ##(Smalltalk.ResourceToolboxPresenter) #resource_Default_view nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 51 674 1339 1053 2784 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 157 2 0 0 39 2 0 0] 1088 1104 nil 27 170 192 34 4 528 8 'toolbar' 2784 8 'resourceToolbox' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 265030 4 ##(Smalltalk.Menu) nil true 34 9 984134 2 ##(Smalltalk.CommandMenuItem) 1 2034 #browseHierarchy 8 '&Browse <1s>' 1 1 263494 3 ##(Smalltalk.Icon) nil true 2128 8 'ClassBrowserShell.ico' 2176 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3170 1 2034 #newView 8 '&New' 1 1 nil nil nil 3170 1 2034 #deleteResource 8 '&Delete...' 1 1 nil nil nil 3282 4097 3170 1 2034 #editResource 8 '&Open' 9349 1 nil nil nil 3282 4097 3170 1 2034 #resourcePackage 8 '&Package...' 1 1 nil nil nil 3170 1 2034 #categorizeResource 8 'Category...' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil 51715 nil nil 3122 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 51717 nil nil 3122 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 51719 nil nil 3122 nil true 34 15 3170 1 2034 #helpContents 8 '&Contents' 1025 1 3234 nil true 2128 49 786694 ##(Smalltalk.ShellLibrary) nil nil 3170 1 2034 #help 8 'On this &Tool' 1249 1 nil nil nil 3170 1 2034 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3282 4097 3170 1 2034 #learnSmalltalk 8 'Learn Smalltalk' 1 1 nil nil nil 3282 4097 3170 1 2034 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3170 1 2034 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3170 1 2034 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3282 4097 3170 1 2034 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 nil nil nil 3170 1 2034 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3170 1 2034 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3282 4097 3170 1 2034 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3234 nil true 2128 8 '!!APPLICATION' 2176 nil nil 8 '&Help' nil 134217729 nil nil 51743 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 674 3839 21 674 1371 1221 416 962 #text: 34 1 8 'View Browser' 416 962 #updateMenuBar 1088 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 44 10 0 0 108 2 0 0] 34 2 528 2784 1104 nil 27 )!

showAsToolboxFor: aView at: aPoint
	"Creates an instance of the receiver in a toolbox view attached to aView
	and displayed at aPoint relative to the origin of this view"

	| toolbox toolboxView position |
	toolboxView := (self loadViewResource: 'Toolbox' inContext: View desktop) bePopupFor: aView.
	position := aView mapPoint: aPoint to: View desktop.
	toolboxView position: position.

	toolbox := self new.
	toolbox view: toolboxView.

	^toolbox show!

toolsFolderHelpId
	^10594!

uninitialize
	"Private - Un-register the system tools folder icon for the receiver to allow clean
	removal of this class from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self! !
!ResourceBrowser class categoriesFor: #displayOn:!displaying!public! !
!ResourceBrowser class categoriesFor: #icon!constants!public! !
!ResourceBrowser class categoriesFor: #initialize!initializing!private! !
!ResourceBrowser class categoriesFor: #publishedAspects!development!public! !
!ResourceBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!ResourceBrowser class categoriesFor: #showAsToolboxFor:at:!instance creation!public! !
!ResourceBrowser class categoriesFor: #toolsFolderHelpId!public! !
!ResourceBrowser class categoriesFor: #uninitialize!class hierarchy-removing!private! !

