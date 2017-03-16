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
	treeUpdateMode := #dynamic!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  202 8 ##(Smalltalk.Dictionary)  98 3 721414 ##(Smalltalk.Association)  410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 656 0 498 528 0 517 0 0 0 656 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  581 1 882 11 591 656 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 34 1 0 0 0 0 0 0 39 1 0 0 39 1 0 0] 98 0 882 193 193 0 27 1 626 410 8 ##(Smalltalk.ListTreeView)  98 44 0 416 98 2 8 1140953421 1 1024 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  498 8 4278190080 0 13 265030 4 ##(Smalltalk.Menu)  0 16 98 12 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 1282 1 1314 8 #inspectReferences 8 'Inspect &References' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 1282 1 1314 8 #browseIt 8 '&Browse It' 1 1 1378 0 16 1424 8 'ClassBrowserShell.ico' 1472 0 0 1570 4097 1282 1 1314 8 #copyAspect 8 '&Copy' 1 1 0 0 0 1282 1 1314 8 #pasteAspect 8 '&Paste <1d>' 1 1 0 0 0 1570 4097 1282 1 1314 8 #editAspect 8 '&Edit' 1 1 0 0 0 1282 1 1314 8 #nilAspect 8 'Set to &Nil' 1 1 0 0 0 1570 4097 1282 1 1314 8 #refresh 8 'Re&fresh' 1 1 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 1024 0 8 4294907285 459270 ##(Smalltalk.Message)  8 #valueText 98 0 0 1049926 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 3 920646 5 ##(Smalltalk.ListViewColumn)  8 'Instance Variable' 267 8 #left 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  2 1 2288 8 'doIt' 8 '[:x | x valueNameOnly]' 8 #[30 105 226 0 106] 8 #valueNameOnly 2304 7 257 0 2098 8 #<= 98 0 0 0 1024 0 3 2290 0 0 2322 2 1 2288 8 'doIt' 8 '[:x | x valueNameInfo ]' 8 #[30 105 226 0 106] 8 #valueNameInfo 2464 7 257 0 0 2226 8 'Value' 267 2272 2290 0 0 2322 2 1 2288 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] 8 #valueTextOnly 2592 7 257 0 2098 2432 2448 0 0 1024 2290 0 0 2322 2 1 2288 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] 8 #valueImage 2704 7 257 0 3 0 0 2226 8 '' 41 8 #center 2098 8 #displayString 98 0 2098 2432 2880 0 0 1024 2290 0 0 2322 3 1 2288 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] 8 ##(Smalltalk.PropertyInspector)  8 #editButtonImageIndexFor: 2912 7 257 0 1 0 0 8 #report 1152 0 2407 882 129 129 0 32 1050438 3 ##(Smalltalk.VirtualTreeModel)  0 1184 202 208 1152 0 0 2290 0 0 918822 ##(Smalltalk.CompiledMethod)  2 3 3056 8 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] 8 #childrenOf: 8 #notEmpty 17 257 3072 2290 0 0 3122 1 83886083 3056 8 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 3216 7 257 0 0 202 8 ##(Smalltalk.PluggableSet)  1152 202 3296 1152 13 5 0 0 0 0 0 0 0 754 202 208 98 3 818 848 98 2 882 1 1 882 581 591 1024 818 8 #contextMenu: 98 1 1248 1024 818 8 #text: 98 1 8 'Instance Variable' 1024 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 34 1 0 0 39 1 0 0] 98 0 992 0 2021 5 626 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 3616 0 0 0 5 0 0 0 3616 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.SmalltalkWorkspace)  8 #resource_Default_view 0 754 202 208 98 1 818 848 98 2 882 591 1 882 291 591 3616 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 39 1 0 0 0 0 0 0 184 1 0 0 39 1 0 0] 1152 992 0 27 3 32 234 256 98 4 3616 8 'source' 1024 8 'aspects' 0 754 202 208 98 1 818 848 98 2 882 3359 21 882 881 591 416 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 71 8 0 0 49 1 0 0] 98 3 1024 656 3616 992 0 27 )! !
!InstVarInspector class categoriesFor: #initialize!initializing!private! !
!InstVarInspector class categoriesFor: #resource_Default_view!public!resources-views! !

