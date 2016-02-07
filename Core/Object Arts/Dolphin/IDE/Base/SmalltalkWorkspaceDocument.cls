"Filed out from Dolphin Smalltalk 7"!

DocumentShell subclass: #SmalltalkWorkspaceDocument
	instanceVariableNames: 'workspacePresenter searchPresenter'
	classVariableNames: 'CanUseIdeaSpace DefaultExtent DefaultView LanguageExtensions ReuseIfOpen VariableTips'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkWorkspaceDocument guid: (GUID fromString: '{87B4C6BA-026E-11D3-9FD7-00A0CC3E4A32}')!
SmalltalkWorkspaceDocument comment: 'SmalltalkWorkspaceDocument is a <documentPresenter> that can be used for displaying Smalltalk ST and CLS files. It also allows for the evaluation of Smalltalk expressions and the execution of various other commands targeted at the <SmalltalkSystem> singleton instance.

Instance Variables:
	workspacePresenter	<SmalltalkWorkspace> holding the workspace text.

Class Variables:
	ReuseIfOpen	<boolean> indicating whether an open workspace should be re-used in preference to opening a new one.

'!
!SmalltalkWorkspaceDocument categoriesForClass!Development!MVP-Presenters!MVP-Resources-IDE Tools! !
!SmalltalkWorkspaceDocument methodsFor!

aboutDolphin
	"Show the About box."

	self model aboutDolphin!

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
		withArguments: (Array with: nil with: self)!

defaultHelpId
	^10729!

destroy
	"Attempt to forcibly close the receiver's view. If this is an IdeaSpace card then we ask the IdeaSpace to destroy it."

	self isIdeaSpaceCard ifTrue: [^self ideaSpace destroyCard: self].
	^super destroy!

