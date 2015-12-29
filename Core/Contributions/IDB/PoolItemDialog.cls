"Filed out from Dolphin Smalltalk X6"!

Dialog subclass: #PoolItemDialog
	instanceVariableNames: 'key value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PoolItemDialog guid: (GUID fromString: '{31F388C5-E843-465B-B15A-50768D135CC1}')!
PoolItemDialog comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!PoolItemDialog categoriesForClass!IDB Goodies!MVP-Presenters! !
!PoolItemDialog methodsFor!

createComponents
	super createComponents.
	key := self add: TextPresenter new name: 'key'.
	value := self add: TextPresenter new name: 'value'!

isValid
	"Answers true if the key field contains a (not empty) String and the 
	value field contains a valid expression"

	| flag |
	(key value isNil or: [key value isEmpty]) ifTrue: [^false].
	
	[Compiler evaluate: value value logged: false.
	flag := true] on: CompilerErrorNotification , Error
			do: 
				[:ex | 
				flag := false.
				ex return: nil].
	^flag!

model: anAssociation 
	"Make sure we are working with two Strings"

	super model: anAssociation key -> anAssociation value printString.
	key model: (self model aspectValue: #key).
	value model: (self model aspectValue: #value)!

ok
	"Compile the value before applying.  We know it will compile correctly 
	because the OK key was enabled (see #isValid)"

	value value: (Compiler evaluate: value value logged: false).
	^super ok!

onViewOpened
	super onViewOpened.
	key value 
		ifNotNil: [
			[(self view viewNamed: 'value')
				setFocus;
				selectAll] postToInputQueue]!

queryCommand: aCommandQuery 
	aCommandQuery command == #ok 
		ifTrue: 
			[aCommandQuery isEnabled: self isValid.
			^true].
	^super queryCommand: aCommandQuery! !
!PoolItemDialog categoriesFor: #createComponents!initializing!public! !
!PoolItemDialog categoriesFor: #isValid!public!testing! !
!PoolItemDialog categoriesFor: #model:!accessing!public! !
!PoolItemDialog categoriesFor: #ok!commands!public! !
!PoolItemDialog categoriesFor: #onViewOpened!event handling!public! !
!PoolItemDialog categoriesFor: #queryCommand:!commands!public! !

!PoolItemDialog class methodsFor!

defaultModel
	^Association new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(DialogView) 98 30 0 0 98 2 26214401 131073 416 0 524550 ##(ColorRef) 8 4278190080 328198 ##(Point) 521 421 679 0 0 0 416 852230 ##(FramingLayout) 234 240 98 12 410 8 ##(PushButton) 98 17 0 416 98 2 8 1140924416 1 624 0 482 512 0 7 0 0 0 624 0 8 4294903480 1180998 4 ##(CommandDescription) 8 #cancel 8 'Cancel' 1 1 0 0 32 983302 ##(MessageSequence) 202 208 98 2 721670 ##(MessageSend) 8 #createAt:extent: 98 2 530 349 299 530 141 51 624 866 8 #text: 98 1 8 'Cancel' 624 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 149 0 0 0 244 0 0 0 174 0 0 0] 98 0 530 193 193 0 27 1181766 2 ##(FramingConstraints) 1114638 ##(STBSingletonProxy) 8 ##(FramingCalculation) 8 #fixedPreviousRight 9 1146 1168 8 #fixedViewLeft 141 1146 1168 8 #fixedPreviousTop 1 1146 1168 8 #fixedPreviousBottom 1 410 8 ##(StaticText) 98 16 0 416 98 2 8 1140850944 1 1296 0 0 0 7 0 0 0 1296 0 8 4294903292 852486 ##(NullConverter) 0 0 0 802 202 208 98 2 866 896 98 2 530 9 165 530 493 51 1296 866 976 98 1 8 'Value: Enter a valid expression' 1296 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 82 0 0 0 250 0 0 0 107 0 0 0] 98 0 1088 0 27 1106 1146 1168 8 #fixedParentLeft 9 1146 1168 8 #fixedParentRight -7 1264 41 1146 1168 8 #fixedViewTop 51 410 1312 98 16 0 416 98 2 8 1140850944 1 1744 0 0 0 7 0 0 0 1744 0 8 4294903292 1394 0 0 0 802 202 208 98 2 866 896 98 2 530 9 25 530 493 51 1744 866 976 98 1 8 'Key:  Enter a String (no quotes needed)' 1744 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 12 0 0 0 250 0 0 0 37 0 0 0] 98 0 1088 0 27 1106 1648 9 1680 -7 1146 1168 8 #fixedParentTop 25 1712 51 410 640 98 17 0 416 98 2 8 1141055488 1 2096 0 482 512 0 7 0 0 0 2096 0 8 4294903480 738 8 #ok 8 'OK' 1 1 0 0 16 802 202 208 98 3 866 896 98 2 530 201 299 530 141 51 2096 866 8 #isEnabled: 98 1 32 2096 866 976 98 1 8 'OK' 2096 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 149 0 0 0 170 0 0 0 174 0 0 0] 98 0 1088 0 27 1106 1648 201 1200 141 1146 1168 8 #fixedViewBottom -49 1146 1168 8 #fixedParentBottom -7 410 8 ##(TextEdit) 98 16 0 416 98 2 8 1140916352 1025 2576 0 482 512 0 7 0 0 0 2576 0 8 4294903564 1394 0 0 5 802 202 208 98 3 866 896 98 2 530 9 215 530 493 51 2576 866 8 #selectionRange: 98 1 525062 ##(Interval) 3 1 3 2576 866 8 #isTextModified: 98 1 32 2576 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 107 0 0 0 250 0 0 0 132 0 0 0] 98 0 1088 0 27 1106 1648 9 1680 -7 1264 1 1712 51 410 2592 98 16 0 416 98 2 8 1140916352 1025 3008 0 482 512 0 7 0 0 0 3008 0 8 4294903564 1394 0 0 5 802 202 208 98 3 866 896 98 2 530 9 75 530 493 51 3008 866 2832 98 1 2866 3 1 3 3008 866 2912 98 1 32 3008 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 37 0 0 0 250 0 0 0 62 0 0 0] 98 0 1088 0 27 1106 1648 9 1680 -7 1264 1 1712 51 234 256 98 4 3008 8 'key' 2576 8 'value' 0 0 0 0 0 10071 0 0 0 0 1 0 0 590598 ##(Semaphore) 0 0 1 0 8 2010572111 802 202 208 98 3 866 896 98 2 530 20001 20001 530 521 421 416 866 976 98 1 8 'PoolConstantsDictionary Item' 416 866 8 #menuBar: 98 1 0 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 39 0 0 16 39 0 0 20 40 0 0 226 39 0 0] 98 6 1744 3008 1296 2576 2096 624 1088 0 27)! !
!PoolItemDialog class categoriesFor: #defaultModel!constants!public! !
!PoolItemDialog class categoriesFor: #resource_Default_view!public!resources-views! !

