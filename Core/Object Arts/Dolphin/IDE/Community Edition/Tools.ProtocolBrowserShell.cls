"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.ProtocolBrowserShell'
	instanceVariableNames: 'protocolsPresenter selectorsPresenter classesPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ProtocolBrowserShell guid: (Core.GUID fromString: '{e168a511-4549-11d3-9fe9-00a0cc3e4a32}')!
Tools.ProtocolBrowserShell comment: 'ProtocolBrowserShell is a <SmalltalkToolShell> that implements the Protocol Browser tool. This displays a list of all the <MethodProtocol>s known to the system. Selecting a protocol displays the selectors within it and the classes that conform to it. From within the Protocol Browser it is possible to perform a wide range of protocol housekeeping activities.

Instance Variables:
	protocolsPresenter		<ListPresenter> holding the list of installed protocols.
	selectorsPresenter		<ListPresenter> holding a list of messages for the selected protocol.
	classesPresenter		<ListPresenter> holding a list of classes conforming to be selected protocol.


'!
!Tools.ProtocolBrowserShell categoriesForClass!MVP-Presenters! !
!Tools.ProtocolBrowserShell methodsFor!

actualClass
	"Answer the currently selected Class in the receiver, or
	nil if there is none"

	^classesPresenter selectionOrNil!

actualClass: aClass
	"Select the <Class> aClass in the receiver"

	^classesPresenter selectionOrNil: aClass instanceClass!

addClass
	"Adds the selected class to the currently selected protocol"

	<commandQuery: #hasProtocol>
	| chosenClass |
	(chosenClass := ChoicePrompter choices: Class allBehaviors asSortedCollection
				caption: 'Choose a Class to add to' , self protocol displayString) notNil
		ifTrue: [self model addClass: chosenClass toProtocol: self protocol]!

addProtocol
	"Prompts for a new protocol to be added to the system"

	((Prompter
		createOn: '' asValue
		prompt: 'Protocol name:'
		caption: 'Add New Protocol…')
		validater: 
				[:name |
				(MethodProtocol isValidProtocolName: name)
					ifTrue: [ValidationResult new]
					ifFalse: [ValidationResult errorMessage: '<p> is not a valid protocol name' << name]];
		showHintWhenEmpty: false;
		showModal)
			ifNotNil: 
				[:name |
				| newProtocol |
				newProtocol := MethodProtocol name: name.
				self
					refreshProtocols;
					protocol: newProtocol]!

addSelector
	"Prompts for a new selector to be added to the currently selected protocol"

	<commandQuery: #canAddSelectors>
	| protocol |
	protocol := self protocol.
	((Prompter
		createOn: '' asValue
		prompt: 'Add Selector:'
		caption: 'Extend <d>…' << protocol)
		validater: 
				[:proposed |
				(Compiler isValidSelector: proposed)
					ifTrue: [ValidationResult new]
					ifFalse: [ValidationResult errorMessage: '<p> is not a valid message selector' << proposed]];
		showHintWhenEmpty: false;
		showModal) ifNotNil: [:new | self model addSelectors: { new asSymbol } toProtocol: protocol]!

addSelectors
	"Prompts for a collection of selector to be added to the currently selected protocol."

	<commandQuery: #canAddSelectors>
	| protocol newSelectors oldSelectors |
	protocol := self protocol.
	oldSelectors := protocol selectors.
	(newSelectors := self model chooseSelectorsInProtocol: protocol forClass: self actualClass) notNil
		ifTrue: 
			[| added removed |
			added := newSelectors difference: oldSelectors.
			self model addSelectors: added toProtocol: protocol.
			removed := oldSelectors difference: newSelectors.
			self model removeSelectors: removed fromProtocol: protocol]!

browseMethods
	"Browse all the methods which are in the currently selected protocols."

	<commandQuery: #hasProtocol>
	self model browseMethodProtocols: { self protocol }!

canAddSelectors
	^self hasProtocol and: [self protocol isReadOnly not]!

canDeleteProtocol
	^self hasProtocol and: [self protocol baseBehaviors isEmpty]!

canRemoveSelectors
	^self hasSelectors and: [self hasProtocol and: [self protocol isReadOnly not]]!

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
		ifTrue: 
			[header := 'Implementing Classes'.
			conformingClasses filter: [:class | (class selectors intersection: selectors) notEmpty]]
		ifFalse: [header := 'Conforming Classes'].
	classesPresenter model: conformingClasses.
	(view viewNamed: 'classesCaption') text: header!

onTipTextRequired: tool query: aCommandQuery
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
	^super onTipTextRequired: tool query: aCommandQuery!

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

	MethodProtocol purgeUnused.
	self refreshProtocols!

