"Filed out from Dolphin Smalltalk"!

Tools.AspectInspector
	subclass: #'Tools.AbstractPublishedAspectInspector'
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
				ifNone: nil.
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

canEditAspect
	| accessor |
	accessor := self aspectAccessor.
	^accessor notNil and: [accessor canEdit]!

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

	<commandQuery: #canEditAspect>
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

	anAspectAccessor isReadable ifFalse: [^#()].
	^
	[| subValue subject |
	subValue := anAspectAccessor value.
	subject := anAspectAccessor isMutable ifTrue: [subValue] ifFalse: [subValue copy].
	(self getSubAspectsFor: subValue) collect: [:each | each accessorFor: subject]]
			on: Error
			do: [:ex | (self getSubAspectsFor: ex) collect: [:each | each accessorFor: ex]]!

getSubAspectsFor: anObject
	"Private - Answer a <sequencedReadableCollection> of the published aspects of the argument."

	| aspects |
	aspects := self getAspectsFor: anObject.
	aspects removeKey: #yourself ifAbsent: nil.
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
					[MessageBox new
						headline: 'Inspector cannot set this value';
						errorMsg: 'The <1p> aspect of the <2p> is read-only, or the object does not understand the setter message.'
									<< {anAspectAccessor name. anAspectAccessor subject class}.
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
!Tools.AbstractPublishedAspectInspector categoriesForMethods!
addToCommandRoute:!private! !
aspectChanged:!private!updating! !
aspectChanged:of:!private!updating! !
aspectTree!event handling!private! !
buildNewAspectTree!private!updating! !
canEditAspect!commands-queries!private! !
createSchematicWiring!initializing!private! !
createValueHolderFor:!private! !
displayOn:!displaying!public! !
editAspect!commands-actions!public! !
getAspectsFor:!private! !
getSubAspectAccessorsFor:!helpers!private! !
getSubAspectsFor:!helpers!private! !
initialize!private! !
isRootAspectVisible!public! !
isRootAspectVisible:!public! !
isSingleLevelOnly!public! !
isSingleLevelOnly:!public! !
onAspectActioned!event handling!private! !
onAspectValueChanged:!event handling!private! !
onLeftButtonPressed:!private! !
onValueChanged!accessing!private! !
propagate:!helpers!private! !
refresh!commands-actions!public!updating! !
refreshAccessor:!event handling!private! !
selectionPath!accessing!private! !
selectionPath:!accessing!private! !
setAspectValue:!operations!private! !
setMutableValueOf:into:!private! !
sortAspects:!private! !
testForEditButtonClickAt:!private! !
!

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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 3 518 #{Core.Association} 18 #{UI.ListTreeView} 50 59 nil 32 50 2 8 1140953421 1 224 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 13 2886 4 #{UI.Menu} nil true 50 12 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 466 1 498 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 466 1 498 #browseIt 8 '&Browse <d:It>' 1 17 546 nil true 578 8 'ClassBrowserShell.ico' 640 65541 nil nil nil 722 4097 466 1 498 #copyAspect 8 '&Copy' 1 1 nil nil nil 466 1 498 #pasteAspect 8 '&Paste <d>' 1 17 nil nil nil 722 4097 466 1 498 #editAspect 8 '&Edit' 1 1 nil nil nil 466 1 498 #resetAspect 8 '&Set to Nil/Default' 1 1 nil nil nil 722 4097 466 1 498 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 224 nil nil 518 #{Core.Message} #valueText 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 322 3 3142 5 #{UI.ListViewColumn} 8 'Published Aspect' 307 #left 1154 #valueNameOnly 8 #() 1154 #<= 8 #() nil nil 224 nil 3 1154 #valueNameInfo 1312 nil 1250 8 'Value' 307 #left 1154 #valueTextOnly 1312 1154 #<= 1344 nil nil 224 1154 #valueImage 1312 3 nil nil 1250 8 '' 41 #center 1154 #displayString 8 #() 1154 #<= 1504 nil nil 224 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 1536 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] #{Tools.PropertyInspector} #editButtonImageIndexFor: 1552 7 257 nil 1 nil nil #report 8 #() nil 133479 518 #{Graphics.Point} 129 129 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil false 1862 3 #{UI.VirtualTreeModel} nil 368 322 0 nil nil 1538 0 nil 1318 #{Kernel.CompiledMethod} 2 3 1696 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 1712 1538 0 nil 1762 1 83886083 1696 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 1808 7 257 nil nil 550 #{Core.PluggableSet} 0 294 #{Core.IdentitySet} 0 13 5 nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 1666 1 1 1666 661 287 224 1970 #text: 50 1 8 'Published Aspect' 224 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 74 1 0 0 143 0 0 0] 8 #() 1666 193 193 nil 2029 5 194 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 2192 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2192 nil 1 #left nil nil nil 1666 1 1 1666 9 9 nil 2288 nil 1922 50 1 1970 #createAt:extent: 50 2 1666 1 287 1666 661 11 2192 2098 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 0 0 0 74 1 0 0 148 0 0 0] 8 #() 2160 nil 27 1 194 18 #{UI.CardContainer} 50 16 nil 32 50 2 8 1140850688 131073 2480 nil nil nil 5 nil nil nil 2480 1350 1 #{UI.CardLayout} 322 0 nil nil nil nil 550 #{Core.IdentityDictionary} 0 nil 18 #{UI.TabViewXP} 50 28 nil 2480 50 2 8 1140916866 1 2624 290 322 0 nil 368 nil nil 1 nil nil nil 2624 nil nil 1538 0 nil 1570 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 8 #[29 105 60 106] 2720 7 257 nil 1154 #iconImageIndex 1312 1216 nil nil nil nil nil #smallIcons nil nil nil nil nil 1922 50 2 1970 #createAt:extent: 50 2 1666 1 1 1666 661 45 2624 1970 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 2624 2098 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 74 1 0 0 22 0 0 0] 8 #() 2160 nil 27 1922 50 1 1970 #createAt:extent: 50 2 1666 1 297 1666 661 45 2480 2098 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 74 1 0 0 170 0 0 0] 50 1 2624 2160 nil 27 8 0.3 true 518 #{Kernel.STBIdentityDictionaryProxy} 2592 50 4 224 8 'aspects' 2480 8 'display' nil 1922 50 1 1970 #createAt:extent: 50 2 1666 6143 21 1666 661 341 32 2098 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 73 13 0 0 180 0 0 0] 50 3 224 2192 2480 2160 nil 27)!

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
!Tools.AbstractPublishedAspectInspector class categoriesForMethods!
publishedEventsOfInstances!events!public! !
resource_Vertical_view!public!resources-views! !
shellOn:!instance creation!public! !
!

