"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.AbstractTEXTRANGE'
	instanceVariableNames: 'text'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.AbstractTEXTRANGE guid: (Core.GUID fromString: '{a8261391-02ae-4fd9-a6e8-044fd70e6f94}')!
OS.AbstractTEXTRANGE isNonInstantiable: true!
OS.AbstractTEXTRANGE comment: ''!
!OS.AbstractTEXTRANGE methodsFor!

cpMax
	"Answer the receiver's cpMax field as a Smalltalk object."

	^self subclassResponsibility!

cpMax: anInteger
	self subclassResponsibility!

cpMin
	"Answer the receiver's cpMin field as a Smalltalk object."

	^self subclassResponsibility!

cpMin: anInteger
	self subclassResponsibility!

lpstrText: anUtf8String
	"Set the receiver's 'lpstrText' field to the value of the argument, anUtf8String"

	self subclassResponsibility!

setFrom: start to: stop text: aString
	"Initialize the receiver with the specified range and text.
	Answer the receiver."

	self
		cpMin: start;
		cpMax: stop;
		text: aString!

size
	^self cpMax - self cpMin!

start
	"Answer the one-based <Integer> index of the first character in the interval."

	^self cpMin + 1!

stop
	"Answer the one-based <integer> index of the end of the last character in the interval."

	^self cpMax
!

text
	"Answer the value of the receiver's 'text' instance variable."

	^text!

text: buffer
	"Set the value of the receiver's 'text' instance variable to <String> argument, buffer.
	Note that buffer should have been allocated from the fixed heap."

	self lpstrText: (text := buffer)! !
!OS.AbstractTEXTRANGE categoriesForMethods!
cpMax!accessing!public! !
cpMax:!accessing!public! !
cpMin!accessing!public! !
cpMin:!accessing!public! !
lpstrText:!**compiled accessors**!public! !
setFrom:to:text:!initializing!private! !
size!accessing!public! !
start!accessing!public! !
stop!accessing!public! !
text!accessing!public! !
text:!accessing!public! !
!

!OS.AbstractTEXTRANGE class methodsFor!

from: startInteger to: stopInteger text: aString 
	"Answer a new instance of the receiver to represent the specified 0-based, 
	end-exclusive, interval, and the text, aString."

	^self new 
		setFrom: startInteger
		to: stopInteger
		text: aString!

from: startInteger to: stopInteger type: aStringClass
	"Answer a new instance of the receiver to represent the specified 0-based, 
	end-exclusive, interval."

	^self 
		from: startInteger
		to: stopInteger
		text: (aStringClass newFixed: stopInteger - startInteger)!

getFieldNames
	^#(#chrg #lpstrText)! !
!OS.AbstractTEXTRANGE class categoriesForMethods!
from:to:text:!instance creation!public! !
from:to:type:!instance creation!public! !
getFieldNames!constants!private! !
!