queryToggleAnsi: query
	self hasProtocol
		ifTrue: 
			[query
				isChecked: self protocol isANSI;
				beEnabled]
		ifFalse: 
			[query
				isChecked: false;
				beDisabled]!

queryToggleReadOnly: aCommandQuery
	self hasProtocol
		ifTrue: 
			[aCommandQuery
				isChecked: self protocol isReadOnly;
				beEnabled]
		ifFalse: 
			[aCommandQuery
				isChecked: false;
				beDisabled]!

refreshProtocols
	"Private - Fill the protocols list with the available MethodProtocols."

	protocolsPresenter list: MethodProtocol allMethodProtocols.
	self onProtocolSelected!

removeClassFromProtocol
	"Removes the current class from the selected protocol"

	<commandQuery: #hasActualClass>
	self model removeClass: self actualClass fromProtocol: self protocol!

removeProtocol
	"Removes the currently selected protocol from the system."

	<commandQuery: #canDeleteProtocol>
	MethodProtocol removeProtocol: self protocol!

removeSelectors
	"Removes the current selectors from the selected protocol"

	<commandQuery: #canRemoveSelectors>
	self model removeSelectors: self selectors fromProtocol: self protocol!

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

	<commandQuery: #queryToggleAnsi:>
	| prot |
	prot := self protocol.
	prot isANSI: prot isANSI not!

toggleReadOnly
	"Private - Toggle the selected protocol between Read Only and Read/Write modes."

	<commandQuery: #queryToggleReadOnly:>
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
!Tools.ProtocolBrowserShell categoriesForMethods!
actualClass!accessing!public! !
actualClass:!accessing!public! !
addClass!commands-actions!public! !
addProtocol!commands-actions!public! !
addSelector!commands-actions!public! !
addSelectors!commands-actions!public! !
browseMethods!commands-actions!public! !
canAddSelectors!commands-queries!private! !
canDeleteProtocol!commands-queries!private! !
canRemoveSelectors!commands-queries!private! !
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
onTipTextRequired:query:!event handling!public! !
onViewOpened!event handling!public! !
protocol!accessing!public! !
protocol:!accessing!public! !
purgeUnused!commands-actions!public! !
queryToggleAnsi:!commands-queries!private! !
queryToggleReadOnly:!commands-queries!private! !
refreshProtocols!event handling!private! !
removeClassFromProtocol!commands-actions!public! !
removeProtocol!commands-actions!public! !
removeSelectors!commands-actions!public! !
selector!accessing!public! !
selectors!accessing!public! !
setInitialFocus!operations!public! !
shortCaption!accessing!public! !
toggleANSI!commands-actions!private! !
toggleReadOnly!commands-actions!private! !
updateCaption!public!updating! !
!

!Tools.ProtocolBrowserShell class methodsFor!

defaultOptionFlags
	^##(ReuseIfOpenMask | CanUseIdeaSpaceMask)!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Protocol Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^MethodProtocol icon!

