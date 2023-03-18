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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1376774 #{UI.ProportionalLayout} 138 #{Core.Dictionary} 34 2 1049094 #{Core.Association} 410 #{UI.ListView} 34 45 nil 416 34 2 8 1140969549 1025 576 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 5 461638 4 #{UI.Menu} nil true 34 10 770 nil true 34 3 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #inspectIt 8 '&Value' 1 1 nil nil nil 850 1 882 #inspectKey 8 '&Key' 1 1 nil nil nil 850 1 882 #inspectReferences 8 '&References' 1 1 nil nil nil 8 '&Inspect' nil 134217729 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 850 1 882 #browseHierarchy 8 '&Browse Class' 1 1 1042 nil true 1074 8 'ClassBrowserShell.ico' 1136 65541 nil nil nil 1170 4097 850 1 882 #nilVariable 8 'Set to &Nil' 1 1 nil nil nil 1170 4097 850 1 882 #addField 8 '&Add…' 1 1 nil nil nil 850 1 882 #removeField 8 'Re&move…' 1 1 nil nil nil 1170 4097 850 1 882 #refreshVariables 8 'Re&fresh' 1 1 nil nil nil 8 '&Inspect' nil 134217729 nil nil nil nil nil nil nil 576 nil 8 1815049392 786950 #{Core.Message} #displayString 688 nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 '' 337 #left nil 1570 #<= 8 #() nil nil 576 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 1 1858 345 501 576 1810 #contextMenu: 34 1 784 576 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 172 0 0 0 250 0 0 0] 8 #() 1858 193 193 nil 35 3 546 410 #{UI.Splitter} 34 12 nil 416 34 2 8 1140850688 1 2032 nil nil nil 517 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 2032 nil 1 #left nil nil nil 1858 1 1 1858 9 9 nil 2128 nil 1762 34 1 1810 #createAt:extent: 34 2 1858 345 1 1858 11 501 2032 1938 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 172 0 0 0 0 0 0 0 177 0 0 0 250 0 0 0] 8 #() 2000 nil 27 1 false 170 192 34 4 576 8 'variablenames' 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140916224 131073 2352 nil nil nil 21 nil nil nil 2352 1376838 1 #{UI.ResourceIdentifier} #{Tools.SmalltalkWorkspace} #resource_Default_view nil 1762 34 1 1810 #createAt:extent: 34 2 1858 355 1 1858 347 501 2352 1938 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 177 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 688 2000 nil 27 8 'source' nil 1762 34 1 1810 #createAt:extent: 34 2 1858 12287 21 1858 701 501 416 1938 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 93 25 0 0 4 1 0 0] 34 3 576 2032 2352 2000 nil 27)! !
!Tools.DictionaryInspector class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

