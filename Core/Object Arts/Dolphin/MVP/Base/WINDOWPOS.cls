"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #WINDOWPOS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WINDOWPOS guid: (GUID fromString: '{cd69a071-3606-11d3-93bd-00a024ca708a}')!
WINDOWPOS comment: ''!
!WINDOWPOS categoriesForClass!External-Data-Structured-Win32! !
!WINDOWPOS methodsFor!

cx
	"Answer the <Integer> value of the receiver's 'cx' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #cx)!

cx: anInteger
	"Set the receiver's 'cx' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #cx) put: anInteger!

cy
	"Answer the <Integer> value of the receiver's 'cy' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #cy)!

cy: anInteger
	"Set the receiver's 'cy' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #cy) put: anInteger!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

hwndInsertAfter
	"Answer the <Integer> value of the receiver's 'hwndInsertAfter' field."

	^bytes dwordAtOffset: ##(self offsetOf: #hwndInsertAfter)!

isRectangleChanged
	^(self flags allMask: ##(SWP_NOMOVE | SWP_NOSIZE)) not!

printOn: aStream 
	"Append a textual representation of the receiver to aStream."

	| flags first |
	self isNull ifTrue: [^super printOn: aStream].
	aStream
		basicPrint: self;
		nextPutAll: '(after ';
		print: (View fromHandle: self hwndInsertAfter);
		nextPutAll: ', '.
	self isRectangleChanged 
		ifTrue: 
			[aStream
				print: self rectangle;
				nextPutAll: ', '].
	flags := self flags.
	first := true.
	##((Win32Constants keys select: [:each | each beginsWith: 'SWP_']) asSortedCollection 
		asArray) do: 
				[:each | 
				(flags allMask: (Win32Constants at: each)) 
					ifTrue: 
						[first ifTrue: [first := false] ifFalse: [aStream nextPut: $|].
						aStream nextPutAll: each]]!

rectangle
	^self x @ self y extent: self cx @ self cy!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #x)!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #y)! !
!WINDOWPOS categoriesFor: #cx!**compiled accessors**!public! !
!WINDOWPOS categoriesFor: #cx:!**compiled accessors**!public! !
!WINDOWPOS categoriesFor: #cy!**compiled accessors**!public! !
!WINDOWPOS categoriesFor: #cy:!**compiled accessors**!public! !
!WINDOWPOS categoriesFor: #flags!**compiled accessors**!public! !
!WINDOWPOS categoriesFor: #hwndInsertAfter!**compiled accessors**!public! !
!WINDOWPOS categoriesFor: #isRectangleChanged!public!testing! !
!WINDOWPOS categoriesFor: #printOn:!development!printing!public! !
!WINDOWPOS categoriesFor: #rectangle!accessing!public! !
!WINDOWPOS categoriesFor: #x!**compiled accessors**!public! !
!WINDOWPOS categoriesFor: #y!**compiled accessors**!public! !

!WINDOWPOS class methodsFor!

defineFields
	"Define the layout of the Win32 WINDOWPOS structure.

		WINDOWPOS compileDefinition

		typedef struct _WINDOWPOS {
			HWND hwnd;
			HWND hwndInsertAfter;
			int x;
			int y;
			int cx;
			int cy;
			UINT flags; } WINDOWPOS; 
	"

	self
		defineField: #hwnd type: DWORDField filler;
		defineField: #hwndInsertAfter type: DWORDField readOnly;
		defineField: #x type: SDWORDField readOnly;
		defineField: #y type: SDWORDField readOnly;
		defineField: #cx type: SDWORDField new;
		defineField: #cy type: SDWORDField new;
		defineField: #flags type: DWORDField readOnly
!

getFieldNames
	^#(#hwndInsertAfter #x #y #cx #cy #flags)! !
!WINDOWPOS class categoriesFor: #defineFields!initializing!public! !
!WINDOWPOS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

