"Filed out from Dolphin Smalltalk 7"!

AspectInspector subclass: #InstVarInspector
	instanceVariableNames: 'sourcePresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InstVarInspector guid: (GUID fromString: '{da630ac4-c186-11d5-9849-0800460222f0}')!
InstVarInspector comment: ''!
!InstVarInspector categoriesForClass!Development!MVP-Resources-IDE Tools! !
!InstVarInspector methodsFor!

accept
	"Saves the current source as the value of the selected variable of the
	receivers object."

	"If there is no selection then the entire workspace is selected for consistency
	with saving method source. This also works rather better with word wrap too."

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
	sourcePresenter := self add: Smalltalk developmentSystem workspaceClass new name: 'source'!

defaultBatchSize
	"Answers the default batch size of the receiver, i.e. the number of keyed elements to return at a time"

	^500
!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it. This will be used as the label for the tab when the receiver is being displayed
	within the Flipper Inspector"

	aStream nextPutAll: 'Instance Variables'!

getInstVarAccessorsOf: anInstVarAccessor 
	"Private - Answers an <Array> of  <InstVarAccessors> to show as children of anInstVarAccessor"

	| fixedPart indexedPart inspectee batchAccessor |
	inspectee := [anInstVarAccessor value] on: Error do: [:ex | ex].
	fixedPart := (1 to: inspectee class instSize) collect: 
					[:each | 
					| value aspect |
					value := inspectee instVarAt: each.
					aspect := value newAspect: each class: InstVarAspect.
					aspect accessorFor: inspectee].
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

queryCommand: query
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery>,  query."

	| command accessor |
	command := query commandSymbol.
	accessor := self aspectAccessor.
	#accept == command 
		ifTrue: 
			[query isEnabled: (accessor notNil and: [accessor canSet]).
			^true].
	^super queryCommand: query!

refresh
	| instVarTreeModel inspectee accessor |
	inspectee := self object.
	accessor := (inspectee newAspect: 0 class: InstVarAspect) accessorFor: inspectee.
	instVarTreeModel := (ExpandingTreeModel withRoots: (Array with: accessor)) 
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
						with: (name isInteger ifTrue: ['self basicAt: ' , name displayString] ifFalse: [name])])!

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
!InstVarInspector categoriesFor: #accept!commands!public! !
!InstVarInspector categoriesFor: #createComponents!initializing!public! !
!InstVarInspector categoriesFor: #defaultBatchSize!constants!private! !
!InstVarInspector categoriesFor: #displayOn:!displaying!public! !
!InstVarInspector categoriesFor: #getInstVarAccessorsOf:!accessing!private! !
!InstVarInspector categoriesFor: #inspecteeChanged!private!updating! !
!InstVarInspector categoriesFor: #inspectIt!commands!public! !
!InstVarInspector categoriesFor: #instVarUpdated:!private!updating! !
!InstVarInspector categoriesFor: #object!accessing!public! !
!InstVarInspector categoriesFor: #onAspectSelected!event handling!private! !
!InstVarInspector categoriesFor: #onValueChanged!accessing!public! !
!InstVarInspector categoriesFor: #queryCommand:!commands!private! !
!InstVarInspector categoriesFor: #refresh!commands!public!updating! !
!InstVarInspector categoriesFor: #selectAspect:!event handling!private! !
!InstVarInspector categoriesFor: #setAspectValue:!accessing!private! !
!InstVarInspector categoriesFor: #unableToDisplayVariableErrorFormatString!constants!private! !

!InstVarInspector class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	Smalltalk developmentSystem registerTool: self.
	treeUpdateMode := #dynamic.
	treeHasGridLines := false!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 3 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.ListTreeView) 34 44 nil 416 34 2 8 1140953421 1 576 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 13 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 834 1 866 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 834 1 866 #browseIt 8 '&Browse It' 1 1 914 nil true 960 8 'ClassBrowserShell.ico' 1008 nil nil 1090 4097 834 1 866 #copyAspect 8 '&Copy' 1 1 nil nil nil 834 1 866 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 1090 4097 834 1 866 #editAspect 8 '&Edit' 1 1 nil nil nil 834 1 866 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 1090 4097 834 1 866 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 576 nil 8 1912800272 459270 ##(Smalltalk.Message) #valueText 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Instance Variable' 267 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 1680 8 'doIt' 8 '[:x | x valueNameOnly]' 8 #[30 105 226 0 106] #valueNameOnly 1696 7 257 nil 1522 #<= 8 #() nil nil 576 nil 3 1682 0 nil 1714 2 1 1680 8 'doIt' 8 '[:x | x valueNameInfo ]' 8 #[30 105 226 0 106] #valueNameInfo 1824 7 257 nil nil 1634 8 'Value' 267 #left 1682 0 nil 1714 2 1 1680 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 1936 7 257 nil 1522 #<= 1808 nil nil 576 1682 0 nil 1714 2 1 1680 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 2032 7 257 nil 3 nil nil 1634 8 '' 41 #center 1522 #displayString 8 #() 1522 #<= 2160 nil nil 576 1682 0 nil 1714 3 1 1680 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 2192 7 257 nil 1 nil nil #report 688 nil 133479 328198 ##(Smalltalk.Point) 129 129 34 4 nil nil 2274 1 1 nil false 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 720 138 144 688 nil nil 1682 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 2336 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 2352 1682 0 nil 2402 1 83886083 2336 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 2448 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 688 138 ##(Smalltalk.PluggableSet) 688 13 5 nil nil nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 2274 1 1 2274 581 591 576 2594 #contextMenu: 34 1 800 576 2594 #text: 34 1 8 'Instance Variable' 576 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 34 1 0 0 39 1 0 0] 8 #() 2274 193 193 nil 2021 5 546 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2848 nil nil nil 5 nil nil nil 2848 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 2530 138 144 34 1 2594 #createAt:extent: 34 2 2274 591 1 2274 291 591 2848 2754 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 39 1 0 0 0 0 0 0 184 1 0 0 39 1 0 0] 688 2816 nil 27 3 546 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 3104 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3104 nil 1 #left nil nil nil 2274 1 1 2274 9 9 nil 3200 nil 2530 138 144 34 1 2594 #createAt:extent: 34 2 2274 581 1 2274 11 591 3104 2754 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 34 1 0 0 0 0 0 0 39 1 0 0 39 1 0 0] 8 #() 2816 nil 27 1 false 170 192 34 4 576 8 'aspects' 2848 8 'source' nil 2530 138 144 34 1 2594 #createAt:extent: 34 2 2274 3839 21 2274 881 591 416 2754 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 55 9 0 0 49 1 0 0] 34 3 576 3104 2848 2816 nil 27 )! !
!InstVarInspector class categoriesFor: #initialize!initializing!private! !
!InstVarInspector class categoriesFor: #resource_Default_view!public!resources-views! !

