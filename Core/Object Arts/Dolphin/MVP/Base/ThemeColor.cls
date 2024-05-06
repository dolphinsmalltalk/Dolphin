"Filed out from Dolphin Smalltalk"!

VirtualColor subclass: #ThemeColor
	instanceVariableNames: 'name actualColor'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ThemeColor guid: (GUID fromString: '{5016060e-ec13-4e73-be45-ed636d352614}')!

ThemeColor comment: '`ThemeColor` is a class of `VirtualColor`s that provide a named indirection to a real `Color`. They are useful for simple theming purposes, allowing view resources to be created that refer to named `ThemeColor`s which can then be changed to configure the desired actual colour later.

## Instance Variables:
  `name`		`Symbol`; the name of the colour in the logical scheme.
  `actualColor`	`Color`; the colour to which the instance currently resolves when used




'!

!ThemeColor categoriesForClass!Drawing! !

!ThemeColor methodsFor!

actualColor
	^(actualColor ?? Color window) actualColor!

actualColor: aColor
	actualColor := aColor!

name
	^name!

printOn: aPuttableStream
	"Append, to the <puttableStream>, target, a string whose characters are a description of the
	receiver as a developer would want to see it."

	| named |
	aPuttableStream nextPut: $(.
	named := NamedColors lookup: self name.
	named == self
		ifTrue: 
			[aPuttableStream
				print: Color;
				space;
				display: #named:;
				space;
				print: self name]
		ifFalse: 
			[aPuttableStream
				print: self class;
				nextPutAll: ' name: ';
				print: self name;
				nextPutAll: ' actualColor: ';
				print: self actualColor].
	aPuttableStream nextPut: $)!

setName: aSymbol actualColor: aColor
	name := aSymbol.
	actualColor := aColor!

shallowCopy
	"The receiver's instances are unique for each named value."

	^self!

stbSaveOn: anSTBOutFiler
	"Output the singleton receiver to anSTBOutFiler."

	anSTBOutFiler writePreambleFor: self.
	anSTBOutFiler nextPut: self name! !

!ThemeColor categoriesForMethods!
actualColor!accessing!public! !
actualColor:!accessing!public! !
name!printing!public! !
printOn:!printing!public! !
setName:actualColor:!initializing!private! !
shallowCopy!copying!public! !
stbSaveOn:!binary filing!public! !
!

!ThemeColor class methodsFor!

addNamed: aSymbol color: aColor
	| wrapper |
	wrapper := self name: aSymbol actualColor: aColor.
	^super addNamed: aSymbol color: wrapper!

initialize
	self addNamed: #dialog color: Color face3d!

name: aSymbol actualColor: aColor
	<primitive: 157>
	^self basicNew setName: aSymbol actualColor: aColor!

stbReadFrom: anSTBInFiler format: anSTBClassConversion 
	"Read an instance of the receiver from the binary filer, aSTBInFiler."

	"Implementation Note: Overridden in order to maintain unique instances without using an
	STBSingletonProxy."

	| answer ref |
	ref := anSTBInFiler register: nil.
	answer := self named: anSTBInFiler basicNext.
	anSTBInFiler fixup: ref to: answer.
	^answer!

uninitialize
	NamedColors
		removeAllKeys: ((NamedColors select: [:each | each isKindOf: self]) collect: [:each | each name])! !

!ThemeColor class categoriesForMethods!
addNamed:color:!instance creation!named colors!public! !
initialize!class initialization!development!public! !
name:actualColor:!instance creation!public! !
stbReadFrom:format:!binary filing!public! !
uninitialize!class hierarchy-removing!private! !
!