initialize
	"Private - Initialize the receiver.

		self initialize.
	"

	SmalltalkSystem current
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	(aspects at: #reuseIfOpen) defaultValue: true.
	aspects add: ((Aspect boolean: #canUseIdeaSpace)
				defaultValue: true;
				yourself).
	^aspects!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 517 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 160 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 8 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 416 nil nil nil 5 nil nil nil 416 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Image_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 306 1 1 306 63 51 416 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 306 193 193 nil 27 8 'imageTools' 18 #{UI.Toolbar} 50 28 nil 160 50 2 8 1409289036 131137 736 nil nil nil 517 nil nil nil 736 352 nil 370 #{Core.IdentityDictionary} 688 nil nil nil nil 50 3 1094 1 #{UI.ToolbarIconButton} 736 1 1350 4 #{UI.CommandDescription} #toggleReadOnly 8 'Lock/unlock protocol' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'Mutex.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil 834 736 1 866 #toggleANSI 8 'Toggle ANSI status' 1 1 914 nil true 946 8 'MethodProtocol_Ansi.ico' 1008 65541 nil nil 582 1 #{UI.ToolbarSeparator} 736 1 nil nil 1 nil nil nil nil nil 514 50 1 562 #createAt:extent: 50 2 306 1051 1 306 109 51 736 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 67 2 0 0 25 0 0 0] 8 #() 704 nil 29 8 'protocolTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1328 nil nil nil 5 nil nil nil 1328 482 #{UI.Toolbar} #resource_Search_tools nil 514 50 1 562 #createAt:extent: 50 2 306 615 1 306 437 51 1328 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 688 704 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1552 nil nil nil 5 nil nil nil 1552 482 #{UI.Toolbar} #resource_Smalltalk_tools nil 514 50 1 562 #createAt:extent: 50 2 306 63 1 306 553 51 1552 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 688 704 nil 27 8 'smalltalkTools' nil nil nil nil 8 #() nil nil 1 nil 306 33 33 nil nil 838 1 #{UI.FlowLayout} 1 1 1 514 50 1 562 #createAt:extent: 50 2 306 1 1 306 1349 51 160 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 162 2 0 0 25 0 0 0] 50 4 416 1552 1328 736 704 nil 29 nil nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1984 nil nil nil 5 nil nil nil 1984 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 true 550 #{Core.IdentityDictionary} 0 nil 514 50 1 562 #createAt:extent: 50 2 306 1 51 306 1349 633 1984 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 162 2 0 0 85 1 0 0] 50 1 18 #{UI.ContainerView} 50 15 nil 1984 50 2 8 1140850688 131073 2288 nil nil nil 5 nil nil nil 2288 2050 518 #{Kernel.STBCollectionProxy} 2080 50 1 518 #{Core.Association} 18 #{UI.ListView} 50 45 nil 2288 50 2 8 1140920393 1 2448 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 352 nil 5 2886 4 #{UI.Menu} nil true 50 3 1094 2 #{UI.CommandMenuItem} 1 866 #addSelector 8 'Add &Selector…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 2658 1 866 #removeSelectors 8 'Remove Se&lectors' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2448 nil nil 518 #{Core.Message} #displayString 8 #() 2818 #iconImageIndex 2848 1350 1 #{Graphics.IconImageManager} nil nil nil 306 65 65 nil nil 2546 2 3142 5 #{UI.ListViewColumn} 8 '' 1 #left 2832 2818 #<= 8 #() nil nil 2448 nil 1 nil nil 2946 8 'Selectors' 435 #left 2832 2818 #<= 8 #() nil nil 2448 nil 3 nil nil #report 8 #() nil 133221 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 514 50 1 562 #createAt:extent: 50 2 306 453 1 306 443 633 2448 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 226 0 0 0 0 0 0 0 191 1 0 0 60 1 0 0] 8 #() 704 nil 35 3 false 370 2112 50 4 18 #{UI.ListView} 50 45 nil 2288 50 2 8 1140920397 1 3280 2514 2546 0 nil 2592 352 nil 29 2610 nil true 50 9 2658 1 866 #toggleReadOnly 8 '&Read Only' 1 1 nil nil nil 2658 1 866 #toggleANSI 8 'AN&SI' 1 1 nil nil nil 2722 4097 2658 1 866 #browseMethods 8 '&Browse Methods…' 1 1 nil nil nil 2658 1 866 #renameMethodProtocol 8 'Rename…' 1 1 914 nil true 946 8 'Rename.ico' 1008 65541 nil nil nil 2658 1 866 #removeProtocol 8 '&Delete' 1 1 914 nil true 946 8 'EditClear.ico' 1008 65541 nil nil nil 2722 4097 2658 1 866 #addProtocol 8 '&Add Protocol…' 1 1 nil nil nil 2658 1 866 #purgeUnused 8 '&Purge Unused Protocols' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3280 nil nil 2818 #name 8 #() 2818 #iconImageIndex 8 #() 2896 nil nil nil nil nil nil 2546 1 2946 8 'Protocols' 435 #left 2818 #name 8 #() 2818 #<= 8 #() nil nil 3280 nil 3 nil nil #report 3088 nil 131169 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 514 50 2 562 #createAt:extent: 50 2 306 1 1 306 443 633 3280 562 #text: 50 1 8 'Protocols' 3280 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 221 0 0 0 60 1 0 0] 8 #() 704 nil 35 8 'protocols' 2448 8 'selectors' nil 514 50 1 562 #createAt:extent: 50 2 306 1 1 306 1349 633 2288 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 162 2 0 0 60 1 0 0] 50 5 3280 18 #{UI.Splitter} 50 12 nil 2288 50 2 8 1140850688 1 4432 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 4432 nil 1 #left nil nil nil 306 1 1 306 9 9 nil 4528 nil 514 50 1 562 #createAt:extent: 50 2 306 443 1 306 11 633 4432 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 0 0 0 0 0 0 0 226 0 0 0 60 1 0 0] 8 #() 704 nil 27 2448 18 #{UI.Splitter} 50 12 nil 2288 50 2 8 1140850688 1 4704 nil nil nil 517 nil nil nil 4498 4704 nil 1 #left nil nil nil 4528 4544 nil 4528 nil 514 50 1 562 #createAt:extent: 50 2 306 895 1 306 11 633 4704 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 1 0 0 0 0 0 0 196 1 0 0 60 1 0 0] 8 #() 704 nil 27 18 #{UI.ContainerView} 50 15 nil 2288 50 2 8 1140850688 131073 4928 nil nil nil 5 nil nil nil 4928 2050 2370 2080 50 1 2418 18 #{UI.StaticText} 50 16 nil 4928 50 2 8 1140916481 1 5056 nil nil nil 5 nil nil nil 5056 nil nil 518 #{UI.NullConverter} nil nil nil 514 50 2 562 #createAt:extent: 50 2 306 1 1 306 445 41 5056 562 #text: 50 1 8 'Conforming classes' 5056 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 222 0 0 0 20 0 0 0] 8 #() 704 nil 27 1 true 370 2112 50 4 18 #{UI.ReferenceView} 50 14 nil 4928 50 2 8 1140850688 131073 5376 nil 352 nil 5 2610 nil true 50 6 2658 1 866 #addClass 8 'Add &Class…' 1 1 nil nil nil 2658 1 866 #removeClassFromProtocol 8 'Remove Cl&ass' 1 1 nil nil nil 2722 4097 2658 1 866 #addSelectors 8 'Selec&tors…' 1 1 nil nil nil 2722 4097 2658 1 866 #browseIt 8 '&Browse Class…' 1 1 914 nil true 946 8 'ClassBrowserShell.ico' 1008 65541 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 5376 482 #{Tools.ClassHierarchySelector} #resource_Default_view nil 514 50 1 562 #createAt:extent: 50 2 306 1 41 306 445 593 5376 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 20 0 0 0 222 0 0 0 60 1 0 0] 688 704 nil 27 8 'classes' 5056 8 'classesCaption' nil 514 50 1 562 #createAt:extent: 50 2 306 905 1 306 445 633 4928 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 196 1 0 0 0 0 0 0 162 2 0 0 60 1 0 0] 50 2 5056 5376 704 nil 27 704 nil 27 704 nil 27 370 2112 50 2 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 5 2610 nil true 50 8 2658 1 866 #fileNew 8 '&New Workspace' 9373 1 914 nil true 946 8 'New Workspace.ico' 1008 65541 nil nil nil 2658 1 866 #fileOpen 8 '&Open Workspace…' 9375 1 914 nil true 946 8 'OpenWorkspace.ico' 1008 65541 nil nil nil 2658 1 866 #fileFileIn 8 '&File In…' 1 1 nil nil nil 2722 4097 2658 1 866 #saveImage 8 'Sa&ve Image' 1 1 914 nil true 946 8 'Snapshot.ico' 1008 65541 nil nil nil 2658 1 866 #smalltalkExit 8 'E&xit Dolphin' 1 1 914 nil true 946 8 'PowerSwitch.ico' 1008 65541 nil nil nil 2722 4097 2658 1 866 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 2610 nil true 50 10 2658 1 866 #addProtocol 8 'Add &Protocol…' 1 1 nil nil nil 2722 4097 2658 1 866 #addSelector 8 'Add &Selector…' 1 1 nil nil nil 2658 1 866 #removeSelectors 8 'Remove Se&lectors.' 1 1 nil nil nil 2722 4097 2658 1 866 #addClass 8 'Add &Class…' 1 1 nil nil nil 2658 1 866 #addSelectors 8 'Add Class Selec&tors…' 1 1 nil nil nil 2658 1 866 #removeClassFromProtocol 8 'Remove Cl&ass' 1 1 nil nil nil 2722 4097 2658 1 866 #purgeUnused 8 'P&urge Unused Protocols' 1 1 nil nil nil 8 '&Protocol' nil 134217729 nil nil nil nil nil 2610 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 2610 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 2610 nil true 50 15 2658 1 866 #helpContents 8 '&Contents' 1025 1 914 nil true 946 8 'Help.ico' 1008 65541 nil nil nil 2658 1 866 #help 8 'On this &Tool' 1249 1 nil nil nil 2658 1 866 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2722 4097 2658 1 866 #learnSmalltalk 8 'Learn Smalltalk' 1 1 6722 8 $🎓 nil 338 #orchid 338 #white nil nil 1 nil nil nil nil 2722 4097 2658 1 866 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2658 1 866 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2658 1 866 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2722 4097 2658 1 866 #dolphinHomePage 8 'Dolphin Homepage' 1 1 914 nil true 946 8 '!!APPLICATION' 1008 65541 nil nil nil 2658 1 866 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2658 1 866 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2722 4097 2658 1 866 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6722 8 $🐬 nil nil 338 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 514 50 2 562 #createAt:extent: 50 2 306 6143 21 306 1381 801 32 562 #text: 50 1 8 'Protocol Browser' 32 642 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 177 14 0 0 154 1 0 0] 50 2 160 1984 704 nil 27)!

toolsFolderHelpId
	^10596! !
!Tools.ProtocolBrowserShell class categoriesForMethods!
defaultOptionFlags!constants!options!private! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
toolsFolderHelpId!public! !
!

