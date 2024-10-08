﻿"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'Tools.BasicInspector'
	instanceVariableNames: 'variableNamesPresenter sourcePresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.BasicInspector guid: (Core.GUID fromString: '{87b4c68b-026e-11d3-9fd7-00a0cc3e4a32}')!

Tools.BasicInspector comment: 'BasicInspector is a <compositePresenter> that implements a generic inspect facility onto any <Object>.

Example:
SmalltalkSystem current basicInspect

Instance Variables:
	variableNamesPresenter	<ListPresenter> presenting the instance variables of the inspected object.
	sourcePresenter		<SmalltalkWorkspace> for displaying the selected variable values.


'!

!Tools.BasicInspector categoriesForClass!MVP-Presenters! !

!Tools.BasicInspector methodsFor!

accept
	"Saves the current source as the value of the selected variable of the
	receivers object."

	<commandQuery: #canSetVariable>
	| newObject oldObject |
	"If there is no source selection then the entire workspace is selected for consistency with saving method source. This also works rather better with word wrap too."
	sourcePresenter view hasSelection ifFalse: [sourcePresenter view selectAll].

	"Evaluate the new value and keep a copy of the old value for undo purposes"
	newObject := sourcePresenter evaluateItIfFail: [^self].
	oldObject := self getField: self currentField.
	self setField: self currentField to: newObject.
	Command current undoWith: 
			[self
				setField: self currentField to: oldObject;
				onVariableNameSelected].
	self onVariableNameSelected.
	self trigger: #inspecteeChanged!

browseClass
	"Private - Open a new default class browser on the class of the object being inspected."

	<commandQuery: #queryBrowseClass:>
	SmalltalkSystem current browseClass: self browseObject class!

browseHierarchy
	"Private - Open a new class browser on the class of the object being inspected."

	<commandQuery: #queryBrowseClass:>
	SmalltalkSystem current browseHierarchy: self browseObject class!

browseIt
	"Open a default browser on the current object"

	<commandQuery: #hasSelection>
	self browseObject browse!

browseObject
	"Private - Answer the object from the receiver that should be browsed"

	^variableNamesPresenter hasSelection ifTrue: [self variable] ifFalse: [self object]!

canSetVariable
	^self hasSelection and: [self variableIndex > self headerSize]!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	variableNamesPresenter := self add: ListPresenter new name: 'variablenames'.
	sourcePresenter := self add: SmalltalkSystem current workspaceClass new name: 'source'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	variableNamesPresenter
		when: #selectionChanged
			send: #onVariableNameSelected
			to: self;
		when: #actionPerformed
			send: #inspectIt
			to: self!

currentField
	"Private - Answers the offset of the current field within the receiver"

	^self fieldIndexFromVariableIndex: self variableIndex!

errorModel: aValueModel
	"Set the errorModel used to collect notifications from the Compiler."

	sourcePresenter errorModel: aValueModel!

extraFields
	"Private - Answer the number of extra fields in the field list, which appear after the instance
	variables, but before the indexed instance variables. Extra fields are inserted in
	inspectors to allow additional calculated information to be presented by performing
	accessor methods. This method will work except where the subclass does not include
	all its indexed instance variables in the field list it reports"

	^self variableNamesList size - self fields!

fieldIndexFromVariableIndex: index
	"Private - Answers the offset of the field within the receiver at the specified
	variable index."

	^index - self headerSize!

fields
	"Private - Answer the list of fields in the field list (named and indexable instance variables), which appear 
	after the inspectors header fields (accessors implemented by the inspector itself), and before
	any extra fields (accessors implemented by the inspected object). Must be overridden by subclasses
	which do not include all their indexable variables in the field list."

	^self selfField class instSize + self selfField size!

getField: anInteger
	"Private - Answer the field of the receiver's object which has the key at index
	anInteger in the field list (1 based)"

	^self selfField instVarAt: anInteger!

