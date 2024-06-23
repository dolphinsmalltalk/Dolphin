"Filed out from Dolphin Smalltalk"!

Tools.AspectInspector
	subclass: #'Tools.InstVarInspector'
	instanceVariableNames: 'sourcePresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.InstVarInspector guid: (Core.GUID fromString: '{da630ac4-c186-11d5-9849-0800460222f0}')!

Tools.InstVarInspector comment: ''!

!Tools.InstVarInspector categoriesForClass!MVP-Resources-IDE Tools! !

!Tools.InstVarInspector methodsFor!

accept
	"Saves the current source as the value of the selected variable of the
	receivers object."

	"If there is no selection then the entire workspace is selected for consistency
	with saving method source. This also works rather better with word wrap too."

	<commandQuery: #canSetAspect>
	| newObject oldObject |
	sourcePresenter view hasSelection ifFalse: [sourcePresenter view selectAll].

	"Evaluate the new value and keep a copy of the old value for undo purposes"
	newObject := sourcePresenter evaluateItIfFail: [^self].
	oldObject := self aspectValue.
	self setAspectValue: newObject.
	Command current undoWith: [self setAspectValue: oldObject]!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	sourcePresenter := self add: SmalltalkSystem current workspaceClass new name: 'source'!

defaultBatchSize
	"Answers the default batch size of the receiver, i.e. the number of keyed elements to return at a time"

	^500
!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see.
	This will be used as the label for the tab when the receiver is being displayed within the Flipper Inspector"

	aPuttableStream nextPutAll: 'Instance Variables'!

getInstVarAccessorsOf: anInstVarAccessor
	"Private - Answers an <Array> of  <InstVarAccessors> to show as children of anInstVarAccessor"

	| fixedPart indexedPart inspectee batchAccessor |
	inspectee := [anInstVarAccessor value] on: Error do: [:ex | ex].
	fixedPart := (1 to: inspectee class instSize)
				collect: [:i | ((inspectee instVarAt: i) newAspect: i class: InstVarAspect) accessorFor: inspectee].
	batchAccessor := IndexedInstVarBatchAccessor subject: inspectee batchSize: self defaultBatchSize.
	indexedPart := batchAccessor getBatchAccessors.
	^fixedPart , indexedPart!

inspecteeChanged
	"Private - The receiver's model has had the currently inspected instance variable updated. 
	Force the receiver to update the variableNamesPresenter appropriately and 
	trigger an #inspecteeChanged to inform our interested parties"

	self instVarUpdated: self aspectAccessor.
	self trigger: #inspecteeChanged!

inspectIt
	"Open a new Inspector on the variable selected in variablesModel."

	<commandQuery: #hasSelection>
	self aspectValue inspect!

instVarUpdated: anInstVarAccessor
	"Private - The instance variable identified by anInstVarAccessor has been updated. 
	Ensure that our aspect tree model is refreshed appropriately"

	aspectTreePresenter model collapse: anInstVarAccessor!

object
	"Answer the object inspected by the receiver."

	^self model value!

onAspectSelected
	"Private - The selection in the variablesModel has changed. Update the source presenter
	to show the value stored in the object at the selected variable."

	(aspectTreePresenter selectionIfNone: [^self]) selectIn: self!

onValueChanged
	"The object which is inspected by the receiver has been changed."

	self refresh!

refresh
	| instVarTreeModel inspectee accessor |
	inspectee := self object.
	accessor := (inspectee newAspect: 0 class: InstVarAspect) accessorFor: inspectee.
	instVarTreeModel := (ExpandingTreeModel withRoots: {accessor})
				getChildrenBlock: [:x | self getInstVarAccessorsOf: x].
	aspectTreePresenter
		model: instVarTreeModel;
		expand: accessor;
		selectionOrNil: accessor!

selectAspect: anAspectAccessor
	| var |
	var := [anAspectAccessor value] on: Error do: [:ex | ex].
	sourcePresenter evaluationContext: var.
	sourcePresenter text: ([var printString] on: Error
				do: 
					[:e |
					| name |
					name := anAspectAccessor name.
					self unableToDisplayVariableErrorFormatString
						expandMacrosWith: name
						with: var class
						with: e description
						with: (name isInteger ifTrue: ['self basicAt: ' , name printString] ifFalse: [name])])!

setAspectValue: anObject
	"Private - Set the value associated with the currently selected
	instance variable name to anObject."

	self aspectAccessor value: anObject.
	self inspecteeChanged!

