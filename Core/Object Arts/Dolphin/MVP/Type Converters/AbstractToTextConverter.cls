"Filed out from Dolphin Smalltalk X6"!

TypeConverter subclass: #AbstractToTextConverter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractToTextConverter guid: (GUID fromString: '{87B4C703-026E-11D3-9FD7-00A0CC3E4A32}')!
AbstractToTextConverter comment: 'AbstractToTextConverter is the abstract superclass all of <typeConverter>s dedicated to transformations to and from text. Hence it also conforms to the <textTypeConverter> protocol. It has subclasses specialized for common types of object such as <Number>s and <Boolean>s. 

'!
!AbstractToTextConverter categoriesForClass!MVP-Type Converters-Abstract! !
!AbstractToTextConverter methodsFor!

initialize
	"Private - Initialize the receiver"

	rightNullValue := String empty! !
!AbstractToTextConverter categoriesFor: #initialize!initializing!private! !

