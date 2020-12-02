Float addClassVariable: 'DefaultDecimalExponents' value: (-3 to: 6)!
#(#thousandSeparator #thousandSeparator:) do: [:each | NUMBERFMTW removeSelector: each]!

External.Integer setName: #INTEGER!
External classPool changeKey: #Integer to: #INTEGER!
External.INTEGER superclass setName: #SCALAR!
External classPool changeKey: #Scalar to: #SCALAR!
PackageManager systemPackage classNames 
	remove: #{External.Integer}; 
	add: #{External.INTEGER};
	remove: #{External.Scalar}; 
	add: #{External.SCALAR}!

!Class methodsFor!

fullName
	| stream |
	(name isNil or: [environment == Root]) ifTrue: [^self name].
	stream := WriteStream on: (Utf8String new: 32).
	environment printNameOn: stream relativeTo: Root.
	^stream
		nextPut: $.;
		nextPutAll: name;
		contents!

setName: aSymbolOrNil environment: aNamespace
	(aSymbolOrNil notNil and: [BindingReference isQualifiedName: aSymbolOrNil])
		ifTrue: [self error: 'Invalid simple name ' , aSymbolOrNil].
	name := aSymbolOrNil.
	environment := aNamespace! !
