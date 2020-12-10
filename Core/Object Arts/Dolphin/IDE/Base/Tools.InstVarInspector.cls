"Filed out from Dolphin Smalltalk 7"!

Tools.AspectInspector subclass: #'Tools.InstVarInspector'
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

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see.
	This will be used as the label for the tab when the receiver is being displayed within the Flipper Inspector"

	aPuttableStream nextPutAll: 'Instance Variables'!

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
!Tools.InstVarInspector categoriesFor: #accept!commands!public! !
!Tools.InstVarInspector categoriesFor: #createComponents!initializing!public! !
!Tools.InstVarInspector categoriesFor: #defaultBatchSize!constants!private! !
!Tools.InstVarInspector categoriesFor: #displayOn:!displaying!public! !
!Tools.InstVarInspector categoriesFor: #getInstVarAccessorsOf:!accessing!private! !
!Tools.InstVarInspector categoriesFor: #inspecteeChanged!private!updating! !
!Tools.InstVarInspector categoriesFor: #inspectIt!commands!public! !
!Tools.InstVarInspector categoriesFor: #instVarUpdated:!private!updating! !
!Tools.InstVarInspector categoriesFor: #object!accessing!public! !
!Tools.InstVarInspector categoriesFor: #onAspectSelected!event handling!private! !
!Tools.InstVarInspector categoriesFor: #onValueChanged!accessing!public! !
!Tools.InstVarInspector categoriesFor: #queryCommand:!commands!private! !
!Tools.InstVarInspector categoriesFor: #refresh!commands!public!updating! !
!Tools.InstVarInspector categoriesFor: #selectAspect:!event handling!private! !
!Tools.InstVarInspector categoriesFor: #setAspectValue:!accessing!private! !
!Tools.InstVarInspector categoriesFor: #unableToDisplayVariableErrorFormatString!constants!private! !

!Tools.InstVarInspector class methodsFor!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1376774 ##(UI.ProportionalLayout) 138 ##(Core.Dictionary) 34 3 1049094 ##(Core.Association) 410 ##(UI.ListTreeView) 34 59 nil 416 34 2 8 1140953421 1 576 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) 917510 ##(Graphics.Color) #default nil 13 461638 4 ##(UI.Menu) nil true 34 12 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #inspectIt 8 '&Inspect' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 818 1 850 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 818 1 850 #browseIt 8 '&Browse It' 1 1 898 nil true 944 8 'ClassBrowserShell.ico' 992 nil nil 1074 4097 818 1 850 #copyAspect 8 '&Copy' 1 1 nil nil nil 818 1 850 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 1074 4097 818 1 850 #editAspect 8 '&Edit' 1 1 nil nil nil 818 1 850 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 1074 4097 818 1 850 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 576 nil 8 1801282304 786950 ##(Core.Message) #valueText 8 #() nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 3 1117254 5 ##(UI.ListViewColumn) 8 'Instance Variable' 267 #left 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 2 1 1664 8 'doIt' 8 '[:x | x valueNameOnly]' 8 #[30 105 226 0 106] #valueNameOnly 1680 7 257 nil 1506 #<= 8 #() nil nil 576 nil 3 1666 0 nil 1698 2 1 1664 8 'doIt' 8 '[:x | x valueNameInfo ]' 8 #[30 105 226 0 106] #valueNameInfo 1808 7 257 nil nil 1618 8 'Value' 267 #left 1666 0 nil 1698 2 1 1664 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 1920 7 257 nil 1506 #<= 1792 nil nil 576 1666 0 nil 1698 2 1 1664 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 2016 7 257 nil 3 nil nil 1618 8 '' 41 #center 1506 #displayString 8 #() 1506 #<= 2144 nil nil 576 1666 0 nil 1698 3 1 1664 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Tools.PropertyInspector) #editButtonImageIndexFor: 2176 7 257 nil 1 nil nil #report 8 #() nil 133479 918022 ##(Graphics.Point) 129 129 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil false 1247046 3 ##(UI.VirtualTreeModel) nil 720 138 144 688 nil nil 1666 0 nil 1377574 ##(Kernel.CompiledMethod) 2 3 2304 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 2320 1666 0 nil 2370 1 83886083 2304 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 2416 7 257 nil nil 138 ##(Core.PluggableSet) 688 138 ##(Core.IdentitySet) 688 13 5 nil nil nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 3 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 2274 1 1 2274 581 591 576 2562 #contextMenu: 34 1 784 576 2562 #text: 34 1 8 'Instance Variable' 576 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 34 1 0 0 39 1 0 0] 8 #() 2274 193 193 nil 2029 5 546 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2816 nil nil nil 5 nil nil nil 2816 1376838 1 ##(UI.ResourceIdentifier) ##(Tools.SmalltalkWorkspace) #resource_Default_view nil 2498 138 144 34 1 2562 #createAt:extent: 34 2 2274 591 1 2274 291 591 2816 2722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 39 1 0 0 0 0 0 0 184 1 0 0 39 1 0 0] 688 2784 nil 27 3 546 410 ##(UI.Splitter) 34 12 nil 416 34 2 8 1140850688 1 3072 nil nil nil 517 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 3072 nil 1 #left nil nil nil 2274 1 1 2274 9 9 nil 3168 nil 2498 138 144 34 1 2562 #createAt:extent: 34 2 2274 581 1 2274 11 591 3072 2722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 34 1 0 0 0 0 0 0 39 1 0 0 39 1 0 0] 8 #() 2784 nil 27 1 false 170 192 34 4 576 8 'aspects' 2816 8 'source' nil 2498 138 144 34 1 2562 #createAt:extent: 34 2 2274 6143 21 2274 881 591 416 2722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 183 13 0 0 49 1 0 0] 34 3 576 3072 2816 2784 nil 27 )! !
!Tools.InstVarInspector class categoriesFor: #initialize!initializing!private! !
!Tools.InstVarInspector class categoriesFor: #resource_Default_view!public!resources-views! !

