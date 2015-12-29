"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #JSONResponseObject
	instanceVariableNames: 'values'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JSONResponseObject guid: (GUID fromString: '{73B1607F-D034-47E4-B8EB-7DD27B333002}')!
JSONResponseObject comment: ''!
!JSONResponseObject categoriesForClass!Unclassified! !
!JSONResponseObject methodsFor!

at: elementNameSymbol put: elementValue 
	self values at: elementNameSymbol put: elementValue!

checkBoxAt: checkboxNameSymbol putChecked: checkboxValueBoolean 
	self values at: checkboxNameSymbol put: checkboxValueBoolean == true!

dropDownListAt: dropDownNameSymbol options: options valueSelector: valueSelector displaySelector: displaySelector putValue: dropDownValue 
	| coll |
	coll := OrderedCollection new.
	options do: 
			[:each | 
			coll add: ((LookupTable new)
						at: #value put: (each perform: valueSelector);
						at: #text put: (each perform: displaySelector);
						yourself)].
	self values at: dropDownNameSymbol
		put: ((LookupTable new)
				at: #value put: dropDownValue;
				at: #options put: coll;
				yourself)!

dropDownListAt: dropDownNameSymbol putValue: dropDownValue 
	self values at: dropDownNameSymbol put: dropDownValue!

generateOn: aStream 
	aStream nextPutAll: self values asJavascriptValue!

radioButtonAt: radioNameSymbol putCheckedValue: radioValue 
	self values at: radioNameSymbol put: radioValue!

values
	values isNil ifTrue: [values := LookupTable new].
	^values! !
!JSONResponseObject categoriesFor: #at:put:!public! !
!JSONResponseObject categoriesFor: #checkBoxAt:putChecked:!public! !
!JSONResponseObject categoriesFor: #dropDownListAt:options:valueSelector:displaySelector:putValue:!public! !
!JSONResponseObject categoriesFor: #dropDownListAt:putValue:!public! !
!JSONResponseObject categoriesFor: #generateOn:!public! !
!JSONResponseObject categoriesFor: #radioButtonAt:putCheckedValue:!public! !
!JSONResponseObject categoriesFor: #values!private! !

