"Filed out from Dolphin Smalltalk"!

UI.AbstractDocumentShell
	subclass: #'Tools.SmalltalkWorkspaceDocument'
	instanceVariableNames: 'workspacePresenter searchPresenter'
	classVariableNames: 'DefaultExtent DefaultView OptionFlags'
	imports: #(#{Refactory.Browser private})
	classInstanceVariableNames: ''
	classConstants: {
			'CanUseIdeaSpaceMask' -> 16r8.
			'LanguageExtensions'
				-> (LookupTable withAll: {
								'chg' -> #container.
								'cls' -> #container.
								'ist' -> #container.
								'json' -> #json.
								'pac' -> #container.
								'pax' -> #container.
								'sml' -> #container.
								'st' -> #container.
								'ston' -> #smalltalk.
								'xml' -> #xml
							}).
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

applyOptions
	self developmentSystem applyOptionsToTool: self.
	self areVariableTipsEnabled: self class variableTips!

areVariableTipsEnabled: aBoolean
	workspacePresenter areVariableTipsEnabled: aBoolean!

canSaveState
	"Private - Answer true if the receiver can successfully have it's state saved by #saveStateOn:. Some
	tools may not be able to save their state and therefore will not be able to be exported as
	part of a IdeaSpace save operation"

	^true!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	workspacePresenter := self add: self class workspaceClass new name: 'workspace'.
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

fileLoad
	| caret |
	caret := self workspace view caretPosition.
	self hasFilename ifTrue: [self setLexer].
	super fileLoad.
	(self workspace view)
		caretPosition: caret;
		ensureCaretVisible!

fileOpen
	"Open a file in this workspace if empty, or a new workspace if not."

	<commandQuery: #queryOpenWorkspace:>
	self openWorkspace!

forgetSize
	"Forget the default size for new instances of this tool."

	<commandQuery: #hasRememberedSize>
	self class defaultExtent: nil!

getDocumentData
	"Private - Answer the data for the receiver's document"

	^self workspace text!

hasContents
	^self hasFilename or: [self getDocumentData notEmpty]!

hasNonDefaultExtent
	^self view extent ~= self class defaultExtent!

hasRememberedSize
	^DefaultExtent notNil!

help
	"Brings up a help page for the receiver"

	self model openHelpTopicForTool: self!

ideaSpace
	^#{IdeaSpaceShell} valueOrNil
		ifNotNil: [:ideaSpaceShellClass | (self topShell isKindOf: ideaSpaceShellClass) ifTrue: [self topShell]]!

inspectSystemOptions
	"Open an <AccessorInspector> on the system options."

	^self model inspectSystemOptions
		selectionOrNil: self class;
		yourself!

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

onViewAvailable
	super onViewAvailable.
	self applyOptions!

onViewOpened
	"Private - Received when the receiver's view has been connected. 
	Transfer any file contents across to the view"

	| modifiedModel |
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
	self fileLoad!

openWorkspace
	"Prompt for a workspace filename and open the contents inside the receiver."

	<commandQuery: #queryOpenWorkspace:>
	| openFilename |
	openFilename := self class getFilename.
	openFilename isNil ifTrue: [^nil].
	^self openOn: openFilename!

queryOpenWorkspace: aCommandQuery
	"We only want to open the content locally if empty and not associated with a file."

	aCommandQuery isEnabled: self hasContents not!

rememberThisSize
	"Record the size of the receiver as the default extent for its tool class."

	<commandQuery: #hasNonDefaultExtent>
	self class defaultExtent: self view designExtent!

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
						argument: ((MethodSearch newSelector: aSymbol) matchesIn: self systemModel browserEnvironment)))!

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

	self class defaultExtent ifNotNil: [:ext | self view designExtent: ext].
	^super show!

systemModel
	^self developmentSystem!

workspace
	"Answers the SmalltalkWorkspace held by the receiver."

	^workspacePresenter! !

