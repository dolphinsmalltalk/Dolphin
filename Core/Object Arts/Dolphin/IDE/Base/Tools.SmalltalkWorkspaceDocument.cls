"Filed out from Dolphin Smalltalk"!

UI.AbstractDocumentShell
	subclass: #'Tools.SmalltalkWorkspaceDocument'
	instanceVariableNames: 'workspacePresenter searchPresenter'
	classVariableNames: 'DefaultExtent DefaultView LanguageExtensions OptionFlags'
	imports: #(#{Refactory.Browser private})
	classInstanceVariableNames: ''
	classConstants: {
			'CanUseIdeaSpaceMask' -> 16r8.
			'LoadingMask' -> 16r1.
			'ReUseIfOpenMask' -> 16r2.
			'VariableTipsMask' -> 16r4
		}!
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
	self developmentSystem applyOptionsToTool: self!

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
		to: self developmentSystem
		withArguments: {nil. self}!

defaultHelpId
	^10729!

destroy
	"Attempt to forcibly close the receiver's view. If this is an IdeaSpace card then we ask the IdeaSpace to destroy it."

	self isIdeaSpaceCard ifTrue: [^self ideaSpace destroyCard: self].
	^super destroy!

developmentSystem
	^SmalltalkSystem current!

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
	(self view viewNamed: 'errors' ifNone: nil)
		ifNotNil: [:item | item model: self workspace errorModel].
	modifiedModel := self workspace modifiedModel.
	(self view viewNamed: 'modified' ifNone: nil) ifNotNil: [:item | item model: modifiedModel].
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
	aSmalltalkWorkspaceDocument workspace namespaces: '.
	self workspace namespaces literalStoreEvaluationOn: aWriteStream.
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
						argument: (self systemModel browserEnvironment messagesMatching: (MethodSearch newSelector: aSymbol))))!

