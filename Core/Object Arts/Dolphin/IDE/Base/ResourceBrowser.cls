"Filed out from Dolphin Smalltalk"!

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

!ResourceBrowser categoriesForMethods!
canSaveState!private!saved state! !
createComponents!**auto generated**!initializing!private! !
defaultHelpId!public! !
newView!commands!public! !
onViewOpened!event handling!private! !
resource!accessing!public! !
resource:!accessing!public! !
resourceToolboxPresenter!private! !
saveStateOn:!private!saved state! !
selectCategory:!public! !
setInitialFocus!operations!public! !
shortCaption!accessing!public! !
showResourcesReferencingView:!public! !
!

!ResourceBrowser class methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'View Browser'
!

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

previewDpiAwareness
	^ResourcePreview dpiAwareness!

previewDpiAwareness: aSymbol
	ResourcePreview dpiAwareness: aSymbol!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: (Aspect boolean: #canUseIdeaSpace);
		add: (Aspect choice: #previewDpiAwareness from: {DpiAwareness gdiScaled. DpiAwareness system. DpiAwareness unaware});
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 5 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 528 327686 ##(Smalltalk.Color) #default 8 1795812352 170 192 34 10 410 ##(Smalltalk.Toolbar) 34 28 nil 528 34 2 8 1140853612 131137 752 nil nil nil 519 nil nil nil 752 688 8 1795812352 170 192 8 #() nil nil nil 170 192 34 2 12743 1115718 2 ##(Smalltalk.ToolbarIconButton) 752 17 1180998 4 ##(Smalltalk.CommandDescription) #viewModeSelect 8 'Views' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ViewMode.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 12743 nil nil 34 1 912 nil nil 9 1 nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[65 2 0 0 0 0 0 0 103 2 0 0 25 0 0 0] 193 784 8 '' 752 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 31 8 'viewTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1392 nil nil nil 7 nil nil nil 1392 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Image_tools nil 1122 138 144 34 1 1186 #createWindow: 34 1 1234 1266 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 1424 8 '' 1392 3 848 1346 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1664 nil nil nil 7 nil nil nil 1664 1458 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 1122 138 144 34 1 1186 #createWindow: 34 1 1234 1266 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 1696 8 '' 1664 3 848 1346 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1920 nil nil nil 7 nil nil nil 1920 1458 ##(Smalltalk.Toolbar) #resource_Resource_tools nil 1122 138 144 34 1 1186 #createWindow: 34 1 1234 1266 8 #[11 2 0 0 0 0 0 0 65 2 0 0 25 0 0 0] 193 1952 8 '' 1920 3 848 1346 193 193 nil 27 8 'resourceTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 2176 nil nil nil 7 nil nil nil 2176 1458 ##(Smalltalk.Toolbar) #resource_Search_tools nil 1122 138 144 34 1 1186 #createWindow: 34 1 1234 1266 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 2208 8 '' 2176 3 848 1346 193 193 nil 27 8 'searchTools' nil nil nil 170 192 848 8 #() nil nil 9 1231 #smallIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1122 138 144 34 1 1186 #createWindow: 34 1 1234 1266 8 #[0 0 0 0 0 0 0 0 187 2 0 0 25 0 0 0] 193 560 8 '' 528 3 34 5 1392 1664 2176 1920 752 1346 193 193 nil 31 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2672 nil nil nil 15 nil nil nil 2672 1458 ##(Smalltalk.ResourceToolboxPresenter) #resource_Default_view nil 1122 138 144 34 1 1186 #createWindow: 34 1 1234 1266 8 #[0 0 0 0 25 0 0 0 187 2 0 0 39 2 0 0] 193 2704 8 '' 2672 3 848 1346 193 193 nil 27 170 192 34 4 528 8 'toolbar' 2672 8 'resourceToolbox' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 265030 4 ##(Smalltalk.Menu) nil true 34 9 984134 2 ##(Smalltalk.CommandMenuItem) 1 930 #browseHierarchy 8 '&Browse <1s>' 1 1 978 nil true 1024 8 'ClassBrowserShell.ico' 1072 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3074 1 930 #newView 8 '&New' 1 1 nil nil nil 3074 1 930 #deleteResource 8 '&Delete...' 1 1 978 nil true 1024 8 'EditClear.ico' 1072 nil nil 3170 4097 3074 1 930 #editResource 8 '&Open' 9349 1 978 nil true 1024 8 'ViewComposer.ico' 1072 nil nil 3170 4097 3074 1 930 #resourcePackage 8 '&Package...' 1 1 978 nil true 1024 8 'Package.ico' 1072 nil nil 3074 1 930 #categorizeResource 8 'Category...' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil 12757 nil nil 3026 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 12759 nil nil 3026 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 12761 nil nil 3026 nil true 34 15 3074 1 930 #helpContents 8 '&Contents' 1025 1 978 nil true 1024 8 'Help.ico' 1072 nil nil 3074 1 930 #help 8 'On this &Tool' 1249 1 nil nil nil 3074 1 930 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3170 4097 3074 1 930 #learnSmalltalk 8 'Learn Smalltalk' 1 1 788806 2 ##(Smalltalk.TextTileIcon) $🎓 nil 674 #orchid 674 #white nil nil 1 nil nil nil nil 3170 4097 3074 1 930 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3074 1 930 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3074 1 930 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3170 4097 3074 1 930 #dolphinHomePage 8 'Dolphin Homepage' 1 1 978 nil true 1024 8 '!!APPLICATION' 1072 nil nil 3074 1 930 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3074 1 930 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3170 4097 3074 1 930 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3954 $🐬 nil nil 674 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 12785 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 1122 138 144 34 1 1186 #createWindow: 34 1 1234 590342 ##(Smalltalk.Rectangle) 1346 6143 21 1346 7573 1241 193 448 8 'View Browser' 416 1 34 2 528 2672 1346 193 193 nil 27 )!

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

!ResourceBrowser class categoriesForMethods!
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
previewDpiAwareness!accessing!public! !
previewDpiAwareness:!accessing!public! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
showAsToolboxFor:at:!instance creation!public! !
toolsFolderHelpId!public! !
!