getFieldExtra: anInteger 
	"Private - Answer the field of the receiver's object which has the key at index
	anInteger in the field list (1 based), by using the basic accessor
	mechanism if the field represents an instance variable, or the accessor 
	method if it is an 'extra' field. This is used by many subclasses."

	| instSize |
	instSize := self selfField class instSize.
	^anInteger <= instSize 
		ifTrue: [self selfField instVarAt: anInteger]
		ifFalse: 
			["Must be in range of indexed and extra fields"

			| extra |
			extra := self extraFields.
			anInteger <= (instSize + extra) 
				ifTrue: 
					[self selfField perform: (self variableNamesList at: anInteger + self headerSize) asSymbol]
				ifFalse: [self selfField at: anInteger - instSize - extra]]!

getFieldList
	"Private - Answer an OrderedCollection of instance variable keys (string names for
	named instance variables, and numeric indices for indexed instance variables)"

	^self selfField basicClass allInstanceVariableNames , (1 to: self selfField basicSize)!

hasSelection
	^variableNamesPresenter hasSelection!

headerList
	"Private - Answer an ordered collection of Associations. The key is the String variable
	entry in the variablesList model. The value is the symbol which is perform'ed
	to find the value to display in the sourceModel when the variables is selected."

	^self class headerList
!

headerSize
	"Private - Answer the number of extra fields in the field list which appear at the
	top of the list. They are used for special access to the receiver's object,
	for example the '-Self-' field allows access to the object itself."

	^self headerList size
!

infoTipForVariable: variableName
	"Answer the info. tip (bubble help) to be displayed when the user hovers over a variable
	in the variables list."

	| list idx |
	list := variableNamesPresenter view.
	idx := list itemFromPoint: list cursorPosition.
	^idx isNil 
		ifTrue: ['']
		ifFalse: [
			[(self variableAtIndex: idx) printStringLimitedTo: 200]
				on: Error do: [:e | 'Value unavailable: ', e description]]!

inspectIt
	"Open a new Inspector on the variable selected in variablesModel."

	<commandQuery: #hasSelection>
	self variable inspect!

inspectReferences
	"Open a new Inspector on all the objects which references the variable
	selected in variablesModel."

	<commandQuery: #hasSelection>
	| refs |
	refs := self variable allReferences copyWithout: self.
	refs isEmpty
		ifTrue: 
			[MessageBox
				notify: ('There are no additional references to:<n><t><1p>' expandMacrosWith: self variable)]
		ifFalse: [refs inspect]!

model: aValueModel
	"Set the model of the receiver to be aValueModel. We intercept a change
	notification so that the list selection can track this value."

	super model: aValueModel.
	self onValueChanged
!

nilVariable
	"Private - Nil the currently selected variable."

	<commandQuery: #canSetVariable>
	| oldObject |
	oldObject := self getField: self currentField.
	self setField: self currentField to: nil.
	Command current undoWith: 
			[self
				setField: self currentField to: oldObject;
				onVariableNameSelected].
	self onVariableNameSelected.
	self trigger: #inspecteeChanged!

object
	"Answer the object inspected by the receiver."

	^self model value!

object: anObject
	"Set the object which is inspected by the receiver."

	self value: anObject
!

onValueChanged
	"The object which is inspected by the receiver has been changed."

	| variableNamesList |
	super onValueChanged.
	variableNamesList := (self headerList collect: [:anAssociation | anAssociation key]), self getFieldList.
	variableNamesPresenter list: variableNamesList.
	sourcePresenter evaluationContext: self object.
	variableNamesPresenter view selectionByIndex: 1.

!

onVariableNameSelected
	"Private - The selection in the variablesModel has changed. Update the sourceModel
	to show the value stored in the object at the selected variable."

	| var |
	sourcePresenter text: (
			[var := self variable.
			var debugPrintString] on: Error
					do: 
						[:e |
						| name |
						name := self variableName.
						self unableToDisplayVariableErrorFormatString
							expandMacrosWith: self variableName
							with: var class
							with: e description
							with: (name isInteger
									ifTrue: ['self at: ' , name displayString]
									ifFalse: [self variableName , ' printString'])])!

