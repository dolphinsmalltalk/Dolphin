"Filed out from Dolphin Smalltalk"!

Tools.InspectorAbstract
	subclass: #'Tools.AspectInspector'
	instanceVariableNames: 'aspectTreePresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'treeUpdateMode treeHasGridLines'
	classConstants: {}!
Tools.AspectInspector guid: (Core.GUID fromString: '{3a705749-14d8-4cd1-9b4e-ccf02a0218de}')!
Tools.AspectInspector isNonInstantiable: true!
Tools.AspectInspector comment: ''!
!Tools.AspectInspector categoriesForClass!MVP-Presenters! !
!Tools.AspectInspector methodsFor!

aspectAccessor
	"Private - Answer the <InstVarAccesor> for the selected variable"

	^aspectTreePresenter selectionOrNil!

aspectAccessor: anAspectAccessor 
	^aspectTreePresenter selectionOrNil: anAspectAccessor!

aspectTreePresenter
	^aspectTreePresenter!

aspectValue
	"Private - Answer the value associated with the currently selected
	aspect variable name or nil if there is no selection."

	^(aspectTreePresenter selectionIfNone: nil) value!

beLargeIcons
	"Sets the receiver to display large icons"

	aspectTreePresenter view viewMode: #largeIcons!

beSmallIcons
	"Sets the receiver to display small icons"

	aspectTreePresenter view viewMode: #smallIcons!

canSetAspect
	"Private - Answer true if the currently selected aspect can be set"

	| accessor |
	accessor := self aspectAccessor.
	^accessor notNil and: [accessor canSet]!

copyAspect
	"Copy the value of the currently selected aspect to the clipboard as an object."

	<commandQuery: #hasSelection>
	| value text |
	value := self copyOfAccessorValue: self aspectAccessor.
	text := value isString 
				ifTrue: [value]
				ifFalse: 
					[| stream |
					stream := String writeStream.
					value aspectDisplayOn: stream.
					stream contents].
	(Clipboard current)
		setText: text;
		setObject: value!

copyOfAccessorValue: anAccessor 
	"Private - Answers a copy of the value in anAccessor. This should be suitable for transferring
	to other locations using the clipboard or drag and drop. To this end we make an attempt
	to isolate the aspect value from it's surroundings, i.e. the current model object."

	"Unfortunately we must make sure that we isolate the aspect value
	from the current model. This means we can't just use #binaryStoreBytes
	but rather we have to set up the STB operation manually."

	| object stream filer modelValue |
	object := anAccessor value.
	stream := WriteStream with: ByteArray new.
	filer := STBOutFiler on: stream.
	modelValue := self model value.
	object == modelValue ifFalse: [filer override: modelValue with: nil].
	filer nextPut: object.
	^[Object fromBinaryStoreBytes: stream contents] on: Error
		do: [:error | self error: 'It is not possible to copy this aspect']!

createComponents
	"Create the presenters contained by the receiver. At this stage
	the receiver has not yet been initialized."

	aspectTreePresenter := self add: TreePresenter new name: 'aspects'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	aspectTreePresenter
		when: #drag:
			send: #onDragObjectRef:
			to: self;
		when: #selectionChanged
			send: #onAspectSelected
			to: self!

expandBatchAccessor: batchAccessor
	| newAccessors |
	newAccessors := batchAccessor getBatchAccessors.
	newAccessors notEmpty
		ifTrue: 
			[| variableNamesTree parentAccessor |
			variableNamesTree := aspectTreePresenter model.
			parentAccessor := variableNamesTree parentOf: batchAccessor.
			newAccessors do: [:each | variableNamesTree add: each asChildOf: parentAccessor].
			aspectTreePresenter selection: newAccessors first.
			variableNamesTree remove: batchAccessor]!

hasSelection
	"Private - Answer whether any aspect is selected."

	^aspectTreePresenter hasSelection!

inspecteeSelection
	"Private - Answer the value associated with the currently selected object"

	^(aspectTreePresenter selectionIfNone: [self]) value!

inspectReferences
	"Open a new Inspector on all the objects which references the variable
	selected in variablesModel."

	<commandQuery: #hasSelection>
	| refs |
	refs := self aspectValue allReferences copyWithout: self.
	refs isEmpty
		ifTrue: [MessageBox notify: 'There are no additional references to:<n><t><1p>' << self aspectValue]
		ifFalse: [refs inspect]!

model: aValueModel
	"Set the model of the receiver to be aValueModel. We intercept a change
	notification so that the list selection can track this value."

	super model: aValueModel.
	self onValueChanged
!

onAspectSelected
	"Private - An aspect accessor has been selected within the aspect tree."

	^self subclassResponsibility!