displayOn: aStream
	aStream display: self shortCaption!

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
	self hasFilename ifTrue: [self setLexer].
	super fileLoad!

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
	^(self class environment at: #IdeaSpaceShell ifAbsent: []) 
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
								in: BrowserEnvironment new)))!

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
	self language: (LanguageExtensions at: (File splitExtensionFrom: self filename) ifAbsent: [#text])

!

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
!SmalltalkWorkspaceDocument categoriesFor: #aboutDolphin!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #browsePackages!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #buildPopupForCommand:!private! !
!SmalltalkWorkspaceDocument categoriesFor: #canSaveState!private!saved state! !
!SmalltalkWorkspaceDocument categoriesFor: #chooseDefaultFont!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #createComponents!initializing!public! !
!SmalltalkWorkspaceDocument categoriesFor: #createSchematicWiring!initializing!public! !
!SmalltalkWorkspaceDocument categoriesFor: #defaultHelpId!public! !
!SmalltalkWorkspaceDocument categoriesFor: #destroy!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #displayOn:!displaying!public! !
!SmalltalkWorkspaceDocument categoriesFor: #dropClassFile:!commands!private! !
!SmalltalkWorkspaceDocument categoriesFor: #dropPackageFile:!commands!private! !
!SmalltalkWorkspaceDocument categoriesFor: #dropScriptFile:!commands!private! !
!SmalltalkWorkspaceDocument categoriesFor: #dropTextFile:!commands!private! !
!SmalltalkWorkspaceDocument categoriesFor: #dropXmlFile:!commands!private! !
!SmalltalkWorkspaceDocument categoriesFor: #educationCenter!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #exit!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #fileFileIn!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #fileLoad!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #fileNew!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #fileOpen!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #forgetSize!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #getDocumentData!accessing!private! !
!SmalltalkWorkspaceDocument categoriesFor: #guidedTour!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #hasContents!public! !
!SmalltalkWorkspaceDocument categoriesFor: #help!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #ideaSpace!public! !
!SmalltalkWorkspaceDocument categoriesFor: #inspectSystemOptions!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #isIdeaSpaceCard!public! !
!SmalltalkWorkspaceDocument categoriesFor: #isModified!public!testing! !
!SmalltalkWorkspaceDocument categoriesFor: #isModified:!modes!public! !
!SmalltalkWorkspaceDocument categoriesFor: #isText!public!testing! !
!SmalltalkWorkspaceDocument categoriesFor: #language:!public! !
!SmalltalkWorkspaceDocument categoriesFor: #onDropDown:!private! !
!SmalltalkWorkspaceDocument categoriesFor: #onViewOpened!event handling!private! !
!SmalltalkWorkspaceDocument categoriesFor: #openViewComposer!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #openWorkspace!public! !
!SmalltalkWorkspaceDocument categoriesFor: #queryCommand:!commands!private! !
!SmalltalkWorkspaceDocument categoriesFor: #rememberThisSize!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #saveStateOn:!private!saved state! !
!SmalltalkWorkspaceDocument categoriesFor: #searchForClass:!private! !
!SmalltalkWorkspaceDocument categoriesFor: #searchForMethod:!private! !
!SmalltalkWorkspaceDocument categoriesFor: #searchForObject:!public! !
!SmalltalkWorkspaceDocument categoriesFor: #searchForPackage:!public! !
!SmalltalkWorkspaceDocument categoriesFor: #searchForSymbol:!private! !
!SmalltalkWorkspaceDocument categoriesFor: #searchSmalltalk!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #searchSmalltalkFor:!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #setDocumentData:!accessing!private! !
!SmalltalkWorkspaceDocument categoriesFor: #setInitialFocus!operations!public! !
!SmalltalkWorkspaceDocument categoriesFor: #setLexer!helpers!private! !
!SmalltalkWorkspaceDocument categoriesFor: #show!operations!public! !
!SmalltalkWorkspaceDocument categoriesFor: #smalltalkExit!commands!public! !
!SmalltalkWorkspaceDocument categoriesFor: #systemModel!accessing!private! !
!SmalltalkWorkspaceDocument categoriesFor: #workspace!accessing!public! !

!SmalltalkWorkspaceDocument class methodsFor!

activeIdeaSpace
	| ideaSpaceShellClass |
	ideaSpaceShellClass := Smalltalk at: #IdeaSpaceShell ifAbsent: [^nil].
	^(View active topShell isKindOf: ideaSpaceShellClass) ifTrue: [View active topShell]!

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

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Workspace'!

fileTypes
	"Answer an Array of file types that can be associated with this
	class of document."

	| domain |
	domain := self defaultModel.
	^(OrderedCollection new)
		add: domain smalltalkFilesType;
		add: domain classFilesType;
		add: domain packageFilesType;
		add: domain ideaSpaceFilesType;
		add: #('Text Files (*.txt)' '*.txt');
		add: FileDialog allFilesType;
		asArray!

icon
	"Answers an Icon that can be used to represent this class"

	^SmalltalkWorkspace icon!

initialize
	"Private - Initialize the receiver. Register with SmalltalkSystem.
		self initialize
	"

	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self wordWrap: true.
	self canUseIdeaSpace: true.
	self defaultExtent: 640 @ 480.
	self variableTips: false.
	LanguageExtensions := (LookupTable new)
				at: 'txt' put: #text;
				at: 'xml' put: #xml;
				yourself.
	#('st' 'cls' 'pac' 'pax' 'chg' 'sml' 'ist') do: [:each | LanguageExtensions at: each put: #container].
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
	#(#defaultBackcolor #defaultCaretColor) 
		do: [:each | answer add: (Aspect color: each)].
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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 196934 1 ##(Smalltalk.RGB) 8 4294967295 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851532 131073 560 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 28 198 63 1 0 0 204 53 63 1 3 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point) 193 193 0 560 642 672 8 4294902647 234 256 98 4 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 864 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 0 0 864 1180166 ##(Smalltalk.ResourceIdentifier) 576 8 #resource_Smalltalk_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 770 63 1 770 991 51 864 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 98 0 770 193 193 0 27 8 'smalltalkTools' 410 880 98 14 0 560 98 2 8 1140850688 131073 1280 0 946 31 0 7 0 0 0 1280 978 576 8 #resource_Image_tools 0 1026 202 208 98 1 1090 1120 98 2 770 1 1 770 63 51 1280 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1232 1248 0 27 8 'imageTools' 234 256 1232 202 208 1232 234 240 1232 0 1 0 770 33 33 770 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1026 202 208 98 2 1090 1120 98 2 770 1 1 770 1059 51 560 1090 8 #updateSizePosted 1232 560 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 17 2 0 0 25 0 0 0] 98 2 1280 864 1248 0 27 410 8 ##(Smalltalk.StatusBar) 98 18 0 416 98 2 8 1140850956 1 1856 0 642 672 0 7 0 690 0 16 722 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 770 193 193 0 1856 0 8 4294902455 234 256 98 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 1856 0 459270 ##(Smalltalk.Message) 8 #displayString 98 0 8 ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'errors' 2066 1 37 1856 0 0 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 5 1 8 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association) 8 #Smalltalk 48 8 #developmentSystem 8 #changedIcon 8 #imageIndex 2256 7 257 0 0 8 'modified' 98 2 2224 2080 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 1856 0 0 1026 202 208 98 1 1090 1120 98 2 770 1 759 770 1059 45 1856 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 123 1 0 0 17 2 0 0 145 1 0 0] 98 0 1248 0 27 410 576 98 25 0 416 98 2 8 1140851596 131073 2688 0 642 672 0 7 0 690 0 16 722 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 770 193 193 0 2688 642 672 8 4294902647 234 256 98 8 410 880 98 14 0 2688 98 2 8 1140850688 131073 2896 0 0 0 7 0 0 0 2896 978 576 8 #resource_Workspace_tools 0 1026 202 208 98 1 1090 1120 98 2 770 1 151 770 49 195 2896 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 75 0 0 0 24 0 0 0 172 0 0 0] 1232 1248 0 27 8 'workspace tools' 410 880 98 14 0 2688 98 2 8 1140850688 131073 3152 0 0 0 7 0 0 0 3152 978 576 8 #resource_Edit_tools 0 1026 202 208 98 1 1090 1120 98 2 770 1 449 770 49 237 3152 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 224 0 0 0 24 0 0 0 86 1 0 0] 1232 1248 0 27 8 'edit tools' 410 880 98 14 0 2688 98 2 8 1140850688 131073 3408 0 0 0 7 0 0 0 3408 978 576 8 #resource_Find_tools 0 1026 202 208 98 1 1090 1120 98 2 770 1 345 770 51 105 3408 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 172 0 0 0 25 0 0 0 224 0 0 0] 1232 1248 0 27 8 'find tools' 410 880 98 14 0 2688 98 2 8 1140850688 131073 3664 0 0 0 7 0 0 0 3664 978 576 8 #resource_File_tools 0 1026 202 208 98 1 1090 1120 98 2 770 1 1 770 51 151 3664 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 25 0 0 0 75 0 0 0] 1232 1248 0 27 8 'file tools' 234 256 1232 98 0 234 240 1232 0 1 0 770 33 33 770 45 45 0 1634 1 1 1 1026 202 208 98 2 1090 1120 98 2 770 1009 51 770 51 709 2688 1090 1792 1232 2688 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 248 1 0 0 25 0 0 0 17 2 0 0 123 1 0 0] 98 4 3664 2896 3408 3152 1248 0 27 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 4192 0 0 0 7 0 0 0 4192 530 1 1 0 0 0 0 410 880 98 14 0 4192 98 2 8 1140916224 131073 4288 0 0 0 23 0 0 0 4288 978 8 ##(Smalltalk.SmalltalkWorkspace) 8 #resource_Default_view 0 1026 202 208 98 1 1090 1120 98 2 770 1 1 770 1009 709 4288 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 248 1 0 0 98 1 0 0] 1232 1248 0 27 234 256 98 2 4288 8 'workspace' 0 1026 202 208 98 1 1090 1120 98 2 770 1 51 770 1009 709 4192 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 248 1 0 0 123 1 0 0] 98 1 4288 1248 0 27 234 256 98 6 2688 8 'toolbar2' 1856 8 'statusbar' 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 6 265030 4 ##(Smalltalk.Menu) 0 16 98 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #fileNew 8 '&New' 9373 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'DocumentShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 4930 1 4962 8 #fileOpen 8 '&Open...' 9375 1 5026 0 16 5072 8 'FileOpen.ico' 5120 0 0 4930 1 4962 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4930 1 4962 8 #fileSave 8 '&Save' 9383 1 5026 0 16 5072 8 'FileSave.ico' 5120 0 0 4930 1 4962 8 #fileSaveAs 8 'Save &As...' 1 1 0 0 0 4930 1 4962 8 #fileRevert 8 '&Revert' 1 1 5026 0 16 5072 8 'Revert.ico' 5120 0 0 5314 4097 4930 1 4962 8 #saveImage 8 'Sa&ve Image' 1 1 5026 0 16 5072 8 'Snapshot.ico' 5120 0 0 4930 1 4962 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 5026 0 16 5072 8 'PowerSwitch.ico' 5120 0 0 5314 4097 4930 1 4962 8 #exit 8 '&Close' 17639 1 5026 0 16 5072 8 'CloseWindow.ico' 5120 0 0 8 '&File' 0 134217729 0 0 9931 0 0 4882 0 16 98 12 4930 1 4962 8 #undo 8 '&Undo' 9397 1 5026 0 16 5072 8 'EditUndo.ico' 5120 0 0 4930 1 4962 8 #redo 8 'R&edo' 9395 1 5026 0 16 5072 8 'EditRedo.ico' 5120 0 0 5314 4097 4930 1 4962 8 #cutSelection 8 'Cu&t' 9393 1 5026 0 16 5072 8 'EditCut.ico' 5120 0 0 4930 1 4962 8 #copySelection 8 '&Copy' 9351 1 5026 0 16 5072 8 'EditCopy.ico' 5120 0 0 4930 1 4962 8 #pasteClipboard 8 '&Paste' 9389 1 5026 0 16 5072 8 'EditPaste.ico' 5120 0 0 4930 1 4962 8 #clearSelection 8 '&Delete' 1 1 5026 0 16 5072 8 'EditClear.ico' 5120 0 0 4930 1 4962 8 #selectAll 8 'Select &All' 9347 1 0 0 0 5314 4097 4930 1 4962 8 #editFind 8 '&Find...' 9357 1 5026 0 16 5072 47 786694 ##(Smalltalk.ShellLibrary) 0 0 4930 1 4962 8 #findNext 8 'Find &Next' 1253 1 5026 0 16 5072 8 'FindNext.ico' 5120 0 0 4930 1 4962 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 134217729 0 0 9953 0 0 4882 0 16 98 16 4930 1 4962 8 #browseIt 8 '&Browse It' 9349 1 5026 0 16 5072 8 'ClassBrowserShell.ico' 5120 0 0 4930 1 4962 8 #displayIt 8 '&Display It' 9353 1 5026 0 16 5072 8 'DisplayIt.ico' 5120 0 0 4930 1 4962 8 #evaluateIt 8 '&Evaluate It' 9355 1 5026 0 16 5072 8 'EvaluateIt.ico' 5120 0 0 4930 1 4962 8 #inspectIt 8 '&Inspect It' 9363 1 5026 0 16 5072 8 'InspectIt.ico' 5120 0 0 4930 1 4962 8 #debugIt 8 'Deb&ug It' 1269 1 5026 0 16 5072 8 'Debugger.ico' 5120 0 0 4930 1 4962 8 #fileItIn 8 '&File it In' 1 1 0 0 0 5314 4097 4930 1 4962 8 #chooseEvaluationPools 8 '&Pools...' 1 1 5026 0 16 5072 8 'Dictionary.ico' 5120 0 0 4930 1 4962 8 #inspectWorkspacePool 8 '&Variables' 1 1 0 0 0 5314 4097 4930 1 4962 8 #browseDefinitions 8 'Defi&nitions...' 1271 1 0 0 0 4930 1 4962 8 #browseReferences 8 '&References...' 5367 1 0 0 0 5314 4097 4930 1 4962 8 #clear 8 'C&lear' 1 1 5026 0 16 5072 8 'ClearDocument.ico' 5120 0 0 5314 4097 4882 0 16 98 9 4930 1 4962 8 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 4930 1 4962 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 4930 1 4962 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 4930 1 4962 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 4930 1 4962 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 4930 1 4962 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 4930 1 4962 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 5314 4097 4882 0 16 98 3 4930 1 4962 2098 8 #language: 98 1 8 #container 8 '&Smalltalk' 1 1 0 0 0 4930 1 4962 2098 8528 98 1 8 #text 8 '&Text' 1 1 0 0 0 4930 1 4962 2098 8528 98 1 8 #xml 8 '&Xml' 1 1 0 0 0 8 '&Language' 0 134217729 0 0 9997 0 0 8 '&Options' 0 134217729 0 0 9999 0 0 8 '&Workspace' 0 134217729 0 0 10001 0 0 4882 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 10003 0 0 4882 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 10005 0 0 4882 0 16 98 16 4930 1 4962 8 #helpContents 8 '&Contents' 1025 1 5026 0 16 5072 49 6736 0 0 4930 1 4962 8 #help 8 'On this &Tool' 1249 1 0 0 0 4930 1 4962 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 5314 4097 4930 1 4962 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 5314 4097 4930 1 4962 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 4930 1 4962 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 4930 1 4962 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 4882 0 16 98 4 4930 2097153 4962 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 5026 0 16 5072 8 'TipOfTheDay.ico' 5120 0 0 4930 1 4962 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 5026 0 16 5072 8 'TipOfTheDay.ico' 5120 0 0 5314 4097 4930 1 4962 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 10027 0 0 5314 4097 4930 1 4962 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 4930 1 4962 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 4930 1 4962 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 5314 4097 4930 1 4962 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5026 0 16 5072 8 '!!APPLICATION' 5120 0 0 8 '&Help' 0 134217729 0 0 10037 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1026 202 208 98 2 1090 1120 98 2 770 4999 21 770 1091 921 416 1090 8 #updateMenuBar 1232 416 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 9 0 0 10 0 0 0 228 11 0 0 214 1 0 0] 98 4 560 2688 4192 1856 1248 0 27)!

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

uninitialize
	"Private - Un-register the system tools folder icon for the receiver to allow clean
	removal of this class from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self displayString;
		unregisterTool: self!

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
!SmalltalkWorkspaceDocument class categoriesFor: #activeIdeaSpace!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #canUseIdeaSpace!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #canUseIdeaSpace:!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultBackcolor!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultBackcolor:!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultCaretColor!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultCaretColor:!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultExtent!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultExtent:!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultFileExtension!constants!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultFont!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultFont:!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultModel!models!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultTabWidth!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultTabWidth:!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultView!constants!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #defaultView:!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #displayOn:!displaying!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #fileTypes!constants!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #icon!constants!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #initialize!initializing!private! !
!SmalltalkWorkspaceDocument class categoriesFor: #isRichTextFile:!helpers!private! !
!SmalltalkWorkspaceDocument class categoriesFor: #openIcon!constants!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #publishedAspects!development!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #resource_Default_view!public!resources-views! !
!SmalltalkWorkspaceDocument class categoriesFor: #reuseIfOpen!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #reuseIfOpen:!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #show!instance creation!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #textStyles!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #textStyles:!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #toolsFolderHelpId!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #toolsFolderIcon!constants!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #uninitialize!initializing!private! !
!SmalltalkWorkspaceDocument class categoriesFor: #variableTips!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #variableTips:!accessing!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #wordWrap!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #wordWrap:!accessing!options!public! !
!SmalltalkWorkspaceDocument class categoriesFor: #workspaceClass!accessing!options!public! !

SmalltalkWorkspaceDocument class methodProtocol: #installableSystemTool attributes: #(#readOnly) selectors: #(#registerAsToolWith: #unregisterAsToolWith:)!