unableToDisplayVariableErrorFormatString
	"Private - Answer the format string used to construct the error message text to be
	displayed in place of a variable value when a variable is selected that cannot be
	printed."

	^'an invalid <2p> [<3s>]<n><n>Evaluate the following expression to debug:<n><t>self printString'! !

!Tools.InstVarInspector categoriesForMethods!
accept!commands-actions!public! !
createComponents!initializing!public! !
defaultBatchSize!constants!private! !
displayOn:!displaying!public! !
getInstVarAccessorsOf:!accessing!private! !
inspecteeChanged!private!updating! !
inspectIt!commands-actions!public! !
instVarUpdated:!private!updating! !
object!accessing!public! !
onAspectSelected!event handling!private! !
onValueChanged!accessing!public! !
refresh!commands-actions!public!updating! !
selectAspect:!event handling!private! !
setAspectValue:!accessing!private! !
unableToDisplayVariableErrorFormatString!constants!private! !
!

!Tools.InstVarInspector class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	SmalltalkSystem current registerTool: self.
	treeUpdateMode := #dynamic.
	treeHasGridLines := false!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 3 518 #{Core.Association} 18 #{UI.ListTreeView} 50 59 nil 32 50 2 8 1140953421 1 224 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 13 2886 4 #{UI.Menu} nil true 50 12 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 466 1 498 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 466 1 498 #browseIt 8 '&Browse It' 1 1 546 nil true 578 8 'ClassBrowserShell.ico' 640 65541 nil nil nil 722 4097 466 1 498 #copyAspect 8 '&Copy' 1 1 nil nil nil 466 1 498 #pasteAspect 8 '&Paste <d>' 1 1 nil nil nil 722 4097 466 1 498 #editAspect 8 '&Edit' 1 1 nil nil nil 466 1 498 #resetAspect 8 'Set to Nil/Default' 1 1 nil nil nil 722 4097 466 1 498 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 224 nil nil 518 #{Core.Message} #valueText 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 322 3 3142 5 #{UI.ListViewColumn} 8 'Instance Variable' 267 #left 1154 #valueNameOnly 8 #() 1154 #<= 8 #() nil nil 224 1154 #valueImage 1312 3 1154 #valueNameInfo 1312 nil 1250 8 'Value' 267 #left 1154 #valueTextOnly 8 #() 1154 #<= 1344 nil nil 224 nil 3 nil nil 1250 8 '' 41 #center 1154 #displayString 8 #() 1154 #<= 1520 nil nil 224 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 1552 8 'doIt' 8 '[:x | Tools.PropertyInspector editButtonImageIndexFor: x]' 8 #[31 105 45 17 177 106] 1094 2 #{Kernel.VariableBinding} #PropertyInspector #{Tools.PropertyInspector} #{Tools} 1 #editButtonImageIndexFor: 1568 7 257 nil 1 nil nil #report 8 #() nil 131431 518 #{Graphics.Point} 129 129 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil false 1862 3 #{UI.VirtualTreeModel} nil 368 322 0 nil nil 1554 0 nil 1318 #{Kernel.CompiledMethod} 2 3 1744 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 1760 1554 0 nil 1810 1 83886083 1744 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 1856 7 257 nil nil 550 #{Core.PluggableSet} 0 294 #{Core.IdentitySet} 0 13 5 nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 1714 1 1 1714 581 591 224 2018 #text: 50 1 8 'Instance Variable' 224 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 34 1 0 0 39 1 0 0] 8 #() 1714 193 193 nil 2029 5 194 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 2240 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2240 nil 1 #left nil nil nil 1714 1 1 1714 9 9 nil 2336 nil 1970 50 1 2018 #createAt:extent: 50 2 1714 581 1 1714 11 591 2240 2146 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 34 1 0 0 0 0 0 0 39 1 0 0 39 1 0 0] 8 #() 2208 nil 27 1 194 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 2528 nil nil nil 5 nil nil nil 2528 582 1 #{UI.ResourceIdentifier} #{Tools.SmalltalkWorkspace} #resource_Default_view nil 1970 50 1 2018 #createAt:extent: 50 2 1714 591 1 1714 291 591 2528 2146 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 39 1 0 0 0 0 0 0 184 1 0 0 39 1 0 0] 8 #() 2208 nil 27 3 false 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 224 8 'aspects' 2528 8 'source' nil 1970 50 1 2018 #createAt:extent: 50 2 1714 6143 21 1714 881 591 32 2146 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 183 13 0 0 49 1 0 0] 50 3 224 2240 2528 2208 nil 27)! !

!Tools.InstVarInspector class categoriesForMethods!
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
!

