"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.TVINSERTSTRUCTW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.TreeViewConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_hInsertAfter' -> 16r4.
			'_OffsetOf_hParent' -> 16r0.
			'_OffsetOf_item' -> 16r8.
			'_TVINSERTSTRUCTW_Size' -> 16r44.
			'CallbackPrototype'
				-> #[0 0 0 0 0 0 0 0 67 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 0 0 0 0 255 255 255 255 0 0 0 0 255 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
		}!

OS.TVINSERTSTRUCTW guid: (Core.GUID fromString: '{87b4c618-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.TVINSERTSTRUCTW comment: ''!

!OS.TVINSERTSTRUCTW categoriesForClass!External-Data-Structured-Win32! !

!OS.TVINSERTSTRUCTW methodsFor!

hInsertAfter
	"Answer the <Handle> value of the receiver's 'hInsertAfter' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hInsertAfter) asExternalHandle!

hInsertAfter: aHandle
	"Set the receiver's 'hInsertAfter' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hInsertAfter put: aHandle!

hParent
	"Answer the <Handle> value of the receiver's 'hParent' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hParent) asExternalHandle!

hParent: aHandle
	"Set the receiver's 'hParent' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hParent put: aHandle!

item
	"Answer the <TVITEMEXW> value of the receiver's 'item' field."

	^TVITEMEXW fromAddress: bytes yourAddress + _OffsetOf_item! !

!OS.TVINSERTSTRUCTW categoriesForMethods!
hInsertAfter!**compiled accessors**!public! !
hInsertAfter:!**compiled accessors**!public! !
hParent!**compiled accessors**!public! !
hParent:!**compiled accessors**!public! !
item!**compiled accessors**!public! !
!

!OS.TVINSERTSTRUCTW class methodsFor!

byteSize
	^_TVINSERTSTRUCTW_Size!

defineFields
	"Define the layout of the Win32 TVINSERTSTRUCT structure.
		self compileDefinition
	"

	self
		defineField: #hParent type: HANDLEField new;
		defineField: #hInsertAfter type: HANDLEField new;
		defineField: #item type: (StructureField type: TVITEMEXW) beReadOnly!

getFieldNames
	^#(#hParent #hInsertAfter #item)!

hParent: parentHandle hInsertAfter: siblingHandle
	^self basicNew
		bytes: (CallbackPrototype shallowCopy
					uintPtrAtOffset: _OffsetOf_hParent put: parentHandle;
					uintPtrAtOffset: _OffsetOf_hInsertAfter put: siblingHandle;
					yourself);
		yourself!

initialize
	| proto |
	proto := self newBuffer.
	proto item allCallbacks.
	self addClassConstant: 'CallbackPrototype' value: proto bytes! !

!OS.TVINSERTSTRUCTW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
hParent:hInsertAfter:!public! !
initialize!development!public! !
!

