"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.OAIDEExtensions'
	instanceVariableNames: 'flags'
	classVariableNames: 'Current'
	imports: #(#{Smalltalk.SHDocVwConstants private})
	classInstanceVariableNames: ''
	classConstants: {
		'ClassCommentTemplateMask' -> 16r1.
		'KeyHelpMask' -> 16r2
	}!
Tools.OAIDEExtensions guid: (Core.GUID fromString: '{7803cf6a-7f63-44a5-80a6-feb5e0af07a2}')!
Tools.OAIDEExtensions comment: 'Class to host Object Arts extensions to the standard Dolphin IDE tools.

This is mainly intended as a sample to demonstrate how to implement IDE extensions in Dolphin. It illustrates:
- how to intercept the opening of new tools of particular classes (i.e. hooking the class #viewOpened: event) 
- how to find and modify menus in the view
- using <ClosedCommandDescription>s to build "closed" commands that are pre-targeted at a particular receiver and which can manage their own enablement/disablement state.
- registering with the system to appear in ''User Preferences'' so that extensions can be enabled and disabled by the user.
- use of the IE web browser control to display generated HTML.'!
!Tools.OAIDEExtensions categoriesForClass!Kernel-Objects! !
!Tools.OAIDEExtensions methodsFor!

allToolClasses
	^Tools.SmalltalkToolShell allSubclasses copyWith: Tools.SmalltalkWorkspaceDocument!

allVisibleSubViewsOf: aView do: aMonadicValuable 
	"Enumerate the visible sub-views of aView."

	aView subViewsDo: 
			[:each | 
			| isShell |
			isShell := each isKindOf: ShellView.
			isShell ifFalse: [aMonadicValuable value: each].
			(each hasVisibleStyle or: [isShell not]) 
				ifTrue: [self allVisibleSubViewsOf: each do: aMonadicValuable]]!

baseProtocolFor: anObject named: aStringName
	"Private - Answers a <readableString> that best describes the base protocol
	or class of anObject. A descriptive name is passed in aStringName."

	| protos classProtocol default |
	protos := anObject class allProtocols collect: [:each | each displayString].
	classProtocol := '%<<1p>>' expandMacrosWith: anObject class.
	default := (protos detect: [:each | each = classProtocol] ifNone: [classProtocol]) asValue.
	protos add: anObject class name.
	^(ChoicePrompter
		on: default
		choices: protos asSortedCollection
		caption: ('Protocol for <1s>=<2p>' expandMacrosWith: aStringName with: anObject)) isNil
		ifTrue: [OperationAborted signal]
		ifFalse: [default value]!

browseKeyBindingsOfShell: aShellView
	"... and then we can stuff in the HTML"

	| stream presenter browser shell |
	stream := ReadWriteStream on: String new.
	stream nextPutAll: '<HTML>'.
	self printInlineStyleSheetOn: stream.
	stream nextPutAll: '<BODY>'.
	self printHtmlDescriptionOfKeyBindingsForShell: aShellView on: stream.
	stream nextPutAll: '</BODY></HTML>'.
	shell := Shell create.
	(shell view)
		extent: 430 @ 600;
		layoutManager: GridLayout new;
		largeIcon: (Icon fromId: 'HotKey.ico');
		isPersistentView: false.
	shell caption: ('<1d> Key Bindings' expandMacrosWith: aShellView presenter class).
	presenter := Smalltalk.URLPresenter createIn: shell.
	shell show.
	browser := presenter view controlDispatch.
	stream reset.
	self streamHtml: stream intoBrowser: browser!

classBrowserClasses
	^Tools.ClassBrowserAbstract allSubclasses!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Object Arts IDE Extensions'!

enableClassCommentTemplate
	^flags allMask: ClassCommentTemplateMask!

enableClassCommentTemplate: aBoolean
	flags := flags mask: ClassCommentTemplateMask set: aBoolean!

enableKeyBindingsHelp
	^flags allMask: KeyHelpMask!

enableKeyBindingsHelp: aBoolean
	flags := flags mask: KeyHelpMask set: aBoolean!

extendClassCommentMenu: aClassBrowserAbstract
	| commentWorkspaceMenu plugin |
	plugin := aClassBrowserAbstract loadedPlugins
				detect: [:each | each isKindOf: Tools.ClassCommentPlugin]
				ifNone: [].
	plugin isNil ifTrue: [^self].
	commentWorkspaceMenu := (plugin presenterNamed: 'text') view contextMenu.
	commentWorkspaceMenu
		addSeparator;
		addCommandDescription: (ClosedCommandDescription
					command: #emitClassLayoutDescription
					description: 'Emit Class Layout Description'
					queryBlock: [:query | query isEnabled: plugin browser hasClassSelected]
					receiver: plugin)!

extendHelpMenu: aSmalltalkToolShell
	| shellView |
	shellView := aSmalltalkToolShell view.
	shellView menuBar
		ifNotNil: 
			[:menuBar |
			(menuBar findCommand: #help)
				ifNotNil: 
					[:helpMenu |
					helpMenu
						insertItem: ((CommandMenuItem commandDescription: (ClosedCommandDescription
										command: (Message selector: #browseKeyBindingsOfShell: argument: shellView)
										description: '&Key Bindings'
										receiver: self))
								image: Keyboard icon;
								yourself)
						at: (4 min: helpMenu size)]]!

initialize
	"Private - 
		self initialize
	"

	flags := ClassCommentTemplateMask | KeyHelpMask.
	self observeToolEvents.
	Smalltalk developmentSystem registerTool: self!

nonClassBrowserTools
	^self allToolClasses difference: self classBrowserClasses!

observeBrowserClass: aClassBrowserClass 
	aClassBrowserClass 
		when: #viewOpened:
		send: #onBrowserOpened:
		to: self!

observeSystemEvents
	Smalltalk developmentSystem 
		when: #classAdded:
		send: #onClassAdded:
		to: self!

observeToolClass: aSmalltalkToolShellClass 
	aSmalltalkToolShellClass 
		when: #viewOpened:
		send: #onToolOpened:
		to: self!

observeToolEvents
	self observeSystemEvents.
	self classBrowserClasses do: [:each | self observeBrowserClass: each].
	self nonClassBrowserTools do: [:each | self observeToolClass: each]!

onBrowserOpened: aClassBrowserAbstract 
	self enableClassCommentTemplate 
		ifTrue: [[self extendClassCommentMenu: aClassBrowserAbstract] postToMessageQueue].
	self onToolOpened: aClassBrowserAbstract!

onClassAdded: aClass
	(aClass inheritsFrom: Tools.SmalltalkToolShell)
		ifTrue: 
			[(aClass inheritsFrom: Tools.ClassBrowserAbstract)
				ifTrue: [self observeBrowserClass: aClass]
				ifFalse: [self observeToolClass: aClass]]!

onToolOpened: aSmalltalkToolShell
	self enableKeyBindingsHelp ifTrue: [self extendHelpMenu: aSmalltalkToolShell]!

printHtmlDescriptionOfKeyBindingsForShell: aShellView on: aPuttableStream
	| topShell global |
	topShell := aShellView topShell view.
	global := self
				printHtmlTableOfKeyBindingsForView: topShell
				on: aPuttableStream
				inUse: Set new.
	self allVisibleSubViewsOf: topShell
		do: 
			[:each |
			self
				printHtmlTableOfKeyBindingsForView: each
				on: aPuttableStream
				inUse: global]!

printHtmlTableOfKeyBindingsForView: aView on: aPuttableStream inUse: aSet
	| acceleratorKeys commands |
	acceleratorKeys := Set new.
	commands := aView keyboardCommands
				asSortedCollection: [:a :b | a acceleratorKeyDisplayString < b acceleratorKeyDisplayString].
	commands notEmpty
		ifTrue: 
			[| stream path |
			stream := String writeStream.
			{aView} , aView allParents reverseDo: 
					[:each |
					each name
						ifNotNil: 
							[:name |
							stream isEmpty ifFalse: [stream nextPut: $/].
							stream nextPutAll: name asPhrase]].
			path := stream contents.
			path isEmpty
				ifFalse: 
					[aPuttableStream
						nextPutAll: '<h2>';
						display: path;
						nextPutAll: '</h2>'].
			aPuttableStream
				nextPutAll: '<TABLE class="clsStd"';
				nextPutAll: '<TR><TH>Accelerator</TH>';
				nextPutAll: '<TH>Command</TH>';
				nextPutAll: '<TH>Description</TH>';
				nextPutAll: '</TR>'.
			commands do: 
					[:each |
					| duplicate |
					duplicate := (aSet includes: each acceleratorKey)
								or: [acceleratorKeys includes: each acceleratorKey].
					aPuttableStream nextPutAll: '<TR align=left><TD>'.
					duplicate ifTrue: [aPuttableStream nextPutAll: '<b>'].
					aPuttableStream nextPutAll: each acceleratorKeyDisplayString.
					duplicate ifTrue: [aPuttableStream nextPutAll: '</b>'].
					aPuttableStream
						nextPutAll: '</TD><TD>';
						print: each command;
						nextPutAll: '</TD><TD>';
						nextPutAll: (each description copyWithout: $&);
						nextPutAll: '</TD></TR>'.
					acceleratorKeys add: each acceleratorKey].
			aPuttableStream nextPutAll: '</TABLE>'].
	^acceleratorKeys!

printInlineStyleSheetOn: aWriteStream 
	aWriteStream 
		nextPutAll: '<STYLE TYPE="text/css">

	BODY { font:normal 68% verdana,arial,helvetica; }

	TD, TH { font-size:68%; }

	H1 {
		font:normal 165% verdana,arial,helvetica;
		margin:5 0;
		margin-top:0px;
	}

	H2 {
		font:bold 125% verdana,arial,helvetica;
		margin-top:1em; margin-bottom:0.5em;
	}

	TABLE.clsStd TH {
		text-align:left; vertical-align:top;
		background-color:#DDD;
		padding:2px;
	}

	TABLE.clsStd TD {
		vertical-align:top;
		background-color:#EEE;
		padding:2px;
	}
	
</STYLE>'!

release
	"Private - Remove references to objects that may refer back to the receiver."

	super release.
	Smalltalk developmentSystem unregisterTool: self.
	self allToolClasses do: [:each | each removeEventsTriggeredFor: self]!

streamHtml: aStream intoBrowser: browser
	| doc docStream |
	doc := browser document.
	docStream := doc queryInterface: OS.COM.IPersistStreamInit.
	docStream initNew.
	docStream readFrom: (aStream queryInterface: OS.COM.IStream)!

variableDescriptionsFor: aClass
	"Private - Answers a <readableString> that describes the instance variables and
	class variables for aClass. This method is simplistic, in that it relies on the availability
	of an instance of aClass to perform its work. First it tries to locate an existing instance 
	but if this fails then #new is used to instantiate one afresh. This may not be a sensible thing
	to do for all classes, and may cause an error."

	| names stream instance instances |
	instances := aClass allSubinstances.
	instance := instances isEmpty ifTrue: [aClass new] ifFalse: [instances first].
	stream := WriteStream on: String new.
	names := aClass instVarNames.
	names notEmpty
		ifTrue: 
			[stream
				nextPutAll: '## Instance Variables:';
				cr.
			names do: 
					[:each |
					| index var |
					index := aClass indexOfInstVar: each.
					var := instance instVarAt: index.
					stream
						space;
						space;
						nextPut: $`;
						nextPutAll: each;
						nextPut: $`;
						tab: 2;
						nextPut: $`;
						nextPutAll: (self baseProtocolFor: var named: each);
						nextPut: $`;
						cr].
			stream cr].
	names := aClass classVariableNames asSortedCollection.
	names notEmpty
		ifTrue: 
			[stream
				nextPutAll: '## Class Variables:';
				cr.
			names do: 
					[:each |
					| var |
					var := aClass classPool at: each.
					stream
						space;
						space;
						nextPut: $`;
						nextPutAll: each;
						nextPut: $`;
						tab: 2;
						nextPut: $`;
						nextPutAll: (self baseProtocolFor: var named: each);
						nextPut: $`;
						cr].
			stream cr].
	names := aClass class instVarNames.
	names notEmpty
		ifTrue: 
			[stream
				nextPutAll: '## Class Instance Variables:';
				cr.
			names do: 
					[:each |
					| index var |
					index := aClass class indexOfInstVar: each.
					var := instance class instVarAt: index.
					(stream
						space;
						space)
						nextPut: $`;
						nextPutAll: each;
						nextPut: $`;
						tab: 2;
						nextPut: $`;
						nextPutAll: (self baseProtocolFor: var named: each);
						nextPut: $`;
						cr].
			stream cr].
	^stream contents! !
!Tools.OAIDEExtensions categoriesFor: #allToolClasses!constants!private! !
!Tools.OAIDEExtensions categoriesFor: #allVisibleSubViewsOf:do:!helpers!private! !
!Tools.OAIDEExtensions categoriesFor: #baseProtocolFor:named:!development!private! !
!Tools.OAIDEExtensions categoriesFor: #browseKeyBindingsOfShell:!operations!private! !
!Tools.OAIDEExtensions categoriesFor: #classBrowserClasses!constants!private! !
!Tools.OAIDEExtensions categoriesFor: #displayOn:!initializing!public! !
!Tools.OAIDEExtensions categoriesFor: #enableClassCommentTemplate!accessing!public! !
!Tools.OAIDEExtensions categoriesFor: #enableClassCommentTemplate:!accessing!public! !
!Tools.OAIDEExtensions categoriesFor: #enableKeyBindingsHelp!accessing!public! !
!Tools.OAIDEExtensions categoriesFor: #enableKeyBindingsHelp:!accessing!public! !
!Tools.OAIDEExtensions categoriesFor: #extendClassCommentMenu:!event handling!private! !
!Tools.OAIDEExtensions categoriesFor: #extendHelpMenu:!helpers!private! !
!Tools.OAIDEExtensions categoriesFor: #initialize!initializing!private! !
!Tools.OAIDEExtensions categoriesFor: #nonClassBrowserTools!accessing!private! !
!Tools.OAIDEExtensions categoriesFor: #observeBrowserClass:!initializing!private! !
!Tools.OAIDEExtensions categoriesFor: #observeSystemEvents!initializing!private! !
!Tools.OAIDEExtensions categoriesFor: #observeToolClass:!initializing!private! !
!Tools.OAIDEExtensions categoriesFor: #observeToolEvents!initializing!private! !
!Tools.OAIDEExtensions categoriesFor: #onBrowserOpened:!event handling!private! !
!Tools.OAIDEExtensions categoriesFor: #onClassAdded:!event handling!private! !
!Tools.OAIDEExtensions categoriesFor: #onToolOpened:!event handling!private! !
!Tools.OAIDEExtensions categoriesFor: #printHtmlDescriptionOfKeyBindingsForShell:on:!helpers!private! !
!Tools.OAIDEExtensions categoriesFor: #printHtmlTableOfKeyBindingsForView:on:inUse:!helpers!private! !
!Tools.OAIDEExtensions categoriesFor: #printInlineStyleSheetOn:!private! !
!Tools.OAIDEExtensions categoriesFor: #release!dependency!private! !
!Tools.OAIDEExtensions categoriesFor: #streamHtml:intoBrowser:!operations!private! !
!Tools.OAIDEExtensions categoriesFor: #variableDescriptionsFor:!development!private! !

!Tools.OAIDEExtensions class methodsFor!

current
	^Current!

initialize
	"
		self initialize
	"

	self uninitialize.
	Current := super new initialize.
!

new
	"Use #current"

	^self shouldNotImplement!

onPreStripImage
	self uninitialize!

publishedAspectsOfInstances
	"Answer a <LookupTable> of the <Aspect>s published by instances of the receiver."

	^super publishedAspectsOfInstances
		add: (Tools.Aspect boolean: #enableKeyBindingsHelp);
		add: (Tools.Aspect boolean: #enableClassCommentTemplate);
		yourself!

uninitialize
	"
		self uninitialize
	"

	Current isNil ifTrue: [^self].
	Current release.
	Current := nil! !
!Tools.OAIDEExtensions class categoriesFor: #current!accessing!public! !
!Tools.OAIDEExtensions class categoriesFor: #initialize!initializing!public! !
!Tools.OAIDEExtensions class categoriesFor: #new!instance creation!public! !
!Tools.OAIDEExtensions class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Tools.OAIDEExtensions class categoriesFor: #publishedAspectsOfInstances!constants!development!public! !
!Tools.OAIDEExtensions class categoriesFor: #uninitialize!class hierarchy-removing!public! !