!Tools.SmalltalkWorkspaceDocument categoriesForMethods!
applyOptions!options!private! !
areVariableTipsEnabled:!accessing!options!public! !
canSaveState!private!saved state!testing! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultHelpId!constants!public! !
developmentSystem!accessing!private! !
displayOn:!displaying!public! !
dropClassFile:!operations!private! !
dropPackageFile:!operations!private! !
dropScriptFile:!operations!private! !
dropTextFile:!operations!private! !
dropXmlFile:!operations!private! !
fileLoad!operations!public! !
fileOpen!commands-actions!public! !
forgetSize!commands-actions!public! !
getDocumentData!accessing!private! !
hasContents!public!testing! !
hasNonDefaultExtent!private!testing! !
hasRememberedSize!private!testing! !
help!commands-actions!public! !
ideaSpace!public! !
inspectSystemOptions!commands-actions!public! !
isIdeaSpaceCard!public!testing! !
isModified!public!testing! !
isModified:!modes!public! !
isText!public!testing! !
language:!options!public! !
onViewAvailable!event handling!public! !
onViewOpened!event handling!private! !
openWorkspace!commands-actions!public! !
queryOpenWorkspace:!commands-queries!private! !
rememberThisSize!commands-actions!public! !
saveStateOn:!private!saved state! !
searchForClass:!modes!private! !
searchForMethod:!operations!private! !
searchForObject:!operations!public! !
searchForPackage:!modes!public! !
searchForSymbol:!modes!private! !
searchSmalltalk!commands-actions!public! !
searchSmalltalkFor:!operations!public! !
setDocumentData:!accessing!private! !
setInitialFocus!operations!public! !
setLexer!helpers!private! !
show!operations!public! !
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

	self ensureOptionsLoaded.
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

ensureOptionsLoaded
	OptionFlags ifNil: [self loadOptions]!

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
	OptionFlags := OptionFlags bitAnd: ##(LoadingMask bitInvert)!

icon
	"Answers an Icon that can be used to represent this class"

	^SmalltalkWorkspace icon!

