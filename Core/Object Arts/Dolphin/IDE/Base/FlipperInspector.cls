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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground 328198 ##(Smalltalk.Point) 1161 921 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853612 131073 560 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 560 327686 ##(Smalltalk.Color) #default 8 1877912960 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 800 nil nil nil 7 nil nil nil 800 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Image_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 1 1 498 63 51 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 498 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1136 nil nil nil 7 nil nil nil 1136 866 ##(Smalltalk.Toolbar) #resource_Search_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 498 615 1 498 437 51 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 1088 1104 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1376 nil nil nil 7 nil nil nil 1376 866 ##(Smalltalk.Toolbar) #resource_Workspace_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 498 247 51 498 247 51 1376 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 123 0 0 0 25 0 0 0 246 0 0 0 50 0 0 0] 1088 1104 nil 27 8 'workspaceTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1616 nil nil nil 7 nil nil nil 1616 866 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 498 63 1 498 553 51 1616 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 1088 1104 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1856 nil nil nil 7 nil nil nil 1856 866 ##(Smalltalk.Toolbar) #resource_Edit_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 498 1 51 498 247 51 1856 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 1088 1104 nil 27 8 'editTools' 170 192 1088 138 144 1088 nil nil 1 nil 498 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 498 1 1 498 1129 101 560 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 52 2 0 0 50 0 0 0] 34 6 800 1616 1136 1856 1376 410 ##(Smalltalk.Toolbar) 34 25 nil 560 34 2 8 1140853580 131137 2336 nil nil nil 519 nil nil nil 2336 736 8 1877912960 170 192 1088 170 192 34 2 56115 1115206 1 ##(Smalltalk.ToolbarIconButton) 2336 1 1180998 4 ##(Smalltalk.CommandDescription) #refresh 8 'Refresh' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Refresh.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 56115 34 1 2480 nil nil 1 nil nil nil nil 2146 1 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 498 493 51 498 51 51 2336 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 246 0 0 0 25 0 0 0 15 1 0 0 50 0 0 0] 8 #() 1104 nil 27 1104 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2864 nil nil nil 7 nil nil nil 2864 530 1 1 nil nil nil nil 410 ##(Smalltalk.CardContainer) 34 16 nil 2864 34 2 8 1140850688 131073 2944 nil nil nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 2 3010 nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1025 2498 459270 ##(Smalltalk.Message) #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 3090 1025 2498 3138 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 3090 1025 2498 3138 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 3090 1025 2498 3138 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 3010 nil true 34 5 3090 1025 2498 3138 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 3090 1025 2498 3138 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 3090 1025 2498 3138 #viewMode: 8 #(#mediumIcons) 8 'Medium Icons' 1 1 nil nil nil 3090 1025 2498 3138 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 3090 1025 2498 3138 #viewMode: 8 #(#tileIcons) 8 'Tile Icons' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2944 656710 1 ##(Smalltalk.CardLayout) 138 144 1088 nil nil nil nil 170 192 1088 nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 2944 34 2 8 1140916736 1 3984 590662 2 ##(Smalltalk.ListModel) 138 144 1088 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 1 nil nil nil 3984 nil 8 1877659392 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #smallIcons nil nil nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 498 1 1 498 1129 703 3984 962 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 3984 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 52 2 0 0 95 1 0 0] 8 #() 1104 nil 27 898 138 144 34 2 962 #createAt:extent: 34 2 498 1 1 498 1129 703 2944 962 #contextMenu: 34 1 3024 2944 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 52 2 0 0 95 1 0 0] 34 1 3984 1104 nil 27 170 192 34 2 2944 8 'cards' nil 898 138 144 34 1 962 #createAt:extent: 34 2 498 1 101 498 1129 703 2864 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 52 2 0 0 145 1 0 0] 34 1 2944 1104 nil 27 170 192 34 2 560 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 3010 nil true 34 8 3090 1 2498 #fileNew 8 '&New Workspace' 9373 1 2546 nil true 2592 8 'NewWorkspace.ico' 2640 nil nil 3090 1 2498 #fileOpen 8 '&Open Workspace...' 9375 1 2546 nil true 2592 8 'OpenWorkspace.ico' 2640 nil nil 3090 1 2498 #fileFileIn 8 '&File In...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3090 1 2498 #saveImage 8 'Sa&ve Image' 1 1 2546 nil true 2592 8 'Snapshot.ico' 2640 nil nil 3090 1 2498 #smalltalkExit 8 'E&xit Dolphin' 1 1 2546 nil true 2592 8 'PowerSwitch.ico' 2640 nil nil 5106 4097 3090 1 2498 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 56129 nil nil 3010 nil true 34 12 3090 1 2498 #undo 8 '&Undo' 9397 1 2546 nil true 2592 8 'EditUndo.ico' 2640 nil nil 3090 1 2498 #redo 8 'R&edo' 9395 1 2546 nil true 2592 8 'EditRedo.ico' 2640 nil nil 5106 4097 3090 1 2498 #cutSelection 8 'Cu&t' 9393 1 2546 nil true 2592 8 'EditCut.ico' 2640 nil nil 3090 1 2498 #copySelection 8 '&Copy' 9351 1 2546 nil true 2592 8 'EditCopy.ico' 2640 nil nil 3090 1 2498 #pasteClipboard 8 '&Paste' 9389 1 2546 nil true 2592 8 'EditPaste.ico' 2640 nil nil 3090 1 2498 #clearSelection 8 '&Delete' 1 1 2546 nil true 2592 8 'EditClear.ico' 2640 nil nil 3090 1 2498 #selectAll 8 'Select &All' 9347 1 nil nil nil 5106 4097 3090 1 2498 #editFind 8 '&Find...' 9357 1 2546 nil true 2592 47 786694 ##(Smalltalk.ShellLibrary) nil nil 3090 1 2498 #findNext 8 'Find &Next' 1253 1 2546 nil true 2592 8 'FindNext.ico' 2640 nil nil 3090 1 2498 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 56151 nil nil 3010 nil true 34 14 3090 1 2498 #browseIt 8 '&Browse It' 9349 1 2546 nil true 2592 8 'ClassBrowserShell.ico' 2640 nil nil 3090 1 2498 #displayIt 8 '&Display It' 9353 1 2546 nil true 2592 8 'DisplayIt.ico' 2640 nil nil 3090 1 2498 #printIt 8 '&Print It' 9377 1 2546 nil true 2592 8 'PrintIt.ico' 2640 nil nil 3090 1 2498 #evaluateIt 8 '&Evaluate It' 9355 1 2546 nil true 2592 8 'EvaluateIt.ico' 2640 nil nil 3090 1 2498 #inspectIt 8 '&Inspect It' 9363 1 2546 nil true 2592 8 'BasicInspector.ico' 2640 nil nil 3090 1 2498 #debugIt 8 'Deb&ug It' 1269 1 2546 nil true 2592 8 'Debugger.ico' 2640 nil nil 3090 1 2498 #fileItIn 8 '&File It In' 1 1 nil nil nil 5106 4097 3090 1 2498 #accept 8 '&Accept' 9383 1 nil nil nil 5106 4097 3090 1 2498 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 3090 1 2498 #browseReferences 8 '&References...' 5367 1 nil nil nil 5106 4097 3010 nil true 34 9 3090 1 2498 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3090 1 2498 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3090 1 2498 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 3090 1 2498 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3090 1 2498 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3090 1 2498 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3090 1 2498 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 5106 4097 3010 nil true 34 2 3090 1 2498 3138 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 3090 1 2498 3138 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil 56191 nil nil 8 '&Options' nil 134217729 nil nil 56193 nil nil 8 '&Workspace' nil 134217729 nil nil 56195 nil nil 3010 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 56197 nil nil 3010 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 56199 nil nil 3010 nil true 34 15 3090 1 2498 #helpContents 8 '&Contents' 1025 1 2546 nil true 2592 8 'Help.ico' 2640 nil nil 3090 1 2498 #help 8 'On this &Tool' 1249 1 nil nil nil 3090 1 2498 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5106 4097 3090 1 2498 #learnSmalltalk 8 'Learn Smalltalk' 1 1 5362 $\x1F393 nil 722 #orchid 722 #white nil nil 1 nil nil nil nil 5106 4097 3090 1 2498 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3090 1 2498 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3090 1 2498 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5106 4097 3090 1 2498 #dolphinHomePage 8 'Dolphin Homepage' 1 1 2546 nil true 2592 8 '!!APPLICATION' 2640 nil nil 3090 1 2498 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3090 1 2498 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5106 4097 3090 1 2498 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5362 $\x1F42C nil nil 722 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil 498 883 661 1 nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 498 6143 21 498 1161 921 416 962 #text: 34 1 8 'Flipper Inspector' 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 67 14 0 0 214 1 0 0] 34 2 560 2864 1104 nil 27)!

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

