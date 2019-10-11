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
!ProtocolBrowserShell categoriesForClass!MVP-Presenters! !
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

	^MethodProtocol icon!

initialize
	"Private - Initialize the receiver.

		self initialize.
	"

	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self reuseIfOpen: true.
	self canUseIdeaSpace: true!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: (Aspect boolean: #canUseIdeaSpace);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 528 327686 ##(Smalltalk.Color) #default 8 1903898080 170 192 34 8 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1409289036 131137 784 nil nil nil 519 nil nil nil 784 720 8 1903898080 170 192 8 #() 170 192 34 4 33787 1115206 1 ##(Smalltalk.ToolbarIconButton) 784 1 1180998 4 ##(Smalltalk.CommandDescription) #toggleReadOnly 8 'Lock/unlock protocol' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Mutex.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 33787 33789 930 784 1 962 #toggleANSI 8 'Toggle ANSI status' 1 1 1010 nil true 1056 8 'MethodProtocol_Ansi.ico' 1104 33789 34 3 944 1136 1049158 1 ##(Smalltalk.ToolbarSeparator) 784 1 nil nil 1 nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 1051 1 674 109 51 784 1330 #updateSizePosted 880 784 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 67 2 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'protocolTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1520 nil nil nil 7 nil nil nil 1520 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 63 1 674 553 51 1520 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 880 1488 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1776 nil nil nil 7 nil nil nil 1776 1586 ##(Smalltalk.Toolbar) #resource_Image_tools nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 1 1 674 63 51 1776 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 880 1488 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 2016 nil nil nil 7 nil nil nil 2016 1586 ##(Smalltalk.Toolbar) #resource_Search_tools nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 615 1 674 437 51 2016 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 880 1488 nil 27 8 'searchTools' 170 192 880 8 #() nil nil 1 nil 674 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1266 138 144 34 2 1330 #createAt:extent: 34 2 674 1 1 674 1349 51 528 1330 #updateSizePosted 880 528 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 162 2 0 0 25 0 0 0] 34 4 1776 1520 2016 784 1488 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2512 nil nil nil 7 nil nil nil 2512 1180166 ##(Smalltalk.ProportionalLayout) 170 176 880 true 170 192 880 nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 1 51 674 1349 633 2512 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 162 2 0 0 85 1 0 0] 34 1 410 ##(Smalltalk.ContainerView) 34 15 nil 2512 34 2 8 1140850688 131073 2800 nil nil nil 7 nil nil nil 2800 2578 170 176 34 2 410 ##(Smalltalk.ListView) 34 30 nil 2800 34 2 8 1140920393 1 2912 590662 2 ##(Smalltalk.ListModel) 138 144 880 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 720 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 3 984134 2 ##(Smalltalk.CommandMenuItem) 1 962 #addSelector 8 'Add &Selector...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3106 1 962 #removeSelectors 8 'Remove Se&lectors' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2912 nil 8 1903904528 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 674 65 65 nil nil 138 144 34 2 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 1 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() nil nil 2912 nil 1 nil nil 3362 8 'Selectors' 435 #left ##(Smalltalk.BasicListAbstract) 3410 #<= 8 #() nil nil 2912 nil 3 nil nil #report 880 nil 133221 nil 34 4 nil nil 674 1 1 nil 1266 138 144 34 2 1330 #createAt:extent: 34 2 674 453 1 674 443 633 2912 1330 #contextMenu: 34 1 3072 2912 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 226 0 0 0 0 0 0 0 191 1 0 0 60 1 0 0] 8 #() 1488 nil 27 3 false 170 192 34 4 410 ##(Smalltalk.ListView) 34 30 nil 2800 34 2 8 1140920397 1 3776 2978 138 144 880 nil 3040 720 nil 31 3058 nil true 34 9 3106 1 962 #toggleReadOnly 8 '&Read Only' 1 1 nil nil nil 3106 1 962 #toggleANSI 8 'AN&SI' 1 1 nil nil nil 3170 4097 3106 1 962 #browseMethods 8 '&Browse Methods...' 1 1 nil nil nil 3106 1 962 #renameMethodProtocol 8 'Rename...' 1 1 1010 nil true 1056 8 'Rename.ico' 1104 nil nil 3106 1 962 #removeProtocol 8 '&Delete' 1 1 1010 nil true 1056 8 'EditClear.ico' 1104 nil nil 3170 4097 3106 1 962 #addProtocol 8 '&Add Protocol...' 1 1 nil nil nil 3106 1 962 #purgeUnused 8 '&Purge Unused Protocols' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3776 nil 8 1903904528 3410 #name 8 #() ##(Smalltalk.IconicListAbstract) 3296 nil nil nil nil nil nil 138 144 34 1 3362 8 'Protocols' 435 #left 3410 #name 8 #() 3410 #<= 8 #() nil nil 3776 nil 3 nil nil #report 880 nil 131169 nil 34 4 nil nil 674 1 1 nil 1266 138 144 34 3 1330 #createAt:extent: 34 2 674 1 1 674 443 633 3776 1330 #contextMenu: 34 1 3872 3776 1330 #text: 34 1 8 'Protocols' 3776 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 221 0 0 0 60 1 0 0] 8 #() 1488 nil 27 8 'protocols' 2912 8 'selectors' nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 1 1 674 1349 633 2800 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 162 2 0 0 60 1 0 0] 34 5 3776 410 ##(Smalltalk.Splitter) 34 12 nil 2800 34 2 8 1140850688 1 4992 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 4992 nil 1 #left nil nil nil 674 1 1 674 9 9 nil 5088 nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 443 1 674 11 633 4992 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 0 0 0 0 0 0 0 226 0 0 0 60 1 0 0] 8 #() 1488 nil 27 2912 410 ##(Smalltalk.Splitter) 34 12 nil 2800 34 2 8 1140850688 1 5280 nil nil nil 519 nil nil nil 5058 5280 nil 1 #left nil nil nil 5088 5104 nil 5088 nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 895 1 674 11 633 5280 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 1 0 0 0 0 0 0 196 1 0 0 60 1 0 0] 8 #() 1488 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 2800 34 2 8 1140850688 131073 5520 nil nil nil 7 nil nil nil 5520 2578 170 176 34 2 410 ##(Smalltalk.StaticText) 34 16 nil 5520 34 2 8 1140916481 1 5632 nil nil nil 7 nil nil nil 5632 nil 8 1903849936 852486 ##(Smalltalk.NullConverter) nil nil nil 1266 138 144 34 2 1330 #createAt:extent: 34 2 674 1 1 674 445 41 5632 1330 #text: 34 1 8 'Conforming classes' 5632 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 222 0 0 0 20 0 0 0] 8 #() 1488 nil 27 1 true 170 192 34 4 5632 8 'classesCaption' 410 ##(Smalltalk.ReferenceView) 34 14 nil 5520 34 2 8 1140850688 131073 6000 nil 720 nil 7 3058 nil true 34 6 3106 1 962 #addClass 8 'Add &Class...' 1 1 nil nil nil 3106 1 962 #removeClassFromProtocol 8 'Remove Cl&ass' 1 1 nil nil nil 3170 4097 3106 1 962 #addSelectors 8 'Selec&tors...' 1 1 nil nil nil 3170 4097 3106 1 962 #browseIt 8 '&Browse Class...' 1 1 1010 nil true 1056 8 'ClassBrowserShell.ico' 1104 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 6000 1586 ##(Smalltalk.ClassHierarchySelector) #resource_Default_view nil 1266 138 144 34 2 1330 #createAt:extent: 34 2 674 1 41 674 445 593 6000 1330 #contextMenu: 34 1 6064 6000 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 20 0 0 0 222 0 0 0 60 1 0 0] 880 1488 nil 27 8 'classes' nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 905 1 674 445 633 5520 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 196 1 0 0 0 0 0 0 162 2 0 0 60 1 0 0] 34 2 5632 6000 1488 nil 27 1488 nil 27 1488 nil 27 170 192 34 2 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 5 3058 nil true 34 8 3106 1 962 #fileNew 8 '&New Workspace' 9373 1 1010 nil true 1056 8 'New Workspace.ico' 1104 nil nil 3106 1 962 #fileOpen 8 '&Open Workspace...' 9375 1 1010 nil true 1056 8 'OpenWorkspace.ico' 1104 nil nil 3106 1 962 #fileFileIn 8 '&File In...' 1 1 nil nil nil 3170 4097 3106 1 962 #saveImage 8 'Sa&ve Image' 1 1 1010 nil true 1056 8 'Snapshot.ico' 1104 nil nil 3106 1 962 #smalltalkExit 8 'E&xit Dolphin' 1 1 1010 nil true 1056 8 'PowerSwitch.ico' 1104 nil nil 3170 4097 3106 1 962 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 34237 nil nil 3058 nil true 34 10 3106 1 962 #addProtocol 8 'Add &Protocol...' 1 1 nil nil nil 3170 4097 3106 1 962 #addSelector 8 'Add &Selector...' 1 1 nil nil nil 3106 1 962 #removeSelectors 8 'Remove Se&lectors.' 1 1 nil nil nil 3170 4097 3106 1 962 #addClass 8 'Add &Class...' 1 1 nil nil nil 3106 1 962 #addSelectors 8 'Add Class Selec&tors...' 1 1 nil nil nil 3106 1 962 #removeClassFromProtocol 8 'Remove Cl&ass' 1 1 nil nil nil 3170 4097 3106 1 962 #purgeUnused 8 'P&urge Unused Protocols' 1 1 nil nil nil 8 '&Protocol' nil 134217729 nil nil 34253 nil nil 3058 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 34255 nil nil 3058 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 34257 nil nil 3058 nil true 34 15 3106 1 962 #helpContents 8 '&Contents' 1025 1 1010 nil true 1056 8 'Help.ico' 1104 nil nil 3106 1 962 #help 8 'On this &Tool' 1249 1 nil nil nil 3106 1 962 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3170 4097 3106 1 962 #learnSmalltalk 8 'Learn Smalltalk' 1 1 7314 $\x1F393 nil 706 #orchid 706 #white nil nil 1 nil nil nil nil 3170 4097 3106 1 962 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3106 1 962 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3106 1 962 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3170 4097 3106 1 962 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 1010 nil true 1056 8 '!!APPLICATION' 1104 nil nil 3106 1 962 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3106 1 962 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3170 4097 3106 1 962 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7314 $\x1F42C nil nil 706 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' nil 134217729 nil nil 34281 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1266 138 144 34 3 1330 #createAt:extent: 34 2 674 3839 21 674 1381 801 416 1330 #text: 34 1 8 'Protocol Browser' 416 1330 #updateMenuBar 880 416 1426 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 49 10 0 0 154 1 0 0] 34 2 528 2512 1488 nil 27)!

toolsFolderHelpId
	^10596! !
!ProtocolBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!ProtocolBrowserShell class categoriesFor: #icon!constants!public! !
!ProtocolBrowserShell class categoriesFor: #initialize!initializing!private! !
!ProtocolBrowserShell class categoriesFor: #publishedAspects!public! !
!ProtocolBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !
!ProtocolBrowserShell class categoriesFor: #toolsFolderHelpId!public! !

