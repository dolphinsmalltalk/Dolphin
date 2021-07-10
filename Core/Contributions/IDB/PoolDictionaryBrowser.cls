"Filed out from Dolphin Smalltalk X6"!

IdbToolShell subclass: #PoolDictionaryBrowser
	instanceVariableNames: 'poolList itemList'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PoolDictionaryBrowser guid: (GUID fromString: '{1342151B-5F66-4633-8FBD-8EDDE20641CD}')!
PoolDictionaryBrowser comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!PoolDictionaryBrowser categoriesForClass!Development!IDB Goodies! !
!PoolDictionaryBrowser methodsFor!

about
	"Display the about view"

	self 
		idbAbout: '
Pool Dictionary Browser
for
Dolphin Smalltalk 6.x

Version 6a
© 2005 Ian Bartholomew
http://www.idb.me.uk'!

addItem: anAssociation 
	(poolList selection)
		add: anAssociation;
		isChanged: true.
	self updateItemList.
	itemList selection: (itemList list detect: [:each | each = anAssociation]).
	self updatePoolListSelection!

canDelete
	^MessageBox 
		confirm: 'Completely delete the PoolConstantsDictionary named ' , poolList selection name 
				, '
Are you sure?'
		caption: 'Delete PoolConstantsDictionary'!

canDeleteIfReferenced
	(self environment allClasses select: [:class | class sharedPools includes: poolList selection]) 
		notEmpty 
			ifTrue: 
				[^MessageBox confirm: 'There are classes that still include ' , poolList selection name 
							, ' as a Pool.
Continue and delete the PoolConstantsDictionary?'
					caption: 'PoolConstantsDictionary still in use'].
	^true!

canOverwrite: aString 
	(self environment includesKey: aString) 
		ifTrue: 
			[^MessageBox confirm: 'A PoolConstantsDictionary named ' , aString 
						, ' already exists. 
Do you want to overwrite it?'
				caption: 'Duplicate PoolConstantsDictionary'].
	^true!

canRenameIfReferenced
	| references |
	(references := self environment allClasses 
				select: [:class | class sharedPools includes: poolList selection]) notEmpty 
		ifTrue: 
			[| stream |
			stream := String writeStream.
			stream
				nextPutAll: 'The PoolConstantsDictionary ';
				nextPutAll: poolList selection name;
				nextPutAll: ' is included in the following class definition(s)';
				cr;
				nextPutAll: 'After renaming these classes (and any subclasses) may not compile unless the Pool reference is updated.';
				cr;
				nextPutAll: 'Are you sure you want to rename this PoolConstantsDictionary?';
				cr;
				cr.
			references do: 
					[:each | 
					stream
						nextPutAll: each name;
						space;
						space].
			^MessageBox confirm: stream contents caption: 'PoolConstantsDictionary Rename'].
	^true!

createComponents
	super createComponents.
	poolList := self add: ListPresenter new name: 'poolList'.
	itemList := self add: ListPresenter new name: 'itemList'!

createSchematicWiring
	super createSchematicWiring.
	poolList 
		when: #selectionChanged
		send: #onPoolSelectionChanged
		to: self.
	itemList 
		when: #actionPerformed
		send: #editItem
		to: self!

deleteItem
	| index |
	(poolList selection)
		removeKey: itemList selection key;
		isChanged: true.
	index := itemList selectionByIndex.
	self updateItemList.
	itemList selectionByIndex: (index min: itemList list size) ifAbsent: [].
	self updatePoolListSelection!

deletePool
	| index |
	self canDelete ifFalse: [^self].
	self canDeleteIfReferenced ifFalse: [^self].
	index := poolList selectionByIndex.
	self environment removeKey: poolList selection name.
	self updatePoolList.
	poolList selectionByIndex: (index min: poolList list size) ifAbsent: []!

editItem
	(PoolItemDialog showModalOn: itemList selection) 
		ifNotNil: 
			[:arg | 
			itemList selection = arg ifTrue: [^self].
			itemList selection key = arg key ifFalse: [poolList selection removeKey: itemList selection key].
			self addItem: arg]!

environment
	^Smalltalk!

