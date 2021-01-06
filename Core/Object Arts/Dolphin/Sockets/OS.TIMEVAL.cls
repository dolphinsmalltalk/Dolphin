"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'OS.TIMEVAL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_tv_sec' -> 16r0.
		'_OffsetOf_tv_usec' -> 16r4
	}!
OS.TIMEVAL guid: (Core.GUID fromString: '{c4066d09-c93b-488e-b9b9-585ddddb41ea}')!
OS.TIMEVAL comment: '<Timeval> is an <ExternalStructure> class to wrap the struct ''WINSOCK2Lib.timeval'' from type information in the ''Windows Sockets 2 Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef struct tagtimeval {
	long tv_sec;
	long tv_usec;
} timeval;
'!
!OS.TIMEVAL categoriesForClass!WINSOCK2Lib-Structs! !
!OS.TIMEVAL methodsFor!

tv_sec
	"Answer the <Integer> value of the receiver's 'tv_sec' field."

	^bytes sdwordAtOffset: _OffsetOf_tv_sec!

tv_sec: anInteger
	"Set the receiver's 'tv_sec' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_tv_sec put: anInteger!

tv_usec
	"Answer the <Integer> value of the receiver's 'tv_usec' field."

	^bytes sdwordAtOffset: _OffsetOf_tv_usec!

tv_usec: anInteger
	"Set the receiver's 'tv_usec' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_tv_usec put: anInteger! !
!OS.TIMEVAL categoriesFor: #tv_sec!**compiled accessors**!public! !
!OS.TIMEVAL categoriesFor: #tv_sec:!**compiled accessors**!public! !
!OS.TIMEVAL categoriesFor: #tv_usec!**compiled accessors**!public! !
!OS.TIMEVAL categoriesFor: #tv_usec:!**compiled accessors**!public! !

!OS.TIMEVAL class methodsFor!

defineFields
	"Define the fields of the timeval structure.

	TIMEVAL compileDefinition

		typedef 
		struct tagtimeval {
			long tv_sec;
			long tv_usec;
		} timeval;
"

	self
		defineField: #tv_sec type: SDWORDField new offset: 0;
		defineField: #tv_usec type: SDWORDField new offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#tv_sec #tv_usec)! !
!OS.TIMEVAL class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!OS.TIMEVAL class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