searchSmalltalk
	<acceleratorKey: 'Ctrl+Shift+F'>
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
	self language: (LanguageExtensions at: (File splitExtensionFrom: self filename) ifAbsent: #null)!

show
	"Shows the view of the receiver.
	Pick up the default extent if any."

	self class defaultExtent ifNotNil: [:ext | self view extent: ext].
	^super show!

smalltalkExit
	"Request system shutdown - may be cancelled by user."

	self model smalltalkExit!

systemModel
	^self developmentSystem!

workspace
	"Answers the SmalltalkWorkspace held by the receiver."

	^workspacePresenter! !
!Tools.SmalltalkWorkspaceDocument categoriesForMethods!
aboutDolphin!commands!public! !
applyOptions!public! !
browsePackages!commands!public! !
buildPopupForCommand:!private! !
canSaveState!private!saved state! !
chooseDefaultFont!commands!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultHelpId!public! !
destroy!commands!public! !
developmentSystem!accessing!private! !
displayOn:!displaying!public! !
dropClassFile:!commands!private! !
dropPackageFile:!commands!private! !
dropScriptFile:!commands!private! !
dropTextFile:!commands!private! !
dropXmlFile:!commands!private! !
educationCenter!commands!public! !
exit!commands!public! !
fileFileIn!commands!public! !
fileLoad!commands!public! !
fileNew!commands!public! !
fileOpen!commands!public! !
forgetSize!commands!public! !
getDocumentData!accessing!private! !
guidedTour!commands!public! !
hasContents!public! !
help!commands!public! !
ideaSpace!public! !
inspectSystemOptions!commands!public! !
isIdeaSpaceCard!public! !
isModified!public!testing! !
isModified:!modes!public! !
isText!public!testing! !
language:!public! !
onDropDown:!private! !
onViewOpened!event handling!private! !
openViewComposer!commands!public! !
openWorkspace!public! !
queryCommand:!commands!private! !
rememberThisSize!commands!public! !
saveStateOn:!private!saved state! !
searchForClass:!private! !
searchForMethod:!private! !
searchForObject:!public! !
searchForPackage:!public! !
searchForSymbol:!private! !
searchSmalltalk!commands!public! !
searchSmalltalkFor:!commands!public! !
setDocumentData:!accessing!private! !
setInitialFocus!operations!public! !
setLexer!helpers!private! !
show!operations!public! !
smalltalkExit!commands!public! !
systemModel!accessing!private! !
workspace!accessing!public! !
!

!Tools.SmalltalkWorkspaceDocument class methodsFor!

activeIdeaSpace
	^#{IdeaSpaceShell}
		ifDefined: [:ideaSpaceShellClass | (View active topShell isKindOf: ideaSpaceShellClass) ifTrue: [View active topShell]]!

canUseIdeaSpace
	"Answers true if an already open instance of the receiver should be reused instead of
	creating additional instances. In fact, it does not always make sense for a system tool
	to allow re-use. Therefore, although all tools support this functionality, only some
	expose it as a published aspect so that it may be set as a system option."

	^self optionFlags allMask: CanUseIdeaSpaceMask!

canUseIdeaSpace: aBoolean
	"Set the receiver to reuse an already open instance of the receiver instead of
	creating an additional one according to aBoolean."

	self setOptionFlag: CanUseIdeaSpaceMask value: aBoolean
!

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

defaultDefaultExtent
	^640 @ 480!

defaultExtent
	"Answer a <Point> which is the user's chosen default extent for new instances
	of the receiver, or nil if left up to Windows."

	DefaultExtent ifNil: [self loadOptions].
	^DefaultExtent ifNil: [self defaultDefaultExtent]!

defaultExtent: aPoint
	"Set the default extent to be used for instances of the receiver to the <Point> argument.
	If the argument is nil, then let Windows decide."

	DefaultExtent = aPoint ifTrue: [^self].
	DefaultExtent := aPoint.
	self persistOptions!

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

	^SmalltalkSystem current!

defaultOptionFlags
	^##(CanUseIdeaSpaceMask | VariableTipsMask)!

defaultSelectionColor
	"Answer the default selection highlight colour to use for instances of the receiver"

	^self workspaceClass defaultSelectionColor!

defaultSelectionColor: aColorOrNil 
	"Set the default selection highlight colour to use for instances of the receiver."

	self workspaceClass defaultSelectionColor: aColorOrNil!

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

	OptionFlags ifNil: [self loadOptions].
	^DefaultView ifNil: [View defaultView]!

defaultView: aString
	"Set the default view name."

	self defaultView = aString ifTrue: [^self].
	DefaultView := aString.
	self persistOptions!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Workspace'!

fileTypes
	"Answer an Array of file types that can be associated with this
	class of document."

	| domain |
	domain := self defaultModel.
	^{domain smalltalkFilesType.
		domain classFilesType.
		domain packageFilesType.
		domain ideaSpaceFilesType.
		#('Text Files (*.txt)' '*.txt').
		FileDialog allFilesType}!

finishedLoadingOptions
	OptionFlags := OptionFlags maskClear: LoadingMask!

icon
	"Answers an Icon that can be used to represent this class"

	^SmalltalkWorkspace icon!

initialize
	"Private - Initialize the receiver. Register with SmalltalkSystem.
		self initialize
	"

	SmalltalkSystem current
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	LanguageExtensions := LookupTable new
				at: 'xml' put: #xml;
				at: 'json' put: #json;
				at: 'ston' put: #smalltalk;
				yourself.
	#('st' 'cls' 'pac' 'pax' 'chg' 'sml' 'ist')
		do: [:each | LanguageExtensions at: each put: #container].
	LanguageExtensions isImmutable: true!

invalidateOptions
	OptionFlags := nil!

isLoadingOptions
	^self optionFlags allMask: LoadingMask!

isRichTextFile: aString
	^aString notNil and: [(File splitExtensionFrom: aString) equalsIgnoreCase: 'rtf']!

loadOptions
	SmalltalkToolShell loadOptionsFor: self!

openIcon
	"Answers an Icon that can be used to represent the opening of an instance from a file"

	^Icon fromId: 'FileOpen.ico'!

optionFlags
	OptionFlags ifNil: [self loadOptions].
	^OptionFlags!

optionsAspects
	"Private - Answer an <IdentityDictionary> of the <Aspect>s published by the receiver, not including those that are really just forwarders to SmalltalkWorkspace."

	| aspects |
	aspects := IdentityDictionary new.
	#(#canUseIdeaSpace #variableTips)
		do: [:each | aspects add: ((Aspect boolean: each)
						defaultValue: true;
						yourself)].
	aspects add: (Aspect boolean: #reuseIfOpen).
	aspects
		add: ((Aspect
					choice: #defaultView
					from: [self resourceNames]
					type: String)
					icon: ResourceIdentifier icon;
					defaultValue: [View defaultView];
					yourself);
		add: (Aspect extent: #defaultExtent);
		yourself.
	^aspects!

persistOptions
	^SmalltalkToolShell persistOptionsFor: self!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| answer |
	answer := super publishedAspects.
	answer addAll: self optionsAspects.
	answer add: (Aspect boolean: #wordWrap).
	#(#defaultBackcolor #defaultCaretColor #defaultSelectionColor)
		do: [:each | answer add: (Aspect color: each)].
	answer
		add: (Aspect font: #defaultFont);
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 #{Graphics.ThemeColor} #toolBackground nil 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 917510 #{Graphics.Color} #default 8 1809897712 170 192 34 6 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Smalltalk_tools nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 63 1 866 553 51 672 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 8 #() 866 193 193 nil 27 8 'smalltalkTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1008 nil nil nil 7 nil nil nil 1008 738 #{UI.Toolbar} #resource_Search_tools nil 770 34 1 818 #createAt:extent: 34 2 866 615 1 866 437 51 1008 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 960 976 nil 27 8 'searchTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1232 nil nil nil 7 nil nil nil 1232 738 #{UI.Toolbar} #resource_Image_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 63 51 1232 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 960 976 nil 27 8 'imageTools' nil nil nil 170 192 960 8 #() nil nil 1 nil 866 33 33 nil nil 852806 1 #{UI.FlowLayout} 1 1 1 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1219 51 528 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 97 2 0 0 25 0 0 0] 34 4 1232 672 1008 410 #{UI.Toolbar} 34 28 nil 528 34 2 8 1409289036 131137 1680 nil nil nil 519 nil nil nil 1680 608 8 1809897712 170 192 960 nil nil nil 170 192 34 2 46883 1311814 1 #{UI.ToolbarIconButton} 1680 1 1377606 4 #{UI.CommandDescription} #fileSave 8 'Save' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'FileSave.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil 46883 34 2 1824 1245766 1 #{UI.ToolbarSeparator} 1680 1 nil nil 1 nil nil nil nil nil 770 34 1 818 #createAt:extent: 34 2 866 1051 1 866 63 51 1680 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 44 2 0 0 25 0 0 0] 8 #() 976 nil 29 976 nil 29 410 #{UI.StatusBar} 34 21 nil 416 34 2 8 1140850956 1 2208 nil nil nil 7 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 866 193 193 nil 2208 nil 8 1809451024 170 192 34 4 1050438 1 #{UI.StatusBarItem} 8193 -1 2208 nil 786950 #{Core.Message} #displayString 8 #() 2450 #iconImageIndex 8 #() nil 8 'errors' 2418 8193 37 2208 nil nil 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 5 1 2560 8 'doIt' 8 '[:modified | modified ifTrue: [Tools.SmalltalkSystem changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 1442886 2 #{Kernel.VariableBinding} #SmalltalkSystem #{Tools.SmalltalkSystem} #{Tools} 1 #changedIcon #imageIndex 2576 #ifTrue: 7 257 nil nil 8 'modified' nil nil nil 34 2 2544 2432 1311814 1 #{UI.StatusBarNullItem} 8705 1 2208 nil nil 770 34 1 818 #createAt:extent: 34 2 866 1 859 866 1219 45 2208 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 173 1 0 0 97 2 0 0 195 1 0 0] 8 #() 976 nil 29 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1140853708 131073 2912 nil nil nil 519 nil nil nil 2912 608 8 1809897712 170 192 34 6 410 #{UI.ReferenceView} 34 14 nil 2912 34 2 8 1140850688 131073 3024 nil nil nil 7 nil nil nil 3024 738 #{UI.Toolbar} #resource_Workspace_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 47 241 3024 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 23 0 0 0 120 0 0 0] 960 976 nil 27 8 'workspace tools' 410 #{UI.ReferenceView} 34 14 nil 2912 34 2 8 1140850688 131073 3248 nil nil nil 7 nil nil nil 3248 738 #{UI.Toolbar} #resource_Edit_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1 349 866 47 241 3248 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 174 0 0 0 23 0 0 0 38 1 0 0] 960 976 nil 27 8 'edit tools' 410 #{UI.ReferenceView} 34 14 nil 2912 34 2 8 1140850688 131073 3472 nil nil nil 7 nil nil nil 3472 738 #{UI.Toolbar} #resource_Find_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1 241 866 47 109 3472 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 120 0 0 0 23 0 0 0 174 0 0 0] 960 976 nil 27 8 'find tools' nil nil nil 170 192 960 8 #() nil nil 1 nil 866 33 33 nil nil 1506 1 1 1 770 34 1 818 #createAt:extent: 34 2 866 1173 51 866 47 809 2912 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 2 0 0 25 0 0 0 97 2 0 0 173 1 0 0] 34 3 3024 3472 3248 976 nil 29 nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 393217 3904 nil nil nil 7 nil nil nil 3904 498 1 1 nil nil nil nil 410 #{UI.ReferenceView} 34 14 nil 3904 34 2 8 1140916224 131073 3984 nil nil nil 23 nil nil nil 3984 738 #{Tools.SmalltalkWorkspace} #resource_Default_view nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1169 805 3984 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 146 1 0 0] 960 976 nil 27 170 192 34 2 3984 8 'workspace' nil 770 34 1 818 #createAt:extent: 34 2 866 1 51 866 1173 809 3904 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 74 2 0 0 173 1 0 0] 34 1 3984 976 nil 27 170 192 34 6 528 8 'toolbar' 2208 8 'statusbar' 2912 8 'toolbar2' nil 658246 4 #{UI.MenuBar} nil true 34 6 461638 4 #{UI.Menu} nil true 34 12 1180742 2 #{UI.CommandMenuItem} 1 1842 #fileNew 8 '&New' 9373 1 1890 nil true 1922 8 'DocumentShell.ico' 1984 65541 nil nil nil 4562 1 1842 #fileOpen 8 '&Open…' 9375 1 1890 nil true 1922 8 'OpenWorkspace.ico' 1984 65541 nil nil nil 4562 1 1842 #fileFileIn 8 '&File In…' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 4562 1 1842 #fileSave 8 '&Save' 9383 1 1890 nil true 1922 8 'FileSave.ico' 1984 65541 nil nil nil 4562 1 1842 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 4562 1 1842 #fileRevert 8 '&Revert' 1 1 1378630 2 #{Graphics.TextTileIcon} $\x1F501 nil nil 594 #commonGreen nil nil 1 nil nil nil nil 4818 4097 4562 1 1842 #saveImage 8 'Sa&ve Image' 1 1 1890 nil true 1922 8 'Snapshot.ico' 1984 65541 nil nil nil 4562 1 1842 #smalltalkExit 8 'E&xit Dolphin' 1 1 1890 nil true 1922 8 'PowerSwitch.ico' 1984 65541 nil nil nil 4818 4097 4562 1 1842 #exit 8 '&Close' 17639 1 5042 $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 47067 nil nil 4514 nil true 34 12 4562 1 1842 #undo 8 '&Undo' 9397 1 1890 nil true 1922 8 'EditUndo.ico' 1984 65541 nil nil nil 4562 1 1842 #redo 8 'R&edo' 9395 1 1890 nil true 1922 8 'EditRedo.ico' 1984 65541 nil nil nil 4818 4097 4562 1 1842 #cutSelection 8 'Cu&t' 9393 1 1890 nil true 1922 8 'EditCut.ico' 1984 65541 nil nil nil 4562 1 1842 #copySelection 8 '&Copy' 9351 1 1890 nil true 1922 8 'EditCopy.ico' 1984 65541 nil nil nil 4562 1 1842 #pasteClipboard 8 '&Paste' 9389 1 1890 nil true 1922 8 'EditPaste.ico' 1984 65541 nil nil nil 4562 1 1842 #clearSelection 8 '&Delete' 1 1 1890 nil true 1922 8 'EditClear.ico' 1984 65541 nil nil nil 4562 1 1842 #selectAll 8 'Select &All' 9347 1 nil nil nil 4818 4097 4562 1 1842 #editFind 8 '&Find…' 9357 1 1890 nil true 1922 8 'Find.ico' 1984 65541 nil nil nil 4562 1 1842 #findNext 8 'Find &Next' 1253 1 1890 nil true 1922 8 'FindNext.ico' 1984 65541 nil nil nil 4562 1 1842 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 47089 nil nil 4514 nil true 34 17 4562 1 1842 #browseIt 8 '&Browse It' 9349 1 1890 nil true 1922 8 'ClassBrowserShell.ico' 1984 65541 nil nil nil 4562 1 1842 #displayIt 8 '&Display It' 9353 1 1890 nil true 1922 8 'DisplayIt.ico' 1984 65541 nil nil nil 4562 1 1842 #printIt 8 '&Print It' 9377 1 1890 nil true 1922 8 'PrintIt.ico' 1984 65541 nil nil nil 4562 1 1842 #evaluateIt 8 '&Evaluate It' 9355 1 1890 nil true 1922 8 'EvaluateIt.ico' 1984 65541 nil nil nil 4562 1 1842 #inspectIt 8 '&Inspect It' 9363 1 1890 nil true 1922 8 'InspectIt.ico' 1984 65541 nil nil nil 4562 1 1842 #debugIt 8 'Deb&ug It' 1269 1 1890 nil true 1922 8 'Debugger.ico' 1984 65541 nil nil nil 4562 1 1842 #fileItIn 8 '&File it In' 1 1 nil nil nil 4818 4097 4562 1 1842 #chooseNamespaces 8 'Na&mespaces…' 1 1 1890 nil true 1922 8 'Dictionary.ico' 1984 65541 nil nil nil 4562 1 1842 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 4818 4097 4562 1 1842 #browseDefinitions 8 'Defi&nitions…' 1271 1 nil nil nil 4562 1 1842 #browseReferences 8 '&References…' 5367 1 nil nil nil 4818 4097 4562 1 1842 #clear 8 'C&lear' 1 1 1890 nil true 1922 8 'ClearDocument.ico' 1984 65541 nil nil nil 4818 4097 4514 nil true 34 9 4562 1 1842 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4562 1 1842 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4562 1 1842 #toggleLineEndings 8 'Line &Endings' 1 1 5042 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4562 1 1842 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4562 1 1842 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4562 1 1842 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4562 1 1842 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 4818 4097 4514 nil true 34 3 4562 1 1842 2450 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 4562 1 1842 2450 #language: 8 #(#null) 8 '&Text' 1 1 nil nil nil 4562 1 1842 2450 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil 47135 nil nil 8 '&Options' nil 134217729 1890 nil true 1922 8 'Preferences.ico' 1984 65541 nil nil 47137 nil nil 8 '&Workspace' nil 134217729 nil nil 47139 nil nil 4514 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 47141 nil nil 4514 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 47143 nil nil 4514 nil true 34 15 4562 1 1842 #helpContents 8 '&Contents' 1025 1 1890 nil true 1922 8 'Help.ico' 1984 65541 nil nil nil 4562 1 1842 #help 8 'On this &Tool' 1249 1 nil nil nil 4562 1 1842 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4818 4097 4562 1 1842 #learnSmalltalk 8 'Learn Smalltalk' 1 1 5042 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 4818 4097 4562 1 1842 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4562 1 1842 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4562 1 1842 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4818 4097 4562 1 1842 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 1890 nil true 1922 8 '!!APPLICATION' 1984 65541 nil nil nil 4562 1 1842 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4562 1 1842 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4818 4097 4562 1 1842 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5042 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 47167 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 34 1 818 #createAt:extent: 34 2 866 12287 21 866 1251 1021 416 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 112 26 0 0 8 2 0 0] 34 4 528 2912 3904 2208 976 nil 27)!

reuseIfOpen
	"Answers true if an already open instance of the receiver should be reused instead of
	creating additional instances. In fact, it does not always make sense for a system tool
	to allow re-use. Therefore, although all tools support this functionality, only some
	expose it as a published aspect so that it may be set as a system option."

	^self optionFlags allMask: ReUseIfOpenMask!

reuseIfOpen: aBoolean
	"Set the receiver to reuse an already open instance of the receiver instead of
	creating an additional one according to aBoolean."

	self setOptionFlag: ReUseIfOpenMask value: aBoolean
!

setDefaultOptions
	OptionFlags := ##(LoadingMask | CanUseIdeaSpaceMask | VariableTipsMask).
	DefaultView := DefaultExtent := nil!

setOptionFlag: anInteger value: aBoolean
	"Private - Set the receiver to reuse an already open instance of the receiver instead of
	creating an additional one according to aBoolean."

	(self optionFlags allMask: anInteger) == aBoolean ifTrue: [^self].
	OptionFlags := OptionFlags mask: anInteger set: aBoolean.
	self persistOptions!

show
	"Shows an instance of the receiver. If reuseIfOpen has been set to true then an 
	existing instance of the receiver will be shown and answered rather than
	a new instance."

	(self canUseIdeaSpace and: [SmalltalkToolShell activeIdeaSpace notNil])
		ifTrue: [^SmalltalkToolShell show: self inIdeaSpace: SmalltalkToolShell activeIdeaSpace].
	self reuseIfOpen
		ifTrue: [(SmalltalkToolShell showExistingInstanceOf: self) ifNotNil: [:tool | ^tool]].
	^super show!

startLoadingOptions
	OptionFlags := LoadingMask!

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
	"Answer whether tooltips will be displayed to show the value of workspace variables that the user hovers the mouse over."

	^self optionFlags allMask: VariableTipsMask!

variableTips: aBoolean 
	"Set whether tooltips will be displayed to show the value of workspace variables that the user hovers the mouse over.
	Note that this works even when the workspace is in the background, and uses a relatively high frequency timer to 
	detect the dwell. It has a certain CPU overhead, and so you may want to disable it if running on battery."

	self setOptionFlag: VariableTipsMask value: aBoolean!

wordWrap
	"Answer true if instances of the receiver use word wrapping by default."

	^self workspaceClass wordWrap!

wordWrap: aBoolean 
	"Sets the word wrapping state for instances of the receiver to aBoolean."

	self workspaceClass wordWrap: aBoolean!

workspaceClass
	^SmalltalkSystem current workspaceClass! !
!Tools.SmalltalkWorkspaceDocument class categoriesForMethods!
activeIdeaSpace!helpers!private! !
canUseIdeaSpace!options!public! !
canUseIdeaSpace:!options!public! !
defaultBackcolor!options!public! !
defaultBackcolor:!options!public! !
defaultCaretColor!options!public! !
defaultCaretColor:!options!public! !
defaultDefaultExtent!constants!options!private! !
defaultExtent!options!public! !
defaultExtent:!options!public! !
defaultFileExtension!constants!public! !
defaultFont!options!public! !
defaultFont:!options!public! !
defaultModel!models!public! !
defaultOptionFlags!constants!private! !
defaultSelectionColor!options!public! !
defaultSelectionColor:!options!public! !
defaultTabWidth!options!public! !
defaultTabWidth:!options!public! !
defaultView!options!public! !
defaultView:!options!public! !
displayOn:!displaying!public! !
fileTypes!constants!public! !
finishedLoadingOptions!options!private! !
icon!constants!public! !
initialize!initializing!private! !
invalidateOptions!private! !
isLoadingOptions!options!private! !
isRichTextFile:!helpers!private! !
loadOptions!options!private! !
openIcon!constants!public! !
optionFlags!options!private! !
optionsAspects!private! !
persistOptions!options!private! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
reuseIfOpen!options!public! !
reuseIfOpen:!options!public! !
setDefaultOptions!options!private! !
setOptionFlag:value:!options!private! !
show!instance creation!public! !
startLoadingOptions!options!private! !
textStyles!options!public! !
textStyles:!options!public! !
toolsFolderHelpId!public! !
toolsFolderIcon!constants!public! !
variableTips!options!public! !
variableTips:!options!public! !
wordWrap!options!public! !
wordWrap:!options!public! !
workspaceClass!options!public! !
!

Tools.SmalltalkWorkspaceDocument class methodProtocol: #installableSystemTool attributes: #(#readOnly) selectors: #(#registerAsToolWith: #unregisterAsToolWith:)!

