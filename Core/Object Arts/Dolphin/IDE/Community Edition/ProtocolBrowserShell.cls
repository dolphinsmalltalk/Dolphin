"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #ProtocolBrowserShell
	instanceVariableNames: 'protocolsPresenter selectorsPresenter classesPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProtocolBrowserShell guid: (GUID fromString: '{e168a511-4549-11d3-9fe9-00a0cc3e4a32}')!
ProtocolBrowserShell comment: 'ProtocolBrowserShell is a <SmalltalkToolShell> that implements the Protocol Browser tool. This displays a list of all the <MethodProtocol>s known to the system. Selecting a protocol displays the selectors within it and the classes that conform to it. From within the Protocol Browser it is possible to perform a wide range of protocol housekeeping activities.

Instance Variables:
	protocolsPresenter		<ListPresenter> holding the list of installed protocols.
	selectorsPresenter		<ListPresenter> holding a list of messages for the selected protocol.
	classesPresenter		<ListPresenter> holding a list of classes conforming to be selected protocol.


'!
!ProtocolBrowserShell categoriesForClass!Development!MVP-Presenters! !
!ProtocolBrowserShell methodsFor!

actualClass
	"Answer the currently selected Class in the receiver, or
	nil if there is none"

	^classesPresenter selectionOrNil!

actualClass: aClass
	"Select the <Class> aClass in the receiver"

	^classesPresenter selectionOrNil: aClass!

addClass
	"Adds the selected class to the currently selected protocol"

	| chosenClass |
	(chosenClass := ChoicePrompter 
		choices: Class allBehaviors asSortedCollection
		caption: 'Choose a Class to add to', self protocol displayString) notNil ifTrue: [
		self model addClass: chosenClass toProtocol: self protocol ]

!

addProtocol
	"Prompts for a new protocol to be added to the system"

	| name |
	(name := Prompter prompt: 'Protocol name:') notNil 
		ifTrue: 
			[| newProtocol |
			newProtocol := Object methodProtocolClass name: name.
			self
				refreshProtocols;
				protocol: newProtocol]!

addSelector
	"Prompts for a new selector to be added to the currently selected protocol"

	| chosenSelector |
	(chosenSelector := Prompter prompt: 'Add Selector:') notNil 
		ifTrue: 
			[chosenSelector := chosenSelector asSymbol.
			(Compiler isValidSelector: chosenSelector) 
				ifFalse: 
					[MessageBox errorMsg: ('Sorry, but <1p> is not a valid selector' expandMacrosWith: chosenSelector).
					^self].
			self model addSelectors: (Array with: chosenSelector asSymbol) toProtocol: self protocol]!

addSelectors
	"Prompts for a collection of selector to be added to the currently selected protocol."

	| protocol newSelectors oldSelectors |
	protocol := self protocol.
	oldSelectors := protocol selectors.
	(newSelectors := self model chooseSelectorsInProtocol: protocol forClass: self actualClass) 
		notNil 
			ifTrue: 
				[| added removed |
				added := newSelectors difference: oldSelectors.
				self model addSelectors: added toProtocol: protocol.
				removed := oldSelectors difference: newSelectors.
				self model removeSelectors: removed fromProtocol: protocol]!

browseMethods
	"Browse all the methods which are in the currently selected protocols."

	self model browseMethodProtocols: (Array with: self protocol)!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	protocolsPresenter := self 
				add: ListPresenter new beSorted
				name: 'protocols'
				helpId: 10867.
	selectorsPresenter := self 
				add: ListPresenter new beSorted
				name: 'selectors'
				helpId: 10868.
	classesPresenter := self 
				add: ClassHierarchySelector new
				name: 'classes'
				helpId: 10869!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	protocolsPresenter
		when: #selectionChanged
			send: #onProtocolSelected
			to: self;
		when: #dragOver:
			send: #onDragOverProtocol:
			to: self model;
		when: #drop:
			send: #onDropOverProtocol:
			to: self model;
		when: #drag:
			send: #onDragProtocol:
			to: self.
	selectorsPresenter 
		when: #selectionChanged
		send: #onSelectorSelected
		to: self.
	classesPresenter 
		when: #actionPerformed
		send: #browseIt
		to: classesPresenter.
	(self model)
		when: #protocolUpdated:
			send: #onProtocolUpdated:
			to: self;
		when: #protocolRemoved:
			send: #onProtocolRemoved:
			to: self!

