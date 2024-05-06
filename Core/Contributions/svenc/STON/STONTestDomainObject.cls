"Filed out from Dolphin Smalltalk"!

Object subclass: #STONTestDomainObject
	instanceVariableNames: 'created modified integer float description color tags bytes boolean'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

STONTestDomainObject guid: (GUID fromString: '{ef1278a4-658e-4799-870c-89c6de6b7c53}')!

STONTestDomainObject comment: 'STONTestDomainObject is used to support unit tests.

Instance Variables
	boolean:		<Boolean>
	bytes:			<ByteArray>
	color:			<Symbol>
	created:		<DateAndTime>
	description:	<String>
	float:			<Float>
	integer:		<Integer>
	modified:	<DateAndTime>
	tags:			<Array of: Symbol>'!

!STONTestDomainObject categoriesForClass!STON-Tests-Base! !

!STONTestDomainObject methodsFor!

= anObject
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ color = anObject color
		and: [ 
			modified = anObject modified
				and: [ 
					created = anObject created
						and: [ 
							description = anObject description
								and: [ 
									boolean = anObject boolean
										and: [ 
											(float closeTo: anObject float) 		"Use #closeTo: instead of #= to increase portability"
												and: [ 
													bytes = anObject bytes 
														and: [ 
															integer = anObject integer 
																and: [ tags = anObject tags ] ] ] ] ] ] ] ]
!

boolean
	^ boolean!

boolean: anObject
	boolean := anObject!

bytes
	^ bytes!

bytes: anObject
	bytes := anObject!

color
	^ color!

color: anObject
	color := anObject!

created
	^ created!

created: anObject
	created := anObject!

description
	^ description!

description: anObject
	description := anObject!

float
	^ float!

float: anObject
	float := anObject!

hash
	"Answer an integer value that is related to the identity of the receiver."

	^ color hash
		bitXor:
			(modified hash
				bitXor:
					(created hash
						bitXor:
							(description hash
								bitXor: (boolean hash bitXor: (float hash bitXor: (bytes hash bitXor: (integer hash bitXor: tags hash)))))))!

initialize
	created := modified := DateAndTime now.!

integer
	^ integer!

integer: anObject
	integer := anObject!

modified
	^ modified!

modified: anObject
	modified := anObject!

tags
	^ tags!

tags: anObject
	tags := anObject! !

!STONTestDomainObject categoriesForMethods!
=!comparing!public! !
boolean!accessing!public! !
boolean:!accessing!public! !
bytes!accessing!public! !
bytes:!accessing!public! !
color!accessing!public! !
color:!accessing!public! !
created!accessing!public! !
created:!accessing!public! !
description!accessing!public! !
description:!accessing!public! !
float!accessing!public! !
float:!accessing!public! !
hash!comparing!public! !
initialize!initialize/release!public! !
integer!accessing!public! !
integer:!accessing!public! !
modified!accessing!public! !
modified:!accessing!public! !
tags!accessing!public! !
tags:!accessing!public! !
!

!STONTestDomainObject class methodsFor!

dummy
	^ self new
		integer: 999999 atRandom;
		float: 999 atRandom / Float pi;
		boolean: #(true false) atRandom;
		bytes: (ByteArray streamContents: [ :out | 32 timesRepeat: [ out nextPut: 255 atRandom ] ]);
		description: (String streamContents: [ :out | 16 atRandom timesRepeat: [ out nextPutAll: 'Blah' ] ]);
		color: #(#red #green #blue) atRandom;
		tags: (Array 
			with: #(#one #two #three) atRandom
 			with: #(#alpha #beta #gamma) atRandom 
			with: #(#low #medium #high) atRandom);
		yourself
!

stonName
	^ #TestDomainObject! !

!STONTestDomainObject class categoriesForMethods!
dummy!instance creation!public! !
stonName!public!ston/core! !
!

