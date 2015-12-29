"Filed out from Dolphin Smalltalk X6.2"!

AspectInspector subclass: #AbstractPublishedAspectInspector
	instanceVariableNames: 'aspectValueHolder aspectPresenter isRootAspectVisible isSingleLevelOnly'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractPublishedAspectInspector guid: (GUID fromString: '{F1CDCDF4-E0B8-4070-953A-C17010BAB8AD}')!
AbstractPublishedAspectInspector comment: ''!
!AbstractPublishedAspectInspector categoriesForClass!Development! !
!AbstractPublishedAspectInspector methodsFor!

addToCommandRoute: route 
	"Private - Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer self to have the command policy decide where
	to go next."

	route appendPresenter: self.
!

aspectChanged: aSymbol 
	"Private - Inform the receiver that its model has had an aspect or aspects with the
	<Symbol> name, aSymbol, externally updated. Update all displayed aspects 
	with this name, if any."

	| accessors |
	accessors := aspectTreePresenter view displayedContents 
				select: [:each | each aspectDescriptor name == aSymbol].
	accessors notEmpty 
		ifTrue: 
			[accessors do: [:each | aspectTreePresenter model collapse: each].
			self onAspectSelected]!

aspectChanged: aSymbol of: anObject
	"Private - Inform the receiver that its model has had the aspect named by the <Symbol,
	aSymbol, and <Object> subject, anObject, externally updated.
	Force the tree to update if it is displaying this aspect."

	| aspect |
	aspect := aspectTreePresenter view displayedContents 
				detect: [:each | each aspectDescriptor name == aSymbol and: [each subject == anObject]]
				ifNone: [].
	aspect isNil 
		ifFalse: 
			[aspectTreePresenter model collapse: aspect.
			self onAspectSelected]!

aspectTree
	^aspectTreePresenter model!