initialize
	"Private - Initialize the receiver. Register with SmalltalkSystem.
		self initialize
	"

	| languageExtensions |
	SmalltalkSystem current
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	languageExtensions := LookupTable new
				at: 'xml' put: #xml;
				at: 'json' put: #json;
				at: 'ston' put: #smalltalk;
				yourself.
	#('st' 'cls' 'pac' 'pax' 'chg' 'sml' 'ist')
		do: [:each | languageExtensions at: each put: #container].
	self addClassConstant: 'LanguageExtensions' value: languageExtensions!

invalidateOptions
	OptionFlags := nil!

isLoadingOptions
	^self optionFlags allMask: LoadingMask!

isRichTextFile: aString
	^aString notNil and: [((File splitExtensionFrom: aString) compareOrdinals: 'rtf' ignoringCase: true) == 0]!

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
		add: (Aspect point: #defaultExtent);
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 517 nil nil nil 160 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 6 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 304 nil nil nil 5 nil nil nil 304 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Image_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 336 8 '' 304 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 656 nil nil nil 5 nil nil nil 656 370 #{UI.Toolbar} #resource_Search_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 688 8 '' 656 3 592 610 193 193 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 896 nil nil nil 5 nil nil nil 896 370 #{UI.Toolbar} #resource_Smalltalk_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 928 8 '' 896 3 592 610 193 193 nil 27 8 'smalltalkTools' nil nil nil nil 8 #() nil nil 9 1109 #smallIcons nil nil 838 1 #{UI.FlowLayout} 1 1 1 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 97 2 0 0 25 0 0 0] 193 192 8 '' 160 3 50 4 304 896 656 18 #{UI.Toolbar} 50 28 nil 160 50 2 8 1409289036 131137 1328 nil nil nil 517 nil nil nil 1328 240 nil 258 #{Core.IdentityDictionary} 592 nil nil nil nil 50 2 1606 2 #{UI.ToolbarIconButton} 1328 1 1350 4 #{UI.CommandDescription} #fileSave 8 'Save' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'FileSave.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil nil 582 1 #{UI.ToolbarSeparator} 1328 1 nil nil 9 1 nil nil nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[11 2 0 0 0 0 0 0 42 2 0 0 25 0 0 0] 193 1360 8 '' 1328 3 8 #() 610 193 193 nil 31 610 193 193 nil 31 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140850956 1 1840 nil nil nil 5 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1840 nil nil 258 #{Core.IdentityDictionary} 50 4 1862 1 #{UI.StatusBarItem} 8193 -1 1840 nil 518 #{Core.Message} #displayString 8 #() 2050 #iconImageIndex 8 #() nil 8 'errors' 2018 8193 37 1840 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 5 1 2160 8 'doIt' 8 '[:modified | modified ifTrue: [Tools.SmalltalkSystem changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 1094 2 #{Kernel.VariableBinding} #SmalltalkSystem #{Tools.SmalltalkSystem} #{Tools} 1 #changedIcon #imageIndex 2176 #ifTrue: 7 257 nil nil 8 'modified' nil nil nil 50 2 2144 2032 1094 1 #{UI.StatusBarNullItem} 8705 1 1840 nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 173 1 0 0 97 2 0 0 195 1 0 0] 193 1872 8 '' 1840 3 8 #() 610 193 193 nil 29 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853708 131073 2528 nil nil nil 517 nil nil nil 2528 240 nil 258 #{Core.IdentityDictionary} 50 6 18 #{UI.ReferenceView} 50 14 nil 2528 50 2 8 1140850688 131073 2624 nil nil nil 5 nil nil nil 2624 370 #{UI.Toolbar} #resource_Edit_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 174 0 0 0 23 0 0 0 38 1 0 0] 193 2656 8 '' 2624 3 592 610 193 193 nil 27 8 'edit tools' 18 #{UI.ReferenceView} 50 14 nil 2528 50 2 8 1140850688 131073 2864 nil nil nil 5 nil nil nil 2864 370 #{UI.Toolbar} #resource_Find_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 120 0 0 0 23 0 0 0 174 0 0 0] 193 2896 8 '' 2864 3 592 610 193 193 nil 27 8 'find tools' 18 #{UI.ReferenceView} 50 14 nil 2528 50 2 8 1140850688 131073 3104 nil nil nil 5 nil nil nil 3104 370 #{UI.Toolbar} #resource_Workspace_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 23 0 0 0 120 0 0 0] 193 3136 8 '' 3104 3 592 610 193 193 nil 27 8 'workspace tools' nil nil nil nil 8 #() nil nil 9 139 #smallIcons nil nil 1154 1 1 1 402 50 1 450 #createWindow: 50 1 498 530 8 #[74 2 0 0 25 0 0 0 97 2 0 0 173 1 0 0] 193 2560 8 '' 2528 3 50 3 3104 2864 2624 610 193 193 nil 31 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 393217 3536 nil nil nil 5 nil nil nil 3536 130 1 1 nil nil nil nil 18 #{UI.ReferenceView} 50 14 nil 3536 50 2 8 1140916224 131073 3616 nil nil nil 21 nil nil nil 3616 370 #{Tools.SmalltalkWorkspace} #resource_Default_view nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 72 2 0 0 146 1 0 0] 193 3648 8 '' 3616 3 592 610 193 193 nil 27 258 #{Core.IdentityDictionary} 50 2 3616 8 'workspace' nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 25 0 0 0 74 2 0 0 173 1 0 0] 193 3568 8 '' 3536 3 50 1 3616 610 193 193 nil 27 258 #{Core.IdentityDictionary} 50 6 1840 8 'statusbar' 160 8 'toolbar' 2528 8 'toolbar2' nil 2886 4 #{UI.MenuBar} nil true 50 6 2886 4 #{UI.Menu} nil true 50 12 1094 2 #{UI.CommandMenuItem} 1 1458 #fileNew 8 '&New' 9373 1 1506 nil true 1538 8 'DocumentShell.ico' 1600 65541 nil nil nil 4226 1 1458 #fileOpen 8 '&Open…' 9375 1 1506 nil true 1538 8 'OpenWorkspace.ico' 1600 65541 nil nil nil 4226 1 1458 #fileFileIn 8 '&File In…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 4226 1 1458 #fileSave 8 '&Save' 9383 1 1506 nil true 1538 8 'FileSave.ico' 1600 65541 nil nil nil 4226 1 1458 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 4226 1 1458 #fileRevert 8 '&Revert' 1 1 2374 2 #{Graphics.TextTileIcon} 8 $🔁 nil nil 226 #commonGreen nil nil 1 nil nil nil nil 4482 4097 4226 1 1458 #saveImage 8 'Sa&ve Image' 1 1 1506 nil true 1538 8 'Snapshot.ico' 1600 65541 nil nil nil 4226 1 1458 #smalltalkExit 8 'E&xit Dolphin' 1 1 1506 nil true 1538 8 'PowerSwitch.ico' 1600 65541 nil nil nil 4482 4097 4226 1 1458 #exit 8 '&Close' 17639 1 4706 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 4178 nil true 50 12 4226 1 1458 #undo 8 '&Undo' 9397 1 1506 nil true 1538 8 'EditUndo.ico' 1600 65541 nil nil nil 4226 1 1458 #redo 8 'R&edo' 9395 1 1506 nil true 1538 8 'EditRedo.ico' 1600 65541 nil nil nil 4482 4097 4226 1 1458 #cutSelection 8 'Cu&t' 9393 1 1506 nil true 1538 8 'EditCut.ico' 1600 65541 nil nil nil 4226 1 1458 #copySelection 8 '&Copy' 9351 1 1506 nil true 1538 8 'EditCopy.ico' 1600 65541 nil nil nil 4226 1 1458 #pasteClipboard 8 '&Paste' 9389 1 1506 nil true 1538 8 'EditPaste.ico' 1600 65541 nil nil nil 4226 1 1458 #clearSelection 8 '&Delete' 1 1 1506 nil true 1538 8 'EditClear.ico' 1600 65541 nil nil nil 4226 1 1458 #selectAll 8 'Select &All' 9347 1 nil nil nil 4482 4097 4226 1 1458 #editFind 8 '&Find…' 9357 1 1506 nil true 1538 8 'Find.ico' 1600 65541 nil nil nil 4226 1 1458 #findNext 8 'Find &Next' 1253 1 1506 nil true 1538 8 'FindNext.ico' 1600 65541 nil nil nil 4226 1 1458 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 4178 nil true 50 17 4226 1 1458 #browseIt 8 '&Browse It' 9349 1 1506 nil true 1538 8 'ClassBrowserShell.ico' 1600 65541 nil nil nil 4226 1 1458 #displayIt 8 '&Display It' 9353 1 1506 nil true 1538 8 'DisplayIt.ico' 1600 65541 nil nil nil 4226 1 1458 #printIt 8 '&Print It' 9377 1 1506 nil true 1538 8 'PrintIt.ico' 1600 65541 nil nil nil 4226 1 1458 #evaluateIt 8 '&Evaluate It' 9355 1 1506 nil true 1538 8 'EvaluateIt.ico' 1600 65541 nil nil nil 4226 1 1458 #inspectIt 8 '&Inspect It' 9363 1 1506 nil true 1538 8 'InspectIt.ico' 1600 65541 nil nil nil 4226 1 1458 #debugIt 8 'Deb&ug It' 1269 1 1506 nil true 1538 8 'Debugger.ico' 1600 65541 nil nil nil 4226 1 1458 #fileItIn 8 '&File it In' 1 1 nil nil nil 4482 4097 4226 1 1458 #chooseNamespaces 8 'Na&mespaces…' 1 1 1506 nil true 1538 8 'Dictionary.ico' 1600 65541 nil nil nil 4226 1 1458 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 4482 4097 4226 1 1458 #browseDefinitions 8 'Defi&nitions…' 1271 1 nil nil nil 4226 1 1458 #browseReferences 8 '&References…' 5367 1 nil nil nil 4482 4097 4226 1 1458 #clear 8 'C&lear' 1 1 1506 nil true 1538 8 'ClearDocument.ico' 1600 65541 nil nil nil 4482 4097 4178 nil true 50 9 4226 1 1458 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4226 1 1458 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4226 1 1458 #toggleLineEndings 8 'Line &Endings' 1 1 4706 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4226 1 1458 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4226 1 1458 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4226 1 1458 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4226 1 1458 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 4482 4097 4178 nil true 50 3 4226 1 1458 2050 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 4226 1 1458 2050 #language: 8 #(#null) 8 '&Text' 1 1 nil nil nil 4226 1 1458 2050 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 1506 nil true 1538 8 'Preferences.ico' 1600 65541 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 4178 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 4178 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 4178 nil true 50 15 4226 1 1458 #helpContents 8 '&Contents' 1025 1 1506 nil true 1538 8 'Help.ico' 1600 65541 nil nil nil 4226 1 1458 #help 8 'On this &Tool' 1249 1 nil nil nil 4226 1 1458 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4482 4097 4226 1 1458 #learnSmalltalk 8 'Learn Smalltalk' 1 1 4706 8 $🎓 nil 226 #orchid 226 #white nil nil 1 nil nil nil nil 4482 4097 4226 1 1458 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4226 1 1458 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4226 1 1458 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4482 4097 4226 1 1458 #dolphinHomePage 8 'Dolphin Homepage' 1 1 1506 nil true 1538 8 '!!APPLICATION' 1600 65541 nil nil nil 4226 1 1458 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4226 1 1458 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4482 4097 4226 1 1458 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4706 8 $🐬 nil nil 226 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil nil nil 193 402 50 1 450 #createWindow: 50 1 498 518 #{Graphics.Rectangle} 610 7679 21 610 8929 1041 193 80 8 '' 32 1 50 4 160 2528 3536 1840 610 193 193 nil 27)!

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

	(self optionFlags allMask: anInteger) == aBoolean ifTrue: [^false].
	OptionFlags := OptionFlags mask: anInteger set: aBoolean.
	^self persistOptions!

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

	(self setOptionFlag: VariableTipsMask value: aBoolean)
		ifTrue: [self primAllSubinstances do: [:each | each areVariableTipsEnabled: aBoolean]]!

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
ensureOptionsLoaded!public! !
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

