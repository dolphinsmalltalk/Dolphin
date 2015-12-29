"Filed out from Dolphin Smalltalk X6.1"!

HtmlTable subclass: #HtmlNoSpacingTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlNoSpacingTable guid: (GUID fromString: '{1718579A-858E-43AB-918C-B24B2794DBE9}')!
HtmlNoSpacingTable comment: ''!
!HtmlNoSpacingTable categoriesForClass!Unclassified! !
!HtmlNoSpacingTable methodsFor!

addBooleanField: fieldName value: fieldValue label: aString 
	self
		addBooleanField: fieldName value: fieldValue;
		nextCell;
		space;
		nextCell;
		add: aString webTranslate;
		nextCell!

addBooleanField: fieldName valueFrom: fieldValue label: aString 
	self
		addBooleanField: fieldName valueFrom: fieldValue;
		nextCell;
		space;
		nextCell;
		add: aString webTranslate;
		nextCell!

addLabel: aString 
	"Adds a label into table. If this is not the first column it will insert a space before label.
	It will use dgLC - dialog label cell - class for the tabel cell with the label.
	It will translate aString before using it and add double colon : after the label."

	super addLabel: aString.
	self
		space;
		nextCell! !
!HtmlNoSpacingTable categoriesFor: #addBooleanField:value:label:!public! !
!HtmlNoSpacingTable categoriesFor: #addBooleanField:valueFrom:label:!public! !
!HtmlNoSpacingTable categoriesFor: #addLabel:!public! !

!HtmlNoSpacingTable class methodsFor!

columns: columns 
	^(super new)
		setColumns: columns;
		cellPadding: 0;
		cellSpacing: 0! !
!HtmlNoSpacingTable class categoriesFor: #columns:!public! !