onDragObjectRef: session
	"Private - An object drag has been started. Populate the <DragDropSession>, 
	session, with the objects to be dragged."

	| dragDropObject dragAspect ref |
	dragAspect := session suggestedSource.
	ref := dragAspect objectRef.
	dragDropObject := session newDragObject: ref value.
	dragDropObject format: #ObjectRef data: ref.
	session dragObjects: (OrderedCollection with: dragDropObject)!

onViewAvailable
	"A new view is available, but has not yet been connected to the receiver, i.e.
	the view will not yet be aware of this presenter or its model.
	This is an appropriate point for subclasses to apply any dynamic view 
	configuration that the application may require."

	aspectTreePresenter view
		updateMode: self class treeUpdateMode;
		hasGridLines: self class treeHasGridLines!

onViewOpened
	super onViewOpened.
	self onValueChanged!

pasteAspect
	"Paste a copy of the currently clipboard object to the current aspect"

	<commandQuery: #queryPasteAspect:>
	| objectCopy |
	objectCopy := Clipboard current getObject.
	self setAspectValue: objectCopy!

queryPasteAspect: aCommandQuery
	| class accessor |
	accessor := self aspectAccessor.
	(accessor notNil and: 
			[accessor canSet and: 
					[Clipboard current isObjectAvailable
						and: [(class := Clipboard current getObjectClassIfNone: nil) notNil]]])
		ifTrue: 
			[aCommandQuery
				beEnabled;
				expandMenuTextWith: class printString]!

queryResetAspect: aCommandQuery
	| accessor |
	accessor := self aspectAccessor.
	(accessor notNil and: [accessor canReset])
		ifTrue: 
			[aCommandQuery
				beEnabled;
				expandMenuTextWith: accessor aspectDescriptor hasDefault not]!

refresh
	^self subclassResponsibility!

resetAspect
	"Clears the currently selected aspect to nil or its default value"

	<commandQuery: #queryResetAspect:>
	| aspect default prompt format |
	aspect := self aspectAccessor aspectDescriptor.
	default := aspect defaultValue.
	prompt := MessageBox new.
	format := 'Are you sure you wish to reset this item to <d>?'.
	default isNil
		ifTrue: [prompt headline: format << 'nil']
		ifFalse: 
			[prompt
				headline: format << 'it''s default';
				detailsText: 'The aspect will be reset to it''s default value, <d>' << default].
	prompt confirm ifTrue: [self setAspectValue: default value]!

setAspectValue: anObject
	"Private - Set the value associated with the currently selected
	instance variable name to anObject."

	^self subclassResponsibility! !
!Tools.AspectInspector categoriesForMethods!
aspectAccessor!accessing!private! !
aspectAccessor:!public! !
aspectTreePresenter!public! !
aspectValue!accessing!private! !
beLargeIcons!operations!public! !
beSmallIcons!operations!public! !
canSetAspect!commands-queries!private!testing! !
copyAspect!commands-actions!public! !
copyOfAccessorValue:!accessing!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
expandBatchAccessor:!event handling!private! !
hasSelection!commands-queries!private!testing! !
inspecteeSelection!accessing!private! !
inspectReferences!commands-actions!public! !
model:!accessing!public! !
onAspectSelected!event handling!private! !
onDragObjectRef:!event handling!private! !
onViewAvailable!event handling!public! !
onViewOpened!event handling!public! !
pasteAspect!commands-actions!public! !
queryPasteAspect:!commands-queries!private! !
queryResetAspect:!commands-queries!private! !
refresh!commands-actions!public! !
resetAspect!commands-actions!public! !
setAspectValue:!accessing!private! !
!

!Tools.AspectInspector class methodsFor!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: (Aspect symbol: #treeUpdateMode from: TreeView updateModes);
		add: (Aspect boolean: #treeHasGridLines);
		yourself!

registerAsToolWith: aSmalltalkSystem
    	"The receiver is being registered as a tool with aSmalltalkSystem. Perform any
    	additional registration operations here. Part of the <installableSystemTool>
    	protocol, and implemented at this level so that 3.0 tools can be installed
    	without amendment."!

treeHasGridLines
	^treeHasGridLines ?? false!

treeHasGridLines: anObject
	treeHasGridLines := anObject!

treeUpdateMode
	"Answer the symbolic name of the TreeView refresh mode to be used in the inspector's 
	aspect tree. This is one of:
		static	- The tree is fully populated with all display information on opening
		lazy - The tree enquires display information as required, but only once
		dynamic - The tree enquires display information on every repaint.
	The recommended mode is #lazy (at least for the PAI), since this will work best for potentially 
	slow access 	to aspect text and images."

	^treeUpdateMode!

treeUpdateMode: aSymbol
	treeUpdateMode := aSymbol! !
!Tools.AspectInspector class categoriesForMethods!
publishedAspects!public! !
registerAsToolWith:!operations!public! !
treeHasGridLines!accessing!private! !
treeHasGridLines:!accessing!private! !
treeUpdateMode!accessing!private! !
treeUpdateMode:!accessing!private! !
!

