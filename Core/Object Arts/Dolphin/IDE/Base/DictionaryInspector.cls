"Filed out from Dolphin Smalltalk"!

BasicInspector subclass: #DictionaryInspector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DictionaryInspector guid: (GUID fromString: '{87b4c694-026e-11d3-9fd7-00a0cc3e4a32}')!

DictionaryInspector comment: 'DictionaryInspector is a <compositePresenter> that implements a specialised inspect facility onto a <Dictionary>. This provides additional functionality to inspect the dictionary via its keys and also to allow the user to add new keys and values.'!

!DictionaryInspector categoriesForClass!MVP-Presenters! !

!DictionaryInspector methodsFor!

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

!DictionaryInspector categoriesForMethods!
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

!DictionaryInspector class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 2 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 576 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 576 nil 1 #left nil nil nil 328198 ##(Smalltalk.Point) 1 1 674 9 9 nil 688 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[172 0 0 0 0 0 0 0 177 0 0 0 250 0 0 0] 193 608 8 '' 576 3 8 #() 674 193 193 nil 27 1 546 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140969549 1025 976 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 10 1170 nil true 34 3 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Value' 1 1 nil nil nil 1250 1 1282 #inspectKey 8 '&Key' 1 1 nil nil nil 1250 1 1282 #inspectReferences 8 '&References' 1 1 nil nil nil 8 '&Inspect' nil 134217729 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1250 1 1282 #browseHierarchy 8 '&Browse Class' 1 1 1442 nil true 1488 8 'ClassBrowserShell.ico' 1536 nil nil 1570 4097 1250 1 1282 #nilVariable 8 'Set to &Nil' 1 1 nil nil nil 1570 4097 1250 1 1282 #addField 8 '&Add...' 1 1 nil nil nil 1250 1 1282 #removeField 8 'Re&move...' 1 1 nil nil nil 1570 4097 1250 1 1282 #refreshVariables 8 'Re&fresh' 1 1 nil nil nil 8 '&Inspect' nil 134217729 nil nil nil nil nil nil nil 976 nil 8 1759068368 ##(Smalltalk.BasicListAbstract) nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 337 #left nil 459270 ##(Smalltalk.Message) #<= 8 #() nil nil 976 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 722 138 144 34 2 786 #createWindow: 34 1 834 866 8 #[0 0 0 0 0 0 0 0 172 0 0 0 250 0 0 0] 193 1008 8 '' 976 786 #contextMenu: 34 1 1184 976 3 8 #() 674 193 193 nil 35 3 false 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140916224 131073 2368 nil nil nil 21 nil nil nil 2368 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 722 138 144 34 1 786 #createWindow: 34 1 834 866 8 #[177 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 193 2400 8 '' 2368 3 1088 674 193 193 nil 27 8 'source' 976 8 'variablenames' nil 722 138 144 34 1 786 #createWindow: 34 1 834 866 8 #[191 13 0 0 10 0 0 0 29 15 0 0 4 1 0 0] 193 448 8 '' 416 1 34 3 976 576 2368 674 193 193 nil 27 )! !

!DictionaryInspector class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