onViewOpened
	"Now run through all our sub-presenters and connect them in turn
	to same named sub-views within aCompositeView"

	super onViewOpened.
	(variableNamesPresenter view)
		getInfoTipBlock: [:v | self infoTipForVariable: v];
		selectionByIndex: 1!

queryBrowseClass: query
	| class |
	class := [self hasSelection ifTrue: [self browseObject class]] on: Error do: [:e | nil].
	class isNil
		ifFalse: 
			[query
				beEnabled;
				expandMenuTextWith: class name]!

refresh
	"Private - The fields of the receiver's object have been modified so update
	our model of it while keeping the original selection if possible."

	| oldSelection |
	oldSelection := self variableName.
	self model notifyChanged.
	variableNamesPresenter selection: oldSelection ifAbsent: []!

selfField
	"Private - Answer the receiver's object for displaying in the sourceModel."

	^self object!

setField: anInteger to: anObject
	"Private - Determine the field of the receiver's object which has the key at index
	anInteger in the field list, and set its value to anObject."

	^self selfField instVarAt: anInteger put: anObject!

source
	"Answer the source definition for the currently selected variable
	of the receiver's object."

	^sourcePresenter value asString!

systemModel
	^SmalltalkSystem current!

unableToDisplayVariableErrorFormatString
	"Private - Answer the format string used to construct the error message text to be
	displayed in place of a variable value when a variable is selected that cannot be
	printed."

	^'an invalid <2p> [<3s>]<n><n>Evaluate the following expression to debug:<n><t><4s>'
!

variable
	"Answer the variable associated with the currently selected
	variable name of the receiver's object or nil if there is no selection."

	^self variableAtIndex: self variableIndex!

variableAtIndex: index
	"Private - Answer the value of the variable at the specified <integer> index in the receiver's
	variable list."

	^index isZero ifFalse: [
		index <= self headerSize
			ifTrue: [self perform: (self headerList at: index) value]
			ifFalse: [self getField: (self fieldIndexFromVariableIndex: index)]]!

variableIndex
	"Private - Answer the index of the variable associated with the curently
	selected variable name of the receiver's object or 0 if there is no selection."

	^variableNamesPresenter selectionByIndex!

variableName
	"Private - Answer the selected variable name of the receiver's object."

	^variableNamesPresenter selectionOrNil!

variableName: name
	"Private - Select the variable name of the receiver's object."

	variableNamesPresenter selection: name!

variableNamesList
	"Answer an OrderedCollection of all the names of the currently
	inspected objects variables."

	^variableNamesPresenter list! !

!Tools.BasicInspector categoriesForMethods!
accept!commands-actions!public! !
browseClass!commands-actions!private! !
browseHierarchy!commands-actions!private! !
browseIt!commands-actions!public! !
browseObject!accessing!private! !
canSetVariable!commands-queries!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
currentField!accessing!private! !
errorModel:!accessing!public! !
extraFields!accessing!private! !
fieldIndexFromVariableIndex:!accessing!private! !
fields!accessing!private! !
getField:!accessing!private! !
getFieldExtra:!accessing!private! !
getFieldList!accessing!private! !
hasSelection!commands-queries!private! !
headerList!accessing!private! !
headerSize!accessing!private! !
infoTipForVariable:!accessing!public! !
inspectIt!commands-actions!public! !
inspectReferences!commands-actions!public! !
model:!accessing!public! !
nilVariable!commands-actions!private! !
object!accessing!public! !
object:!accessing!public! !
onValueChanged!accessing!public! !
onVariableNameSelected!event handling!private! !
onViewOpened!event handling!public! !
queryBrowseClass:!commands-queries!private! !
refresh!commands-actions!private! !
selfField!accessing!private! !
setField:to:!accessing!private! !
source!accessing!public! !
systemModel!accessing!private! !
unableToDisplayVariableErrorFormatString!constants!private! !
variable!accessing!public! !
variableAtIndex:!accessing!private! !
variableIndex!accessing!private! !
variableName!accessing!private! !
variableName:!accessing!private! !
variableNamesList!accessing!public! !
!

