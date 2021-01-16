"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Database.DBAbstractRow'
	instanceVariableNames: 'columns contents selectors status'
	classVariableNames: ''
	imports: #(#{OS.ODBCConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
Database.DBAbstractRow guid: (Core.GUID fromString: '{c829ece2-5847-4e24-855e-a9c259dd955f}')!
Database.DBAbstractRow isNonInstantiable: true!
Database.DBAbstractRow comment: 'A DBAbstractRow respresents a row in a <DBResultSet>, either as a buffer containing a collection of field buffers used to receive data from ODBC (subclasses of DBRowBuffer), or as a reified row containing the column values as appropriate types of Smalltalk object (DBRow).

From a DBAbstractRows one can access the column attributes and the actual field data for the columns. The columns can be accessed by name using #at: and by index using #atIndex:. The type of object returned depends on whether the receiver is a buffer (in which case one gets <DBField>s, or a reified <DBRow>, in which case one gets the field values). DBAbstractRows also provide implicit accessor methods for each column by overriding #doesNotUnderstand.

Instance Variables:
	columns		<Array> of <DBColAttr>
	contents		<Array> of <DBField>|<Object>
	selectors		<Dictionary> mapping <Symbol>s to <integer> column indices.
	status		<WORD>|<integer> ODBC row status'!
!Database.DBAbstractRow categoriesForClass!Kernel-Objects! !
!Database.DBAbstractRow methodsFor!

= comparand
	"Answer whether the receiver and the <Object>, comparand, 
	are considered equivalent."

	^comparand species == self species and: [
		self contents = comparand contents]!

asObject
	"Private - Answer the receiver as an instance of DBRow containing the receiver's values."

	^self subclassResponsibility!

at: aString
	"Answer the field named aSymbol from the receiver."

	^self atIndex: (self selectors at: aString)!

at: aString ifAbsent: exceptionHandler
	"Answer the field named aString from the receiver.  If the field is not present,
	answer the result of evaluating the niladic valuable, exceptionHandler."

	^self 
		atIndex: (self selectors at: aString ifAbsent: [^exceptionHandler value])!

at: key ifPresent: operation
	"Answer the result of evaluating the monadic valuable, operation, if
	the argument, key, is the key of an element in the receiver, with that
	element as its argument. If the key is not present, then answer nil."

	^operation value: (self at: key ifAbsent: [^nil])!

at: aString put: anObject
	"Set the field named aSymbol to anObject.
	Answer the argument."

	^self atIndex: (self selectors at: aString) put: anObject!

atIndex: anInteger
	"Answer the field whose column index is anInteger."

	^self contents at: anInteger!

atIndex: anInteger put: anObject
	"Set the field whose column index is anInteger to anObject.	
	Answer the argument."

	^self contents at: anInteger put: anObject!

buildSelectors
	| cols |
	cols := self columns.
	selectors := LookupTable new: cols size.	"* 2"
	cols keysAndValuesDo: 
			[:i :col | 
			| instName |
			instName := col name.
			selectors at: instName put: i
			"selectors at: (instName, ':') put: i"]!

columns
	"Answer an <Array> of <DBColAttr>s describing the columns in this row."

	^columns!

columns: anArrayOfDBColAttr
	columns := anArrayOfDBColAttr
!

contents
	^contents!

doesNotUnderstand: aMessage
	"Private - See if the message selector is one of the field names of the receiver.
	If so, access that field."

	| selector |
	selector := aMessage selector.
	^selector last == $: 
		ifTrue: 
			[self atIndex: (self selectors at: selector allButLast
						ifAbsent: [^super doesNotUnderstand: aMessage])
				put: aMessage arguments first]
		ifFalse: [self at: selector ifAbsent: [super doesNotUnderstand: aMessage]]!

hash
	"Answer the <integer> hash value for the receiver." 

	^self contents hash
!

isDeletedRow
	"Answer whether the receiver represents a row in a result set which has been 
	deleted in the time since the result set was originally queried."

	^self status = SQL_ROW_DELETED!

printOn: aStream
	"Append the ASCII representation of the receiver
	 to aStream."

	aStream
		basicPrint: self;
		nextPut: $(.
	self contents do: [:f | aStream print: f] separatedBy: [aStream space].
	aStream nextPut: $)!

selectors
	"Private - Answer a <LookupTable> mapping the names of fields in the receiver to
	column indices."

	selectors isNil ifTrue: [self buildSelectors].
	^selectors!

status
	^status! !
!Database.DBAbstractRow categoriesFor: #=!comparing!public! !
!Database.DBAbstractRow categoriesFor: #asObject!converting!private! !
!Database.DBAbstractRow categoriesFor: #at:!accessing!public! !
!Database.DBAbstractRow categoriesFor: #at:ifAbsent:!accessing!public! !
!Database.DBAbstractRow categoriesFor: #at:ifPresent:!accessing!public! !
!Database.DBAbstractRow categoriesFor: #at:put:!accessing!public! !
!Database.DBAbstractRow categoriesFor: #atIndex:!accessing!public! !
!Database.DBAbstractRow categoriesFor: #atIndex:put:!accessing!public! !
!Database.DBAbstractRow categoriesFor: #buildSelectors!accessing!private! !
!Database.DBAbstractRow categoriesFor: #columns!accessing!public! !
!Database.DBAbstractRow categoriesFor: #columns:!accessing!private! !
!Database.DBAbstractRow categoriesFor: #contents!accessing!public! !
!Database.DBAbstractRow categoriesFor: #doesNotUnderstand:!exceptions!private! !
!Database.DBAbstractRow categoriesFor: #hash!comparing!public! !
!Database.DBAbstractRow categoriesFor: #isDeletedRow!public!testing! !
!Database.DBAbstractRow categoriesFor: #printOn:!printing!public! !
!Database.DBAbstractRow categoriesFor: #selectors!accessing!private! !
!Database.DBAbstractRow categoriesFor: #status!accessing!private! !

