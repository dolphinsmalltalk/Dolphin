"Filed out from Dolphin Smalltalk 7"!

Tools.AspectInspector subclass: #'Tools.AbstractPublishedAspectInspector'
	instanceVariableNames: 'aspectValueHolder aspectPresenter isRootAspectVisible isSingleLevelOnly'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.AbstractPublishedAspectInspector guid: (Core.GUID fromString: '{f1cdcdf4-e0b8-4070-953a-c17010bab8ad}')!
Tools.AbstractPublishedAspectInspector isNonInstantiable: true!
Tools.AbstractPublishedAspectInspector comment: ''!
!Tools.AbstractPublishedAspectInspector categoriesForClass!MVP-Presenters! !
!Tools.AbstractPublishedAspectInspector methodsFor!

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
						accessorFor: value.
			roots := {rootAccessor}]
		ifFalse: 
			[value
				ifNil: 
					["If the value is nil and we are not showing the root then show nothing"
					roots := #()]
				ifNotNil: 
					[publishedAspects removeKey: #yourself.
					roots := (self sortAspects: publishedAspects) collect: [:each | each accessorFor: value]]].
	aspectTreeModel := ExpandingTreeModel withRoots: roots.
	aspectTreeModel getChildrenBlock: (self isSingleLevelOnly
				ifTrue: [[:each | #()]]
				ifFalse: [[:each | self getSubAspectAccessorsFor: each]]).
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

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see.
	This will be used as the label for the tab when the receiver is being displayed within the Flipper Inspector"

	aPuttableStream nextPutAll: 'Published Aspects'!

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
	aspects := self getAspectsFor: anObject.
	aspects removeKey: #yourself ifAbsent: [].
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
!Tools.AbstractPublishedAspectInspector categoriesFor: #addToCommandRoute:!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #aspectChanged:!private!updating! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #aspectChanged:of:!private!updating! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #aspectTree!event handling!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #buildNewAspectTree!private!updating! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #createSchematicWiring!initializing!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #createValueHolderFor:!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #displayOn:!displaying!public! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #editAspect!operations!public! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #getAspectsFor:!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #getSubAspectAccessorsFor:!helpers!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #getSubAspectsFor:!helpers!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #initialize!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #isRootAspectVisible!public! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #isRootAspectVisible:!public! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #isSingleLevelOnly!public! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #isSingleLevelOnly:!public! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #onAspectActioned!event handling!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #onAspectValueChanged:!event handling!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #onLeftButtonPressed:!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #onValueChanged!accessing!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #propagate:!helpers!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #queryCommand:!commands!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #refresh!commands!public!updating! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #refreshAccessor:!event handling!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #selectionPath!accessing!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #selectionPath:!accessing!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #setAspectValue:!commands!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #setMutableValueOf:into:!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #sortAspects:!private! !
!Tools.AbstractPublishedAspectInspector categoriesFor: #testForEditButtonClickAt:!private! !

!Tools.AbstractPublishedAspectInspector class methodsFor!

publishedEventsOfInstances
	^(super publishedEventsOfInstances)
		add: #inspecteeChanged;
		yourself!

resource_Vertical_view
	"Answer the literal data from which the 'Vertical view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Vertical_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1376774 ##(UI.ProportionalLayout) 138 ##(Core.Dictionary) 34 3 1049094 ##(Core.Association) 410 ##(UI.CardContainer) 34 16 nil 416 34 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 853318 1 ##(UI.CardLayout) 138 144 8 #() nil nil nil nil 170 192 688 nil 410 ##(UI.TabViewXP) 34 28 nil 576 34 2 8 1140916866 1 720 787270 2 ##(UI.ListModel) 138 144 688 nil 1769478 ##(Kernel.IdentitySearchPolicy) nil nil 1 nil nil nil 720 nil 8 1801049728 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 1 83886081 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 8 #[29 105 60 106] 896 7 257 nil ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil #smallIcons nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 1 1 1138 661 45 720 1090 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 720 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 74 1 0 0 22 0 0 0] 8 #() 1138 193 193 nil 27 1026 138 144 34 1 1090 #createAt:extent: 34 2 1138 1 297 1138 661 45 576 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 74 1 0 0 170 0 0 0] 34 1 720 1280 nil 27 655414 ##(Core.Float) 8 51 51 51 51 51 51 211 63 546 410 ##(UI.Splitter) 34 12 nil 416 34 2 8 1140850688 1 1504 nil nil nil 517 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 1504 nil 1 #left nil nil nil 1138 1 1 1138 9 9 nil 1600 nil 1026 138 144 34 1 1090 #createAt:extent: 34 2 1138 1 287 1138 661 11 1504 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 0 0 0 74 1 0 0 148 0 0 0] 8 #() 1280 nil 27 1 546 410 ##(UI.ListTreeView) 34 59 nil 416 34 2 8 1140953421 1 1808 786 138 144 688 nil 848 917510 ##(Graphics.Color) #default nil 13 461638 4 ##(UI.Menu) nil true 34 12 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #inspectIt 8 '&Inspect' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1986 1 2018 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 1986 1 2018 #browseIt 8 '&Browse It' 1 1 2066 nil true 2112 8 'ClassBrowserShell.ico' 2160 nil nil 2242 4097 1986 1 2018 #copyAspect 8 '&Copy' 1 1 nil nil nil 1986 1 2018 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 2242 4097 1986 1 2018 #editAspect 8 '&Edit' 1 1 nil nil nil 1986 1 2018 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 2242 4097 1986 1 2018 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 1808 nil 8 1801282304 786950 ##(Core.Message) #valueText 8 #() nil 1008 nil nil nil nil nil nil 138 144 34 3 1117254 5 ##(UI.ListViewColumn) 8 'Published Aspect' 307 #left 882 0 nil 914 2 1 880 8 'doIt' 8 '[:x | x valueNameOnly ]' 8 #[30 105 226 0 106] #valueNameOnly 2800 7 257 nil 2674 #<= 8 #() nil nil 1808 nil 3 882 0 nil 914 2 1 880 8 'doIt' 8 '[:x | x valueNameInfo]' 8 #[30 105 226 0 106] #valueNameInfo 2912 7 257 nil nil 2754 8 'Value' 307 #left 882 0 nil 914 2 1 880 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 3024 7 257 nil 2674 #<= 2896 nil nil 1808 882 0 nil 914 2 1 880 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 3120 7 257 nil 3 nil nil 2754 8 '' 41 #center 2674 #displayString 8 #() 2674 #<= 3248 nil nil 1808 882 0 nil 914 3 1 880 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Tools.PropertyInspector) #editButtonImageIndexFor: 3280 7 257 nil 1 nil nil #report 8 #() nil 133479 1138 129 129 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil false 1247046 3 ##(UI.VirtualTreeModel) nil 848 138 144 688 nil nil 882 0 nil 1377574 ##(Kernel.CompiledMethod) 2 3 3392 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 3408 882 0 nil 3458 1 83886083 3392 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 3504 7 257 nil nil 138 ##(Core.PluggableSet) 688 138 ##(Core.IdentitySet) 688 13 5 nil nil nil nil nil nil nil 1026 138 144 34 3 1090 #createAt:extent: 34 2 1138 1 1 1138 661 287 1808 1090 #contextMenu: 34 1 1952 1808 1090 #text: 34 1 8 'Published Aspect' 1808 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 74 1 0 0 143 0 0 0] 8 #() 1280 nil 2029 5 true 170 192 34 4 576 8 'display' 1808 8 'aspects' nil 1026 138 144 34 1 1090 #createAt:extent: 34 2 1138 6143 21 1138 661 341 416 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 73 13 0 0 180 0 0 0] 34 3 1808 1504 576 1280 nil 27 )!

shellOn: anObject
	"Open an Inspector shell displaying on anObject. 
	Answer the new Inspector."

	| inspector shell |
	shell := InspectorShell create.
	shell caption: 'Inspecting ' , anObject basicPrintString.
	inspector := self createIn: shell on: (ValueHolder with: anObject).
	inspector view arrangement: #center.
	shell view validateLayout.
	shell show setInitialFocus.
	^inspector! !
!Tools.AbstractPublishedAspectInspector class categoriesFor: #publishedEventsOfInstances!events!public! !
!Tools.AbstractPublishedAspectInspector class categoriesFor: #resource_Vertical_view!public!resources-views! !
!Tools.AbstractPublishedAspectInspector class categoriesFor: #shellOn:!instance creation!public! !

