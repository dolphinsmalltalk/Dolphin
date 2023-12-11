"Filed out from Dolphin Smalltalk"!

STON.Writer
	subclass: #'STON.JsonWriter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.JsonWriter guid: (Core.GUID fromString: '{c227455c-4e8f-490b-a62a-eaf7a3985622}')!
STON.JsonWriter comment: ''!
!STON.JsonWriter categoriesForClass!STON-Core-Writer! !
!STON.JsonWriter methodsFor!

emitQuote
	writeStream nextPut: $"!

encodeKey: key value: value
	key isString ifFalse: [self error: 'JSON key names in objects must be strings'].
	super encodeKey: key value: value!

initialize
	super initialize.
	referencePolicy := #error.
	self
		escape: $' with: #pass;
		escape: $" with: '\"'!

jsonMode
	^true!

writeAssociation: association
	self error: 'wrong object class for JSON mode'!

writeFraction: fraction
	self writeFloat: fraction asFloat!

writeNull
	writeStream nextPutAll: 'null'!

writeObject: anObject do: block
	(anObject class ~= STON listClass and: [anObject class ~= STON mapClass])
		ifTrue: [self error: 'wrong object class for JSON mode'].
	super writeObject: anObject do: block!

writeObject: anObject named: stonName do: block
	(anObject class ~= STON listClass and: [anObject class ~= STON mapClass])
		ifTrue: [self error: 'wrong object class for JSON mode'].
	super
		writeObject: anObject
		named: stonName
		do: block!

writeScaledDecimal: scaledDecimal
	self writeFloat: scaledDecimal asFloat!

writeSymbol: symbol
	self writeString: symbol! !
!STON.JsonWriter categoriesForMethods!
emitQuote!helpers!private! !
encodeKey:value:!helpers!private! !
initialize!initialization!public! !
jsonMode!public!testing! !
writeAssociation:!public!writing! !
writeFraction:!public!writing! !
writeNull!public!writing! !
writeObject:do:!public!writing! !
writeObject:named:do:!public!writing! !
writeScaledDecimal:!public!writing! !
writeSymbol:!public!writing! !
!

