"Filed out from Dolphin Smalltalk"!

SmalltalkToolShell subclass: #FlipperInspector
	instanceVariableNames: 'cards'
	classVariableNames: 'Renderers'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FlipperInspector guid: (GUID fromString: '{8dc9ca40-c164-11d5-9849-0800460222f0}')!

FlipperInspector comment: ''!

!FlipperInspector categoriesForClass!MVP-Presenters! !

!FlipperInspector methodsFor!

addToCommandRoute: route
	"Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer self to have the command policy decide where
	to go next."

	route
		appendTarget: self systemModel;
		appendPresenter: cards view currentCard;
		appendPresenter: self!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	cards := self add: Presenter new name: 'cards'.
!

createRenderers
	"Private - Create the presenters used to render view of the receiver's model"

	| firstRendition |
	self class renderers do: 
			[:each | 
			| presenter |
			presenter := each createIn: cards on: self model.
			firstRendition isNil ifTrue: [firstRendition := presenter].
			presenter view arrangement: presenter ].
	firstRendition notNil ifTrue: [firstRendition ensureVisible]!

model: anObject
	"Set the model of the receiver to be a value model on anObject. Usually anObject is expected
	to be a ValueModel itself. If not, it is automatically wrapped in a valueHolder. 
	Register with it's #valueChanged event"

	| valueModel |
	valueModel := anObject asValue.
	super model: valueModel.
	valueModel when: #valueChanged send: #onValueChanged to: self!

object
	"Answer the object inspected by the receiver."

	^self model value!

object: anObject
	"Set the object which is inspected by the receiver."

	self value: anObject
!

onValueChanged
	"Private - The value held by the receiver's model has changed.
	The default is to trigger a #valueChanged event off the receiver"

	self trigger: #valueChanged.
	self updateCaption!

onViewOpened
	super onViewOpened.
	self createRenderers!

renderers
	"Answers the <OrderedCollection> of renderers held by the receiver"
	
	^cards subPresenters!

setInitialFocus
	cards view tabFirst!

setValue: anObject
	"Private - Set the model data of the receiver to be anObject but without propagating
	any change triggers"

	self model setValue: anObject.
!

shortCaption
	^'Inspector'!

updateCaption
	"The receiver has changed in such a way that the caption may need to be refreshed.
	Do this here"

	self caption: 'Inspecting ' , self value basicPrintString!

value
	"Answer the model value of the receiver. 
	Any view changes may first need to be flushed"

	self view notNil ifTrue: [ self view updateModel ].
	^self model value!

value: anObject
	"Set the model value of the receiver to be anObject"

	self model value: anObject.
! !

!FlipperInspector categoriesForMethods!
addToCommandRoute:!commands!public! !
createComponents!initializing!private! !
createRenderers!initializing!private! !
model:!accessing!public! !
object!accessing!public! !
object:!accessing!public! !
onValueChanged!event handling!private! !
onViewOpened!event handling!private! !
renderers!accessing!public! !
setInitialFocus!public! !
setValue:!accessing!private! !
shortCaption!accessing!public! !
updateCaption!public!updating! !
value!accessing!public! !
value:!accessing!public! !
!

!FlipperInspector class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^nil asValue
!

defaultRenderers
	"Private - Answers a <Array> of default  classes that will be used to render views onto an inspected object"

	^OrderedCollection 
		with: PublishedAspectInspector
		with: InstVarInspector
		with: VisualObjectFinder!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Visual Inspector'!