!Tools.BasicInspector class methodsFor!

headerList
	"Answer an OrderedCollection of associations between prefix attributes and selectors
	to be sent to instances of the receiver to access those attributes."

	^##(OrderedCollection with: 'self' -> #selfField)
!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

publishedEventsOfInstances
	"Answer a Set of Symbols that describe the published events triggered
	by instances of the receiver."

	^super publishedEventsOfInstances
		add: #inspecteeChanged;
		yourself.
!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 144 nil nil nil 5 nil nil nil 144 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 3 518 #{Core.Association} 18 #{UI.ListView} 50 45 nil 144 50 2 8 1140936781 1025 320 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 2886 4 #{UI.Menu} nil true 50 8 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 562 1 594 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 562 1 594 #nilVariable 8 'Set to &Nil' 1 1 nil nil nil 818 4097 562 1 594 #browseIt 8 '&Browse It' 1 1 642 nil true 674 8 'ClassBrowserShell.ico' 736 65541 nil nil nil 818 4097 562 1 594 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Inspect' nil 1 nil nil nil nil nil nil nil 320 nil nil 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 418 1 3142 5 #{UI.ListViewColumn} 8 '' 441 #left 1104 1090 #<= 8 #() nil nil 320 nil 3 nil nil #report 8 #() nil 133217 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 320 nil nil nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 224 0 0 0 39 1 0 0] 193 352 8 '' 320 1362 #contextMenu: 50 1 528 320 3 8 #() 518 #{Graphics.Point} 193 193 nil 35 3 290 18 #{UI.Splitter} 50 12 nil 144 50 2 8 1140850688 1 1600 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 1600 nil 1 #left nil nil nil 1554 1 1 1554 9 9 nil 1696 nil 1314 50 1 1362 #createWindow: 50 1 1410 1442 8 #[224 0 0 0 0 0 0 0 229 0 0 0 39 1 0 0] 193 1632 8 '' 1600 3 8 #() 1554 193 193 nil 27 1 290 18 #{UI.ReferenceView} 50 14 nil 144 50 2 8 1140850688 131073 1904 nil nil nil 5 nil nil nil 1904 582 1 #{UI.ResourceIdentifier} #{Tools.SmalltalkWorkspace} #resource_Default_view nil 1314 50 1 1362 #createWindow: 50 1 1410 1442 8 #[229 0 0 0 0 0 0 0 167 2 0 0 39 1 0 0] 193 1936 8 '' 1904 3 8 #() 1554 193 193 nil 27 5 false 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 1904 8 'source' 320 8 'variablenames' nil 1314 50 1 1362 #createWindow: 50 1 1410 1442 8 #[0 0 0 0 0 0 0 0 167 2 0 0 39 1 0 0] 193 176 8 '' 144 3 50 3 320 1600 1904 1554 193 193 nil 27 550 #{Core.IdentityDictionary} 0 nil 1314 50 1 1362 #createWindow: 50 1 1410 1442 8 #[255 14 0 0 10 0 0 0 166 17 0 0 49 1 0 0] 193 80 8 '' 32 1 50 1 144 1554 193 193 nil 27)!

shellOn: anObject
	"Open an Inspector shell displaying on anObject. 
	Answer the new Inspector."

	| inspector shell |
	shell := InspectorShell create.
	shell caption: self displayString , ' on ' , anObject basicPrintString.
	inspector := self createIn: shell on: (ValueHolder with: anObject).
	inspector view arrangement: #center.
	shell view validateLayout.
	shell show setInitialFocus.
	^inspector! !

!Tools.BasicInspector class categoriesForMethods!
headerList!constants!public! !
icon!constants!public! !
publishedEventsOfInstances!events!public! !
resource_Default_view!public!resources-views! !
shellOn:!instance creation!public! !
!

