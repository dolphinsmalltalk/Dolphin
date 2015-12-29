"Filed out from Dolphin Smalltalk 2000 release 5.00"!

BrowserApplicationModel subclass: #Navigator
	instanceVariableNames: 'applicationMenuHolder classMenuHolder protocolMenuHolder selectorMenuHolder methodTypes isMeta onlyApplicationSelectors viewHierarchy classTypes environment'
	classVariableNames: 'LastProtocol SortProtocols'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Navigator comment: ''!

Navigator guid: (GUID fromString: '{A8B6C1C8-0E73-11D5-B80B-000102677BBF}')!

!Navigator categoriesForClass!Unclassified! !
!Navigator methodsFor!

addApplicationLabelWidgetTo: aWidget positionBlock: aBlock 
	| labelWidget |
	(self widgetAt: #applicationLabel) notNil ifTrue: [^self].
	self addWidget: (labelWidget := aWidget createLabel: 'applicationLabel'
						argBlock: (self labelArgBlockFor: aBlock))
		named: #applicationLabel.
	self schedulePopUpMenu: applicationMenuHolder for: labelWidget.
	labelWidget manageChild!

addApplicationListWidgetTo: aWidget positionBlock: aBlock 
	self addListWidgetTo: aWidget
		positionBlock: aBlock
		name: #applicationList
		drawCallback: #drawApplication:clientData:callData:
		doubleClick: #expandCollapseApplication
		menu: applicationMenuHolder!

addClassLabelWidgetTo: aWidget positionBlock: aBlock 
	| labelWidget form |
	(self widgetAt: #classLabel) notNil ifTrue: [^self].
	form := aWidget createForm: 'classview' argBlock: nil.
	form manageChild.
	form setValuesBlock: aBlock.
	self addWidget: (labelWidget := form createLabel: 'classLabel'
						argBlock: 
							[:w | 
							w leftAttachment: XmATTACHFORM;
								leftOffset: 2;
								rightAttachment: XmATTACHFORM;
								rightOffset: 2;
								borderWidth: 1;
								labelString: ' ';
								alignment: XmALIGNMENTBEGINNING])
		named: #classLabel.
	labelWidget manageChild.
	self addMetaWidgetTo: form
		positionBlock: 
			[:w | 
			w leftAttachment: XmATTACHFORM;
				leftOffset: 0;
				rightAttachment: XmATTACHFORM;
				rightOffset: 0;
				topAttachment: XmATTACHWIDGET;
				topWidget: (self widgetAt: #classLabel);
				topOffset: 2;
				bottomAttachment: XmATTACHFORM;
				bottomOffset: 0].
	self schedulePopUpMenu: classMenuHolder for: labelWidget!

addClassListWidgetTo: aWidget positionBlock: aBlock 
	| form |
	(self widgetAt: #classList) notNil ifTrue: [^self].
	self addWidget: (form := aWidget createForm: 'classview' argBlock: nil)
		named: #classForm.
	form manageChild.
	form setValuesBlock: aBlock.
	self addMetaWidgetTo: form
		positionBlock: 
			[:w | 
			w leftAttachment: XmATTACHFORM;
				rightAttachment: XmATTACHFORM;
				bottomAttachment: XmATTACHFORM].
	self addListWidgetTo: form
		positionBlock: 
			[:w | 
			w leftAttachment: XmATTACHFORM;
				rightAttachment: XmATTACHFORM;
				topAttachment: XmATTACHFORM;
				bottomAttachment: XmATTACHWIDGET;
				bottomWidget: (self widgetAt: #metaForm)]
		name: #classList
		drawCallback: #drawClass:clientData:callData:
		doubleClick: nil
		menu: classMenuHolder!

addClassNoMetaLabelWidgetTo: aWidget positionBlock: aBlock 
	| labelWidget |
	(self widgetAt: #classLabel) notNil ifTrue: [^self].
	self addWidget: (labelWidget := aWidget createLabel: 'classLabel'
						argBlock: 
							[:w | 
							aBlock value: w.
							w alignment: XmALIGNMENTBEGINNING;
								borderWidth: 1;
								labelString: ' '])
		named: #classLabel.
	self schedulePopUpMenu: classMenuHolder for: labelWidget.
	labelWidget manageChild.
	self addUnmanagedMetaWidgetTo: aWidget positionBlock: [:w | ]!

addClassOptionsMenu
	"Here for subclasses"!

addHierarchyClasses: classes to: aCollection for: aClass 
	aCollection add: aClass name.
	(aClass subclasses asSortedCollection: Class sortBlock) do: 
			[:each | 
			(classes includes: each) ifTrue: 
					[self addHierarchyClasses: classes
						to: aCollection
						for: each]]!

addListWidgetTo: aWidget positionBlock: aBlock name: aSymbol drawCallback: drawSymbol doubleClick: doubleClickSymbol menu: aMenuHolder 
	| listWidget fontHeight |
	fontHeight := self defaultFontHeight.
	(self widgetAt: aSymbol) notNil ifTrue: [^self].
	self addWidget: (listWidget := aWidget 
						createScrolledEwDrawnList: aSymbol asString
						argBlock: 
							[:w | 
							w
								selectionPolicy: XmEXTENDEDSELECT;
								itemHeight: fontHeight;
								scrollHorizontal: false;
								items: #()])
		named: aSymbol.
	listWidget parent setValuesBlock: aBlock.
	listWidget
		addCallback: XmNdisplayCallback
			receiver: self
			selector: drawSymbol
			clientData: nil;
		addCallback: XmNmodifyVerifyCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: [:callData | callData doit: self changeRequest].
	doubleClickSymbol notNil 
		ifTrue: 
			[listWidget 
				addCallback: XmNdefaultActionCallback
				receiver: self
				selector: #processCallback:clientData:callData:
				clientData: doubleClickSymbol].
	aMenuHolder isNil 
		ifFalse: [self schedulePopUpMenu: aMenuHolder for: listWidget].
	listWidget manageChild!

addMetaWidgetTo: aWidget positionBlock: aBlock 
	(self addUnmanagedMetaWidgetTo: aWidget positionBlock: aBlock) manageChild!

addProtocolLabelWidgetTo: aWidget positionBlock: aBlock 
	| labelWidget |
	(self widgetAt: #protocolLabel) notNil ifTrue: [^self].
	self addWidget: (labelWidget := aWidget createLabel: 'protocolLabel'
						argBlock: (self labelArgBlockFor: aBlock))
		named: #protocolLabel.
	self schedulePopUpMenu: classMenuHolder for: labelWidget.
	labelWidget manageChild!

addProtocolListWidgetTo: aWidget positionBlock: aBlock 
	self addListWidgetTo: aWidget
		positionBlock: aBlock
		name: #protocolList
		drawCallback: #drawProtocol:clientData:callData:
		doubleClick: nil
		menu: protocolMenuHolder!

addSelectorLabelWidgetTo: aWidget positionBlock: aBlock 
	| labelWidget |
	(self widgetAt: #selectorLabel) notNil ifTrue: [^self].
	self addWidget: (labelWidget := aWidget createLabel: 'selectorLabel'
						argBlock: (self labelArgBlockFor: aBlock))
		named: #selectorLabel.
	self schedulePopUpMenu: selectorMenuHolder for: labelWidget.
	labelWidget manageChild!

addSelectorListWidgetTo: aWidget positionBlock: aBlock 
	self addListWidgetTo: aWidget
		positionBlock: aBlock
		name: #selectorList
		drawCallback: #drawSelector:clientData:callData:
		doubleClick: nil
		menu: selectorMenuHolder!

addSubAppsFor: anApplication from: oldList to: newList 
	| subApps |
	subApps := anApplication subApplications.
	(subApps detect: [:each | oldList includes: each] ifNone: [nil]) notNil
		ifTrue: 
			[(subApps asSortedCollection: Class sortBlock) do: 
					[:each | 
					newList add: each.
					self addSubAppsFor: each
						from: oldList
						to: newList]]!

addUnmanagedMetaWidgetTo: aWidget positionBlock: aBlock 
	| radioBox form meta instance |
	self addWidget: (form := aWidget createForm: 'metaForm' argBlock: aBlock)
		named: #metaForm.
	self
		addWidget: (form createArrowButton: 'clear'
				argBlock: 
					[:w | 
					w rightAttachment: XmATTACHFORM;
						bottomAttachment: XmATTACHFORM;
						bottomOffset: 2;
						arrowDirection: XmARROWUP])
					manageChild
		named: #clearToClass.
	self whenPushed: (self widgetAt: #clearToClass) perform: #clearToClass.
	radioBox := form createRadioBox: 'meta'
				argBlock: 
					[:w | 
					w orientation: XmHORIZONTAL;
						leftAttachment: XmATTACHFORM;
						topAttachment: XmATTACHFORM;
						bottomAttachment: XmATTACHFORM;
						rightAttachment: XmATTACHWIDGET;
						rightWidget: (self widgetAt: #clearToClass)].
	radioBox manageChild.
	self
		addWidget: (instance := radioBox createToggleButton: 'instance' argBlock: [:w | w set: true])
		named: #instance.
	instance manageChild.
	self
		addWidget: (meta := radioBox createToggleButton: 'class' argBlock: [:w | w set: false])
		named: #meta.
	meta addCallback: XmNvalueChangedCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: 
				[self changeRequest
					ifTrue: 
						[isMeta := meta set.
						self changedMeta]
					ifFalse: [self meta: isMeta]];
		manageChild.
	^form!

application
	^self selectionFor: self applicationList!

applicationList
	^#application!

applicationMenu
	^applicationMenuHolder!

applications

	^OrderedCollection new

"rbDmm changed
	^self selectionsFor: self applicationList

	^^^^^ this is specific to the va gui"!

beHierarchy!

bothClassesBlock
	^[:class | true]!

bothSelectorsBlock
	^
	[:class :selector | 
	| method |
	method := class compiledMethodAt: selector ifAbsent: [nil].
	method notNil and: 
			[onlyApplicationSelectors not
				or: [self applications includes: method application]]]!

changedApplication
	self updateClassList.
	self updateApplicationMenu.
	self changed: #application!

changedClass
	self updateProtocolList.
	self updateClassMenu.
	self changed: #class!

changedMeta
	self updateProtocolList.
	self changed: #meta!

changedProtocol
	| protocol |
	protocol := self protocol.
	protocol notNil ifTrue: [LastProtocol := protocol].
	self updateSelectorList.
	self updateProtocolMenu.
	self changed: #protocol!

changedSelector
	self updateSelectorMenu.
	self changed: #selector!

classForName: className 
	| class |
	className isNil ifTrue: [^nil].
	class := self environment at: className ifAbsent: [nil].
	class isBehavior ifFalse: [^nil].
	^class!

classList
	^#class!

classMenu
	^classMenuHolder!

className
	^self selectionFor: self classList!

classNames

	^OrderedCollection new

"rbDmm
	^self selectionsFor: self classList

	^^^^^this is specific to the va gui"

	!

clearToClass
	self changeRequest ifFalse: [^self].
	self newProtocolList: #().
	self changedProtocol!

closed
	self changed: #closed!

drawApplication: aWidget clientData: ignored callData: callData 
	| numParents application parentApp name |
	self setFontFor: aWidget gc.
	application := callData object.
	parentApp := application parent.
	application isRemoved
		ifTrue: [^self drawString: '--Removed--' using: callData].
	name := (self isApplicationExpanded: application)
				ifTrue: [application name]
				ifFalse: [application name , '...'].
	numParents := 0.
	[parentApp notNil] whileTrue: 
			[numParents := numParents + 1.
			parentApp := parentApp parent].
	self
		drawString: ((String new: numParents * self spacesForChild) atAllPut: $ ;
				yourself) , name
		using: callData!

drawClass: aWidget clientData: ignored callData: callData 
	| name |
	self setFontFor: aWidget gc.
	name := viewHierarchy
				ifTrue: 
					[((String
						new: (self
								numSuperclasses: (Smalltalk at: callData object asSymbol ifAbsent: [Object]))
									* self spacesForChild)
						atAllPut: $ ;
						yourself) , callData object]
				ifFalse: [callData object].
	self drawString: name using: callData!

drawProtocol: aWidget clientData: ignored callData: callData 
	| string |
	self setFontFor: aWidget gc.
	string := (self includesMethodsIn: callData object)
				ifTrue: [callData object]
				ifFalse: ['(<1s>)' expandMacrosWith: callData object].
	self drawString: string using: callData!

drawSelector: aWidget clientData: ignored callData: callData 
	self setFontFor: aWidget gc.
	self drawString: callData object using: callData!

environment
	^environment!

environment: aBrowserEnvironment 
	environment := aBrowserEnvironment!

expandCollapseApplication
	| application oldList |
	application := self application.
	application isNil ifTrue: [^self].
	oldList := self listFrom: self applicationList.
	(self isApplicationExpanded: application)
		ifTrue: 
			[application allSubApplications
				do: [:each | oldList remove: each ifAbsent: []]]
		ifFalse: 
			[oldList addAll: (application subApplications
						asSortedCollection: Class sortBlock)
				afterIndex: (oldList indexOf: application ifAbsent: [oldList size])].
	self setList: oldList in: self applicationList.
	self select: application in: self applicationList!

findClass
	"Prompt for a class and position myself there."

	| testClass |
	self changeRequest ifFalse: [^self].
	
	[testClass := self pickAClass: 'Find class'.
	testClass = '' ifTrue: [^self].
	testClass isNil and: 
			[(self confirm: 'No matching class, try again?')
				ifFalse: [^self]
				ifTrue: [true]]]
			whileTrue: [].
	testClass isBehavior ifFalse: [testClass := testClass class].
	testClass isMetaclass ifTrue: [testClass := testClass primaryInstance].
	self isMetaclass ifTrue: [testClass := testClass class].
	self selectClass: testClass.
	self changedClass!

findMethodAndSelectAlphabetic
	| chosenSelector selectorCollection selector block |
	self changeRequest ifFalse: [^self].
	selector := self request: 'Find selector:'.
	selector isEmpty ifTrue: [^self].
	block := self selectorFilterBlock.
	selectorCollection := ((self environment selectorsForClass: self selectedClass)
				select: [:each | (selector match: each) and: [block value: each]])
					asSortedCollection.
	selectorCollection isEmpty ifTrue: 
			[^(self confirm: 'No selectors found.<n>Search again?' expandMacros)
				ifTrue: [self findMethodAndSelectAlphabetic]].
	chosenSelector := selectorCollection size == 1
				ifTrue: [selectorCollection first]
				ifFalse: 
					[self choose: 'Find which selector?'
						fromList: selectorCollection
						values: selectorCollection
						lines: 10
						cancel: [nil]].
	chosenSelector isNil ifTrue: [^self].
	self setSelector: chosenSelector.
	LastProtocol := self protocol.
	self changedSelector!

getState
	| state |
	state := self navigatorStateClass new.
	state applications: self applications.
	state isMetaclass: self isMetaclass.
	state classNames: self classNames.
	state protocols: self protocols.
	state selectors: self selectors. 
	^state!

hierarchyClassListFor: classNames 
	| classes newNames |
	classes := Set new.
	classNames do: 
			[:name | 
			| class |
			class := Smalltalk at: name ifAbsent: [Object].
			classes add: class.
			class allSuperclassesDo: [:each | classes add: each]].
	newNames := OrderedCollection new: classes size.
	((classes select: [:each | each superclass isNil])
		asSortedCollection: Class sortBlock) do: 
				[:each | 
				self addHierarchyClasses: classes
					to: newNames
					for: each].
	^newNames!

includesMethodsIn: aProtocol 
	| class |
	class := self selectedClass.
	class isNil ifTrue: [^false].
	^((self environment selectorsFor: aProtocol in: class)
		detect: self selectorFilterBlock ifNone: [nil]) notNil!

initialize
	super initialize.
	self addClassOptionsMenu.
"rbDmm menuHolders not needed (I think)
	protocolMenuHolder := self initializeMenu: self class protocolMenu. 
	selectorMenuHolder := self initializeMenu: self class selectorMenu. "
	self meta: false.
	methodTypes := #bothSelectorsBlock.
	onlyApplicationSelectors := true.
	viewHierarchy := false.
	classTypes := #bothClassesBlock!

isApplicationExpanded: application 
	| apps |
	application hasSubApplications ifFalse: [^true].
	apps := self listFrom: self applicationList.
	^(apps at: ((apps indexOf: application ifAbsent: [0]) + 1 min: apps size))
		parent == application!

isHierarchy
	^false!

isMetaclass
	^isMeta!

labelArgBlockFor: aBlock 
	^
	[:w | 
	aBlock value: w.
	w alignment: XmALIGNMENTBEGINNING;
		borderWidth: 1;
		labelString: ' ']!

listFrom: aSymbol 
	| widget |
	widget := self widgetAt: (self listLabelFor: aSymbol).
	widget isNil ifTrue: 
			[widget := self widgetAt: (aSymbol , 'Label') asSymbol.
			widget isNil ifTrue: [^OrderedCollection new].
			^OrderedCollection with: widget userData].
	^widget items!

listLabelFor: aSymbol 
	^(aSymbol , 'List') asSymbol!

meta: aBoolean 
	| widget |
	isMeta := aBoolean.
"rbDmm 
the rest is VA gui specific
	(self widgetAt: #protocolLabel) notNil ifTrue: 
			[widget := self widgetAt: #classLabel.
			widget isNil ifTrue: [^self].
			widget
				labelString: (aBoolean ifTrue: [widget userData , ' class'] ifFalse: [widget userData]).].
	widget := self widgetAt: #meta.
	widget isNil ifTrue: [^self].
	widget set: aBoolean.
	widget := self widgetAt: #instance.
	widget isNil ifTrue: [^self].
	widget set: aBoolean not 
"!

navigatorStateClass
	^NavigatorState!

newApplicationList: initialSelections 
	self newApplicationListNoUpdate: initialSelections.
	self updateClassList!

newApplicationListNoUpdate: initialSelections 
	| oldList newList roots |
	oldList := self listFrom: self applicationList.
	roots := Set new.
	initialSelections do: 
			[:each | 
			oldList addAll: each allParents;
				add: each].
	self environment applications do: [:each | roots add: each rootApplication].
	newList := OrderedCollection new.
	(roots asSortedCollection: Class sortBlock) do: 
			[:each | 
			newList add: each.
			self addSubAppsFor: each
				from: oldList
				to: newList].
	self setList: newList in: self applicationList.
	self selectAll: initialSelections in: self applicationList.
	self updateApplicationMenu!

newClassList: initialSelections 
	self newClassListNoUpdate: initialSelections.
"rbDmm VA code	self updateProtocolList "!

newClassListNoUpdate: initialSelections 
	| applications classNames block |
	applications := self applications.
	classNames := Set new.
	block := self perform: classTypes.
	applications do: 
			[:each | 
			each isRemoved ifFalse: [classNames addAll: ((self environment classNamesFor: each) select: block)]].
	classNames := viewHierarchy
				ifTrue: [self hierarchyClassListFor: classNames]
				ifFalse: [classNames asSortedCollection].
	self setList: classNames in: self classList.
	self selectAll: initialSelections in: self classList.
"rbDmm VA -------------------------------------
	self updateClassMenu
------------------------------------------------"!

newProtocolList: initialSelections 
	self newProtocolListNoUpdate: initialSelections.
	self updateSelectorList!

newProtocolListNoUpdate: initialSelections 
	| class protocols |
	class := self selectedClass.
	protocols := (class notNil and: [self application notNil and: [self classNames size = 1]])
				ifTrue: [self environment protocolsFor: class]
				ifFalse: [#()].
	SortProtocols ifTrue: [protocols := protocols asSortedCollection].
	self setList: protocols in: self protocolList.
	self selectAll: initialSelections in: self protocolList.
	self updateProtocolMenu!

newSelectorList: initialSelections 
	| protocols class selectors |
	class := self selectedClass.
	class isNil
		ifTrue: [selectors := #()]
		ifFalse: 
			[selectors := Set new.
			protocols := self protocols.
			protocols do: [:each | selectors addAll: (self environment selectorsFor: each in: class)]].
	selectors := selectors select: self selectorFilterBlock.
	self setList: selectors asSortedCollection in: self selectorList.
	self selectAll: initialSelections in: self selectorList.
	self updateSelectorMenu!

nonMetaClass
	^self classForName: self className!

nonMetaClasses
	| names classes |
	names := self classNames.
	classes := OrderedCollection new: names size.
	names
		do: 
			[:each | 
			| class |
			class := self classForName: each.
			class notNil ifTrue: [classes add: class]].
	^classes!

numSuperclasses: aClass 
	| i class |
	i := 0.
	class := aClass.
	[(class := class superclass) isNil] whileFalse: [i := i + 1].
	^i!

pickAClass: prompt 
	| destClassName destClass classes |
	destClassName := self request: prompt.
	destClassName = '' ifTrue: [^''].
	classes := self showWaitCursorWhile: 
					[(self environment classNames select: [:cn | destClassName match: cn])
						asSortedCollection].
	(classes isNil or: [classes isEmpty])
		ifTrue: 
			[classes := (self environment keys select: [:cn | destClassName match: cn])
						asSortedCollection.
			classes isEmpty ifTrue: [^nil].
			(self
				confirm: 'There are no matching class names.<n>Do you want to browse matching globals?'
						expandMacros)
					ifFalse: [^nil].
			destClassName := self choose: 'Browse the class of which global?'
						fromList: classes
						values: (classes collect: [:glob | (self environment at: glob) class name])
						lines: 5
						cancel: [^'']]
		ifFalse: 
			[destClassName := classes size = 1
						ifTrue: [classes first]
						ifFalse: 
							[self choose: 'Choose a class'
								fromList: classes
								values: classes
								lines: 10
								cancel: [^'']]].
	destClass := self environment at: destClassName asSymbol ifAbsent: [^nil].
	self isMetaclass ifTrue: [destClass := destClass class].
	^destClass!

postBuild
	| selection |
	super postBuild.
	#(#application #class #protocol #selector) do: 
			[:each | 
			| widget |
			widget := self widgetAt: (each , 'List') asSymbol.
			widget notNil ifTrue: 
					[widget addCallback: XmNextendedSelectionCallback
						receiver: self
						selector: #processCallback:clientData:callData:
						clientData: ('changed' , ((each asString) at: 1 put: each first asUppercase;
										yourself))
								asSymbol]].
	selection := self environment applications.
	selection size == 1 ifFalse: [selection := #()].
	self newApplicationList: selection.
	selection := selection size == 1
		ifTrue: [self environment classNamesFor: selection first]
		ifFalse: [#()].
	selection := selection size == 1 ifTrue: [selection asArray] ifFalse: [#()].
	self newClassList: selection.
	self updateMenus!

privateClassesBlock
	^
	[:className | 
	| class |
	class := Smalltalk at: className ifAbsent: [nil].
	class notNil and: [class isPrivate]]!

privateSelectorsBlock
	^
	[:class :selector | 
	| method |
	method := class compiledMethodAt: selector ifAbsent: [nil].
	method notNil and: 
			[method isPrivate and: 
					[onlyApplicationSelectors not
						or: [self applications includes: method application]]]]!

protocol
	^self selectionFor: self protocolList!

protocolList
	^#protocol!

protocolMenu
	^protocolMenuHolder!

protocols

	^OrderedCollection new

"rbDmm
	^self selectionsFor: self protocolList

this is specific to the va gui"
	!

publicClassesBlock
	^
	[:className | 
	| class |
	class := Smalltalk at: className ifAbsent: [nil].
	class notNil and: [class isPublic]]!

publicSelectorsBlock
	^
	[:class :selector | 
	| method |
	method := class compiledMethodAt: selector ifAbsent: [nil].
	method notNil and: 
			[method isPublic and: 
					[onlyApplicationSelectors not
						or: [self applications includes: method application]]]]!

selectAll: aCollection in: aSymbol 
	| widget label |
	label := self listLabelFor: aSymbol.
	widget := self widgetAt: label.
	widget isNil
		ifTrue: 
			[| item string |
			widget := self widgetAt: (aSymbol , 'Label') asSymbol.
			widget isNil ifTrue: [^self].
			item := aCollection isEmpty ifTrue: [nil] ifFalse: [aCollection first].
			string := item isNil
						ifTrue: [' ']
						ifFalse: [item isString ifTrue: [item] ifFalse: [item printString]].
			(item notNil and: 
					[self isMetaclass
						and: [aSymbol == #class and: [(self widgetAt: #protocolLabel) notNil]]])
				ifTrue: [string := string , ' class'].
			widget userData: item.
			widget labelString: string]
		ifFalse: [super selectAll: aCollection in: label]!

selectClass: aClass 
	| names meta apps |
	aClass isNil
		ifTrue: 
			[names := #().
			apps := #().
			meta := self isMetaclass]
		ifFalse: 
			[apps := OrderedCollection new. "rbDmm aClass applications."
			meta := aClass isMeta. "class."
			names := meta
						ifTrue: [Array with: aClass primaryInstance name]
						ifFalse: [Array with: aClass name]].
	self selectClasses: names
		meta: meta
		in: apps.
	self updateProtocolList!

selectClasses: classNames meta: aBoolean in: appCollection 
	| apps |
	self meta: aBoolean.
"rbDmm VA code ------------------------
	apps := appCollection asOrderedCollection.
	classNames do: 
			[:each | 
			| class |
			class := Smalltalk at: each ifAbsent: [nil].
			class notNil ifTrue: 
					[(class applications detect: [:app | apps includes: app] ifNone: [nil])
						isNil ifTrue: [apps add: class controller]]].
	self newApplicationListNoUpdate: apps.
--------------------------------------------------"
	self newClassListNoUpdate: classNames!

selectedClass
	| class |
	class := self nonMetaClass.
	^(class notNil and: [self isMetaclass]) ifTrue: [class class] ifFalse: [class]!

selectedClasses
	| nonMetaClasses |
	nonMetaClasses := self nonMetaClasses.
	^self isMetaclass
		ifTrue: [nonMetaClasses collect: [:each | each class]]
		ifFalse: [nonMetaClasses]!

selectionsFor: aSymbol 
	| widget |
	widget := self widgetAt: (self listLabelFor: aSymbol).
	widget isNil ifTrue: 
			[widget := self widgetAt: (aSymbol , 'Label') asSymbol.
			(widget isNil or: [widget userData isNil]) ifTrue: [^#()].
			^Array with: widget userData].
	^widget selectedItems!

selector
	^self selectionFor: self selectorList!

selectorFilterBlock
	| block class |
	block := self perform: methodTypes.
	class := self selectedClass.
	^[:selector | block value: class value: selector]!

selectorList
	^#selector!

selectorMenu
	^selectorMenuHolder!

selectors

	^OrderedCollection new

"rbDmm
	^self selectionsFor: self selectorList

this is specific to the va gui"

	!

setList: aCollection in: aSymbol 
	| widget data label |
	label := self listLabelFor: aSymbol.
	widget := self widgetAt: label.
	widget isNil
		ifTrue: 
			[widget := self widgetAt: (aSymbol , 'Label') asSymbol.
			widget isNil ifTrue: [^self].
			data := aCollection isEmpty ifTrue: [nil] ifFalse: [aCollection first].
			self select: data in: aSymbol]
		ifFalse: [super setList: aCollection in: label]!

setSelector: aSelector 
	aSelector isNil ifTrue: [^self].
	self setSelectors: (Array with: aSelector)
		in: (self environment whichProtocolsIncludes: aSelector in: self selectedClass)!

setSelectors: selectorCollection in: protocolCollection 
	| protocols class selectors |
	class := self selectedClass.
	class isNil
		ifTrue: [selectors := (protocols := #())]
		ifFalse: 
			[selectors := selectorCollection.
			protocols := protocolCollection asOrderedCollection.
			selectorCollection do: 
					[:each | 
					((self environment whichProtocolsIncludes: each in: class)
						detect: [:protocol | protocols includes: protocol]
						ifNone: [nil]) isNil ifTrue: 
							[protocols addAll: (self environment whichProtocolsIncludes: each in: class)]]].
	self newProtocolListNoUpdate: protocols.
	self newSelectorList: selectors!

setState: aNavigatorState 
	self setState: aNavigatorState updateClasses: false!

setState: aNavigatorState updateClasses: aBoolean 
	"Set the current selections to be that of aNavigatorState. If aBoolean is true then update the
	application and class lists, otherwise only update them if their values have changed."

	aNavigatorState classNames isEmpty
		ifTrue: 
			["rbDmm VAself newApplicationListNoUpdate: aNavigatorState applications."
			self newClassList: #()]
		ifFalse: 
			[(aBoolean not and: 
					[self isMetaclass == aNavigatorState isMetaclass and: 
							[aNavigatorState classNames = self classNames
								and: [aNavigatorState applications = self applications]]])
				ifFalse: 
					[self selectClasses: aNavigatorState classNames
						meta: aNavigatorState isMetaclass
						in: aNavigatorState applications].
"rbDmm VA ----------------------------------------------------------------------------
			self setSelectors: aNavigatorState selectors in: aNavigatorState protocols
-------------------------------------------------------------------------------"
]!

showSelectors: aSymbol 
	self changeRequest.
	methodTypes := aSymbol.
	self updateSelectorList.
	self changedSelector!

updateApplicationList
	self changeRequest ifFalse: [^self].
	self setState: self getState updateClasses: true.
	self changed: #application!

updateApplicationMenu
	self application isNil
		ifTrue: [applicationMenuHolder disableAllExcept: #('Add...' 'Update' 'Find Class...')]
		ifFalse: [applicationMenuHolder enableAll]!

updateClassList
	self newClassList: self classNames!

updateClassMenu
"rbDmm
	self className isNil
		ifTrue: [classMenuHolder disableAllExcept: #('Options')]
		ifFalse: [classMenuHolder enableAll]
VA
"
!

updateMenus
	self updateApplicationMenu.
	self updateClassMenu.
	self updateProtocolMenu.
	self updateSelectorMenu!

updateProtocolList
"rbDmm
	self newProtocolList: self protocols 
VA
"!

updateProtocolMenu
	self className isNil
		ifTrue: [protocolMenuHolder disableAll]
		ifFalse: 
			[self protocol isNil
				ifTrue: 
					[protocolMenuHolder
						disableAllExcept: #('Add...' 'Find Method...' 'Remove Empty Protocols')]
				ifFalse: [protocolMenuHolder enableAll]]!

updateSelectorList
	self newSelectorList: self selectors!

updateSelectorMenu
	self selector isNil
		ifTrue: 
			[selectorMenuHolder disableAllExcept: (self selectedClass isNil
						ifTrue: [#('Options')]
						ifFalse: [#('Options' 'Available Methods...')])]
		ifFalse: [selectorMenuHolder enableAll]!

windowMenuItems
	| menus |
	menus := OrderedCollection new.
	menus
		add: '&Application' -> self applicationMenu;
		add: '&Class' -> self classMenu;
		add: '&Protocol' -> self protocolMenu;
		add: '&Selector' -> self selectorMenu.
	^menus! !
!Navigator categoriesFor: #addApplicationLabelWidgetTo:positionBlock:!*-unclassified!public! !
!Navigator categoriesFor: #addApplicationListWidgetTo:positionBlock:!*-unclassified!public! !
!Navigator categoriesFor: #addClassLabelWidgetTo:positionBlock:!*-compilation failures!*-unclassified!public! !
!Navigator categoriesFor: #addClassListWidgetTo:positionBlock:!*-compilation failures!*-unclassified!public! !
!Navigator categoriesFor: #addClassNoMetaLabelWidgetTo:positionBlock:!*-compilation failures!*-unclassified!public! !
!Navigator categoriesFor: #addClassOptionsMenu!*-unclassified!public! !
!Navigator categoriesFor: #addHierarchyClasses:to:for:!*-unclassified!public! !
!Navigator categoriesFor: #addListWidgetTo:positionBlock:name:drawCallback:doubleClick:menu:!*-compilation failures!*-unclassified!public! !
!Navigator categoriesFor: #addMetaWidgetTo:positionBlock:!*-unclassified!public! !
!Navigator categoriesFor: #addProtocolLabelWidgetTo:positionBlock:!*-unclassified!public! !
!Navigator categoriesFor: #addProtocolListWidgetTo:positionBlock:!*-unclassified!public! !
!Navigator categoriesFor: #addSelectorLabelWidgetTo:positionBlock:!*-unclassified!public! !
!Navigator categoriesFor: #addSelectorListWidgetTo:positionBlock:!*-unclassified!public! !
!Navigator categoriesFor: #addSubAppsFor:from:to:!*-unclassified!public! !
!Navigator categoriesFor: #addUnmanagedMetaWidgetTo:positionBlock:!*-compilation failures!*-unclassified!public! !
!Navigator categoriesFor: #application!*-unclassified!public! !
!Navigator categoriesFor: #applicationList!*-unclassified!public! !
!Navigator categoriesFor: #applicationMenu!*-unclassified!public! !
!Navigator categoriesFor: #applications!*-unclassified!public! !
!Navigator categoriesFor: #beHierarchy!*-unclassified!public! !
!Navigator categoriesFor: #bothClassesBlock!*-unclassified!public! !
!Navigator categoriesFor: #bothSelectorsBlock!*-unclassified!public! !
!Navigator categoriesFor: #changedApplication!*-unclassified!public! !
!Navigator categoriesFor: #changedClass!*-unclassified!public! !
!Navigator categoriesFor: #changedMeta!*-unclassified!public! !
!Navigator categoriesFor: #changedProtocol!*-unclassified!public! !
!Navigator categoriesFor: #changedSelector!*-unclassified!public! !
!Navigator categoriesFor: #classForName:!*-unclassified!public! !
!Navigator categoriesFor: #classList!*-unclassified!public! !
!Navigator categoriesFor: #classMenu!*-unclassified!public! !
!Navigator categoriesFor: #className!*-unclassified!public! !
!Navigator categoriesFor: #classNames!*-unclassified!public! !
!Navigator categoriesFor: #clearToClass!*-unclassified!public! !
!Navigator categoriesFor: #closed!*-unclassified!public! !
!Navigator categoriesFor: #drawApplication:clientData:callData:!*-unclassified!public! !
!Navigator categoriesFor: #drawClass:clientData:callData:!*-unclassified!public! !
!Navigator categoriesFor: #drawProtocol:clientData:callData:!*-unclassified!public! !
!Navigator categoriesFor: #drawSelector:clientData:callData:!*-unclassified!public! !
!Navigator categoriesFor: #environment!*-unclassified!public! !
!Navigator categoriesFor: #environment:!*-unclassified!public! !
!Navigator categoriesFor: #expandCollapseApplication!*-unclassified!public! !
!Navigator categoriesFor: #findClass!*-unclassified!public! !
!Navigator categoriesFor: #findMethodAndSelectAlphabetic!*-unclassified!public! !
!Navigator categoriesFor: #getState!*-unclassified!public! !
!Navigator categoriesFor: #hierarchyClassListFor:!*-unclassified!public! !
!Navigator categoriesFor: #includesMethodsIn:!*-unclassified!public! !
!Navigator categoriesFor: #initialize!*-unclassified!public! !
!Navigator categoriesFor: #isApplicationExpanded:!*-unclassified!public! !
!Navigator categoriesFor: #isHierarchy!*-unclassified!public! !
!Navigator categoriesFor: #isMetaclass!*-unclassified!public! !
!Navigator categoriesFor: #labelArgBlockFor:!*-compilation failures!*-unclassified!public! !
!Navigator categoriesFor: #listFrom:!*-unclassified!public! !
!Navigator categoriesFor: #listLabelFor:!*-unclassified!public! !
!Navigator categoriesFor: #meta:!*-unclassified!public! !
!Navigator categoriesFor: #navigatorStateClass!*-unclassified!public! !
!Navigator categoriesFor: #newApplicationList:!*-unclassified!public! !
!Navigator categoriesFor: #newApplicationListNoUpdate:!*-unclassified!public! !
!Navigator categoriesFor: #newClassList:!*-unclassified!public! !
!Navigator categoriesFor: #newClassListNoUpdate:!*-unclassified!public! !
!Navigator categoriesFor: #newProtocolList:!*-unclassified!public! !
!Navigator categoriesFor: #newProtocolListNoUpdate:!*-unclassified!public! !
!Navigator categoriesFor: #newSelectorList:!*-unclassified!public! !
!Navigator categoriesFor: #nonMetaClass!*-unclassified!public! !
!Navigator categoriesFor: #nonMetaClasses!*-unclassified!public! !
!Navigator categoriesFor: #numSuperclasses:!*-unclassified!public! !
!Navigator categoriesFor: #pickAClass:!*-unclassified!public! !
!Navigator categoriesFor: #postBuild!*-compilation failures!*-unclassified!public! !
!Navigator categoriesFor: #privateClassesBlock!*-unclassified!public! !
!Navigator categoriesFor: #privateSelectorsBlock!*-unclassified!public! !
!Navigator categoriesFor: #protocol!*-unclassified!public! !
!Navigator categoriesFor: #protocolList!*-unclassified!public! !
!Navigator categoriesFor: #protocolMenu!*-unclassified!public! !
!Navigator categoriesFor: #protocols!*-unclassified!public! !
!Navigator categoriesFor: #publicClassesBlock!*-unclassified!public! !
!Navigator categoriesFor: #publicSelectorsBlock!*-unclassified!public! !
!Navigator categoriesFor: #selectAll:in:!*-unclassified!public! !
!Navigator categoriesFor: #selectClass:!*-unclassified!public! !
!Navigator categoriesFor: #selectClasses:meta:in:!*-unclassified!public! !
!Navigator categoriesFor: #selectedClass!*-unclassified!public! !
!Navigator categoriesFor: #selectedClasses!*-unclassified!public! !
!Navigator categoriesFor: #selectionsFor:!*-unclassified!public! !
!Navigator categoriesFor: #selector!*-unclassified!public! !
!Navigator categoriesFor: #selectorFilterBlock!*-unclassified!public! !
!Navigator categoriesFor: #selectorList!*-unclassified!public! !
!Navigator categoriesFor: #selectorMenu!*-unclassified!public! !
!Navigator categoriesFor: #selectors!*-unclassified!public! !
!Navigator categoriesFor: #setList:in:!*-unclassified!public! !
!Navigator categoriesFor: #setSelector:!*-unclassified!public! !
!Navigator categoriesFor: #setSelectors:in:!*-unclassified!public! !
!Navigator categoriesFor: #setState:!*-unclassified!public! !
!Navigator categoriesFor: #setState:updateClasses:!*-unclassified!public! !
!Navigator categoriesFor: #showSelectors:!*-unclassified!public! !
!Navigator categoriesFor: #updateApplicationList!*-unclassified!public! !
!Navigator categoriesFor: #updateApplicationMenu!*-unclassified!public! !
!Navigator categoriesFor: #updateClassList!*-unclassified!public! !
!Navigator categoriesFor: #updateClassMenu!*-unclassified!public! !
!Navigator categoriesFor: #updateMenus!*-unclassified!public! !
!Navigator categoriesFor: #updateProtocolList!*-unclassified!public! !
!Navigator categoriesFor: #updateProtocolMenu!*-unclassified!public! !
!Navigator categoriesFor: #updateSelectorList!*-unclassified!public! !
!Navigator categoriesFor: #updateSelectorMenu!*-unclassified!public! !
!Navigator categoriesFor: #windowMenuItems!*-unclassified!public! !

!Navigator class methodsFor!

initializeAfterLoad
	"self initialize"

	LastProtocol := ''.
	SortProtocols := true! !
!Navigator class categoriesFor: #initializeAfterLoad!*-unclassified!public! !

