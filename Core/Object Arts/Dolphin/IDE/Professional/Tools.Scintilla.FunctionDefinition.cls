"Filed out from Dolphin Smalltalk"!

Tools.Scintilla.InterfaceDefinition
	subclass: #'Tools.Scintilla.FunctionDefinition'
	instanceVariableNames: 'funcType returnType lParam wParam returnTypeName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Scintilla.FunctionDefinition guid: (Core.GUID fromString: '{1c19ff8a-f7a5-4f32-ad24-5ddb1990984f}')!
Tools.Scintilla.FunctionDefinition comment: ''!
!Tools.Scintilla.FunctionDefinition categoriesForClass!Development! !
!Tools.Scintilla.FunctionDefinition methodsFor!

constPrefix
	^'SCI_'!

defaultReturnValue
	^self returnType defaultValue!

displayOn: aStream
	aStream nextPutAll: returnTypeName;
		space;
		nextPutAll: name;
		nextPut: $(.
	wParam name ifNotNil: [
		aStream display: wParam].
	lParam name ifNotNil: [
		aStream nextPutAll: ', '.
		aStream display: lParam].
	aStream nextPut: $)!

emitBasicNullLParamFunctionOn: aPuttableStream
	aPuttableStream
		nextPutAll: self selector;
		space;
		nextPutAll: lParam parameterName;
		crtab.
	self emitMethodBodyOn: aPuttableStream!

emitBasicWParamLParamFunctionOn: aPuttableStream
	| keywords |
	keywords := self selector subStrings: $:.
	aPuttableStream
		nextPutAll: keywords first;
		nextPut: $:;
		space;
		nextPutAll: wParam parameterName;
		space;
		nextPutAll: keywords second;
		nextPut: $:;
		space;
		nextPutAll: lParam parameterName;
		crtab.
	self emitMethodBodyOn: aPuttableStream!

