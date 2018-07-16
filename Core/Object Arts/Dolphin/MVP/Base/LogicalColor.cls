"Filed out from Dolphin Smalltalk 7"!

Color subclass: #LogicalColor
	instanceVariableNames: 'index'
	classVariableNames: 'ColorsByIndex NamesByIndex'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LogicalColor guid: (GUID fromString: '{8171569c-0521-4414-b735-de5670f78949}')!
LogicalColor isAbstract: true!
LogicalColor comment: '`LogicalColor` is the abstract class of predefined, named, colours defined by Windows that represent either a named colour from the system palette, e.g. `Color red`, or a named colour from the system theme, e.g. `Color menu`.

A number of commonly used named colours are accessible using the named colour instance creation methods of `Color` class. The entire range of named colours can be accessing using `Color class>>named:`, passing the symbolic name of the colour. The named colours can also be replaced, which provides a simplistic theming mechanism, however this is not recommended. The preferred approach is to defined your own named `Color`s. If this is done using `VirtualColor`s, then these can be changed dynamically, even if saved into view resources. For an example look for references to the `#toolBackground` colour used in the IDE tools.

## Instance Variables:
  `index`		`SmallInteger` code of the pre-defined colour; either an indexed colour or system colour constant.

## Class Variables:
  `NamesByIndex`		`IdentityDictionary` mapping `SmallInteger` index to `Symbol` name
  `ColorsByIndex`		`IdentityDictionary` mapping `SmallInteger` index to sub-instance

'!
!LogicalColor categoriesForClass!Drawing! !
!LogicalColor methodsFor!

= aLogicalColor
	"Answer true if aLogicalColor is equal to (is the same species of LogicalColor and has the
	same index as) the receiver."

	^self species == aLogicalColor species and: [self index = aLogicalColor index]!

hash
	"Answer the SmallInteger hash value for the receiver."

	^index hash!

index
	"Answer the receiver's index."

	^index!

name
	"Answer the symbolic name of the receiver."

	^NamesByIndex lookup: index!

printOn: aPuttableStream
	"Append, to the <puttableStream>, target, a string whose characters are a the same as those
	which would result from sending a #printString message to the receiver."

	aPuttableStream nextPut: $(.
	self name
		ifNil: 
			[aPuttableStream
				print: self class;
				space;
				display: #withIndex:;
				space;
				print: index]
		ifNotNil: 
			[:name |
			aPuttableStream
				print: Color;
				space.
			(Color class canUnderstand: name)
				ifTrue: [aPuttableStream display: name]
				ifFalse: 
					[aPuttableStream
						display: #named:;
						space;
						print: name]].
	aPuttableStream nextPut: $)!

setIndex: anInteger
	"Private - Set the receiver's index to anInteger."

	index := anInteger!

shallowCopy
	"The receiver's instances are unique for each named value."

	^self! !
!LogicalColor categoriesFor: #=!comparing!public! !
!LogicalColor categoriesFor: #hash!comparing!public! !
!LogicalColor categoriesFor: #index!accessing!public! !
!LogicalColor categoriesFor: #name!accessing!public! !
!LogicalColor categoriesFor: #printOn:!development!printing!public! !
!LogicalColor categoriesFor: #setIndex:!accessing!private! !
!LogicalColor categoriesFor: #shallowCopy!copying!public! !

!LogicalColor class methodsFor!

initialize
	NamesByIndex := IdentityDictionary new.
	ColorsByIndex := IdentityDictionary new!

stbReadFrom: anSTBInFiler format: anSTBClassConversion 
	"Read a sub-instance of the receiver from the binary filer, aSTBInFiler."

	"Implementation Note: Overridden in order to maintain unique instances without using a proxy"

	| answer ref |
	anSTBInFiler version < 3 ifTrue: [anSTBInFiler stream skip: 4].
	"Make a placeholder for the Color"
	ref := anSTBInFiler register: nil.
	answer := self withIndex: anSTBInFiler basicNext.
	anSTBInFiler fixup: ref to: answer.
	^answer!

withIndex: anInteger 
	"Answer an instance whose index is anInteger."

	^ColorsByIndex at: anInteger
		ifAbsent: 
			[(self basicNew)
				setIndex: anInteger;
				yourself]! !
!LogicalColor class categoriesFor: #initialize!class initialization!development!public! !
!LogicalColor class categoriesFor: #stbReadFrom:format:!binary filing!public! !
!LogicalColor class categoriesFor: #withIndex:!instance creation!public! !

