"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #FlipperInspector
	instanceVariableNames: 'cards'
	classVariableNames: 'Renderers'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FlipperInspector guid: (GUID fromString: '{8dc9ca40-c164-11d5-9849-0800460222f0}')!
FlipperInspector comment: ''!
!FlipperInspector categoriesForClass!Development! !
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
	model removeEventsTriggeredFor: self.
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
!FlipperInspector categoriesFor: #addToCommandRoute:!commands!public! !
!FlipperInspector categoriesFor: #createComponents!initializing!private! !
!FlipperInspector categoriesFor: #createRenderers!initializing!private! !
!FlipperInspector categoriesFor: #model:!accessing!public! !
!FlipperInspector categoriesFor: #object!accessing!public! !
!FlipperInspector categoriesFor: #object:!accessing!public! !
!FlipperInspector categoriesFor: #onValueChanged!event handling!private! !
!FlipperInspector categoriesFor: #onViewOpened!event handling!private! !
!FlipperInspector categoriesFor: #renderers!accessing!public! !
!FlipperInspector categoriesFor: #setInitialFocus!public! !
!FlipperInspector categoriesFor: #setValue:!accessing!private! !
!FlipperInspector categoriesFor: #shortCaption!accessing!public! !
!FlipperInspector categoriesFor: #updateCaption!public!updating! !
!FlipperInspector categoriesFor: #value!accessing!public! !
!FlipperInspector categoriesFor: #value:!accessing!public! !

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
		add: (Aspect boolean: #reuseIfOpen);
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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 328198 ##(Smalltalk.Point) 1161 921 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851564 131137 592 0 482 512 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 530 193 193 0 592 482 512 8 4294903529 234 256 98 8 410 8 ##(Smalltalk.ReferenceView) 98 14 0 592 98 2 8 1140850688 131073 848 0 0 0 7 0 0 0 848 1180166 ##(Smalltalk.ResourceIdentifier) 608 8 #resource_Workspace_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 530 247 51 530 155 51 848 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 123 0 0 0 25 0 0 0 200 0 0 0 50 0 0 0] 98 0 530 193 193 0 27 8 'workspaceTools' 410 864 98 14 0 592 98 2 8 1140850688 131073 1232 0 0 0 7 0 0 0 1232 930 608 8 #resource_Image_tools 0 978 202 208 98 1 1042 1072 98 2 530 1 1 530 63 51 1232 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1184 1200 0 27 8 'imageTools' 410 864 98 14 0 592 98 2 8 1140850688 131073 1488 0 0 0 7 0 0 0 1488 930 608 8 #resource_Edit_tools 0 978 202 208 98 1 1042 1072 98 2 530 1 51 530 247 51 1488 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 1184 1200 0 27 8 'editTools' 410 864 98 14 0 592 98 2 8 1140850688 131073 1744 0 0 0 7 0 0 0 1744 930 608 8 #resource_Smalltalk_tools 0 978 202 208 98 1 1042 1072 98 2 530 63 1 530 991 51 1744 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1184 1200 0 27 8 'smalltalkTools' 234 256 1184 202 208 1184 234 240 1184 0 1 0 530 33 33 530 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 978 202 208 98 2 1042 1072 98 2 530 1 1 530 1129 101 592 1042 8 #updateSizePosted 1184 592 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 52 2 0 0 50 0 0 0] 98 5 1232 1744 1488 848 410 608 98 25 0 592 98 2 8 1140853580 131137 2304 0 482 512 0 519 0 690 0 16 722 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 530 193 193 0 2304 482 512 8 4294903529 234 256 1184 234 256 98 2 37473 853766 ##(Smalltalk.ToolbarButton) 37473 0 2304 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #refresh 8 'Refresh' 1 1 0 395334 3 ##(Smalltalk.Bitmap) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Tools.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 71 530 1857 33 85 98 1 2544 234 240 98 2 2640 1 0 1 0 530 33 33 530 45 45 0 2082 1 1 1 978 202 208 98 2 1042 1072 98 2 530 401 51 530 51 51 2304 1042 2240 1184 2304 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 200 0 0 0 25 0 0 0 225 0 0 0 50 0 0 0] 98 0 1200 0 27 1200 0 27 0 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 3040 0 0 0 7 0 0 0 3040 562 1 1 0 0 0 0 410 8 ##(Smalltalk.CardContainer) 98 16 0 3040 98 2 8 1140850688 131073 3136 0 917766 ##(Smalltalk.PluggableColor) 1042 8 #toolBackgroundColor 98 0 8 ##(Smalltalk.SmalltalkSystem) 0 7 265030 4 ##(Smalltalk.Menu) 0 16 98 2 3314 0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem) 1025 2562 459270 ##(Smalltalk.Message) 8 #tabOrientation: 98 1 8 #top 8 '&Top' 1 1 0 0 0 3394 1025 2562 3442 3472 98 1 8 #bottom 8 '&Bottom' 1 1 0 0 0 3394 1025 2562 3442 3472 98 1 8 #left 8 '&Left' 1 1 0 0 0 3394 1025 2562 3442 3472 98 1 8 #right 8 '&Right' 1 1 0 0 0 8 '&Orientation' 0 134217729 0 0 0 0 0 3314 0 16 98 5 3394 1025 2562 3442 8 #viewMode: 98 1 8 #noIcons 8 '&No Icons' 1 1 0 0 0 3394 1025 2562 3442 3920 98 1 8 #smallIcons 8 '&Small Icons' 1 1 0 0 0 3394 1025 2562 3442 3920 98 1 8 #mediumIcons 8 'Medium Icons' 1 1 0 0 0 3394 1025 2562 3442 3920 98 1 8 #largeIcons 8 '&Large Icons' 1 1 0 0 0 3394 1 2562 3442 3920 98 1 8 #tileIcons 8 'Tile Icons' 1 1 0 0 0 8 '&View' 0 134217729 0 0 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 3136 655878 ##(Smalltalk.CardLayout) 202 208 1184 0 234 256 1184 0 410 8 ##(Smalltalk.TabViewXP) 98 28 0 3136 98 2 8 1140916736 1 4464 590662 2 ##(Smalltalk.ListModel) 202 208 1184 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 3232 0 1 0 0 0 4464 0 8 4294903943 8 ##(Smalltalk.BasicListAbstract) 8 ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 0 0 0 0 0 4048 0 0 0 0 0 978 202 208 98 2 1042 1072 98 2 530 1 1 530 1129 703 4464 1042 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 4464 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 52 2 0 0 95 1 0 0] 98 0 1200 0 27 978 202 208 98 2 1042 1072 98 2 530 1 1 530 1129 703 3136 1042 8 #contextMenu: 98 1 3328 3136 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 52 2 0 0 95 1 0 0] 98 1 4464 1200 0 27 234 256 98 2 3136 8 'cards' 0 978 202 208 98 1 1042 1072 98 2 530 1 101 530 1129 703 3040 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 52 2 0 0 145 1 0 0] 98 1 3136 1200 0 27 234 256 98 2 592 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 6 3314 0 16 98 8 3394 1 2562 8 #fileNew 8 '&New' 9373 1 263494 3 ##(Smalltalk.Icon) 0 16 2672 8 'FileNew.ico' 2720 0 0 3394 1 2562 8 #fileOpen 8 '&Open...' 9375 1 5522 0 16 2672 8 'FileOpen.ico' 2720 0 0 3394 1 2562 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3394 1 2562 8 #saveImage 8 'Sa&ve Image' 1 1 5522 0 16 2672 8 'Snapshot.ico' 2720 0 0 3394 1 2562 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 5522 0 16 2672 8 'PowerSwitch.ico' 2720 0 0 5730 4097 3394 1 2562 8 #exit 8 '&Close' 17639 1 5522 0 16 2672 8 'CloseWindow.ico' 2720 0 0 8 '&File' 0 134217729 0 0 37507 0 0 3314 0 16 98 12 3394 1 2562 8 #undo 8 '&Undo' 9397 1 5522 0 16 2672 8 'EditUndo.ico' 2720 0 0 3394 1 2562 8 #redo 8 'R&edo' 9395 1 5522 0 16 2672 8 'EditRedo.ico' 2720 0 0 5730 4097 3394 1 2562 8 #cutSelection 8 'Cu&t' 9393 1 5522 0 16 2672 8 'EditCut.ico' 2720 0 0 3394 1 2562 8 #copySelection 8 '&Copy' 9351 1 5522 0 16 2672 8 'EditCopy.ico' 2720 0 0 3394 1 2562 8 #pasteClipboard 8 '&Paste' 9389 1 5522 0 16 2672 8 'EditPaste.ico' 2720 0 0 3394 1 2562 8 #clearSelection 8 '&Delete' 1 1 5522 0 16 2672 8 'EditClear.ico' 2720 0 0 3394 1 2562 8 #selectAll 8 'Select &All' 9347 1 0 0 0 5730 4097 3394 1 2562 8 #editFind 8 '&Find...' 9357 1 5522 0 16 2672 47 786694 ##(Smalltalk.ShellLibrary) 0 0 3394 1 2562 8 #findNext 8 'Find &Next' 1253 1 5522 0 16 2672 8 'FindNext.ico' 2720 0 0 3394 1 2562 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 134217729 0 0 37529 0 0 3314 0 16 98 13 3394 1 2562 8 #browseIt 8 '&Browse It' 9349 1 5522 0 16 2672 8 'ClassBrowserShell.ico' 2720 0 0 3394 1 2562 8 #displayIt 8 '&Display It' 9353 1 5522 0 16 2672 8 'DisplayIt.ico' 2720 0 0 3394 1 2562 8 #evaluateIt 8 '&Evaluate It' 9355 1 5522 0 16 2672 8 'EvaluateIt.ico' 2720 0 0 3394 1 2562 8 #inspectIt 8 '&Inspect It' 9363 1 5522 0 16 2672 8 'BasicInspector.ico' 2720 0 0 3394 1 2562 8 #debugIt 8 'Deb&ug It' 1269 1 5522 0 16 2672 8 'Debugger.ico' 2720 0 0 3394 1 2562 8 #fileItIn 8 '&File It In' 1 1 0 0 0 5730 4097 3394 1 2562 8 #accept 8 '&Accept' 9383 1 0 0 0 5730 4097 3394 1 2562 8 #browseDefinitions 8 'Defi&nitions...' 1271 1 0 0 0 3394 1 2562 8 #browseReferences 8 '&References...' 5367 1 0 0 0 5730 4097 3314 0 16 98 9 3394 1 2562 8 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 3394 1 2562 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 3394 1 2562 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 3394 1 2562 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 3394 1 2562 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 3394 1 2562 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 3394 1 2562 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 5730 4097 3314 0 16 98 2 3394 1 2562 3442 8 #language: 98 1 8 #container 8 '&Smalltalk' 1 1 0 0 0 3394 1 2562 3442 8464 98 1 8 #xml 8 '&Xml' 1 1 0 0 0 8 '&Language' 0 134217729 0 0 37567 0 0 8 '&Options' 0 134217729 0 0 37569 0 0 8 '&Workspace' 0 134217729 0 0 37571 0 0 3314 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 37573 0 0 3314 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 37575 0 0 3314 0 16 98 15 3394 1 2562 8 #helpContents 8 '&Contents' 1025 1 5522 0 16 2672 49 6880 0 0 3394 1 2562 8 #help 8 'On this &Tool' 1249 1 0 0 0 3394 1 2562 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 5730 4097 3394 1 2562 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 5730 4097 3394 1 2562 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3394 1 2562 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3394 1 2562 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 5730 4097 3394 1 2562 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3394 1 2562 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3394 1 2562 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 5730 4097 3394 1 2562 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5522 0 16 2672 8 '!!APPLICATION' 2720 0 0 8 '&Help' 0 134217729 0 0 37599 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 530 883 661 1 0 0 978 202 208 98 3 1042 1072 98 2 530 3839 21 530 1161 921 416 1042 8 #text: 98 1 8 'Flipper Inspector' 416 1042 8 #updateMenuBar 1184 416 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 195 9 0 0 214 1 0 0] 98 2 592 3040 1200 0 27 )!

shellOn: anObject
	"Open an instance of the receiver displaying anObject. 
	Answer the new inspector."

	^(self show)
		value: anObject;
		yourself!

toolsFolderHelpId
	^10600!

uninitialize
	"Private - Un-register the system tools folder icon for the receiver to allow clean
	removal of this class from the system.
		self uninitialize
	"

	(Smalltalk developmentSystem)
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self! !
!FlipperInspector class categoriesFor: #defaultModel!models!public! !
!FlipperInspector class categoriesFor: #defaultRenderers!constants!private! !
!FlipperInspector class categoriesFor: #displayOn:!displaying!public! !
!FlipperInspector class categoriesFor: #icon!constants!public! !
!FlipperInspector class categoriesFor: #initialize!initializing!private! !
!FlipperInspector class categoriesFor: #publishedAspects!development!public! !
!FlipperInspector class categoriesFor: #renderers!accessing!public! !
!FlipperInspector class categoriesFor: #renderers:!accessing!public! !
!FlipperInspector class categoriesFor: #resource_Default_view!public!resources-views! !
!FlipperInspector class categoriesFor: #shellOn:!instance creation!public! !
!FlipperInspector class categoriesFor: #toolsFolderHelpId!public! !
!FlipperInspector class categoriesFor: #uninitialize!class hierarchy-removing!private! !

