"Filed out from Dolphin Smalltalk"!

Tools.BasicInspector
	subclass: #'Tools.DictionaryInspector'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.DictionaryInspector guid: (Core.GUID fromString: '{87b4c694-026e-11d3-9fd7-00a0cc3e4a32}')!

Tools.DictionaryInspector comment: 'DictionaryInspector is a <compositePresenter> that implements a specialised inspect facility onto a <Dictionary>. This provides additional functionality to inspect the dictionary via its keys and also to allow the user to add new keys and values.'!

!Tools.DictionaryInspector categoriesForClass!MVP-Presenters! !

!Tools.DictionaryInspector methodsFor!

addField
	"Request a new key to add to the inspected object. If no matching key exists
	in the object add the key with a value of nil, else just hilight the existing
	matching key."

	| newField command |
	command := Command current.
	newField := Prompter prompt: 'Key expression:' caption: 'Add Field'.
	newField notNil
		ifTrue: 
			[| newKey selfField |
			selfField := self selfField.
			newKey := selfField class compilerClass evaluate: newField for: selfField environment: selfField class environment.
			newKey notNil
				ifTrue: 
					[(selfField includesKey: newKey)
						ifFalse: 
							["Add the new key and an undo action to remove the new key on #undo"
							command undoWith: [self removeKey: newKey].
							self addKey: newKey put: nil].
					self variableName: newKey]].
	#todo	"Add compiler notification handling (message box). See Debugger>>returnFromMessage"!

addKey: aKey put: anObject
	"Private - Adds a key to the receiver and refreshes the displayed variables"

	self selfField at: aKey put: anObject.
	self refresh!

getField: anInteger
	"Private - Answer the field of the receiver's object which has the key at index
	anInteger in the field list."

	^self selfField 
		at: (self variableNamesList at: anInteger + self headerSize)!

getFieldList
	"Private - Answer the an OrderedCollection of keys for filling the inspector instance
	variable list. For a Dictionary ordering is not important, but the Inspector
	is much easier to use if we can sort the keys."

	| fields |
	fields := self selfField keys.
	^[fields asSortedCollection] on: Error
		do: 
			[:e | 
			"The keys could not be sorted, so just answer them in arbitrary order"

			fields asOrderedCollection]!

hasKeySelection
	"Private - Answer whether the currently selected variable is a dictionary key of the object."

	^variableNamesPresenter hasSelection and: [self variableIndex > self headerSize]!

inspectKey
	"Open a new Inspector on the selected key."

	<commandQuery: #hasKeySelection>
	self variableName inspect!

removeField
	"Remove the selected key in the variablesModel from the receiver's object."

	<commandQuery: #hasKeySelection>
	| selected value command |
	command := Command current.
	selected := self variableName.
	value := self selfField at: selected.
	self variableIndex > self headerSize
		ifTrue: 
			[(MessageBox new
				headline: 'Remove <1p> field?' << selected;
				confirm)
					ifTrue: 
						[command undoWith: [self addKey: selected put: value].
						self removeKey: selected]]!

removeKey: aKey
	"Private - Removes a key in the receiver and refreshes the displayed variables"

	self selfField removeKey: aKey.
	self refresh!

setField: anInteger to: anObject
	"Private - Determine the field of the receiver's object which has the key at index
	anInteger in the field list, and set its value to anObject."

	^self selfField 
		at: (self variableNamesList at: anInteger + self headerSize)
		put: anObject! !

!Tools.DictionaryInspector categoriesForMethods!
addField!commands-actions!public! !
addKey:put:!operations!private! !
getField:!accessing!private! !
getFieldList!accessing!public! !
hasKeySelection!commands-queries!private!testing! !
inspectKey!commands-actions!public! !
removeField!commands-actions!public! !
removeKey:!operations!private! !
setField:to:!accessing!private! !
!

!Tools.DictionaryInspector class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 2 518 #{Core.Association} 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140969549 1025 224 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 2886 4 #{UI.Menu} nil true 50 10 418 nil true 50 3 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #inspectIt 8 '&Value' 1 1 nil nil nil 498 1 530 #inspectKey 8 '&Key' 1 1 nil nil nil 498 1 530 #inspectReferences 8 '&References' 1 1 nil nil nil 8 '&Inspect' nil 134217729 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil nil nil 326 1 #{UI.DividerMenuItem} 4097 498 1 530 #browseHierarchy 8 '&Browse Class' 1 1 690 nil true 722 8 'ClassBrowserShell.ico' 784 65541 nil nil nil 818 4097 498 1 530 #nilVariable 8 'Set to &Nil' 1 1 nil nil nil 818 4097 498 1 530 #addField 8 '&Add…' 1 1 nil nil nil 498 1 530 #removeField 8 'Re&move…' 1 1 nil nil nil 818 4097 498 1 530 #refreshVariables 8 'Re&fresh' 1 1 nil nil nil 8 '&Inspect' nil 134217729 nil nil nil nil nil nil nil 224 nil nil 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 322 1 3142 5 #{UI.ListViewColumn} 8 '' 337 #left nil 1202 #<= 8 #() nil nil 224 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 224 nil nil nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 172 0 0 0 250 0 0 0] 193 256 8 '' 224 1474 #contextMenu: 50 1 432 224 3 8 #() 518 #{Graphics.Point} 193 193 nil 35 3 194 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 1712 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 1712 nil 1 #left nil nil nil 1666 1 1 1666 9 9 nil 1808 nil 1426 50 1 1474 #createWindow: 50 1 1522 1554 8 #[172 0 0 0 0 0 0 0 177 0 0 0 250 0 0 0] 193 1744 8 '' 1712 3 8 #() 1666 193 193 nil 27 1 false 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140916224 131073 2048 nil nil nil 21 nil nil nil 2048 582 1 #{UI.ResourceIdentifier} #{Tools.SmalltalkWorkspace} #resource_Default_view nil 1426 50 1 1474 #createWindow: 50 1 1522 1554 8 #[177 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 193 2080 8 '' 2048 3 8 #() 1666 193 193 nil 27 8 'source' 224 8 'variablenames' nil 1426 50 1 1474 #createWindow: 50 1 1522 1554 8 #[255 14 0 0 10 0 0 0 93 16 0 0 4 1 0 0] 193 80 8 '' 32 1 50 3 224 1712 2048 1666 193 193 nil 27)! !

!Tools.DictionaryInspector class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

