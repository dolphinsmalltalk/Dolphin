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
	"Private - Open a new Inspector on the selected key."

	variableNamesPresenter hasSelection
		ifTrue: [self variableName inspect]
!

queryCommand: query
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery>,  query."

	| cmd |
	cmd := query commandSymbol.

	#removeField == cmd ifTrue: [
		query isEnabled: self hasKeySelection.
		^true].

	^super queryCommand: query.
!

removeField
	"Remove the selected key in the variablesModel from the receiver's object."

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
addField!commands!public! !
addKey:put:!operations!private! !
getField:!accessing!private! !
getFieldList!accessing!public! !
hasKeySelection!private!testing! !
inspectKey!commands!private! !
queryCommand:!commands!private! !
removeField!commands!public! !
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 294 #{Core.Dictionary} 2 518 #{Core.Association} 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140969549 1025 208 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 2886 4 #{UI.Menu} nil true 50 10 402 nil true 50 3 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #inspectIt 8 '&Value' 1 1 nil nil nil 482 1 514 #inspectKey 8 '&Key' 1 1 nil nil nil 482 1 514 #inspectReferences 8 '&References' 1 1 nil nil nil 8 '&Inspect' nil 134217729 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil nil nil 326 1 #{UI.DividerMenuItem} 4097 482 1 514 #browseHierarchy 8 '&Browse Class' 1 1 674 nil true 706 8 'ClassBrowserShell.ico' 768 65541 nil nil nil 802 4097 482 1 514 #nilVariable 8 'Set to &Nil' 1 1 nil nil nil 802 4097 482 1 514 #addField 8 '&Add…' 1 1 nil nil nil 482 1 514 #removeField 8 'Re&move…' 1 1 nil nil nil 802 4097 482 1 514 #refreshVariables 8 'Re&fresh' 1 1 nil nil nil 8 '&Inspect' nil 134217729 nil nil nil nil nil nil nil 208 nil 8 1853243664 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 306 1 3142 5 #{UI.ListViewColumn} 8 '' 337 #left nil 1202 #<= 8 #() nil nil 208 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1 1 1490 345 501 208 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 172 0 0 0 250 0 0 0] 8 #() 1490 193 193 nil 35 3 178 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 1632 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 1632 nil 1 #left nil nil nil 1490 1 1 1490 9 9 nil 1728 nil 1394 50 1 1442 #createAt:extent: 50 2 1490 345 1 1490 11 501 1632 1538 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 172 0 0 0 0 0 0 0 177 0 0 0 250 0 0 0] 8 #() 1600 nil 27 1 false 550 #{Core.IdentityDictionary} 2 208 8 'variablenames' 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140916224 131073 1952 nil nil nil 21 nil nil nil 1952 582 1 #{UI.ResourceIdentifier} #{Tools.SmalltalkWorkspace} #resource_Default_view nil 1394 50 1 1442 #createAt:extent: 50 2 1490 355 1 1490 347 501 1952 1538 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 177 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 1600 nil 27 8 'source' nil 1394 50 1 1442 #createAt:extent: 50 2 1490 6143 21 1490 701 501 32 1538 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 4 1 0 0] 50 3 208 1632 1952 1600 nil 27)! !
!Tools.DictionaryInspector class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

