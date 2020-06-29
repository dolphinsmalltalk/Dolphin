"Filed out from Dolphin Smalltalk 7"!

TypeConverter subclass: #AbstractToTextConverter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractToTextConverter guid: (GUID fromString: '{87b4c703-026e-11d3-9fd7-00a0cc3e4a32}')!
AbstractToTextConverter comment: 'AbstractToTextConverter is the abstract superclass all of <typeConverter>s dedicated to transformations to and from text. Hence it also conforms to the <textTypeConverter> protocol. It has subclasses specialized for common types of object such as <Number>s and <Boolean>s. 

'!
!AbstractToTextConverter categoriesForClass!MVP-Type Converters-Abstract! !
!AbstractToTextConverter methodsFor!

initialize
	"Private - Initialize the receiver"

	rightNullValue := String empty! !
!AbstractToTextConverter categoriesFor: #initialize!initializing!private! !

