"Filed out from Dolphin Smalltalk"!

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

!ProtocolBrowserShell categoriesForMethods!
actualClass!accessing!public! !
actualClass:!accessing!public! !
addClass!commands!public! !
addProtocol!commands!public! !
addSelector!commands!public! !
addSelectors!commands!public! !
browseMethods!commands!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultHelpId!public! !
hasActualClass!public!testing! !
hasProtocol!public!testing! !
hasSelectors!public!testing! !
onDragProtocol:!event handling!private! !
onProtocolRemoved:!event handling!private! !
onProtocolSelected!event handling!private! !
onProtocolUpdated:!event handling!private! !
onSelectorSelected!event handling!private! !
onTipTextRequired:!event handling!public! !
onViewOpened!event handling!public! !
protocol!accessing!public! !
protocol:!accessing!public! !
purgeUnused!commands!public! !
queryCommand:!commands!private! !
refreshProtocols!event handling!private! !
removeClassFromProtocol!commands!public! !
removeProtocol!commands!public! !
removeSelectors!commands!public! !
selector!accessing!public! !
selectors!accessing!public! !
setInitialFocus!operations!public! !
shortCaption!accessing!public! !
toggleANSI!commands!private! !
toggleReadOnly!commands!private! !
updateCaption!public!updating! !
!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 528 327686 ##(Smalltalk.Color) #default 8 1795812352 170 192 34 8 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 752 nil nil nil 7 nil nil nil 752 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Search_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 784 8 '' 752 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1120 nil nil nil 7 nil nil nil 1120 818 ##(Smalltalk.Toolbar) #resource_Image_tools nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 1152 8 '' 1120 3 1056 1074 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1376 nil nil nil 7 nil nil nil 1376 818 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 1408 8 '' 1376 3 1056 1074 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.Toolbar) 34 28 nil 528 34 2 8 1409289036 131137 1632 nil nil nil 519 nil nil nil 1632 688 8 1795812352 170 192 1056 nil nil nil 170 192 34 4 12651 1115718 2 ##(Smalltalk.ToolbarIconButton) 1632 1 1180998 4 ##(Smalltalk.CommandDescription) #toggleReadOnly 8 'Lock/unlock protocol' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Mutex.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 12651 nil nil 12653 1762 1632 1 1794 #toggleANSI 8 'Toggle ANSI status' 1 1 1842 nil true 1888 8 'MethodProtocol_Ansi.ico' 1936 12653 nil nil 34 3 1776 1968 1049158 1 ##(Smalltalk.ToolbarSeparator) 1632 1 nil nil 9 1 nil nil nil nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[11 2 0 0 0 0 0 0 65 2 0 0 25 0 0 0] 193 1664 8 '' 1632 3 8 #() 1074 193 193 nil 31 8 'protocolTools' nil nil nil 170 192 1056 8 #() nil nil 9 1155 #smallIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 0 0 0 0 162 2 0 0 25 0 0 0] 193 560 8 '' 528 3 34 4 1120 1376 752 1632 1074 193 193 nil 31 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2528 nil nil nil 7 nil nil nil 2528 1180166 ##(Smalltalk.ProportionalLayout) 170 176 1056 true 170 192 1056 nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 25 0 0 0 162 2 0 0 85 1 0 0] 193 2560 8 '' 2528 3 34 1 410 ##(Smalltalk.ContainerView) 34 15 nil 2528 34 2 8 1140850688 131073 2816 nil nil nil 7 nil nil nil 2816 2594 170 176 34 2 410 ##(Smalltalk.ListView) 34 45 nil 2816 34 2 8 1140920393 1 2928 590662 2 ##(Smalltalk.ListModel) 138 144 1056 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 688 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 3 984134 2 ##(Smalltalk.CommandMenuItem) 1 1794 #addSelector 8 'Add &Selector...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3122 1 1794 #removeSelectors 8 'Remove Se&lectors' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2928 nil 8 1795768528 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 1074 65 65 nil nil 138 144 34 2 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 1 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() nil nil 2928 nil 1 nil nil 3378 8 'Selectors' 435 #left ##(Smalltalk.BasicListAbstract) 3426 #<= 8 #() nil nil 2928 nil 3 nil nil #report 8 #() nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 850 138 144 34 2 914 #createWindow: 34 1 962 994 8 #[226 0 0 0 0 0 0 0 191 1 0 0 60 1 0 0] 193 2960 8 '' 2928 914 #contextMenu: 34 1 3088 2928 3 8 #() 1074 193 193 nil 35 3 false 170 192 34 4 410 ##(Smalltalk.ListView) 34 45 nil 2816 34 2 8 1140920397 1 3792 2994 138 144 1056 nil 3056 688 nil 31 3074 nil true 34 9 3122 1 1794 #toggleReadOnly 8 '&Read Only' 1 1 nil nil nil 3122 1 1794 #toggleANSI 8 'AN&SI' 1 1 nil nil nil 3186 4097 3122 1 1794 #browseMethods 8 '&Browse Methods...' 1 1 nil nil nil 3122 1 1794 #renameMethodProtocol 8 'Rename...' 1 1 1842 nil true 1888 8 'Rename.ico' 1936 nil nil 3122 1 1794 #removeProtocol 8 '&Delete' 1 1 1842 nil true 1888 8 'EditClear.ico' 1936 nil nil 3186 4097 3122 1 1794 #addProtocol 8 '&Add Protocol...' 1 1 nil nil nil 3122 1 1794 #purgeUnused 8 '&Purge Unused Protocols' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3792 nil 8 1795768528 3426 #name 8 #() ##(Smalltalk.IconicListAbstract) 3312 nil nil nil nil nil nil 138 144 34 1 3378 8 'Protocols' 435 #left 3426 #name 8 #() 3426 #<= 8 #() nil nil 3792 nil 3 nil nil #report 3536 nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 850 138 144 34 2 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 0 0 0 0 221 0 0 0 60 1 0 0] 193 3824 8 'Protocols' 3792 914 #contextMenu: 34 1 3888 3792 3 8 #() 1074 193 193 nil 35 8 'protocols' 2928 8 'selectors' nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 0 0 0 0 162 2 0 0 60 1 0 0] 193 2848 8 '' 2816 3 34 5 3792 410 ##(Smalltalk.Splitter) 34 12 nil 2816 34 2 8 1140850688 1 4944 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 4944 nil 1 #left nil nil nil 1074 1 1 1074 9 9 nil 5040 nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[221 0 0 0 0 0 0 0 226 0 0 0 60 1 0 0] 193 4976 8 '' 4944 3 8 #() 1074 193 193 nil 27 2928 410 ##(Smalltalk.Splitter) 34 12 nil 2816 34 2 8 1140850688 1 5248 nil nil nil 519 nil nil nil 5010 5248 nil 1 #left nil nil nil 5040 5056 nil 5040 nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[191 1 0 0 0 0 0 0 196 1 0 0 60 1 0 0] 193 5280 8 '' 5248 3 8 #() 1074 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 2816 34 2 8 1140850688 131073 5504 nil nil nil 7 nil nil nil 5504 2594 170 176 34 2 410 ##(Smalltalk.StaticText) 34 16 nil 5504 34 2 8 1140916481 1 5616 nil nil nil 7 nil nil nil 5616 nil 8 1795912768 852486 ##(Smalltalk.NullConverter) nil nil nil 850 138 144 34 2 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 0 0 0 0 222 0 0 0 20 0 0 0] 193 5648 nil 5616 914 #text: 34 1 8 'Conforming classes' 5616 3 8 #() 1074 193 193 nil 27 1 true 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 5504 34 2 8 1140850688 131073 5968 nil 688 nil 7 3074 nil true 34 6 3122 1 1794 #addClass 8 'Add &Class...' 1 1 nil nil nil 3122 1 1794 #removeClassFromProtocol 8 'Remove Cl&ass' 1 1 nil nil nil 3186 4097 3122 1 1794 #addSelectors 8 'Selec&tors...' 1 1 nil nil nil 3186 4097 3122 1 1794 #browseIt 8 '&Browse Class...' 1 1 1842 nil true 1888 8 'ClassBrowserShell.ico' 1936 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 5968 818 ##(Smalltalk.ClassHierarchySelector) #resource_Default_view nil 850 138 144 34 2 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 20 0 0 0 222 0 0 0 60 1 0 0] 193 6000 8 '' 5968 914 #contextMenu: 34 1 6032 5968 3 1056 1074 193 193 nil 27 8 'classes' 5616 8 'classesCaption' nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[196 1 0 0 0 0 0 0 162 2 0 0 60 1 0 0] 193 5536 8 '' 5504 3 34 2 5616 5968 1074 193 193 nil 27 1074 193 193 nil 27 1074 193 193 nil 27 170 192 34 2 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 5 3074 nil true 34 8 3122 1 1794 #fileNew 8 '&New Workspace' 9373 1 1842 nil true 1888 8 'New Workspace.ico' 1936 nil nil 3122 1 1794 #fileOpen 8 '&Open Workspace...' 9375 1 1842 nil true 1888 8 'OpenWorkspace.ico' 1936 nil nil 3122 1 1794 #fileFileIn 8 '&File In...' 1 1 nil nil nil 3186 4097 3122 1 1794 #saveImage 8 'Sa&ve Image' 1 1 1842 nil true 1888 8 'Snapshot.ico' 1936 nil nil 3122 1 1794 #smalltalkExit 8 'E&xit Dolphin' 1 1 1842 nil true 1888 8 'PowerSwitch.ico' 1936 nil nil 3186 4097 3122 1 1794 #exit 8 '&Close' 17639 1 788806 2 ##(Smalltalk.TextTileIcon) $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 12667 nil nil 3074 nil true 34 10 3122 1 1794 #addProtocol 8 'Add &Protocol...' 1 1 nil nil nil 3186 4097 3122 1 1794 #addSelector 8 'Add &Selector...' 1 1 nil nil nil 3122 1 1794 #removeSelectors 8 'Remove Se&lectors.' 1 1 nil nil nil 3186 4097 3122 1 1794 #addClass 8 'Add &Class...' 1 1 nil nil nil 3122 1 1794 #addSelectors 8 'Add Class Selec&tors...' 1 1 nil nil nil 3122 1 1794 #removeClassFromProtocol 8 'Remove Cl&ass' 1 1 nil nil nil 3186 4097 3122 1 1794 #purgeUnused 8 'P&urge Unused Protocols' 1 1 nil nil nil 8 '&Protocol' nil 134217729 nil nil 12683 nil nil 3074 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 12685 nil nil 3074 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 12687 nil nil 3074 nil true 34 15 3122 1 1794 #helpContents 8 '&Contents' 1025 1 1842 nil true 1888 8 'Help.ico' 1936 nil nil 3122 1 1794 #help 8 'On this &Tool' 1249 1 nil nil nil 3122 1 1794 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3186 4097 3122 1 1794 #learnSmalltalk 8 'Learn Smalltalk' 1 1 7362 $🎓 nil 674 #orchid 674 #white nil nil 1 nil nil nil nil 3186 4097 3122 1 1794 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3122 1 1794 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3122 1 1794 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3186 4097 3122 1 1794 #dolphinHomePage 8 'Dolphin Homepage' 1 1 1842 nil true 1888 8 '!!APPLICATION' 1936 nil nil 3122 1 1794 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3122 1 1794 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3186 4097 3122 1 1794 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7362 $🐬 nil nil 674 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 12711 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 850 138 144 34 1 914 #createWindow: 34 1 962 590342 ##(Smalltalk.Rectangle) 1074 6143 21 1074 7523 821 193 448 8 'Protocol Browser' 416 1 34 2 528 2528 1074 193 193 nil 27 )!

toolsFolderHelpId
	^10596! !

!ProtocolBrowserShell class categoriesForMethods!
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
toolsFolderHelpId!public! !
!

