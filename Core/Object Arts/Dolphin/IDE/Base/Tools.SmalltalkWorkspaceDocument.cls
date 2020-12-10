"Filed out from Dolphin Smalltalk 7"!

UI.AbstractDocumentShell subclass: #'Tools.SmalltalkWorkspaceDocument'
	instanceVariableNames: 'workspacePresenter searchPresenter'
	classVariableNames: 'CanUseIdeaSpace DefaultExtent DefaultView LanguageExtensions ReuseIfOpen VariableTips'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SmalltalkWorkspaceDocument guid: (Core.GUID fromString: '{87b4c6ba-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.SmalltalkWorkspaceDocument comment: '`SmalltalkWorkspaceDocument` is a `<documentPresenter>` that can be used for displaying Smalltalk ST and CLS files. It also allows for the evaluation of Smalltalk expressions and the execution of various other commands targeted at the `SmalltalkSystem` singleton instance.

Instance Variables:
	workspacePresenter	`SmalltalkWorkspace` holding the workspace text.

Class Variables:
	ReuseIfOpen	`<boolean>` indicating whether an open workspace should be re-used in preference to opening a new one.

'!
!Tools.SmalltalkWorkspaceDocument categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
!Tools.SmalltalkWorkspaceDocument methodsFor!

aboutDolphin
	"Show the About box."

	self model aboutDolphin!

applyOptions
	self systemModel applyOptionsToTool: self!

browsePackages
	"Open a new package browser."
	
	self model browsePackages!

buildPopupForCommand: aSymbol
	aSymbol == #newIdeaSpace ifTrue: [^SmalltalkToolShell buildIdeaSpacePopup].
	^nil!

canSaveState
	"Private - Answer true if the receiver can successfully have it's state saved by #saveStateOn:. Some
	tools may not be able to save their state and therefore will not be able to be exported as
	part of a IdeaSpace save operation"

	^true!

chooseDefaultFont
	"Launch a dialog to prompt for a change in the default font used by the system tools."
	
	self model chooseDefaultFont!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	workspacePresenter := self add: self class workspaceClass new name: 'workspace'.
	workspacePresenter areVariableTipsEnabled: self class variableTips.
	searchPresenter := self
				add: SmalltalkSearchPresenter new
				name: 'search'
				helpId: 10510!

createSchematicWiring
	super createSchematicWiring.
	self
		when: #dropFiles:
		send: #onDropFiles:over:
		to: self systemModel
		withArguments: {nil. self}!

defaultHelpId
	^10729!

destroy
	"Attempt to forcibly close the receiver's view. If this is an IdeaSpace card then we ask the IdeaSpace to destroy it."

	self isIdeaSpaceCard ifTrue: [^self ideaSpace destroyCard: self].
	^super destroy!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self shortCaption!

dropClassFile: aString 
	self dropScriptFile: aString!

dropPackageFile: aString 
	self dropScriptFile: aString!

dropScriptFile: aString 
	self dropTextFile: aString!

dropTextFile: aString 
	"Private - The file with the specified full pathname has been dropped over the receiver.
	Behave as notepad and load it into this workspace."

	self promptToSaveChanges ifFalse: [^self].
	self filename: aString.
	self fileLoad!

dropXmlFile: aString 
	self dropTextFile: aString!

educationCenter
	"Open the local Education Centre page"

	self model educationCenter!

exit
	"Attempt to close the receiver's view. If this is an IdeaSpace card then we ask the IdeaSpace to close it."

	self isIdeaSpaceCard ifTrue: [^self ideaSpace closeCard: self].
	^super exit!

fileFileIn
	"The user has selected the standard File/File In command. File in the 
	current contents of the receiver."

	self model fileFileIn!

fileLoad
	| caret |
	caret := self workspace view caretPosition.
	self hasFilename ifTrue: [self setLexer].
	super fileLoad.
	(self workspace view)
		caretPosition: caret;
		ensureCaretVisible!

fileNew
	"The user has selected the standard File/New command. Use this
	to create a new workspace"

	^self model newWorkspace!

fileOpen
	"Create a new workspace window on a file"

	self openWorkspace!

forgetSize
	"Forget the default size for new instances of this tool."

	self class defaultExtent: nil!

getDocumentData
	"Private - Answer the data for the receiver's document"

	^self workspace text!

guidedTour
	"Open the guided tour page"

	self model guidedTour!

hasContents
	^self hasFilename or: [self getDocumentData notEmpty]!

help
	"Brings up a help page for the receiver"

	self model openHelpTopicForTool: self!

ideaSpace
	^#{IdeaSpaceShell} valueOrNil
		ifNotNil: [:ideaSpaceShellClass | (self topShell isKindOf: ideaSpaceShellClass) ifTrue: [self topShell]]!

inspectSystemOptions
	"Open an <AccessorInspector> on the system options."

	| inspector |
	inspector := PublishedAspectInspector shellOn: self class.
	inspector topShell caption: self class name , ' Options'!

isIdeaSpaceCard
	^self ideaSpace notNil!

isModified
	"Answer whether the document in the receiver has been modified."

	^workspacePresenter isModified!

isModified: aBoolean
	"Set/reset the receiver's dirty flag."

	workspacePresenter isModified: aBoolean!

isText
	"Answer true if the receiver is a text document"

	^true!

language: aSymbol
	workspacePresenter view lexer: aSymbol!

onDropDown: aToolbarButton 
	"Private - The receiver's toolbar has sent a notification that a button's drop-down arrow
	has been pressed. Generate and pop-up the appropriate menu."

	| popup |
	popup := self buildPopupForCommand: aToolbarButton command asSymbol.
	popup isNil ifTrue: [^nil].
	popup queryAllFromView: self view.
	popup showIn: self position: aToolbarButton screenRectangle bottomLeft.
	^0!

onViewOpened
	"Private - Received when the receiver's view has been connected. 
	Transfer any file contents across to the view"

	| modifiedModel toolbar |
	super onViewOpened.
	self view acceptDroppedFiles: true.
	(self view viewNamed: 'errors' ifNone: []) 
		ifNotNil: [:item | item model: self workspace errorModel].
	modifiedModel := self workspace modifiedModel.
	(self view viewNamed: 'modified' ifNone: []) ifNotNil: [:item | item model: modifiedModel].
	modifiedModel 
		when: #valueChanged
		send: #updateCaption
		to: self.
	"Enable toolbar pulldowns"
	toolbar := self view viewNamed: 'smalltalkTools'.
	toolbar presenterConnectionPoint 
		when: #dropDown:
		send: #onDropDown:
		to: self.
	self applyOptions.
	self fileLoad!

openViewComposer
	"Open a new view composer"
	
	self model openViewComposer!

openWorkspace
	"Prompt for a workspace filename and open the contents inside the receiver if it is empty. Otherwise
	create a new SmalltalkWorkspaceDocument to hold the contents of the file."

	| openFilename |
	self hasContents ifTrue: [^self model openWorkspace].
	openFilename := self class getFilename.
	openFilename isNil ifTrue: [^nil].
	^self openOn: openFilename!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver into the 
	<CommandQuery>."

	| command |
	command := aCommandQuery commandSymbol.
	(#(#dragToolToIdeaSpace #addToNewIdeaSpace) includes: command) 
		ifTrue: 
			[aCommandQuery isEnabled: self isIdeaSpaceCard not.
			^true].
	^super queryCommand: aCommandQuery!

rememberThisSize
	"Record the size of the receiver as the default extent for its tool class."

	self class defaultExtent: self view extent!

saveStateOn: aWriteStream 
	"Private - Write the source of a monadic block that will configure an instance of the receiver's class
	to match the state current receiver, to aWriteStream. The block expects a fresh instance of
	the receiver's class as it's parameter"

	aWriteStream 
		nextPutAll: '[:aSmalltalkWorkspaceDocument | 
	aSmalltalkWorkspaceDocument workspace evaluationPools: '.
	self workspace evaluationPools literalStoreEvaluationOn: aWriteStream.
	aWriteStream
		nextPut: $.;
		cr.
	super saveStateOn: aWriteStream.
	aWriteStream nextPutAll: ' value: aSmalltalkWorkspaceDocument.'.
	aWriteStream nextPutAll: ']'!

searchForClass: aClass 
	^aClass browse!

searchForMethod: aCompiledMethod 
	aCompiledMethod browse!

searchForObject: anObject 
	^anObject inspect!

searchForPackage: aPackage 
	^aPackage browse!

searchForSymbol: aSymbol
	self
		routeCommand: (CommandDescription command: (Message selector: #browseMethodsInEnvironments:
						argument: (self systemModel messagesMatching: (MethodSearch newSelector: aSymbol)
								in: Refactory.Browser.BrowserEnvironment new)))!

searchSmalltalk
	| searchView |
	searchView := searchPresenter view.
	searchView hasFocus ifTrue: [^self].
	searchView
		setFocus;
		flash: SmalltalkToolShell searchFieldFlashes!

searchSmalltalkFor: anObject 
	anObject searchForInTool: self!

setDocumentData: text
	"Private - Set the data for the receiver's document to text (a String or RichText)."

	self workspace text: text!

setInitialFocus
	workspacePresenter view setFocus!

setLexer
	self language: (LanguageExtensions at: (File splitExtensionFrom: self filename) ifAbsent: [#text])!

show
	"Shows the view of the receiver.
	Pick up the default extent if any."

	self class defaultExtent ifNotNil: [:ext | self view extent: ext].
	^super show!

smalltalkExit
	"Request system shutdown - may be cancelled by user."

	self model smalltalkExit!

systemModel
	^SmalltalkSystem current!

workspace
	"Answers the SmalltalkWorkspace held by the receiver."

	^workspacePresenter! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #aboutDolphin!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #applyOptions!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #browsePackages!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #buildPopupForCommand:!private! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #canSaveState!private!saved state! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #chooseDefaultFont!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #createComponents!initializing!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #defaultHelpId!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #destroy!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #displayOn:!displaying!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #dropClassFile:!commands!private! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #dropPackageFile:!commands!private! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #dropScriptFile:!commands!private! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #dropTextFile:!commands!private! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #dropXmlFile:!commands!private! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #educationCenter!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #exit!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #fileFileIn!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #fileLoad!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #fileNew!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #fileOpen!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #forgetSize!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #getDocumentData!accessing!private! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #guidedTour!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #hasContents!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #help!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #ideaSpace!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #inspectSystemOptions!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #isIdeaSpaceCard!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #isModified!public!testing! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #isModified:!modes!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #isText!public!testing! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #language:!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #onDropDown:!private! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #onViewOpened!event handling!private! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #openViewComposer!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #openWorkspace!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #queryCommand:!commands!private! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #rememberThisSize!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #saveStateOn:!private!saved state! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #searchForClass:!private! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #searchForMethod:!private! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #searchForObject:!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #searchForPackage:!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #searchForSymbol:!private! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #searchSmalltalk!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #searchSmalltalkFor:!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #setDocumentData:!accessing!private! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #setInitialFocus!operations!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #setLexer!helpers!private! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #show!operations!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #smalltalkExit!commands!public! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #systemModel!accessing!private! !
!Tools.SmalltalkWorkspaceDocument categoriesFor: #workspace!accessing!public! !

!Tools.SmalltalkWorkspaceDocument class methodsFor!

activeIdeaSpace
	^#{IdeaSpaceShell}
		ifDefined: [:ideaSpaceShellClass | (View active topShell isKindOf: ideaSpaceShellClass) ifTrue: [View active topShell]]!

canUseIdeaSpace
	"Answers true if an already open instance of the receiver should be reused instead of
	creating additional instances. In fact, it does not always make sense for a system tool
	to allow re-use. Therefore, although all tools support this functionality, only some
	expose it as a published aspect so that it may be set as a system option."

	CanUseIdeaSpace isNil ifTrue: [ CanUseIdeaSpace := false ].
	^CanUseIdeaSpace!

canUseIdeaSpace: aBoolean
	"Set the receiver to reuse an already open instance of the receiver instead of
	creating an additional one according to aBoolean."

	CanUseIdeaSpace := aBoolean
!

defaultAdditionalAccelerators
	"Private - Answer a collection of additional accelerator definitions for commands not on the menu bar of the receiver's view(s).
	Each element of the collection should be a two element <Array>, the first element of which is the command symbol
	and the second the accelerator key string."

	^#(#(#inspectIt 'Shift+Ctrl+I'))!

defaultBackcolor
	"Answer the default background colour to use for instances of the receiver."

	^self workspaceClass defaultBackcolor!

defaultBackcolor: aColorOrNil 
	"Set the default background colour to use for instances of the receiver."

	self workspaceClass defaultBackcolor: aColorOrNil!

defaultCaretColor
	"Answer the default caret colour to use for instances of the receiver"

	^self workspaceClass defaultCaretColor !

defaultCaretColor: aColorOrNil 
	"Set the default caret colour to use for instances of the receiver"

	self workspaceClass defaultCaretColor: aColorOrNil!

defaultExtent
	"Answer a <Point> which is the user's chosen default extent for new instances
	of the receiver, or nil if left up to Windows."

	^DefaultExtent!

defaultExtent: aPoint
	"Set the default extent to be used for instances of the receiver to the <Point> argument.
	If the argument is nil, then let Windows decide."

	DefaultExtent := aPoint!

defaultFileExtension
	"Answer a default extension that will be used for files saved from
	the receiver"

	^'st'!

defaultFont
	"Answer the default font to use for instances of the receiver"

	^self workspaceClass defaultFont!

defaultFont: aFontOrNil 
	"Set the default font to use for instances of the receiver"

	self workspaceClass defaultFont: aFontOrNil!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^Smalltalk developmentSystem!

defaultTabWidth
	"Answer the width of tabs (equivalent number of spaces) in instances of the receiver."

	^self workspaceClass defaultTabWidth!

defaultTabWidth: anInteger 
	"Answer the width of tabs (equivalent number of spaces) in instances of the receiver."

	self workspaceClass defaultTabWidth: anInteger!

defaultView
	"Answer the resource name of the default view for the receiver.
	This is configurable for tool shells so that the developer can easily replace the
	standard Dolphin views if he or she wishes."

	DefaultView isNil ifTrue: [DefaultView := super defaultView].
	^DefaultView!

defaultView: aString
	"Set the default view name."

	DefaultView := aString!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Workspace'!

fileTypes
	"Answer an Array of file types that can be associated with this
	class of document."

	| domain |
	domain := self defaultModel.
	^OrderedCollection new
		add: domain smalltalkFilesType;
		add: domain classFilesType;
		add: domain packageFilesType;
		add: domain ideaSpaceFilesType;
		add: #('Text Files (*.txt)' '*.txt');
		add: UI.FileDialog allFilesType;
		asArray!

icon
	"Answers an Icon that can be used to represent this class"

	^SmalltalkWorkspace icon!

initialize
	"Private - Initialize the receiver. Register with SmalltalkSystem.
		self initialize
	"

	Smalltalk developmentSystem
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self wordWrap: true.
	self canUseIdeaSpace: true.
	self defaultExtent: 640 @ 480.
	self variableTips: true.
	LanguageExtensions := LookupTable new
				at: 'txt' put: #text;
				at: 'xml' put: #xml;
				yourself.
	#('st' 'cls' 'pac' 'pax' 'chg' 'sml' 'ist')
		do: [:each | LanguageExtensions at: each put: #container].
	LanguageExtensions isImmutable: true!

isRichTextFile: aString
	^aString notNil and: [(File splitExtensionFrom: aString) asLowercase = 'rtf']!

openIcon
	"Answers an Icon that can be used to represent the opening of an instance from a file"

	^Icon fromId: 'FileOpen.ico'!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| answer |
	answer := super publishedAspects.
	#(#reuseIfOpen #canUseIdeaSpace #wordWrap #variableTips)
		do: [:each | answer add: (Aspect boolean: each)].
	#(#defaultBackcolor #defaultCaretColor) do: [:each | answer add: (Aspect color: each)].
	answer
		add: (Aspect font: #defaultFont);
		add: (Aspect choice: #defaultView from: self resourceNames);
		add: (Aspect name: #defaultExtent);
		add: self workspaceClass textStylesAspect;
		add: (Aspect integer: #defaultTabWidth);
		yourself.
	^answer!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 517 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 917510 ##(Graphics.Color) #default 8 1801306032 170 192 34 6 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Toolbar) #resource_Image_tools nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 1 1 882 63 51 672 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 882 193 193 nil 27 8 'imageTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 738 ##(UI.Toolbar) #resource_Smalltalk_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 63 1 882 553 51 1024 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 976 992 nil 27 8 'smalltalkTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 738 ##(UI.Toolbar) #resource_Search_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 615 1 882 437 51 1264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 976 992 nil 27 8 'searchTools' 170 192 976 8 #() nil nil 1 nil 882 33 33 nil nil 852806 1 ##(UI.FlowLayout) 1 1 1 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1219 51 528 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 97 2 0 0 25 0 0 0] 34 4 672 1024 1264 410 ##(UI.Toolbar) 34 25 nil 528 34 2 8 1409289036 131137 1744 nil nil nil 519 nil nil nil 1744 608 8 1801306032 170 192 976 170 192 34 2 45875 1311814 1 ##(UI.ToolbarIconButton) 1744 1 1377606 4 ##(UI.CommandDescription) #fileSave 8 'Save' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'FileSave.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 45875 34 2 1888 1245766 1 ##(UI.ToolbarSeparator) 1744 1 nil nil 1 nil nil nil nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1051 1 882 63 51 1744 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 44 2 0 0 25 0 0 0] 8 #() 992 nil 27 992 nil 27 410 ##(UI.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2288 nil nil nil 7 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 882 193 193 nil 2288 nil 8 1801004784 170 192 34 4 1050374 ##(UI.StatusBarItem) 1 37 2288 nil nil 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 6 1 2528 8 'doIt' 8 '[:modified | modified ifTrue: [SmalltalkSystem current changedIcon imageIndex]]' 8 #[34 105 17 122 45 159 160 161 106 60 106] 1442886 2 ##(Kernel.VariableBinding) #'Tools.SmalltalkSystem' ##(Tools.SmalltalkSystem) ##(Smalltalk) 1 #current #changedIcon #imageIndex #ifTrue: 2544 7 257 nil nil 8 'modified' 2498 1 -1 2288 nil 786950 ##(Core.Message) #displayString 8 #() ##(UI.IconicListAbstract) nil 8 'errors' 34 2 2512 2688 1311750 ##(UI.StatusBarNullItem) 513 1 2288 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 859 882 1219 45 2288 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 173 1 0 0 97 2 0 0 195 1 0 0] 8 #() 992 nil 27 410 ##(UI.Toolbar) 34 25 nil 416 34 2 8 1140853708 131073 2976 nil nil nil 519 nil nil nil 2976 608 8 1801306032 170 192 34 6 410 ##(UI.ReferenceView) 34 14 nil 2976 34 2 8 1140850688 131073 3088 nil nil nil 7 nil nil nil 3088 738 ##(UI.Toolbar) #resource_Edit_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 349 882 47 241 3088 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 174 0 0 0 23 0 0 0 38 1 0 0] 976 992 nil 27 8 'edit tools' 410 ##(UI.ReferenceView) 34 14 nil 2976 34 2 8 1140850688 131073 3328 nil nil nil 7 nil nil nil 3328 738 ##(UI.Toolbar) #resource_Find_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 241 882 47 109 3328 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 120 0 0 0 23 0 0 0 174 0 0 0] 976 992 nil 27 8 'find tools' 410 ##(UI.ReferenceView) 34 14 nil 2976 34 2 8 1140850688 131073 3568 nil nil nil 7 nil nil nil 3568 738 ##(UI.Toolbar) #resource_Workspace_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 47 241 3568 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 23 0 0 0 120 0 0 0] 976 992 nil 27 8 'workspace tools' 170 192 976 8 #() nil nil 1 nil 882 33 33 nil nil 1554 1 1 1 770 138 144 34 1 834 #createAt:extent: 34 2 882 1173 51 882 47 809 2976 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 2 0 0 25 0 0 0 97 2 0 0 173 1 0 0] 34 3 3568 3328 3088 992 nil 27 nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 393217 4032 nil nil nil 7 nil nil nil 4032 498 1 1 nil nil nil nil 410 ##(UI.ReferenceView) 34 14 nil 4032 34 2 8 1140916224 131073 4112 nil nil nil 23 nil nil nil 4112 738 ##(Tools.SmalltalkWorkspace) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1169 805 4112 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 146 1 0 0] 976 992 nil 27 170 192 34 2 4112 8 'workspace' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 51 882 1173 809 4032 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 74 2 0 0 173 1 0 0] 34 1 4112 992 nil 27 170 192 34 6 528 8 'toolbar' 2976 8 'toolbar2' 2288 8 'statusbar' nil 658246 4 ##(UI.MenuBar) nil true 34 6 461638 4 ##(UI.Menu) nil true 34 12 1180742 2 ##(UI.CommandMenuItem) 1 1906 #fileNew 8 '&New' 9373 1 1954 nil true 2000 8 'DocumentShell.ico' 2048 nil nil 4722 1 1906 #fileOpen 8 '&Open...' 9375 1 1954 nil true 2000 8 'OpenWorkspace.ico' 2048 nil nil 4722 1 1906 #fileFileIn 8 '&File In...' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 4722 1 1906 #fileSave 8 '&Save' 9383 1 1954 nil true 2000 8 'FileSave.ico' 2048 nil nil 4722 1 1906 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 4722 1 1906 #fileRevert 8 '&Revert' 1 1 1378630 1 ##(Graphics.TextTileIcon) $\x1F501 nil nil 594 #commonGreen nil nil 1 nil nil nil nil 4946 4097 4722 1 1906 #saveImage 8 'Sa&ve Image' 1 1 1954 nil true 2000 8 'Snapshot.ico' 2048 nil nil 4722 1 1906 #smalltalkExit 8 'E&xit Dolphin' 1 1 1954 nil true 2000 8 'PowerSwitch.ico' 2048 nil nil 4946 4097 4722 1 1906 #exit 8 '&Close' 17639 1 5154 $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 45919 nil nil 4674 nil true 34 12 4722 1 1906 #undo 8 '&Undo' 9397 1 1954 nil true 2000 8 'EditUndo.ico' 2048 nil nil 4722 1 1906 #redo 8 'R&edo' 9395 1 1954 nil true 2000 8 'EditRedo.ico' 2048 nil nil 4946 4097 4722 1 1906 #cutSelection 8 'Cu&t' 9393 1 1954 nil true 2000 8 'EditCut.ico' 2048 nil nil 4722 1 1906 #copySelection 8 '&Copy' 9351 1 1954 nil true 2000 8 'EditCopy.ico' 2048 nil nil 4722 1 1906 #pasteClipboard 8 '&Paste' 9389 1 1954 nil true 2000 8 'EditPaste.ico' 2048 nil nil 4722 1 1906 #clearSelection 8 '&Delete' 1 1 1954 nil true 2000 8 'EditClear.ico' 2048 nil nil 4722 1 1906 #selectAll 8 'Select &All' 9347 1 nil nil nil 4946 4097 4722 1 1906 #editFind 8 '&Find...' 9357 1 1954 nil true 2000 47 983302 ##(OS.ShellLibrary) nil nil 4722 1 1906 #findNext 8 'Find &Next' 1253 1 1954 nil true 2000 8 'FindNext.ico' 2048 nil nil 4722 1 1906 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 45941 nil nil 4674 nil true 34 17 4722 1 1906 #browseIt 8 '&Browse It' 9349 1 1954 nil true 2000 8 'ClassBrowserShell.ico' 2048 nil nil 4722 1 1906 #displayIt 8 '&Display It' 9353 1 1954 nil true 2000 8 'DisplayIt.ico' 2048 nil nil 4722 1 1906 #printIt 8 '&Print It' 9377 1 1954 nil true 2000 8 'PrintIt.ico' 2048 nil nil 4722 1 1906 #evaluateIt 8 '&Evaluate It' 9355 1 1954 nil true 2000 8 'EvaluateIt.ico' 2048 nil nil 4722 1 1906 #inspectIt 8 '&Inspect It' 9363 1 1954 nil true 2000 8 'InspectIt.ico' 2048 nil nil 4722 1 1906 #debugIt 8 'Deb&ug It' 1269 1 1954 nil true 2000 8 'Debugger.ico' 2048 nil nil 4722 1 1906 #fileItIn 8 '&File it In' 1 1 nil nil nil 4946 4097 4722 1 1906 #chooseEvaluationPools 8 'Pool&s...' 1 1 1954 nil true 2000 8 'Dictionary.ico' 2048 nil nil 4722 1 1906 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 4946 4097 4722 1 1906 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 4722 1 1906 #browseReferences 8 '&References...' 5367 1 nil nil nil 4946 4097 4722 1 1906 #clear 8 'C&lear' 1 1 1954 nil true 2000 8 'ClearDocument.ico' 2048 nil nil 4946 4097 4674 nil true 34 9 4722 1 1906 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4722 1 1906 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4722 1 1906 #toggleLineEndings 8 'Line &Endings' 1 1 5154 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4722 1 1906 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4722 1 1906 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4722 1 1906 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4722 1 1906 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 4946 4097 4674 nil true 34 3 4722 1 1906 2706 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 4722 1 1906 2706 #language: 8 #(#text) 8 '&Text' 1 1 nil nil nil 4722 1 1906 2706 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil 45987 nil nil 8 '&Options' nil 134217729 1954 nil true 2000 8 'Preferences.ico' 2048 nil 45989 nil nil 8 '&Workspace' nil 134217729 nil nil 45991 nil nil 4674 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 45993 nil nil 4674 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 45995 nil nil 4674 nil true 34 15 4722 1 1906 #helpContents 8 '&Contents' 1025 1 1954 nil true 2000 8 'Help.ico' 2048 nil nil 4722 1 1906 #help 8 'On this &Tool' 1249 1 nil nil nil 4722 1 1906 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4946 4097 4722 1 1906 #learnSmalltalk 8 'Learn Smalltalk' 1 1 5154 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 4946 4097 4722 1 1906 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4722 1 1906 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4722 1 1906 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4946 4097 4722 1 1906 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 1954 nil true 2000 8 '!!APPLICATION' 2048 nil nil 4722 1 1906 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4722 1 1906 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4946 4097 4722 1 1906 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5154 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 46019 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 6143 21 882 1251 1021 416 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 112 14 0 0 8 2 0 0] 34 4 528 2976 4032 2288 992 nil 27 )!

reuseIfOpen
	"Answers true if an already open instance of the receiver should be reused instead of
	creating additional instances. In fact, it does not always make sense for a system tool
	to allow re-use. Therefore, although all tools support this functionality, only some
	expose it as a published aspect so that it may be set as a system option."

	ReuseIfOpen isNil ifTrue: [ ReuseIfOpen := false ].
	^ReuseIfOpen!

reuseIfOpen: aBoolean
	"Set the receiver to reuse an already open instance of the receiver instead of
	creating an additional one according to aBoolean."

	ReuseIfOpen := aBoolean
!

show
	"Shows an instance of the receiver. If reuseIfOpen has been set to true then an 
	existing instance of the receiver will be shown and answered rather than
	a new instance."

	(self canUseIdeaSpace and: [SmalltalkToolShell activeIdeaSpace notNil])
		ifTrue: [^SmalltalkToolShell show: self inIdeaSpace: SmalltalkToolShell activeIdeaSpace].
	self reuseIfOpen
		ifTrue: [(SmalltalkToolShell showExistingInstanceOf: self) ifNotNil: [:tool | ^tool]].
	^super show!

textStyles
	^self workspaceClass textStyles!

textStyles: aCollectionOfScintillaTextStyles 
	"Set the text styles used to colour text in the receiver's instances. These must have the
	names used in the styler, which by default is a <SmalltalkStyler>."

	self workspaceClass textStyles: aCollectionOfScintillaTextStyles!

toolsFolderHelpId
	^10592!

toolsFolderIcon
	"Answer an instance of SmalltalkSystemIcon suitable for representing the
	receiver in the system folder."

	^SmalltalkSystemIcon
		show: self
		description: self displayString
		helpId: self toolsFolderHelpId!

variableTips
	^VariableTips!

variableTips: aBoolean 
	"Set whether tooltips will be displayed to show the value of workspace variables that the user hovers the mouse over.
	Note that this works even when the workspace is in the background, and uses a relatively high frequency timer to 
	detect the dwell. It has a certain CPU overhead, and so is disabled by default."

	VariableTips := aBoolean!

wordWrap
	"Answer true if instances of the receiver use word wrapping by default."

	^self workspaceClass wordWrap!

wordWrap: aBoolean 
	"Sets the word wrapping state for instances of the receiver to aBoolean."

	self workspaceClass wordWrap: aBoolean!

workspaceClass
	^Smalltalk developmentSystem workspaceClass! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #activeIdeaSpace!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #canUseIdeaSpace!accessing!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #canUseIdeaSpace:!accessing!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #defaultBackcolor!accessing!options!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #defaultBackcolor:!accessing!options!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #defaultCaretColor!accessing!options!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #defaultCaretColor:!accessing!options!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #defaultExtent!accessing!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #defaultExtent:!accessing!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #defaultFileExtension!constants!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #defaultFont!accessing!options!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #defaultFont:!accessing!options!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #defaultModel!models!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #defaultTabWidth!accessing!options!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #defaultTabWidth:!accessing!options!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #defaultView!constants!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #defaultView:!accessing!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #displayOn:!displaying!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #fileTypes!constants!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #icon!constants!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #initialize!initializing!private! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #isRichTextFile:!helpers!private! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #openIcon!constants!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #publishedAspects!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #reuseIfOpen!accessing!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #reuseIfOpen:!accessing!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #show!instance creation!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #textStyles!accessing!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #textStyles:!accessing!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #toolsFolderHelpId!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #toolsFolderIcon!constants!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #variableTips!accessing!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #variableTips:!accessing!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #wordWrap!accessing!options!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #wordWrap:!accessing!options!public! !
!Tools.SmalltalkWorkspaceDocument class categoriesFor: #workspaceClass!accessing!options!public! !

Tools.SmalltalkWorkspaceDocument class methodProtocol: #installableSystemTool attributes: #(#readOnly) selectors: #(#registerAsToolWith: #unregisterAsToolWith:)!