fileInPool
	| filename difference |
	filename := (FileOpenDialog new)
				caption: 'File In PoolConstantsDictionary ';
				fileTypes: (Array with: #('Smalltalk Files (*.st)' '*.st') with: FileDialog allFilesType);
				defaultExtension: 'st';
				showModal.
	filename ifNil: [^self].
	SourceManager default fileIn: filename.	"Hmmm, think about this next bit"
	difference := SmalltalkSystem current availablePools difference: poolList list.
	(difference detect: [:each | each class == PoolConstantsDictionary] ifNone: []) 
		ifNotNil: 
			[:arg | 
			self updatePoolList.
			poolList selection: arg]!

fileOutPool
	| filename |
	filename := (FileSaveDialog new)
				caption: 'File Out PoolConstantsDictionary ' , poolList selection name;
				fileTypes: (Array with: #('Smalltalk Files (*.st)' '*.st') with: FileDialog allFilesType);
				defaultExtension: 'st';
				value: poolList selection fileOutName;
				showModal.
	filename ifNil: [^self].
	SourceManager default fileOut: poolList selection to: filename.
	self updatePoolListSelection!

findItemKey
	| title target lowercaseTarget found stream pools |
	title := 'Find Item Key'.
	target := Prompter prompt: 'Enter the required key text (case ignored)' caption: title.
	target ifNil: [^self].
	lowercaseTarget := target asLowercase.
	found := OrderedCollection new.
	poolList list do: 
			[:eachPool | 
			(eachPool keys 
				select: [:eachKey | (eachKey asLowercase indexOfSubCollection: lowercaseTarget) ~= 0]) 
					do: [:eachKey | found add: eachPool -> eachKey]].
	found isEmpty 
		ifTrue: 
			[(MessageBox new)
				text: target , ' has no matching keys';
				caption: title;
				iconStyle: #prompt;
				buttonStyle: #ok;
				open.
			^self].
	pools := (found collect: [:each | each key name]) asSet asSortedCollection.
	stream := String writeStream.
	stream
		nextPutAll: 'The following pools contained keys whichec matched ';
		nextPutAll: target;
		cr;
		cr.
	pools do: 
			[:each | 
			stream
				nextPutAll: each;
				space].
	stream
		cr;
		cr.
	(found 
		asSortedCollection: [:a :b | a key = b key ifTrue: [a value < b value] ifFalse: [a key name < b key name]]) 
			keysAndValuesDo: 
				[:index :each | 
				index < 26 
					ifTrue: 
						[stream
							nextPutAll: each key name;
							nextPutAll: ' .... ';
							nextPutAll: each value;
							nextPutAll: ' .... ';
							print: (each key at: each value);
							cr]
					ifFalse: 
						[index = 26 
							ifTrue: 
								[stream
									nextPutAll: '(and ';
									print: found size - 25;
									nextPutAll: ' more)';
									cr]]].
	(MessageBox new)
		text: stream contents;
		caption: title;
		iconStyle: #prompt;
		buttonStyle: #ok;
		open!

getNewPoolName
	"Answers a name or nil"

	^self validatePoolName: (Prompter prompt: 'Name of new PoolConstantsDictionary'
				caption: 'Add PoolConstantsDictionary')!

getRenamePoolName
	"Answers the name or nil "

	^self validatePoolName: (Prompter 
				prompt: 'New name for the PoolConstantsDictionary ' , poolList selection name
				caption: 'Rename PoolConstantsDictionary')!

newItem
	PoolItemDialog showModal ifNotNil: [:arg | self addItem: arg]!

newPool
	| poolName newPool |
	(poolName := self getNewPoolName) ifNil: [^self].
	(self canOverwrite: poolName) ifFalse: [^self].
	self environment at: poolName put: (newPool := PoolConstantsDictionary named: poolName).
	self updatePoolList.
	poolList selection: newPool!

onPoolSelectionChanged
	poolList hasSelection ifTrue: [self updateItemList] ifFalse: [itemList list: OrderedCollection new]!

onViewOpened
	super onViewOpened.
	self updatePoolList.
	[self validatePools] postToInputQueue!

packagePool
	| currentPackage newPackage |
	currentPackage := poolList selection owningPackage.
	newPackage := PackagePrompter 
				showModalOn: currentPackage asValue
				caption: 'Package of ' , poolList selection name
				default: currentPackage.
	(newPackage isNil or: [newPackage = currentPackage]) ifTrue: [^self].
	poolList selection owningPackage: newPackage.
	self updatePoolListSelection!

queryCommand: aCommandQuery 
	(#(#deletePool #packagePool #newItem #refreshItems #referencesToPool #renamePool) 
		identityIncludes: aCommandQuery command) 
			ifTrue: 
				[aCommandQuery isEnabled: poolList hasSelection.
				^true].
	(#(#deleteItem #editItem #referencesToItem) identityIncludes: aCommandQuery command) 
		ifTrue: 
			[aCommandQuery isEnabled: itemList hasSelection.
			^true].
	aCommandQuery command == #fileOutPool 
		ifTrue: 
			[aCommandQuery isEnabled: (poolList hasSelection and: [poolList selection canFileOut]).
			^true].
	^super queryCommand: aCommandQuery!

referencesToItem
	| references target title |
	references := OrderedCollection new.
	target := itemList selection key.
	(self environment allClasses select: [:class | class allSharedPools includes: poolList selection]) 
		do: 
			[:class | 
			class methodDictionary 
				do: [:method | (method containsSource: target) ifTrue: [references add: method]].
			class class methodDictionary 
				do: [:method | (method containsSource: target) ifTrue: [references add: method]]].
	title := 'References to ' , target , ' in ' , poolList selection name.
	references isEmpty 
		ifTrue: 
			[(MessageBox new)
				text: target , ' has no references';
				caption: title;
				iconStyle: #prompt;
				buttonStyle: #ok;
				open.
			^self].
	SmalltalkSystem current 
		browseMethods: references
		caption: title
		findString: target
		filter: [:m | false]!

referencesToPool
	| references stream |
	stream := String writeStream.
	(references := self environment allClasses 
				select: [:class | class sharedPools includes: poolList selection]) isEmpty 
		ifTrue: 
			[stream nextPutAll: 'The PoolConstantsDictionary ' , poolList selection name , ' has no references']
		ifFalse: 
			[stream
				nextPutAll: 'The PoolConstantsDictionary ';
				nextPutAll: poolList selection name;
				nextPutAll: ' is included in the following class definition(s) and is also available in any subclasses';
				cr;
				cr.
			(references asSortedCollection: [:a :b | a name < b name]) do: 
					[:each | 
					stream
						nextPutAll: each name;
						space;
						space]].
	(MessageBox new)
		text: stream contents;
		caption: 'PoolConstantsDictionary References';
		iconStyle: #prompt;
		buttonStyle: #ok;
		open!

refreshItems
	self updateItemList.
	itemList selectionOrNil: nil!

refreshPools
	self updatePoolList.
	poolList selectionOrNil: nil!

renamePool
	| poolName newPool |
	self canRenameIfReferenced ifFalse: [^self].
	(poolName := self getRenamePoolName) ifNil: [^self].
	(self canOverwrite: poolName) ifFalse: [^self].
	self environment at: poolName put: (newPool := PoolConstantsDictionary named: poolName).
	poolList selection keysAndValuesDo: [:key :value | newPool at: key put: value].
	poolList selection owningPackage ifNotNil: [:arg | newPool owningPackage: arg].
	self environment removeKey: poolList selection name.
	self updatePoolList.
	poolList selection: newPool!

updateItemList
	itemList list: (poolList selection associations asSortedCollection: [:a :b | a key < b key])!

updatePoolList
	poolList 
		list: (SmalltalkSystem current availablePools asSortedCollection: [:a :b | a name < b name])!

updatePoolListSelection
	poolList model refreshAtIndex: poolList selectionByIndex!

validatePoolName: aStringOrNil 
	(aStringOrNil isNil or: [aStringOrNil isEmpty]) ifTrue: [^nil].
	aStringOrNil first isLetter 
		ifFalse: 
			[(MessageBox new)
				text: 'Pool name should start with an uppercase letter';
				caption: 'PoolConstantsDictionary Name';
				iconStyle: #prompt;
				buttonStyle: #ok;
				open.
			^nil].
	aStringOrNil first isUppercase 
		ifFalse: 
			[(MessageBox 
				confirm: 'Pool name should start with an uppercase letter.
Change new pool name to ' 
						, aStringOrNil capitalized , ' ?'
				caption: 'PoolConstantsDictionary Name') ifTrue: [^aStringOrNil capitalized]].
	^aStringOrNil!

validatePools
	poolList list do: 
			[:each | 
			((self environment includesKey: each name) and: [(self environment at: each name) == each]) 
				ifFalse: 
					[| stream reply |
					stream := String writeStream.
					stream
						nextPutAll: 'The PoolConstantsDictionary with the global name of ';
						nextPutAll: (self environment keyAtValue: each);
						nextPutAll: ' has the internal name ';
						nextPutAll: each name;
						cr;
						nextPutAll: 'Do you want to change the internal name to match the global name (recommended)'.
					reply := ((MessageBox new)
								text: stream contents;
								caption: 'PoolConstantsDictionary Name Mismatch';
								iconStyle: #warning;
								buttonStyle: #yesNo;
								open) == #yes.
					reply 
						ifTrue: 
							[each name: (self environment keyAtValue: each).
							self updatePoolList]]]! !
!PoolDictionaryBrowser categoriesFor: #about!commands!public! !
!PoolDictionaryBrowser categoriesFor: #addItem:!items!operations!public! !
!PoolDictionaryBrowser categoriesFor: #canDelete!public!testing! !
!PoolDictionaryBrowser categoriesFor: #canDeleteIfReferenced!public!testing! !
!PoolDictionaryBrowser categoriesFor: #canOverwrite:!public!testing! !
!PoolDictionaryBrowser categoriesFor: #canRenameIfReferenced!public!testing! !
!PoolDictionaryBrowser categoriesFor: #createComponents!initializing!public! !
!PoolDictionaryBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!PoolDictionaryBrowser categoriesFor: #deleteItem!commands!items!public! !
!PoolDictionaryBrowser categoriesFor: #deletePool!commands!pools!public! !
!PoolDictionaryBrowser categoriesFor: #editItem!commands!items!public! !
!PoolDictionaryBrowser categoriesFor: #environment!constants!public! !
!PoolDictionaryBrowser categoriesFor: #fileInPool!commands!pools!public! !
!PoolDictionaryBrowser categoriesFor: #fileOutPool!commands!pools!public! !
!PoolDictionaryBrowser categoriesFor: #findItemKey!commands!public! !
!PoolDictionaryBrowser categoriesFor: #getNewPoolName!commands!pools!public! !
!PoolDictionaryBrowser categoriesFor: #getRenamePoolName!commands!pools!public! !
!PoolDictionaryBrowser categoriesFor: #newItem!commands!items!public! !
!PoolDictionaryBrowser categoriesFor: #newPool!commands!pools!public! !
!PoolDictionaryBrowser categoriesFor: #onPoolSelectionChanged!event handling!public! !
!PoolDictionaryBrowser categoriesFor: #onViewOpened!event handling!public! !
!PoolDictionaryBrowser categoriesFor: #packagePool!commands!pools!public! !
!PoolDictionaryBrowser categoriesFor: #queryCommand:!commands!public! !
!PoolDictionaryBrowser categoriesFor: #referencesToItem!commands!items!public! !
!PoolDictionaryBrowser categoriesFor: #referencesToPool!commands!pools!public! !
!PoolDictionaryBrowser categoriesFor: #refreshItems!commands!items!public! !
!PoolDictionaryBrowser categoriesFor: #refreshPools!commands!items!public! !
!PoolDictionaryBrowser categoriesFor: #renamePool!commands!pools!public! !
!PoolDictionaryBrowser categoriesFor: #updateItemList!helpers!items!public! !
!PoolDictionaryBrowser categoriesFor: #updatePoolList!helpers!pools!public! !
!PoolDictionaryBrowser categoriesFor: #updatePoolListSelection!helpers!pools!public! !
!PoolDictionaryBrowser categoriesFor: #validatePoolName:!commands!operations!pools!public! !
!PoolDictionaryBrowser categoriesFor: #validatePools!helpers!operations!pools!public! !

!PoolDictionaryBrowser class methodsFor!

displayOn: aStream 
	aStream nextPutAll: 'PoolDictionary Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) instanceClass defaultIcon!

initializeAfterLoad
	(Smalltalk developmentSystem)
		addAdditionalToolsFolderIcon: self toolsFolderIcon;
		registerTool: self.
	super initializeAfterLoad!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 196934 1 ##(Smalltalk.RGB)  25264513 328198 ##(Smalltalk.Point)  1201 801 519 0 0 0 416 852230 ##(Smalltalk.FramingLayout)  234 240 98 4 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140920397 1025 608 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.SearchPolicy)  8 #identity 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 5 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #newPool 8 '&New...' 1 1 0 0 0 914 1 946 8 #packagePool 8 '&Package...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 914 1 946 8 #renamePool 8 'Rena&me' 1 1 0 0 0 914 1 946 8 #deletePool 8 '&Delete' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 608 0 8 4294904165 8 ##(Smalltalk.BasicListAbstract)  787814 3 ##(Smalltalk.BlockClosure)  0 459302 ##(Smalltalk.Context)  1 1 0 0 1180966 ##(Smalltalk.CompiledExpression)  6 9 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 98 2 8 '[:o | (o isChanged ifTrue: [Package changedIcon] ifFalse: [Icon blank]) imageIndex]' 98 1 202 8 ##(Smalltalk.PoolDictionary)  736 8 #[252 1 0 1 1 14 0 17 229 32 158 221 4 46 160 219 2 48 162 163 106 105] 8 #isChanged 721414 ##(Smalltalk.Association)  8 #Package 8 ##(Smalltalk.Package)  8 #changedIcon 1522 8 #Icon 8 ##(Smalltalk.Icon)  8 #blank 8 #imageIndex 17 257 0 762 8 ##(Smalltalk.IconImageManager)  8 #current 0 0 0 0 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn)  8 'Pool Dictionary' 351 8 #left 1264 1282 0 1314 2 1 0 0 0 1346 1 13 1376 8 'doIt' 98 2 8 '[:a :b | a name <= b name]' 98 1 202 1472 736 8 #[252 2 0 1 1 12 0 17 18 230 33 229 32 158 228 33 158 130 106 105] 8 #name 17 513 0 0 0 608 0 3 0 0 1762 8 'Package' 227 1808 1264 1282 0 1314 2 1 0 0 0 1346 1 13 1376 8 'doIt' 98 2 8 '[:a :b | a name <= b name]' 98 1 202 1472 736 8 #[252 2 0 1 1 12 0 17 18 230 33 229 32 158 228 33 158 130 106 105] 1968 17 513 0 459270 ##(Smalltalk.Message)  8 #owningPackage 98 0 0 608 0 1 0 0 8 #report 736 0 131169 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 514 9 9 514 585 677 608 2306 8 #contextMenu: 98 1 880 608 2306 8 #text: 98 1 8 'Pool Dictionary' 608 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 40 1 0 0 86 1 0 0] 98 0 514 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  762 8 ##(Smalltalk.FramingCalculation)  8 #fixedParentLeft 9 762 2640 8 #relativeParentWidth 327734 ##(Smalltalk.Float)  8 0 0 0 0 0 0 224 63 762 2640 8 #fixedParentTop 9 762 2640 8 #fixedParentBottom -7 410 624 98 30 0 416 98 2 8 1140920397 1025 2800 690 202 208 736 0 768 818 848 0 7 866 0 16 98 4 914 1 946 8 #newItem 8 '&New...' 1 1 0 0 0 914 1 946 8 #editItem 8 '&Edit' 1 1 0 0 0 1074 4097 914 1 946 8 #deleteItem 8 '&Delete' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 2800 0 8 4294904165 1264 0 1680 0 0 0 0 0 0 202 208 98 2 1762 8 'Key' 369 1808 1264 8 ##(Smalltalk.SortedCollection)  2162 8 #key 98 0 0 2800 0 3 0 0 1762 8 'Value' 201 1808 2162 8 #printString 98 0 1282 0 1314 2 1 0 0 0 1346 2 13 1376 8 'doIt' 98 2 8 '[:a :b |
	a notNil & b notNil & (a class = b class)
		ifTrue: [a < b]
		ifFalse: [a class name < b class name]]' 98 1 202 1472 736 8 #[252 2 0 1 1 37 0 17 18 230 33 229 32 157 228 33 157 176 228 32 144 228 33 144 132 176 221 6 228 32 228 33 128 106 228 32 144 159 228 33 144 159 128 106 105] 8 #& 1968 17 513 0 2162 8 #value 3296 0 2800 0 1 0 0 2224 736 0 131169 0 0 2242 202 208 98 3 2306 2336 98 2 514 601 9 514 577 677 2800 2306 2416 98 1 2912 2800 2306 2464 98 1 8 'Key' 2800 2514 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 44 1 0 0 4 0 0 0 76 2 0 0 86 1 0 0] 98 0 2576 0 27 2594 762 2640 8 #fixedPreviousRight 9 762 2640 8 #fixedParentRight -7 2736 9 2768 -7 234 256 98 4 608 8 'poolList' 2800 8 'itemList' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 4 866 0 16 98 4 914 1 946 8 #fileInPool 8 'File &In Pool' 1 1 0 0 0 914 1 946 8 #fileOutPool 8 'File &Out Pool' 1 1 0 0 0 1074 4097 914 1 946 8 #exit 8 'Close' 17639 1 0 0 0 8 '&File' 0 1 0 0 21889 0 0 866 0 16 98 8 914 1 946 976 8 '&New...' 1 1 0 0 0 914 1 946 1040 8 '&Package...' 1 1 0 0 0 1074 4097 914 1 946 1136 8 'Rena&me' 1 1 0 0 0 914 1 946 1200 8 '&Delete' 1 1 0 0 0 1074 4097 914 1 946 8 #referencesToPool 8 '&References' 1 1 0 0 0 914 1 946 8 #refreshPools 8 'Re&fresh List' 1 1 0 0 0 8 '&Pool' 0 1 0 0 21903 0 0 866 0 16 98 8 914 1 946 2976 8 '&New...' 1 1 0 0 0 914 1 946 3040 8 '&Edit' 1 1 0 0 0 1074 4097 914 1 946 3120 8 '&Delete' 1 1 0 0 0 1074 4097 914 1 946 8 #findItemKey 8 '&Find key' 1 1 0 0 0 914 1 946 8 #referencesToItem 8 '&References' 1 1 0 0 0 914 1 946 8 #refreshItems 8 'Refresh &List' 1 1 0 0 0 8 '&Item' 0 1 0 0 21917 0 0 866 0 16 98 19 914 1 946 8 #helpContents 8 '&Contents' 1025 1 1634 0 16 762 8 ##(Smalltalk.ImageRelativeFileLocator)  1712 49 762 8 ##(Smalltalk.ShellLibrary)  8 #default 0 0 914 1 946 8 #help 8 'On this &Tool' 1249 1 0 0 0 914 1 946 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 1074 4097 914 1 946 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 1074 4097 914 1 946 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 914 1 946 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 914 1 946 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 866 0 16 98 4 914 2097153 946 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 1634 0 16 5200 8 'TipOfTheDay.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 914 1 946 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 1634 0 16 5200 8 'TipOfTheDay.ico' 5840 0 0 1074 4097 914 1 946 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 0 0 0 1074 4097 914 1 946 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 914 1 946 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 914 1 946 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 914 1 946 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 1074 4097 914 1 946 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 1634 0 16 5200 8 'LiveUpdate.ico' 5840 0 0 1074 4097 914 1 946 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 1634 0 16 5200 8 '!!APPLICATION' 5840 0 0 8 '&Help' 0 134217729 0 0 0 0 0 8 '' 0 1 0 0 0 0 0 0 1049350 ##(Smalltalk.AcceleratorTable)  0 16 98 6 1522 17639 4208 1522 1025 946 5152 8 '&Contents' 1025 1 1634 0 16 5200 49 5232 1522 1249 946 5312 8 'On this &Tool' 1249 1 0 1522 5345 946 5376 8 'What''s This?' 5345 1 0 1522 9441 946 5760 8 '&Next Tip of the Day' 9441 1 1634 0 16 5200 8 'TipOfTheDay.ico' 5840 1522 13537 946 5904 8 '&Previous Tip of the Day' 13537 1 1634 0 16 5200 8 'TipOfTheDay.ico' 5840 0 1 0 0 0 0 1 0 0 2242 202 208 98 3 2306 2336 98 2 514 6399 21 514 1201 801 416 2306 2464 98 1 8 'PoolDictionary Browser' 416 2306 8 #menuBar: 98 1 3984 416 2514 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 12 0 0 10 0 0 0 215 14 0 0 154 1 0 0] 98 2 608 2800 2576 0 27 )!

uninitializeBeforeRemove
	(Smalltalk developmentSystem)
		removeSystemFolderIcon: self toolsFolderIcon;
		unregisterTool: self.
	super uninitializeBeforeRemove! !
!PoolDictionaryBrowser class categoriesFor: #displayOn:!accessing!public! !
!PoolDictionaryBrowser class categoriesFor: #icon!constants!public! !
!PoolDictionaryBrowser class categoriesFor: #initializeAfterLoad!initializing!public! !
!PoolDictionaryBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!PoolDictionaryBrowser class categoriesFor: #uninitializeBeforeRemove!public!uninitializing! !

