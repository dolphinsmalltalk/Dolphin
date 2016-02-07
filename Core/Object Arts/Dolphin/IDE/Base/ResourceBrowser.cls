"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #ResourceBrowser
	instanceVariableNames: 'resourceToolboxPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ResourceBrowser guid: (GUID fromString: '{87B4C6C2-026E-11D3-9FD7-00A0CC3E4A32}')!
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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 39 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851532 131137 560 0 482 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 0 560 482 656 8 4294902647 234 256 98 8 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 848 0 0 0 7 0 0 0 848 1180166 ##(Smalltalk.ResourceIdentifier) 576 8 #resource_Resource_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 754 1053 1 754 109 51 848 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 2 0 0 0 0 0 0 68 2 0 0 25 0 0 0] 98 0 754 193 193 0 27 8 'resourceTools' 410 864 98 14 0 560 98 2 8 1140850688 131073 1232 0 0 0 7 0 0 0 1232 930 576 8 #resource_Image_tools 0 978 202 208 98 1 1042 1072 98 2 754 1 1 754 63 51 1232 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1184 1200 0 27 8 'imageTools' 410 576 98 25 0 560 98 2 8 1140853612 131137 1488 0 482 656 0 519 0 0 0 1488 482 656 8 4294902647 234 256 1184 234 256 98 2 18071 853766 ##(Smalltalk.ToolbarButton) 18071 0 1488 17 1180998 4 ##(Smalltalk.CommandDescription) 8 #viewModeSelect 8 'Views' 1 1 0 395334 3 ##(Smalltalk.Bitmap) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ViewBar.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 7 754 129 33 3 98 1 1664 234 240 98 2 1760 1 0 1 0 754 33 33 754 45 45 0 0 978 202 208 98 2 1042 1072 98 2 754 1 51 754 77 51 1488 1042 8 #updateSizePosted 1184 1488 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 38 0 0 0 50 0 0 0] 98 0 1200 0 27 8 'viewTools' 410 864 98 14 0 560 98 2 8 1140850688 131073 2176 0 0 0 7 0 0 0 2176 930 576 8 #resource_Smalltalk_tools 0 978 202 208 98 1 1042 1072 98 2 754 63 1 754 991 51 2176 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1184 1200 0 27 8 'smalltalkTools' 234 256 1184 98 0 234 240 1184 0 1 0 754 33 33 754 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 978 202 208 98 2 1042 1072 98 2 754 1 1 754 1199 101 560 1042 2096 1184 560 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 87 2 0 0 50 0 0 0] 98 4 1232 2176 848 1488 1200 0 27 0 0 0 410 864 98 14 0 416 98 2 8 1140850688 131073 2720 0 482 8 4278190080 0 15 0 0 0 2720 930 8 ##(Smalltalk.ResourceToolboxPresenter) 8 #resource_Default_view 0 978 202 208 98 1 1042 1072 98 2 754 1 101 754 1199 953 2720 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 87 2 0 0 14 2 0 0] 1184 1200 0 27 234 256 98 4 560 8 'toolbar' 2720 8 'resourceToolbox' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 4 265030 4 ##(Smalltalk.Menu) 0 16 98 9 984134 2 ##(Smalltalk.CommandMenuItem) 1 1682 8 #browseHierarchy 8 '&Browse <1s>' 1 1 263494 3 ##(Smalltalk.Icon) 0 16 1792 8 'ClassBrowserShell.ico' 1840 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3170 1 1682 8 #newView 8 '&New' 1 1 0 0 0 3170 1 1682 8 #deleteResource 8 '&Delete...' 1 1 0 0 0 3298 4097 3170 1 1682 8 #editResource 8 '&Open' 9349 1 0 0 0 3298 4097 3170 1 1682 8 #resourcePackage 8 '&Package...' 1 1 0 0 0 3170 1 1682 8 #categorizeResource 8 'Category...' 1 1 0 0 0 8 '&View' 0 134217729 0 0 18141 0 0 3122 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 18143 0 0 3122 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 18145 0 0 3122 0 16 98 16 3170 1 1682 8 #helpContents 8 '&Contents' 1025 1 3250 0 16 1792 49 786694 ##(Smalltalk.ShellLibrary) 0 0 3170 1 1682 8 #help 8 'On this &Tool' 1249 1 0 0 0 3170 1 1682 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 3298 4097 3170 1 1682 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 3298 4097 3170 1 1682 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3170 1 1682 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3170 1 1682 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 3122 0 16 98 4 3170 2097153 1682 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 3250 0 16 1792 8 'TipOfTheDay.ico' 1840 0 0 3170 1 1682 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 3250 0 16 1792 8 'TipOfTheDay.ico' 1840 0 0 3298 4097 3170 1 1682 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 18167 0 0 3298 4097 3170 1 1682 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3170 1 1682 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3170 1 1682 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 3298 4097 3170 1 1682 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3250 0 16 1792 8 '!!APPLICATION' 1840 0 0 8 '&Help' 0 134217729 0 0 18177 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 978 202 208 98 3 1042 1072 98 2 754 4999 21 754 1231 1171 416 1042 8 #text: 98 1 8 'View Browser' 416 1042 8 #updateMenuBar 1184 416 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 9 0 0 10 0 0 0 42 12 0 0 83 2 0 0] 98 2 560 2720 1200 0 27)!

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