defaultHelpId
	^10873!

hasActualClass
	"Answer true if the receiver has a class selected"

	^self actualClass notNil!

hasProtocol
	"Answer true if the receiver has a protocol selected"

	^self protocol notNil!

hasSelectors
	"Answer true if the receiver has one or more selectors selected"

	^self selectors notEmpty!

onDragProtocol: session
	"Private - A protocol drag has been started. Just extend the available formats
	to mention the availability of MethodProtocols."

	session dragObjects do: [:dragee | dragee format: #MethodProtocol data: (dragee format: #Object)].!

onProtocolRemoved: aMethodProtocol
	"Private - The <MethodProtocol>, aMethodProtocol, has been removed from the system.
	Update the protocols list."

	protocolsPresenter model remove: aMethodProtocol!

onProtocolSelected
	"Private - A new protocol has been selected."

	selectorsPresenter clear.
"	classesPresenter
		model: (ClassHierarchyModel withRoots: 	
		filter: [:x | false])."
	self hasProtocol ifTrue: [ 
		selectorsPresenter list: self protocol selectors.
		self onSelectorSelected ]
		ifFalse: [classesPresenter model: TreeModel new].
	self updateCaption

!

onProtocolUpdated: aMethodProtocol 
	"Private - The <MethodProtocol>, aMethodProtocol, has been updated in some manner
	(normally by having classes/selectors added/removed). Inform interested parties."

	| protocolList idx |
	protocolList := protocolsPresenter model.
	idx := protocolList indexOf: aMethodProtocol.
	idx isZero 
		ifTrue: [protocolList add: aMethodProtocol]
		ifFalse: 
			[protocolList refreshAtIndex: idx.
			self protocol == aMethodProtocol ifTrue: [self onProtocolSelected]]!

onSelectorSelected
	"Private - A selector has been selected."

	| conformingClasses protocol selectors header |

	protocol := self protocol.
	selectors := self selectors.

	conformingClasses := ClassHierarchyModel withRoots: protocol baseBehaviors.

	selectors notEmpty
		ifTrue: [
			header := 'Implementing Classes'.
			conformingClasses filter: [:class | (class selectors intersection: selectors) notEmpty]]
		ifFalse: [header := 'Conforming Classes'].

	classesPresenter model: conformingClasses.
	(view viewNamed: 'classesCaption') text: header!

onTipTextRequired: tool 
	"Tool tip text is required for the <ToolbarItem>, tool."

	| cmd prot |
	cmd := tool command asSymbol.
	prot := self protocol.
	cmd == #toggleANSI 
		ifTrue: 
			[^'Make <1d> a<2s>ANSI protocol' expandMacrosWith: prot
				with: (prot isANSI ifTrue: [' non-'] ifFalse: ['n '])].
	cmd == #toggleReadOnly 
		ifTrue: 
			[^'<1s> <2d>' expandMacrosWith: (prot isReadOnly ifTrue: ['Unlock'] ifFalse: ['Lock']) with: prot].
	^super onTipTextRequired: tool!

onViewOpened
	"Received when the receiver's view is been connected. "

	super onViewOpened.
	self refreshProtocols
!

protocol
	"Answer the currently selected method protocol in the receiver, or
	nil if there is none"

	^protocolsPresenter selectionOrNil!

protocol: aMethodProtocol
	"Sets the currently selected method protocol in the receiver to aMethodProtocol"

	^protocolsPresenter selectionOrNil: aMethodProtocol!

purgeUnused
	"Purge all unused protocols from the system"

	Object methodProtocolClass purgeUnused.
	self refreshProtocols!

queryCommand: query 
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>, query"

	| cmd |
	cmd := query command.
	#toggleANSI == cmd 
		ifTrue: 
			[self hasProtocol 
				ifTrue: 
					[query
						isChecked: self protocol isANSI;
						isEnabled: true]
				ifFalse: 
					[query
						isChecked: false;
						isEnabled: false].
			^true].
	#toggleReadOnly == cmd 
		ifTrue: 
			[self hasProtocol 
				ifTrue: 
					[query
						isChecked: self protocol isReadOnly;
						isEnabled: true]
				ifFalse: 
					[query
						isChecked: false;
						isEnabled: false].
			^true].
	#deleteProtocol == cmd 
		ifTrue: 
			[query 
				isEnabled: (self hasProtocol and: [self protocol baseBehaviors isEmpty]).
			^true].
	(#(#addClass #browseMethods) identityIncludes: cmd) 
		ifTrue: 
			[query isEnabled: self hasProtocol.
			^true].
	(#(#addSelector #addSelectors) identityIncludes: cmd) 
		ifTrue: 
			[query isEnabled: (self hasProtocol and: [self protocol isReadOnly not]).
			^true].
	(#(#removeSelectors) identityIncludes: cmd) 
		ifTrue: 
			[query isEnabled: (self hasSelectors 
						and: [self hasProtocol and: [self protocol isReadOnly not]]).
			^true].
	(#(#removeClassFromProtocol) identityIncludes: cmd) 
		ifTrue: 
			[query isEnabled: self hasActualClass.
			^true].
	^super queryCommand: query!

refreshProtocols
	"Private - Fill the protocols list with the available MethodProtocols."

	protocolsPresenter list: (Object methodProtocolClass allMethodProtocols).
	self onProtocolSelected!

removeClassFromProtocol
	"Removes the current class from the selected protocol"

	self model removeClass: self actualClass fromProtocol: self protocol!

removeProtocol
	"Removes the currently selected protocol from the system."

	Object methodProtocolClass removeProtocol: self protocol
!

removeSelectors
	"Removes the current selectors from the selected protocol"

	self model removeSelectors: self selectors fromProtocol: self protocol

!

selector
	"Answer the currently selected selector <Symbol> in the receiver or
	nil if there is none"

	^selectorsPresenter selectionOrNil!

selectors
	"Answer the <collection> of <Symbol>'s currently selected from the selector list."

	^selectorsPresenter selections!

setInitialFocus
	protocolsPresenter view tabFirst!

shortCaption
	^'Protocols'!

toggleANSI
	"Private - Toggle the selected protocol between ANSI and non-ANSI modes."

	| prot |
	prot := self protocol.
	prot isANSI: prot isANSI not!

toggleReadOnly
	"Private - Toggle the selected protocol between Read Only and Read/Write modes."

	| prot |
	prot := self protocol.
	prot isReadOnly: prot isReadOnly not!

updateCaption
	"The receiver has changed in such a way that the caption may need to be refreshed.
	Do this here"

	| text |
	text := self class displayString.
	self hasProtocol ifTrue: [text := self protocol displayString].
	self caption: text! !
!ProtocolBrowserShell categoriesFor: #actualClass!accessing!public! !
!ProtocolBrowserShell categoriesFor: #actualClass:!accessing!public! !
!ProtocolBrowserShell categoriesFor: #addClass!commands!public! !
!ProtocolBrowserShell categoriesFor: #addProtocol!commands!public! !
!ProtocolBrowserShell categoriesFor: #addSelector!commands!public! !
!ProtocolBrowserShell categoriesFor: #addSelectors!commands!public! !
!ProtocolBrowserShell categoriesFor: #browseMethods!commands!public! !
!ProtocolBrowserShell categoriesFor: #createComponents!initializing!public! !
!ProtocolBrowserShell categoriesFor: #createSchematicWiring!initializing!public! !
!ProtocolBrowserShell categoriesFor: #defaultHelpId!public! !
!ProtocolBrowserShell categoriesFor: #hasActualClass!public!testing! !
!ProtocolBrowserShell categoriesFor: #hasProtocol!public!testing! !
!ProtocolBrowserShell categoriesFor: #hasSelectors!public!testing! !
!ProtocolBrowserShell categoriesFor: #onDragProtocol:!event handling!private! !
!ProtocolBrowserShell categoriesFor: #onProtocolRemoved:!event handling!private! !
!ProtocolBrowserShell categoriesFor: #onProtocolSelected!event handling!private! !
!ProtocolBrowserShell categoriesFor: #onProtocolUpdated:!event handling!private! !
!ProtocolBrowserShell categoriesFor: #onSelectorSelected!event handling!private! !
!ProtocolBrowserShell categoriesFor: #onTipTextRequired:!event handling!public! !
!ProtocolBrowserShell categoriesFor: #onViewOpened!event handling!public! !
!ProtocolBrowserShell categoriesFor: #protocol!accessing!public! !
!ProtocolBrowserShell categoriesFor: #protocol:!accessing!public! !
!ProtocolBrowserShell categoriesFor: #purgeUnused!commands!public! !
!ProtocolBrowserShell categoriesFor: #queryCommand:!commands!private! !
!ProtocolBrowserShell categoriesFor: #refreshProtocols!event handling!private! !
!ProtocolBrowserShell categoriesFor: #removeClassFromProtocol!commands!public! !
!ProtocolBrowserShell categoriesFor: #removeProtocol!commands!public! !
!ProtocolBrowserShell categoriesFor: #removeSelectors!commands!public! !
!ProtocolBrowserShell categoriesFor: #selector!accessing!public! !
!ProtocolBrowserShell categoriesFor: #selectors!accessing!public! !
!ProtocolBrowserShell categoriesFor: #setInitialFocus!operations!public! !
!ProtocolBrowserShell categoriesFor: #shortCaption!accessing!public! !
!ProtocolBrowserShell categoriesFor: #toggleANSI!commands!private! !
!ProtocolBrowserShell categoriesFor: #toggleReadOnly!commands!private! !
!ProtocolBrowserShell categoriesFor: #updateCaption!public!updating! !

!ProtocolBrowserShell class methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Protocol Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver.

		self initialize.
	"

	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self reuseIfOpen: true.
	self canUseIdeaSpace: true
	"BaseOnlyMask := 1"!

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 196934 1 ##(Smalltalk.RGB) 8 4294967295 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851468 131073 560 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 0 560 642 672 8 4294903529 234 256 98 6 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 864 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 0 0 864 1180166 ##(Smalltalk.ResourceIdentifier) 576 8 #resource_Protocol_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 770 1053 1 770 109 51 864 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 2 0 0 0 0 0 0 68 2 0 0 25 0 0 0] 98 0 770 193 193 0 27 8 'protocolTools' 410 880 98 14 0 560 98 2 8 1140850688 131073 1280 0 946 31 0 7 0 0 0 1280 978 576 8 #resource_Smalltalk_tools 0 1026 202 208 98 1 1090 1120 98 2 770 63 1 770 991 51 1280 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1232 1248 0 27 8 'smalltalkTools' 410 880 98 14 0 560 98 2 8 1140850688 131073 1552 0 946 31 0 7 0 0 0 1552 978 576 8 #resource_Image_tools 0 1026 202 208 98 1 1090 1120 98 2 770 1 1 770 63 51 1552 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1232 1248 0 27 8 'imageTools' 234 256 1232 98 0 234 240 1232 0 1 0 770 33 33 770 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1026 202 208 98 2 1090 1120 98 2 770 1 1 770 1169 51 560 1090 8 #updateSizePosted 1232 560 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 25 0 0 0] 98 3 1552 1280 864 1248 0 27 0 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 2128 0 642 8 4278190080 0 7 0 0 0 2128 1180166 ##(Smalltalk.ProportionalLayout) 234 240 1232 16 234 256 1232 0 1026 202 208 98 1 1090 1120 98 2 770 1 51 770 1169 633 2128 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 72 2 0 0 85 1 0 0] 98 1 410 2144 98 15 0 2128 98 2 8 1140850688 131073 2464 0 0 0 7 0 0 0 2464 2242 234 240 98 2 410 8 ##(Smalltalk.ListView) 98 30 0 2464 98 2 8 1140920393 1 2576 590662 2 ##(Smalltalk.ListModel) 202 208 1232 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 642 8 4278190080 0 7 265030 4 ##(Smalltalk.Menu) 0 16 98 3 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #addSelector 8 'Add &Selector...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2818 1 2850 8 #removeSelectors 8 'Remove Se&lectors' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 2576 0 8 4294909021 8 ##(Smalltalk.BasicListAbstract) 8 ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 0 0 0 770 65 65 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 1 8 #left 3040 8 ##(Smalltalk.SortedCollection) 0 0 2576 0 1 0 0 3154 8 'Selectors' 375 3200 3040 3216 0 0 2576 0 3 0 0 8 #report 1232 0 133221 0 98 1 0 1026 202 208 98 2 1090 1120 98 2 770 393 1 770 383 633 2576 1090 8 #contextMenu: 98 1 2784 2576 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 196 0 0 0 0 0 0 0 131 1 0 0 60 1 0 0] 98 0 1248 0 27 3 32 234 256 98 4 410 2592 98 30 0 2464 98 2 8 1140920397 1 3536 2658 202 208 1232 0 2720 642 2752 0 31 2770 0 16 98 9 2818 1 2850 8 #toggleReadOnly 8 '&Read Only' 1 1 0 0 0 2818 1 2850 8 #toggleANSI 8 'AN&SI' 1 1 0 0 0 2914 4097 2818 1 2850 8 #browseMethods 8 '&Browse Methods...' 1 1 0 0 0 2818 1 2850 8 #renameMethodProtocol 8 'Rename...' 1 1 0 0 0 2818 1 2850 8 #removeProtocol 8 '&Delete' 1 1 0 0 0 2914 4097 2818 1 2850 8 #addProtocol 8 '&Add Protocol...' 1 1 0 0 0 2818 1 2850 8 #purgeUnused 8 '&Purge Unused Protocols' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 3536 0 8 4294909021 459270 ##(Smalltalk.Message) 8 #name 98 0 3056 3088 0 0 0 0 0 0 202 208 98 1 3154 8 'Protocols' 375 3200 4194 4224 98 0 3216 0 0 3536 0 3 0 0 3264 1232 0 131169 0 98 1 0 1026 202 208 98 3 1090 1120 98 2 770 1 1 770 383 633 3536 1090 3424 98 1 3648 3536 1090 8 #text: 98 1 8 'Protocols' 3536 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 191 0 0 0 60 1 0 0] 98 0 1248 0 27 8 'protocols' 2576 8 'selectors' 0 1026 202 208 98 1 1090 1120 98 2 770 1 1 770 1169 633 2464 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 60 1 0 0] 98 5 3536 410 8 ##(Smalltalk.Splitter) 98 12 0 2464 98 2 8 1140850688 1 4816 0 642 2752 0 519 0 0 0 4816 1026 202 208 98 1 1090 1120 98 2 770 383 1 770 11 633 4816 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 0 0 0 0 0 0 0 196 0 0 0 60 1 0 0] 98 0 1248 0 27 2576 410 4832 98 12 0 2464 98 2 8 1140850688 1 5072 0 642 2752 0 519 0 0 0 5072 1026 202 208 98 1 1090 1120 98 2 770 775 1 770 11 633 5072 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 131 1 0 0 0 0 0 0 136 1 0 0 60 1 0 0] 98 0 1248 0 27 410 2144 98 15 0 2464 98 2 8 1140850688 131073 5312 0 642 2752 0 7 0 0 0 5312 2242 234 240 98 2 410 8 ##(Smalltalk.StaticText) 98 16 0 5312 98 2 8 1140916481 1 5440 0 642 8 4278190080 0 7 0 0 0 5440 0 8 4294908187 852486 ##(Smalltalk.NullConverter) 0 0 0 1026 202 208 98 2 1090 1120 98 2 770 1 1 770 385 41 5440 1090 4528 98 1 8 'Conforming classes' 5440 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 192 0 0 0 20 0 0 0] 98 0 1248 0 27 1 16 234 256 98 4 410 880 98 14 0 5312 98 2 8 1140850688 131073 5840 0 0 0 7 2770 0 16 98 6 2818 1 2850 8 #addClass 8 'Add &Class...' 1 1 0 0 0 2818 1 2850 8 #removeClassFromProtocol 8 'Remove Cl&ass' 1 1 0 0 0 2914 4097 2818 1 2850 8 #addSelectors 8 'Selec&tors...' 1 1 0 0 0 2914 4097 2818 1 2850 8 #browseIt 8 '&Browse Class...' 1 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ClassBrowserShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 5840 978 8 ##(Smalltalk.ClassHierarchySelector) 8 #resource_Default_view 0 1026 202 208 98 2 1090 1120 98 2 770 1 41 770 385 593 5840 1090 3424 98 1 5904 5840 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 20 0 0 0 192 0 0 0 60 1 0 0] 1232 1248 0 27 8 'classes' 5440 8 'classesCaption' 0 1026 202 208 98 1 1090 1120 98 2 770 785 1 770 385 633 5312 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 0 0 0 0 72 2 0 0 60 1 0 0] 98 2 5440 5840 1248 0 27 1248 0 27 1248 0 27 234 256 98 2 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 5 2770 0 16 98 8 2818 1 2850 8 #fileNew 8 '&New' 9373 1 6226 0 16 6272 8 'FileNew.ico' 6320 0 0 2818 1 2850 8 #fileOpen 8 '&Open...' 9375 1 6226 0 16 6272 8 'FileOpen.ico' 6320 0 0 2818 1 2850 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 2914 4097 2818 1 2850 8 #saveImage 8 'Sa&ve Image' 1 1 6226 0 16 6272 8 'Snapshot.ico' 6320 0 0 2818 1 2850 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 6226 0 16 6272 8 'PowerSwitch.ico' 6320 0 0 2914 4097 2818 1 2850 8 #exit 8 '&Close' 17639 1 6226 0 16 6272 8 'CloseWindow.ico' 6320 0 0 8 '&File' 0 134217729 0 0 38491 0 0 2770 0 16 98 10 2818 1 2850 4064 8 'Add &Protocol...' 1 1 0 0 0 2914 4097 2818 1 2850 2880 8 'Add &Selector...' 1 1 0 0 0 2818 1 2850 2976 8 'Remove Se&lectors.' 1 1 0 0 0 2914 4097 2818 1 2850 5968 8 'Add &Class...' 1 1 0 0 0 2818 1 2850 6112 8 'Add Class Selec&tors...' 1 1 0 0 0 2818 1 2850 6032 8 'Remove Cl&ass' 1 1 0 0 0 2914 4097 2818 1 2850 4128 8 'P&urge Unused Protocols' 1 1 0 0 0 8 '&Protocol' 0 134217729 0 0 38507 0 0 2770 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 38509 0 0 2770 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 38511 0 0 2770 0 16 98 15 2818 1 2850 8 #helpContents 8 '&Contents' 1025 1 6226 0 16 6272 49 786694 ##(Smalltalk.ShellLibrary) 0 0 2818 1 2850 8 #help 8 'On this &Tool' 1249 1 0 0 0 2818 1 2850 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 2914 4097 2818 1 2850 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 2914 4097 2818 1 2850 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 2818 1 2850 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 2818 1 2850 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 2914 4097 2818 1 2850 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 2818 1 2850 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 2818 1 2850 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 2914 4097 2818 1 2850 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6226 0 16 6272 8 '!!APPLICATION' 6320 0 0 8 '&Help' 0 134217729 0 0 38535 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1026 202 208 98 3 1090 1120 98 2 770 3839 21 770 1201 801 416 1090 4528 98 1 8 'Protocol Browser' 416 1090 8 #updateMenuBar 1232 416 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 98 2 560 2128 1248 0 27 )!

toolsFolderHelpId
	^10596!

uninitialize
	"Private - Un-register the system tools folder icon for the receiver to allow clean
	removal of this class from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self! !
!ProtocolBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!ProtocolBrowserShell class categoriesFor: #icon!constants!public! !
!ProtocolBrowserShell class categoriesFor: #initialize!initializing!private! !
!ProtocolBrowserShell class categoriesFor: #publishedAspects!development!public! !
!ProtocolBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !
!ProtocolBrowserShell class categoriesFor: #toolsFolderHelpId!public! !
!ProtocolBrowserShell class categoriesFor: #uninitialize!class hierarchy-removing!private! !

