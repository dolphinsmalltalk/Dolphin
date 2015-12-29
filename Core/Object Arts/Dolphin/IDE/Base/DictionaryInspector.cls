"Filed out from Dolphin Smalltalk X6"!

BasicInspector subclass: #DictionaryInspector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DictionaryInspector guid: (GUID fromString: '{87B4C694-026E-11D3-9FD7-00A0CC3E4A32}')!
DictionaryInspector comment: 'DictionaryInspector is a <compositePresenter> that implements a specialised inspect facility onto a <Dictionary>. This provides additional functionality to inspect the dictionary via its keys and also to allow the user to add new keys and values.'!
!DictionaryInspector categoriesForClass!Development!MVP-Presenters! !
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
						for: self selfField
						logged: false.
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
!DictionaryInspector categoriesFor: #addField!commands!public! !
!DictionaryInspector categoriesFor: #addKey:put:!operations!private! !
!DictionaryInspector categoriesFor: #getField:!accessing!private! !
!DictionaryInspector categoriesFor: #getFieldList!accessing!public! !
!DictionaryInspector categoriesFor: #hasKeySelection!private!testing! !
!DictionaryInspector categoriesFor: #inspectKey!commands!private! !
!DictionaryInspector categoriesFor: #queryCommand:!commands!private! !
!DictionaryInspector categoriesFor: #removeField!commands!public! !
!DictionaryInspector categoriesFor: #removeKey:!operations!private! !
!DictionaryInspector categoriesFor: #setField:to:!accessing!private! !

!DictionaryInspector class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  202 8 ##(Smalltalk.Dictionary)  98 2 721414 ##(Smalltalk.Association)  410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140969549 1025 656 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  498 528 0 5 265030 4 ##(Smalltalk.Menu)  0 16 98 10 850 0 16 98 3 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #inspectIt 8 '&Value' 1 1 0 0 0 930 1 962 8 #inspectKey 8 '&Key' 1 1 0 0 0 930 1 962 8 #inspectReferences 8 '&References' 1 1 0 0 0 8 '&Inspect' 0 134217729 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 930 1 962 8 #browseHierarchy 8 '&Browse Class' 1 1 1170 0 16 1216 8 'ClassBrowserShell.ico' 1264 0 0 1298 4097 930 1 962 8 #nilVariable 8 'Set to &Nil' 1 1 0 0 0 1298 4097 930 1 962 8 #addField 8 '&Add...' 1 1 0 0 0 930 1 962 8 #removeField 8 'Re&move...' 1 1 0 0 0 1298 4097 930 1 962 8 #refreshVariables 8 'Re&fresh' 1 1 0 0 0 8 '&Inspect' 0 134217729 0 0 0 0 0 0 0 656 0 8 4294903801 8 ##(Smalltalk.BasicListAbstract)  0 1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 '' 337 8 #left 0 8 ##(Smalltalk.SortedCollection)  0 0 656 0 3 0 0 8 #report 784 0 133185 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 2066 345 501 656 2002 8 #contextMenu: 98 1 864 656 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 172 0 0 0 250 0 0 0] 98 0 2066 193 193 0 27 3 626 410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 2256 0 498 528 0 517 0 0 0 2256 1938 202 208 98 1 2002 2032 98 2 2066 345 1 2066 11 501 2256 2162 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 172 0 0 0 0 0 0 0 177 0 0 0 250 0 0 0] 98 0 2224 0 27 1 32 234 256 98 4 656 8 'variablenames' 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140916224 131073 2560 0 0 0 21 0 0 0 2560 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.SmalltalkWorkspace)  8 #resource_Default_view 0 1938 202 208 98 1 2002 2032 98 2 2066 355 1 2066 347 501 2560 2162 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 177 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 784 2224 0 27 8 'source' 0 1938 202 208 98 1 2002 2032 98 2 2066 2799 21 2066 701 501 416 2162 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 213 6 0 0 4 1 0 0] 98 3 656 2256 2560 2224 0 27 )! !
!DictionaryInspector class categoriesFor: #resource_Default_view!public!resources-views! !