emitCommentString: aString on: aPuttableStream 
	aString do: [:each | aPuttableStream nextPut: (each == $" ifTrue: [$'] ifFalse: [each])]!

emitMethodBodyOn: aPuttableStream
	self emitMethodPreambleOn: aPuttableStream.
	self hasReturnValue
		ifTrue: 
			[aPuttableStream nextPutAll: '^('.
			self returnType emitReturnConversionAround: [self emitScintillaCallOn: aPuttableStream]
				on: aPuttableStream.
			aPuttableStream nextPut: $)]
		ifFalse: [self emitScintillaCallOn: aPuttableStream]!

emitMethodCommentOn: aPuttableStream
	| target devsys |
	self comment isEmpty ifTrue: [^self].
	target := String writeStream.
	target nextPut: $".
	self isPrivate ifTrue: [target nextPutAll: 'Private - '].
	self emitCommentString: self comment on: target.
	target nextPut: $".
	devsys := SmalltalkSystem current.
	aPuttableStream
		nextPutAll: (devsys
					wrapText: target contents
					indent: devsys workspaceClass defaultTabWidth + 1
					tabWidth: devsys workspaceClass defaultTabWidth);
		cr!

emitMethodPreambleOn: aPuttableStream 
	self emitMethodCommentOn: aPuttableStream.
	self isDeprecated 
		ifTrue: 
			[aPuttableStream
				print: 'deprecated' asSymbol;
				nextPut: $.;
				crtab]!

emitMethodTextOn: aWriteStream
	^wParam isUnused
		ifTrue: 
			[lParam isUnused
				ifTrue: [self emitNullNullFunctionOn: aWriteStream]
				ifFalse: [self emitNullLParamFunctionOn: aWriteStream]]
		ifFalse: 
			[lParam isUnused
				ifTrue: [self emitWParamNullFunctionOn: aWriteStream]
				ifFalse: [self emitWParamLParamFunctionOn: aWriteStream]]!

emitNullLParamFunctionOn: aWriteStream 
	^self hasStringResult 
		ifTrue: [self emitStringResultFunctionOn: aWriteStream]
		ifFalse: [self emitBasicNullLParamFunctionOn: aWriteStream]!

emitNullNullFunctionOn: aWriteStream
	aWriteStream
		nextPutAll: self selector;
		crtab.
	self emitMethodBodyOn: aWriteStream!

emitScintillaCallOn: aPuttableStream
	| retType |
	retType := self returnType.
	aPuttableStream
		nextPutAll: 'library ';
		nextPutAll: retType directFunctionKeyword;
		nextPutAll: 'this msg: ';
		nextPutAll: constName.
	wParam emitOutParam: $w on: aPuttableStream.
	lParam emitOutParam: $l on: aPuttableStream!

emitStringResultFunctionOn: aPuttableStream
	| resultClassExpression |
	aPuttableStream
		nextPutAll: self selector;
		crtab.
	self emitMethodPreambleOn: aPuttableStream.
	resultClassExpression := (self fixedClassStringResults lookup: constName)
				ifNil: ['stringClass']
				ifNotNil: [:resultClass | resultClass shortName].
	aPuttableStream
		nextPutAll: '| len | len := library directFunction: this msg: ';
		nextPutAll: self constName;
		nextPutAll: ' wParam: 0 lpParam: nil. ^len == 0 ifTrue: [';
		display: resultClassExpression;
		nextPutAll: ' empty] ifFalse: [| result | result := ';
		display: resultClassExpression;
		nextPutAll: ' newFixed: len. library directFunction: this msg: ';
		nextPutAll: self constName;
		nextPutAll: ' wParam: 0 lpParam: result. result]'!

emitWParamLParamFunctionOn: aPuttableStream
	^self hasStringResult
		ifTrue: [self emitWParamStringResultFunctionOn: aPuttableStream]
		ifFalse: [self emitBasicWParamLParamFunctionOn: aPuttableStream]!

emitWParamNullFunctionOn: aPuttableStream
	aPuttableStream
		nextPutAll: self selector;
		space;
		nextPutAll: wParam parameterName;
		crtab.
	self emitMethodBodyOn: aPuttableStream!

emitWParamStringResultFunctionOn: aWriteStream
	| ignoreWParam resultClassExpression |
	ignoreWParam := self selector argumentCount = 0.
	aWriteStream
		nextPutAll: self selector;
		space.
	ignoreWParam ifFalse: [aWriteStream nextPutAll: wParam parameterName].
	aWriteStream crtab.
	self emitMethodPreambleOn: aWriteStream.
	resultClassExpression := self fixedClassStringResults at: constName ifAbsent: ['stringClass'].
	aWriteStream
		nextPutAll: '| len | len := library directFunction: this msg: ';
		nextPutAll: self constName.
	ignoreWParam
		ifTrue: [aWriteStream nextPutAll: ' wParam: 0']
		ifFalse: [wParam emitOutParam: $w on: aWriteStream].
	aWriteStream
		nextPutAll: ' lpParam: nil. ^len == 0 ifTrue: [';
		display: resultClassExpression;
		nextPutAll: ' empty] ifFalse: [| result | result := ';
		display: resultClassExpression;
		nextPutAll: ' newFixed: len. library directFunction: this msg: ';
		nextPutAll: constName.
	ignoreWParam
		ifTrue: [aWriteStream nextPutAll: ' wParam: len']
		ifFalse: [wParam emitOutParam: $w on: aWriteStream].
	aWriteStream nextPutAll: ' lpParam: result. result]'!

fixedClassStringResults
	"Answer the set of Scintilla functions declared as returning strings, but which need to
	return either a ByteArray or a specific class of String that doesn't depend on the view's
	current encoding."

	^##(LookupTable new
		at: 'SCI_MARGINGETSTYLES' put: ByteArray;
		at: 'SCI_ANNOTATIONGETSTYLES' put: ByteArray;
		at: 'SCI_GETSUBSTYLEBASES' put: ByteArray;
		at: 'SCI_TARGETASUTF8' put: Utf8String;
		at: 'SCI_GETPUNCTUATIONCHARS' put: AnsiString;
		at: 'SCI_GETWHITESPACECHARS' put: AnsiString;
		at: 'SCI_GETWORDCHARS' put: AnsiString;
		yourself)!

funcType: aString 
	funcType := aString!

hasReturnValue
	^self returnType isVoid not!

hasStringResult
	^lParam typeName = 'stringresult'!

isCommand
	"void functions with no parameters that have been given a specific name are considered to be commands."

	^self isFunction and: 
			[self hasReturnValue not
				and: [wParam isUnused and: [lParam isUnused and: [(self selector beginsWith: 'sci') not]]]]!

isFunction
	^funcType = 'fun'!

isPrivate
	| sel |
	sel := ScintillaViewGenerator renamedFunctions at: constName ifAbsent: [].
	^sel isNil or: [sel beginsWith: 'basic']!

isPropGet
	^funcType = 'get'!

isPropSet
	^funcType = 'set'!

lParam: anArray
	lParam := self makeParam: anArray!