buildNewAspectTree
	| aspectTreeModel rootAccessor value publishedAspects roots |
	value := self value.
	publishedAspects := self getAspectsFor: value.
	self isRootAspectVisible 
		ifTrue: 
			[rootAccessor := (publishedAspects at: #yourself ifAbsent: [Aspect name: #yourself])
						beMutable;
						beReadOnly;
						accessorFor: value]
		ifFalse: 
			["If the value is nil and we are not showing the root then show nothing"
			publishedAspects := value 
						ifNil: [publishedAspects := LookupTable new]
						ifNotNil: 
							[:v | 
							publishedAspects removeKey: #yourself.
							publishedAspects]].
	roots := rootAccessor notNil 
				ifTrue: [Array with: rootAccessor]
				ifFalse: [self sortAspects: (publishedAspects asArray collect: [:each | each accessorFor: value])].
	aspectTreeModel := ExpandingTreeModel withRoots: roots.
	aspectTreeModel getChildrenBlock: (self isSingleLevelOnly 
				ifTrue: [[:each | #()]]
				ifFalse: [[:each | self getSubAspectAccessorsFor: each]]).
	"(self sortAspects: publishedAspects) do: 
			[:each | 
			each name == #yourself 
				ifFalse: [aspectTreeModel add: (each accessorFor: value) asChildOf: rootAccessor]]."
	aspectTreePresenter model: aspectTreeModel.
	rootAccessor notNil ifTrue: [aspectTreePresenter expand: rootAccessor]!

createSchematicWiring
	"Private - Create the trigger wiring for the receiver"

	super createSchematicWiring.
	aspectTreePresenter 
		when: #actionPerformed
		send: #onAspectActioned
		to: self.
	aspectTreePresenter 
		when: #leftButtonPressed:
		send: #onLeftButtonPressed:
		to: self.
!

createValueHolderFor: anAspectAccessor 
	"Private - Create a ValueHolder to hold the contents of anAspectAccessor and place it in
	aspectValueModel. We need to create a separate value model here (rather than just using
	anAspectAccessorOrNil itself) because some aspects may not be writeable and we need our
	intermediate model to always be so. Answer true if successful, false otherwise."

	aspectValueHolder := ValueHolder comparisonPolicy: SearchPolicy never.
	aspectValueHolder 
		when: #valueChanged
		send: #onAspectValueChanged:
		to: self
		with: anAspectAccessor.
	^self setMutableValueOf: anAspectAccessor into: aspectValueHolder!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it. This will be used as the label for the tab when the receiver is being displayed
	within the Flipper Inspector"

	aStream nextPutAll: 'Published Aspects'!

editAspect
	"Edit the currently selected aspect using the current aspect presenter"

	self aspectAccessor editUsing: aspectPresenter!

getAspectsFor: anObject 
	^[anObject publishedAspects] on: Error
		do: 
			[:ex | 
			ex toTrace.
			LookupTable with: (Aspect name: #yourself)]!

getSubAspectAccessorsFor: anAspectAccessor 
	"Private - Answer a <sequencedReadableCollection> of the <AspectAccessor> child nodes 
	below the <AspectAccessor> argument."

	| subValue subject |
	anAspectAccessor isReadable ifFalse: [^#()].
	
	[subValue := anAspectAccessor value.
	subject := anAspectAccessor isMutable ifTrue: [subValue] ifFalse: [subValue copy]] 
			on: Error
			do: [:ex | subValue := subject := ex].
	^(self getSubAspectsFor: subValue) collect: [:each | each accessorFor: subject]!

getSubAspectsFor: anObject 
	"Private - Answer a <sequencedReadableCollection> of the published aspects of the argument."

	| aspects |
	aspects := (self getAspectsFor: anObject) reject: [:each | each name == #yourself].
	^self sortAspects: aspects!

initialize
	super initialize.
	isRootAspectVisible := true.
	isSingleLevelOnly := false!

isRootAspectVisible
	^isRootAspectVisible!

isRootAspectVisible: aBoolean 
	isRootAspectVisible := aBoolean.
	self buildNewAspectTree!

isSingleLevelOnly
	^isSingleLevelOnly!

isSingleLevelOnly: aBoolean 
	isSingleLevelOnly := aBoolean!

onAspectActioned
	"Event handler for an action being performed on the current aspect, i.e. Enter or double-click"

	self subclassResponsibility!

onAspectValueChanged: anAspectAccessor 
	"Private - The currently inspected aspect value has been updated."

	anAspectAccessor name == #yourself 
		ifFalse: 
			["If the accessor cannot be set, warn the user and restore the original value"
			anAspectAccessor canSet 
				ifFalse: 
					[MessageBox 
						errorMsg: ('The <1p> aspect of the <2p> is read-only, or the object does not understand the setter message.' 
								expandMacrosWith: anAspectAccessor name
								with: anAspectAccessor subject class)
						caption: 'Inspector cannot set this value'.
					self onAspectSelected.
					^self].
			anAspectAccessor editedValue: aspectValueHolder value.
			self propagate: anAspectAccessor].
	self refreshAccessor: anAspectAccessor.
	self trigger: #inspecteeChanged!

onLeftButtonPressed: aMouseEvent 
	"The mouse has gone down inside the aspect tree view. We want to ascertain whether this is a
	click over an aspect edit button or not. First, however, we must let any selection take
	place. Hence, we post out check to the input queue so it is actioned after the mouse down
	event has been fully handled."

	[self testForEditButtonClickAt: aMouseEvent position] postToInputQueue!

onValueChanged
	"Private - The root object being inspected has changed so initialize the tree appropriately.
	We use an ExpandingTreeModel that asks the receiver for the children of an aspect as it
	is dynamically expanded."

	super onValueChanged.
	self refresh!

propagate: anAspectAccessor
	"Private - Sets aspectAccessor with the given value. For non-mutable aspects the change is propagated
	up the aspect parent chain"

	| aspectTree thisAccessor parentAccessor propagateValue |
	aspectTree := self aspectTree.
	(aspectTree includes: anAspectAccessor) ifFalse: [^self].
	thisAccessor := anAspectAccessor.
	propagateValue := true.
	
	[parentAccessor := aspectTree parentOf: thisAccessor.
	parentAccessor notNil] whileTrue: 
				[propagateValue 
					ifTrue: 
						[parentAccessor canSet 
							ifTrue: 
								[parentAccessor isMutable 
									ifFalse: 
										["Note that we don't want to store back the actual subject, as that might result
								 in the parent object referencing the same object as the accessor, which would
								 mean the next modification in the inspector would update it internally"

										parentAccessor value: thisAccessor subject copy]]
							ifFalse: [propagateValue := false]].
				"Each parent is instructed to refresh regardless of whether actually updated, as its display value may have changed"
				aspectTree refresh: parentAccessor.
				thisAccessor := parentAccessor]!

queryCommand: query
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery>,  query."

	| command accessor |
	command := query commandSymbol.
	accessor := self aspectAccessor.
	(#(#editAspect) includes: command) 
		ifTrue: 
			[query isEnabled: (accessor notNil and: [accessor canEdit]).
			^true].
	^super queryCommand: query!

refresh
	| selectionPath |
	selectionPath := self isOpen ifTrue: [self selectionPath] ifFalse: [#()].
	self buildNewAspectTree.
	self selectionPath: selectionPath.
	aspectTreePresenter ensureVisible!

refreshAccessor: anAspectAccessor 
	"Private - The value of aspectAccessor has been changed so refresh the receiver's display to reflect this"

	| aspectTree selectionPath |
	aspectTree := self aspectTree.
	(aspectTree includes: anAspectAccessor) ifFalse: [^self].
	selectionPath := self selectionPath.
	aspectTreePresenter noEventsDo: 
			[| parentAspect |
			parentAspect := aspectTree parentOf: anAspectAccessor.
			aspectTreePresenter view noRedrawDo: 
					[parentAspect isNil 
						ifTrue: [aspectTree collapse: anAspectAccessor]
						ifFalse: 
							[#todo.
							"I think we may need to collapse the parent in case siblings change shape (e.g. ToolbarSystemButton),
						but if we do that then aspectPresenter's get recreated and selection is lost, a problem, e.g., when 
						rearranging the elements of a sequenceable collection."
							false 
								ifTrue: 
									[aspectTree collapse: parentAspect.
									aspectTreePresenter expand: parentAspect]
								ifFalse: [(aspectTree childrenOf: parentAspect) do: [:each | aspectTree collapse: each]]
							"Refresh is necessary if not using dynamic tree update mode"
							"aspectTree refresh: parentAspect"].
					"Always keep the aspect expanded"
					aspectTreePresenter expand: anAspectAccessor]].
	self selectionPath: selectionPath!

selectionPath
	"Private - Answer a path of the names of the aspects from the root to the currently 
	selected aspect."

	| answer current aspectTree |
	answer := OrderedCollection new.
	current := self aspectAccessor.
	aspectTree := self aspectTree.
	[current isNil] whileFalse: 
			[answer addFirst: current name.
			current := aspectTree parentOf: current].
	^answer!

selectionPath: aSequencedReadableCollection 
	"Private - Re-establish a selection at an arbitrary depth in the tree
	by walking a path of aspect names."

	| aspectTree i last newSelection |
	aspectTree := self aspectTree.
	i := 1.
	last := aSequencedReadableCollection size.
	newSelection := nil.
	[i > last] whileFalse: 
			[| name |
			name := aSequencedReadableCollection at: i.
			newSelection := (aspectTree childrenOf: newSelection) 
						detect: [:eachAspect | eachAspect name = name]
						ifNone: 
							[i := last.
							newSelection].
			i := i + 1].
	aspectTreePresenter selectionOrNil: newSelection!

setAspectValue: anObject 
	aspectValueHolder value: anObject!

setMutableValueOf: anAspectAccessor into: aValueHolder 
	"Private - Find the value of anAspectAccessor if it is readable. If it is then silently set the value
	into aValueHolder and answer true"

	| hasReadableValue aspectValue |
	hasReadableValue := false.
	anAspectAccessor isReadable 
		ifTrue: 
			[aspectValue := 
					[| value |
					value := anAspectAccessor getMutableValue.
					hasReadableValue := true.
					value] 
							on: Error
							do: [:ex | ex]].

	"Set the value into our aValueHolder without triggering a change event"
	aValueHolder setValue: aspectValue.
	^hasReadableValue!

sortAspects: aLookupTable 
	^[aLookupTable asSortedCollection] 
		on: MessageNotUnderstood
		do: 
			[:ex | 
			"Some KeyedAspects may have keys that don't respond to #<=. In such cases return an unsorted collection"
			ex selector == #<= ifFalse: [ex toTrace].
			aLookupTable asArray]
		on: Error
		do: 
			[:ex | 
			ex toTrace.
			aLookupTable asArray]!

testForEditButtonClickAt: aPoint 
	"The mouse left button has gone down insiide the aspect tree view at aPoint. The click has
	already been handled so any selection will have already been made. We make the assumption
	that the aspect tree is being displayed in a ListTreeView and that any edit button icon is
	in column 3. Check to see if the mouse click was over this column and if the accessor can be
	edited let it be so."

	| hit aspectListTree |
	aspectListTree := aspectTreePresenter view.
	(aspectListTree isKindOf: ListTreeView) ifFalse: [^self].
	hit := aspectListTree basicItemFromPoint: aPoint.
	(hit isItemHit and: [hit iSubItem + 1 = 3]) 
		ifTrue: 
			[| aspectAccessor |
			self assert: [hit iItem = (aspectListTree selectionByIndex - 1)].
			aspectAccessor := aspectListTree objectFromHandle: hit iItem + 1.
			aspectAccessor canEdit ifTrue: [aspectAccessor editUsing: aspectPresenter]]! !
!AbstractPublishedAspectInspector categoriesFor: #addToCommandRoute:!private! !
!AbstractPublishedAspectInspector categoriesFor: #aspectChanged:!private!updating! !
!AbstractPublishedAspectInspector categoriesFor: #aspectChanged:of:!private!updating! !
!AbstractPublishedAspectInspector categoriesFor: #aspectTree!event handling!private! !
!AbstractPublishedAspectInspector categoriesFor: #buildNewAspectTree!private!updating! !
!AbstractPublishedAspectInspector categoriesFor: #createSchematicWiring!initializing!private! !
!AbstractPublishedAspectInspector categoriesFor: #createValueHolderFor:!private! !
!AbstractPublishedAspectInspector categoriesFor: #displayOn:!displaying!public! !
!AbstractPublishedAspectInspector categoriesFor: #editAspect!operations!public! !
!AbstractPublishedAspectInspector categoriesFor: #getAspectsFor:!private! !
!AbstractPublishedAspectInspector categoriesFor: #getSubAspectAccessorsFor:!helpers!private! !
!AbstractPublishedAspectInspector categoriesFor: #getSubAspectsFor:!helpers!private! !
!AbstractPublishedAspectInspector categoriesFor: #initialize!private! !
!AbstractPublishedAspectInspector categoriesFor: #isRootAspectVisible!public! !
!AbstractPublishedAspectInspector categoriesFor: #isRootAspectVisible:!public! !
!AbstractPublishedAspectInspector categoriesFor: #isSingleLevelOnly!public! !
!AbstractPublishedAspectInspector categoriesFor: #isSingleLevelOnly:!public! !
!AbstractPublishedAspectInspector categoriesFor: #onAspectActioned!event handling!private! !
!AbstractPublishedAspectInspector categoriesFor: #onAspectValueChanged:!event handling!private! !
!AbstractPublishedAspectInspector categoriesFor: #onLeftButtonPressed:!private! !
!AbstractPublishedAspectInspector categoriesFor: #onValueChanged!accessing!private! !
!AbstractPublishedAspectInspector categoriesFor: #propagate:!helpers!private! !
!AbstractPublishedAspectInspector categoriesFor: #queryCommand:!commands!private! !
!AbstractPublishedAspectInspector categoriesFor: #refresh!commands!public!updating! !
!AbstractPublishedAspectInspector categoriesFor: #refreshAccessor:!event handling!private! !
!AbstractPublishedAspectInspector categoriesFor: #selectionPath!accessing!private! !
!AbstractPublishedAspectInspector categoriesFor: #selectionPath:!accessing!private! !
!AbstractPublishedAspectInspector categoriesFor: #setAspectValue:!commands!private! !
!AbstractPublishedAspectInspector categoriesFor: #setMutableValueOf:into:!private! !
!AbstractPublishedAspectInspector categoriesFor: #sortAspects:!private! !
!AbstractPublishedAspectInspector categoriesFor: #testForEditButtonClickAt:!private! !

!AbstractPublishedAspectInspector class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	Smalltalk developmentSystem registerTool: self.
	treeUpdateMode := #lazy!

publishedEventsOfInstances
	^(super publishedEventsOfInstances)
		add: #inspecteeChanged;
		yourself!

resource_Vertical_view
	"Answer the literal data from which the 'Vertical view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Vertical_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  202 8 ##(Smalltalk.Dictionary)  98 3 721414 ##(Smalltalk.Association)  410 8 ##(Smalltalk.CardContainer)  98 16 0 416 98 2 8 1140850688 131073 656 0 721158 ##(Smalltalk.SystemColor)  31 0 5 0 0 0 656 655878 ##(Smalltalk.CardLayout)  202 208 98 0 0 234 256 816 0 410 8 ##(Smalltalk.TabViewXP)  98 28 0 656 98 2 8 1140916866 1 848 590662 2 ##(Smalltalk.ListModel)  202 208 816 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  0 0 1 0 0 0 848 0 8 4294903839 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  1 83886081 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:x | nil]' 8 #[29 105 60 106] 1040 7 257 0 8 ##(Smalltalk.IconicListAbstract)  1049926 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 8 #smallIcons 0 0 0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 1346 661 45 848 1282 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 848 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 74 1 0 0 22 0 0 0] 98 0 1346 193 193 0 27 1218 202 208 98 1 1282 1312 98 2 1346 1 297 1346 661 45 656 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 74 1 0 0 170 0 0 0] 98 1 848 1504 0 27 327734 ##(Smalltalk.Float)  8 51 51 51 51 51 51 211 63 626 410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 1728 0 498 528 0 517 0 0 0 1728 1218 202 208 98 1 1282 1312 98 2 1346 1 287 1346 661 11 1728 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 0 0 0 74 1 0 0 148 0 0 0] 98 0 1504 0 27 1 626 410 8 ##(Smalltalk.ListTreeView)  98 44 0 416 98 2 8 1140953421 1 2000 930 202 208 816 0 992 498 8 4278190080 0 13 265030 4 ##(Smalltalk.Menu)  0 16 98 12 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 2194 1 2226 8 #inspectReferences 8 'Inspect &References' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 2194 1 2226 8 #browseIt 8 '&Browse It' 1 1 2290 0 16 2336 8 'ClassBrowserShell.ico' 2384 0 0 2482 4097 2194 1 2226 8 #copyAspect 8 '&Copy' 1 1 0 0 0 2194 1 2226 8 #pasteAspect 8 '&Paste <1d>' 1 1 0 0 0 2482 4097 2194 1 2226 8 #editAspect 8 '&Edit' 1 1 0 0 0 2194 1 2226 8 #nilAspect 8 'Set to &Nil' 1 1 0 0 0 2482 4097 2194 1 2226 8 #refresh 8 'Re&fresh' 1 1 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 2000 0 8 4294907285 459270 ##(Smalltalk.Message)  8 #valueText 98 0 0 1184 0 0 0 0 0 0 202 208 98 3 920646 5 ##(Smalltalk.ListViewColumn)  8 'Published Aspect' 307 8 #left 1026 0 0 1058 2 1 1024 8 'doIt' 8 '[:x | x valueNameOnly ]' 8 #[30 105 226 0 106] 8 #valueNameOnly 3168 7 257 0 3010 8 #<= 98 0 0 0 2000 0 3 1026 0 0 1058 2 1 1024 8 'doIt' 8 '[:x | x valueNameInfo]' 8 #[30 105 226 0 106] 8 #valueNameInfo 3312 7 257 0 0 3106 8 'Value' 307 3152 1026 0 0 1058 2 1 1024 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] 8 #valueTextOnly 3440 7 257 0 3010 3280 3296 0 0 2000 1026 0 0 1058 2 1 1024 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] 8 #valueImage 3552 7 257 0 3 0 0 3106 8 '' 41 8 #center 3010 8 #displayString 98 0 3010 3280 3728 0 0 2000 1026 0 0 1058 3 1 1024 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] 8 ##(Smalltalk.PropertyInspector)  8 #editButtonImageIndexFor: 3760 7 257 0 1 0 0 8 #report 816 0 2407 1346 129 129 0 32 1050438 3 ##(Smalltalk.VirtualTreeModel)  0 992 202 208 816 0 0 1026 0 0 918822 ##(Smalltalk.CompiledMethod)  2 3 3904 8 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] 8 #childrenOf: 8 #notEmpty 17 257 3920 1026 0 0 3970 1 83886083 3904 8 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 4064 7 257 0 0 202 8 ##(Smalltalk.PluggableSet)  816 202 4144 816 13 5 0 0 0 0 0 0 0 1218 202 208 98 3 1282 1312 98 2 1346 1 1 1346 661 287 2000 1282 8 #contextMenu: 98 1 2160 2000 1282 8 #text: 98 1 8 'Published Aspect' 2000 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 74 1 0 0 143 0 0 0] 98 0 1504 0 2021 5 16 234 256 98 4 2000 8 'aspects' 656 8 'display' 0 1218 202 208 98 1 1282 1312 98 2 1346 3359 21 1346 661 341 416 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 217 7 0 0 180 0 0 0] 98 3 2000 1728 656 1504 0 27 )!

shellOn: anObject
	"Open an Inspector shell displaying on anObject. 
	Answer the new Inspector."

	| inspector shell |
	shell := InspectorShell create.
	shell caption: 'Inspecting ', anObject basicPrintString.
	inspector := self createIn: shell on: (ValueHolder with: anObject).
	inspector view arrangement: #center.
	shell view validateLayout.
	shell show setInitialFocus.
	^inspector! !
!AbstractPublishedAspectInspector class categoriesFor: #initialize!initializing!private! !
!AbstractPublishedAspectInspector class categoriesFor: #publishedEventsOfInstances!development!events!public! !
!AbstractPublishedAspectInspector class categoriesFor: #resource_Vertical_view!public!resources-views! !
!AbstractPublishedAspectInspector class categoriesFor: #shellOn:!instance creation!public! !

