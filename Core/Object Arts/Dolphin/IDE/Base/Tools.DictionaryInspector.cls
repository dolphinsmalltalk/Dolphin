"Filed out from Dolphin Smalltalk 7"!

Tools.BasicInspector subclass: #'Tools.DictionaryInspector'
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
			[| newKey |
			newKey := self selfField class compilerClass 
						evaluate: newField
						for: self selfField.
			newKey notNil 
				ifTrue: 
					[(self selfField includesKey: newKey) 
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
	"Remove the selected key in the variablesModel from the receivers object."

	| selected value command |
	command := Command current.
	selected := self variableName.
	value := self selfField at: selected.
	self variableIndex > self headerSize
		ifTrue: 
			[(MessageBox confirm: ('Remove <1p> field?' expandMacrosWith: selected))
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
!Tools.DictionaryInspector categoriesFor: #addField!commands!public! !
!Tools.DictionaryInspector categoriesFor: #addKey:put:!operations!private! !
!Tools.DictionaryInspector categoriesFor: #getField:!accessing!private! !
!Tools.DictionaryInspector categoriesFor: #getFieldList!accessing!public! !
!Tools.DictionaryInspector categoriesFor: #hasKeySelection!private!testing! !
!Tools.DictionaryInspector categoriesFor: #inspectKey!commands!private! !
!Tools.DictionaryInspector categoriesFor: #queryCommand:!commands!private! !
!Tools.DictionaryInspector categoriesFor: #removeField!commands!public! !
!Tools.DictionaryInspector categoriesFor: #removeKey:!operations!private! !
!Tools.DictionaryInspector categoriesFor: #setField:to:!accessing!private! !

!Tools.DictionaryInspector class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1376774 ##(UI.ProportionalLayout) 138 ##(Core.Dictionary) 34 2 1049094 ##(Core.Association) 410 ##(UI.Splitter) 34 12 nil 416 34 2 8 1140850688 1 576 nil nil nil 517 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 576 nil 1 #left nil nil nil 918022 ##(Graphics.Point) 1 1 674 9 9 nil 688 nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 674 345 1 674 11 501 576 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 172 0 0 0 0 0 0 0 177 0 0 0 250 0 0 0] 8 #() 674 193 193 nil 27 1 546 410 ##(UI.ListView) 34 45 nil 416 34 2 8 1140969549 1025 960 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) 917510 ##(Graphics.Color) #default nil 5 461638 4 ##(UI.Menu) nil true 34 10 1154 nil true 34 3 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #inspectIt 8 '&Value' 1 1 nil nil nil 1234 1 1266 #inspectKey 8 '&Key' 1 1 nil nil nil 1234 1 1266 #inspectReferences 8 '&References' 1 1 nil nil nil 8 '&Inspect' nil 134217729 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 1234 1 1266 #browseHierarchy 8 '&Browse Class' 1 1 1426 nil true 1472 8 'ClassBrowserShell.ico' 1520 nil nil 1554 4097 1234 1 1266 #nilVariable 8 'Set to &Nil' 1 1 nil nil nil 1554 4097 1234 1 1266 #addField 8 '&Add...' 1 1 nil nil nil 1234 1 1266 #removeField 8 'Re&move...' 1 1 nil nil nil 1554 4097 1234 1 1266 #refreshVariables 8 'Re&fresh' 1 1 nil nil nil 8 '&Inspect' nil 134217729 nil nil nil nil nil nil nil 960 nil 8 1801282304 ##(UI.BasicListAbstract) nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 '' 337 #left nil 786950 ##(Core.Message) #<= 8 #() nil nil 960 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 722 138 144 34 2 786 #createAt:extent: 34 2 674 1 1 674 345 501 960 786 #contextMenu: 34 1 1168 960 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 172 0 0 0 250 0 0 0] 8 #() 928 nil 35 3 false 170 192 34 4 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140916224 131073 2336 nil nil nil 21 nil nil nil 2336 1376838 1 ##(UI.ResourceIdentifier) ##(Tools.SmalltalkWorkspace) #resource_Default_view nil 722 138 144 34 1 786 #createAt:extent: 34 2 674 355 1 674 347 501 2336 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 177 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 1072 928 nil 27 8 'source' 960 8 'variablenames' nil 722 138 144 34 1 786 #createAt:extent: 34 2 674 6143 21 674 701 501 416 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 4 1 0 0] 34 3 960 576 2336 928 nil 27 )! !
!Tools.DictionaryInspector class categoriesFor: #resource_Default_view!public!resources-views! !