makeParam: anArray
	| paramName paramTypeName |
	paramName := anArray last.
	paramTypeName := anArray first.
	((paramTypeName = 'position' and: 
			[(##(#('bytes' 'space' 'lines' 'columns' 'relative') asSet) includes: paramName)
				or: [paramName beginsWith: 'length']])
		or: [paramTypeName = 'line' and: [paramName = 'lines']]) ifTrue: [paramTypeName := 'int'].
	^ParameterDefinition newName: paramName typeName: paramTypeName!

name
	^name!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(; display: self; nextPut: $).!

remappedReturnTypes
	"As of Scintilla 4.20 there are some helpful new parameter and return types intended to more closely describe
	usage in order to allow for better auto-generation of language bindings. However the 'position' type has been 
	abused to also describe lengths/sizes. Since we want to map from Scintilla's zero-based positions to Smalltalk
	1-based indexes, we need to distinguish between genuine positions, and misuses of the type."

	^##(| remappedReturnTypes |
	remappedReturnTypes := LookupTable new.
	#('SCI_GETSTYLEDTEXT' 'SCI_GETSTYLEDTEXTFULL' 'SCI_COUNTCHARACTERS' 'SCI_COUNTCODEUNITS' 'SCI_GETLINECOUNT' 'SCI_GETTEXTRANGE' 'SCI_GETTEXTRANGEFULL' 'SCI_GETTEXTLENGTH' 'SCI_REPLACETARGET' 'SCI_REPLACETARGETRE' 'SCI_WRAPCOUNT' 'SCI_LINESONSCREEN' 'SCI_POSITIONRELATIVE' 'SCI_POSITIONRELATIVECODEUNITS' 'SCI_GETSELECTIONNCARETVIRTUALSPACE' 'SCI_GETSELECTIONNANCHORVIRTUALSPACE' 'SCI_GETRECTANGULARSELECTIONCARETVIRTUALSPACE' 'SCI_GETRECTANGULARSELECTIONANCHORVIRTUALSPACE')
		do: [:each | remappedReturnTypes at: each put: 'int'].
	remappedReturnTypes)!

retType: aString
	returnTypeName := self remappedReturnTypes at: constName ifAbsent: [aString]!

returnType
	^returnType ifNil: [returnType := TypeReference named: returnTypeName]!

selector
	selector ifNotNil: [^selector].
	selector := ScintillaViewGenerator renamedFunctions at: constName
				ifAbsent: 
					[| stream |
					stream := String writeStream.
					stream
						nextPutAll: 'sci';
						nextPutAll: name capitalized.
					wParam isUnused
						ifTrue: [(lParam isUnused or: [self hasStringResult]) ifFalse: [stream nextPut: $:]]
						ifFalse: 
							[stream nextPut: $:.
							(lParam isUnused or: [self hasStringResult])
								ifFalse: 
									[stream
										nextPutAll: lParam name;
										nextPut: $:]].
					stream contents asSymbol].
	^selector!

wParam: anArray
	wParam := self makeParam: anArray! !
!Tools.Scintilla.FunctionDefinition categoriesForMethods!
constPrefix!initializing!private! !
defaultReturnValue!accessing!private! !
displayOn:!displaying!public! !
emitBasicNullLParamFunctionOn:!generating!private! !
emitBasicWParamLParamFunctionOn:!generating!private! !
emitCommentString:on:!helpers!private! !
emitMethodBodyOn:!generating!private! !
emitMethodCommentOn:!helpers!private! !
emitMethodPreambleOn:!helpers!private! !
emitMethodTextOn:!generating!public! !
emitNullLParamFunctionOn:!generating!private! !
emitNullNullFunctionOn:!generating!private! !
emitScintillaCallOn:!generating!private! !
emitStringResultFunctionOn:!generating!private! !
emitWParamLParamFunctionOn:!helpers!private! !
emitWParamNullFunctionOn:!generating!private! !
emitWParamStringResultFunctionOn:!generating!private! !
fixedClassStringResults!accessing!constants!private! !
funcType:!accessing!private! !
hasReturnValue!helpers!public! !
hasStringResult!helpers!private! !
isCommand!helpers!private! !
isFunction!public!testing! !
isPrivate!private!testing! !
isPropGet!public!testing! !
isPropSet!public!testing! !
lParam:!accessing!private! !
makeParam:!accessing!private! !
name!accessing!public! !
printOn:!printing!public! !
remappedReturnTypes!private! !
retType:!accessing!private! !
returnType!accessing!public! !
selector!generating!private! !
wParam:!accessing!private! !
!

!Tools.Scintilla.FunctionDefinition class methodsFor!

tokens: anArray 
	| func |
	func := super tokens: anArray.
	func wParam: (anArray at: 4).
	func lParam: (anArray at: 5).
	^func! !
!Tools.Scintilla.FunctionDefinition class categoriesForMethods!
tokens:!instance creation!public! !
!

