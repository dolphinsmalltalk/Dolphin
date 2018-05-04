"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #TIMEVAL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TIMEVAL guid: (GUID fromString: '{c4066d09-c93b-488e-b9b9-585ddddb41ea}')!
TIMEVAL comment: '<Timeval> is an <ExternalStructure> class to wrap the struct ''WINSOCK2Lib.timeval'' from type information in the ''Windows Sockets 2 Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef struct tagtimeval {
	long tv_sec;
	long tv_usec;
} timeval;
'!
!TIMEVAL categoriesForClass!WINSOCK2Lib-Structs! !
!TIMEVAL methodsFor!

tv_sec
	"Answer the receiver's tv_sec field as a Smalltalk object."

	^(bytes sdwordAtOffset: 0)!

tv_sec: anObject
	"Set the receiver's tv_sec field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

tv_usec
	"Answer the receiver's tv_usec field as a Smalltalk object."

	^(bytes sdwordAtOffset: 4)!

tv_usec: anObject
	"Set the receiver's tv_usec field to the value of anObject."

	bytes sdwordAtOffset: 4 put: anObject! !
!TIMEVAL categoriesFor: #tv_sec!**compiled accessors**!public! !
!TIMEVAL categoriesFor: #tv_sec:!**compiled accessors**!public! !
!TIMEVAL categoriesFor: #tv_usec!**compiled accessors**!public! !
!TIMEVAL categoriesFor: #tv_usec:!**compiled accessors**!public! !

!TIMEVAL class methodsFor!

defineFields
	"Define the fields of the timeval structure.
		self compileDefinition
	
		typedef 		struct tagtimeval {
			long tv_sec;
			long tv_usec;
		} timeval;
"

	self
		defineField: #tv_sec type: SDWORDField new;
		defineField: #tv_usec type: SDWORDField new! !
!TIMEVAL class categoriesFor: #defineFields!**auto generated**!initializing!public! !