icon
	"Answers an Icon that can be used to represent this class"

	^BasicInspector icon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	(Smalltalk developmentSystem)
		registerTool: self;
		addSystemFolderIcon: self toolsFolderIcon.
	self renderers: self defaultRenderers.
	self canUseIdeaSpace: true!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		add: ((Aspect sequenceableCollection: #renderers)
					isNullable: false;
					yourself);
		add: (Aspect boolean: #canUseIdeaSpace);
		yourself!

renderers
	"Answer an <OrderedCollection> of classes that will be used to render views of an inspected object"

	^Renderers!

renderers: anOrderedCollection
	"Sets classes that will be used to render views of an inspected object to anOrderedCollection"

	Renderers := anOrderedCollection!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground 328198 ##(Smalltalk.Point) 1161 921 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1140853612 131073 560 nil nil nil 517 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 560 327686 ##(Smalltalk.Color) #default 8 1759112192 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 784 nil nil nil 5 nil nil nil 784 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Workspace_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[123 0 0 0 25 0 0 0 246 0 0 0 50 0 0 0] 193 816 8 '' 784 3 8 #() 498 193 193 nil 27 8 'workspaceTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1136 nil nil nil 5 nil nil nil 1136 850 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 1168 8 '' 1136 3 1088 498 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1392 nil nil nil 5 nil nil nil 1392 850 ##(Smalltalk.Toolbar) #resource_Search_tools nil 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 1424 8 '' 1392 3 1088 498 193 193 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1648 nil nil nil 5 nil nil nil 1648 850 ##(Smalltalk.Toolbar) #resource_Image_tools nil 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 1680 8 '' 1648 3 1088 498 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1904 nil nil nil 5 nil nil nil 1904 850 ##(Smalltalk.Toolbar) #resource_Edit_tools nil 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 193 1936 8 '' 1904 3 1088 498 193 193 nil 27 8 'editTools' nil nil nil 170 192 1088 138 144 1088 nil nil 9 1589 #smallIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[0 0 0 0 0 0 0 0 52 2 0 0 50 0 0 0] 193 592 8 '' 560 3 34 6 1648 1136 1392 1904 784 410 ##(Smalltalk.Toolbar) 34 28 nil 560 34 2 8 1140853580 131137 2384 nil nil nil 517 nil nil nil 2384 720 8 1759112192 170 192 1088 nil nil nil 170 192 34 2 12887 1115206 1 ##(Smalltalk.ToolbarIconButton) 2384 1 1180998 4 ##(Smalltalk.CommandDescription) #refresh 8 'Refresh' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Refresh.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 12887 34 1 2528 nil nil 9 nil #smallIcons nil nil 2194 1 1 1 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[246 0 0 0 25 0 0 0 15 1 0 0 50 0 0 0] 193 2416 8 '' 2384 3 8 #() 498 193 193 nil 31 498 193 193 nil 31 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2944 nil nil nil 5 nil nil nil 2944 530 1 1 nil nil nil nil 410 ##(Smalltalk.CardContainer) 34 16 nil 2944 34 2 8 1140850688 131073 3024 nil nil nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 2 3090 nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1025 2546 459270 ##(Smalltalk.Message) #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 3170 1025 2546 3218 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 3170 1025 2546 3218 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 3170 1025 2546 3218 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 3090 nil true 34 5 3170 1025 2546 3218 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 3170 1025 2546 3218 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 3170 1025 2546 3218 #viewMode: 8 #(#mediumIcons) 8 'Medium Icons' 1 1 nil nil nil 3170 1025 2546 3218 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 3170 1025 2546 3218 #viewMode: 8 #(#tileIcons) 8 'Tile Icons' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3024 656710 1 ##(Smalltalk.CardLayout) 138 144 1088 nil nil nil nil 170 192 1088 nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3024 34 2 8 1140916736 1 4064 590662 2 ##(Smalltalk.ListModel) 138 144 1088 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 1 nil nil nil 4064 nil 8 1758664336 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #smallIcons nil nil nil nil nil 882 138 144 34 2 946 #createWindow: 34 1 994 1026 8 #[0 0 0 0 0 0 0 0 52 2 0 0 95 1 0 0] 193 4096 8 '' 4064 946 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4064 3 8 #() 498 193 193 nil 27 882 138 144 34 2 946 #createWindow: 34 1 994 1026 8 #[0 0 0 0 0 0 0 0 52 2 0 0 95 1 0 0] 193 3056 8 '' 3024 946 #contextMenu: 34 1 3104 3024 3 34 1 4064 498 193 193 nil 27 170 192 34 2 3024 8 'cards' nil 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[0 0 0 0 50 0 0 0 52 2 0 0 145 1 0 0] 193 2976 8 '' 2944 3 34 1 3024 498 193 193 nil 27 170 192 34 2 560 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 3090 nil true 34 8 3170 1 2546 #fileNew 8 '&New Workspace' 9373 1 2594 nil true 2640 8 'NewWorkspace.ico' 2688 nil nil 3170 1 2546 #fileOpen 8 '&Open Workspace...' 9375 1 2594 nil true 2640 8 'OpenWorkspace.ico' 2688 nil nil 3170 1 2546 #fileFileIn 8 '&File In...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3170 1 2546 #saveImage 8 'Sa&ve Image' 1 1 2594 nil true 2640 8 'Snapshot.ico' 2688 nil nil 3170 1 2546 #smalltalkExit 8 'E&xit Dolphin' 1 1 2594 nil true 2640 8 'PowerSwitch.ico' 2688 nil nil 5234 4097 3170 1 2546 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 12901 nil nil 3090 nil true 34 12 3170 1 2546 #undo 8 '&Undo' 9397 1 2594 nil true 2640 8 'EditUndo.ico' 2688 nil nil 3170 1 2546 #redo 8 'R&edo' 9395 1 2594 nil true 2640 8 'EditRedo.ico' 2688 nil nil 5234 4097 3170 1 2546 #cutSelection 8 'Cu&t' 9393 1 2594 nil true 2640 8 'EditCut.ico' 2688 nil nil 3170 1 2546 #copySelection 8 '&Copy' 9351 1 2594 nil true 2640 8 'EditCopy.ico' 2688 nil nil 3170 1 2546 #pasteClipboard 8 '&Paste' 9389 1 2594 nil true 2640 8 'EditPaste.ico' 2688 nil nil 3170 1 2546 #clearSelection 8 '&Delete' 1 1 2594 nil true 2640 8 'EditClear.ico' 2688 nil nil 3170 1 2546 #selectAll 8 'Select &All' 9347 1 nil nil nil 5234 4097 3170 1 2546 #editFind 8 '&Find...' 9357 1 2594 nil true 2640 47 786694 ##(Smalltalk.ShellLibrary) nil nil 3170 1 2546 #findNext 8 'Find &Next' 1253 1 2594 nil true 2640 8 'FindNext.ico' 2688 nil nil 3170 1 2546 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 12923 nil nil 3090 nil true 34 14 3170 1 2546 #browseIt 8 '&Browse It' 9349 1 2594 nil true 2640 8 'ClassBrowserShell.ico' 2688 nil nil 3170 1 2546 #displayIt 8 '&Display It' 9353 1 2594 nil true 2640 8 'DisplayIt.ico' 2688 nil nil 3170 1 2546 #printIt 8 '&Print It' 9377 1 2594 nil true 2640 8 'PrintIt.ico' 2688 nil nil 3170 1 2546 #evaluateIt 8 '&Evaluate It' 9355 1 2594 nil true 2640 8 'EvaluateIt.ico' 2688 nil nil 3170 1 2546 #inspectIt 8 '&Inspect It' 9363 1 2594 nil true 2640 8 'BasicInspector.ico' 2688 nil nil 3170 1 2546 #debugIt 8 'Deb&ug It' 1269 1 2594 nil true 2640 8 'Debugger.ico' 2688 nil nil 3170 1 2546 #fileItIn 8 '&File It In' 1 1 nil nil nil 5234 4097 3170 1 2546 #accept 8 '&Accept' 9383 1 nil nil nil 5234 4097 3170 1 2546 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 3170 1 2546 #browseReferences 8 '&References...' 5367 1 nil nil nil 5234 4097 3090 nil true 34 9 3170 1 2546 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3170 1 2546 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3170 1 2546 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 3170 1 2546 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3170 1 2546 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3170 1 2546 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3170 1 2546 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 5234 4097 3090 nil true 34 2 3170 1 2546 3218 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 3170 1 2546 3218 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil 12963 nil nil 8 '&Options' nil 134217729 nil nil 12965 nil nil 8 '&Workspace' nil 134217729 nil nil 12967 nil nil 3090 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 12969 nil nil 3090 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 12971 nil nil 3090 nil true 34 15 3170 1 2546 #helpContents 8 '&Contents' 1025 1 2594 nil true 2640 8 'Help.ico' 2688 nil nil 3170 1 2546 #help 8 'On this &Tool' 1249 1 nil nil nil 3170 1 2546 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5234 4097 3170 1 2546 #learnSmalltalk 8 'Learn Smalltalk' 1 1 5490 $🎓 nil 706 #orchid 706 #white nil nil 1 nil nil nil nil 5234 4097 3170 1 2546 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3170 1 2546 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3170 1 2546 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5234 4097 3170 1 2546 #dolphinHomePage 8 'Dolphin Homepage' 1 1 2594 nil true 2640 8 '!!APPLICATION' 2688 nil nil 3170 1 2546 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3170 1 2546 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5234 4097 3170 1 2546 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5490 $🐬 nil nil 706 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 12995 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil 498 883 661 1 nil 193 882 138 144 34 1 946 #createWindow: 34 1 994 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1161 921 193 448 8 'Flipper Inspector' 416 1 34 2 560 2944 498 193 193 nil 27 )!

shellOn: anObject
	"Open an instance of the receiver displaying anObject. 
	Answer the new inspector."

	^(self show)
		value: anObject;
		yourself!

toolsFolderHelpId
	^10600! !

!FlipperInspector class categoriesForMethods!
defaultModel!models!public! !
defaultRenderers!constants!private! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!public! !
renderers!accessing!public! !
renderers:!accessing!public! !
resource_Default_view!public!resources-views! !
shellOn:!instance creation!public! !
toolsFolderHelpId!public! !
!

