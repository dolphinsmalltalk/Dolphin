"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ThirtyTwoBitRegister
	instanceVariableNames: 'hi low'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ThirtyTwoBitRegister guid: (GUID fromString: '{74d0064f-5479-4424-b71c-dad95909afff}')!
ThirtyTwoBitRegister comment: '''From Squeak3.0 of 4 February 2001 [latest update: #3545] on 23 September 2001 at 7:54:45 am

I represent a 32-bit register. An instance of me can hold any non-negative integer in the range [0..(2^32 - 1)]. Operations are performed on my contents in place, like a hardware register, and results are always modulo 2^32.

This class is primarily meant for use by the SecureHashAlgorithm class.
'!
!ThirtyTwoBitRegister categoriesForClass!System-Digital Signatures! !
!ThirtyTwoBitRegister methodsFor!

+= aThirtTwoBitRegister
	"Replace my contents with the sum of the given register and my current contents.
	'jm 12/7/1999 15:36'"

	| lowSum |
	lowSum := low + aThirtTwoBitRegister low.
	hi := (hi + aThirtTwoBitRegister hi + (lowSum bitShift: -16)) bitAnd: 16rFFFF.
	low := lowSum bitAnd: 16rFFFF.
!

asInteger
	"Answer the integer value of my current contents. 
	'jm 12/14/1999 16:03'"

	^ (hi bitShift: 16) + low
!

asReverseInteger
	"Answer the byte-swapped integer value of my current contents.
	'DSM 1/20/2000 17:17'"

	^ ((low bitAnd: 16rFF) bitShift: 24) +
       ((low bitAnd: 16rFF00) bitShift: 8) +
	  ((hi bitAnd: 16rFF) bitShift: 8) +
       (hi bitShift: -8)
!

bitAnd: aThirtTwoBitRegister
	"Replace my contents with the bitwise AND of the given register and my current contents.
	'jm 12/7/1999 15:41'"

	hi := hi bitAnd: aThirtTwoBitRegister hi.
	low := low bitAnd: aThirtTwoBitRegister low.
!

bitInvert
	"Replace my contents with the bitwise inverse my current contents.
	'jm 12/7/1999 15:40'"

	hi := hi bitXor: 16rFFFF.
	low := low bitXor: 16rFFFF.
!

bitOr: aThirtTwoBitRegister
	"Replace my contents with the bitwise OR of the given register and my current contents.
	'jm 12/7/1999 15:40'"

	hi := hi bitOr: aThirtTwoBitRegister hi.
	low := low bitOr: aThirtTwoBitRegister low.
!

bitXor: aThirtTwoBitRegister
	"Replace my contents with the bitwise exclusive OR of the given register and my current contents.
	'jm 12/7/1999 15:38'"

	hi := hi bitXor: aThirtTwoBitRegister hi.
	low := low bitXor: aThirtTwoBitRegister low.
!

copy
	"Use the clone primitive for speed.
	'jm 12/7/1999 15:26'"

	"swChanged"
	"<primitive: 148>"
	^ super copy
!

hi
	"'jm 12/7/1999 15:26'"

	^ hi
!

leftRotateBy: bits
	"Rotate my contents left by the given number of bits, retaining exactly 32 bits."
	"Details: Perform this operation with as little LargeInteger arithmetic as possible.
	'jm 12/7/1999 23:09'"

	| bitCount s1 s2 newHi |
	"ensure bitCount is in range [0..32]"
	bitCount := bits \\ 32.
	bitCount < 0 ifTrue: [bitCount := bitCount + 32].

	bitCount > 16
		ifTrue: [
			s1 := bitCount - 16.
			s2 := s1 - 16.
			newHi := ((low bitShift: s1) bitAnd: 16rFFFF) bitOr: (hi bitShift: s2).
			low := ((hi bitShift: s1) bitAnd: 16rFFFF) bitOr: (low bitShift: s2).
			hi := newHi]
		ifFalse: [
			s1 := bitCount.
			s2 := s1 - 16.
			newHi := ((hi bitShift: s1) bitAnd: 16rFFFF) bitOr: (low bitShift: s2).
			low := ((low bitShift: s1) bitAnd: 16rFFFF) bitOr: (hi bitShift: s2).
			hi := newHi]
!

load: anInteger
	"Set my contents to the value of given integer.
	'jm 12/14/1999 16:07'"

	low := anInteger bitAnd: 16rFFFF.
	hi := (anInteger bitShift: -16) bitAnd: 16rFFFF.
	self asInteger = anInteger
		ifFalse: [self error: 'out of range: ', anInteger printString].
!

loadFrom: aByteArray at: index
	"Load my 32-bit value from the four bytes of the given ByteArray starting at the given index. Consider the first byte to contain the most significant bits of the word (i.e., use big-endian byte ordering).
	'jm 12/14/1999 16:07'"

	hi := ((aByteArray at: index) bitShift: 8) + ( aByteArray at: index + 1).
	low := ((aByteArray at: index + 2) bitShift: 8) + ( aByteArray at: index + 3).
!

low
	"'jm 12/7/1999 15:26'"

	^ low!

printOn: aStream
	"Print my contents in hex with a leading 'R' to show that it is a register object being printed.
	'jm 12/14/1999 16:05'"

	aStream nextPutAll: 'R:'.
	self asInteger printOn: aStream base: 16.
!

reverseLoadFrom: aByteArray at: index
	"Load my 32-bit value from the four bytes of the given ByteArray
starting at the given index. Consider the first byte to contain the most
significant bits of the word (i.e., use big-endian byte ordering).
'mdr 2/23/2001 22:51'"

	hi := ((aByteArray at: index + 3) bitShift: 8) + ( aByteArray at: index + 2).
	low := ((aByteArray at: index + 1) bitShift: 8) + ( aByteArray at: index).
! !
!ThirtyTwoBitRegister categoriesFor: #+=!accumulator ops!public! !
!ThirtyTwoBitRegister categoriesFor: #asInteger!accessing!public! !
!ThirtyTwoBitRegister categoriesFor: #asReverseInteger!accessing!public! !
!ThirtyTwoBitRegister categoriesFor: #bitAnd:!accumulator ops!public! !
!ThirtyTwoBitRegister categoriesFor: #bitInvert!accumulator ops!public! !
!ThirtyTwoBitRegister categoriesFor: #bitOr:!accumulator ops!public! !
!ThirtyTwoBitRegister categoriesFor: #bitXor:!accumulator ops!public! !
!ThirtyTwoBitRegister categoriesFor: #copy!copying!public! !
!ThirtyTwoBitRegister categoriesFor: #hi!accessing!public! !
!ThirtyTwoBitRegister categoriesFor: #leftRotateBy:!accumulator ops!public! !
!ThirtyTwoBitRegister categoriesFor: #load:!accessing!public! !
!ThirtyTwoBitRegister categoriesFor: #loadFrom:at:!accessing!public! !
!ThirtyTwoBitRegister categoriesFor: #low!accessing!public! !
!ThirtyTwoBitRegister categoriesFor: #printOn:!printing!public! !
!ThirtyTwoBitRegister categoriesFor: #reverseLoadFrom:at:!accessing!public! !

!ThirtyTwoBitRegister class methodsFor!

new
	"Answer a new instance whose initial contents is zero.
	'jm 12/14/1999 16:05'"

	^ super new load: 0
! !
!ThirtyTwoBitRegister class categoriesFor: #new!instance creation!public! !

