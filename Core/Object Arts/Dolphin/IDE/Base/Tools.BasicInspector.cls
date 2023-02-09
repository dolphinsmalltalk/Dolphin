"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter subclass: #'Tools.BasicInspector'
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

	variableNamesPresenter hasSelection 
		ifTrue: 
			["If there is no selection then the entire workspace is selected for consistency
		with saving method source. This also works rather better with word wrap too."

			| newObject oldObject |
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
			self trigger: #inspecteeChanged]!

browseClass
	"Private - Open a new default class browser on the class of the object being inspected."

	SmalltalkSystem current browseClass: self browseObject class!

browseHierarchy
	"Private - Open a new class browser on the class of the object being inspected."

	SmalltalkSystem current browseHierarchy: self browseObject class!

browseIt
	"Open a default browser on the current object"

	self browseObject browse!

browseObject
	"Private - Answer the object from the receiver that should be browsed"

	^variableNamesPresenter hasSelection ifTrue: [self variable] ifFalse: [self object]!

browseSystem
	"Open a new system browser on the class of the object being inspected."
	
	self model browseSystem: self browseObject class!

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

	variableNamesPresenter hasSelection
		ifTrue: [self variable inspect]
!

inspectReferences
	"Open a new Inspector on all the objects which references the variable
	selected in variablesModel."

	variableNamesPresenter hasSelection
		ifTrue: 
			[| refs |
			refs := self variable allReferences copyWithout: self.
			refs isEmpty
				ifTrue: 
					[MessageBox
						notify: ('There are no additional references to:<n><t><1p>' expandMacrosWith: self variable)]
				ifFalse: [refs inspect]]!

model: aValueModel
	"Set the model of the receiver to be aValueModel. We intercept a change
	notification so that the list selection can track this value."

	super model: aValueModel.
	self onValueChanged
!

nilVariable
	"Private - Nil the currently selected variable."

	| oldObject |
	oldObject := self getField: self currentField.
	self setField: self currentField to: nil.
	Command current undoWith: [self setField: self currentField to: oldObject; onVariableNameSelected].
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

queryCommand: query
	"Private - Enter details about a potential command for the receiver into the 
	<CommandQuery>, query."

	| cmd hasSel |
	super queryCommand: query.
	cmd := query commandSymbol.
	hasSel := variableNamesPresenter hasSelection.
	(#(#inspectReferences #basicInspectIt) includes: cmd)
		ifTrue: 
			[query isEnabled: hasSel.
			^true].
	#inspectIt == cmd
		ifTrue: 
			[query
				isEnabled: hasSel;
				isDefault: hasSel.
			^true].
	(#(#accept #nilVariable) includes: cmd)
		ifTrue: 
			[query isEnabled: (hasSel and: [self variableIndex > self headerSize]).
			^true].
	(#(#browseHierarchy #browseSystem #browseClass) identityIncludes: query command)
		ifTrue: 
			[| class |
			[hasSel ifTrue: [class := self browseObject class]] on: Error do: [:e | ].
			class isNil
				ifFalse: 
					[query
						isEnabled: (self respondsTo: #browseSystem);
						text: 'Browse ' , class name.
					^true]
				ifTrue: 
					[query
						isEnabled: false;
						text: query commandDescription menuText]].
	cmd == #undo
		ifTrue: 
			[query
				beDisabled;
				text: (query commandDescription menuText expandMacrosWithArguments: {''} locale: Locale smalltalk).
			^true].
	^false!

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
accept!commands!public! !
browseClass!commands!private! !
browseHierarchy!commands!private! !
browseIt!commands!public! !
browseObject!accessing!private! !
browseSystem!commands!public! !
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
headerList!accessing!private! !
headerSize!accessing!private! !
infoTipForVariable:!accessing!public! !
inspectIt!commands!public! !
inspectReferences!commands!public! !
model:!accessing!public! !
nilVariable!commands!private! !
object!accessing!public! !
object:!accessing!public! !
onValueChanged!accessing!public! !
onVariableNameSelected!event handling!private! !
onViewOpened!event handling!public! !
queryCommand:!commands!private! !
refresh!commands!private! !
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 nil nil nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 512 nil nil nil 5 nil nil nil 512 1376774 #{UI.ProportionalLayout} 138 #{Core.Dictionary} 34 3 1049094 #{Core.Association} 410 #{UI.ListView} 34 45 nil 512 34 2 8 1140936781 1025 672 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 5 461638 4 #{UI.Menu} nil true 34 8 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 914 1 946 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 914 1 946 #nilVariable 8 'Set to &Nil' 1 1 nil nil nil 1170 4097 914 1 946 #browseIt 8 '&Browse It' 1 1 994 nil true 1026 8 'ClassBrowserShell.ico' 1088 65541 nil nil nil 1170 4097 914 1 946 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Inspect' nil 1 nil nil nil nil nil nil nil 672 nil 8 1815049392 786950 #{Core.Message} #displayString 784 nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 '' 441 #left 1472 1458 #<= 8 #() nil nil 672 nil 3 nil nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 1 1746 449 591 672 1698 #contextMenu: 34 1 880 672 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 224 0 0 0 39 1 0 0] 8 #() 1746 193 193 nil 35 3 642 410 #{UI.Splitter} 34 12 nil 512 34 2 8 1140850688 1 1920 nil nil nil 517 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 1920 nil 1 #left nil nil nil 1746 1 1 1746 9 9 nil 2016 nil 1650 34 1 1698 #createAt:extent: 34 2 1746 449 1 1746 11 591 1920 1826 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 224 0 0 0 0 0 0 0 229 0 0 0 39 1 0 0] 8 #() 1888 nil 27 1 642 410 #{UI.ReferenceView} 34 14 nil 512 34 2 8 1140850688 131073 2208 nil nil nil 5 nil nil nil 2208 1376838 1 #{UI.ResourceIdentifier} #{Tools.SmalltalkWorkspace} #resource_Default_view nil 1650 34 1 1698 #createAt:extent: 34 2 1746 459 1 1746 901 591 2208 1826 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 229 0 0 0 0 0 0 0 167 2 0 0 39 1 0 0] 784 1888 nil 27 5 false 170 192 34 4 2208 8 'source' 672 8 'variablenames' nil 1650 34 1 1698 #createAt:extent: 34 2 1746 1 1 1746 1359 591 512 1826 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 167 2 0 0 39 1 0 0] 34 3 672 1920 2208 1888 nil 27 170 192 784 nil 1650 34 1 1698 #createAt:extent: 34 2 1746 12287 21 1746 1359 591 416 1826 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 166 26 0 0 49 1 0 0] 34 1 512 1888 nil 27)!

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

